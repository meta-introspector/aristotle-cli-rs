#!/usr/bin/env bash
# split-lean-project.sh — Run SplitDecls on a Lean module
# Usage: split-lean-project.sh <module-name> <output-dir> [extra-path]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ENGINE_DIR="$SCRIPT_DIR/splitter-engine"
LAKE="/nix/store/aqpyjzpqhs988lpqs8rnq8rw3i7ihrmi-lean/bin/lake"
LEAN_BIN="/nix/store/aqpyjzpqhs988lpqs8rnq8rw3i7ihrmi-lean/bin"

MODULE="${1:-}"
OUTPUT="${2:-}"
EXTRA_PATH="${3:-}"

if [ -z "$MODULE" ] || [ -z "$OUTPUT" ]; then
    echo "Usage: $0 <module-name> <output-dir> [extra-lean-path]" >&2
    exit 1
fi

cd "$ENGINE_DIR"

# Build LEAN_PATH with extra entries
LEAN_PATH_EXTRA=""
if [ -n "$EXTRA_PATH" ] && [ -d "$EXTRA_PATH" ]; then
    LEAN_PATH_EXTRA="$EXTRA_PATH"
fi

PATH="$LEAN_BIN:$PATH"
if [ -n "$LEAN_PATH_EXTRA" ]; then
    LEAN_PATH="$LEAN_PATH_EXTRA:$(lake env printenv LEAN_PATH 2>/dev/null || echo '')" \
    "$LAKE" env lean --run RequestProject/SplitDecls.lean "$MODULE" "$OUTPUT"
else
    "$LAKE" env lean --run RequestProject/SplitDecls.lean "$MODULE" "$OUTPUT"
fi
