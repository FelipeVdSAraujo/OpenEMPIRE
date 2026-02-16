#!/bin/bash
set -x
ncc=$1
na=$2
w=$3
p=$4



# Check if empire_env is the active environment
if [[ "$CONDA_DEFAULT_ENV" != "empire_env" ]]; then
    # Check if empire_env exists among the installed environments
    conda info --envs | grep -q "empire_env"
    if [ $? -eq 0 ]; then
        echo "Activating existing conda environment: empire_env"
        source ~/miniconda3/bin/activate empire_env
    else
        echo "Creating new conda environment: empire_env"
        conda env create -f ./environment.yml
        source ~/miniconda3/bin/activate empire_env
    fi
fi

echo "Active conda env: "
echo $CONDA_DEFAULT_ENV
# Load modules and activate conda environment
module load gurobi/9.5
echo "testing gurobi"
pyomo help --version
# Print which node we are running on
echo "Running on compute node: $(hostname)"

python scripts/run.py -d test


echo "Done with starting bash script!"