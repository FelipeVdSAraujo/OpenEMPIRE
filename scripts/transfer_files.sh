#!/bin/bash

set -x
export PATH="/usr/bin:$PATH"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOCAL_DIR="$SCRIPT_DIR/.."
RESULTS_DIR="$LOCAL_DIR/Results/run_analysis"
REMOTE_DIR="Documents/Empire/OpenEMPIRE/Results"  # Check if needs cygdrive

echo "Checking local source directory: $RESULTS_DIR"
if [ ! -d "$RESULTS_DIR" ]; then
    echo "ERROR: Local results directory does not exist: $RESULTS_DIR"
    exit 10
fi

echo "Transferring files from: $RESULTS_DIR"
echo "To: marttih@NTNU00707.win.ntnu.no:$REMOTE_DIR"

which rsync

# Use scp instead of rsync
scp -i ~/.ssh/id_rsa -r "$RESULTS_DIR/" "marttih@NTNU00707.win.ntnu.no:$REMOTE_DIR/" || {
    echo "SCP failed with exit code $?"
    exit 11
}

echo "SCP completed successfully."
exit 0
