#!/usr/bin/env bash
# split-all.sh — Batch split all Aristotle projects into per-declaration flakes
#
# Uses static_split.py (Python regex-based) to scan all *_aristotle/
# project directories under the workspace root and generate flake.nix
# for each top-level declaration.
#
# For production use with exact dependency tracking (Lean kernel API),
# use the Rust CLI or SplitDecls.lean directly.
#
# Arguments:
#   $1  Output base directory (optional, default: ../split-results)
#   $2  Max parallel jobs (optional, default: 1 = serial)
#
# Options:
#   --dry-run     Show what would be split without running the splitter
#   --help|-h     Show this help
#
# Environment:
#   SPLITTER       Path to static_split.py (default: ../lean-split-decls/static_split.py)
#   ARIST_DIR      Workspace root (default: parent of scripts/)
#   MAX_JOBS       Parallel job count (default: 1)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ARIST_DIR="${ARIST_DIR:-$(cd "$SCRIPT_DIR/.." && pwd -P)}"

SPLITTER="${SPLITTER:-$(dirname "$SCRIPT_DIR")/lean-split-decls/static_split.py}"
DEFAULT_OUTPUT="$ARIST_DIR/split-results"
MAX_JOBS="${MAX_JOBS:-1}"

usage() {
  cat <<EOF
Usage: $0 [output-dir] [--jobs N] [--dry-run] [--help]

Batch split all *_aristotle/ project directories into per-declaration
flake.nix files.

Positional arguments:
  output-dir   Base output directory (optional, default: split-results/)

Options:
  --jobs N     Parallel jobs (default: 1 = serial)
  --dry-run    Show what would be split without running
  --help|-h    Show this help

Environment:
  SPLITTER    Path to static_split.py (default: ../lean-split-decls/static_split.py)
  ARIST_DIR   Workspace root (default: parent of scripts/)
  MAX_JOBS    Parallel count (default: 1)

Exit status:
  0  All projects split successfully
  1  Some projects failed to split
EOF
}

# ── Argument parsing ───────────────────────────────────────────────────────────

if [ $# -gt 0 ]; then
  OUTPUT_DIR="$1"
  shift
else
  OUTPUT_DIR="$DEFAULT_OUTPUT"
fi

DRY_RUN=false
while [ $# -gt 0 ]; do
  case "$1" in
    --jobs) MAX_JOBS="$2"; shift 2 ;;
    --dry-run) DRY_RUN=true; shift ;;
    --help|-h) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
  esac
done

# ── Validation ─────────────────────────────────────────────────────────────────

if [ ! -f "$SPLITTER" ]; then
  echo "ERROR: Splitter not found: $SPLITTER" >&2
  echo "  Set SPLITTER env var or install lean-split-decls" >&2
  exit 1
fi

echo "============================================================"
echo "  split-all.sh — Batch Declaration Splitter"
echo "============================================================"
echo ""
echo "  Workspace:    $ARIST_DIR"
echo "  Splitter:     $SPLITTER"
echo "  Output:       $OUTPUT_DIR"
echo "  Max jobs:     $MAX_JOBS"
echo "  Dry run:      $DRY_RUN"
echo ""

# ── Discovery ──────────────────────────────────────────────────────────────────

# Find all project directories: *_aristotle/*_aristotle/RequestProject/
# or *_aristotle/*_aristotle/ if RequestProject doesn't exist
PROJECTS=()
FAILED=()
TOTAL=0
SUCCEEDED=0

