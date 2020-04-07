package scheduler

import (
	"fmt"
	"math/rand"
	"testing"

	"github.com/docker/docker/api/types"
	docker "github.com/docker/docker/api/types/container"
	"github.com/pkg/errors"
	"gotest.tools/assert"

	"github.com/determined-ai/determined/master/pkg/actor"
	"github.com/determined-ai/determined/master/pkg/agent"
	cproto "github.com/determined-ai/determined/master/pkg/container"
)

var errMock = errors.New("mock error")

type mockActor struct {
	system             *actor.System
	cluster            *actor.Ref
	onAssigned         func(Assigned) error
	onContainerStarted func(ContainerStarted) error
	onTaskTerminated   func(TaskTerminated) error
}

type (
	AskSchedulerToAddTask struct {
		task AddTask
	}
	ThrowError struct{}
	ThrowPanic struct{}
)

func (h *mockActor) Receive(ctx *actor.Context) error {
	switch msg := ctx.Message().(type) {
	case AskSchedulerToAddTask:
		if ctx.ExpectingResponse() {
			ctx.Respond(ctx.Ask(h.cluster, msg.task).Get())
		} else {
			ctx.Tell(h.cluster, msg.task)
		}

	case ThrowError:
		return errMock

	case ThrowPanic:
		panic(errMock)

	case Assigned:
		if h.onAssigned != nil {
			return h.onAssigned(msg)
		}

		h.system.Tell(h.cluster, agent.ContainerStateChanged{
			Container: cproto.Container{
				ID:    cproto.ID(msg.container.id),
				State: cproto.Running,
			},
			ContainerStarted: &agent.ContainerStarted{
				ContainerInfo: types.ContainerJSON{
					ContainerJSONBase: &types.ContainerJSONBase{
						HostConfig: &docker.HostConfig{
							NetworkMode: "bridge",
						},
					},
				},
			},
		})

	case ContainerStarted:
		if h.onContainerStarted != nil {
			return h.onContainerStarted(msg)
		}
		h.system.Tell(h.cluster, agent.ContainerStateChanged{
			Container: cproto.Container{
				ID:    cproto.ID(msg.Container.ID()),
				State: cproto.Terminated,
			},
			ContainerStopped: &agent.ContainerStopped{},
		})

	case TaskTerminated:
		if h.onTaskTerminated != nil {
			return h.onTaskTerminated(msg)
		}

	default:
		return actor.ErrUnexpectedMessage(ctx)
	}
	return nil
}

func TestCleanUpTaskWhenTaskActorStopsWithError(t *testing.T) {
	system := actor.NewSystem(t.Name())
	agents := []*agentState{newMockAgent(t, system, "agent", 1, "")}
	c := setupCluster(NewFairShareScheduler(), BestFit, agents, nil)
	c.saveNotifications = true
	cluster, created := system.ActorOf(actor.Addr("scheduler"), c)
	assert.Assert(t, created)
	mockActor, created := system.ActorOf(
		actor.Addr("mockActor"),
		&mockActor{
			cluster: cluster,
			system:  system,
			onContainerStarted: func(ContainerStarted) error {
				return nil
			},
		},
	)
	assert.Assert(t, created)
	taskID := NewTaskID()

	system.Ask(mockActor, AskSchedulerToAddTask{
		task: AddTask{
			ID:           &taskID,
			Name:         "mock_task",
			Group:        mockActor,
			SlotsNeeded:  1,
			CanTerminate: true,
		},
	}).Get()
	assert.Equal(t, len(c.tasksByHandler), 1)

	system.Ask(mockActor, ThrowError{})
	assert.ErrorType(t, mockActor.StopAndAwaitTermination(), errMock)

	for _, c := range c.notifications {
		<-c
	}

	assert.NilError(t, cluster.StopAndAwaitTermination())
	assert.Equal(t, len(c.tasksByHandler), 0)
}

