# Aristotle Manager CLI Command Reference

Generated: 2026-07-19

## Source
`/mnt/data1/time-2026/05-may/07/arist/src/`

## Command Categories

### Indexing
- `index` — Scan all `*_aristotle` dirs, produce `aristotle-blocks.json`
- `scan-index` — Read `.txt` index files, find Lean4 proofs, ingest
- `notebooklm` — Generate NotebookLM text files from a project
- `notebooklm-cross` — Cross-project NotebookLM from REPL declarations
- `notebooklm-dump` — Dump DASL pipeline state for NotebookLM

### Searching / Graph Building
- `term-graph` — Cross-project term dependency graph (`--json` supported)
- `dep-graph` — Dependency graph from consolidated declarations
- `j-key` — J-invariant prime stratification (q⁻¹ through q⁴)
- `arrows` — Functor arrows between declarations (2-category)
- `decl-table` — Canonical declaration table from split results
- `overlap` — Find overlapping projects by shared imports

### Splitting
- `split` — Run SplitDecls on one project
- `split-all` — Split every project (parallel, `-j 4`)
- `split-by-band` — Split by J-invariant bands
- `canonical-flake` — Per-module flakes with mathlib-split resolution
- `canonical-flake-all` — Canonical flakes for all projects

### Merging
- `merge` — Merge split results into unified pool
- `merge-projects` — Merge multiple projects into one directory
- `consolidate` — Consolidate one project into unified pool
- `diagonalize` — Self-hosting diagonalization of Aristotle pipeline

### Pipeline
- `pipeline` — Full pipeline: fetch → split → verify → version → merge
- `refresh` — Pull latest, download, split, decl-table
- `replay` — Chronological replay of entire archive
- `version` — Git-version each project (commit with metadata)
- `next` — Autonomous agent loop: pick highest-priority task

### Analysis
- `build` — Run `lake build` in all projects
- `test` — Test Lean4 projects
- `poll` — Git-pull + build
- `results` — Show build results
- `dasl-status` — Status of all DASL projects
- `repl-stats` — lean4-repl stats
- `load-decls` — Load declarations into lean4-repl shared memory
- `enrich` — Task-enricher + GOAP pipeline

### Communication
- `ask` — Send instructions to a running project
- `ask-with-files` — Ask with Lean4 proof files attached
- `respond` — Auto-respond to Aristotle asks
- `patch` — Watch a project, detect prereq gaps
- `submit` — Submit to Aristotle API
- `check` — Check status of a submitted project

### Other
- `download` — Bulk download all projects
- `download-result` — Download one tarball
- `configure` — API key and settings
- `clean` — Remove build artifacts
- `serve` — Start local Aristotle API server
- `mc-kay-oeis` — Scan OEIS for McKay-Thompson series
- `refusal-audit` — Audit refusals/help/needs
- `refusal-context` — Extract context around refusal keywords
- `refusal-fix-strategies` — Dump refusal fix strategies
- `refusal-corpus` — Build failure corpus
- `refusal-glossary` — Extract gnostic/undefined terms

## Build Status
- `cargo build --release`: 0 errors, 0 warnings
- Binary: `/mnt/data1/time-2026/05-may/07/arist/target/release/aristotle-manager`

## Related
- `SESSION_SUMMARY.md` — Detailed implementation notes
- `~/dotagents/skills/aristo-tools/SKILL.md` — Codebase guide
- `~/dotagents/skills/aristo-pipeline-phases/SKILL.md` — Pipeline phases
- `~/dotagents/skills/aristo-loop/SKILL.md` — Aristotle DASL cycle
