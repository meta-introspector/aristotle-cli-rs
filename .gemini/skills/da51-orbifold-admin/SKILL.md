---
name: da51-orbifold-admin
description: >-
  DA51 Orbifold Arrow Matrix — Monster group (71×59×47)² combinatorial space,
  Bott/AZ folding, admin panel for model creation/save/share. Use when building
  the orbifold memstore, ingesting Cargo.toml dependency graphs, folding arrow
  matrices, or deploying the DA51 admin dashboard.
---

# DA51 Orbifold — Arrow Matrix & Admin Panel

The orbifold is a sparse bitmask over the combinatorial space of the
Monster group's smallest non-trivial representation.

```
N   = 71 × 59 × 47 = 196,883
N²  = 38,764,092,889 possible arrows (directed morphisms)
```

Each cell is an `Arrow` from one `OrbifoldCoord` to another.
Only active dependency edges are stored (sparse: 21K / 38.7B = 0.00000055%).

## File structure

```
dasl-tiles-rust/src/
├── orbifold.rs        # OrbifoldCoord, Arrow, ArrowMatrix, fold_mod
├── cargo_graph.rs     # Cargo.toml → orbifold ingest, CargoGraph
├── server.rs          # Routes: /admin, /menu, /tile/da51/*, /tile/nginx/*
└── bin/
    └── ingest-cargo-graph.rs   # CLI bulk ingester
```

## Core types

### OrbifoldCoord

```rust
pub struct OrbifoldCoord {
    pub x: u8,  // 0..71
    pub y: u8,  // 0..59
    pub z: u8,  // 0..47
}
```

Methods: `linear()`, `from_linear(idx)`, `from_hash(&[u8])`, `neighbors()`, `da51_prefix()`

### Arrow

```rust
pub struct Arrow {
    pub src: OrbifoldCoord,
    pub dst: OrbifoldCoord,
    pub hecke: u8,   // Hecke weight (0..71)
    pub bott: u8,    // Bott periodicity (0..7)
    pub flags: u8,   // active | verified | cached
}
```

### ArrowMatrix — Sparse CSR bitmask

Stores only active arrows (not the 38.7B cells). Uses a sorted `membership` vec
for O(log n) lookup and a `rows` HashMap for outgoing edges.

```rust
let mut m = ArrowMatrix::new();
m.put(Arrow::new(src, dst));
m.has(src, dst);              // O(log n)
m.outgoing(src);              // all arrows from src
m.fold_mod(8);                // → [count0, count1, ..., count7]
m.fold_bott_az();             // → {8: [...], 10: [...]}
```

## Cargo.toml Dependency Graph

### Bulk ingest

```bash
cargo run --release --bin ingest-cargo-graph \
  ~/dasl/index/cargo_toml.txt \
  ~/dasl/IMPL/users/atproto/atproto_repos
```

Results: **2,643 crates · 21,341 dependency arrows** mapped into the orbifold.

### Folding

```
mod 8  (Bott periodicity): ~2,667 arrows/bucket (±4%)
mod 10 (AZ tenfold):       ~2,134 arrows/bucket (±3%)
```

The uniform distribution confirms healthy DA51 hash addressing.

## Tile-Server Routes

| Route | Description |
|-------|-------------|
| `/` | → redirects to /menu |
| `/menu` | Main menu with all tile cards |
| `/webview` | Tile gallery (harnesses, eBPF, infra, orbifold) |
| `/admin` | DA51 Admin Panel — Bott/AZ bar charts, model CRUD |
| `/tile/da51/orbifold` | JSON: N, N², crates, arrows, sparsity, folds |
| `/tile/da51/fold` | JSON: Bott 8 + AZ 10 bucket vectors |
| `/tile/nginx/errors` | Color-coded nginx error log (last 200 lines) |
| `/tile/nginx/access` | Color-coded nginx access log (last 200 lines) |
| `POST /admin/models` | Save model to `/dev/shm/da51-models/` |

## Admin Panel Features

- **Bar charts** — Bott (purple) + AZ (blue) fold distributions
- **Model creator** — name, description, auto-captures orbifold state
- **Save** → `/dev/shm/da51-models/<name>.json` (shared memory)
- **Share** → copies URL with params for sharing
- **Clear** → localStorage wipe
- **Nginx error log** — embedded live view (last 50 lines, auto-refresh 10s)
- **Nginx access log** — embedded live view (color-coded by HTTP status)

## Nginx Proxy Configuration

All public routes proxied through `solana.solfunmeme.com` (port 18090):

```nginx
location ^~ /tiles/     { proxy_pass http://127.0.0.1:18090/tiles; }
location ^~ /tile/      { proxy_pass http://127.0.0.1:18090/tile/; }
location ^~ /webview    { proxy_pass http://127.0.0.1:18090/webview; }
location ^~ /admin      { proxy_pass http://127.0.0.1:18090/admin; }
location ^~ /menu       { proxy_pass http://127.0.0.1:18090/menu; }
location = /            { return 302 /menu; }
location = /favicon.ico { return 204; }  # silences 93% of error logs
```

Managed via `system-manager.nix` in the dasl-tiles-rust worktree.

## Deploy

```bash
cd dasl-tiles-rust/
bash deploy.sh deploy    # cargo build + systemd restart
bash deploy.sh status    # diagnostic
```

Service: `dasl-tiles-rust` (port 18090, system-manager target)

## Key Files

| File | Purpose |
|------|---------|
| `src/orbifold.rs` | OrbifoldCoord, Arrow, ArrowMatrix, fold_mod |
| `src/cargo_graph.rs` | CargoGraph, CargoTomlEntry, bulk ingest |
| `src/bin/ingest-cargo-graph.rs` | CLI for bulk Cargo.toml → orbifold |
| `src/server.rs` | All tile-server routes + handlers |
| `system-manager.nix` | Nginx + systemd config |
| `deploy.sh` | Build + deploy script |

## References

- Monster group dimension: 71×59×47 = 196,883
- Bott periodicity: mod 8 (resonance classes 0–7)
- Altland-Zirnbauer tenfold: mod 10 (topological symmetry classes)
- DA51 prefix: `da51:{xx}{yy}{zz}` — 3-byte hex orbifold address
