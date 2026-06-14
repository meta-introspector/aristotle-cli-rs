#!/usr/bin/env bash
set -e

# This script runs the 'notebooklm' command for all downloaded Aristotle projects.

# Navigate to the aristotle-manager project directory
cd /mnt/data1/time-2026/05-may/07/arist

echo "--- Building aristotle-manager (if needed)... ---"
cargo build --release

echo "--- Processing all Aristotle projects for NotebookLM export... ---"

# Find all project directories (ending in _aristotle) and iterate
for project_dir in *_aristotle/; do
    # Check if it's a directory
    if [ -d "$project_dir" ]; then
        # Remove trailing slash for cleaner output
        project_name="${project_dir%/}"
        
        echo "--- Processing project: $project_name ---"
        
        # Run the notebooklm command
        # We use the release build for better performance
        ./target/release/aristotle-manager notebooklm --project-dir "$project_name"
    fi
done

echo "--- All projects processed. ---"
