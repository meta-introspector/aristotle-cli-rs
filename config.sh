#!/bin/bash
# Configuration file for Aristotle polling and build scripts
# Modify these variables to adapt to your environment

# Base directory where all aristotle projects are stored
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Directory to store result downloads
RESULTS_DIR="$HOME/projects/aristotle_results"

# Log files
POLL_LOG="$BASE_DIR/poll.log"
ARISTOTLE_POLL_LOG="$BASE_DIR/aristotle_poll.log"
BUILD_LOG="$BASE_DIR/build.log"

# Processed file to track already processed IDs
PROCESSED_FILE="$BASE_DIR/aristotle_processed.txt"

# Result file for build summary
RESULT_FILE="$BASE_DIR/result.txt"

# Maximum number of parallel downloads (0 = unlimited)
MAX_PARALLEL_DOWNLOADS=4

# Wait time between retries (seconds)
RETRY_WAIT=10

# Maximum retry attempts
MAX_RETRIES=3

# Git configuration
GIT_BASE="$HOME/05/07/arist"

# Email for notifications (optional)
NOTIFICATION_EMAIL=""

# Slack webhook URL for notifications (optional)
SLACK_WEBHOOK=""

# Function to validate configuration
validate_config() {
    # Ensure directories exist
    mkdir -p "$RESULTS_DIR"
    mkdir -p "$(dirname "$POLL_LOG")"
    mkdir -p "$(dirname "$ARISTOTLE_POLL_LOG")"
    
    # Create processed file if it doesn't exist
    touch "$PROCESSED_FILE"
    
    # Check if aristotle CLI is available
    if ! command -v aristotle &> /dev/null; then
        echo "WARNING: 'aristotle' command not found in PATH"
        echo "Please ensure the aristotle CLI is installed and in your PATH"
    fi
    
    echo "Configuration validated successfully"
}

# Export variables for use by other scripts
export BASE_DIR
 export RESULTS_DIR
export POLL_LOG
export ARISTOTLE_POLL_LOG
export BUILD_LOG
export PROCESSED_FILE
export RESULT_FILE
export GIT_BASE
export MAX_PARALLEL_DOWNLOADS
export RETRY_WAIT
export MAX_RETRIES
export NOTIFICATION_EMAIL
export SLACK_WEBHOOK
