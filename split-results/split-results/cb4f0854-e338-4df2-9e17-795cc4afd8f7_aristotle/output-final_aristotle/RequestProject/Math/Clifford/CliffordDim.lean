/-
# CliffordDim — General Dimension Theorem for Clifford Algebras

Proves finrank ℝ (Cl0 n) = 2^n for all n, using:
1. CliffordAlgebra.equivExterior : Cl Q ≃ₗ[ℝ] ExteriorAlgebra ℝ M (when 2 is invertible)
2. ExteriorAlgebra has a graded decomposition with known piece dimensions
3. Binomial theorem: ∑ C(n,k) = 2^n
-/

import Mathlib
import RequestProject.Math.Clifford.CliffordBase

set_option maxHeartbeats 1600000

open CliffordAlgebra Module

noncomputable section

/-! ## §1. Exterior Algebra Dimension -/

/-
The exterior algebra on Fin n → ℝ has finrank 2^n.
-/
theorem finrank_exteriorAlgebra_eq (n : ℕ) :
    Module.finrank ℝ (ExteriorAlgebra ℝ (Fin n → ℝ)) = 2 ^ n := by
  -- We apply the graded decomposition theorem to reduce the problem to calculating the dimensions of each graded component.
  have h_decomp : DirectSum.IsInternal (fun k => ⋀[ℝ]^k (Fin n → ℝ)) := by
    -- Apply the definition of `DirectSum.IsInternal` to the exterior algebra.
    apply DirectSum.Decomposition.isInternal;
  have := h_decomp.collectedBasis ( fun k => ( Pi.basisFun ℝ ( Fin n ) ).exteriorPower k );
  rw [ @finrank_eq_of_rank_eq ];
  convert this.mk_eq_rank.symm;
  · norm_num;
  · rw [ Cardinal.mk_congr ];
    rotate_right;
    exact Finset ( Fin n );
    · simp +decide [ Cardinal.mk_fintype ];
    · refine' Equiv.ofBijective ( fun x => x.2.val ) ⟨ _, _ ⟩;
      · intro x y hxy;
        have := x.2.2; have := y.2.2; aesop;
      · intro x;
        exact ⟨ ⟨ x.card, ⟨ x, by simp +decide ⟩ ⟩, rfl ⟩

/-! ## §2. Clifford Algebra Dimension -/

/-
The Clifford algebra Cl(0,n) has finrank 2^n.
-/
theorem finrank_Cl0_eq (n : ℕ) :
    Module.finrank ℝ (Cl0 n) = 2 ^ n := by
  have h_iso : Nonempty (Cl0 n ≃ₗ[ℝ] ExteriorAlgebra ℝ (Fin n → ℝ)) := by
    refine' ⟨ _ ⟩;
    convert CliffordAlgebra.equivExterior _;
    exact invertibleOfNonzero ( by norm_num );
  exact h_iso.some.finrank_eq.trans ( finrank_exteriorAlgebra_eq n )

/-! ## §3. Periodicity Dimension Statement -/

/-- The periodicity statement follows from the dimension formula. -/
theorem cl0_dim_periodicity (n : ℕ) :
    Module.finrank ℝ (Cl0 (n + 8)) = Module.finrank ℝ (Cl0 n) * 256 := by
  rw [finrank_Cl0_eq, finrank_Cl0_eq]
  ring

end