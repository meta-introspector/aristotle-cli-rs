/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

**Structure of the semi-local densities `κ_Λ`.**

`RequestProject/RenormalizedTraceDensity.lean` writes the trace at a finite cut-off scale as
an integral against the density `κ_Λ(λ) = Tr(ϑ(λ) S^{(Λ)})`.  Here the elementary structure
of these densities is established, exactly as `RequestProject/TraceDensitySymmetry.lean`
does at the scale `Λ = 1`:

* `traceDensityCut_eq_hsInner`: the Hilbert–Schmidt formula
  `κ_Λ(λ) = ⟪B_Λ^*, ϑ(λ) B_Λ^*⟫_HS`, exhibiting `κ_Λ` as a matrix coefficient of the
  scaling representation on Hilbert–Schmidt operators — in particular a positive-definite
  function of `λ`;
* `conj_traceDensityCut`: the symmetry `κ_Λ(λ⁻¹) = conj κ_Λ(λ)`, the operator-side
  counterpart of `δ(ρ) = δ(ρ⁻¹)`;
* `continuous_traceDensityCut`: continuity of `κ_Λ` on `ℝ⋆₊`;
* `traceDensityCut_one_eq_hsNormSq`: `κ_Λ(1) = ‖B_Λ‖²_{HS} = Tr(S^{(Λ)})`, the quantity
  shown to diverge in `RequestProject/TraceDivergence.lean`.  The divergence of the
  renormalized trace therefore sits entirely in the behaviour of `κ_Λ` near `λ = 1`.
-/
import RequestProject.Imported.OutputFinal.RequestProject.RenormalizedTraceDensity
import RequestProject.Imported.OutputFinal.RequestProject.TraceDensitySymmetry

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory ContinuousLinearMap

open scoped CompactlySupported ENNReal

namespace ConnesConsani.WeilPositivity

variable {ι : Type*}

/-- The "half" of the cut-off sandwich, `B_Λ^* = P^{(Λ)} P̂^{(Λ)}`. -/
def soninHalfCut (cut : ℝ) : L2R →L[ℂ] L2R :=
  ContinuousLinearMap.adjoint (PcutHat cut ∘L Pcut cut)

theorem isHilbertSchmidt_soninHalfCut (b : HilbertBasis ι ℂ L2R) (cut : ℝ) :
    IsHilbertSchmidt b (soninHalfCut cut) :=
  (isHilbertSchmidt_PcutHat_comp_Pcut cut b).adjoint

variable (U : L2Rplus ≃ₗᵢ[ℂ] L2R)

theorem isHilbertSchmidt_thetaUnitOf_comp_soninHalfCut (b : HilbertBasis ι ℂ L2R) (cut : ℝ)
    (lam : Rplus) : IsHilbertSchmidt b (thetaUnitOf U lam ∘L soninHalfCut cut) := by
  rw [IsHilbertSchmidt,
    hsNormSq_comp_left_isometry b (soninHalfCut cut) (norm_thetaUnitOf_apply U lam)]
  exact isHilbertSchmidt_soninHalfCut b cut

/-- **The Hilbert–Schmidt formula for the semi-local density**:
`κ_Λ(λ) = ⟪B_Λ^*, ϑ(λ) B_Λ^*⟫_HS`. -/
theorem traceDensityCut_eq_hsInner (b : HilbertBasis ι ℂ L2R) (cut : ℝ) (lam : Rplus) :
    traceDensityCut U b cut lam
      = hsInner b (soninHalfCut cut) (thetaUnitOf U lam ∘L soninHalfCut cut) := by
  have hA : IsHilbertSchmidt b (PcutHat cut ∘L Pcut cut) :=
    isHilbertSchmidt_PcutHat_comp_Pcut cut b
  have hVA : IsHilbertSchmidt b (thetaUnitOf U lam ∘L soninHalfCut cut) :=
    isHilbertSchmidt_thetaUnitOf_comp_soninHalfCut U b cut lam
  rw [traceDensityCut, soninSandwichCut_eq_adjoint_comp]
  rw [show thetaUnitOf U lam ∘L
        (ContinuousLinearMap.adjoint (PcutHat cut ∘L Pcut cut) ∘L (PcutHat cut ∘L Pcut cut))
      = (thetaUnitOf U lam ∘L soninHalfCut cut) ∘L (PcutHat cut ∘L Pcut cut) from rfl]
  rw [traceAlong_comm hVA hA, traceAlong_comp_eq_hsInner]
  rfl

