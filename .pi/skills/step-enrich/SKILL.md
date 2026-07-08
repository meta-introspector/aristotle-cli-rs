---
name: step-enrich
description: >-
  Build DASL blocks.json index, NotebookLM text exports, refusal audits,
  glossaries, and failure corpora. Phase 6 of the self-improvement cycle.
---

# Step: enrich — Build Indexes, Glossaries & Exports

Final phase of the self-improvement cycle. Turns processed data into
useful artifacts for DASL, agents, and human review.

## Commands

```bash
# DASL block index
aristotle-manager index
# → aristotle-blocks.json  (scans all project dirs + source)

# NotebookLM ingestion
aristotle-manager notebooklm --project-dir aristotles_results/xxx_aristotle
# → exports project .lean files as text with word-limit chunking

# Refusal audit
aristotle-manager refusal-audit
# → aristo-refusal-audit.json

# Refusal context extraction
aristotle-manager refusal-context
# → aristo-test-corpus.json

# Failure corpus
aristotle-manager refusal-corpus
# → aristo-failure-corpus.jsonl

# Glossary builder
aristotle-manager refusal-glossary
# → aristo-gnostic-glossary.json
```

## What each artifact is for

| Artifact | Tool | Consumer |
|----------|------|----------|
| `aristotle-blocks.json` | DASL index | Tile viewer, search |
| NotebookLM text | `notebooklm.rs` | LLM training/analysis |
| Refusal audit | `refusal/audit.rs` | Flag helpful/refusal patterns |
| Failure corpus | `refusal/failure.rs` | Train on error patterns |
| Glossary | `refusal/glossary.rs` | Term extraction for agents |

## Key Files

| File | Purpose |
|------|---------|
| `src/index.rs` | DASL blocks.json builder |
| `src/notebooklm.rs` | NotebookLM text chunking |
| `src/refusal/` | Audit, context, extract, glossary, failure modules |

## Related Skills

- [[self-improve-pipeline]] — Full cycle overview
- [[step-diagonalize]] — Previous step
- [[dasl-indexers]] — DASL index details
