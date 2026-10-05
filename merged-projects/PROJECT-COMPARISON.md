# Project Comparison - Branches for Review

Two Aristotle projects are tracked here for review and merge.

## Branch 1: project-17da0589 (newer, active)
Downloaded: 2026-10-05

| Category | Files | Notes |
|----------|-------|-------|
| Master docs | `ORION_MASTER_INDEX.md`, `ORION_FUNCTIONAL_WALKTHROUGH.md`, `ORION_LINK_ARCHIVE.md`, `ORION_RUNNING_ROSTER.md` | Core project docs |
| Review rounds | `ROUND_THREE_*`, `ROUND_FOUR_*`, `ROUND_EIGHT_*`, `ROUND_NINE_*`, `ROUND_TEN_REPLY.md` | Iterative reviews |
| Game docs | `GAME_LORE_CODEX.md`, `GAMEPLAY_MECHANICS_SUMMARY.md` | Game design |
| Review artifacts | `SPAGHETTI_LINKS_ROUND_THREE.md`, `EFMW_ZOO_PROOFS_ARENA_REVIEW.md`, `PRE_PUBLICATION_REVIEW.md`, `TEAM_ROSTER_AND_X_REVIEW.md` | Review outputs |
| Source code | `orion/` | Lean 4 source tree |
| Project mgmt | `RequestProject/`, `review/`, `site/` | Work items |

## Branch 2: project-0f9b0981 (older)
Downloaded: 2026-09-27

| Category | Files | Notes |
|----------|-------|-------|
| Design docs | `ENGINE_CATALOG.md`, `HUB_DESIGN.md`, `TOTALITY.md`, `ORION_CHRONICLES_BLUEPRINT.md`, `NEWKIN_COUNCIL.md` | System design |
| Build | `BUILD_GUIDE.md`, `CST_COMPILED_EDITION.md`, `ORION_TOOLS.md` | Build info |
| Project mgmt | `REQUESTED.md`, `REVIEW_NEW_DOCUMENTS.md`, `STATUS_AND_NEXT_STEPS.md`, `NOTES.md` | Work tracking |
| Review | `INCIDENT_REVIEW.md`, `reviews/` | Review outputs |
| Sources | `conformance/`, `external/`, `webapp/` | Assets |

## Common files

Both projects share:
- `README.md` - Aristotle citation info
- `ARISTOTLE_SUMMARY.md` (30KB in branch 2, 127KB in branch 1 — check which is newer)
- `lake-manifest.json` (identical, 3109 bytes)
- `lakefile.toml` (identical, 234 bytes)
- `lean-toolchain` (identical, 25 bytes)

## Merge considerations

1. **ORION_MASTER_INDEX.md** (branch 1) likely supersedes the scattered design docs from branch 2
2. **Game docs** in branch 1 have no counterpart in branch 2
3. **Source trees differ**: branch 1 has `orion/`, branch 2 has `conformance/`, `external/`, `webapp/`
4. **Review rounds**: branch 1 has rounds 3-10; branch 2 has `INCIDENT_REVIEW.md`, `REVIEW_NEW_DOCUMENTS.md`

## Next steps

1. Review `ORION_MASTER_INDEX.md` against branch 2 design docs
2. Compare source trees (`orion/` vs `conformance/`, `external/`, `webapp/`)
3. Decide which review artifacts to preserve
4. Create merged tree and re-deploy