/-- **The symmetry of the semi-local density**: `κ_Λ(λ⁻¹) = conj κ_Λ(λ)`. -/
theorem conj_traceDensityCut (b : HilbertBasis ι ℂ L2R) (cut : ℝ) (lam : Rplus) :
    (starRingEnd ℂ) (traceDensityCut U b cut lam) = traceDensityCut U b cut lam⁻¹ := by
  rw [traceDensityCut_eq_hsInner, traceDensityCut_eq_hsInner, hsInner, hsInner,
    starRingEnd_apply, tsum_star]
  refine tsum_congr fun i => ?_
  rw [← starRingEnd_apply, inner_conj_symm]
  exact inner_thetaUnitOf_left U lam (soninHalfCut cut (b i)) (soninHalfCut cut (b i))

/-- **The semi-local density is continuous** on `ℝ⋆₊`, at every cut-off scale. -/
theorem continuous_traceDensityCut (b : HilbertBasis ι ℂ L2R) (cut : ℝ) :
    Continuous fun lam : Rplus => traceDensityCut U b cut lam := by
  have hsum : Summable fun i => ‖soninHalfCut cut (b i)‖ ^ 2 :=
    (isHilbertSchmidt_soninHalfCut b cut).summable_norm_sq
  have hcont : ∀ i : ι,
      Continuous fun lam : Rplus =>
        (inner ℂ (soninHalfCut cut (b i))
          (thetaUnitOf U lam (soninHalfCut cut (b i))) : ℂ) :=
    fun i => continuous_const.inner (continuous_thetaUnitOf_apply U (soninHalfCut cut (b i)))
  have hbound : ∀ (i : ι) (lam : Rplus),
      ‖(inner ℂ (soninHalfCut cut (b i))
          (thetaUnitOf U lam (soninHalfCut cut (b i))) : ℂ)‖
        ≤ ‖soninHalfCut cut (b i)‖ ^ 2 := by
    intro i lam
    calc ‖(inner ℂ (soninHalfCut cut (b i))
            (thetaUnitOf U lam (soninHalfCut cut (b i))) : ℂ)‖
        ≤ ‖soninHalfCut cut (b i)‖ * ‖thetaUnitOf U lam (soninHalfCut cut (b i))‖ :=
          norm_inner_le_norm _ _
      _ = ‖soninHalfCut cut (b i)‖ ^ 2 := by
          rw [norm_thetaUnitOf_apply]; ring
  have hkey : Continuous fun lam : Rplus =>
      ∑' i, (inner ℂ (soninHalfCut cut (b i))
        (thetaUnitOf U lam (soninHalfCut cut (b i))) : ℂ) :=
    continuous_tsum hcont hsum hbound
  refine hkey.congr fun lam => ?_
  rw [traceDensityCut_eq_hsInner, hsInner]
  rfl

/-- `κ_Λ(1) = ‖B_Λ‖²_{HS} = Tr(S^{(Λ)})`: the value of the density at the unit is the trace
of the cut-off sandwich, the quantity that diverges as `Λ → ∞`. -/
theorem traceDensityCut_one_eq_hsNormSq (b : HilbertBasis ι ℂ L2R) (cut : ℝ) :
    traceDensityCut U b cut 1 = ∑' i, ((‖soninHalfCut cut (b i)‖ : ℂ)) ^ 2 := by
  rw [traceDensityCut_eq_hsInner, hsInner]
  refine tsum_congr fun i => ?_
  have h : (thetaUnitOf U 1 ∘L soninHalfCut cut) (b i) = soninHalfCut cut (b i) :=
    thetaUnitOf_one U (soninHalfCut cut (b i))
  rw [h, inner_self_eq_norm_sq_to_K]
  simp

end ConnesConsani.WeilPositivity
