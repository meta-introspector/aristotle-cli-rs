# DASL Aristotle Pipeline — Complete System Documentation

## The Architecture

```
                    aristotle.harmonic.fun API
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│  aristotle-manager (Rust CLI, 1,600 lines)              │
│  download -j 2  →  191 projects, 960 MB                 │
│  split-all     →  43 projects split, 6,698 declarations │
│  index         →  DASL blocks.json (Monster/CFSG/Lean)  │
└──────────────────────┬──────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────┐
│  aristotle-splitter (SplitDecls.lean, 274 lines)        │
│  Multi-root BFS + iterative DFS topo sort               │
│  Kernel-level module index (getModuleIdxFor?)           │
│  Per-project: build → split → flake.nix per declaration │
└──────────────────────┬──────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────┐
│  aristotle-mathlib-split (dedup-split.py)               │
│  5,790 unique declarations from 6,698 total             │
│  5,792 DAG nodes, all paths relative (path:../<decl>)   │
│  Git committed: baa1370, 11,584 files, 4.8 MB           │
└────────┬─────────────────────────┬──────────────────────┘
         │                         │
         ▼                         ▼
┌─────────────────────┐  ┌────────────────────────────────┐
│  aristotle-j-       │  │  aristotle-dasl-subgraph       │
│  invariant          │  │  18,100 term index             │
│                     │  │  222 DASL seeds → 3,155 nodes  │
│  j(τ) = q⁻¹ + 744   │  │  17,489 edges at depth 8      │
│  + 196884q          │  │  51 hubs filtered              │
│  + 21493760q²       │  │  MicroLean (151) + Weaver (69) │
│  + 864299970q³      │  │  + codec (1) + DA51 (1)       │
│  + O(q⁴)            │  │                                │
│                     │  └───────────────┬────────────────┘
│  Prime bands:       │                  │
│  q⁰:   2-31  (316)  │                  ▼
│  q¹: 32-1823 (123)  │  ┌────────────────────────────────┐
│  q²: 1824-2099 (2)  │  │  aristotle-locate2proof        │
│  q³: >2100   (315)  │  │  47,482 files → 9,751 unique   │
│  O(q⁴): tail (374)  │  │  61 canonical DASL proofs      │
│                     │  │  DA51 (20), fractran (14),      │
│  Monster primes:    │  │  qbert (3), monster-osm (9),   │
│  196883 = 47·59·71  │  │  sidechain (5), others (10)    │
└─────────────────────┘  └────────────────────────────────┘
```

## The Mathematical Core

### j-Invariant Prime Bands

The j-invariant q-expansion (Sage: `j_invariant_qexp(4)`) acts as a
periodic table for mathematical structure:

```
j(τ) = q⁻¹ + 744 + 196884q + 21493760q² + 864299970q³ + O(q⁴)
```

| Band | Prime Range | Coeff Factorization | Physics |
|------|------------|-------------------|---------|
| q⁻¹ | 0 | 1 | Identity origin |
| q⁰ | 2–31 | 744 = 2³×3×31 | Foundation |
| q¹ | 32–1823 | 196884 = 2²×3³×1823 | Monster emergence |
| q² | 1824–2099 | 21493760 = 2⁸×5×2099 | Moonshine harmonics |
| q³ | 2100–355679 | 864299970 | Higher irreps |
| O(q⁴) | >355679 | — | Transcendental tail |

### Monster Primes

```
196883 = 47 × 59 × 71          (Monster minimal non-trivial irrep)
196884 = 196883 + 1             (q¹ coefficient — "Moonshine +1")
```

The 15 supersingular primes span the Clifford algebra basis Cl(15,0,0):

```
[2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]
                                                      └─ Monster primes
```

### DA51 CBOR Encoding

Every mathematical structure is serialized through the DA51 CBOR layer:

```
Lean4 Type/Proof ──→ CborVal ──→ ByteArray ──→ .cbor file
                                      │
                           ┌──────────┘
                           ▼
                    Round-trip verified
                    Self-apply quine test
                    Exec: RDF triple = instruction
```

## DA51 Core Module (20 files, 1,988 lines, 258 declarations)

### Layer 0: CBOR Codec
- `CborVal.lean` — CBOR value type: cnat, cneg, cbytes, ctext, carray, cmap, ctag
- `Encode.lean` — Encoder: major types (0x00-0xa0), varint, definite/indefinite
- `Decode.lean` — Decoder: ByteArray → Option CborVal
- `RoundTrip.lean` — encode ∘ decode = id proofs
- `RealRoundTrip.lean` — concrete shard round-trip with clifford.rs

### Layer 1: Monster Group
- `Monster.lean` — Monster element as CBOR term, 15 SSP slots
- `CubicalKernel.lean` — Cl(15,0,0) basis: `sspPrimes = [2,3,5,7,11,13,17,19,23,29,31,41,47,59,71]`
- `Hecke.lean` — Hecke operator τ(p) on Monster coordinates
- `Vertex.lean` — VOA instance (V, Y, 1, ω) over CborVal
- `HVertex.lean` — Bridge to mathlib `HVertexOperator Γ R V W := V →ₗ[R] HahnModule Γ R W`
- `Borcherds.lean` — Borcherds' Monstrous Moonshine (4 proof steps)

