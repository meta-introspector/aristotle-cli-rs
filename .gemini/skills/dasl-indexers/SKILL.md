---
name: dasl-indexers
description: >-
  Index any data directory into the DASL IPLD CAR block store. 4 Python scripts
  (aristotle-index, spool-index, master-index, dasl-report) + Rust aristotle-manager
  with `index` command. Use when adding new data sources to DASL, running block
  store analytics, or generating commutative proofs.
---

# dasl-indexers — DASL Data Indexers

Four Python scripts + one Rust binary for indexing arbitrary data into the
DASL IPLD CAR block store.

**Location:** `~/projects/diagonalize/scripts/`

## Quick Test

```bash
cd ~/projects/diagonalize/.kilo

# Index pastebin + notebooklm (15,640 blocks, <1s)
python3 spool-index.py -o /tmp/test-blocks.json

# Merge all indexes (no re-scanning, memory-aware)
python3 master-index.py -o /tmp/master-blocks.json

# Full block store report
python3 dasl-report.py --stats --arrows
```

## Scripts

| Script | Purpose | Time |
|--------|---------|------|
| `aristotle-index.py` | Index 208 Lean 4 Aristotle runs | <2s |
| `spool-index.py` | Index 15,640 pastebin + notebooklm entries | <1s |
| `master-index.py` | Merge all indexes (memory-aware) | <1s |
| `dasl-report.py` | Block store analytics (7 sections) | varies |

## Rust Binary

```bash
cd ~/projects/arist
cargo run --release -- index
```

46 tests passing. 9 commands total: poll, build, download, split, merge, test,
results, configure, clean, **index**.

## Index a New Directory

1. Create `my-indexer.py` using the template from `~/DOCS/DASL_INDEXING_GUIDE.md`
2. Run it: `python3 my-indexer.py -o my-blocks.json`
3. Feed to DASL: `letta-ipld-memory index /mnt/data1/dasl-cache/ --output /mnt/data1/dasl-cache/blocks.json`
4. Verify: `curl http://127.0.0.1:8082/api/stats | jq .total_blocks`

## Block Schema

```json
{
  "path": "namespace/category/identifier",
  "description": "Human-readable title",
  "size": 12345,
  "cid": "",
  "read_only": false,
  "category": "CATEGORY_NAME"
}
```

## Current Index (master-blocks.json)

```
PASTEBIN              : 15,583
MATH/OTHER            :    150
NOTEBOOKLM            :     57
MATH/MONSTER          :     36
LEAN/PROOF            :     20
MATH/CFSG             :      2
TOTAL                 : 15,848
```

## Integrating with DASL Tiles

```bash
# Feed into diagonalize tile
cp .kilo/master-blocks.json /mnt/data1/dasl-cache/
letta-ipld-memory index /mnt/data1/dasl-cache/ \
  --output /mnt/data1/dasl-cache/blocks.json

# Clear cache to refresh
curl http://127.0.0.1:8082/api/cache/clear

# Query via MCP
echo '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"diag_get_stats","arguments":{}}}' \
  | python3 .kilo/tile-server/mcp_server.py | jq .
```

## Lean 4 Proofs

All indexing supports the commutative proof:
- `.kilo/lean-proofs/CommutativeSquare.lean`
- `.kilo/lean-proofs/GrantSpecProof.lean`
- `.kilo/lean-proofs/ProofObligations.lean`

Full proof: `.kilo/COMMUTATIVE_PROOF.org`

## Related Skills

- `diagonalize-tile` — Block tree viewer on port 8082
- `dasl-tiles-mcp` — MCP server for tile monitoring
- `dasl-tile-guide` — Complete tile deployment guide
- `cargo-vendormod` — Git submodule vendoring
