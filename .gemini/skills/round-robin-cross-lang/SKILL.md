---
name: "round-robin-cross-lang"
description: "Run round-robin comparison with dag-cbrrr, go-ipld-cbor, and js-dag-cbor beyond the current n0_dasl vs serde_ipld_dagcbor test. Use when expanding cross-language divergence testing, verifying map_keys/tags/indefinite/floats/ integer_range categories, or building multi-language conformance evidence."
---

# Round-Robin Cross-Language Divergence Testing

**Priority:** HIGH
**Area:** Divergence
**Status:** Pending (blocked by fix-rust001-min-len)
**Source:** status.org

## Current State

93 unique inputs tested (n0_dasl vs serde_ipld_dagcbor only):
- 60 total divergences: 32 HIGH (decode), 28 LOW (canonicalization)
- Both implementations accept non-canonical CBOR and re-encode canonically
- Both correctly reject: truncated CID, missing null byte, hash mismatches

## Goal

Expand to 5+ implementations:
- dag-cbrrr (Python, strict DAG-CBOR)
- go-ipld-cbor (Go)
- js-dag-cbor (JavaScript)
- c-cbor (C, zcbor)
- java-cbor-remoting (Java)

## Remaining Divergence Categories

| Category      | Count | Description                      |
|---------------|-------|----------------------------------|
| map_keys      |     3 | Map key ordering/type enforcement |
| tags          |     3 | Non-42 tag handling               |
| indefinite    |     4 | Indefinite-length encoding         |
| floats        |    12 | NaN/Infinity, float precision      |
| integer_range |     3 | BigInt handling                    |

## How To Run

```bash
cd ~/dasl/dasl-testing

# Current (2 impls):
python3 round_robin.py --inputs fixtures/cbor --impls n0_dasl,serde_ipld_dagcbor

# Target (5+ impls):
python3 round_robin.py --inputs fixtures/cbor --impls n0_dasl,serde_ipld_dagcbor,dag-cbrrr,go-ipld-cbor,js-dag-cbor
```

## Build Drivers

```bash
cd ~/dasl/dasl-testing/harnesses
# Build round-robin binaries for each language
make -C harnesses
```

## Depends On

- fix-rust001-min-len (fix the bug before re-testing)

## Blocks

Nothing directly.
