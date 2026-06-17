#!/usr/bin/env bash
set -euo pipefail

FLAKE_REF=$1

echo "Building Nix flake: $FLAKE_REF"
# nix build "$FLAKE_REF"
echo "(Pretending to build)"
