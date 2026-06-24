#!/usr/bin/env bash
# build.sh — commit to git mirror, then nix build
# The flake.nix uses git+file:// with ref=main, so it auto-tracks the mirror.
set -euo pipefail
cd "$(dirname "$0")"

MIRROR="/mnt/data1/git/github.com/arist/aristotle-manager.git"

echo "=== aristotle-manager build ==="

# 1. Ensure the bare mirror exists
if [ ! -d "$MIRROR" ]; then
    echo "Creating bare mirror at $MIRROR"
    git init --bare "$MIRROR"
fi

# 2. Commit current working tree if dirty
if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
    echo "Committing changes..."
    git add -A
    git commit -m "auto: $(date +%Y-%m-%d-%H%M)" || true
fi

# 3. Push to mirror
echo "Pushing to $MIRROR..."
git push --force "$MIRROR" HEAD:main

# 4. Pin rev (optional — comment out to use floating ref=main)
REV=$(git -C "$MIRROR" rev-parse main)
echo "Pinned rev: $REV"

# 5. Nix build
echo "Building via nix..."
nix build .#default --impure 2>&1 | tail -5

# 6. Install
echo "Installing via nix profile..."
nix profile install .#default --impure 2>&1 | tail -3

echo "Done. Binary: $(which aristotle-manager 2>/dev/null || echo 'nix profile')"
