---
name: "doc-watcher-sync"
description: "Watch .kilo/plans/*.md, .kilo/commands/*.md, and .kilo/agents/*.md then sync to ~/DOCS with stable slugs and last-updated stamps."
---

# DOC Watcher Sync Skill

Use this when you want authoritative `.kilo` docs mirrored into `~/DOCS` for readable `file://` delivery without losing the canonical source-of-truth paths.

## Files of interest

- `.kilo/plans/*.md`
  - `plans/1780330072996-tidy-squid.md`
  - `kilo.json` / `AGENTS.md`
- `plans/1780330072996-tidy-squid.md` (note: **deprecated source**; use `.kilo/plans/...` unless an earlier naming convention is in use.)

## Sync Smells

- mirror not present under `/home/mdupont/DOCS`
- export script missing from `doc_watcher/` package
- `~/DOCS` mtime older than `.kilo/plans/*.md`

## Routes (api convention; implementations may vary)

| Route | Path |
|-------|------|
| `.kilo/plans/*.md` | `/home/mdupont/DOCS/docs/plans/{slug}.html` |
| `.kilo/commands/*.md` | `/home/mdupont/DOCS/docs/commands/{slug}.html` |
| `.kilo/agents/*.md` | `/home/mdupont/DOCS/docs/agents/{slug}.html` |
| `~/DOCS` preview mounts | `file:///home/mdupont/DOCS/docs/...`
