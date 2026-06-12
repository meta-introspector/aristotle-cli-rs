#!/bin/bash

# poll-results.sh - Fetch new results from Aristotle and test them

# Set up
source ~/.bashrc  # Ensure ARISTOTLE_API_KEY is loaded
BASE_DIR="/home/mdupont/05/07/arist"
RESULTS_DIR="$HOME/projects/aristotle_results/"
PROCESSED_FILE="$BASE_DIR/aristotle_processed.txt"
LOG_FILE="$BASE_DIR/aristotle_poll.log"

mkdir -p "$RESULTS_DIR"
touch "$PROCESSED_FILE"

echo "[$(date)] Starting Aristotle result poll" >> "$LOG_FILE"

# Get list of recent projects from Aristotle
# Skip header lines and separator
MAPFILE=($(aristotle list | tail -n +4))  # Skip first 3 lines (pagination key, header, separator)
# Each line: ID STATUS CREATED PROGRESS
# We'll extract the first field (UUID)
IDS=()
for line in "${MAPFILE[@]}"; do
    # Check if line looks like a UUID (starts with alphanum and has hyphens)
    if [[ $line =~ ^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12} ]]; then
        IDS+=($(echo "$line" | awk '{print $1}'))
    fi
done

echo "[$(date)] Found ${#IDS[@]} recent projects" >> "$LOG_FILE"

# Process each ID
for ID in "${IDS[@]}"; do
    echo processing $ID
    if grep -q "^$ID$" "$PROCESSED_FILE"; then
        echo "[$(date)] NOT Skipping already processed ID: $ID" >> "$LOG_FILE"
        #continue
    fi

    echo "[$(date)] Processing new result ID: $ID" >> "$LOG_FILE"
    
    # Create a temporary directory for this result
    TMPDIR=$(mktemp -d)
    echo "[$(date)] Using temporary directory: $TMPDIR" >> "$LOG_FILE"
    
    cd "$TMPDIR"
    
    # Wait for result and download (saves as <ID>-aristotle.tar.gz in current directory)
    if aristotle download "$ID" >> "$LOG_FILE" 2>&1; then
        echo "[$(date)] Download command completed for $ID" >> "$LOG_FILE"
        
        # Check if the tarball was created
        TARBALL="${ID}-aristotle.tar.gz"
        if [ -f "$TARBALL" ]; then
            echo "[$(date)] Found tarball: $TARBALL" >> "$LOG_FILE"
            
            # Extract the tarball
            if tar -xzf "$TARBALL" >> "$LOG_FILE" 2>&1; then
                echo "[$(date)] Extracted tarball for $ID" >> "$LOG_FILE"
                
                # The extracted directory is likely named <ID>_aristotle (based on the tarball name)
                # But let's check what was extracted
                # Look for directories in the current directory (excluding . and ..)
                DIRS=($(find . -maxdepth 1 -type d ! -name . ! -name ..))
                if [ ${#DIRS[@]} -eq 0 ]; then
                    # No subdirectories, maybe the tarball extracted files directly?
                    EXTRACTED_DIR="."
                elif [ ${#DIRS[@]} -eq 1 ]; then
                    EXTRACTED_DIR="${DIRS[0]}"
                else
                    # Multiple directories, try to find one that matches the ID or is likely the project
                    # We'll just use the first one for now, but log the situation
                    echo "[$(date)] Warning: Multiple directories extracted, using first: ${DIRS[0]}" >> "$LOG_FILE"
                    EXTRACTED_DIR="${DIRS[0]}"
                fi
                
                echo "[$(date)] Checking project in: $EXTRACTED_DIR" >> "$LOG_FILE"
                
                # Try to build the project
#                if cd "$EXTRACTED_DIR" && lake build >> "$LOG_FILE" 2>&1; then
#                    echo "[$(date)] SUCCESS: Built $ID" >> "$LOG_FILE"
#                    RESULT="SUCCESS"
#                else
#                    echo "[$(date)] FAILED: Build error for $ID" >> "$LOG_FILE"
#                    RESULT="FAILED"
#                fi
            else
                echo "[$(date)] FAILED: Could not extract tarball for $ID" >> "$LOG_FILE"
                RESULT="EXTRACTION_FAILED"
            fi
        else
            echo "[$(date)] FAILED: Tarball not found for $ID" >> "$LOG_FILE"
            RESULT="DOWNLOAD_FAILED"
        fi
    else
        echo "[$(date)] FAILED: Could not download result for $ID" >> "$LOG_FILE"
        RESULT="DOWNLOAD_FAILED"
    fi

    # Clean up temporary directory
    cd /
    rm -rf "$TMPDIR"
    
    # Record as processed
    echo "$ID" >> "$PROCESSED_FILE"
    echo "[$(date)] Finished processing $ID with result: $RESULT" >> "$LOG_FILE"
done

echo "[$(date)] Poll finished" >> "$LOG_FILE"
echo "Poll complete. See $LOG_FILE for details."
