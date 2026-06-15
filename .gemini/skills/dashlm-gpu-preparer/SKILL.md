---
name: dashlm-gpu-preparer
description: Convert CPU hash-table into GPU-friendly Structure-of-Arrays layout and write to pinned memfd with JSON metadata sidecar.
---

# dashlm_index_gpu_prep

## Steps

1. Create `src/bin/dashlm_index_gpu_prep.rs`.
2. Dependencies:
   - `dashlm_shared_index = { path = "./dashlm_shared_index" }`
   - `cuda-sys = "0.2"`
   - `memfd = "0.6"` (optional)
   - `byteorder = "1.5"`
   - `clap = "4.5"`
3. CLI:
   - `--index-name <STRING>`
   - `--output-dir <PATH>` (default `/dev/shm`)
   - `--verbose`
4. Algorithm:
   - Open shared index read-only.
   - Iterate slots: deserialize values, extract structs/enums/functions, push counts into metadata vectors, append strings to blob buffer with offsets.
   - Allocate pinned buffer via `cudaHostAlloc` or memfd + `cudaHostRegister`.
   - Copy metadata and blob into pinned buffer with header describing offsets/lengths.
   - Write to `$OUTPUT_DIR/gpu_index_<hash>.bin`.
   - Emit JSON sidecar `gpu_index_<hash>.meta` with metadata_offset, metadata_stride, num_entries, blob_offset, blob_length, value_encoding.
   - Print suggested CUDA launch command.
5. Test: build tiny index, run prep, verify output file round-trips.

## Source files

- `src/bin/dashlm_index_gpu_prep.rs`
- `tests/gpu_prep_test.rs`
