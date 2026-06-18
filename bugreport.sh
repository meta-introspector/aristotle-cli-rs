#!/bin/bash

echo "--- Bug Report for Aristotle Manager Nix Build ---"
echo ""

echo "1. Current Working Directory:"
pwd
echo ""

echo "2. Contents of flake.nix:"
cat flake.nix
echo ""

echo "3. Contents of Cargo.toml:"
cat Cargo.toml
echo ""

echo "4. Contents of src/main.rs (first 50 lines):"
head -n 50 src/main.rs
echo ""

echo "5. Contents of src/fetch.rs:"
cat src/fetch.rs
echo ""

echo "6. Contents of src/index.rs:"
cat src/index.rs
echo ""

echo "7. Contents of src/notebooklm.rs:"
cat src/notebooklm.rs
echo ""

echo "8. Listing contents of src/ directory:"
ls -l src/
echo ""

echo "9. Attempting 'cargo build --verbose' (non-Nix build):"
cargo build --verbose
echo ""

echo "10. Attempting 'nix build . --show-trace' (Nix build - full log saved to nix_build.log):"
nix build . --show-trace > nix_build.log 2>&1
cat nix_build.log
echo ""

echo "--- Bug Report End ---"
