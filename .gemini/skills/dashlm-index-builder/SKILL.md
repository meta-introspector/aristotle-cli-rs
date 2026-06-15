---
name: dashlm-index-builder
description: Build binary dashlm_index_builder that walks project tree, hashes files, and inserts into shared index, skipping unchanged files.
---

# dashlm_index_builder

## Steps

1. Create `src/bin/dashlm_index_builder.rs`.
2. Dependencies:
   - `dashlm_shared_index = { path = "./dashlm_shared_index" }`
   - `walkdir = "2.5"`
   - `blake3 = "1.0"`
   - `rayon = "1.8"` (optional)
   - `clap = "4.5"`
3. Re-use analysis functions from cross-beam analyzer (copy FileAnalysis and ContentVisitor or extract to static lib).
4. CLI:
   - `--project-root <PATH>` (default `~/dasl`)
   - `--index-name <STRING>` (default computed from git hash)
   - `--index-size <SIZE>` (default 1GiB)
   - `--verbose`
5. Algorithm:
   - Open/create shared index via SharedIndex::open_or_create.
   - Iterate *.rs under project root.
   - For each file: compute SHA-256, SipHash-2-4 of relative path, get(key), skip if hash matches, else analyze, bincode serialize, store, access.
   - Print progress every 5000 files.
6. Add unit tests with mock directory tree.

## Source files

- `src/bin/dashlm_index_builder.rs`
