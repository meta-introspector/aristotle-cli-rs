---
name: "ipld-car-shmem"
description: "Operate the ipld-car-ipc-shmem-linux server — start, stop, warm, query, and monitor the CAR page shared memory ring buffer. Use when managing the DAG-CBOR memory cache, warming DASL files, or querying CAR pages by CID."
---

# ipld-car-shmem — CAR Page Shared Memory Server

Operate the content-addressable shared memory server for DAG-CBOR CAR pages.

## Server

**Location:** `~/dasl/ipld-car-ipc-shmem-linux/`

```bash
# Start server (foreground)
cargo run --bin ipld-car-shmem-server

# Start server (background)
./target/release/ipld-car-shmem-server &
# → Listening on @ipld_car_shmem
# → Cache: /mnt/data1/dasl-cache/pages.bin (36GB)

# Check if running
dasl-shmem-client stats
```

## Client Commands

```bash
# Warm: walk directory, wrap files as CAR pages, store in server
dasl-shmem-client warm ~/dasl
dasl-shmem-client warm ~/dasl --max 65536  # only files ≤ 64KB

# Query: get CAR page by CID
dasl-shmem-client get <64-char-hex-cid>

# List all CIDs
dasl-shmem-client ls

# Server stats
dasl-shmem-client stats
# → { "capacity": 38654705664, "used": 524288000, "pages": 8900, ... }

# Shutdown
dasl-shmem-client shutdown
```

## Integration Points

- **Pastebin** — `CarShmemClient::connect()` in git_mount.rs
- **Nora** — `CarShmemStorage` backend in nora-registry/src/storage/
- **deep_scanner** — reads file content from CAR pages, writes analysis results
- **LibAFL fuzzers** — read/write CBOR test cases as CAR pages

## Architecture

Each page = one CARv1 file = one DAG-CBOR object.
CID = CAR root CID = sha256(root_block_dag_cbor).
Protocol: LibAFL wire format (postcard + fd passing).
Storage: 36GB mmap sparse file, CID-indexed ring buffer.
Socket: @ipld_car_shmem (Unix abstract namespace).

## Troubleshooting

```bash
# Server won't start — check port
ss -xln | grep ipld_car_shmem

# Cache full — check usage
dasl-shmem-client stats | jq .used

# Build from source
cd ~/dasl/ipld-car-ipc-shmem-linux
cargo build --release

# Nix build
nix build ~/dasl/ipld-car-ipc-shmem-linux
```

## Vendormod Usage

cargo-vendormod uses the IPLD CAR shmem server for:
- `shmem_put()` in `src/utils.rs` — stores file samples, scan results, and
  registry metadata under the `vendormod/` prefix
- `handle_ingest` — stores submodule Cargo.toml contents keyed by submodule name
- `deep-scan` — writes Hecke/entropy/CID analysis results as CAR pages
- `scan-index` — stores file samples (head+tail+middle+conformal) under 1MB cap

See [[cargo-vendormod]] for the full vendormod architecture.