### Layer 2: Algebra + Graph
- `Conformal.lean` — Phase transition Type ↔ Data (conformal mapping)
- `Bivector.lean` — Long-range bivectors, 416/455 trivector census
- `Ternary.lean` — RDF triples in 3^20 (Monster 3-Sylow: |M| has 3^20)
- `MultiAttractor.lean` — Leech lattice 24D basin attractors, Borcherds no-ghost

### Layer 3: Reflection
- `Reflect.lean` — Compile-time Lean4 environment → DA51 CBOR
- `SelfApply.lean` — Quine: encode→decode→re-encode grade stability
- `Exec.lean` — DA51 shard as executable (RDF triple = opcode)
- `Theories.lean` — Fractran-vm symbolic regression discoveries
- `TestReflect.lean` — `#da51_reflect_to "/tmp/lean4_env.cbor"`

## The Complete DASL Proof Ecosystem (61 canonical files)

| Source | Files | Key Contents |
|--------|-------|-------------|
| **DA51 core** | 20 | CBOR encode/decode, Monster, Hecke, Vertex, Borcherds |
| **fractran-vm** | 14 | Monster fractran, codebook, labeler, compression |
| **qbert/oracle** | 3 | MonsterResonance, VertexAlgebra |
| **monster-osm** | 9 | Spiral proofs (kant, spiral1-3) |
| **zkperf sidechain** | 5 | Bills, FederalGov, Governance, VotingProtocol |
| **meta-introspector** | 2 | ExportCFT, CFTReflection |
| **dasl merged** | 3 | HeckeOperators Abstract/Concrete, monsterLie/VOA |
| **binding-ontology** | 2 | clifford_rs, ontology_global |
| **experiments** | 3 | DA51HVertex, HeckeOperators |

## Command Reference

### Download & Split
```bash
cd /mnt/data1/time-2026/05-may/07/arist
cargo build --release

# Download new projects (skips already-downloaded)
./target/release/aristotle-manager download -j 2

# Split all projects into per-declaration flakes
./target/release/aristotle-manager split-all

# Preview what will be split
./target/release/aristotle-manager split-all --dry-run
```

### Deduplicate
```bash
python3 dedup-split.py
```

### Stratify by j-Invariant Prime Bands
```bash
python3 prime-stratify.py
# Output: aristotles_results/j-invariant-stratification.json (752 KB)
```

### Extract DASL Subgraph
```bash
python3 dasl-term-filter.py
# Output: aristotles_results/dasl-subgraph/
#   dasl-clean-subgraph.json (3,155 nodes, 17,489 edges)
#   dasl-clean.mermaid (Mermaid diagram)
```

### Search for DASL Proofs via locate
```bash
# Collect locate results
locate monster cbor hecke dasl DA51 | grep '\.lean$' > locate-results.txt

# Deduplicate to canonical set
python3 -c "
from pathlib import Path
files = set(Path('locate-results.txt').read_text().splitlines())
canonical = [f for f in files if any(p in f for p in 
    ['DA51','fractran-vm','qbert','monster-osm','zkperf-private'])]
Path('dasl-canonical.txt').write_text('\n'.join(sorted(canonical)))
"
```

### Build Individual Declaration
```bash
cd aristotles_results/mathlib-split
nix build "path:MicroLean/MicroLeanType"
```

## Key Files

| Path | Lines | Purpose |
|------|-------|---------|
| `src/main.rs` | 1,600 | CLI dispatcher, download, split, build, merge |
| `src/index.rs` | 198 | DASL blocks.json indexer |
| `splitter-engine/RequestProject/SplitDecls.lean` | 274 | Multi-root BFS + iterative DFS splitter |
| `split-aristotle-project.sh` | 100 | Per-project split wrapper |
| `dedup-split.py` | 101 | Deduplication + flake path fixer |
| `prime-stratify.py` | 229 | j-invariant prime band stratification |
| `dasl-term-filter.py` | 156 | DASL/IPLD/CBOR subgraph extraction |
| `dasl-index-scanner.py` | 130 | DASL index file scanner |
| `locate2proof-collect.py` | 100 | locate result collector |
| `DOCUMENTATION.md` | — | Full system docs |
| `J-INVARIANT-STRATIFICATION.md` | — | Prime band index |

## Agent Skills (6)

