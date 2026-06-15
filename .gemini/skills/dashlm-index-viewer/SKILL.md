---
name: dashlm-index-viewer
description: Read-only tool dashlm_index_show that prints shared index statistics including zone distribution, access logs, and conflicts.
---

# dashlm_index_show

## Steps

1. Create `src/bin/dashlm_index_show.rs`.
2. Dependencies:
   - `dashlm_shared_index = { path = "./dashlm_shared_index" }`
   - `clap = "4.5"`
   - `serde_json = "1.0"` (optional for `--json`)
3. CLI:
   - `--index-name <STRING>` (required)
   - `--json` (flag for raw JSON output)
4. Implementation:
   - Open segment read-only.
   - Iterate slots, count non-zero key_hash.
   - Build histograms of zone usage by mem_type.
   - Read access logs, count per type, detect conflicts (same key in CPU and GPU logs).
   - Print summary; with `--json` emit object with total_files, cpu/gpu/shared entries, zone histograms, conflict_keys, access log lengths.
5. Add test: build tiny index, run viewer, assert output matches.

## Source files

- `src/bin/dashlm_index_show.rs`
- `tests/index_show_test.rs`
