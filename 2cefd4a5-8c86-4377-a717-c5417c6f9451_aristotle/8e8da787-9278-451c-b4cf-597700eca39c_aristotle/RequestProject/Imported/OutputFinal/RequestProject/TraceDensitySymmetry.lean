/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

**Structure of the trace density**, for arXiv:2006.13771 (Connes–Consani, *Weil positivity
and Trace formula – the archimedean place*).

`RequestProject/TraceDensity.lean` shows that the trace functional of the Sonin sandwich is
integration against a bounded function on `ℝ⋆₊`,

  `Tr(ϑ(f) P₁P̂₁P₁) = ∫ f(λ) κ(λ) d*λ`,     `κ(λ) = Tr(ϑ(λ) P₁P̂₁P₁)`,

and that the normalized trace identity `L_Norm(f) = Tr(ϑ(f) P P̂ P)` is *equivalent* to the
identification of `κ` with the density of the analytic functional `L_Norm`.

This file establishes the structural properties of `κ` that the analytic density of the
paper must share, and which pin `κ` down as a classical *positive-definite function* on the
group `ℝ⋆₊`:

* `traceDensity_eq_hsInner` — the Hilbert–Schmidt formula `κ(λ) = ⟪B, ϑ(λ) B⟫_HS`, with
  `B = P₁P̂₁ = (P̂₁P₁)*`.  This is the key structural identity: it removes the trace and
  exhibits `κ` as a matrix coefficient of the scaling representation in the
  Hilbert–Schmidt space.
* `conj_traceDensity` — `κ(λ⁻¹) = conj κ(λ)`, the symmetry of the paper's `δ`.
* `continuous_traceDensity` — `κ` is continuous on `ℝ⋆₊` (the HS series converges
  uniformly), so the identity of functions to which the trace identity has been reduced is
  an identity of *continuous* functions and may be checked pointwise.
* `traceDensity_one_eq_hsNormSq` — `κ(1) = ‖B‖²_HS ≥ 0`.
-/
import RequestProject.Imported.OutputFinal.RequestProject.TraceDensity

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory ContinuousLinearMap

open scoped CompactlySupported ENNReal

namespace ConnesConsani.WeilPositivity

variable {ι : Type*}

/-! ## Hilbert–Schmidt norms are unchanged by an isometry on the left -/

section HS

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℂ E] [CompleteSpace E]

omit [CompleteSpace E] in
/-- Composing on the left with a norm-preserving operator does not change the
Hilbert–Schmidt norm. -/
theorem hsNormSq_comp_left_isometry (b : HilbertBasis ι ℂ E) (A : E →L[ℂ] E)
    {V : E →L[ℂ] E} (hV : ∀ x, ‖V x‖ = ‖x‖) : hsNormSq b (V ∘L A) = hsNormSq b A := by
  refine tsum_congr fun i => ?_
  have : ‖(V ∘L A) (b i)‖₊ = ‖A (b i)‖₊ := NNReal.coe_injective (hV _)
  rw [this]

end HS

/-! ## The Hilbert–Schmidt formula for the trace density -/

/-- The "half" of the Sonin sandwich, `B = P₁P̂₁ = (P̂₁P₁)*`; it is a Hilbert–Schmidt
operator and `P₁P̂₁P₁ = B* B`. -/
def soninHalf : L2R →L[ℂ] L2R := ContinuousLinearMap.adjoint (P1hat ∘L P1)

theorem isHilbertSchmidt_soninHalf (b : HilbertBasis ι ℂ L2R) :
    IsHilbertSchmidt b soninHalf :=
  (isHilbertSchmidt_P1hat_comp_P1 b).adjoint

variable (U : L2Rplus ≃ₗᵢ[ℂ] L2R)

theorem isHilbertSchmidt_thetaUnitOf_comp_soninHalf (b : HilbertBasis ι ℂ L2R) (lam : Rplus) :
    IsHilbertSchmidt b (thetaUnitOf U lam ∘L soninHalf) := by
  rw [IsHilbertSchmidt,
    hsNormSq_comp_left_isometry b soninHalf (norm_thetaUnitOf_apply U lam)]
  exact isHilbertSchmidt_soninHalf b

/-- **The Hilbert–Schmidt formula for the trace density**:

  `κ(λ) = Tr(ϑ(λ) P₁P̂₁P₁) = ⟪B, ϑ(λ) B⟫_HS`,   `B = P₁P̂₁`.

The trace is removed in favour of a Hilbert–Schmidt pairing; in particular `κ` is a matrix
coefficient of the scaling representation acting on the Hilbert–Schmidt operators, hence a
positive-definite function on `ℝ⋆₊`. -/
theorem traceDensity_eq_hsInner (b : HilbertBasis ι ℂ L2R) (lam : Rplus) :
    traceDensity U b lam = hsInner b soninHalf (thetaUnitOf U lam ∘L soninHalf) := by
  have hA : IsHilbertSchmidt b (P1hat ∘L P1) := isHilbertSchmidt_P1hat_comp_P1 b
  have hVA : IsHilbertSchmidt b (thetaUnitOf U lam ∘L soninHalf) :=
    isHilbertSchmidt_thetaUnitOf_comp_soninHalf U b lam
  rw [traceDensity, soninSandwich_eq_adjoint_comp]
  rw [show thetaUnitOf U lam ∘L
        (ContinuousLinearMap.adjoint (P1hat ∘L P1) ∘L (P1hat ∘L P1))
      = (thetaUnitOf U lam ∘L soninHalf) ∘L (P1hat ∘L P1) from rfl]
  rw [traceAlong_comm hVA hA, traceAlong_comp_eq_hsInner]
  rfl

