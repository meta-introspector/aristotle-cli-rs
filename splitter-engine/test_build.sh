#!/bin/bash
set -e

# Try to build just the absurd declaration from the split lattice
cd split-self-test

# Create a minimal test file that imports just absurd
cat > TestAbsurd.lean << 'LEAN'
import Split.absurd

example (h : False) : Nat := absurd h (fun x => x)
LEAN

# Try to build it
nix-shell -p lean4 --run "lean TestAbsurd.lean" 2>&1 || echo "Nix build failed, trying direct..."
cd ..
