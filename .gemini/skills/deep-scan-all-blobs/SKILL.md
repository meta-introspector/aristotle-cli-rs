---
name: deep-scan-all-blobs
description: >-
  Apply deep-scan to ALL 765+ blobs in IPLD shmem, not just the 153 in
  vendormod/full/. The deep scanner applies Hecke scoring, entropy computation,
  and functor arrow extraction. Use when expanding analysis coverage, computing
  spectral features, or preparing data for the 3-category construction.
---

# Apply Deep-Scan to All 765+ IPLD Shmem Blobs

**Priority:** MEDIUM
**Area:** Scanning
**Status:** Pending
**Source:** plan.org

## Current State

Only 153 of 765+ blobs have been deep-scanned (those in `vendormod/full/`).
The deep scanner computes:
- Hecke score (T_p spectral operator values)
- Shannon entropy
- Functor arrows (morphism relationships between blobs)
- CID count (0xD8 0x2A occurrences)

## Top Result So Far

`ontologies/data/arrows.txt` ranked #1 of 153 blocks:
- Hecke score: 448.8 (highest)
- Entropy: 5.25 (rank #8)
- Anomaly: High shadow spike (only one detected)

## How to Run

```bash
cd /mnt/data1/time-2026/06-june/letta-unified

# Build
cargo build --release

# Scan all blobs (not just vendormod/full/)
./target/release/cargo-vendormod deep-scan --all
```

## Available Functions (from utils.rs)

- `compute_cid(data: &[u8]) -> String` — SHA-256 CID
- `compute_entropy(data: &[u8]) -> f64` — Shannon entropy
- `compute_hecke_score(data: &[u8]) -> f64` — Hecke spectral score
- `count_cids(data: &[u8]) -> usize` — Count 0xD8 0x2A signatures
- `FileSample` — Structured file sampling

## Expected Output

- 765+ analysis nodes (up from 153)
- 765+ functor arrows (up from 153)
- Complete Hecke ranking of all blobs
- Full entropy distribution

## Depends On

Nothing — this is a leaf task.

## Blocks

- build-3-category (need full scan before constructing 3-cells)
