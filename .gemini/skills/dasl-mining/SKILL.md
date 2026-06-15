---
name: dasl-mining
description: >-
  Execute the three-phase DASL codebase mining pipeline — discover submodules
  with vendormod, cross-reference objects between repos, deep-scan each with
  deep_scanner. Use when analyzing the DASL monorepo structure.
---

# dasl-mining — DASL Codebase Mining Pipeline

Three-phase pipeline for systematic DASL corpus analysis.

## Phase 1: Discover & Classify (vendormod)

```bash
# Discover all git repos under ~/dasl
cd ~/dasl
find . -name '.git' -not -path '*/node_modules/*' -not -path '*/target/*' \
  | sed 's|/\.git||' | sort > analysis/dasl_repos.txt

# Classify by language, extract project name and remotes
# → output: analysis/phase1_classified.json, phase1_graph.json
```

**Key modules:** `submodule_discovery.rs`, `lang_detect.rs`, `workspace.rs` in vendormod.

## Phase 2: Cross-Repo Object Linking

- Extract shared Cargo.toml dependencies (explicit links)
- Find common byte-level constants (≥4 bytes, ≥2 repos, not plaintext)
- Cross-reference CBOR/IPLD protocol constants
- Identify semantic overlaps (same problem, different language)

Output: `analysis/phase2_links.json`

## Phase 3: Deep-Scan Each Repo

```bash
# Priority order: most-depended-upon → CBOR decoders → apps → other languages
deep_scanner --lang rs --output ./analysis/<repo-path> --workspace
```

Output per repo: Markov model, constant finder results, CAR file analysis.

## Integration

- Phase 1 feeds Phase 2 (dependency parsing) and Phase 3 (repo list)
- Phase 2's graph determines Phase 3 scan priority
- Phase 3 discovers new constants → feeds back into Phase 2
- All results stored as CAR pages in ipld-car-shmem-server

## Related Tools

- `cargo-vendormod` — submodule discovery, language detection
- `deep_scanner` — per-file analysis (Markov, spectral, constants)
- `ipld-car-shmem-server` — CAR page storage for analysis results
- `dasl-shmem-client warm ~/dasl` — pre-load corpus into shared memory
