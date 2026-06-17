# Lean4 Splitter — Structured Rebase Plan

## What We Have

### 1. Lean4Introspector (user-space JSON exporter)
- **Path:** `/mnt/data1/nix/time/2025/05/10/Lean4Introspector/`
- **What it does:** Uses Lean `Meta` to inspect the environment and emit JSON schemas
- **Key files:**
  - `LeanIntrospector.lean` (1057 lines) — `ToJson` instances for every Lean kernel type
  - `LeanIntrospectorSimple.lean` (410 lines) — Self-contained reimplementation of kernel types
  - `LeanIntrospectorTodo.lean` — WIP
- **Output:** `data/` and `data2/` with per-type JSON files, content-addressed by CID
- **Pipeline:** `process.sh` → `report1.json.gz`

### 2. Lean4 kernel patches (54 files, +609/-523 lines)
- **Pattern:** `private` → public visibility for internal structures/defs
- **Status:** WIP, 7 messy commits, last says "prototype in user space first"
- **Key files affected:** `LazyDiscrTree`, `Simp/Main`, `EMatchTheorem`, `CompletionCollectors`, `Environment`, `Declaration`, `Expr`

### 3. Vendored copy in solfunmeme-dioxus
- Same as main + 1 extra commit (`src/Lean/test.lean`)

## Architecture Decision

Lean4Introspector works in **user space** — it defines its own `ToJson` instances.
The kernel patches (making things public) may or may not be needed.

## Structured Plan

### Phase 1: Extract Lean4Introspector as standalone project
- Give it proper `lakefile.toml` with mathlib dependency
- Document JSON schema for all exported types
- Tag as `v1.0-schema-doc`

### Phase 2: Determine minimal kernel patches needed
- Try building Lean4Introspector against stock Lean4 v4.28.0
- Identify which `private` declarations it needs access to
- Extract minimal patch set (likely just `Declaration.lean` + `Environment.lean`)

### Phase 3: Apply minimal patches as clean commits onto upstream
- Rebase minimal patches onto `upstream/master` (v4.33.0-dev)
- Proper commit messages documenting why each change
- CI config changes separate from source changes

### Phase 4: Build Rust splitter (in aristotle-manager)
- Consume Lean4Introspector JSON output
- Produce per-declaration flake.nix + source chunks
- Integrate with Aristotle pipeline

## Files to Create

```
lean4-introspector/          # New standalone project
  lakefile.toml
  LeanIntrospector.lean
  LeanIntrospectorSimple.lean
  SCHEMA.md                  # JSON schema documentation
  process.sh                 # Export pipeline

lean4/                       # Patched lean4 fork
  src/Lean/Declaration.lean  # Minimal patch
  src/Lean/Environment.lean  # Minimal patch
  PATCHES.md                 # Why each patch exists

aristotle-manager/           # Existing Rust tool
  src/splitter.rs            # JSON→flake splitter
```
