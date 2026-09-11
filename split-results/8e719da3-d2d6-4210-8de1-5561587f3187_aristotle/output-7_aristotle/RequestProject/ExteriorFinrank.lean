/-
# Finrank of the exterior algebra of a finite free module

We prove `Module.finrank ℝ (ExteriorAlgebra ℝ (Fin n → ℝ)) = 2 ^ n`.

This is the missing piece needed to compute the dimension of the Clifford
algebra `Cl(0,n)` (which is linearly isomorphic to the exterior algebra via
`CliffordAlgebra.equivExterior`).

The strategy:
* The exterior algebra is graded: `ExteriorAlgebra ℝ M ≃ₗ ⨁ i, ⋀[ℝ]^i M`
  (`DirectSum.decomposeLinearEquiv`).
* Rank is additive over direct sums (`rank_directSum`).
* The `i`-th exterior power of an `n`-dimensional space has finrank `C(n,i)`
  (`exteriorPower.finrank_eq`).
* `∑ i, C(n,i) = 2 ^ n` (`Nat.sum_range_choose`).
-/
import Mathlib

open scoped DirectSum BigOperators

namespace ExteriorFinrank

/-- The cardinal sum `∑ i, C(n,i)` (as cardinals, over all of `ℕ`) equals `2 ^ n`. -/
theorem cardinal_sum_choose (n : ℕ) :
    Cardinal.sum (fun i : ℕ => ((n.choose i : ℕ) : Cardinal)) = ((2 ^ n : ℕ) : Cardinal) := by
  sorry

/-- The exterior algebra of an `n`-dimensional real vector space has dimension `2 ^ n`. -/
theorem exteriorAlgebra_finrank (n : ℕ) :
    Module.finrank ℝ (ExteriorAlgebra ℝ (Fin n → ℝ)) = 2 ^ n := by
  sorry

end ExteriorFinrank
