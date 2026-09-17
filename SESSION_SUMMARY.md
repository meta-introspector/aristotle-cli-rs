# Session Summary — Aristotle Manager Fixes

## Completed

### Build fixes
- `src/term_graph.rs`: replaced unstable `.as_str()` on `&str` with plain `word`, resolving rustc E0658 (`str_as_str` unstable feature).
- Confirmed `once_cell` dependency is not required by `term_graph.rs`; no Cargo.toml change needed.
- Verified `cargo build --release` completes with **0 errors, 0 warnings**.

### CLI enhancements
- `src/main.rs`: added `--extra-dirs` and `--json` flags to the `TermGraph` command.
- `src/main.rs`: added `LoadTermGraphToShmem` command variant for loading term-graph JSON into IPLD CAR shmem.
- `src/load_shmem.rs`: new module added (126 lines).

### Commits
- `3a3c4cb81` fix: replace unstable `word.as_str()` with `word` in `term_graph.rs`
- `96741770c` feat: add `--extra-dirs` and `--json` flags to `term-graph` command
- `afbc53c62` feat: add `--extra-dirs` and `--json` flags to `term-graph` command
  - note: commit message is inaccurate; this commit actually contains `src/load_shmem.rs`
- `490d2dd76` feat: add `LoadTermGraphToShmem` command to CLI
- `356dab07d` docs: session summary for term_graph build fix and CLI additions
- `b2ad6f8d3` docs: comprehensive Aristotle command reference

### Operations
- Removed redundant worktree `/home/mdupont/projects/arist-fix` (main repo already contained the warning fixes).
- Verified `next` command runs correctly (autonomous agent loop).
- Ran `fetch`: downloaded **10 new/updated** Aristotle projects, 0 failures.
- Active Lean build queue: **project 116/393** (`6a63c71d`) — mathlib decompression phase. 82/115 attempted projects completed successfully.

### Current state
- `results` command shows **0 succeeded, 389 failed** — these are tracked Aristotle outputs, not necessarily recent runs.
- `repl-stats` shows `lean4-repl` at `localhost:8156` with 0 declarations loaded.
- `dasl-status` runs but times out under 30s due to large dataset.

---

## Aristotle Command Reference

### Indexing

| Command | Purpose | Key Flags | Implementation |
|---------|---------|-----------|----------------|
| `index` | Scan all `*_aristotle` dirs and produce `aristotle-blocks.json` (DASL-compatible) | `--output <OUTPUT>` | `index.rs`: heuristic categorization (MONSTER, CFSG, DASL/IPLD, FRACTRAN, LEAN/PROOF, etc.), extracts H1 title |
| `scan-index` | Read `.txt` index files (lists of paths), find Lean4 proofs, ingest | `--index-dir`, `--output-dir`, `--prefix-filter` | `file_index.rs`: parses raw paths and grep-style `source:path:line:text`, organizes by category (mathlib, dasl, fractran, aristotle, other) |
| `notebooklm` | Generate text files for NotebookLM from a project | `--project-dir <PROJECT_DIR>` | `notebooklm.rs`: walks project dir, concatenates text files, splits at 500K words into `~/notebooklm/2026/{date}/{project_name}/part_{N}.txt` |
| `notebooklm-cross` | Generate cross-project NotebookLM files from all REPL declarations | `--output-dir` | `notebooklm_cross.rs`: hardcoded list of 66 projects, runs `staticsplitjson --dir`, writes to `/mnt/data1/notebooklm/2026/06-june/24-dasl-proofs/` |
| `notebooklm-dump` | Dump entire DASL pipeline state for NotebookLM ingestion | `--output-dir` | `notebooklm_dump.rs`: reads 12 sections from `~/dasl-planning/` and `~/dotagents/`, writes numbered `.txt` files to `~/notebooklm/dasl-pipeline/` |

### Searching / Graph Building

| Command | Purpose | Key Flags | Implementation |
|---------|---------|-----------|----------------|
| `overlap` | Find overlapping projects by shared mathlib-split imports | `--reference <REF>`, `--min-shared <N>`, `--top <N>` | CLI stub in `main.rs`; requires `canonical-flake` first |
| `term-graph` | Build term-level dependency graph across projects | `--git-base`, `--extra-dirs`, `--output-dir`, `--quiet`, `--json` | `term_graph.rs`: heuristic Lean parser, tracks `defined_by`, `used_by`, `needed_by` per term, 107-term STOP_TERMS filter, generates `term_graph.json`, `term_summary.json`, `term_graph.dot`, merge suggestions |
| `dep-graph` | Build dependency graph from consolidated declarations | `--input-dir`, `--output-dir` | `pipeline_steps.rs`: reads `manifest.json`, builds adjacency list, computes roots/leaves, graph density, outputs `dep-graph.json` |
| `j-key` | J-invariant prime stratification (assign declarations to q-expansion bands) | `--input-dir`, `--output-dir` | `pipeline_steps.rs`: extracts integers from Lean bodies, computes max prime factor, assigns to 5 bands (q⁻¹, q⁰, q¹, q², q³, O(q⁴)), detects "monster hits" (divisible by 47, 59, 71), outputs `j-key-stratification.json` |
| `arrows` | Extract functor arrows between declarations (2-category structure) | `--input-dir`, `--output-dir` | `pipeline_steps.rs`: reads `j-key-stratification.json`, creates 3 arrow types: `spectral_flow` (band transitions), `monster_bridge` (complete graph among monster hits), 5 canonical morphisms (markov_transition, hecke_operator, maass_shadow), outputs `arrows.json` |
| `decl-table` | Build canonical declaration table from split results | `--split-dir`, `--output` | `main.rs`: walks `flake.nix` dirs, maps declaration names to source projects, deduplicates (first-project-as-canonical), outputs `decl-table.json` |

