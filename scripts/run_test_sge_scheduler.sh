#!/bin/bash
# This script submits a single test job

# Define parameter values
ncc="4000"
na="0.95"
w="200000"
p="true"

mkdir -p ./hpc_output/

# Submit a single job
qsub \
    -V \
    -cwd \
    -N empire_test_run_${ncc}_${na}_${w}_${p} \
    -o ./hpc_output/ \
    -e ./hpc_output/ \
    -l h_rt=12:00:00 \
    -l mem_free=150G \
    -pe smp 8 \
    ./scripts/run_test_sge_worker.sh $ncc $na $w $p
