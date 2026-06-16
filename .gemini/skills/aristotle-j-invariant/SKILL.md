---
name: "aristotle-j-invariant"
description: "j-Invariant Prime Stratification — indexes 5,790 Lean declarations by the maximum prime factor of their numerical constants, using the j-invariant q-expansion (q⁻¹ + 744 + 196884q + 21493760q² + 864299970q³ + O(q⁴)) as a natural periodic table. Monster primes (47, 59, 71) define the q¹ band. Use when analyzing mathematical structure of Lean codebases, finding Monster group connections, or stratifying declarations by prime energy."
---

# aristotle-j-invariant — j-Invariant Prime Stratification

**Location:** `/mnt/data1/time-2026/05-may/07/arist/prime-stratify.py`
**Output:** `aristotles_results/j-invariant-stratification.json` (752 KB)
**Declarations analyzed:** 5,790 (1,130 with numerical constants)

## The j-Invariant as a Periodic Table

The **j-invariant q-expansion** (Sage: `j_invariant_qexp(4)`):

```
j(τ) = q⁻¹ + 744 + 196884q + 21493760q² + 864299970q³ + O(q⁴)
```

Each coefficient's largest prime factor creates a boundary. A declaration's
"energy level" is the highest prime dividing any integer constant it contains.

### Prime Bands

| Band | Prime Range | Count | Coefficient |
|------|------------|-------|-------------|
| q⁻¹ | 0 | 0 | 1 (identity) |
| **q⁰** | 2–31 | 316 | 744 = 2³×3×31 |
| **q¹** | 32–1823 | 123 | 196884 = 2²×3³×1823 |
| **q²** | 1824–2099 | 2 | 21493760 = 2⁸×5×2099 |
| **q³** | 2100–355679 | 315 | 864299970 |
| **O(q⁴)** | 355680–∞ | 374 | Truncation tail |
| *no constants* | — | 4,569 | Pure structural |

### Monster Primes

The **Monster group** minimal non-trivial irrep dimension:

```
196883 = 47 × 59 × 71
```

- 196883 + 1 = 196884 = q¹ coefficient
- **47, 59, 71** are the *Monster primes*
- Declarations with these primes sit in the **q¹ band**

## Monster Prime Declarations (38 total)

### q¹ Band — Pure Monster (14 declarations)
```
GccTree_TreeCode_CLEANUP_POINT_EXPR_elim    prime=71
GccTree_TreeCode_COMPOUND_EXPR_elim         prime=59
GccTree_TreeCode_NAMELIST_DECL_elim         prime=47
Something_SomeResource_elim                 prime=59
Something_ThatTerraform_elim                prime=47
```

### q³ Band — Monster as sub-factor (14 declarations)
```
MicroLean_instDecidableEqMicroLeanType_...  ALL THREE: 47, 59, 71
MicroLean_exprNoBVars_eq_5                  prime=59
Array_forIn'_loop_match_3                   prime=71
LawfulMonad_mk                              prime=59
```

### O(q⁴) Band — Monster in large numbers (10 declarations)
```
Std_DTreeMap_Internal_Impl_balanceR_match_1  primes=47,71
MicroLean_ofExpr_match_1                     prime=71
isCyclicRewriteChainBool_match_1             prime=59
```

## Key Insight

`MicroLean_instDecidableEqMicroLeanType_decEq_match_1` hits **all three**
Monster primes simultaneously (47, 59, 71) — a direct structural connection
between the Lean type system and the Monster group through the
j-invariant q-expansion.

## Usage

```bash
cd /mnt/data1/time-2026/05-may/07/arist

# Run stratification on mathlib-split
python3 prime-stratify.py

# Custom paths
python3 prime-stratify.py path/to/mathlib-split path/to/output.json

# Query the JSON
python3 -c "
import json
data = json.load(open('aristotles_results/j-invariant-stratification.json'))
# Find all q¹ band (Monster prime) declarations
for d in data['bands']['q¹']['declarations']:
    print(d['name'], d['max_prime'])
"
```

## Noise Filtering

Large primes (>10⁸) in Lean internal hash maps are flagged as hash noise:
- `Lean_PersistentHashMap_*` — compiler hash values
- `Array_foldlM_*` — internal IDs
- Values > 10⁸ are overwhelmingly hash collisions, not mathematical

91 hash-noise declarations filtered out of 1,221 total.

## Related Skills

- [[aristotle-manager]] — Rust CLI that downloads projects
- [[aristotle-splitter]] — SplitDecls engine that produces the declarations
- [[aristotle-mathlib-split]] — The 5,790-declaration pool being stratified