### Splitting

| Command | Purpose | Key Flags | Implementation |
|---------|---------|-----------|----------------|
| `split` | Split Lean4 modules (de-duplicate) | `--input-dir`, `--output-dir` | `main.rs`: calls external `split-aristotle-project.sh` |
| `split-all` | Run SplitDecls on all Lean projects, produce per-declaration flake.nix lattice | `--output-dir`, `-j <PARALLEL>`, `--dry-run` | `main.rs`: iterates all `*_aristotle` dirs, runs split script, parallel with semaphore |
| `split-by-band` | Split declarations by J-invariant bands | `--input-dir`, `--output-dir` | `pipeline_steps.rs`: reads `j-key-stratification.json`, groups by band, generates per-band `declarations.lean` + `band-manifest.json` + `band-index.json` |
| `canonical-flake` | Generate canonical per-module flakes with mathlib-split resolution | `--input-dir`, `--output-dir`, `--mathlib-split` | `pipeline_steps.rs`: builds `mathlib-split` index (`module_name → directory`), resolves `import Mathlib.X` to canonical paths, generates per-module `flake.nix` with `path:` inputs |
| `canonical-flake-all` | Generate canonical flakes for all downloaded projects | `--output-dir`, `--mathlib-split` | `pipeline_steps.rs`: iterates all projects, runs canonical-flake logic per project |

### Merging

| Command | Purpose | Key Flags | Implementation |
|---------|---------|-----------|----------------|
| `merge` | Merge split results | `--input-dir`, `--output-dir` | `main.rs` / `pipeline.rs`: copies `split-decls/` into unified `mathlib-split/` pool, preserves relative paths |
| `merge-projects` | Merge multiple Aristotle projects into unified directory | `--project-ids <UUIDs>...`, `--output-dir` | `pipeline_steps.rs`: copies `.lean` files from each project's `RequestProject/`, prefixes filenames with `{project_id}_`, copies `lakefile.toml` + `lean-toolchain` |
| `consolidate` | Consolidate declarations from a specific project into unified pool | `--project-id <UUID>`, `--output-dir` | CLI stub in `main.rs` |
| `diagonalize` | Apply Aristotle pipeline to itself — self-hosting diagonalization | `--output-dir`, `--core-only`, `--dry-run`, `--rebuild`, `--from-lattice`, `--repair` | CLI stub in `main.rs` |

### Pipeline

| Command | Purpose | Key Flags | Implementation |
|---------|---------|-----------|----------------|
| `pipeline` | Full pipeline: fetch → split → verify → version → merge | `-j <PARALLEL>`, `--limit`, `--dry-run` | `pipeline.rs`: orchestrates 5 steps in sequence |
| `refresh` | Pull latest from Aristotle, download new, split all, build decl table | `-j <PARALLEL>`, `--limit` | `main.rs`: download (paginated API + parallel semaphore) → split (external script) → decl-table |
| `replay` | Replay entire archive chronologically into fresh split/merge repo | `--output-dir`, `--dry-run` | `replay.rs`: sorts projects by `extracted_at`, initializes git repo with backdated initial commit (1970-01-01), splits each chronologically into `ReplayPool/`, generates `dag.json` |
| `version` | Git-version all Aristotle outputs — each project becomes a commit | `--results-dir`, `--output-dir` | `version.rs`: each project gets its own git repo under `git_base/`, commit date = `extracted_at`, only copies changed files (mtime check), skips `.tar.gz` |

---

## Data Flow

```
fetch → download tarballs → extract → version (git repos)
  ↓
split / split-all / canonical-flake → split-decls/
  ↓
decl-table → decl-table.json (canonical mapping)
  ↓
merge / merge-projects → mathlib-split/ (unified pool)
  ↓
dep-graph → dep-graph.json
  ↓
j-key → j-key-stratification.json (prime bands)
  ↓
arrows → arrows.json (2-category structure)
  ↓
split-by-band → bands/ (per-band .lean files)
  ↓
gen-flake → per-band flake.nix
  ↓
term-graph → term_graph.json (cross-project term usage)
  ↓
notebooklm / notebooklm-dump → .txt files for LLM ingestion
```

## Key Implementation Notes

1. **Split implementation**: `cmd_split` delegates to external `split-aristotle-project.sh` shell script, not pure Rust
2. **Mathlib integration**: `canonical-flake` requires `mathlib-split` directory (module_name → directory mapping) to resolve `import Mathlib.X` paths
3. **Prime stratification**: J-invariant bands use q-expansion (q⁻¹ through q⁴), with "monster hits" at primes 47, 59, 71
4. **2-category structure**: Mycelium module constructs 0-cells, 1-cells, 2-cells, and terminal morphisms (Monster prime orbifold residues)
5. **NotebookLM limits**: 500,000 word limit per part file
6. **Incremental sync**: `fetch` compares `last_updated` API field with local `extracted_at` metadata
7. **Versioning**: Each project gets its own git repo; commit messages include `aristotle_status.json` description
8. **Replay**: Uses `BTreeMap` to sort projects chronologically by `extracted_at`; initial commit backdated to 1970-01-01
