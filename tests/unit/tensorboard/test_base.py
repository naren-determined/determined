import pathlib

import pytest

from determined import tensorboard
from determined.tensorboard import SharedFSTensorboardManager
from tests.unit.tensorboard import test_util

CONTAINER_PATH = pathlib.Path(__file__).resolve().parent.joinpath("test_tensorboard")
BASE_PATH = pathlib.Path(__file__).resolve().parent.joinpath("fixtures")


def test_getting_manager_instance(tmp_path: pathlib.Path) -> None:
    checkpoint_config = {"type": "shared_fs", "container_path": tmp_path}
    manager = tensorboard.build(test_util.get_dummy_env(), checkpoint_config)
    assert isinstance(manager, SharedFSTensorboardManager)


def test_setting_optional_variable(tmp_path: pathlib.Path) -> None:
    checkpoint_config = {"type": "shared_fs", "base_path": "test_value", "container_path": tmp_path}
    manager = tensorboard.build(test_util.get_dummy_env(), checkpoint_config)
    assert isinstance(manager, SharedFSTensorboardManager)
    assert manager.base_path == pathlib.Path("test_value/tensorboard")


def test_unknown_type() -> None:
    checkpoint_config = {"type": "unknown", "container_path": CONTAINER_PATH}
    with pytest.raises(TypeError, match="Unknown storage type: unknown"):
        tensorboard.build(test_util.get_dummy_env(), checkpoint_config)


def test_missing_type() -> None:
    with pytest.raises(TypeError, match="Missing 'type' parameter"):
        tensorboard.build(test_util.get_dummy_env(), {})


def test_illegal_type() -> None:
    checkpoint_config = {"type": 4}
    with pytest.raises(TypeError, match="must be a string"):
        tensorboard.build(test_util.get_dummy_env(), checkpoint_config)


def test_list_directory(tmp_path: pathlib.Path) -> None:
    checkpoint_config = {"type": "shared_fs", "base_path": BASE_PATH, "container_path": tmp_path}
    manager = tensorboard.build(test_util.get_dummy_env(), checkpoint_config)

    full_event_path = BASE_PATH.joinpath("tensorboard", "events.out.tfevents.example")

    assert set(manager.list_tfevents()) == {full_event_path}


def test_list_nonexistent_directory(tmp_path: pathlib.Path) -> None:
    base_path = "/non-existent-directory"
    checkpoint_config = {"type": "shared_fs", "base_path": base_path, "container_path": tmp_path}

    manager = tensorboard.build(test_util.get_dummy_env(), checkpoint_config)
    assert not pathlib.Path(base_path).exists()
    assert manager.list_tfevents() == []
