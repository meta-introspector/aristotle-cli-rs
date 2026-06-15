---
name: dasl-testing
description: >-
  Run the DASL cross-implementation fuzzing harness — 27 CBOR/DAG-CBOR
  implementations × 7 fuzzing engines across 13 languages. Use when setting
  up fuzz campaigns, running round-robin comparison, analyzing crash data,
  or launching the TUI dashboards (tile-tui, perf-tile-tui).
---

# dasl-testing — Cross-Implementation Fuzzing

**Location:** `~/dasl/dasl-testing/`
**Scope:** 27 harnesses × 7 engines × 13 languages

## Harness Targets

### Rust
| Harness | Fuzz engines |
|---------|-------------|
| `libipld` | honggfuzz, bolero, fuzzcheck, libafl, libfuzzer, siderophile, ziggy |
| `serde_ipld_dagcbor` | same 7 |
| `n0_dasl` | same 7 |
| `rust-cbor` (4 libs) | same 7 + round-robin |

### Other Languages
`go-dasl`, `go-ipld-cbor`, `boxo`, `c-cbor`, `cpp-glaze`,
`java-dag-cbor`, `js`, `python`, `python-ipld-core`

## Build

```bash
cd ~/dasl/dasl-testing

# Build one harness
cd harnesses/serde_ipld_dagcbor && cargo build --release

# Build round-robin
cd harnesses/rust-cbor && cargo build --release --bin rr_cbor4ii
```

## Run Fuzzing

```bash
# Honggfuzz
cd harnesses/serde_ipld_dagcbor/fuzz
cargo hfuzz run fuzz_target_1

# LibAFL
cd harnesses/serde_ipld_dagcbor/fuzz-libafl
cargo run --release

# Round-robin (cross-implementation comparison)
cd harnesses/rust-cbor
cargo run --release --bin rr_cbor4ii
```

## CAR File Operations

```bash
# Extract blocks from CAR
python car_reader.py file.car ./extracted/

# Aggregate into master CAR
python create_master_car.py

# Collect crash data
python collect_afl_data.py
```

## Round-Robin Testing

Cross-implementation comparison:
- `rr_cbor4ii` — cbor4ii ↔ other libs
- `rr_ciborium` — ciborium ↔ other libs
- `rr_minicbor` — minicbor ↔ other libs
- `rr_serde_cbor` — serde_cbor ↔ other libs

Pattern: encode A → decode B → re-encode → compare bytes.

## Integration

- `campaign.sh` — orchestrates full fuzz campaign
- `crash_inventory.json` — crash database
- Service binaries connect to `@ipld_car_shmem`
- CAR corpus feeds test vectors via shared memory

## TUI Dashboards (via dasl-tiles-rust)

```bash
cd ~/projects/dasl-tiles-rust

# Interactive tile browser — navigate harnesses, run syscalls, view pipelines
cargo run --release --bin tile-tui
cargo run --release --bin tile-tui -- --demo

# Performance dashboard — 27 impls across 13 languages
cargo run --release --bin perf-tile-tui
cargo run --release --bin perf-tile-tui -- --demo
```

### eBPF Monitoring Tiles

The eBPF loader exposes D8-2A detection as tiles:

```bash
# Diagnostic check (permissions, kernel lockdown)
cargo run --release --bin tile-mothership -- ebpf://d8-2a/diagnostic

# Monitoring status
cargo run --release --bin tile-mothership -- ebpf://d8-2a/status

# Captured hits (requires sudo to run monitoring)
cargo run --release --bin tile-mothership -- ebpf://d8-2a/hits
```

### All Implementations (27)

| Lang | Implementations |
|------|----------------|
| rust | serde_ipld_dagcbor, libipld, n0_dasl, rust-cbor |
| python | dagcbrrr, libipld, ipld-core |
| js | helia, atcute |
| go | go-ipld-cbor, go-dasl, boxo |
| java | java-dag-cbor |
| c | tinycbor, libcbor, zcbor, qcbor, cncbor, libcbrrr |
| cpp | glaze |
| lisp | cl-cbor, cl-dag-cbor |
| haskell | hs-cbor, hs-ipld |
| lean4 | lean4-cbor |
| fractran | fractran-cbor |
| ocaml | ocaml-cbor, ocaml-ipld |
| scheme | racket-cbor, guile-cbor |

### Syscall Operations

Each harness exposes 3 syscall tiles:
- `roundtrip` — encode then decode, verify byte equality
- `decode-only` — parse CBOR bytes, check for panics
- `invalid-encode` — attempt encode of invalid data

### Pipeline DAG

```
corpus → [roundtrip@all 27 impls] → cross-check → report
```

## Guardrails

- Round-robin tests expect byte-identical output across implementations
- CAR files must be DAG-CBOR encoded
- CDDL spec at `dag_cbor_json.cddl` is the authority
- Crash data goes to `collected_afl_data/`
- TUI binaries are in `~/projects/dasl-tiles-rust/target/release/`
