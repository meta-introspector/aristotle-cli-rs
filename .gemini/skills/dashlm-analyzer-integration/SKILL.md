---
name: dashlm-analyzer-integration
description: Integrate shared index cache into crossbeam rustc analyzer to skip re-analysis of unchanged files.
---

# crossbeam + dashlm integration

## Steps

1. Add `dashlm_shared_index` dep to analyzer Cargo.toml (patch/path).
2. Import: `use dashlm_shared_index::{SharedIndex, MemType};`
3. Before `analyze_file(&path)`:
   - Compute relative path, SipHash-2-4 -> key.
   - Open shared index read-only.
   - If cached value exists: bincode deserialize, compare SHA-256, return cached if match.
   - Else: run analysis, add `file_hash: [u8;32]` to `FileAnalysis`, serialize, store, access.
4. Add `--index-name` CLI arg or `DASHLM_INDEX_NAME` env var.
5. Test: run analyzer twice, second run faster, access logs show CPU hits.

## Source files

- `/mnt/data1/meta-introspector/crossbeam_rustc_analyzer_complete.rs`
- analyzer Cargo.toml patch
