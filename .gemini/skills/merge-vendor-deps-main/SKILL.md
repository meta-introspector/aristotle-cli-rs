---
name: merge-vendor-deps-main
description: >-
  Merge the vendor-deps branch into main for ipld-car-ipc-shmem-linux.
  The main branch is broken (cargoLock.lockFile with file:// paths fails in
  Nix sandbox). The vendor-deps branch works with cargo vendor + cargoVendorDir.
  Use when fixing offline Nix builds, merging branches, or updating flake.nix.
---

# Merge ipld-car-ipc-shmem-linux vendor-deps into main

**Priority:** HIGH
**Area:** Nix
**Status:** Pending
**Source:** plan.org

## Problem

The `main` branch of ipld-car-ipc-shmem-linux uses `cargoLock.lockFile` which
contains `file://` paths that fail inside the Nix sandbox. The `vendor-deps`
branch fixes this by using `cargo vendor` + `cargoVendorDir = "vendor"`.

## Branches

| Branch       | Status    | Build Method                          |
|--------------|-----------|---------------------------------------|
| main         | BROKEN    | cargoLock.lockFile (file:// fails)    |
| vendor-deps  | WORKING   | cargoVendorDir = "vendor" (offline)   |

## What vendor-deps Changed

1. Fixed paths: `/home/mdupont/` → `/mnt/data1/git/` in Cargo.toml/Cargo.lock
2. Vendored 100+ crate deps: `cargo vendor vendor` (11,584 files)
3. Created `.cargo/config.toml` with vendored source mapping
4. Switched flake.nix: `cargoLock.lockFile` → `cargoVendorDir = "vendor"`
5. Fixed source filter: exclude only top-level `/target`, not `vendor/cc/src/target/`

## Merge Steps

```bash
cd /mnt/data1/time-2026/02-february/22/dasl/ipld-car-ipc-shmem-linux

# 1. Checkout main
git checkout main

# 2. Merge vendor-deps
git merge vendor-deps

# 3. Resolve any conflicts (likely in flake.nix and Cargo.lock)
# 4. Verify build
nix build .#letta-ipld-memory

# 5. Verify offline
nix build .#letta-ipld-memory --option substitute false

# 6. Push
git push origin main
```

## After Merge

- Point task flake.nix back to main branch instead of `?ref=vendor-deps`
- Update diagonalize deploy to use main
- Delete vendor-deps branch after verification

## Depends On

Nothing — this is a leaf task.

## Blocks

Nothing directly, but unblocks clean builds from main.

## Vendormod Connection

The same vendoring pattern is used by cargo-vendormod (`src/utils.rs` uses
`cargo vendor vendor` + `cargoVendorDir`). The ipld-car-ipc-shmem-linux fix
documented here is the reference implementation for all DASL Rust flakes.

See [[cargo-vendormod]] for the full vendormod architecture and
[[nix-build]] for the general vendoring procedure.
