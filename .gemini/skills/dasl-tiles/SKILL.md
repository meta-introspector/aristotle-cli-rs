---
name: "dasl-tiles"
description: "DASL tile system — load, render, and publish content-addressed tiles. Run the tile-tui and perf-tile-tui TUI dashboards. Use when working with tiles, fuzzing harness tiles, performance dashboards, or the IPLD CAR shmem bridge."
---

# dasl-tiles — Tile System & TUI Clients

**Location:** `~/projects/dasl-tiles-rust/`
**Binaries:** `tile-tui`, `perf-tile-tui`, `tile-mothership`
**Scope:** Tile loaders, syscall composition, performance dashboards

## Quick Start

```bash
cd ~/projects/dasl-tiles-rust

# TUI: interactive tile browser (harnesses, syscalls, pipeline DAGs)
cargo run --release --bin tile-tui
cargo run --release --bin tile-tui -- --demo

# TUI: performance dashboard — 27 DAG-CBOR impls across 13 languages
cargo run --release --bin perf-tile-tui
cargo run --release --bin perf-tile-tui -- --demo

# CLI: mothership orchestration
cargo run --bin tile-mothership -- --load-domain dasl.testing load fuzz://python/dagcbrrr
```

## Tile Loaders

| Loader | URL scheme | Backend |
|--------|-----------|---------|
| `IpldCarLoader` | `ipld-car://<path>` | ipld-car-shmem server (`@ipld_car_shmem`) |
| `FuzzHarnessLoader` | `fuzz://<lang>/<impl>` | dasl-testing harnesses |
| `MemoryLoader` | `memory://<key>` | In-memory store |
| `CARLoader` | `car://<file>` / `*.tile` | Local CAR files |
| `ATProtoLoader` | `at://did:plc:...` | AT Protocol |
| `WebXDCLoader` | `webxdc://...` | WebXDC messages |
| `EbpfLoader` | `ebpf://d8-2a/*` | eBPF register hits, diagnostic |
| `Orbifold/CargoGraph` | `da51://orbifold` | Monster group arrow matrix |

## TUI Clients

### tile-tui — Harness Browser

```
┌──────────────┬──────────────────────────┬─────────────────────┐
│ 📦 Pipelines │ ╔══ Tile: python/dagcbrrr │ ▶ Running...       │
│ 📦 Harnesses │ ║ Syscalls:              │   ✓ roundtrip ok   │
│  ├─ python/  │ ║  🔄 roundtrip         │   ✓ decode ok      │
│  ├─ js/      │ ║  📥 decode-only       │   ✗ encode ERR     │
│  ├─ rust/    │ ║  ⚠️ invalid-encode    │                     │
│  └─ ...      │ ╚════════════════════════╝                     │
├──────────────┴──────────────────────────┴─────────────────────┤
│ q:quit ↑↓:nav Enter:sel r:run p:pipeline Tab:focus [Tree ◀]   │
└───────────────────────────────────────────────────────────────┘
```

Keys: `↑↓` navigate, `Enter` select, `r` run syscall, `p` pipeline, `Tab` focus

### perf-tile-tui — Performance Dashboard

Keys: `↑↓` navigate, `s` cycle sort (speed/crashes/coverage/decode), `Tab` focus,
`R/P/J/G/A/C/X/L/H/E/F/O/M` filter by language

## Tile-Server Webview

### Main Menu (`/menu`)

Landing page with all tile cards:
- 🧩 Tile Gallery · 🔮 DA51 Admin · 🖥 eBPF Hits · 📊 Orbifold JSON
- 🎱 Bott/AZ Fold · ✏️ Compose Tile · 💚 Health · 📋 Catalog · 🔧 Diagnostic
- 🚨 Nginx Error Log · 📈 Nginx Access Log

### Admin Panel (`/admin`)

DA51 orbifold admin dashboard:
- Bott(8) and AZ(10) bar charts with live fold data
- Model creation: name, description, auto-captures orbifold state
- Save to `/dev/shm/da51-models/`, share via copy-link
- Embedded nginx error + access log viewers (auto-refresh)

