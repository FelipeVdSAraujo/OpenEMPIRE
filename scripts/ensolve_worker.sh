#!/bin/bash
set -x
name=$1
dataset=${2:-uploads}
dataset_path=$3

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
config_file=${4:-"$REPO_ROOT/config/ensolve_run.yaml"}
cd "$REPO_ROOT"

# Check if empire_env is the active environment
if [[ "$CONDA_DEFAULT_ENV" != "empire_env" ]]; then
    conda info --envs | grep -q "empire_env"
    if [ $? -eq 0 ]; then
        echo "Activating existing conda environment: empire_env"
        CONDA_BASE=$(cd "$(dirname "$(command -v conda)")/.." && pwd)
        # shellcheck disable=SC1091
        source "$CONDA_BASE/etc/profile.d/conda.sh"
        conda activate empire_env
    else
        echo "Creating new conda environment: empire_env"
        conda env create -f "$REPO_ROOT/environment.yml"
        CONDA_BASE=$(cd "$(dirname "$(command -v conda)")/.." && pwd)
        # shellcheck disable=SC1091
        source "$CONDA_BASE/etc/profile.d/conda.sh"
        conda activate empire_env
    fi
fi

if [ -z "$name" ]; then
  echo "Usage: $0 <run_name>"
  exit 1
fi

echo "Active conda env: "
echo "$CONDA_DEFAULT_ENV"

# Load modules if available (HPC environments)
if command -v module >/dev/null 2>&1; then
    module load gurobi/9.5
else
    echo "module command not available; skipping module load"
fi

echo "testing gurobi"
if command -v pyomo >/dev/null 2>&1; then
    pyomo help --version
else
    echo "pyomo not found in PATH"
fi

# Print which node we are running on
echo "Running on compute node: $(hostname)"

run_cmd=(python "$REPO_ROOT/scripts/run.py" -n "$name" -d "$dataset" -c "$config_file")

if [ -n "$dataset_path" ]; then
    run_cmd+=(--dataset-path "$dataset_path")
fi

"${run_cmd[@]}"

echo "Finished model execution script!"