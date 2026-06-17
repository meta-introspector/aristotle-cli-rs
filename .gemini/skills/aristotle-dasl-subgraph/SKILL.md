---
name: "aristotle-dasl-subgraph"
description: "DASL/IPLD/CBOR term filter and commutative subgraph extractor for the mathlib-split declaration pool. Searches 5,790 Lean declarations for DASL-relevant terms (MicroLean polyglot FFI, AristotleWeaver graph layout, codec/serialize), extracts depth-8 dependency subgraph, removes mega-hubs, and outputs JSON + Mermaid diagrams. Use when building DASL knowledge graphs, finding IPLD/CBOR-related code in Lean formalizations, or extracting commutative diagrams from the declaration dependency DAG."
---

# aristotle-dasl-subgraph — DASL/IPLD/CBOR Subgraph Extractor

**Location:** `/mnt/data1/time-2026/05-may/07/arist/dasl-term-filter.py`
**Output:** `aristotles_results/dasl-subgraph/`
**Source:** `aristotles_results/mathlib-split/` (5,790 declarations)

## Quick Start

```bash
cd /mnt/data1/time-2026/05-may/07/arist

# Extract DASL subgraph (depth 8, hub threshold 100)
python3 dasl-term-filter.py

# With custom parameters
python3 dasl-term-filter.py path/to/mathlib-split path/to/output 6 50

# View the Mermaid diagram
cat aristotles_results/dasl-subgraph/dasl-clean.mermaid
```

## Pipeline

```
mathlib-split/ (5,790 decls)
        │
        ▼
[1] Build term index ─── 18,100 unique terms
        │
        ▼
[2] Search DASL patterns ─── 222 seeds
    • microlean (151): emitRust, emitCpp, emitJs, emitCABI, emitEmoji, ...
    • weaver (69): SimpleExpr, BoundingBox, nodeToBox, branchGraph, ...
    • codec (1): utf8Decode, serialize
        │
        ▼
[3] BFS expansion (depth 8) ─── 3,209 nodes, 26,409 edges
    • Forward: dependencies of seeds
    • Backward: dependents of seeds
        │
        ▼
[4] Hub removal (>100 degree) ─── 51 hubs removed
    Bool, Eq, Nat, Array, List, String, ...
        │
        ▼
[5] Main component extraction ─── 3,155 nodes, 17,489 edges
    221 seeds retained in single connected component
```

## DASL Search Patterns

Word-boundary regex patterns covering the DASL/IPLD/CBOR ecosystem:

| Category | Patterns |
|----------|----------|
| IPLD/CBOR | `dasl`, `ipld`, `cbor`, `dag-cbor`, `car-file`, `cid-v1`, `multihash`, `ipfs`, `content-address` |
| Storage | `shmem`, `shared-memory`, `block-store`, `merkledag` |
| Codecs | `multicodec`, `varint`, `protobuf`, `codec`, `encode`, `decode`, `serialize`, `deserialize` |
| Math | `sheaf`, `stalk`, `presheaf`, `topos`, `natural-transformation`, `commutative-diagram` |
| Our code | `aristotle`, `weaver`, `microlean`, `aristotleweaver` |

## Results

### MicroLean (151 seeds)
The verified polyglot FFI meta-system. Core DASL bridge types:

- **Type AST**: `MicroLeanType` — `nat`, `bool`, `function`, `array`, `prod`
- **FFI emitters**: `emitRust`, `emitCpp`, `emitJs`, `emitPython`, `emitEmoji`, `emitCABI`
- **Memory ops**: `isBoxed`, `memOps`, `mem_iff_boxed`, `mem_boxed_incdec`
- **Projection**: `reify`, `ofExpr`, `ofExprPure`, `projectOr`
- **Theorems**: `abi_nat_rust`, `abi_nat_cpp`, `abi_nat_js`, `abi_boxed_iff`, `elaboration_path_total`, `emitters_distinguish`, `not_all_boxed`

### AristotleWeaver (69 seeds)
Graph layout engine for commutative diagrams:

- **AST**: `SimpleExpr` — `app`, `bvar`, `const`, `forallE`, `lam`
- **Layout**: `BoundingBox` (x,y,w,h), `nodeToBox`, `branchGraph_layout_clean`
- **Algorithms**: `disjointBoxes`, `layoutClean`, `layoutClean_const`
- **Samples**: `sampleConfluenceNodeExpr`, `sample_size_pos`

### Codec (1 seed)
- `ByteArray.utf8DecodeChar?` — UTF8 codec decode match

## Output Files

| File | Size | Description |
|------|------|-------------|
| `dasl-clean-subgraph.json` | 1.4 MB | 3,155 nodes, 17,489 edges (main component) |
| `dasl-filtered-subgraph.json` | 464 KB | Intermediate filtered graph |
| `dasl-subgraph.json` | 1.2 MB | Full depth-8 subgraph (3,209 nodes) |
| `dasl-clean.mermaid` | 26 KB | Mermaid diagram (251 lines, 250 edges) |
| `term-index-summary.json` | 20 KB | Match statistics |

## Key Files

| File | Purpose |
|------|---------|
| `dasl-term-filter.py` | Full pipeline: term index → search → BFS → hub filter → component |
| `aristotles_results/mathlib-split/dag.json` | 5,792-node dependency graph |

## Related Skills

- [[aristotle-manager]] — Download and split projects
- [[aristotle-mathlib-split]] — The 5,790-declaration pool
- [[aristotle-j-invariant]] — j-invariant prime stratification
- [[aristotle-splitter]] — SplitDecls engine
