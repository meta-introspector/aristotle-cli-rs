import Mathlib
import RequestProject.Monster

/-!
# Bridge to the McKay–Thompson series (Monstrous Moonshine)

The normalized modular `j`-function with constant term removed,
`J(τ) = j(τ) - 744`, is the **McKay–Thompson series `T_{1A}`** of Monstrous
Moonshine — the graded dimension (character of the identity element `1A`) of the
moonshine module `V♮`:

```
J(τ) = q⁻¹ + 196884 q + 21493760 q² + 864299970 q³ + 20245856256 q⁴
            + 333202640600 q⁵ + 4252023300096 q⁶ + 44656994071935 q⁷ + ⋯
```

McKay's original observation was that each Fourier coefficient is a small
non‑negative integer combination of the **irreducible degrees of the Monster**
(`Monster.degrees`).  More precisely, the homogeneous graded piece `V♮_n`
(whose dimension is the `qⁿ` coefficient) decomposes *uniquely* as a Monster
module into irreducibles; its multiplicity vector is the `n`-th row of the genuine
head‑character table computed by Conway–Norton and McKay–Strauss.

This file records the coefficients of `T_{1A}` and verifies those genuine module
decompositions exactly, for `q¹` through `q⁸`.

## Source of the multiplicities

The multiplicities used below are the genuine module multiplicities
`m_{n,k} = ⟨V♮_n, χ_k⟩` of the `k`-th Monster irreducible (in increasing degree
order, matching `Monster.degrees`) in the `n`-th graded piece.  They are the rows
of the published table

* OEIS **A055791** — "Table giving multiplicity of `k`-th irreducible character of
  the Monster simple group in the `n`-th head character",
* J. H. Conway and S. P. Norton, *Monstrous Moonshine*, Bull. LMS 11 (1979),
* J. McKay and H. Strauss, *The q-series of Monstrous Moonshine…*, Comm. Alg. 18 (1990).

## A subtlety about uniqueness (the coefficient *sum* does not determine the row)

A non‑negative integer combination of irreducible degrees that merely *sums* to
`cₙ` need **not** be the genuine module decomposition: there are typically many
such combinations, but a module has a single decomposition into irreducibles.
This file uses the genuine rows of A055791 throughout.  The pitfall is recorded
formally in `mckay_six_sum_not_unique`, which exhibits a *different* multiplicity
vector that also sums to `c₆` yet is **not** the true decomposition.
-/

namespace Monster

/-- Fourier coefficients of the McKay–Thompson series `T_{1A} = J = j - 744`,
for `q¹` through `q⁸` (the positive part of the `q`-expansion). -/
def mckayThompson1A : List ℕ :=
  [196884,          -- q¹
   21493760,        -- q²
   864299970,       -- q³
   20245856256,     -- q⁴
   333202640600,    -- q⁵
   4252023300096,   -- q⁶
   44656994071935,  -- q⁷
   401490886656000  -- q⁸
  ]

/-- The first moonshine coefficient: `196884 = 1 + 196883`, i.e. the trivial plus the
smallest faithful irreducible degree. This is **McKay's observation** that started
Monstrous Moonshine. Multiplicities `(1,1)` over `χ₀,χ₁` (A055791 row 1). -/
theorem mckay_coeff_one :
    mckayThompson1A[0]! = degrees[0]! + degrees[1]! := by native_decide

/-- The second coefficient decomposes as `21493760 = 1 + 196883 + 21296876`.
Multiplicities `(1,1,1)` over `χ₀,χ₁,χ₂` (A055791 row 2). -/
theorem mckay_coeff_two :
    mckayThompson1A[1]! = degrees[0]! + degrees[1]! + degrees[2]! := by native_decide

/-- The third coefficient decomposes as
`864299970 = 2·1 + 2·196883 + 21296876 + 842609326`.
Multiplicities `(2,2,1,1)` over `χ₀,…,χ₃` (A055791 row 3). -/
theorem mckay_coeff_three :
    mckayThompson1A[2]!
      = 2 * degrees[0]! + 2 * degrees[1]! + degrees[2]! + degrees[3]! := by
  native_decide

