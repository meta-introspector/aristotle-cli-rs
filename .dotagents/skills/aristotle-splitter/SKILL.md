---
name: aristotle-splitter
description: >-
  Lean 4 declaration splitter — splits a Lean module into one file per
  declaration with exact dependency tracking via the Environment API.
  Two modes: kernel API (SplitDecls.lean) and static regex (StaticSplit.lean).
  Use when splitting Lean codebases into per-declaration flakes.
---

# Aristotle Splitter — Lean Declaration Splitter

Splits a Lean module into one `.lean` + `flake.nix` per declaration, enabling
minimal recompilation, parallel builds, and cherry-pick imports.

## When to Use

- "Split this Lean module into declarations"
- "Generate per-declaration flake.nix files"
- "Extract declaration dependencies from Lean Environment"
- "Run the splitter on Aristotle projects"

## Two Modes

### 1. Kernel API Mode (SplitDecls.lean) — Exact Dependencies

Uses the Lean 4 Environment API to load a module, extract every declaration,
compute exact dependencies via `Expr.foldConsts`, and emit per-decl files.

```bash
# Via Rust driver
cargo run --release -- split --input-dir <dir> --output-dir <out>

# Via shell script
./split-lean-project.sh <module-name> <output-dir> [extra-lean-path]

# Direct
lake env lean --run RequestProject/SplitDecls.lean <module> <output-dir>
```

**Key functions in SplitDecls.lean:**
- `collectRefs` — walk Expr AST, collect all constant references
- `constDeps` — get deps from type + value of a constant
- `bfsClosure` — BFS from root decl to find transitive deps
- `topoSort` — Kahn's algorithm dependency sort
- `emitDeclFile` / `emitDeclFlake` — write per-decl `.lean` + `flake.nix`
- `emitDag` — write `dag.json` (dependency graph)
- `emitLakefile` — write `lakefile.toml` for the split project

### 2. Static Regex Mode (StaticSplit.lean) — No Build Required

Scans `.lean` files for declaration keywords, tracks brace depth for
boundaries. No lake build needed — works on raw source files.

```bash
# Via Python (legacy, being replaced)
python3 static_split.py <project-dir> <output-dir>

# Via Lean (replacement)
lake env lean --run StaticSplit.lean <project-dir> <output-dir>
```

**Declaration keywords detected:** `def`, `theorem`, `lemma`, `example`,
`inductive`, `structure`, `class`, `instance`, `opaque`, `axiom`, `abbrev`,
`noncomputable def`

## Splitter Engine (splitter-engine/)

The Lean project that hosts the splitter:

```
splitter-engine/
├── lakefile.toml       — Lean 4 v4.28.0 + Mathlib
├── lean-toolchain      — leanprover/lean4:v4.28.0
├── RequestProject/
│   ├── SplitDecls.lean — Kernel API splitter
│   ├── MicroLean.lean  — FFI extraction meta-system
│   └── Main.lean       — Mathlib imports + pp options
└── .lake/              — build cache
```

**lakefile.toml:**
```toml
name = "splitter-engine"
defaultTargets = ["RequestProject"]

[[require]]
name = "mathlib"
git = "https://github.com/leanprover-community/mathlib4.git"
rev = "v4.28.0"

[[lean_lib]]
name = "RequestProject"
globs = ["RequestProject.+", "RequestProject.AZ.+"]

[[lean_exe]]
name = "splitdecls"
root = "RequestProject.SplitDecls"
```

## Output Structure

```
split-results/
├── <project-uuid>/
│   ├── Split.<decl_name>/
│   │   ├── <decl_name>.lean    — stub with imports + metadata
│   │   └── flake.nix           — per-decl Nix build
│   ├── dag.json                — dependency graph
│   └── lakefile.toml           — split project lakefile
└── split_summary.json          — metadata
```

## Batch Splitting

```bash
# All Aristotle projects via Rust
cargo run --release -- split-all --output-dir ./split-results

# Single project
cargo run --release -- split --input-dir ./aristotles_results/<uuid>/

# Via split-aristotle-project.sh
./split-aristotle-project.sh <project-dir> <output-dir>
```

## Related

- `~/projects/lean-split-decls/` — standalone splitter project (v4.29.1)
- `aristotle-manager` skill — Rust driver that orchestrates splitting
- `micro-lean-ffi` skill — FFI extraction meta-system in splitter-engine
