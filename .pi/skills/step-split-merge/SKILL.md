---
name: step-split-merge
description: >-
  Split (per-declaration extraction via SplitDecls.lean + multi-language) and
  Merge (deduplicate into unified pool). Phase 2-3 of the self-improvement cycle.
---

# Step: Split + Merge — Declaration Extraction & Deduplication

Part of the self-improvement pipeline after `fetch`.

## split-all

```bash
aristotle-manager split-all            # full run
aristotle-manager split-all --dry-run  # preview
```

Splits every `*_aristotle` project directory:
- **Lean4:** `SplitDecls.lean` via Environment API (exact dependency tracking)
- **Rust:** `split-decls-rs simple-split` via syn AST walking
- **Python:** regex def/class extraction
- **Shared memory:** IPLD CAR shmem server queries
- **Agent logs:** key:value patterns from `ARISTOTLE_SUMMARY.md`

Output: `split-results/<project>/<decl>/declaration.json + flake.nix`

## merge

```bash
aristotle-manager merge
```

Deduplicates across all splitter outputs. Builds unified `mathlib-split/` pool.
Removes duplicate declarations, keeps canonical versions.

## Architecture

```
*_aristotle/  ──→  split-all  ──→  split-results/  ──→  merge  ──→  mathlib-split/
   .lean, .rs,     SplitDecls       per-decl dirs        dedup       unified pool
   .py, .md        + multi-lang     + declaration.json              + flakes
```

## Key Files

| File | Purpose |
|------|---------|
| `splitter-engine/SplitDecls.lean` | Lean Environment API splitter |
| `splitter-engine/MicroLean.lean` | Minimal Lean core for self-ref |
| `split-lean-project.sh` | Shell wrapper for Lean split |
| `split-aristotle-project.sh` | Shell wrapper for Aristotle split |

## Related Skills

- [[self-improve-pipeline]] — Full cycle overview
- [[aristotle-splitter]] — SplitDecls engine details
- [[aristotle-mathlib-split]] — Unified pool details