/-! ## Symmetry of the trace density -/

/-- `ϑ(λ)` and `ϑ(λ⁻¹)` are mutually adjoint. -/
theorem inner_thetaUnitOf_left (lam : Rplus) (x y : L2R) :
    (inner ℂ (thetaUnitOf U lam x) y : ℂ) = inner ℂ x (thetaUnitOf U lam⁻¹ y) := by
  have hs : ∀ z : L2Rplus, scaling lam (scaling lam⁻¹ z) = z := by
    intro z
    rw [← scaling_mul, mul_inv_cancel, scaling_apply, scalingₗᵢ_one]
    rfl
  have h : thetaUnitOf U lam (thetaUnitOf U lam⁻¹ y) = y := by
    simp only [thetaUnitOf_apply, LinearIsometryEquiv.symm_apply_apply, hs,
      LinearIsometryEquiv.apply_symm_apply]
  calc (inner ℂ (thetaUnitOf U lam x) y : ℂ)
      = inner ℂ (thetaUnitOf U lam x) (thetaUnitOf U lam (thetaUnitOf U lam⁻¹ y)) := by rw [h]
    _ = inner ℂ x (thetaUnitOf U lam⁻¹ y) := by
        simp only [thetaUnitOf_apply, LinearIsometryEquiv.inner_map_map,
          LinearIsometryEquiv.symm_apply_apply]
        rw [← U.inner_map_map (U.symm x) (scaling lam⁻¹ (U.symm y)),
          LinearIsometryEquiv.apply_symm_apply]

/-- **The symmetry of the trace density**: `κ(λ⁻¹) = conj κ(λ)`.  This is the operator-side
counterpart of the symmetry `δ(ρ) = δ(ρ⁻¹)` of the archimedean density. -/
theorem conj_traceDensity (b : HilbertBasis ι ℂ L2R) (lam : Rplus) :
    (starRingEnd ℂ) (traceDensity U b lam) = traceDensity U b lam⁻¹ := by
  rw [traceDensity_eq_hsInner, traceDensity_eq_hsInner, hsInner, hsInner]
  rw [starRingEnd_apply, tsum_star]
  refine tsum_congr fun i => ?_
  rw [← starRingEnd_apply, inner_conj_symm]
  exact inner_thetaUnitOf_left U lam (soninHalf (b i)) (soninHalf (b i))

/-- The same symmetry for the trace density computed in the standard basis. -/
theorem conj_traceDensityStd (lam : Rplus) :
    (starRingEnd ℂ) (traceDensityStd U lam) = traceDensityStd U lam⁻¹ :=
  conj_traceDensity U stdBasis lam

/-! ## Continuity of the trace density -/

/-- **The trace density is continuous.**  The Hilbert–Schmidt series representing `κ`
converges uniformly on `ℝ⋆₊`, being dominated by the summable family `‖B bᵢ‖²`. -/
theorem continuous_traceDensity (b : HilbertBasis ι ℂ L2R) :
    Continuous fun lam : Rplus => traceDensity U b lam := by
  have hsum : Summable fun i => ‖soninHalf (b i)‖ ^ 2 :=
    (isHilbertSchmidt_soninHalf b).summable_norm_sq
  have hcont : ∀ i : ι,
      Continuous fun lam : Rplus =>
        (inner ℂ (soninHalf (b i)) (thetaUnitOf U lam (soninHalf (b i))) : ℂ) :=
    fun i => continuous_const.inner (continuous_thetaUnitOf_apply U (soninHalf (b i)))
  have hbound : ∀ (i : ι) (lam : Rplus),
      ‖(inner ℂ (soninHalf (b i)) (thetaUnitOf U lam (soninHalf (b i))) : ℂ)‖
        ≤ ‖soninHalf (b i)‖ ^ 2 := by
    intro i lam
    calc ‖(inner ℂ (soninHalf (b i)) (thetaUnitOf U lam (soninHalf (b i))) : ℂ)‖
        ≤ ‖soninHalf (b i)‖ * ‖thetaUnitOf U lam (soninHalf (b i))‖ :=
          norm_inner_le_norm _ _
      _ = ‖soninHalf (b i)‖ ^ 2 := by
          rw [norm_thetaUnitOf_apply]; ring
  have hkey : Continuous fun lam : Rplus =>
      ∑' i, (inner ℂ (soninHalf (b i)) (thetaUnitOf U lam (soninHalf (b i))) : ℂ) :=
    continuous_tsum hcont hsum hbound
  refine hkey.congr fun lam => ?_
  rw [traceDensity_eq_hsInner, hsInner]
  rfl

theorem continuous_traceDensityStd :
    Continuous fun lam : Rplus => traceDensityStd U lam :=
  continuous_traceDensity U stdBasis

/-! ## The value at the identity -/

theorem thetaUnitOf_one (x : L2R) : thetaUnitOf U 1 x = x := by
  simp only [thetaUnitOf_apply, scaling_apply, scalingₗᵢ_one]
  simp

/-- `κ(1) = ‖B‖²_HS`, in particular `κ(1)` is a nonnegative real number. -/
theorem traceDensity_one_eq_hsNormSq (b : HilbertBasis ι ℂ L2R) :
    traceDensity U b 1 = ∑' i, ((‖soninHalf (b i)‖ : ℂ)) ^ 2 := by
  rw [traceDensity_eq_hsInner, hsInner]
  refine tsum_congr fun i => ?_
  have h : (thetaUnitOf U 1 ∘L soninHalf) (b i) = soninHalf (b i) :=
    thetaUnitOf_one U (soninHalf (b i))
  rw [h, inner_self_eq_norm_sq_to_K]
  simp

end ConnesConsani.WeilPositivity
