---
name: "dashlm-shared-index"
description: "Create the low-level shared-memory library crate dashlm_shared_index wrapping LibAFL shmem with fixed-size hash table and zone-based hashing."
---

# dashlm_shared_index

## Steps

1. Create `dashlm_shared_index/Cargo.toml` deps:
   - `libafl_shmem = { path = "../../../dasl/rust/ipld-core/LibAFL/crates/shmem_providers" }`
   - `siphash = "1.3"`
   - `bincode = "1.3"`
   - `once_cell = "1.19"`
2. Implement memory layout:
   - Header 64B: magic, version, zone_count, slot_count, value_heap_offset, value_heap_size, value_heap_used, reserved.
   - Slots: 16B each (key_hash u64, value_len u32, value_offset u32, mem_type u8, zone u8, padding u16).
   - Value heap: growable region after slots.
3. Public API: `open_or_create`, `store`, `get`, `access`, `cpu_accesses`, `gpu_accesses`, `check_conflicts`, `zone_distribution`.
4. Add unit tests for store/retrieve, zone calc, concurrent readers, access logging.
5. Verify: `nix develop -c cargo build --release`.

## Source files

- `dashlm_shared_index/Cargo.toml`
- `dashlm_shared_index/src/lib.rs`
- `dashlm_shared_index/tests/*.rs`
