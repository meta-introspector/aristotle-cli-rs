---
name: "nora-car-shmem"
description: "Configure and operate the Nora artifact registry with CAR shared-memory storage backend for high-performance, content-addressed artifact storage. Use when setting up Nora to use ipld-car-ipc-shmem-linux as its storage layer instead of local filesystem or S3, or to diagnose its status."
---

# nora-car-shmem — Nora + CAR Shared Memory Storage

Integrate Nora (artifact registry) with ipld-car-ipc-shmem-linux for
content-addressed crate storage.

## Quick Start

Here are some common operations you can perform with this skill:

-   **Check Shared Memory Server Status**:
    ```bash
    /skill:nora-car-shmem check_shmem_server
    ```
    This script verifies if the `ipld-car-shmem-server` is running and displays its statistics.

-   **Configure Nora to use CAR Shared Memory Backend**:
    ```bash
    /skill:nora-car-shmem configure_nora
    ```
    This script helps set up Nora's `config.toml` to use the `car-shmem` storage backend.

## Prerequisite

`ipld-car-shmem-server` must be running:
```bash
ipld-car-shmem-server &
dasl-shmem-client stats  # verify
```

## Configuration

In Nora's `config.toml`:
```toml
[storage]
backend = "car-shmem"
```

Or via environment:
```bash
NORA_STORAGE_BACKEND=car-shmem
nora
```

## Architecture

```
Nora (:4000)                    ipld-car-shmem-server
┌──────────────────┐            ┌───────────────────┐
│ StorageBackend   │  Unix      │ CarStore          │
│ ┌──────────────┐ │  socket    │ pages.bin (36GB)  │
│ │CarShmemStorage│◄├───────────┤ CID index         │
│ └──────────────┘ │ @ipld_car  │                   │
│                  │ _shmem     └───────────────────┘
│ LocalStorage     │
│ S3Storage        │
└──────────────────┘
```

## How It Works

- `put(key, data)` → wrap as CARv1 page → `client.put_car()` → shmem ring
- `get(key)` → deterministic CID from key → `client.get_car()` → unwrap → return
- `delete(key)` → `client.deregister(cid)` → refcount decrement
- Integrity: CID IS the hash — content-addressing guarantees correctness

## Benefits

- **Zero-copy serving** — CAR pages mmap'd directly
- **Multi-registry** — multiple Nora instances share one page store
- **Fuzzer access** — LibAFL reads/writes same CAR pages
- **IPFS interop** — any CAR page = `ipfs dag import`
- **No HashPinStore needed** — CID provides integrity

## Files

- `nora-registry/src/storage/car_shmem.rs` — backend implementation
- `nora-registry/src/storage/mod.rs` — Storage::new_car_shmem() constructor
- `nora-registry/Cargo.toml` — Dependency for `ipld-car-ipc-shmem-linux`
- **Patch file**: For detailed changes, see [assets/nora-car-shmem-patch.md](assets/nora-car-shmem-patch.md)

## Vendormod Integration

cargo-vendormod's `nora_indexer` module feeds crate metadata into Nora,
and `handle_scan_index` can write scan results directly to CAR shmem for
Nora to serve. The vendormod tile_composer binary registers scan tiles
as Nora-discoverable content-addressed objects.

See [[cargo-vendormod]] for the full vendormod architecture and
[[vendormod-module-tile]] for the interactive module visualization.