### Nginx Log Tiles (`/tile/nginx/*`)

- `/tile/nginx/errors` — severity color-coded (emerg→red, warn→amber)
- `/tile/nginx/access` — status color-coded (200→green, 404→amber, 5xx→red)
- Both show last 200 lines with total line counts

### Public URLs (via nginx proxy, domain solana.solfunmeme.com)

| Path | Backend |
|------|---------|
| `/` | → 302 /menu |
| `/menu` | Main menu |
| `/webview` | Tile gallery |
| `/admin` | Admin panel |
| `/tile/da51/orbifold` | Orbifold JSON |
| `/tile/da51/fold` | Fold vectors |
| `/tile/nginx/errors` | Error log viewer |
| `/tile/nginx/access` | Access log viewer |
| `/tile/ebpf/d8-2a/hits` | eBPF hit feed |
| `/tile/ebpf/d8-2a/status` | eBPF status |
| `/health-dasl` | Health check |
| `POST /admin/models` | Save model |

## Orbifold Module

### Cargo.toml → Orbifold Mapping

```bash
cargo run --release --bin ingest-cargo-graph
# → 2,643 crates · 21,341 dependency arrows
# → Fold: mod 8 (Bott) ~2,667/bucket, mod 10 (AZ) ~2,134/bucket
```

### Key Types

- `OrbifoldCoord { x: u8, y: u8, z: u8 }` — 71×59×47 torus coordinates
- `Arrow { src, dst, hecke, bott, flags }` — directed morphism
- `ArrowMatrix` — sparse CSR bitmask (21K of 38.7B cells)
- `CargoGraph` — Cargo.toml dependency graph in orbifold space
- `fold_mod(k)`, `fold_bott_az()` — projection into Bott/AZ bases

See skill `da51-orbifold-admin` for full documentation.

## Architecture

```
TileMothership
├── LoaderManager (6 loaders)
├── ShuttleManager → Shuttle (sandboxed rendering)
├── IpldCarClient → @ipld_car_shmem (postcard wire protocol)
├── FuzzHarnessLoader → 27 harnesses as tiles
│   └── Syscall Tiles: roundtrip, decode-only, invalid-encode
│   └── Pipeline DAGs: corpus → N×syscall → cross-check → report
└── IpldCarTileWriter → write tiles into CAR store
```

## Key Files

| File | Purpose |
|------|---------|
| `src/tile.rs` | Core tile types |
| `src/loader.rs` | TileLoader trait + MemoryLoader |
| `src/loader_ipld_car.rs` | IpldCarLoader bridging to CAR shmem |
| `src/ipld_car.rs` | Postcard wire protocol client |
| `src/syscall.rs` | Syscall/Pipeline types for fuzz-as-tile |
| `src/loader_fuzz.rs` | FuzzHarnessLoader (27 harnesses) |
| `src/loader_ebpf.rs` | EbpfLoader — eBPF hits/status/diagnostic tiles |
| `src/orbifold.rs` | OrbifoldCoord, Arrow, ArrowMatrix, fold_mod |
| `src/cargo_graph.rs` | CargoGraph — Cargo.toml → orbifold ingest |
| `src/server.rs` | Tile-server routes + admin/main-menu/log-tile handlers |
| `src/mothership.rs` | TileMothership orchestrator |
| `src/bin/tile-tui.rs` | Interactive tile browser TUI |
| `src/bin/perf-tile-tui.rs` | Performance dashboard TUI |
| `src/bin/ebpf-tile-ui.rs` | eBPF monitoring TUI |
| `src/bin/ingest-cargo-graph.rs` | CLI: Cargo.toml index → orbifold |
| `system-manager.nix` | Nginx + systemd config for deployment |
| `deploy.sh` | Build + deploy script |

## Environment

| Variable | Default | Description |
|----------|---------|-------------|
| `DASL_TESTING_ROOT` | `~/dasl/dasl-testing` | Harness discovery root |

## Building

```bash
cargo build --release              # All binaries
cargo test --lib                   # Library tests
cargo test --bin tile-tui          # TUI tests
cargo test --bin perf-tile-tui     # Perf dashboard tests
```
