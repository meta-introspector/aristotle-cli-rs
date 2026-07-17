#!/usr/bin/env bash
# split-aristotle-project.sh — Split a single Aristotle project into declarations
#
# Used by `aristotle-manager split-all`. Reads project dir and output dir from args.
# Strategy: strip unused import Mathlib, run SplitDecls.lean with nix store lean.
#
# Usage:
#   split-aristotle-project.sh <project-dir> <output-dir>
#
# Environment:
#   LEAN_BIN       — nix store lean binary (default: 181szlvc)
#   LEAN_SPLITTER  — path to SplitDecls.lean (default: ~/projects/lean-split-decls/SplitDecls.lean)
#
# Output: prints "N declaration files written to <dir>"

set -euo pipefail

# ── Config ─────────────────────────────────────────────────────────────────
NIX="/mnt/data1/nix-store/store/181szlvcvvjg9yr14849gmv253zyhlfl-lean"
LEAN="${LEAN_BIN:-$NIX/bin/lean}"
LEAN_LIB="$NIX/lib/lean"
SPLITTER="${LEAN_SPLITTER:-/home/mdupont/projects/lean-split-decls/SplitDecls.lean}"
PROJECT_DIR="${1:?Usage: split-aristotle-project.sh <project-dir> <output-dir>}"
OUTPUT_DIR="${2:?Usage: split-aristotle-project.sh <project-dir> <output-dir>}"
TMPDIR="/tmp/split-aristotle-$$"

# ── Step 0: Find RequestProject source dir ─────────────────────────────────
RP_DIR="$PROJECT_DIR/output-final_aristotle/RequestProject"
if [ ! -d "$RP_DIR" ]; then
  echo "No RequestProject, skipping" >&2
  exit 0
fi

# ── Step 1: Copy and strip mathlib ────────────────────────────────────
rm -rf "$TMPDIR"
mkdir -p "$TMPDIR" "$OUTPUT_DIR"

cp "$RP_DIR"/*.lean "$TMPDIR/"

MATHLIB_RE='Finset|Filter|SetLike|Submodule|Algebra\.|Ring\.|Group\.|Field\.|Topology|Measure|Category|Module|Ideal|Prime\.|Polynomial|Matrix\.|Vector\.|Manifold|Metric|Normed|CompleteLattice|DirectSum|TensorProduct|Localization|Adjoin|AlgebraMap'

for f in "$TMPDIR"/*.lean; do
  needs_mathlib=$(grep -cE "$MATHLIB_RE" "$f" 2>/dev/null || true)
  if [ "$needs_mathlib" -eq 0 ]; then
    sed -i 's/^import Mathlib$/-- import Mathlib (stripped, unused)/' "$f"
  fi
done

# ── Step 2: Get module name ────────────────────────────────────────────
MODULE=$(basename "$(ls "$TMPDIR"/*.lean 2>/dev/null | head -1)" .lean)
if [ -z "$MODULE" ]; then
  echo "No .lean files found" >&2
  rm -rf "$TMPDIR"
  exit 0
fi

# ── Step 3: Run SplitDecls with nix store lean ─────────────────────────
cd "$TMPDIR"
LEAN_PATH="$LEAN_LIB" \
  $LEAN --run "$SPLITTER" "$MODULE" "$OUTPUT_DIR" 2>/dev/null || true

# Count results
DECL_COUNT=$(find "$OUTPUT_DIR" -name "*.lean" 2>/dev/null | wc -l)
echo "$DECL_COUNT declaration files written to $OUTPUT_DIR"

# Cleanup
rm -rf "$TMPDIR"
