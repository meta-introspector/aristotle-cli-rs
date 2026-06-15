#!/usr/bin/env bash
# split-aristotle-project.sh — Split one Aristotle project into per-declaration flakes
# Usage: split-aristotle-project.sh <project-dir> <output-dir>
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ENGINE_SRC="$SCRIPT_DIR/splitter-engine"
LAKE="/nix/store/aqpyjzpqhs988lpqs8rnq8rw3i7ihrmi-lean/bin/lake"
LEAN_BIN="/nix/store/aqpyjzpqhs988lpqs8rnq8rw3i7ihrmi-lean/bin"

PROJECT_DIR="${1:-}"
OUTPUT_DIR="${2:-}"

[ -n "$PROJECT_DIR" ] && [ -n "$OUTPUT_DIR" ] || { echo "Usage: $0 <project-dir> <output-dir>" >&2; exit 1; }

SRC="$PROJECT_DIR/output-final_aristotle/RequestProject"
[ -d "$SRC" ] || { echo "No RequestProject/ in $PROJECT_DIR" >&2; exit 1; }

PROJ_NAME="$(basename "$PROJECT_DIR")"
# Convert to absolute path (splitter writes relative to its CWD)
OUTPUT_DIR="$(realpath "$OUTPUT_DIR" 2>/dev/null || readlink -f "$OUTPUT_DIR" 2>/dev/null || echo "$PWD/$OUTPUT_DIR")"
echo "=== $PROJ_NAME ==="

# Find the module with the most declarations (not Main.lean which is usually empty)
BEST_MODULE=""
BEST_COUNT=0
for f in "$SRC"/*.lean; do
    [ -f "$f" ] || continue
    name=$(basename "$f" .lean)
    [ "$name" = "Main" ] && continue  # Main.lean is usually just imports
    [ "$name" = "SplitDecls" ] && continue  # skip splitter itself unless it's the only one
    count=$(grep -cE '^[[:space:]]*(def |theorem |lemma |inductive |structure |class |instance |opaque |abbrev |elab |macro |syntax )' "$f" 2>/dev/null | head -1)
    count=${count:-0}
    if [ "$count" -gt "$BEST_COUNT" ]; then
        BEST_COUNT=$count
        BEST_MODULE="$name"
    fi
done

if [ -z "$BEST_MODULE" ]; then
    # Fallback: try Main.lean
    if [ -f "$SRC/Main.lean" ]; then
        BEST_MODULE="Main"
        BEST_COUNT=$(grep -cE '^[[:space:]]*(def |theorem |lemma |inductive |structure |class |instance |opaque |abbrev )' "$SRC/Main.lean" 2>/dev/null | head -1)
        BEST_COUNT=${BEST_COUNT:-0}
    fi
    if [ "$BEST_COUNT" -eq 0 ]; then
        echo "  No declarations found, skipping"
        exit 0
    fi
fi

MODULE="RequestProject.$BEST_MODULE"
echo "  Module: $MODULE ($BEST_COUNT decls)"

# Temp work dir
WORK_DIR=$(mktemp -d /tmp/splitter-work-XXXXXX)
trap "rm -rf $WORK_DIR" EXIT

# Copy engine + project files
mkdir -p "$WORK_DIR/RequestProject"
cp "$ENGINE_SRC"/lakefile.toml "$ENGINE_SRC"/lean-toolchain "$ENGINE_SRC"/lake-manifest.json "$WORK_DIR/" 2>/dev/null
cp "$ENGINE_SRC"/RequestProject/*.lean "$WORK_DIR/RequestProject/" 2>/dev/null
cp -r "$ENGINE_SRC"/RequestProject/AZ "$WORK_DIR/RequestProject/" 2>/dev/null
cp "$ENGINE_SRC"/RequestProject/.gitkeep "$WORK_DIR/RequestProject/" 2>/dev/null
# Copy project files (don't overwrite SplitDecls.lean)
for f in "$SRC"/*.lean; do
    [ -f "$f" ] || continue
    n=$(basename "$f")
    [ "$n" != "SplitDecls.lean" ] && cp "$f" "$WORK_DIR/RequestProject/$n"
done
for d in "$SRC"/*/; do
    [ -d "$d" ] || continue
    sub=$(basename "$d"); [ "$sub" != "AZ" ] && cp -r "$d" "$WORK_DIR/RequestProject/" 2>/dev/null
done

ln -sf "$ENGINE_SRC/.lake" "$WORK_DIR/.lake"

cat > "$WORK_DIR/lakefile.toml" <<'LAKEFILE'
name = "splitter-work"
defaultTargets = ["RequestProject"]
[[require]]
name = "mathlib"
git = "https://github.com/leanprover-community/mathlib4.git"
rev = "v4.28.0"
[[lean_lib]]
name = "RequestProject"
globs = ["RequestProject.+", "RequestProject.AZ.+"]
[[lean_exe]]
name = "splitdecls"
root = "RequestProject.SplitDecls"
LAKEFILE

cd "$WORK_DIR"
PATH="$LEAN_BIN:$PATH"

# Build the target module + splitter
if ! "$LAKE" build "$MODULE" splitdecls > /dev/null 2>&1; then
    echo "  WARNING: build failed for $MODULE, skipping"
    exit 0
fi

# Run splitter
echo "  Splitting..."
"$LAKE" env lean --run RequestProject/SplitDecls.lean "$MODULE" "$OUTPUT_DIR" 2>&1
echo "  Done: $(find "$OUTPUT_DIR" -name 'flake.nix' 2>/dev/null | wc -l) flakes"
