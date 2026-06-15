---
name: serde-ipld-dagcbor
description: >-
  Work with the DAG-CBOR codec — deterministic CBOR serialization with
  canonical map ordering, f64-only floats, and CID tag 42 enforcement.
  Use when modifying the serde_ipld_dagcbor codec or debugging DAG-CBOR
  encoding/decoding issues.
---

# serde-ipld-dagcbor — DAG-CBOR Codec

**Location:** `~/dasl/rust/serde_ipld_dagcbor/`
**Version:** 0.6.4
**Lines:** 2071 across 6 source files
**Dependencies:** 4 direct (cbor4ii, ipld-core, serde, scopeguard)

## API

```rust
// Serialize
let bytes = serde_ipld_dagcbor::to_vec(&value)?;
// Deserialize
let value = serde_ipld_dagcbor::from_slice::<T>(&bytes)?;
```

## Key Files

| File | Lines | What |
|------|-------|------|
| `de.rs` | 884 | CBOR bytes → Rust types, DAG-CBOR enforcement |
| `ser.rs` | 699 | Rust types → DAG-CBOR bytes, canonical ordering |
| `error.rs` | 256 | EncodeError and DecodeError types |
| `lib.rs` | 148 | DAG_CBOR_CODE (0x71), CBOR_TAGS_CID (42) |

## DAG-CBOR Restrictions

| Restriction | Where | Why |
|-------------|-------|-----|
| Tag 42 for CIDs | de.rs:214, ser.rs:552 | DAG-CBOR spec for content-addressed links |
| f64-only floats | ser.rs:127, de.rs:370 | Deterministic encoding |
| Finite floats only | ser.rs:133 | NaN/Infinity not content-addressable |
| Canonical map key order | ser.rs:421-471 | Keys sorted length→lexicographic |
| String keys only | ser.rs:470 | No integer keys in maps |
| No indefinite-length | cbor4ii level | Explicit lengths only |
| No duplicate keys | ser.rs:467 | Sort guarantees uniqueness |

## Build

```bash
cd ~/dasl/rust/serde_ipld_dagcbor
cargo build --release  # ~20s
cargo test
```

## CID Serialization

```
Tag 42 (0xD8 0x2A)
  + CBOR bytes: [version 0x01][codec 0x55=raw][multihash: 0x12 sha256 0x20 <32 bytes>]
  = 38 bytes per CID (sha256)
```

## Key Invariants

1. **Deterministic:** `from_slice(&to_vec(&value)?)? == value`
2. **Byte-identical across versions** — same input always same bytes
3. **DAG-CBOR ⊂ CBOR** — strict subset
4. **Tag 42 is the only allowed tag** — all other tags rejected
5. **Floats always 8 bytes** — f16/f32 rejected on deser, never produced

## Where Used

- `deep_scanner` — serializes analysis output with `to_vec()`
- `ipld-car-ipc-shmem-linux` — CAR pages contain DAG-CBOR
- `n0_dasl` — DASL reference implementation
- `dasl-testing` — cross-implementation test harness
