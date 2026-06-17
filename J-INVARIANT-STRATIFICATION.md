# Aristotle Manager — j-Invariant Prime Stratification

## The j-Invariant as a Periodic Table

The **j-invariant q-expansion** (Sage: `j_invariant_qexp(4)`) defines natural prime bands:

```
j(τ) = q⁻¹ + 744 + 196884q + 21493760q² + 864299970q³ + O(q⁴)
```

Each coefficient's largest prime factor creates a boundary. A declaration's
"energy level" is the highest prime dividing any integer constant it contains.

### Prime Bands

| Band | Prime Range | Max Prime | Coefficient | Physics |
|------|------------|-----------|-------------|---------|
| q⁻¹ | 0 | 0 | 1 | Identity origin |
| **q⁰** | 2–31 | 31 | 744 = 2³×3×31 | Foundation |
| **q¹** | 32–1823 | 1823 | 196884 = 2²×3³×1823 | **Monster emergence** |
| **q²** | 1824–2099 | 2099 | 21493760 = 2⁸×5×2099 | Moonshine harmonics |
| **q³** | 2100–355679 | 355679 | 864299970 | Higher irreps |
| O(q⁴) | 355680–∞ | — | Truncation bound | Transcendental tail |

### Monster Primes

The **Monster group** minimal non-trivial irrep dimension:

```
196883 = 47 × 59 × 71
```

- 196883 + 1 = 196884 = q¹ coefficient
- **47, 59, 71** are the *Monster primes*
- Declarations containing these primes are in the **q¹ band**

## Stratification Results

| Band | Declarations | Key Contents |
|------|-------------|--------------|
| q⁻¹ | 0 | (no numeric constants use prime 0) |
| **q⁰** | 316 | Foundation: basic types, EQ, AND, OR, tree codes |
| **q¹** | 123 | Monster emergence: GCC tree codes, `Something_*` modules |
| **q²** | 2 | `decide_eq_true_eq`, `instMonadLiftTOfMonadLift` |
| **q³** | 315 | Higher irreps: Pattern matching, Std library, `MicroLean` |
| **O(q⁴)** | 374 | Transcendental: Hash table internals, large factorizations |
| *no constants* | 4,569 | Pure type-level / structural declarations |

**Total declarations**: 5,790

## Declarations Using Monster Primes (47, 59, 71)

### q¹ Band — Direct Monster primes (14 declarations)

```
GccTree_TreeCode_CLEANUP_POINT_EXPR_elim    prime=71  (71)
GccTree_TreeCode_COMPOUND_EXPR_elim         prime=59  (59)
GccTree_TreeCode_NAMELIST_DECL_elim         prime=47  (47)
Something_SomeResource_elim                 prime=59  (59)
Something_ThatTerraform_elim                prime=47  (47)
...
```

### q³ Band — Monster primes as sub-factors (14 declarations)

```
MicroLean_instDecidableEqMicroLeanType_...  ALL THREE: 47, 59, 71  (max_p=55837)
MicroLean_exprNoBVars_eq_5                  prime=59  (max_p=16033)
MicroLean_ofExprPure_eq_2                   prime=59  (max_p=1389251)
Array_forIn'_loop_match_3                   prime=71  (max_p=15139)
```

### O(q⁴) Band — Monster primes in large numbers (9 declarations)

```
Std_DTreeMap_Internal_Impl_balanceR_match_1  primes=47,71  (max_p=157157437)
MicroLean_ofExpr_match_1                     prime=71  (max_p=9465601)
isCyclicRewriteChainBool_match_1             prime=59  (max_p=177831847)
```

## The Architecture

```
j(τ) q-expansion prime bands
        │
        ▼
┌──────────────────────────────────┐
│  aristotle-manager download      │  169 projects from Aristotle API
│  164 downloaded, 960MB           │
└──────────────┬───────────────────┘
               │
               ▼
┌──────────────────────────────────┐
│  splitter-engine (fa51bcab)      │  SplitDecls.lean: 274 lines
│  Multi-root BFS, DFS topo sort   │  Lake build with mathlib v4.28.0
│  43 projects split successfully  │  Kernel-level module index
└──────────────┬───────────────────┘
               │
               ▼
┌──────────────────────────────────┐
│  split-results/                  │  6,698 total declarations
│  <project>/Split/<decl>/         │  Per-project transitive closures
│    ├── <decl>.lean               │  import Split.<dep> stubs
│    └── flake.nix                 │  path:../<dep> inputs
└──────────────┬───────────────────┘
               │
               ▼
┌──────────────────────────────────┐
│  mathlib-split/ (dedup-split.py) │  5,790 unique declarations
│  11.3 MB, relative flake paths   │  5,792 DAG nodes
└──────────────┬───────────────────┘
               │
               ▼
┌──────────────────────────────────┐
│  j-invariant-stratification.json │  Prime band index
│  prime-stratify.py               │  1,130 with constants
│  q⁰: 316, q¹: 123, q²: 2,       │  Monster primes: 47,59,71
│  q³: 315, O(q⁴): 374            │  Hash noise filtered: 91
└──────────────────────────────────┘
```

## Key Files

| File | Purpose |
|------|---------|
| `src/main.rs` | CLI: download, split-all, index, notebooklm, merge |
| `splitter-engine/RequestProject/SplitDecls.lean` | The splitter (274L, multi-root BFS + iterative DFS) |
| `split-aristotle-project.sh` | Per-project split wrapper (build + split) |
| `dedup-split.py` | Deduplicate + fix flake paths to relative |
| `prime-stratify.py` | j-invariant prime band stratification |
| `DOCUMENTATION.md` | Full system documentation |
| `aristotles_results/j-invariant-stratification.json` | 752 KB stratification output |

## Quick Start

```bash
# Download all projects
cargo run --release -- download -j 2

# Split all projects into per-declaration flakes
cargo run --release -- split-all

# Deduplicate into unified mathlib-split
python3 dedup-split.py

# Stratify by j-invariant prime bands
python3 prime-stratify.py

# Use a declaration as a Nix flake
nix build "path:aristotles_results/mathlib-split/eq_self"
```