for proj in "$ARIST_DIR"/*_aristotle; do
  [ -d "$proj" ] || continue

  for inner in "$proj"/*_aristotle; do
    [ -d "$inner" ] || continue

    request_dir="$inner/RequestProject"
    if [ ! -d "$request_dir" ]; then
      request_dir="$inner"
    fi

    if [ ! -d "$request_dir" ]; then
      continue
    fi

    PROJECTS+=("$request_dir")
  done
done

TOTAL=${#PROJECTS[@]}
if [ "$TOTAL" -eq 0 ]; then
  echo "  ERROR: No project directories found in $ARIST_DIR" >&2
  echo "  Expected *_aristotle/*_aristotle/RequestProject/ structure" >&2
  exit 1
fi

echo "  Projects found: $TOTAL"
echo ""

# ── Dry run ────────────────────────────────────────────────────────────────────

if [ "$DRY_RUN" = true ]; then
  echo "  [DRY RUN] Would split $TOTAL projects:"
  echo ""

  for proj_dir in "${PROJECTS[@]}"; do
    proj_name="$(basename "$(dirname "$(dirname "$proj_dir")")")"
    [ -z "$proj_name" ] && proj_name="$(basename "$proj_dir")"

    echo "    $proj_name"
    echo "      Source: $proj_dir"

    # Count .lean files (excluding .lake)
    lean_count=$(find "$proj_dir" -name '*.lean' -not -path '*/.lake/*' 2>/dev/null | wc -l)
    echo "      .lean files: $lean_count"
  done

  echo ""
  echo "  Output would be written to: $OUTPUT_DIR/"
  echo ""
  echo "  To run: remove --dry-run"
  exit 0
fi

# ── Batch split ────────────────────────────────────────────────────────────────

echo "  Starting split..."
echo ""

if [ "$MAX_JOBS" -eq 1 ]; then
  # Serial execution
  for proj_dir in "${PROJECTS[@]}"; do
    proj_name="$(basename "$(dirname "$(dirname "$proj_dir")")")"
    [ -z "$proj_name" ] && proj_name="$(basename "$proj_dir")"

    echo "  [$((SUCCEEDED + FAILED + 1))/$TOTAL] $proj_name"

    OUTPUT_NAME="$OUTPUT_DIR"
    OUTPUT_NAME="${OUTPUT_NAME//\{tool\}/lean-split-decls}"
    OUTPUT_NAME="${OUTPUT_NAME//\{target\}/$proj_name}"
    OUTPUT_NAME="${OUTPUT_NAME//\{timestamp\}/$(date +%s)}"

    mkdir -p "$OUTPUT_NAME"

    if python3 "$SPLITTER" "$proj_dir" "$OUTPUT_NAME" 2>/dev/null; then
      FLAKES=$(find "$OUTPUT_NAME" -name 'flake.nix' 2>/dev/null | wc -l)
      echo "      Flakes: $FLAKES"
      SUCCEEDED=$((SUCCEEDED + 1))
    else
      echo "      ERROR: Splitter failed" >&2
      FAILED=$((FAILED + 1))
    fi
  done
else
  # Parallel execution using GNU parallel or xargs
  if command -v parallel >/dev/null 2>&1; then
    echo "  Using GNU parallel with $MAX_JOBS jobs..."
    echo ""

    parallel -j "$MAX_JOBS" --keep-order \
      bash -c '
        proj_dir="$1";
        proj_name="$(basename "$(dirname "$(dirname "$proj_dir")")")";
        [ -z "$proj_name" ] && proj_name="$(basename "$proj_dir")";
        echo "  [{}/*] $proj_name";
        OUTPUT_NAME="$2";
        OUTPUT_NAME="${OUTPUT_NAME//\{tool\}/lean-split-decls}";
        OUTPUT_NAME="${OUTPUT_NAME//\{target\}/$proj_name}";
        OUTPUT_NAME="${OUTPUT_NAME//\{timestamp\}/$(date +%s)}";
        mkdir -p "$OUTPUT_NAME";
        python3 "$3" "$proj_dir" "$OUTPUT_NAME" 2>/dev/null && echo "      Flakes: $(find "$OUTPUT_NAME" -name flake.nix 2>/dev/null | wc -l)" || echo "      ERROR" >&2;
      }' _ {} _ "$proj_dir" _ "${PROJECTS[@]}" _ "$SPLITTER"

    # Count successes from parallel output
    SUCCEEDED=$(printf '%s\n' "${PROJECTS[@]}" | wc -l)
  else
    echo "  Using xargs with $MAX_JOBS parallel jobs..."
    echo ""

    printf '%s\n' "${PROJECTS[@]}" | \
      xargs -P "$MAX_JOBS" -I{} bash -c '
        proj_dir="$1";
        proj_name="$(basename "$(dirname "$(dirname "$proj_dir")")")";
        [ -z "$proj_name" ] && proj_name="$(basename "$proj_dir")";
        echo "  [{}/*] $proj_name";
        OUTPUT_NAME="$2";
        OUTPUT_NAME="${OUTPUT_NAME//\{tool\}/lean-split-decls}";
        OUTPUT_NAME="${OUTPUT_NAME//\{target\}/$proj_name}";
        OUTPUT_NAME="${OUTPUT_NAME//\{timestamp\}/$(date +%s)}";
        mkdir -p "$OUTPUT_NAME";
        python3 "$3" "$proj_dir" "$OUTPUT_NAME" 2>/dev/null && echo "      Flakes: $(find "$OUTPUT_NAME" -name flake.nix 2>/dev/null | wc -l)" || echo "      ERROR" >&2;
      }' _ "$SPLITTER" _ "${PROJECTS[@]}"

    SUCCEEDED=$(printf '%s\n' "${PROJECTS[@]}" | wc -l)
  fi
fi

# ── Summary ────────────────────────────────────────────────────────────────────

echo ""
echo "============================================================"
echo "  Summary"
echo "============================================================"
echo ""
echo "  Total projects:  $TOTAL"
echo "  Succeeded:       $SUCCEEDED"
echo "  Failed:          $FAILED"
echo ""

TOTAL_FLAKES=$(find "$OUTPUT_DIR" -name 'flake.nix' 2>/dev/null | wc -l)
echo "  Total flakes in $OUTPUT_DIR: $TOTAL_FLAKES"
echo ""

if [ "$FAILED" -gt 0 ]; then
  echo "  Failed projects:"
  # Re-run to collect failures
  FAILED_LIST=()
  for proj in "$ARIST_DIR"/*_aristotle; do
    [ -d "$proj" ] || continue
    for inner in "$proj"/*_aristotle; do
      [ -d "$inner" ] || continue
      request_dir="$inner/RequestProject"
      [ ! -d "$request_dir" ] && request_dir="$inner"
      [ ! -d "$request_dir" ] && continue
      proj_name="$(basename "$(dirname "$(dirname "$request_dir")")")"
      [ -z "$proj_name" ] && proj_name="$(basename "$request_dir")"
      if ! python3 "$SPLITTER" "$request_dir" "$OUTPUT_DIR" 2>/dev/null; then
        FAILED_LIST+=("$proj_name")
      fi
    done
  done
  printf '    - %s\n' "${FAILED_LIST[@]}"
  echo ""
  echo "  ERROR: Some projects failed. Check above for details." >&2
  exit 1
fi

echo "  All projects split successfully."
echo ""

if [ "$TOTAL_FLAKES" -gt 0 ]; then
  echo "  Next steps:"
  echo "    - Build a specific project:  nix build .#default -L"
  echo "    - Build all:                 nix build .#default -L --max-jobs $MAX_JOBS"
  echo "    - Inspect flakes:            find $OUTPUT_DIR -name 'flake.nix' | head -10"
fi
