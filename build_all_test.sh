#!/bin/bash

# Script to build all Lean4 projects in /home/mdupont/05/07/arist using lake build

BASE_DIR="/home/mdupont/05/07/arist"
RESULT_FILE="$BASE_DIR/result.txt"
SUCCESS=0
FAIL=0

echo "Building all Lean4 projects in $BASE_DIR..."

# Find all directories ending with _aristotle
for dir in "$BASE_DIR"/*_aristotle; do
    if [ -d "$dir" ]; then
        PROJECT_NAME=$(basename "$dir")
        echo "Building $PROJECT_NAME..."
        cd "$dir"
        if [ -f lakefile.toml ]; then
            if lake build; then
                echo "✓ $PROJECT_NAME succeeded"
                ((SUCCESS++))
            else
                echo "✗ $PROJECT_NAME failed"
                ((FAIL++))
            fi
        else
            echo "? $PROJECT_NAME - no lakefile.toml"
            ((FAIL++))
        fi
        cd - > /dev/null
    fi
        break
done

echo "----------------------------------------"
echo "Total: $SUCCESS succeeded, $FAIL failed"
echo "Total: $SUCCESS succeeded, $FAIL failed" > "$RESULT_FILE"