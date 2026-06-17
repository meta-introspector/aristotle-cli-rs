# DAG-CBOR Lean4 Splitter — Integrated Plan

## Architecture

```
.lean source files
       │
       ▼
┌──────────────────────┐
│  Lean4Introspector   │  (user-space Lean, ToJson for all kernel types)
│  process.sh          │
│  → data/*.json       │  (CID-addressed: ConstantInfo.thmInfo_<cid>.json)
└──────────────────────┘
       │
       ▼
┌──────────────────────┐
│  Rust bridge         │  (in aristotle-manager or ipld-car-ipc-shmem-linux)
│  json → DAG-CBOR     │  (serde_ipld_dagcbor)
│  → IPLD CAR shmem    │  (CAR-of-CARs token-dedup store)
└──────────────────────┘
       │
       ▼
┌──────────────────────┐
│  DASL tiles          │  (diagonalize, sparql-gui, tile-viewer)
│  - Block tree nav    │
│  - SPARQL queries    │
│  - Graph viz         │
└──────────────────────┘
```

## What Already Exists

### Lean4Introspector (already working!)
- `~/seealso/Lean4Introspector/src/LeanIntrospector.lean` — 1057 lines of `ToJson` instances
- Output: `data/` with JSON files content-addressed by CID
- Uses standard `Lean.Meta` — no kernel patches needed*
- Already processes environment declarations and emits per-type JSON

### IPLD CAR Shmem (already working!)
- `~/dasl/ipld-car-ipc-shmem-linux/` — CAR-of-CARs store
- Unix socket API for push/query
- Token-level dedup + content-addressed blocks
- `d8-2a` CBOR tag 42 (CID) monitoring via eBPF

### DASL Tiles (already deployed!)
- `diagonalize-tile` — IPLD block tree viewer (port 8082)
- `sparql-gui` — SPARQL over Oxigraph/JSON-LD
- `tile-viewer` — tile navigation

## What's Needed

### Step 1: JSON → DAG-CBOR conversion spec
Map Lean4Introspector JSON schema to DAG-CBOR:
```
ConstantInfo.thmInfo_<cid>.json  →  CBOR tag 42 (CID) block
  { "_type": "ConstantInfo.thmInfo",
    "_cid": "<sha256>",
    "name": "Nat.add_comm",
    "type": "∀ a b, a + b = b + a",
    "levelParams": [...],
    ...
  }
```
Each field becomes a DAG-CBOR map entry. The `_cid` becomes the IPLD CID.
Cross-references (e.g., `type` references other CIDs) become IPLD links.

### Step 2: Rust bridge in aristotle-manager
```rust
// New module: src/cbor_store.rs
pub fn json_to_dag_cbor(json_dir: &Path) -> Result<Vec<Cid>> {
    // 1. Walk data/ directory
    // 2. For each .json file, parse and validate schema
    // 3. Encode as DAG-CBOR using serde_ipld_dagcbor
    // 4. Push to IPLD CAR shmem via Unix socket
    // 5. Return CIDs of top-level blocks
}
```

### Step 3: DASL tile configuration
```json
{
  "id": "lean4-declarations",
  "title": "Lean4 Declaration Graph",
  "source": "ipld://lean4-introspector/root",
  "query": "SELECT ?name ?type WHERE { ?s <type> ?type ; <name> ?name }"
}
```

### Step 4: Aristotle integration
Once declarations are in IPLD CAR shmem:
- Aristotle can consume CBOR blocks directly (no JSON)
- DASL SPARQL tile can query "which theorems are unproven?"
- diagonalize can show declaration dependency graph

## Path Forward

1. Verify Lean4Introspector builds and runs against stock Lean4
2. Define DAG-CBOR schema (map JSON fields to IPLD blocks)
3. Add `json_to_dag_cbor` to aristotle-manager Rust code
4. Register in DASL tile system
5. Re-run Aristotle pipeline with CBOR output
