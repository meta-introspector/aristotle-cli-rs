---
name: fix-rust001-min-len
description: >-
  Fix n0_dasl RUST-001 bug: MIN_LEN is 3 but should be 4 in cid.rs.
  Truncated CID (3-byte payload) causes panic instead of Err.
  Use when fixing the n0_dasl CID parsing bug, adding regression tests,
  or verifying mitigation vectors pass after the fix.
---

# Fix RUST-001: n0_dasl MIN_LEN 3→4

**Priority:** HIGH
**Area:** Divergence
**Status:** Pending
**Source:** status.org

## Bug Description

In `dasl-0.2.0/src/cid.rs`, `MIN_LEN` is set to 3 but should be 4.
A truncated CID with a 3-byte payload causes a panic instead of returning `Err`.

## Root Cause

```rust
// dasl-0.2.0/src/cid.rs
const MIN_LEN: usize = 3;  // BUG: should be 4
```

A valid CIDv1 requires at minimum:
- 1 byte version
- 1 byte codec
- 1 byte multihash code
- 1 byte multihash length
= 4 bytes minimum

## Fix

1. Change `MIN_LEN` from 3 to 4 in `dasl-0.2.0/src/cid.rs`
2. Add regression test: `from_bytes_raw(&[0x01, 0x55, 0x12])` must return `Err`, not panic
3. Verify all 50 mitigation vectors pass after fix

## Verification

```bash
cd ~/dasl/rust/n0_dasl
# Apply fix
# Then:
cargo test
# Run round-robin with mitigation vectors
cd ~/dasl/dasl-testing
python3 round_robin.py --inputs fixtures/cbor --impls n0_dasl,serde_ipld_dagcbor
```

## Mitigation Vectors

Located at `~/dasl/dasl-testing/fixtures/cbor/`:
- `short_form_mitigation.json` — 37 vectors for non-canonical encodings
- `cid_mitigation.json` — 13 vectors including RUST-001 reproduction
- `rust001_repro.sh` — Script to reproduce the panic

## Depends On

Nothing — this is a leaf task.

## Blocks

- task_2: Run round-robin with dag-cbrrr, go-ipld-cbor, js-dag-cbor (should fix bug first)
