---
name: ipld-core
description: >-
  Work with the IPLD core types crate — the Ipld enum, CID handling,
  codec trait, and dependency audit. Use when modifying, upgrading, or
  fuzzing libipld-core or any crate that depends on ipld_core::ipld::Ipld.
---

# ipld-core — IPLD Core Types Crate

**Location:** `~/dasl/rust/ipld-core/`
**Version:** 0.4.3
**Lines:** 1333 across 8 source files
**Dependencies:** 3 direct (cid, hex, thiserror), 14 total

## Core Type: `Ipld` enum (ipld.rs, 399 lines)

```rust
pub enum Ipld {
    Null, Bool(bool), Integer(i128), Float(f64),
    String(String), Bytes(Vec<u8>),
    List(Vec<Ipld>), Map(BTreeMap<String, Ipld>),
    Link(Cid),  // ← content-addressing primitive
}
```

9 variants. Direct mapping to IPLD data model. `Link(Cid)` is the only
way to reference other IPLD nodes.

## Key Files

| File | Lines | What |
|------|-------|------|
| `ipld.rs` | 399 | Ipld enum + Index impl + iteration |
| `convert.rs` | 348 | Into/From between Ipld and Rust types |
| `macros.rs` | 291 | `ipld!` macro for literal construction |
| `lib.rs` | 37 | Re-exports: cid, codec, serde, error |

## Build

```bash
cd ~/dasl/rust/ipld-core
cargo build --release     # 3.7s → liblibipld_core.rlib
nix build --file flake-lib.nix
```

## Feature Flags

- `std` (default) — `Error: std::error::Error`, `Codec` trait
- `codec` (default) — `Codec`, `Encode`, `Decode`, `Links`, `References`
- `serde` — Serde serialization for `Ipld` enum
- `arb` — QuickCheck arbitrary instances

## Dependencies (audited)

All 14 deps audited. See `DOCS/dasl/crates/ipld-core-deps.md`.
Zero unsafe code. All no_std compatible (except proc-macros, compile-time only).

## Fuzzing

Existing flake.nix sets up honggfuzz + AFL + bolero + ziggy.
Fuzz targets in `fuzz/`. Build: `nix build` (not flake-lib.nix).

## Guardrails

- `Ipld` is not inherently a DAG — cycles possible at enum level
- CID version must be v1 (raw codec + sha256 hash)
- Do not modify the `__private_do_not_use` module — macro hygiene
- Link variant always carries tag 42 when serialized to DAG-CBOR
