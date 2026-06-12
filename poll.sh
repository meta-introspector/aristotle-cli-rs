#!/bin/bash

# poll.sh - Pull latest changes for all Lean4 projects and build them
# Usage: ./poll.sh

BASE_DIR="/home/mdupont/05/07/arist"
LOG_FILE="$BASE_DIR/poll.log"
RESULT_FILE="$BASE_DIR/result.txt"

echo "[$(date)] Starting poll: pulling updates and building projects" >> "$LOG_FILE"

# Update each project if it's a git repo
for dir in "$BASE_DIR"/*_aristotle; do
    if [ -d "$dir" ]; then
        PROJECT_NAME=$(basename "$dir")
        echo "[$(date)] Checking $PROJECT_NAME for git updates..." >> "$LOG_FILE"
        cd "$dir"
        if [ -d .git ]; then
            echo "[$(date)] Pulling latest changes for $PROJECT_NAME" >> "$LOG_FILE"
            git pull >> "$LOG_FILE" 2>&1
        else
            echo "[$(date)] $PROJECT_NAME is not a git repository" >> "$LOG_FILE"
        fi
        cd - > /dev/null
    fi
done

# Run the build
echo "[$(date)] Starting build of all projects..." >> "$LOG_FILE"
./build_all.sh >> "$LOG_FILE" 2>&1

# Show the result
echo "[$(date)] Build completed. Results:" >> "$LOG_FILE"
cat "$RESULT_FILE" >> "$LOG_FILE" 2>/dev/null || echo "No result file found" >> "$LOG_FILE"

echo "[$(date)] Poll finished." >> "$LOG_FILE"
echo "Poll completed. See $LOG_FILE for details."