func TestCleanUpTaskWhenTaskActorPanics(t *testing.T) {
	system := actor.NewSystem(t.Name())
	agents := []*agentState{newMockAgent(t, system, "agent", 1, "")}
	c := setupCluster(NewFairShareScheduler(), BestFit, agents, nil)
	c.saveNotifications = true
	cluster, created := system.ActorOf(actor.Addr("scheduler"), c)
	assert.Assert(t, created)
	mockActor, created := system.ActorOf(
		actor.Addr("mockActor"),
		&mockActor{
			cluster: cluster,
			system:  system,
			onContainerStarted: func(ContainerStarted) error {
				return nil
			},
		},
	)
	assert.Assert(t, created)

	taskID := NewTaskID()
	system.Ask(mockActor, AskSchedulerToAddTask{
		task: AddTask{
			ID:           &taskID,
			Name:         "mock_task",
			Group:        mockActor,
			SlotsNeeded:  1,
			CanTerminate: true,
		},
	}).Get()

	assert.Equal(t, len(c.tasksByHandler), 1)
	system.Ask(mockActor, ThrowPanic{})
	assert.ErrorType(t, mockActor.StopAndAwaitTermination(), errMock)

	for _, c := range c.notifications {
		<-c
	}

	assert.NilError(t, cluster.StopAndAwaitTermination())
	assert.Equal(t, len(c.tasksByHandler), 0)
}

func TestCleanUpTaskWhenTaskActorStopsNormally(t *testing.T) {
	system := actor.NewSystem(t.Name())
	agents := []*agentState{newMockAgent(t, system, "agent", 1, "")}
	c := setupCluster(NewFairShareScheduler(), BestFit, agents, nil)
	c.saveNotifications = true
	cluster, created := system.ActorOf(actor.Addr("scheduler"), c)
	assert.Assert(t, created)

	mockActor, created := system.ActorOf(
		actor.Addr("mockActor"),
		&mockActor{
			cluster: cluster,
			system:  system,
			onContainerStarted: func(ContainerStarted) error {
				return nil
			},
		},
	)
	assert.Assert(t, created)

	taskID := NewTaskID()
	system.Ask(mockActor, AskSchedulerToAddTask{
		task: AddTask{
			ID:           &taskID,
			Name:         "mock_task",
			Group:        mockActor,
			SlotsNeeded:  1,
			CanTerminate: true,
		},
	}).Get()

	assert.Equal(t, len(c.tasksByHandler), 1)

	assert.NilError(t, mockActor.StopAndAwaitTermination())

	for _, c := range c.notifications {
		<-c
	}

	assert.NilError(t, cluster.StopAndAwaitTermination())
	assert.Equal(t, len(c.tasksByHandler), 0)
}

func testWhenActorsStopOrTaskIsKilled(t *testing.T, r *rand.Rand) {
	system := actor.NewSystem(t.Name())
	agents := []*agentState{newMockAgent(t, system, fmt.Sprintf("agent-%d", r.Int()), 1, "")}
	c := setupCluster(NewFairShareScheduler(), BestFit, agents, nil)
	cluster, created := system.ActorOf(actor.Addr("scheduler"), c)
	assert.Assert(t, created)

	mockActor, created := system.ActorOf(
		actor.Addr("mockActor"),
		&mockActor{
			cluster: cluster,
			system:  system,
		})
	assert.Assert(t, created)

	taskID := NewTaskID()
	system.Ask(mockActor, AskSchedulerToAddTask{
		task: AddTask{
			ID:           &taskID,
			Name:         "mock_task",
			Group:        mockActor,
			SlotsNeeded:  1,
			CanTerminate: true,
		},
	}).Get()

	actions := []func(){
		func() {
			system.Tell(cluster, taskStopped{
				Ref: mockActor,
			})
		},
		func() {
			system.Tell(cluster, TerminateTask{
				TaskID:   taskID,
				Forcible: false,
			})
		},
		func() {
			system.Tell(cluster, RemoveAgent{
				Agent: agents[0].handler,
			})
		},
	}

	r.Shuffle(len(actions), func(i, j int) {
		actions[i], actions[j] = actions[j], actions[i]
	})

	for _, fn := range actions {
		fn()
	}

	assert.NilError(t, cluster.StopAndAwaitTermination())
	assert.Equal(t, len(c.tasksByHandler), 0)
}

func TestCleanUpTaskWhenActorsStopOrTaskIsKilled(t *testing.T) {
	r := rand.New(rand.NewSource(0))

	// When the actor messages are actually processed is non-deterministic,
	// re-run this test a couple times to ensure interesting interleavings.
	for i := 0; i < 10; i++ {
		testWhenActorsStopOrTaskIsKilled(t, r)
	}
}
