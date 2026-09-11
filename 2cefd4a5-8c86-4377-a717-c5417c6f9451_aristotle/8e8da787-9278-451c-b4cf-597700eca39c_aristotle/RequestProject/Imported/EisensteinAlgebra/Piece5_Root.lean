import Mathlib
import RequestProject.Imported.EisensteinAlgebra.EisensteinIntegers_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinTheta_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinThetaBridge_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinUnits_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinOrbit_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinPrimeSplit_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinPrimeSplitHard_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinEuclidean_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinAlgebra_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinIdealCount_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinDivSum_Root

/-!
# Piece 5: The DULA Eisenstein Theta Formula

This file states and assembles the final theorem of the Eisenstein theta
program:

  **For every positive integer `n`,**
  $$r(n) = 6 \sum_{d \mid n} \chi_{-3}(d)$$

  **where `r(n) = #{(a,b) ∈ ℤ² : a² + ab + b² = n}` and `χ_{-3}` is the
  non-trivial Dirichlet character mod 3.**

## Status

**All lemmas are fully proved.** The theorem `dula_theta_formula` is
unconditional — no sorry statements remain anywhere in the proof chain.

Key results proved in `EisensteinDivSum.lean`:
- `iCount_multiplicative` — coprime product property for ideal counting
- `iCount_prime_pow_split` — ideal count for split primes (k+1)
- `iCount_prime_pow_inert` — ideal count for inert primes
- `iCount_prime_pow_ramified` — ideal count for the ramified prime 3
- `iCount_eq_divSum` — ideal count equals divisor sum of χ₋₃
- `divSum_multiplicative` and `divSum_prime_pow`

## What this file captures

The **architectural completion** of the program: the final equality
$r(n) = 6 \sum_{d \mid n} \chi_{-3}(d)$ is shown to follow by a clean
three-step rewrite from the existing `repCount = eisNormCount` bridge
(`EisensteinThetaBridge`) and the two named lemmas above. No mathematical
content is hidden — every step is explicitly visible and fully proved.
-/

noncomputable section

open scoped Classical

namespace Eisenstein

/-! ## The ideal count -/

/-- The number of ideals of `Eisenstein` with `Ideal.absNorm = n`. -/
def idealCount (n : ℕ) : ℕ :=
  (Ideal.finite_setOf_absNorm_eq (S := Eisenstein) n).toFinset.card

/-! ## The two sub-lemmas -/

/-- **Sub-lemma 1 (orbit-to-ideal bijection).**

For `n ≥ 1`, the count of Eisenstein integers of norm `n` equals
`6 · idealCount n`. -/
theorem eisNormCount_eq_six_mul_idealCount (n : ℕ) (hn : 0 < n) :
    EisensteinThetaBridge.eisNormCount n = 6 * idealCount n := by
  exact eisNormCount_eq_six_mul_idealCount' n hn

/-- **Sub-lemma 2 (ideal count = divisor sum of χ₋₃).** -/
theorem idealCount_eq_divSum (n : ℕ) (hn : 0 < n) :
    (idealCount n : ℤ) = EisensteinTheta.divSum n := by
  exact iCount_eq_divSum n hn

/-! ## The final theorem -/

/-- **The DULA Eisenstein Theta Formula (Piece 5).**

For every positive integer `n`,
$$r(n) = 6 \sum_{d \mid n} \chi_{-3}(d)$$
where `r(n)` counts pairs `(a, b) ∈ ℤ²` with `a² + a·b + b² = n`.

This is the master identity for the Eisenstein theta program:

1. `repCount n = eisNormCount n`  (the (a,b) ↔ ⟨a,-b⟩ bijection).
2. `eisNormCount n = 6 · idealCount n`  (orbit-to-ideal bijection).
3. `idealCount n = Σ_{d|n} χ_{-3}(d)`  (multiplicativity + prime powers). -/
theorem dula_theta_formula (n : ℕ) (hn : 0 < n) :
    (EisensteinTheta.repCount n : ℤ) = 6 * EisensteinTheta.divSum n := by
  -- Step 1: repCount = eisNormCount (existing bridge)
  rw [EisensteinThetaBridge.repCount_eq_eisNormCount]
  -- Step 2: eisNormCount = 6 · idealCount
  rw [eisNormCount_eq_six_mul_idealCount n hn]
  -- Step 3: cast and apply the multiplicative identification
  push_cast
  rw [idealCount_eq_divSum n hn]

end Eisenstein
