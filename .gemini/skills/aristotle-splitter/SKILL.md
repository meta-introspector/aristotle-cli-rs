---
name: "aristotle-splitter"
description: "Aristotle Splitter — Lean4 SplitDecls engine (274 lines) that splits mathlib and Aristotle projects into per-declaration Nix flakes using kernel-level module indexing, multi-root BFS dependency closure, and iterative DFS topological sort. Use when splitting Lean4 projects into individual declarations, building per-declaration flake.nix files, or running the splitter on mathlib modules."
---

# aristotle-splitter — Per-Declaration Lean4 Splitter

**Location:** `/mnt/data1/time-2026/05-may/07/arist/splitter-engine/`
**Source:** Aristotle project `fa51bcab` ("split math lib")
**Lines:** 274 (SplitDecls.lean), 37 auxiliary Lean files
**Dependencies:** mathlib4 v4.28.0 (573MB cached)

## Quick Start

```bash
cd /mnt/data1/time-2026/05-may/07/arist/splitter-engine

# Build (first time fetches mathlib from GitHub)
lake build splitdecls

# Split a module into per-declaration flakes
lake env lean --run RequestProject/SplitDecls.lean \
  RequestProject.SplitDecls ./split-out

# Split via wrapper
cd /mnt/data1/time-2026/05-may/07/arist
bash split-aristotle-project.sh \
  aristotles_results/<id>_aristotle \
  aristotles_results/split-results/<id>
```

## Algorithm

The splitter (`RequestProject/SplitDecls.lean`, 274 lines):

1. **`importModules`** — loads the Lean4 environment with mathlib
2. **`declsInModules`** — kernel-level `getModuleIdxFor?` index lookup (NOT regex)
3. **`bfsClosure`** — multi-root BFS within the declaration NameSet universe
4. **`topoSort`** — iterative depth-first post-order (O(V+E), cycle-safe)
5. **`emitDeclFile`** — one `.lean` stub per declaration: `import Split.<dep>`
6. **`emitDeclFlake`** — one `flake.nix` per decl: `path:../<dep>` inputs
7. **`emitDag`** — full dependency graph as JSON

### Key improvements over local `lean-split-decls/SplitDecls.lean`:

| Feature | fa51bcab (274L) | local (223L) |
|---------|-----------------|--------------|
| bfsClosure | Multi-root `Array Name` | Single root |
| topoSort | Iterative DFS post-order | O(n²) loop + maxIter guard |
| Module lookup | `getModuleIdxFor?` (kernel) | String prefix match |
| Config | JSON split-config.json | CLI args only |
| Flake inputs | `path:../<decl>` (relative) | `git+file://...` (hardcoded) |
| Lakefile | mathlib v4.28.0 upstream | meta-introspector fork |

## Per-Project Splitting

`split-aristotle-project.sh` wraps the engine:

1. Detects which `.lean` file has the most declarations (not Main.lean)
2. Creates temp working copy of splitter-engine (symlinks .lake/mathlib)
3. Copies project's RequestProject `*.lean` files into work dir
4. Runs `lake build $MODULE splitdecls`
5. Runs splitter on the best module
6. Cleans up temp dir

Supported modules: automatically picks `RequestProject.MicroLean`,
`RequestProject.SplitDecls`, or first non-Main file with declarations.

## Results

| Metric | Value |
|--------|-------|
| Projects with RequestProject | 61 |
| Projects split successfully | 43 |
| Projects that failed build | 18 |
| Total declarations | 6,698 |
| Top project | MicroLean (4,410 decls) |

## Key Files

| File | Purpose |
|------|---------|
| `RequestProject/SplitDecls.lean` | The splitter (274L) |
| `RequestProject/DupFinder.lean` | Exact duplicate detection |
| `RequestProject/GradedCodeModel.lean` | Graded algebra: grade = dependency depth |
| `RequestProject/ShapeAlgebra.lean` | Algebraic structure on declaration shapes |
| `RequestProject/ProofGeometry.lean` | 7D embedding geometric flow model |
| `lakefile.toml` | Lake build config (splitdecls exe) |
| `.lake/packages/mathlib/` | Cached mathlib (573MB) |

## Related Skills

- [[aristotle-manager]] — Rust CLI that orchestrates download + split-all
- [[aristotle-mathlib-split]] — Unified deduplicated 5,790-declaration pool
- [[aristotle-j-invariant]] — j-invariant prime band stratification
- [[lean-split]] — Per-module Nix flakes for Lean 4 projects