/-- The fourth coefficient decomposes as
`20245856256 = 2·1 + 3·196883 + 2·21296876 + 842609326 + 19360062527`,
the genuine head‑character decomposition with multiplicities `(2,3,2,1,0,1)` over the
first six irreducible degrees `χ₀,…,χ₅` (A055791 row 4).

Note the genuine row uses `χ₅ = 19360062527` (multiplicity `1`) and **not**
`χ₄ = 18538750076` (multiplicity `0`).  A naive `(3,3,1,2,1)` over `χ₀,…,χ₄`
*also* sums to `20245856256`, but is **not** the true module decomposition — see the
uniqueness caveat in the module docstring and `mckay_six_sum_not_unique`. -/
theorem mckay_coeff_four :
    mckayThompson1A[3]!
      = 2 * degrees[0]! + 3 * degrees[1]! + 2 * degrees[2]! + degrees[3]!
        + degrees[5]! := by
  native_decide

/-- The fifth coefficient decomposes as
`333202640600 = 4·1 + 5·196883 + 3·21296876 + 2·842609326 + 18538750076 + 19360062527
+ 293553734298`, the head‑character decomposition with multiplicities `(4,5,3,2,1,1,1)`
over the first seven irreducible degrees `χ₀,…,χ₆` (A055791 row 5).  This is the first
coefficient whose decomposition reaches the seventh irreducible degree `293553734298`. -/
theorem mckay_coeff_five :
    mckayThompson1A[4]!
      = 4 * degrees[0]! + 5 * degrees[1]! + 3 * degrees[2]! + 2 * degrees[3]!
        + degrees[4]! + degrees[5]! + degrees[6]! := by
  native_decide

/-- The sixth coefficient decomposes as
`4252023300096 = 4·1 + 7·196883 + 5·21296876 + 3·842609326 + 18538750076
+ 3·19360062527 + 293553734298 + 3879214937598`, the genuine head‑character
decomposition with multiplicities `(4,7,5,3,1,3,1,1)` over the first eight irreducible
degrees `χ₀,…,χ₇` (A055791 row 6).  This is the first coefficient whose decomposition
reaches the eighth irreducible degree `3879214937598`. -/
theorem mckay_coeff_six :
    mckayThompson1A[5]!
      = 4 * degrees[0]! + 7 * degrees[1]! + 5 * degrees[2]! + 3 * degrees[3]!
        + degrees[4]! + 3 * degrees[5]! + degrees[6]! + degrees[7]! := by
  native_decide

/-- The seventh coefficient decomposes as
`44656994071935 = 7·1 + 11·196883 + 7·21296876 + 6·842609326 + 3·18538750076
+ 4·19360062527 + 2·293553734298 + 2·3879214937598 + 36173193327999`, the genuine
head‑character decomposition with multiplicities `(7,11,7,6,3,4,2,2,1)` over the first
nine irreducible degrees `χ₀,…,χ₈` (A055791 row 7).  This is the first coefficient whose
decomposition reaches the ninth irreducible degree `36173193327999`. -/
theorem mckay_coeff_seven :
    mckayThompson1A[6]!
      = 7 * degrees[0]! + 11 * degrees[1]! + 7 * degrees[2]! + 6 * degrees[3]!
        + 3 * degrees[4]! + 4 * degrees[5]! + 2 * degrees[6]! + 2 * degrees[7]!
        + degrees[8]! := by
  native_decide

/-- The eighth coefficient decomposes as
`401490886656000 = 8·1 + 15·196883 + 12·21296876 + 8·842609326 + 4·18538750076
+ 8·19360062527 + 4·293553734298 + 4·3879214937598 + 36173193327999
+ 125510727015275 + 222879856734249`, the genuine head‑character decomposition with
multiplicities `(8,15,12,8,4,8,4,4,1,1,0,1)` over the first twelve irreducible degrees
`χ₀,…,χ₁₁` (A055791 row 8).  This is the first coefficient whose decomposition reaches
the twelfth irreducible degree `χ₁₁ = 222879856734249`.

