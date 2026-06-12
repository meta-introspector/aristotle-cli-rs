#!/bin/bash

# Debug script for aristotle result

set -x  # Enable debugging

# Test with one ID
ID="9c2a5244-5558-4e36-9e63-9f8f014b2461"
echo "Testing with ID: $ID"

# Create temp directory
TMPDIR=$(mktemp -d)
echo "Temp dir: $TMPDIR"
cd "$TMPDIR"

# Run aristotle result
echo "Running: aristotle result --wait $ID"
OUTPUT=$(aristotle result --wait "$ID" 2>&1)
echo "Output: $OUTPUT"

# Check what files were created
echo "Files in $TMPDIR:"
ls -la

# Check for tarball
TARBALL="${ID}-aristotle.tar.gz"
if [ -f "$TARBALL" ]; then
    echo "Found tarball: $TARBALL"
    # Try to extract
    if tar -xzf "$TARBALL"; then
        echo "Extraction successful"
        ls -la
        # Check for extracted directory
        DIRS=($(find . -maxdepth 1 -type d ! -name . ! -name ..))
        echo "Directories found: ${DIRS[@]}"
        if [ ${#DIRS[@]} -gt 0 ]; then
            echo "Trying to build in ${DIRS[0]}"
            cd "${DIRS[0]}" && lake build 2>&1 | head -20
        fi
    else
        echo "Extraction failed"
    fi
else
    echo "Tarball not found"
fi

# Cleanup
cd /
rm -rf "$TMPDIR"