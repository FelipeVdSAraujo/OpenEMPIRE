from argparse import ArgumentParser
from pathlib import Path

from empire.core.config import EmpireConfiguration, read_config_file
from empire.core.model_runner import run_empire_model, setup_run_paths
from empire.input_client.client import EmpireInputClient
from empire.logger import get_empire_logger

parser = ArgumentParser(description="A CLI script to run the Empire model.")

parser.add_argument("-t", "--test-run", help="Test run without optimization", action="store_true")
parser.add_argument(
    "-d",
    "--dataset",
    help="Specify the required dataset",
    default="europe_v51",
)
parser.add_argument("-f", "--force", help="Force new run if old exist.", action="store_true")
parser.add_argument("-c", "--config-file", help="Path to config file.", default="config/run.yaml")
parser.add_argument(
    "--dataset-path",
    help="Optional explicit dataset folder path. If provided, this overrides -d/--dataset for input files.",
    default=None,
)
parser.add_argument(
    "-n",
    "--name",
    help="name of run",
    default="Unnamed_run"
)

args = parser.parse_args()

## Read config and setup folders ##
if args.dataset == "test":
    config = read_config_file(Path("config/testrun.yaml"))
    run_path = Path.cwd() / f"Results/basic_run/dataset_{args.dataset}"

elif args.dataset =="uploads":
    config = read_config_file(Path("config/ensolve_run.yaml"))#if we run the ensolve run, use this config
    #change path if we run an ensolve run
    run_path = Path.cwd() / f"Results/run_analysis/ensolve_{args.name}"
else:
    config = read_config_file(Path(args.config_file))
    run_path = Path.cwd() / f"Results/v51/ensolve_{args.name}"

empire_config = EmpireConfiguration.from_dict(config=config)

dataset_path_override = None
if args.dataset_path:
    dataset_path_override = Path(args.dataset_path)
    if not dataset_path_override.is_absolute():
        dataset_path_override = (Path.cwd() / dataset_path_override).resolve()
    if not dataset_path_override.exists():
        raise ValueError(f"Dataset path does not exist: {dataset_path_override}")




if (run_path / "Output/results_objective.csv").exists() and not args.force:
    raise ValueError("There already exists results for this analysis run.")

run_config = setup_run_paths(
    version=args.dataset,
    empire_config=empire_config,
    run_path=run_path,
    base_dataset_path=dataset_path_override,
)
logger = get_empire_logger(run_config=run_config)

logger.info("Running EMPIRE Model")

client = EmpireInputClient(dataset_path=run_config.dataset_path)

data_managers = [
    # Add input data managers to alter the dataset
]

## Run empire model
run_empire_model(
    empire_config=empire_config, run_config=run_config, data_managers=data_managers, test_run=args.test_run
)