| Skill | Location | Purpose |
|-------|----------|---------|
| `aristotle-manager` | `~/dotagents/skills/` | Rust CLI for Aristotle pipeline |
| `aristotle-splitter` | `~/dotagents/skills/` | SplitDecls Lean4 engine |
| `aristotle-mathlib-split` | `~/dotagents/skills/` | 5,790-declaration unified pool |
| `aristotle-j-invariant` | `~/dotagents/skills/` | j-invariant prime stratification |
| `aristotle-dasl-subgraph` | `~/dotagents/skills/` | DASL/IPLD/CBOR subgraph |
| `aristotle-locate2proof` | `~/dotagents/skills/` | locate → proof pipeline |

## Agent Skills (6)

| Skill | Location | Purpose |
|-------|----------|---------|
| `aristotle-manager` | `~/dotagents/skills/` | Rust CLI: download, split-all, index, config |
| `aristotle-splitter` | `~/dotagents/skills/` | SplitDecls.lean (274L): multi-root BFS + DFS topo sort |
| `aristotle-mathlib-split` | `~/dotagents/skills/` | 6,143 unique declarations, git committed, relative flake paths |
| `aristotle-j-invariant` | `~/dotagents/skills/` | j(τ) q-expansion prime bands, Monster primes 47·59·71 |
| `aristotle-dasl-subgraph` | `~/dotagents/skills/` | 3,155-node DASL/IPLD/CBOR commutative subgraph at depth 8 |
| `aristotle-locate2proof` | `~/dotagents/skills/` | 61 canonical DASL proofs from 47K locate results |

## Script Inventory (7 Python, 5 Shell)

| Script | Purpose |
|--------|---------|
| `prime-stratify.py` | j-invariant q-expansion prime band stratification |
| `dasl-index-scanner.py` | Scan ~/dasl/index/ for DASL-related .lean files |
| `build-dasl-module.py` | Build canonical dasl-lean/ module (751 decls, 9 categories) |
| `dasl-term-filter.py` | DASL/IPLD/CBOR term filter + depth-8 subgraph extraction |
| `dedup-split.py` | Deduplicate split-results + fix flake paths to relative |
| `locate2proof-collect.py` | Collect locate results → locate2proof config |
| `detect-stale.py` | Detect stale projects (API updated since download) |
| `split-aristotle-project.sh` | Per-project split wrapper (build + split) |
| `split-lean-project.sh` | Low-level single-module splitter |
| `run_notebooklm_all.sh` | Batch NotebookLM export |

## Canonical DASL Module (`aristotles_results/dasl-lean/`)

| Category | Decls | Content |
|----------|-------|---------|
| `dasl/ipld` | 12 | Content addressing, multihash, CID, Merkle DAG |
| `dasl/cbor` | 150 | CBOR encode/decode, codec, round-trip |
| `dasl/monster` | 26 | Monster group, Moonshine, Hecke, vertex operators |
| `dasl/sheaf` | 2 | Sheaf theory, Čech cohomology |
| `dasl/microlean` | 371 | Verified polyglot FFI (Rust/C++/JS/Python/CABI/emoji) |
| `dasl/weaver` | 69 | AristotleWeaver graph layout engine |
| `dasl/journal` | 12 | Content-addressed Merkle journals |
| `dasl/primes` | 16 | Prime factorization, SSP primes |
| `dasl/godel` | 93 | Gödel numbering, reflection, meta-reflective rewrite |

## Documentation Index

| Doc | Path |
|-----|------|
| Quick Reference | `~/DOCS/lean.md` |
| Master Reference | `MASTER-DOCUMENTATION.md` |
| Sheaf Architecture | `SHEAF-ARCHITECTURE.md` |
| DASL Testing Integration | `DASL-TESTING-INTEGRATION.md` |
| System Documentation | `DOCUMENTATION.md` |
| j-Invariant Stratification | `J-INVARIANT-STRATIFICATION.md` |
| Lean Dedup | `DASL_LEAN_DEDUP.md` |

## Statistics

| Metric | Value |
|--------|-------|
| Aristotle projects | 193 |
| Projects with Lean code | 81 |
| Projects successfully split | 59 |
| Total declarations (pre-dedup) | 7,376 |
| Unique declarations (mathlib-split) | 6,143 |
| DASL canonical module | 751 (9 categories) |
| DAG nodes | 6,145 |
| j-invariant: q⁰ band | 329 |
| j-invariant: q¹ band (Monster primes) | 123 |
| DASL subgraph: seeds | 222 (MicroLean 151 + Weaver 69 + codec 1 + DA51 1) |
| DASL subgraph: depth-8 nodes | 3,155 |
| DASL subgraph: depth-8 edges | 17,489 |
| locate: total .lean files | 47,482 |
| locate: unique by filename | 9,751 |
| locate: canonical DASL proofs | 61 |
| DA51 core: files / lines / decls | 20 / 1,988 / 258 |
| Monster primes | 47 · 59 · 71 = 196,883 |
| Sheaf-related projects | 64 |
| Sheaf-related files | 645 |

## Build

```bash
# Rust tool
cd /mnt/data1/time-2026/05-may/07/arist
cargo build --release

# Splitter engine (requires lake + lean in PATH)
cd splitter-engine
lake build splitdecls
```