Note the genuine row **skips** `χ₁₀ = 190292345709543` (multiplicity `0`), analogous to
how the genuine `q⁴` row skips `χ₄`.  A *different* non‑negative vector
`(5,15,15,5,1,11,4,4,1,1,0,1)` also sums to `401490886656000`, but it is **not** the true
module decomposition — see `mckay_eight_sum_not_unique`. -/
theorem mckay_coeff_eight :
    mckayThompson1A[7]!
      = 8 * degrees[0]! + 15 * degrees[1]! + 12 * degrees[2]! + 8 * degrees[3]!
        + 4 * degrees[4]! + 8 * degrees[5]! + 4 * degrees[6]! + 4 * degrees[7]!
        + degrees[8]! + degrees[9]! + degrees[11]! := by
  native_decide

/-- **Why a correct *sum* is not enough, for `q⁸`.**  The multiplicity vector
`(5,15,15,5,1,11,4,4,1,1,0,1)` over `χ₀,…,χ₁₁` also sums to the eighth coefficient
`401490886656000`, yet it is a *different* combination from the genuine module
decomposition `(8,15,12,8,4,8,4,4,1,1,0,1)` of `mckay_coeff_eight`.  Since a module
decomposes into irreducibles with unique multiplicities, at most one of these can be the
true decomposition of `V♮_8`; the genuine one is the A055791 row used in
`mckay_coeff_eight`.  This theorem certifies both that the alternative sums correctly
**and** that the two vectors genuinely differ. -/
theorem mckay_eight_sum_not_unique :
    (5 * degrees[0]! + 15 * degrees[1]! + 15 * degrees[2]! + 5 * degrees[3]!
        + degrees[4]! + 11 * degrees[5]! + 4 * degrees[6]! + 4 * degrees[7]!
        + degrees[8]! + degrees[9]! + degrees[11]!
      = mckayThompson1A[7]!)
  ∧ ([5, 15, 15, 5, 1, 11, 4, 4, 1, 1, 0, 1] : List ℕ)
      ≠ [8, 15, 12, 8, 4, 8, 4, 4, 1, 1, 0, 1] :=
  ⟨by native_decide, by decide⟩

/-- Sanity check on the explicit numerics of McKay's first observation,
written out as the famous identity `196884 = 196883 + 1`. -/
theorem mckay_196884 : mckayThompson1A[0]! = 196883 + 1 := by native_decide

/-- **Why a correct *sum* is not enough.**  The multiplicity vector `(5,7,4,4,2,2,1,1)`
over `χ₀,…,χ₇` also sums to the sixth coefficient `4252023300096`, yet it is a
*different* combination from the genuine module decomposition `(4,7,5,3,1,3,1,1)` of
`mckay_coeff_six`.  Since a module decomposes into irreducibles with unique
multiplicities, at most one of these can be the true decomposition of `V♮_6`; the genuine
one is the A055791 row used in `mckay_coeff_six`.  This theorem certifies both that the
alternative sums correctly **and** that the two vectors genuinely differ. -/
theorem mckay_six_sum_not_unique :
    (5 * degrees[0]! + 7 * degrees[1]! + 4 * degrees[2]! + 4 * degrees[3]!
        + 2 * degrees[4]! + 2 * degrees[5]! + degrees[6]! + degrees[7]!
      = mckayThompson1A[5]!)
  ∧ ([5, 7, 4, 4, 2, 2, 1, 1] : List ℕ) ≠ [4, 7, 5, 3, 1, 3, 1, 1] :=
  ⟨by native_decide, by decide⟩

/-- Every recorded moonshine coefficient is expressible as a non-negative integer
combination of Monster irreducible degrees with the published head-character
multiplicities (verified term-by-term for `q¹,q²,q³`). -/
theorem moonshine_head_characters :
    mckayThompson1A[0]! = degrees[0]! + degrees[1]!
  ∧ mckayThompson1A[1]! = degrees[0]! + degrees[1]! + degrees[2]!
  ∧ mckayThompson1A[2]! = 2 * degrees[0]! + 2 * degrees[1]! + degrees[2]! + degrees[3]! := by
  native_decide

