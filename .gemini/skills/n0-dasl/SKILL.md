---
name: "n0-dasl"
description: "Work with the n0_dasl crate — DASL reference implementation with custom CID type (SHA-256 + BLAKE3) and DRISL (DAG-CBOR) codec. Use when modifying the DASL reference, comparing with serde_ipld_dagcbor, or setting up cross-implementation fuzzing."
---

# n0-dasl — DASL Reference Implementation

**Location:** `~/dasl/rust/n0_dasl/`
**Version:** 0.2.0
**Lines:** 2621 (440 core + 2181 DRISL codec)
**Crate name:** `dasl`

## Two Components

### 1. Custom CID (cid.rs, 414 lines)
- 36-byte fixed-size CID: 4-byte prefix + 32-byte hash
- Hash support: SHA-256 (0x12) + BLAKE3 (0x1e)
- Codec support: Raw (0x55) + DRISL (0x71)
- Base32 encoding + serde support (tag 42 visitor)

### 2. DRISL Codec (drisl/, 2181 lines)
- DAG-Restricted IPLD Serialization Language = DAG-CBOR with codec 0x71
- Independent implementation based on serde_ipld_dagcbor
- Uses cbor4ii 1.0.0 (newer engine)
- Custom `Value` enum (9 variants, like Ipld but with dasl::Cid)
- Same restrictions: tag 42, f64-only, canonical ordering

## Build

```bash
cd ~/dasl/rust/n0_dasl
cargo build --release    # 3.8s → libdasl.rlib
```

## Key Files

| File | Lines | What |
|------|-------|------|
| `cid.rs` | 302 | Custom Cid type + Codec enum |
| `cid/serde.rs` | 112 | Serde visitor for tag 42 CIDs |
| `drisl/de.rs` | 874 | CBOR bytes → Rust types |
| `drisl/ser.rs` | 682 | Rust types → DAG-CBOR bytes |
| `drisl/value.rs` | 256 | Dynamic Value enum |
| `drisl/error.rs` | 207 | EncodeError + DecodeError |

## vs serde_ipld_dagcbor

| Feature | serde_ipld_dagcbor | n0_dasl |
|---------|-------------------|---------|
| CID type | ipld_core::Cid | dasl::Cid (custom) |
| Hash support | SHA-256 only | SHA-256 + BLAKE3 |
| Value type | ipld_core::Ipld | dasl::drisl::Value |
| cbor4ii version | 0.2.14 | 1.0.0 |
| DAG-CBOR code | 0x71 | 0x71 (same) |
| Wire format | compatible | compatible |

Both produce identical DAG-CBOR bytes for same input.
DRISL is an independent implementation — ideal for cross-fuzzing.

## Guardrails

- DRISL CID is not ipld-core CID — they are different types
- cbor4ii 1.0.0 may have API differences from 0.2.14
- BLAKE3 CIDs are not recognized by ipld-core consumers
- DRISL fuzz targets should compare output with serde_ipld_dagcbor
