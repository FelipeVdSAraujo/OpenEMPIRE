#!/bin/bash
# This script submits a single test job

# Define parameter values
name=$1

AVAILABLE_NODES=$(./scripts/filter_idle_hosts.sh "compute-4-50|compute-4-51|compute-4-52|compute-4-53|compute-4-54|compute-4-55|compute-4-56|compute-4-57|compute-4-58")

mkdir -p ./hpc_output/

# Submit a single job
qsub \
    -V \
    -cwd \
    -N ensolve_run_${name} \
    -o ./hpc_output/ \
    -e ./hpc_output/ \
    -l h_rt=12:00:00 \
    -l mem_free=150G \
    -l hostname="$AVAILABLE_NODES" \
    -pe smp 8 \
    ./scripts/ensolve_worker.sh $name