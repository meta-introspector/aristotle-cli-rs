---
name: sparql-gui-tile
description: >-
  SPARQL GUI tile — wraps the SPARQL query GUI at /mnt/data1/time-2026/06/07/sparql-gui.
  Provides a web interface for running SPARQL queries over the IPLD CAR store metadata
  loaded as RDF triples in Oxigraph. Use when running SPARQL queries against the
  DASL block store or building graph visualizations.
---

# sparql-gui-tile — SPARQL Query Interface

**Project:** `/mnt/data1/time-2026/06/07/sparql-gui`
**Status:** Running (pid 12870, tmux window 11)
**Tile kind:** `http-tile`

## Endpoints (to verify)

```bash
curl http://127.0.0.1:PORT/health
curl http://127.0.0.1:PORT/sparql?query=SELECT+*+WHERE+{?s+?p+?o}+LIMIT+10
```

## Tile Registration

```bash
letta-ipld-memory put "tiles/sparql-gui-tile" "SPARQL GUI Tile" < tile-defs/sparql-gui-tile.json
```

## Integration

- Queries the IPLD CAR store's RDF-encoded metadata
- Can join with diagonalize tile's block tree for graph visualization
- Natural candidate for the vector space's "query" dimension
