#!/usr/bin/env bash
# split-project.sh — Split one Aristotle project into per-declaration flakes
#
# Uses the static_split.py fallback splitter (Python regex-based).
# For production use with exact dependency tracking, use SplitDecls.lean via:
#   lake env lean SplitDecls.lean -- <module> <output-dir>
#
# Arguments:
#   $1  Project directory (required)
#   $2  Output base directory (optional, default: ../split-results)
#   $3  Tool name for output path pattern (optional, default: "lean-split-decls")
#
# Example:
#   ./scripts/split-project.sh 016b1f96-d5e9-4d02-b8a6-99336b8b1760_aristotle
#   ./scripts/split-project.sh 016b1f96-d5e9-4d02-b8a6-99336b8b1760_aristotle /tmp/my-split

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ARIST_DIR="$(cd "$SCRIPT_DIR/.." && pwd -P)"

# Splitter lives in a sibling project; override via env or set absolute path
if [ -z "${SPLITTER:-}" ]; then
  SPLITTER="${LEAN_SPLIT_DECLS:-/home/mdupont/projects/lean-split-decls/static_split.py}"
fi
DEFAULT_OUTPUT="$ARIST_DIR/split-results"

usage() {
  cat <<EOF
Usage: $0 <project-dir> [output-dir] [--tool-name <name>]

Split one Aristotle project's RequestProject/ .lean files into
per-declaration flake.nix files using static_split.py.

Positional arguments:
  project-dir   Path to a *_aristotle project directory (required)
  output-dir    Base output directory (optional, default: split-results/)

Options:
  --tool-name <name>   Tool identifier for output path pattern (default: "lean-split-decls")
  --help               Show this help

Environment:
  SPLITTER       Path to static_split.py (default: ../lean-split-decls/static_split.py)
EOF
}

# ── Argument parsing ───────────────────────────────────────────────────────────

if [ $# -lt 1 ]; then
  usage >&2
  exit 1
fi

PROJECT_DIR="$1"
OUTPUT_DIR="${2:-$DEFAULT_OUTPUT}"

shift $#  # consume all positional args

TOOL_NAME="lean-split-decls"
while [ $# -gt 0 ]; do
  case "$1" in
    --tool-name) TOOL_NAME="$2"; shift 2 ;;
    --help|-h) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
  esac
done

# ── Validation ─────────────────────────────────────────────────────────────────

if [ ! -d "$PROJECT_DIR" ]; then
  echo "ERROR: Project directory not found: $PROJECT_DIR" >&2
  exit 1
fi

if [ ! -f "$SPLITTER" ]; then
  echo "ERROR: Splitter not found: $SPLITTER" >&2
  echo "  Set SPLITTER env var or install lean-split-decls" >&2
  exit 1
fi

# Find the inner project directory (the *_aristotle/*_aristotle/RequestProject structure)
REQUEST_DIR="$PROJECT_DIR/RequestProject"
if [ ! -d "$REQUEST_DIR" ]; then
  echo "WARNING: No RequestProject/ subdirectory found in $PROJECT_DIR" >&2
  echo "  Looking for .lean files at project root..." >&2
  REQUEST_DIR="$PROJECT_DIR"
fi

# Extract project name from directory path
PROJECT_NAME="$(basename "$PROJECT_DIR")"

# ── Split ──────────────────────────────────────────────────────────────────────

echo "============================================================"
echo "  split-project.sh"
echo "  Project: $PROJECT_NAME"
echo "  Splitter: $SPLITTER"
echo "  Output: $OUTPUT_DIR"
echo "============================================================"
echo ""

mkdir -p "$OUTPUT_DIR"

# Resolve output path with pattern: {tool}/{target}/{timestamp}
TIMESTAMP="$(date +%s)"
RESOLVED_OUT="$OUTPUT_DIR"
RESOLVED_OUT="${RESOLVED_OUT//\{tool\}/$TOOL_NAME}"
RESOLVED_OUT="${RESOLVED_OUT//\{target\}/$PROJECT_NAME}"
RESOLVED_OUT="${RESOLVED_OUT//\{timestamp\}/$TIMESTAMP}"

mkdir -p "$RESOLVED_OUT"

echo "Source: $REQUEST_DIR"
echo "Output: $RESOLVED_OUT"
echo ""

# Run the splitter
python3 "$SPLITTER" "$REQUEST_DIR" "$RESOLVED_OUT"

FLAKE_COUNT="$(find "$RESOLVED_OUT" -name 'flake.nix' 2>/dev/null | wc -l)"
echo ""
echo "  Flakes generated: $FLAKE_COUNT"
echo "  Output: $RESOLVED_OUT"

echo ""
echo "  Next steps:"
echo "    - Inspect individual flakes:  find $RESOLVED_OUT -name 'flake.nix' | head -5"
echo "    - Build a specific flake:    nix build -f $RESOLVED_OUT/<decl-dir>"
echo "    - Full build:                 nix build .#default -L"
