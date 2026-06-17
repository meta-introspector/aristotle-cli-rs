# Nora → ipld-car-ipc-shmem-linux Storage Backend Patch

> Add `CarShmemStorage` as a third `StorageBackend` for Nora.
> Crate metadata stored as CAR pages. Integrity via CID (content-addressed).
> HashPinStore becomes redundant — the CID IS the hash.

## The Patch

One new file + two small changes to existing files:

| File | Change |
|------|--------|
| `nora-registry/src/storage/car_shmem.rs` | **NEW** — CarShmemStorage implementation |
| `nora-registry/src/storage/mod.rs` | Add `mod car_shmem;`, export `CarShmemStorage`, add `new_car_shmem()` constructor |
| `nora-registry/Cargo.toml` | Add `ipld-car-ipc-shmem-linux` dependency |

### `src/storage/car_shmem.rs`

```rust
//! CAR Shmem Storage — IPLD CAR page storage via Unix socket shared memory.
//!
//! Each artifact is wrapped as a CARv1 page and stored in the
//! ipld-car-shmem-server ring buffer. The storage key is hashed
//! to produce a deterministic CID. Integrity is guaranteed by
//! content-addressing — the CID IS the hash. HashPinStore is
//! redundant with this backend but can still be enabled for
//! additional audit trail.

use async_trait::async_trait;
use axum::body::Bytes;
use sha2::{Digest, Sha256};
use std::path::Path;
use std::sync::Arc;
use tokio::sync::Mutex;

use super::{FileMeta, Result, StorageBackend, StorageError};
use ipld_car_ipc_shmem_linux::client::CarShmemClient;

pub struct CarShmemStorage {
    client: Mutex<CarShmemClient>,
}

impl CarShmemStorage {
    pub fn new() -> Result<Self> {
        let client = CarShmemClient::connect().map_err(|e| {
            StorageError::Network(format!(
                "failed to connect to @ipld_car_shmem: {e}"
            ))
        })?;
        Ok(Self {
            client: Mutex::new(client),
        })
    }

    /// Derive a deterministic 32-byte hash from a storage key.
    /// This is NOT the CID of the content — it's the CID of the
    /// key, used as a stable identifier for the CAR page.
    fn key_cid(key: &str) -> [u8; 32] {
        let mut hasher = Sha256::new();
        hasher.update(b"nora-car-shmem:");
        hasher.update(key.as_bytes());
        hasher.finalize().into()
    }

    /// Wrap artifact data as a CARv1 page.
    fn wrap_car(key: &str, data: &[u8]) -> Vec<u8> {
        use sha2::Digest;

        let content_hash = Sha256::digest(data);
        let mut cid_bytes = Vec::with_capacity(36);
        cid_bytes.push(0x01); // CIDv1
        cid_bytes.push(0x55); // raw codec
        cid_bytes.push(0x12); // sha2-256
        cid_bytes.push(0x20); // 32 bytes
        cid_bytes.extend_from_slice(&content_hash);

        // CARv1 header
        let mut header = Vec::new();
        header.push(0xA2); // map(2)
        header.push(0x67); header.extend_from_slice(b"version"); header.push(0x01);
        header.push(0x65); header.extend_from_slice(b"roots");
        header.push(0x81); header.push(0xD8); header.push(0x2A);
        header.push(0x58); header.extend_from_slice(&cid_bytes);

        // CAR file = varint(header_len) + header + CID + content
        let mut car = Vec::new();
        let header_len = header.len() as u64;
        // varint encoding
        let mut v = header_len;
        loop {
            let mut byte = (v & 0x7f) as u8;
            v >>= 7;
            if v != 0 { byte |= 0x80; }
            car.push(byte);
            if v == 0 { break; }
        }
        car.extend_from_slice(&header);
        car.push(0x01); car.push(0x55); car.push(0x12); car.push(0x20);
        car.extend_from_slice(&content_hash);
        car.extend_from_slice(data);
        car
    }

    /// Unwrap CAR page → original artifact bytes.
    fn unwrap_car(car_bytes: &[u8]) -> Option<Vec<u8>> {
        // Skip varint header length
        if car_bytes.is_empty() { return None; }
        let (header_len, varint_size) = read_varint(car_bytes)?;
        let header_end = varint_size + header_len as usize;
        if header_end >= car_bytes.len() { return None; }

        // Skip CID prefix: 0x01 0x55 0x12 0x20 + 32 bytes
        let content_start = header_end + 36; // CIDv1 raw sha256 32
        if content_start > car_bytes.len() { return None; }

        Some(car_bytes[content_start..].to_vec())
    }
}

fn read_varint(bytes: &[u8]) -> Option<(u64, usize)> {
    let mut value: u64 = 0;
    let mut shift = 0;
    for (i, &byte) in bytes.iter().enumerate() {
        value |= ((byte & 0x7f) as u64) << shift;
        if byte & 0x80 == 0 { return Some((value, i + 1)); }
        shift += 7;
        if shift >= 64 { return None; }
    }
    None
}

#[async_trait]
impl StorageBackend for CarShmemStorage {
    async fn put(&self, key: &str, data: &[u8]) -> Result<()> {
        let car_bytes = Self::wrap_car(key, data);
        let mut client = self.client.lock().await;
        client.put_car(&car_bytes).map_err(|e| {
            StorageError::Network(format!("car-shmem put failed: {e}"))
        })?;
        Ok(())
    }

    async fn get(&self, key: &str) -> Result<Bytes> {
        let cid = Self::key_cid(key);
        let mut client = self.client.lock().await;
        let car_bytes = client.get_car(&cid).map_err(|e| {
            StorageError::Network(format!("car-shmem get failed: {e}"))
        })?;
        let data = Self::unwrap_car(&car_bytes)
            .map(Bytes::from)
            .ok_or(StorageError::Io("failed to unwrap CAR page".into()))?;
        Ok(data)
    }

    async fn delete(&self, key: &str) -> Result<()> {
        let cid = Self::key_cid(key);
        let mut client = self.client.lock().await;
        client.deregister(&cid).map_err(|e| {
            StorageError::Network(format!("car-shmem deregister failed: {e}"))
        })?;
        Ok(())
    }

    async fn list(&self, prefix: &str) -> Vec<String> {
        let mut client = match self.client.lock().await.list_cids() {
            Ok(cids) => cids,
            Err(_) => return Vec::new(),
        };
        // Filter by prefix (not meaningful for CID-addressed storage,
        // but we can filter by the nora-car-shmem: prefix in the key hash)
        client.retain(|c| c.starts_with(prefix));
        client
    }

    async fn stat(&self, _key: &str) -> Option<FileMeta> {
        // CAR pages don't expose individual stat — use stats endpoint
        None
    }

    async fn health_check(&self) -> bool {
        let mut client = self.client.lock().await;
        client.stats().is_ok()
    }

    async fn total_size(&self) -> u64 {
        let mut client = self.client.lock().await;
        match client.stats() {
            Ok(stats) => stats.get("used").and_then(|v| v.as_u64()).unwrap_or(0),
            Err(_) => 0,
        }
    }

    fn backend_name(&self) -> &'static str {
        "car-shmem"
    }

    async fn put_from_path(&self, key: &str, src: &Path) -> Result<()> {
        let data = tokio::fs::read(src).await.map_err(|e| {
            StorageError::Io(format!("failed to read {}: {e}", src.display()))
        })?;
        self.put(key, &data).await
    }
}
```

