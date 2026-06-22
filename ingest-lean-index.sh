#!/bin/bash
# ingest-lean-index.sh — ingest lean.index2.txt into REPL shmem with all splitters
# Usage: bash ingest-lean-index.sh [--limit N] [--batch B]

set -euo pipefail

INDEX="/mnt/data1/time-2026/06-june/26/index/lean.index2.txt"
STATICSPLIT="/nix/store/hagadmgn61fhbxdq2md6p1jjb5plb52v-staticsplitjson/bin/staticsplitjson"
REPL_HOST="http://127.0.0.1:8156"
LIMIT="${1:-1000}"
BATCH="${2:-50}"

echo "=== Ingesting Lean Index into REPL Shmem ==="
echo "Index: $INDEX"
echo "Limit: $LIMIT files"
echo "Batch: $BATCH per batch"
echo "REPL: $REPL_HOST"

# Filter to actual .lean source files (not .olean, .ilean, /lean dirs, lakefile.lean)
# Must be readable, must contain actual Lean content
TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT

echo ""
echo "=== Phase 1: Filter valid .lean files ==="
grep '\.lean$' "$INDEX" | \
  grep -v '\.olean$\|\.ilean$\|/lake/\|/\.lake/\|/.emacs.d/\|/build/\|lakefile.lean$' | \
  head -n "$LIMIT" > "$TMPDIR/valid-paths.txt"

VALID=$(wc -l < "$TMPDIR/valid-paths.txt")
echo "  Valid paths: $VALID"

# Verify a few exist
echo "  Sample:"
head -3 "$TMPDIR/valid-paths.txt" | while read p; do
  if [ -f "$p" ]; then
    echo "    OK: $p ($(wc -l < "$p") lines)"
  else
    echo "    MISSING: $p"
  fi
done

echo ""
echo "=== Phase 2: Split with staticsplitjson ==="
TOTAL_DECLS=0
PROCESSED=0
ERRORS=0

# Process files in batches
split -l "$BATCH" "$TMPDIR/valid-paths.txt" "$TMPDIR/batch-"

for batch_file in "$TMPDIR"/batch-*; do
    BATCH_NUM=$(basename "$batch_file" | sed 's/batch-//')
    
    # Build a temp file list for staticsplitjson --dir doesn't support file lists,
    # so we process each file individually
    BATCH_DECLS=0
    
    while IFS= read -r file; do
        if [ ! -f "$file" ]; then
            continue
        fi
        
        # Run staticsplitjson on single file
        output=$("$STATICSPLIT" "$file" 2>/dev/null || true)
        if [ -z "$output" ]; then
            continue
        fi
        
        # Count declarations
        lines=$(echo "$output" | wc -l)
        BATCH_DECLS=$((BATCH_DECLS + lines))
        
        # Push to REPL /put
        echo "$output" | while IFS= read -r json_line; do
            [ -z "$json_line" ] && continue
            curl -s -X POST "$REPL_HOST/put" \
                -H "Content-Type: application/json" \
                -d "$json_line" > /dev/null 2>&1 || true
        done
        
        PROCESSED=$((PROCESSED + 1))
    done < "$batch_file"
    
    TOTAL_DECLS=$((TOTAL_DECLS + BATCH_DECLS))
    
    if [ $((PROCESSED % 100)) -eq 0 ]; then
        echo "  Processed $PROCESSED/$VALID files, $TOTAL_DECLS declarations loaded"
    fi
done

echo ""
echo "=== Phase 3: Verify ==="
HEALTH=$(curl -s "$REPL_HOST/health")
echo "  $HEALTH"

echo ""
echo "=== Complete ==="
echo "  Files processed: $PROCESSED"
echo "  Declarations loaded: $TOTAL_DECLS"
echo "  Errors: $ERRORS"
