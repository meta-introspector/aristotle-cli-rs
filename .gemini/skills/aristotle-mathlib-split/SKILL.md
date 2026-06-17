---
name: "aristotle-mathlib-split"
description: "Aristotle Mathlib Split — unified deduplicated pool of 5,790 unique Lean4 declarations from 43 Aristotle projects. Each declaration has a .lean stub and flake.nix with relative path dependencies. Use when building independent Nix flakes for individual Lean declarations, analyzing cross-project dependency graphs, or using the 5,792-node DAG."
---

# aristotle-mathlib-split — Unified Declaration Pool

**Location:** `/mnt/data1/time-2026/05-may/07/arist/aristotles_results/mathlib-split/`
**Size:** 11.3 MB (files only), 71 MB (with DAG)
**Declarations:** 5,790 unique (deduplicated from 6,698 total across 43 projects)
**DAG nodes:** 5,792

## Quick Start

```bash
cd /mnt/data1/time-2026/05-may/07/arist

# Generate from split results
python3 dedup-split.py

# Use a declaration as a Nix flake
nix build "path:aristotles_results/mathlib-split/eq_self"

# Query the DAG
python3 -c "
import json
dag = json.load(open('aristotles_results/mathlib-split/dag.json'))
# Find dependencies of eq_self
print(dag.get('eq_self', []))
"
```

## Architecture

```
43 projects × per-project split
        │
        ▼
┌──────────────────────────────────┐
│  dedup-split.py                  │
│  1. Scan all split-results/*/    │
│  2. Copy first occurrence of     │
│     each unique declaration      │
│  3. Fix flake.nix paths to       │
│     relative (path:../<decl>)    │
│  4. Merge all dag.json files     │
└──────────────┬───────────────────┘
               │
               ▼
┌──────────────────────────────────┐
│  mathlib-split/                  │
│  Split/<decl>/                   │
│    ├── <decl>.lean               │
│    └── flake.nix                  │
│  dag.json                        │
│  lakefile.toml                   │
└──────────────────────────────────┘
```

## Declaration Structure

### `.lean` stub
```lean
import Split.True
import Split.eq_true
import Split.Eq
import Split.rfl

-- eq_self from environment
-- theorem eq_self : ...
-- Stub: this file represents the declaration `eq_self`
```

### `flake.nix`
```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    True.url = "path:../True";        # Relative!
    eq_true.url = "path:../eq_true";
    Eq.url = "path:../Eq";
    rfl.url = "path:../rfl";
  };
  outputs = { self, nixpkgs, flake-utils, True, eq_true, Eq, rfl }:
    # Standard derivation wrapping the .lean file
}
```

## Statistics

| Metric | Value |
|--------|-------|
| Total declarations (pre-dedup) | 6,698 |
| Unique declarations | 5,790 |
| Flake files | 5,792 |
| DAG nodes | 5,792 |
| Duplication ratio | 1.15x |
| Most duplicated | Unit, String, SizeOf (4 projects) |
| Top project | MicroLean (4,410 decls) |

## Top Declarations by Source

| Project | Declarations | Description |
|---------|-------------|-------------|
| `3caa76e8` | 4,410 | MicroLean4 polyglot FFI meta-system |
| `c140fb4b` | 986 | Unknown math project |
| `0fd4acb0` | 890 | Meta-Reflective Rewrite System |
| `c038a247` | 408 | Unknown math project |

## Deduplication Logic

1. Scan all `split-results/*/Split/**/*.lean`
2. First occurrence wins (copied to mathlib-split)
3. Subsequent occurrences skipped (same decl path = same declaration)
4. `flake.nix` paths rewritten from absolute to relative:
   ```
   path:/mnt/data1/.../split-results/PROJ/True  →  path:../True
   ```
5. All project `dag.json` files merged into one master DAG

## Key Files

| File | Purpose |
|------|---------|
| `dedup-split.py` | Deduplication script (3,485 bytes) |
| `mathlib-split/Split/` | 5,790 declaration directories |
| `mathlib-split/dag.json` | Full dependency graph (5,792 nodes) |
| `mathlib-split/lakefile.toml` | Lake build config |

## Related Skills

- [[aristotle-manager]] — Rust CLI that produces the split-results
- [[aristotle-splitter]] — SplitDecls engine
- [[aristotle-j-invariant]] — j-invariant prime band stratification of these decls
