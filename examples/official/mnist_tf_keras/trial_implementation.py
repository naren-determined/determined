"""
This example demonstrates training a simple CNN with tf.keras using the Determined
Native API.
"""
import argparse
import json
import pathlib

import determined as det

import model_def


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--config",
        dest="config",
        help="Specifies Determined Experiment configuration.",
        default="{}",
    )
    parser.add_argument(
        "--mode", dest="mode", help="Specifies test mode or submit mode.", default="submit"
    )
    args = parser.parse_args()
    config = json.loads(args.config)
    config["hyperparameters"] = {
        "global_batch_size": det.Constant(value=32),
        "kernel_size": det.Constant(value=3),
        "dropout": det.Double(minval=0.0, maxval=0.5),
        "activation": det.Constant(value="relu"),
    }

    det.create(
        trial_def=model_def.MNISTTrial,
        config=config,
        mode=det.Mode(args.mode),
        context_dir=str(pathlib.Path.cwd()),
    )
