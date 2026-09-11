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

/-
The cardinal sum `∑ i, C(n,i)` (as cardinals, over all of `ℕ`) equals `2 ^ n`.
-/
theorem cardinal_sum_choose (n : ℕ) :
    Cardinal.sum (fun i : ℕ => ((n.choose i : ℕ) : Cardinal)) = ((2 ^ n : ℕ) : Cardinal) := by
  by_contra h_contra';
  -- We'll use that the set of all subsets of a finite set is equivalent to `Finset (Fin n)`.
  have h_equiv : Nonempty ((Σ (i : ℕ), {x : Finset (Fin n) // Finset.card x = i}) ≃ Finset (Fin n)) := by
    refine' ⟨ _ ⟩;
    refine' Equiv.ofBijective ( fun x => x.2.val ) ⟨ fun x y hxy => _, fun x => _ ⟩ <;> aesop;
  have := Cardinal.mk_congr h_equiv.some; simp_all +decide ;
  convert this using 1;
  rw [ ← Cardinal.lift_inj ] ; simp +decide;
  convert h_contra' using 1;
  norm_cast;
  rw [ Cardinal.lift_natCast ]

/-
The exterior algebra of an `n`-dimensional real vector space has dimension `2 ^ n`.
-/
theorem exteriorAlgebra_finrank (n : ℕ) :
    Module.finrank ℝ (ExteriorAlgebra ℝ (Fin n → ℝ)) = 2 ^ n := by
  -- The exterior algebra of an n-dimensional real vector space is graded as a direct sum of its exterior powers ⋀[ℝ]^i.
  have h_grad : ExteriorAlgebra ℝ (Fin n → ℝ) ≃ₗ[ℝ] (DirectSum ℕ fun i => ⋀[ℝ]^i (Fin n → ℝ)) :=
    DirectSum.decomposeLinearEquiv fun i => ⋀[ℝ]^i (Fin n → ℝ)
  have h_finrank : ∀ i, Module.finrank ℝ (⋀[ℝ]^i (Fin n → ℝ)) = (n.choose i : ℕ) := by
    intro i;
    convert exteriorPower.finrank_eq ?_ ?_;
    · norm_num;
    · infer_instance;
    · infer_instance;
    · infer_instance;
  have := h_grad.finrank_eq;
  rw [ this, Module.finrank_eq_of_rank_eq ];
  rw [ rank_directSum ];
  convert cardinal_sum_choose n using 1;
  exact congr_arg _ ( funext fun i => by rw [ ← h_finrank i, ← Module.finrank_eq_rank ] )

end ExteriorFinrank