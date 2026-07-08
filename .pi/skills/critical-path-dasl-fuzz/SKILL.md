---
name: critical-path-dasl-fuzz
description: >-
  Critical path for completing DASL cross-implementation fuzz testing.
  90% done — 3 remaining tasks to close. Prunes all unneeded pipeline steps.
---

# Critical Path: DASL Fuzz Testing

## State: ~90% Complete

All 6 services running via system-manager. 11 implementations harnessed.
Corpus in shmem. Tiles registered. The only remaining work is wiring
nix-built Rust binaries into the orchestrator and running the final
round-robin comparison.

## UNNEEDED (skip these pipeline steps)

These are part of the broader Aristotle self-improvement pipeline but are
**completely irrelevant** to DASL fuzz testing:

| Step | Why Skip |
|------|----------|
| `fetch` — download new projects | Fuzz corpus is self-contained (360 decls + 157 vectors) |
| `split_all` — per-declaration extraction | Already split and chunked |
| `aristo_merge_order` — prioritize merges | Fuzz doesn't consume Aristotle project pool |
| `merge` — unified pool dedup | Self-contained corpus |
| `diagonalize` — self-application | Gödelian loop doesn't help cross-impl fuzzing |
| `enrich` — indexes, glossaries | Only needed if feeding into DASL tile viewer |
| `ooda-loop` — planner meta-loop | One-shot task, no loop needed |

## CRITICAL PATH (shortest route to done)

```
Step 1: rust-round-robin-conformance
   └─→ nix build .#serdeIpldDagcborRR + n0DaslRR
   └─→ wire into super_harness.sh (done — env vars work)

Step 2: finalize-round-robin-all
   └─→ Collect background job results
   └─→ Generate divergence report
   └─→ Set has_round_robin = true

Step 3: dasl-fuzz-chunk-merge (optional, P1)
   └─→ Handle 53 singletons
   └─→ Compile-test merged chunks
```

Total remaining effort: ~1-2 hours.

## Pruned GOAP Fuzz Manifest

Only these atoms matter for fuzz completion:

| Atom | Current | Needed |
|------|---------|--------|
| `has_round_robin` | 🔄 in progress | true |
| `has_flake` | ✅ true | — |
| `has_car_shmem` | ✅ true | — |
| `has_tile` | ✅ true | — |
| `has_perf_trace` | ✅ true | — |
| `has_cross_ref` | ✅ true | — |

Everything else (has_annotated_spec, has_consolidated_decls, has_atoms,
has_j_key, has_arrows, has_bands, has_cid_index, has_cid_lookup, has_spec_index,
has_tantivy_index, has_dep_graph, has_mycelium, all_infra_done, all_tiles_done)
is **unneeded** for fuzz testing.

## Where to Work

```bash
cd ~/projects/dasl/dasl-testing

# Build Rust round_robin
nix build .#serdeIpldDagcborRR
nix build .#n0DaslRR

# Run conformance
./super_harness.sh conformance

# Run full round-robin
python3 round_robin.py --all --json --batch-size 10
# or: make round-robin-all-bg

# Check progress
tail -f RESULTS/round_robin_all.log
```

## Related Task Dirs

- `~/dotagents/tasks/rust-round-robin-conformance/`
- `~/dotagents/tasks/finalize-round-robin-all/`
- `~/dotagents/tasks/dasl-fuzz-finish/` (project finisher, 90% done)
- `~/dotagents/tasks/CRITICAL_PATH_DASL_FUZZ.md`
