---
name: self-improve-pipeline
description: >-
  Master skill for the Aristotle self-improvement cycle:
  fetch → split → merge → dasl-finish → diagonalize → enrich.
  OODA loop driven by GOAP + DASL planners.
---

# Self-Improvement Pipeline — Observe-Orient-Decide-Act Cycle

The full pipeline that turns Aristotle server data into system improvements.
Each phase feeds the next. The GOAP/DASL planners decide what to do next.

## The Cycle

```
fetch ──→ split ──→ merge ──→ dasl-finish ──→ diagonalize ──→ enrich
  │         │         │            │               │             │
  │    split decls   unified     rebuild +       apply to      indexes +
  │    into per-     decl        update          self: find     glossaries
  │    decl flakes   pool        planners       minimal core   notebooklm
  ▼                               & OODA                         exports
new/updated                      loop
projects
```

## Step-by-Step

### 1. fetch — Incremental download
```
aristotle-manager fetch
```
Compares API `last_updated` vs local `aristotle_status.json`. Downloads only new/updated tarballs. Extracts into `results_dir/*_aristotle/`.

### 2. split-all — Declaration extraction
```
aristotle-manager split-all [--dry-run]
```
Runs SplitDecls.lean (Environment API) per project. Also runs multi-language splitters (Rust syn, Python regex, shmem queries, agent log extraction). Output: per-declaration `declaration.json` + `flake.nix`.

### 3. merge — Unified declaration pool
```
aristotle-manager merge
```
Deduplicates all declarations across all splitters. Builds `mathlib-split/` unified pool.

### 4. dasl-finish — Rebuild flakes + planners
```
aristotle-manager dasl-finish
```
1. Download remaining projects
2. Merge declarations
3. Rebuild flakes with correct paths
4. Update DASL planner: `~/dasl-planning/dasl-planner refresh`
5. Update GOAP planner: `~/dasl-planning/.../dasl-planner`

### 5. diagonalize — Self-application
```
aristotle-manager diagonalize --core-only   # find minimal self-referential kernel
aristotle-manager diagonalize --rebuild     # merge arist + vendormod + split-decls
aristotle-manager diagonalize --from-lattice  # regenerate from variant index
aristotle-manager diagonalize --repair      # SPARQL + GOAP fixes
```

### 6. enrich — Build indexes
```
aristotle-manager index          # DASL blocks.json
aristotle-manager notebooklm     # NotebookLM text
aristotle-manager refusal-audit  # Audit refusals/needs
```

## Related Skills

- [[aristotle-fetch-version]] — Incremental fetch details
- [[aristotle-manager]] — CLI reference
- [[diagonalize-tile]] — Diagonalize tile viewer (port 8082)
- [[dasl-indexers]] — DASL block index generation
