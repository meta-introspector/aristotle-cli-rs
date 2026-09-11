/-
# Cl(0,6) ≅ M₈(ℝ): finite dimensionality and the explicit isomorphism

This file establishes the core facts about the Clifford algebra `Cl(0,6)` of the
negative-definite form on `ℝ⁶`:

* `cl06_finrank_eq_64` — `finrank ℝ (Cl0 6) = 64`,
* `cl06_forward_injective` / `cl06_forward_surjective` — the faithful matrix
  representation is bijective, and
* `cl0_six_equiv` — the resulting `ℝ`-algebra isomorphism `Cl(0,6) ≃ₐ[ℝ] M₈(ℝ)`.

## Build-fix note

The original version of this file combined two heavy hand-rolled developments
(a 64-monomial span argument and an explicit `Cl(0,6) ≃ M₈(ℝ)` construction with
64 trace-formula coefficients). After the dedup merge the span lemmas
`e2/e3/e4_mul_mem_span6` no longer fit within their 51.2M-heartbeat budget and the
file failed to compile (a multi-hour timeout — one of the causes of the build
appearing to hang). It is preserved verbatim in `CliffordCl06.original.txt`.

We now obtain the same results cheaply from the generic signed-permutation Gram
engine (`CliffordCl06SPerm`), which proves `finrank ℝ (Cl0 6) = 2^6` and
faithfulness by `native_decide` in seconds, and we rebuild the algebra
isomorphism from the engine's injective forward map together with the dimension
count (an injective linear map between equidimensional finite-dimensional spaces
is bijective).
-/

import Mathlib
import RequestProject.Math.Clifford.CliffordBase
import RequestProject.Math.Clifford.CliffordCl06SPerm

open CliffordAlgebra Matrix

noncomputable section

/-- The real `8×8` matrix algebra, the representation target for `Cl(0,6)`. -/
abbrev M8R := Matrix (Fin 8) (Fin 8) ℝ

/-- `finrank ℝ (Cl0 6) = 64` (from the generic Gram engine). -/
theorem cl06_finrank_eq_64 : Module.finrank ℝ (Cl0 6) = 64 := cl06_finrank_64

/-- Upper bound on the dimension of `Cl(0,6)`. -/
theorem finrank_Cl06_le_64 : Module.finrank ℝ (Cl0 6) ≤ 64 :=
  le_of_eq cl06_finrank_64

/-- `Cl(0,6)` is finite-dimensional (from the engine's `Module.Finite` instance). -/
instance cl06_finiteDimensional : FiniteDimensional ℝ (Cl0 6) := inferInstance

private theorem finrank_M8R : Module.finrank ℝ M8R = 64 := by
  simp [Module.finrank_matrix]

/-- The faithful representation `Cl(0,6) →ₐ[ℝ] M₈(ℝ)` is injective. -/
theorem cl06_forward_injective : Function.Injective cl06Forward :=
  cl06Forward_injective

/-- The representation is surjective: an injective linear map between
finite-dimensional spaces of equal dimension is surjective. -/
theorem cl06_forward_surjective : Function.Surjective cl06Forward := by
  have hdim : Module.finrank ℝ (Cl0 6) = Module.finrank ℝ M8R := by
    rw [cl06_finrank_64, finrank_M8R]
  have hinj : Function.Injective cl06Forward.toLinearMap := cl06Forward_injective
  exact (LinearMap.injective_iff_surjective_of_finrank_eq_finrank hdim).mp hinj

/-- **Main result**: the explicit `ℝ`-algebra isomorphism `Cl(0,6) ≃ₐ[ℝ] M₈(ℝ)`. -/
noncomputable def cl0_six_equiv : Cl0 6 ≃ₐ[ℝ] M8R :=
  AlgEquiv.ofBijective cl06Forward ⟨cl06_forward_injective, cl06_forward_surjective⟩

end
