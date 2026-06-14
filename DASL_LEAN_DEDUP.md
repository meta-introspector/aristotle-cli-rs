# Math-Split Dedup Engine — Documentation

## Project: `fa51bcab` ("split math lib")

A **Lean4-native mathematical deduplication engine** that models code as a graded algebra
and uses sheaf theory, Clifford algebras, and commutative diagram geometry to detect
duplicate and similar declarations.

**Location**: `/mnt/data1/time-2026/05-may/07/arist/fa51bcab-be78-4427-b05c-27c58cdd8584_aristotle/output-final_aristotle/`

---

## Architecture

### Core Pipeline

```
Lean Environment (mathlib4)
        │
        ▼
┌───────────────────┐
│   DupFinder.lean  │  Load env, hash types, find exact duplicates
│   (dedup engine)  │  Grade by dependency depth
└───────┬───────────┘
        │
        ▼
┌───────────────────┐
│ SplitDecls.lean   │  Extract every decl with exact deps
│   (splitter)      │  Emit one .lean + flake.nix per decl
└───────┬───────────┘
        │
        ▼
  split-out/{decl}/
    ├── decl.lean       # stub with dependency imports
    ├── flake.nix       # independent nix build
    └── dag.json        # full dependency graph
```

### Mathematical Models (4 layers)

#### Layer 1: Exact Duplicate Detection (`DupFinder.lean`)
- Scans all constants in the Lean `Environment`
- Theorems: duplicate if **statement type** is structurally equal (α-equivalence)
- Definitions: duplicate if **type + body** are both structurally equal
- Uses type-hash bucketing for O(n) grouping
- Output: `duplicates.txt`, `duplicates.json`, `graded.json`

#### Layer 2: Graded Algebra Model (`GradedCodeModel.lean`)
- Each declaration = variable in `MvPolynomial Decl R`
- Dependency multiset = monomial (each dep counted with multiplicity)
- **Grade** = weighted total degree = dependency depth in the DAG
- `codeGradedAlgebra`: proven `GradedAlgebra` instance
- **Duplicate** = equal dependency multisets → equal algebra elements
- **Similar** = same grade → same homogeneous component
- `IsDuplicate` and `IsSimilar` are equivalence relations, duplicates refine similars

#### Layer 3: Geometric Flow Model (`ProofGeometry.lean` + `ArithmeticKernel.lean`)
- Embeds declarations into **7D act-space** via type-shape size words (`SevenDEmbedding`)
- Proofs/declarations → geometric objects with **flows**
- `flow_eq_head_sub_tail`: flow depends only on endpoint coordinates
- **`kernel_flow_commutative`**: parallel paths in commutative diagrams → identical 7D displacement = duplicates
- **`kernel_flow_exactness`**: exact sequences → zero net flow (duplicates cancel perfectly)

#### Layer 4: Shape-Theoretic Analysis (`Shape*.lean`)
- `ShapeAlgebra.lean` — algebraic structure on declaration shapes
- `ShapeCliffordGenuine.lean` — Clifford algebra structure (Pin/Spin groups on declarations)
- `ShapeBott.lean` — Bott periodicity (8-periodic structure)
- `ShapeHarmonic.lean` — harmonic analysis on the declaration space
- `ShapeStructural.lean` — sheaf-theoretic structure
- `PeriodicTable.lean` — Mendeleev-style periodic classification of declarations

### Analysis Tools

| File | Purpose |
|------|---------|
| `ClusterDecls.lean` | Cluster declarations by shape similarity |
| `Coverage.lean` | Analyze coverage of declaration space |
| `DepthFinder.lean` | Compute dependency depth per declaration |
| `SizeFinder.lean` / `SizeSignature.lean` | Size metrics + signatures |
| `ArrowFinder.lean` | Find morphisms (dependencies) between declarations |
| `WordCloudFinder.lean` | Word frequency analysis of declaration names |
| `SemanticDupFinder.lean` | Semantic (not just syntactic) dedup |
| `ProofTermFinder.lean` | Extract proof terms from theorems |
| `CFTMorphisms.lean` | CFT/vertex algebra morphisms on code |

---

## Generated Outputs

### `split-out/` (environment-based, mathlib4 subset)
- **595 declarations** split from the target module
- Each in its own directory with `flake.nix`
- `dag.json`: 597-line dependency graph
- `lakefile.toml`: build config referencing mathlib4

### `split-self/` (reflexive split)
- **2,791 declarations** — the splitter splitting itself + transitive deps
- **2,792 flake.nix** files
- `dag.json`: 2,794-line dependency graph

---

## Building and Running

### Prerequisites
- Lean 4.29+ with `lake`
- mathlib4 (v4.28.0) cached

### Build
```bash
cd fa51bcab-be78-4427-b05c-27c58cdd8584_aristotle/output-final_aristotle
lake build
```

### Run DupFinder
```bash
# On a specific module
lake exe dupfinder Mathlib.Algebra.Vertex.HVertexOperator ./dup-out

# Using config file
echo '{"modules":["Mathlib.Algebra.Vertex.HVertexOperator"],"outputDir":"./dup-out"}' > dup-config.json
lake exe dupfinder
```

### Run SplitDecls
```bash
lake exe splitdecls RequestProject.SplitDecls ./split-self
```

---

## Key Theorems Proved

1. **`codeGradedAlgebra`** — The code algebra is a genuine `GradedAlgebra`
2. **`declElt_mem_grade`** — A declaration sits in its grade's homogeneous component
3. **`IsDuplicate` / `IsSimilar`** — Equivalence relations, duplication refines similarity
4. **`kernel_flow_commutative`** — Parallel paths in commutative diagrams have identical 7D displacement
5. **`kernel_flow_exactness`** — Exact sequences have zero net flow
6. **`grade_eq_of_duplicate`** — Duplicate declarations have equal grades

---

## Integration with aristotle-manager

The Rust `aristotle-manager` tool:
1. Downloads Aristotle projects (done: 156 projects, 149 extracted)
2. Runs `static_split.py` for regex-based static split (done: 35,998+ flakes)
3. **TODO**: Run `DupFinder` on the Lean environment for dedup analysis
4. **TODO**: Apply GradedCodeModel to identify near-duplicates across projects
5. **TODO**: Feed dedup results back into split to merge duplicates

### Makefile targets

```makefile
# Run dedup on mathlib4 environment
dedup:
    cd $(ARIST_DIR)/fa51bcab-*/output-final_aristotle && \
    lake exe dupfinder Mathlib.Algebra.Vertex.HVertexOperator ./dup-out
```
