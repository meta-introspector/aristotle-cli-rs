---
name: extend-dmz-mmap-scan
description: >-
  Extend the DMZ mmap scan from 200MB to the full 36GB pages.bin for complete
  CID signature analysis. Also build per-language fuzz harnesses for 0xD8 0x2A
  round-trip and cross-validate CID encoding/decoding across Rust, Python, Go,
  JS, Java, and C. Use when expanding binary analysis coverage or building
  cross-language validation harnesses.
---

# Extend DMZ mmap Scan to Full 36GB pages.bin

**Priority:** MEDIUM
**Area:** DMZ
**Status:** Pending
**Source:** plan.org

## Current Results (200MB scan only)

| Metric                          | Value      |
|---------------------------------+------------|
| Total 0xD8 bytes                | 61,612     |
| Total 0x2A bytes                | 183,426    |
| 0xD8 → 0x2A transitions         | 9,331      |
| Markov P(0x2A | 0xD8)           | 0.151448   |

All 9,331 DAG-CBOR CID signatures follow the CARv1 pattern:
```
0x65 "roots" → 0x81 (array-1) → 0xD8 0x2A (tag 42) → 0x58 (bytes) → CID body
```

## Goal

Scan the full 36GB pages.bin to find ALL CID signatures across the entire
IPLD store. Expected: 100K+ additional transitions.

## How to Run

```bash
cd /mnt/data1/time-2026/06-june/letta-unified

# Current: only scans first 200MB
./target/release/cargo-vendormod cid-scan /mnt/data1/dasl-cache/pages.bin

# Target: scan full file (may need chunked reading for 36GB)
# Consider: mmap with 1GB chunks, or streaming scan
```

## Cross-Language Round-Trip Harness

Build per-language fuzz harnesses that:
1. Encode a CID in Rust → verify 0xD8 0x2A bytes
2. Decode those bytes in Python/Go/JS/Java/C
3. Verify the decoded CID matches the original
4. Store hits in IPLD shmem as DAG-CBOR

```bash
# Example (Rust → Python):
# 1. Rust: Cid::new_v1(DRISL, sha256(data)) → encode → 0xD8 0x2A ...
# 2. Python: cbor2.loads(bytes) → CBORTag(42, cid_bytes) → verify
# 3. Store witness in IPLD shmem
```

## Depends On

Nothing — this is a leaf task.

## Blocks

Nothing directly.
