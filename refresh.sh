#!/usr/bin/env bash
# refresh.sh — DASL Aristotle pipeline: download → git-track → split → dedup → build
# Usage: bash refresh.sh [--skip-build] [--skip-split] [--skip-track] [--dry-run]
set -euo pipefail
cd "$(dirname "$0")"

SKIP_BUILD=false; SKIP_SPLIT=false; SKIP_TRACK=false; DRY_RUN=false
for a in "$@"; do case "$a" in
    --skip-build) SKIP_BUILD=true ;; --skip-split) SKIP_SPLIT=true ;;
    --skip-track) SKIP_TRACK=true ;; --dry-run) DRY_RUN=true ;;
esac; done

RESULTS="aristotles_results"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
LOG="$RESULTS/refresh-$(date -u +%Y%m%d-%H%M%S).log"
mkdir -p "$RESULTS"
log() { echo "[$(date -u +%H:%M:%S)] $*" | tee -a "$LOG"; }
LAKE="/nix/store/aqpyjzpqhs988lpqs8rnq8rw3i7ihrmi-lean/bin/lake"

# ── Phase 1: Download ──────────────────────────────────────────
log "=== Phase 1: Download ==="
if $DRY_RUN; then log "  DRY RUN: skip"; else
    ./target/release/aristotle-manager download -j 2 2>&1 | grep -E '(Download complete|Saved)' | tail -3 | tee -a "$LOG"
fi

# ── Phase 2: Git-track projects ─────────────────────────────────
log "=== Phase 2: Git-track ==="
TRACKED=0; NEW=0; UPDATED=0
if $DRY_RUN || $SKIP_TRACK; then
    TRACKED=$(ls -d "$RESULTS"/*_aristotle/ 2>/dev/null | wc -l)
    log "  DRY/SKIP: would track $TRACKED projects"
else
    for proj in "$RESULTS"/*_aristotle/; do
        [ -d "$proj" ] || continue; name=$(basename "$proj")
        if [ ! -d "$proj/.git" ]; then
            (cd "$proj" && git init -q && git config user.email "a@d.l" && git config user.name "A" && git add -A 2>/dev/null; git commit -q -m "init" 2>/dev/null) || true
            NEW=$((NEW+1))
        elif [ -n "$(find "$proj" -not -path '*/.git/*' -newer "$proj/.git/COMMIT_EDITMSG" -type f 2>/dev/null | head -1)" ]; then
            (cd "$proj" && git add -A 2>/dev/null; DIFF=$(git diff --cached --stat 2>/dev/null|tail -1); git commit -q -m "$TIMESTAMP $DIFF" 2>/dev/null) || true
            UPDATED=$((UPDATED+1)); log "  UPDATED $name: $DIFF"
        fi
        TRACKED=$((TRACKED+1))
    done
fi
log "  $TRACKED tracked, $NEW new, $UPDATED updated"

# ── Phase 3: Split ──────────────────────────────────────────────
log "=== Phase 3: Split ==="
if $DRY_RUN || $SKIP_SPLIT; then log "  DRY/SKIP"; else
    ./target/release/aristotle-manager split-all 2>&1 | grep -E '(complete|✓ [1-9])' | tail -5 | tee -a "$LOG"
fi

# ── Phase 4: Dedup + track mathlib-split ────────────────────────
log "=== Phase 4: Dedup + track ==="
MATHLIB="$RESULTS/mathlib-split"
if $DRY_RUN; then log "  DRY RUN: skip"; else
    python3 dedup-split.py "$RESULTS/split-results" "$MATHLIB" 2>&1 | grep -E '(unique|Done|Size)' | tee -a "$LOG"
    cd "$MATHLIB"
    [ -d .git ] || { git init -q; git config user.email "d@d.l"; git config user.name "DASL"; }
    git add -A 2>/dev/null || true
    if ! git diff --cached --quiet 2>/dev/null; then
        ADDED=$(git diff --cached --diff-filter=A --name-only 2>/dev/null|grep -c '\.lean$'||echo 0)
        REMOVED=$(git diff --cached --diff-filter=D --name-only 2>/dev/null|grep -c '\.lean$'||echo 0)
        TOTAL=$(find . -name '*.lean' -not -path './.git/*'|wc -l)
        git commit -q -m "delta: +$ADDED -$REMOVED decls, $TOTAL total — $TIMESTAMP" 2>/dev/null || true
        log "  +$ADDED -$REMOVED decls, $TOTAL total"
    else log "  no changes"; fi
    cd - >/dev/null
fi

# ── Phase 5: Build ──────────────────────────────────────────────
log "=== Phase 5: Build ==="
if $DRY_RUN || $SKIP_BUILD; then log "  DRY/SKIP"; else
    BUILT=0; FAILED=0; SKIPPED_BUILD=0
    for proj in "$RESULTS"/*_aristotle/; do
        [ -d "$proj" ] || continue; name=$(basename "$proj")
        src="$proj/output-final_aristotle"
        [ -f "$src/lakefile.toml" ] || [ -f "$src/lakefile.lean" ] || { SKIPPED_BUILD=$((SKIPPED_BUILD+1)); continue; }
        (cd "$src" && "$LAKE" build >/dev/null 2>&1) && BUILT=$((BUILT+1)) || { FAILED=$((FAILED+1)); log "  FAILED $name"; }
    done
    log "  $BUILT ok, $FAILED failed, $SKIPPED_BUILD no lakefile"
fi

log "=== Done: $LOG ==="
