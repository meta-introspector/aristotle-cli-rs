---
name: step-diagonalize
description: >-
  Self-application of the split/merge pipeline to Aristotle's own codebase.
  Gödelian self-improvement: find minimal self-referential kernel,
  rebuild clean workspace, repair with SPARQL/GOAP.
  Phase 5 of the self-improvement cycle.
---

# Step: diagonalize — Self-Application (Gödelian Loop)

The core self-improvement phase. Applies the Aristotle pipeline to itself.

## Sub-commands

### --core-only — Find Minimal Self-Referential Kernel
```bash
aristotle-manager diagonalize --core-only
```
1. Build self-project mirror from `arist/src/` + `splitter-engine/` + `*.sh` + `*.nix`
2. Run all 5 language splitters on the self-project
3. Discover variant sources from all server projects
4. Build dependency graph across ALL declarations
5. Extract top 50% most-referenced declarations as minimal core
6. Report results: `minimal-core.json`, `variant-index.json`

### --rebuild — Merge Sources into Unified Workspace
```bash
aristotle-manager diagonalize --rebuild
```
Merges `arist/src/` + `vendormod/src/` + `split-decls-rs/src/` into `unified/`.
Preserves directory structure, generates mod.rs, Cargo.toml, flake.nix.

### --from-lattice — Regenerate from Variant Index
```bash
aristotle-manager diagonalize --from-lattice
```
Reads `variant-index.json` + raw source from 3 projects.
Rewrites paths to produce `lattice-workspace/` with clean structure.

### --repair — SPARQL + GOAP Fixes
```bash
aristotle-manager diagonalize --repair
```
Pushes unified-tool to RDF graph, runs SPARQL queries, applies fixes,
verifies compilation. Uses GOAP planner to prove fix correctness.

## Output Structure

```
diagonalize-results/
├── self-project/          # mirrored source files
├── self-split/            # per-declaration splits
├── merged-with-variants/  # cross-project merged pool
├── minimal-core/          # top declarations
│   ├── minimal-core.json
│   └── variant-index.json
├── variants-applied/      # diagonalized reflections
├── unified/               # --rebuild workspace
├── lattice-workspace/     # --from-lattice workspace
└── unified-tool/          # --repair workspace
```

## Historical Results (2026-06-26)

| Metric | Value |
|--------|-------|
| Self-project files | 130,200 |
| Variant sources | 4,917 |
| Unique declarations | 18,648 |
| Minimal core | **91** declarations |
| Top decls | Mathlib (34,793 refs), Eq (13,157), MicroLean_MicroLeanType (6,175 self!) |

## Related Skills

- [[self-improve-pipeline]] — Full cycle overview
- [[step-dasl-finish]] — Previous step
- [[step-enrich]] — Next step
- [[diagonalize-tile]] — Web viewer for diagonalization data (port 8082)
