#!/usr/bin/env bash
# merge-projects.sh - Merge two Aristotle project branches into a single tree
#
# Usage: ./merge-projects.sh
# Creates a merged tree at ./merged-workspace/ for team review.
# The actual merge decision is made by the team after reviewing PROJECT-COMPARISON.md.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SRC1="${ROOT}/output-final_aristotle/17da0589-2bfc-44c4-8169-dbdb61676da2_aristotle/output-final_aristotle"
SRC2="${ROOT}/output-final_aristotle/0f9b0981-1dc9-4321-a46b-53e3cc6ee6e3_aristotle/output-final_aristotle"
OUT="${ROOT}/merged-workspace"

echo "=== Merging Aristotle project branches ==="
echo "  Branch 1 (17da0589): ${SRC1}"
echo "  Branch 2 (0f9b0981): ${SRC2}"
echo "  Output: ${OUT}"

# Clean output
rm -rf "${OUT}"
mkdir -p "${OUT}"

# ── Common files (use branch 1 as primary, branch 2 as fallback) ──
echo "[1/4] Copying common files..."
for f in README.md lakefile.toml lake-manifest.json lean-toolchain; do
    if [ -f "${SRC1}/${f}" ]; then
        cp "${SRC1}/${f}" "${OUT}/${f}"
        echo "  ✓ ${f} (from branch 1)"
    elif [ -f "${SRC2}/${f}" ]; then
        cp "${SRC2}/${f}" "${OUT}/${f}"
        echo "  ✓ ${f} (from branch 2)"
    fi
done

# ── Branch 1 master docs (primary) ──
echo "[2/4] Copying branch 1 master docs..."
for f in ORION_MASTER_INDEX.md ORION_FUNCTIONAL_WALKTHROUGH.md ORION_LINK_ARCHIVE.md ORION_RUNNING_ROSTER.md; do
    if [ -f "${SRC1}/${f}" ]; then
        cp "${SRC1}/${f}" "${OUT}/${f}"
        echo "  ✓ ${f}"
    fi
done

# ── Branch 2 design docs (supplementary) ──
echo "[3/4] Copying branch 2 design docs..."
for f in ENGINE_CATALOG.md HUB_DESIGN.md TOTALITY.md ORION_CHRONICLES_BLUEPRINT.md NEWKIN_COUNCIL.md CST_COMPILED_EDITION.md ORION_TOOLS.md; do
    if [ -f "${SRC2}/${f}" ]; then
        cp "${SRC2}/${f}" "${OUT}/${f}"
        echo "  ✓ ${f}"
    fi
done

# ── Review artifacts (both branches) ──
echo "[4/4] Copying review artifacts..."
for f in ROUND_THREE_* ROUND_FOUR_* ROUND_FIVE_* ROUND_EIGHT_* ROUND_NINE_* ROUND_TEN_* ROUND_SEVEN_* ROUND_SIX_* SPAGHETTI_* EFMW_ZOO_PROOFS_ARENA_REVIEW.md PRE_PUBLICATION_REVIEW.md TEAM_ROSTER_AND_X_REVIEW.md INCIDENT_REVIEW.md REVIEW_NEW_DOCUMENTS.md STATUS_AND_NEXT_STEPS.md NOTES.md; do
    if [ -f "${SRC1}/${f}" ]; then
        cp "${SRC1}/${f}" "${OUT}/${f}"
        echo "  ✓ ${f} (branch 1)"
    elif [ -f "${SRC2}/${f}" ]; then
        cp "${SRC2}/${f}" "${OUT}/${f}"
        echo "  ✓ ${f} (branch 2)"
    fi
done

echo ""
echo "=== Merge complete ==="
echo "  Output: ${OUT}"
echo "  Files: $(find "${OUT}" -type f | wc -l)"
echo ""
echo "  Review the merged tree and decide which files to keep."
echo "  Then re-deploy with: ./deploy-orion.sh --build"