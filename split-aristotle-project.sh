#!/usr/bin/env bash
# split-aristotle-project.sh — Split a single Aristotle project into declarations
#
# Used by `aristotle-manager split-all`. Reads project dir and output dir from args.
# Strategy: use lake env to set up correct LEAN_PATH with pre-built oleans,
# then run SplitDecls.lean to extract per-declaration files.
#
# Usage:
#   split-aristotle-project.sh <project-dir> <output-dir>
#
# Environment:
#   LEAN_BIN       — nix store lean binary (default: 181szlvc, lean 4.28.0)
#   LEAN_SPLITTER  — path to SplitDecls.lean (default: ~/projects/lean-split-decls/SplitDecls.lean)
#
# Output: prints "N declaration files written to <dir>"

set -euo pipefail

# ── Config ─────────────────────────────────────────────────────────────────
NIX="/mnt/data1/nix-store/store/181szlvcvvjg9yr14849gmv253zyhlfl-lean"
LEAN_BIN="${LEAN_BIN:-$NIX/bin/lean}"
LAKE_BIN="${LAKE_BIN:-$NIX/bin/lake}"
LEAN_LIB="$NIX/lib/lean"
SPLITTER="${LEAN_SPLITTER:-/home/mdupont/projects/lean-split-decls/SplitDecls.lean}"
PROJECT_DIR="${1:?Usage: split-aristotle-project.sh <project-dir> <output-dir>}"
OUTPUT_DIR="${2:?Usage: split-aristotle-project.sh <project-dir> <output-dir>}"

# ── Step 0: Find RequestProject source dir ─────────────────────────────────
RP_DIR="$PROJECT_DIR/output-final_aristotle/RequestProject"
if [ ! -d "$RP_DIR" ]; then
  echo "No RequestProject, skipping" >&2
  exit 0
fi

# The project root is the parent of RequestProject (output-final_aristotle/)
PROJECT_ROOT="$PROJECT_DIR/output-final_aristotle"

# ── Step 0b: Use the shared precompiled Lean package cache ────────────────
SHARED_PACKAGES="/mnt/data1/lean/dot_lake/packages"
mkdir -p "$PROJECT_ROOT/.lake"
PACKAGES_LINK="$PROJECT_ROOT/.lake/packages"
if [ -L "$PACKAGES_LINK" ]; then
  [ "$(readlink "$PACKAGES_LINK")" = "$SHARED_PACKAGES" ] || {
    echo "Wrong .lake/packages symlink: $PACKAGES_LINK" >&2
    exit 1
  }
elif [ -e "$PACKAGES_LINK" ]; then
  BACKUP="$PROJECT_ROOT/.lake/packages.before-shared"
  [ ! -e "$BACKUP" ] || {
    echo "Refusing to overwrite existing package backup: $BACKUP" >&2
    exit 1
  }
  mv "$PACKAGES_LINK" "$BACKUP"
  ln -s "$SHARED_PACKAGES" "$PACKAGES_LINK"
else
  ln -s "$SHARED_PACKAGES" "$PACKAGES_LINK"
fi

# ── Step 1: Determine module prefix ────────────────────────────────────────
# Oleans are built as RequestProject.<ModuleName>, so the splitter needs
# the full module path (e.g. RequestProject.ErrorCorrectionBound)
MODULE_PREFIX="RequestProject"

# ── Step 2: Ensure oleans are built ─────────────────────────────────────────
# Use the project's lean-toolchain version (4.28.0) to build, not the system lean
cd "$PROJECT_ROOT"

# Check if oleans exist; if not, build them
OLEAN_DIR="$PROJECT_ROOT/.lake/build/lib/lean"
if [ ! -d "$OLEAN_DIR/$MODULE_PREFIX" ]; then
  echo "  Building oleans with $LAKE_BIN..." >&2
  timeout 120 "$LAKE_BIN" build "$MODULE_PREFIX" 2>"$PROJECT_ROOT/lake-build.err" || {
    echo "  ✗ lake build failed, falling back to stripped-imports mode" >&2
    # Fall back to the old approach: copy files, strip all imports, run directly
    FALLBACK=1
  }
fi

if [ "${FALLBACK:-0}" = "1" ]; then
  # ── Fallback: strip imports and run directly ─────────────────────────────
  TMPDIR=$(mktemp -d)
  cp "$RP_DIR"/*.lean "$TMPDIR/"

  # Strip ALL import lines (Mathlib and sub-imports) to avoid compilation
  for f in "$TMPDIR"/*.lean; do
    sed -i 's/^import /-- import /' "$f"
  done

  MODULE=$(basename "$(ls "$TMPDIR"/*.lean 2>/dev/null | head -1)" .lean)
  if [ -z "$MODULE" ]; then
    echo "No .lean files found" >&2
    rm -rf "$TMPDIR"
    exit 0
  fi

  cd "$TMPDIR"
  mkdir -p "$OUTPUT_DIR"
  LEAN_ERR="$TMPDIR/lean.err"
  if ! LEAN_PATH="$LEAN_LIB:." "$LEAN_BIN" --run "$SPLITTER" "$MODULE" "$OUTPUT_DIR" 2>"$LEAN_ERR"; then
    echo "  ✗ SplitDecls failed (fallback) for $MODULE: $(head -3 "$LEAN_ERR" 2>/dev/null)" >&2
    rm -rf "$TMPDIR"
    exit 1
  fi
  if [ -s "$LEAN_ERR" ]; then
    head -5 "$LEAN_ERR" >&2
  fi

  DECL_COUNT=$(rg --files -g '*.lean' "$OUTPUT_DIR" 2>/dev/null | wc -l)
  echo "$DECL_COUNT declaration files written to $OUTPUT_DIR"
  rm -rf "$TMPDIR"
  exit 0
fi

# ── Step 3: Use lake env to run SplitDecls ──────────────────────────────────
# lake env sets up LEAN_PATH with all the correct olean paths
mkdir -p "$OUTPUT_DIR"

# Get the LEAN_PATH from lake env
LEAN_PATH=$("$LAKE_BIN" env bash -c 'echo $LEAN_PATH' 2>/dev/null || echo "$LEAN_LIB:$OLEAN_DIR")

# Find all .lean files in RequestProject and build module list
MODULES=()
for f in "$RP_DIR"/*.lean; do
  modname=$(basename "$f" .lean)
  MODULES+=("$MODULE_PREFIX.$modname")
done

if [ ${#MODULES[@]} -eq 0 ]; then
  echo "No .lean files found" >&2
  exit 0
fi

# Run SplitDecls for each module
LEAN_ERR=$(mktemp)
TOTAL_DECLS=0
for module in "${MODULES[@]}"; do
  if ! LEAN_PATH="$LEAN_PATH" "$LEAN_BIN" --run "$SPLITTER" "$module" "$OUTPUT_DIR" 2>"$LEAN_ERR"; then
    echo "  ✗ SplitDecls failed for $module: $(head -3 "$LEAN_ERR" 2>/dev/null)" >&2
    continue
  fi
  if [ -s "$LEAN_ERR" ]; then
    head -5 "$LEAN_ERR" >&2
  fi
  # Count declarations from this module
  MOD_DECLS=$(rg --files -g '*.lean' "$OUTPUT_DIR" 2>/dev/null | wc -l)
  TOTAL_DECLS=$((TOTAL_DECLS + MOD_DECLS))
done

rm -f "$LEAN_ERR"

DECL_COUNT=$(rg --files -g '*.lean' "$OUTPUT_DIR" 2>/dev/null | wc -l)
echo "$DECL_COUNT declaration files written to $OUTPUT_DIR"