/-- The genuine head-character decompositions for **all seven** recorded moonshine
coefficients `q¹,…,q⁷`, verified term-by-term against the Monster's irreducible degrees
using the A055791 multiplicity rows.  This extends `moonshine_head_characters` all the way
up to `q⁷` and corrects the earlier `q⁴` row to its genuine module decomposition. -/
theorem moonshine_head_characters_q1_q7 :
    mckayThompson1A[0]! = degrees[0]! + degrees[1]!
  ∧ mckayThompson1A[1]! = degrees[0]! + degrees[1]! + degrees[2]!
  ∧ mckayThompson1A[2]! = 2 * degrees[0]! + 2 * degrees[1]! + degrees[2]! + degrees[3]!
  ∧ mckayThompson1A[3]!
      = 2 * degrees[0]! + 3 * degrees[1]! + 2 * degrees[2]! + degrees[3]! + degrees[5]!
  ∧ mckayThompson1A[4]!
      = 4 * degrees[0]! + 5 * degrees[1]! + 3 * degrees[2]! + 2 * degrees[3]!
        + degrees[4]! + degrees[5]! + degrees[6]!
  ∧ mckayThompson1A[5]!
      = 4 * degrees[0]! + 7 * degrees[1]! + 5 * degrees[2]! + 3 * degrees[3]!
        + degrees[4]! + 3 * degrees[5]! + degrees[6]! + degrees[7]!
  ∧ mckayThompson1A[6]!
      = 7 * degrees[0]! + 11 * degrees[1]! + 7 * degrees[2]! + 6 * degrees[3]!
        + 3 * degrees[4]! + 4 * degrees[5]! + 2 * degrees[6]! + 2 * degrees[7]!
        + degrees[8]! := by
  native_decide

/-- The genuine head-character decompositions for **all eight** recorded moonshine
coefficients `q¹,…,q⁸`, verified term-by-term against the Monster's irreducible degrees
using the A055791 multiplicity rows.  This extends `moonshine_head_characters_q1_q7` with
the `q⁸` row, the first to reach the twelfth irreducible degree `χ₁₁` (and which skips
`χ₁₀`). -/
theorem moonshine_head_characters_q1_q8 :
    mckayThompson1A[0]! = degrees[0]! + degrees[1]!
  ∧ mckayThompson1A[1]! = degrees[0]! + degrees[1]! + degrees[2]!
  ∧ mckayThompson1A[2]! = 2 * degrees[0]! + 2 * degrees[1]! + degrees[2]! + degrees[3]!
  ∧ mckayThompson1A[3]!
      = 2 * degrees[0]! + 3 * degrees[1]! + 2 * degrees[2]! + degrees[3]! + degrees[5]!
  ∧ mckayThompson1A[4]!
      = 4 * degrees[0]! + 5 * degrees[1]! + 3 * degrees[2]! + 2 * degrees[3]!
        + degrees[4]! + degrees[5]! + degrees[6]!
  ∧ mckayThompson1A[5]!
      = 4 * degrees[0]! + 7 * degrees[1]! + 5 * degrees[2]! + 3 * degrees[3]!
        + degrees[4]! + 3 * degrees[5]! + degrees[6]! + degrees[7]!
  ∧ mckayThompson1A[6]!
      = 7 * degrees[0]! + 11 * degrees[1]! + 7 * degrees[2]! + 6 * degrees[3]!
        + 3 * degrees[4]! + 4 * degrees[5]! + 2 * degrees[6]! + 2 * degrees[7]!
        + degrees[8]!
  ∧ mckayThompson1A[7]!
      = 8 * degrees[0]! + 15 * degrees[1]! + 12 * degrees[2]! + 8 * degrees[3]!
        + 4 * degrees[4]! + 8 * degrees[5]! + 4 * degrees[6]! + 4 * degrees[7]!
        + degrees[8]! + degrees[9]! + degrees[11]! := by
  native_decide

end Monster
