#!/bin/bash

# Base path of project (relative)
BASE_DIR="$(dirname "$0")/.."

# Results path
RESULTS_DIR="$BASE_DIR/results"

# Destination
DEST_USER="marttih"
DEST_HOST="server.example.com"
DEST_PATH="/home/youruser/empire_backup/results"

# Sync only new/changed files
rsync -av --progress "$RESULTS_DIR/" "$DEST_USER@$DEST_HOST:$DEST_PATH"




