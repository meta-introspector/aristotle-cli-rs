---
name: "consolidate-dasl-org-files"
description: "Clean up duplicate and stale org files in ~/dasl. Merge NOTES.org/notes.org, TASKS.org/tasks.org, archive PLAN.org (superseded by plan.org), check report duplicates, archive numbered plan stubs (02-07), and create a single consolidated TODO.org. Use when cleaning up project documentation, removing duplicates, or consolidating scattered TODO items."
---

# Consolidate Duplicate Org Files in ~/dasl

**Priority:** LOW
**Area:** Cleanup
**Status:** Pending
**Source:** summary-2026-06-08.org

## Duplicates to Merge

| File 1           | File 2         | Action                          |
|------------------|----------------|---------------------------------|
| NOTES.org        | notes.org      | Merge into one, delete other    |
| TASKS.org        | tasks.org      | Merge into one, delete other    |
| PLAN.org         | plan.org       | Archive PLAN.org (superseded)   |
| report-26-06-08.org | report-jun-8.org | Check if duplicates, merge    |

## Stale Files to Archive

| File                              | Last updated | Issue                    |
|-----------------------------------+--------------+--------------------------|
| SPEC.org                          | May 17       | Only TODOs, no work done |
| IMPLEMENTATION.org                | May 17       | Only TODOs, no work done |
| 02-fuzzing-plan.org               | May 17       | Stub, zero progress      |
| 03-constant-invariant-extraction.org | May 17    | Stub, zero progress      |
| 04-test-coverage.org              | May 17       | Stub, zero progress      |
| 05-infra-build.org                | May 17       | Stub, zero progress      |
| 06-car-archive.org                | May 17       | Stub, zero progress      |
| 07-perf-profiling.org             | May 17       | Stub, zero progress      |

## Consolidated TODO.org

Create a single TODO.org that replaces scattered items across:
- plan.org (hypermorphisms, DMZ, eBPF, vendormod, diagonalize)
- status.org (divergence testing, tile servers, RUST-001)
- TODO.org (coverage matrix, spec→impl mapping)
- tasks.org (unknown content)
- TASKS.org (unknown content)

## Steps

```bash
cd ~/dasl

# 1. Check duplicates
diff NOTES.org notes.org
diff TASKS.org tasks.org
diff report-26-06-08.org report-jun-8.org

# 2. Archive stale files
mkdir -p archive/2026-05-stubs
mv SPEC.org IMPLEMENTATION.org 02-*.org 03-*.org 04-*.org 05-*.org 06-*.org 07-*.org archive/2026-05-stubs/
mv PLAN.org archive/2026-05-stubs/

# 3. Merge duplicates
# (manual merge, then delete one of each pair)

# 4. Create consolidated TODO.org
# (pull TODO items from all files into one)
```

## Depends On

Nothing — this is a leaf task.

## Blocks

Nothing directly.
