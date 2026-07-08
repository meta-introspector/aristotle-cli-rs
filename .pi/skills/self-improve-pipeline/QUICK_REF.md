# Self-Improvement Pipeline — Quick Reference

## One-shot complete cycle
```bash
aristotle-manager fetch && \
aristotle-manager split-all && \
aristotle-manager merge && \
aristotle-manager dasl-finish && \
aristotle-manager diagonalize --core-only && \
aristotle-manager index
```

## Individual steps

| Step | Command | What it does |
|------|---------|-------------|
| Observe | `aristotle-manager fetch` | Download new/updated projects |
| Orient | `aristotle-manager split-all` | Extract declarations per project |
| Orient | `aristotle-manager merge` | Dedup into unified pool |
| Decide | `aristotle-manager dasl-finish` | Rebuild flakes, update planners |
| Decide | `aristotle-manager diagonalize --core-only` | Find minimal self kernel |
| Act | `aristotle-manager diagonalize --rebuild` | Merge sources → unified workspace |
| Act | `aristotle-manager index` | Build DASL blocks.json |
| Meta | `aristotle-manager next` | OODA loop: check planners, do next |

## Sub-modes of diagonalize

| Flag | Purpose |
|------|---------|
| `--core-only` | Find minimal self-referential kernel (91 decls) |
| `--rebuild` | Merge arist+vendormod+split-decls → unified/ |
| `--from-lattice` | Regenerate workspace from variant index |
| `--repair` | SPARQL queries + GOAP fixes |
| `--dry-run` | Preview without executing |
