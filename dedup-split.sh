#!/usr/bin/env bash
# dedup-split.sh — Deduplicate split declarations into a unified mathlib-split
set -euo pipefail

SPLIT_DIR="${1:-aristotles_results/split-results}"
OUT_DIR="${2:-aristotles_results/mathlib-split}"

echo "=== Deduplicating $SPLIT_DIR -> $OUT_DIR ==="
rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

# Track which decls we've seen and from which project
declare -A SEEN
declare -A SOURCES
TOTAL=0
UNIQ=0

# Collect all unique declaration paths
while IFS= read -r -d '' lean_file; do
    # Extract the declaration path relative to the project dir
    proj_dir=$(echo "$lean_file" | sed 's|.*/split-results/||; s|/.*||')
    decl_path=$(echo "$lean_file" | sed "s|.*/split-results/$proj_dir/||")
    
    TOTAL=$((TOTAL + 1))
    
    if [ -z "${SEEN[$decl_path]:-}" ]; then
        # First encounter — copy it
        SEEN[$decl_path]=1
        SOURCES[$decl_path]="$proj_dir"
        UNIQ=$((UNIQ + 1))
        
        # Create target directory
        target="$OUT_DIR/$decl_path"
        mkdir -p "$(dirname "$target")"
        cp "$lean_file" "$target"
    fi
done < <(find "$SPLIT_DIR" -name "*.lean" -path "*/Split/*" -print0 2>/dev/null)

echo "Total: $TOTAL files, Unique: $UNIQ declarations"

# Copy flake.nix files for each unique decl
FLAKES=0
while IFS= read -r -d '' flake; do
    proj_dir=$(echo "$flake" | sed 's|.*/split-results/||; s|/.*||')
    decl_dir=$(echo "$flake" | sed "s|.*/split-results/$proj_dir/||; s|/flake\.nix$||")
    
    target="$OUT_DIR/$decl_dir/flake.nix"
    if [ -f "$target" ]; then
        continue  # already copied via .lean dedup
    fi
    mkdir -p "$(dirname "$target")"
    cp "$flake" "$target"
    FLAKES=$((FLAKES + 1))
done < <(find "$SPLIT_DIR" -name "flake.nix" -not -path "*/.*" -print0 2>/dev/null)

echo "Flakes copied: $FLAKES"

# Merge dag.json files
echo "Merging dag.json..."
TOTAL_DAG=0
python3 -c "
import json, sys, os, glob

merged = {}
for dag_file in glob.glob('$SPLIT_DIR/*/dag.json'):
    with open(dag_file) as f:
        dag = json.load(f)
    for k, v in dag.items():
        if k not in merged:
            merged[k] = v

with open('$OUT_DIR/dag.json', 'w') as f:
    json.dump(merged, f, indent=2)
print(f'Merged DAG: {len(merged)} nodes')
" 2>/dev/null || echo "  (no dag.json files to merge)"

# Copy lakefile.toml from first project that has one
for d in "$SPLIT_DIR"/*/; do
    if [ -f "$d/lakefile.toml" ]; then
        cp "$d/lakefile.toml" "$OUT_DIR/"
        break
    fi
done

echo "=== Done: $OUT_DIR ==="
echo "  Declarations: $UNIQ"
echo "  Sources: $(echo "${SOURCES[@]}" | wc -w) projects"
du -sh "$OUT_DIR"
