---
name: "dasl-tiles-publication"
description: "Self-publishing DASL tile registry with stable identities, immutable versions, proof artifacts, and IPLD service references. Implements the tile publication protocol: stable ID → latest pointer → immutable version → manifest + .so + proof. Use when publishing tiles, updating tile versions, resolving stable IDs, or managing the tile discovery list."
---

# DASL Tiles Publication

> Self-publishing content-addressed tile registry.
> Protocol: stable ID → latest pointer → immutable version → .so + proof.

## When to Use

- Publishing a new tile to the DASL registry
- Updating a tile to a new version (shadows old, preserves history)
- Attaching proof artifacts (zkp, signature, attestation, audit) to tile versions
- Setting IPLD service references (.so CID + endpoint)
- Resolving stable tile IDs to latest versions
- Querying publication history and version audit trails
- Managing the tile discovery list

## Architecture

### Tile Protocol

```
Discovery List (stable tile IDs only)
    │
    └──► StablePointer (tile_id → latest_version_id)
            │
            └──► ImmutableVersion (version_id, parent, content_hash, resources)
                    │
                    ├──► TileManifest (title, description, endpoints)
                    ├──► IpldService (so_cid, so_car_path, endpoint)
                    ├──► TileProof (proof_kind, proof_cid, status)
                    └──► VersionHistory (all previous versions preserved)
```

### Deployment (per-project system-manager)

```
~/projects/dasl-tiles-rust/         # tile registry + server
├── flake.nix                        # crane build
├── system-manager-config.nix        # systemd + nginx proxy (:8088)
├── deploy.sh                        # build → activate → diagnose
└── tiles.d/                         # TOML tile store
    ├── etc-services.toml            # /etc/services registry
    ├── service-*.toml               # 22 Monster CFT service tiles
    ├── port-registry.toml           # port registry dashboard tile
    ├── nora.toml / nginx.toml       # control tiles
    └── nginx-*.toml                 # 56 nginx topology tiles
```

### Live Tiles

| Tile | Port | URL | Status |
|------|------|-----|--------|
| port-registry | 8820 | `/tile/ports/` | ✅ LIVE |
| nagios-monitor | 8800 | `/tile/nagios/` | ✅ LIVE |
| deploy-tile | 8810 | `/tile/deploy/` | ✅ LIVE |
| diagonalize-tile | 8082 | `/tile/diagonalize/` | ✅ LIVE |

No more `~/pastebin` monolith. Each project deploys independently.

## Core Types

### StableIdentity
```rust
StableIdentity {
    tile_id: "serde_ipld_dagcbor",
    category: "http-tile",
    owner: "dasl",
    stable_address: "da51://tiles/serde_ipld_dagcbor"
}
```
Never changes. Always resolves to latest version.

### ImmutableVersion
```rust
ImmutableVersion {
    version_id: "da51://tiles/serde_ipld_dagcbor/v1",
    parent_version_id: None,
    content_hash: "sha256:abc123...",
    resource_urls: ["/decode", "/roundtrip"],
    created_at: "2026-06-06T..."
}
```

### IpldService
```rust
IpldService {
    so_ipld: "ipld://bafy.../libtile.so",
    so_cid: "bafyabc123",
    so_car_path: "tiles/serde_ipld_dagcbor/v1/libtile.so",
    abi_version: "1.0",
    glibc_target: "x86_64-linux-gnu",
    endpoint: Some("http://127.0.0.1:18007")
}
```

### TileProof
```rust
TileProof {
    proof_ipld: "da51://proofs/serde_ipld_dagcbor/v1",
    proof_cid: "bafyproof456",
    proof_kind: "zkp",          // zkp | signature | attestation | audit
    proof_subject: "tile.serde_ipld_dagcbor.v1.roundtrip",
    status: "valid"             // valid | invalid | pending
}
```

## Rust API

```rust
use dasl_tiles::tile::Tile;
use dasl_tiles::resolver::TileRegistry;
use dasl_tiles::publisher::TilePublisher;

// Create a publisher
let mut pubr = TilePublisher::new();

// Register a new tile (v1)
pubr.create_tile("my-tile", "http-tile", "dasl", "My Tile", "Description")?;

// Publish v2 (shadows v1, keeps history)
pubr.update_tile("my-tile")?;

// Attach proof
pubr.attach_proof("my-tile", "bafyproof1", "zkp", "tile.my-tile.v2.roundtrip")?;

// Set IPLD service
pubr.set_service("my-tile", "bafyso1", Some("http://127.0.0.1:8095"))?;

// Query registry
let tile = pubr.registry().resolve("my-tile")?;
assert_eq!(pubr.registry().version_count("my-tile")?, 2);

// Publication history
let events = pubr.publication_history("my-tile");
// → [Created, ProofAttached, Updated, Created...]
```

## HTTP API (via zombie-cft-tile)

```bash
# Publish
curl -X POST https://solana.solfunmeme.com/zombie-cft/publish \
  -H 'Content-Type: application/json' \
  -d '{"tile_id":"my-tile","title":"My Tile","description":"A tile"}'

# Update to new version
curl -X POST https://solana.solfunmeme.com/zombie-cft/publish \
  -H 'Content-Type: application/json' \
  -d '{"tile_id":"my-tile","title":"My Tile","action":"update"}'

# View registry
curl https://solana.solfunmeme.com/zombie-cft/registry
```

## Publication Events (ISO 9001 Traceable)

| Event | Trigger | Preserves |
|-------|---------|-----------|
| `Created` | New tile registered | — |
| `Updated` | New version published | Old version in history |
| `ProofAttached` | Proof artifact attached | Previous proof (if any) |
| `ServiceUpdated` | IPLD service ref set | Previous service ref |
| `Deprecated` | Tile marked deprecated | Version history |

## Version Shadowing Rule

1. Publish new immutable version object first
2. Publish .so object and proof if changed
3. Update stable pointer to new version
4. Old version remains addressable by its immutable ID
5. Default lookup returns latest; explicit version queries work for history

## Tests

```bash
cd zombie_driver2
cargo test -p dasl-tiles
# 15 tests: tile types (7), resolver (5), publisher (3)
```

## Related Skills

- [[skills/zombie-cft-tile]] — CFT tile server (browser + API)
- [[skills/dasl-tiles]] — DASL tile system, TUI clients
- [[skills/dasl-tile-onboarding]] — Tile creation and IPLD storage
- [[skills/ipld-car-shmem]] — IPLD CAR server operations
- [[skills/ipld-compiler-thoughts]] — Shared compiler thought store
