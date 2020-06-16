package searcher

import (
	"fmt"
	"math"

	"github.com/determined-ai/determined/master/pkg/model"
	"github.com/determined-ai/determined/master/pkg/nprand"
)

type hparamSample map[string]interface{}

func sampleAll(h model.Hyperparameters, rand *nprand.State) hparamSample {
	results := make(hparamSample)
	h.Each(func(name string, param model.Hyperparameter) {
		results[name] = sampleOne(param, rand)
	})
	return results
}

func sampleOne(h model.Hyperparameter, rand *nprand.State) interface{} {
	switch {
	case h.ConstHyperparameter != nil:
		p := h.ConstHyperparameter
		return p.Val
	case h.IntHyperparameter != nil:
		p := h.IntHyperparameter
		return p.Minval + rand.Intn(p.Maxval-p.Minval)
	case h.DoubleHyperparameter != nil:
		p := h.DoubleHyperparameter
		return rand.Uniform(p.Minval, p.Maxval)
	case h.LogHyperparameter != nil:
		p := h.LogHyperparameter
		return math.Pow(p.Base, rand.Uniform(p.Minval, p.Maxval))
	case h.CategoricalHyperparameter != nil:
		p := h.CategoricalHyperparameter
		return p.Vals[rand.Intn(len(p.Vals))]
	case h.NestedHyperparameter != nil:
        p := h.NestedHyperparameter
        m := make(map[string]interface{})
        for key, value := range p.Vals {
            m[key] = sampleOne(value, rand)
        }
        return m
	default:
		panic(fmt.Sprintf("unexpected hyperparameter type: %+v", h))
	}
}

func intClamp(val, minval, maxval int) int {
	switch {
	case val < minval:
		return minval
	case val > maxval:
		return maxval
	default:
		return val
	}
}

func doubleClamp(val, minval, maxval float64) float64 {
	switch {
	case val < minval:
		return minval
	case val > maxval:
		return maxval
	default:
		return val
	}
}
