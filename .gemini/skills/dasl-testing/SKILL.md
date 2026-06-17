---
name: "dasl-testing"
description: "Run the DASL cross-implementation fuzzing harness — 27 CBOR/DAG-CBOR implementations × 7 fuzzing engines across 13 languages. Use when setting up fuzz campaigns, running round-robin comparison, analyzing crash data, deploying services via system-manager, or launching the TUI dashboards."
---

# dasl-testing — Cross-Implementation Fuzzing

**Location:** `~/dasl/dasl-testing/`
**Scope:** 27 harnesses × 7 engines × 13 languages
**Nix flake:** `~/dasl/dasl-testing/flake.nix`
**Git mirror:** `~/git/github.com/meta-introspector/dasl-testing.git`

## Nix Build (flakes)

The root flake builds all Rust harnesses and Python services as nix packages:

```bash
cd ~/dasl/dasl-testing

# Lock and build all services
nix flake lock
nix build .#  # default = all services

# Individual services
nix build .#serdeIpldDagcbor   # serde_ipld_dagcbor service binary
nix build .#libipld            # libipld service binary
nix build .#n0Dasl             # n0_dasl service binary
nix build .#pythonService      # Python dag-cbrrr service
nix build .#gateway            # Orchestration dashboard

# C CBOR round-robin binaries
nix build .#rr-tinycbor .#rr-libcbor .#rr-qcbor
nix build .#c-cbor-all         # All 7 C round-robin testers
```

### Libipld Harness (vendored deps)

The libipld harness has 46MB of vendored crate dependencies for pure sandbox build:

```bash
cd ~/dasl/dasl-testing/harnesses/libipld
nix build .#  # Uses cargoVendorDir = "vendor"
```

**Flake pattern:** `cargoVendorDir = "vendor"` — avoids crates.io network fetches.
The harness uses `cargoBuildFlags = [ "--bin service" ]` to build only the service binary.

**Edition 2024 note:** Uses `edition = "2024"` (Cargo.toml). Requires a nixpkgs
with rustc ≥ 1.85. If you see `"this version of Cargo is older than the '2024' edition"`,
update nixpkgs or use rust-overlay.

### Nora Cargo Config

Rust harnesses that can't vendor deps use a preBuild hook with nora registry:

```nix
preBuild = ''
  mkdir -p .cargo
  cat > .cargo/config.toml << 'NORA_EOF'
  [source.crates-io]
  replace-with = "nora"

  [source.nora]
  registry = "http://127.0.0.1:4000/cargo/index"
  NORA_EOF
'';
```

**Gotcha:** This requires `--impure` in nix build (network to nora).
Pure eval requires vendored deps.

## Cargo Build (direct)

```bash
cd ~/dasl/dasl-testing

# Build one harness
cd harnesses/serde_ipld_dagcbor && cargo build --release

# Build round-robin
cd harnesses/rust-cbor && cargo build --release --bin rr_cbor4ii
```

## System-Manager Deployment

Services defined in `~/dasl/dasl-testing/system-manager-config.nix`:

```bash
# Deploy via dasl-testing flake directly
sudo $(nix build ~/dasl/dasl-testing#systemConfigs.dasl-tiles --print-out-paths)/bin/activate

# Or via dasl-planning aggregate flake
sudo $(nix build ~/dasl-planning#systemConfigs.all-services --print-out-paths)/bin/activate
```

### Current Service Status

| Service | Port | Type | Deploy |
|---------|------|------|--------|
| serde-ipld-dagcbor | 18007 | Rust (service binary) | nix build .#serdeIpldDagcbor |
| n0-dasl | 18009 | Rust (service binary) | nix build .#n0Dasl |
| libipld | 18011 | Rust (vendored, edition 2024) | separate flake |
| dag-cbrrr | 18001 | Python | nix build .#pythonService |
| gateway | 18100 | Python | nix build .#gateway |

### Python Tile Servers (separate)

The nagios, deploy, vendormod, port-registry, and fuzz-team tile servers are
Python scripts vendored in `~/dasl-planning/tile-servers/`:

```bash
nix build ~/dasl-planning#nagios-tile
nix build ~/dasl-planning#deploy-tile
```

---

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

# Interactive tile browser
cargo run --release --bin tile-tui
cargo run --release --bin tile-tui -- --demo

# Performance dashboard
cargo run --release --bin perf-tile-tui
cargo run --release --bin perf-tile-tui -- --demo
```

### eBPF Monitoring Tiles

```bash
cargo run --release --bin tile-mothership -- ebpf://d8-2a/diagnostic
cargo run --release --bin tile-mothership -- ebpf://d8-2a/status
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

## Guardrails

- Round-robin tests expect byte-identical output across implementations
- CAR files must be DAG-CBOR encoded
- CDDL spec at `dag_cbor_json.cddl` is the authority
- Crash data goes to `collected_afl_data/`
- TUI binaries are in `~/projects/dasl-tiles-rust/target/release/`
- Pure eval builds need `cargoVendorDir`, not `cargoLock.lockFile`
- Edition 2024 requires rustc ≥ 1.85 (use rust-overlay)
