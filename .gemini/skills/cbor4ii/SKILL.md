---
name: "cbor4ii"
description: "Work with the cbor4ii CBOR parser — the low-level CBOR engine used by serde_ipld_dagcbor. Use when modifying CBOR parsing internals, debugging CBOR encoding issues, or analyzing the CBOR→DAG-CBOR restriction layer."
---

# cbor4ii — CBOR Parser Engine

**Version:** 0.2.14 (used by serde_ipld_dagcbor 0.6.4)
**Role:** Low-level CBOR parser. Handles major type discrimination,
integer encoding, string/bytes length prefixes, array/map headers,
and tag decoding. No DAG-CBOR restrictions — that's added by serde_ipld_dagcbor.

## Relationship

```
serde_ipld_dagcbor (2071 lines)     ← DAG-CBOR restrictions + serde integration
└── cbor4ii (0.2.14)                ← CBOR wire format parsing
    ├── core::dec                    ← Decoder trait + implementations
    ├── core::enc                    ← Encoder trait + implementations
    ├── core::major                  ← Major type constants (0-7)
    ├── core::types                  ← CBOR type definitions
    └── core::utils                  ← SliceReader, IoReader
```

## What cbor4ii Handles

| Layer | Responsibility |
|-------|---------------|
| Major types | uint(0), nint(1), bytes(2), text(3), array(4), map(5), tag(6), simple(7) |
| Additional info | Length encoding: direct(0-23), 1-byte(24), 2-byte(25), 4-byte(26), 8-byte(27) |
| Integers | Positive (major 0), negative (major 1), fixint (-24..23) |
| Strings/Bytes | Definite length only (indefinite is valid CBOR but not DAG-CBOR) |
| Tags | Any tag value (serde_ipld_dagcbor restricts to 42 only) |
| Floats | f16, f32, f64 (serde_ipld_dagcbor restricts to f64 only) |

## cbor4ii_nonpub.rs

`serde_ipld_dagcbor` accesses cbor4ii internals via `cbor4ii_nonpub.rs`:
- `marker()` — peek at the next CBOR item without consuming it
- `peek_one()` — inspect next item type
- `pull_one()` — consume next item

These are used for the DAG-CBOR restriction enforcement layer.

## Build

cbor4ii is a transitive dependency — built automatically when compiling
serde_ipld_dagcbor. No direct build needed.

## Key Files (in registry)

```
~/.cargo/registry/src/<hash>/cbor4ii-0.2.14/
├── src/
│   ├── core/
│   │   ├── dec.rs    ← Deserialization from CBOR bytes
│   │   ├── enc.rs    ← Serialization to CBOR bytes
│   │   ├── major.rs  ← Major type constants
│   │   └── types.rs   ← CBOR type definitions
│   └── serde/
│       ├── de.rs     ← Serde Deserializer impl
│       └── ser.rs    ← Serde Serializer impl
```

## Guardrails

- cbor4ii is a general CBOR parser — it accepts non-DAG-CBOR encodings
- DAG-CBOR restrictions must be enforced by the consumer (serde_ipld_dagcbor)
- Do not modify cbor4ii directly — patches go upstream
- The `cbor4ii_nonpub.rs` access is fragile — check cbor4ii version compatibility