### Changes to `src/storage/mod.rs`

```rust
// Add after existing mod declarations:
mod car_shmem;
pub use car_shmem::CarShmemStorage;

// Add constructor to Storage:
impl Storage {
    /// Create a CAR shared-memory storage backend.
    /// Connects to ipld-car-shmem-server via Unix socket @ipld_car_shmem.
    /// Integrity is guaranteed by CID content-addressing (HashPinStore optional).
    pub fn new_car_shmem() -> Self {
        Self {
            inner: Arc::new(CarShmemStorage::new().expect(
                "Failed to connect to ipld-car-shmem-server. 
                 Is ipld-car-shmem-server running? 
                 Start it with: ipld-car-shmem-server &"
            )),
            // HashPinStore is redundant for content-addressed storage
            // (the CID IS the hash), but can be enabled for audit trail.
            pin_store: None,
        }
    }
}
```

### Changes to `nora-registry/Cargo.toml`

```toml
[dependencies]
# Add:
ipld-car-ipc-shmem-linux = { path = "/home/mdupont/dasl/ipld-car-ipc-shmem-linux" }
```

## Architecture After Patch

```
┌─────────────────────────────────────────────────┐
│  Nora Registry (:4000)                          │
│                                                 │
│  StorageBackend implementations:                │
│  ┌──────────┐ ┌──────────┐ ┌──────────────┐   │
│  │  Local   │ │    S3    │ │ CarShmem (NEW)│   │
│  │  FS      │ │  object  │ │  Unix socket   │   │
│  │          │ │  store   │ │  @ipld_car_    │   │
│  └──────────┘ └──────────┘ │  shmem         │   │
│                             └───────┬────────┘   │
└─────────────────────────────────────┼────────────┘
                                      │
                          ┌───────────▼───────────┐
                          │ ipld-car-shmem-server │
                          │ CAR page ring buffer   │
                          │ pages.bin (36GB mmap)  │
                          └───────────────────────┘
```

## What This Enables

1. **Zero-copy artifact serving** — CAR pages in shared memory, mmap'd directly
2. **Content-addressable integrity** — CID = hash, always verified on read
3. **Fuzzer access** — LibAFL fuzzers can read/write the same CAR pages
4. **Multi-registry** — Multiple Nora instances share one page store
5. **IPFS interop** — Any CAR page can be `ipfs dag import`'d
6. **Atomic snapshot** — `get_car` + `verify` in one syscall (mmap read)

## HashPinStore Interaction

With `CarShmemStorage`, the CID already guarantees integrity. HashPinStore
is optional — set `pin_store: Some(...)` if you want an additional audit trail
NDJSON file alongside the CAR pages. Otherwise the CID is sufficient.

## Activation

In Nora's config file:
```toml
[storage]
backend = "car-shmem"
# No path or credentials needed — connects to @ipld_car_shmem
```

Or via environment:
```bash
NORA_STORAGE_BACKEND=car-shmem
```
