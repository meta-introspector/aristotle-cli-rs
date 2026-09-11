/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Sonin's space and the associated orthogonal projection `S`, following §1–§2 of
arXiv:2006.13771 (Connes–Consani, *Weil positivity and Trace formula – the
archimedean place*).

Sonin's space is the subspace of `L²(ℝ)` consisting of the functions which vanish
(almost everywhere) on `[-1,1]` **and** whose Fourier transform vanishes on `[-1,1]`.
It is the orthogonal complement of the sum of the ranges of the two cutoff
projections `P₁` (cutoff in space) and `P̂₁` (cutoff in frequency), which is the
content of the "pair of projections" description used in the paper.
-/
import RequestProject.Imported.OutputFinal.RequestProject.TraceRemainder

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory Set Filter

namespace ConnesConsani.WeilPositivity

/-- The Hilbert space `L²(ℝ)` of complex valued square integrable functions. -/
abbrev L2R := Lp ℂ 2 (volume : Measure ℝ)

/-! ## Multiplication by the indicator function of a measurable set -/

section Cutoff

variable {s : Set ℝ}

/-- Multiplication of an `L²` function by the indicator function of `s`. -/
def cutoffFun (hs : MeasurableSet s) (f : L2R) : L2R :=
  (MemLp.indicator hs (Lp.memLp f)).toLp _

lemma coeFn_cutoffFun (hs : MeasurableSet s) (f : L2R) :
    (cutoffFun hs f : ℝ → ℂ) =ᵐ[volume] s.indicator (f : ℝ → ℂ) :=
  MemLp.coeFn_toLp _

/-- Multiplication by `1_s`, as a linear map of `L²(ℝ)`. -/
def cutoffₗ (hs : MeasurableSet s) : L2R →ₗ[ℂ] L2R where
  toFun f := cutoffFun hs f
  map_add' f g := by
    rw [Lp.ext_iff]
    filter_upwards [coeFn_cutoffFun hs (f + g), coeFn_cutoffFun hs f, coeFn_cutoffFun hs g,
      Lp.coeFn_add f g, Lp.coeFn_add (cutoffFun hs f) (cutoffFun hs g)] with x h1 h2 h3 h4 h5
    rw [h1, h5]
    simp only [Pi.add_apply]
    rw [h2, h3]
    by_cases hx : x ∈ s
    · simp only [Set.indicator_of_mem hx]
      exact h4
    · simp [hx]
  map_smul' c f := by
    rw [Lp.ext_iff]
    filter_upwards [coeFn_cutoffFun hs (c • f), coeFn_cutoffFun hs f,
      Lp.coeFn_smul c f, Lp.coeFn_smul c (cutoffFun hs f)] with x h1 h2 h3 h4
    rw [RingHom.id_apply, h1, h4]
    simp only [Pi.smul_apply]
    rw [h2]
    by_cases hx : x ∈ s
    · simp only [Set.indicator_of_mem hx]
      exact h3
    · simp [hx]

/-- The **cutoff projection**: multiplication by the indicator function of a measurable
set `s`, as a bounded operator on `L²(ℝ)`. -/
def cutoff (hs : MeasurableSet s) : L2R →L[ℂ] L2R :=
  LinearMap.mkContinuous (cutoffₗ hs) 1 (by
    intro f
    rw [one_mul]
    refine Lp.norm_le_norm_of_ae_le ?_
    filter_upwards [coeFn_cutoffFun hs f] with x hx
    show ‖(cutoffFun hs f : ℝ → ℂ) x‖ ≤ _
    rw [hx]
    by_cases h : x ∈ s <;> simp [h])

lemma coeFn_cutoff (hs : MeasurableSet s) (f : L2R) :
    (cutoff hs f : ℝ → ℂ) =ᵐ[volume] s.indicator (f : ℝ → ℂ) :=
  coeFn_cutoffFun hs f

/-- The cutoff operator is idempotent. -/
theorem cutoff_idempotent (hs : MeasurableSet s) :
    IsIdempotentElem (cutoff hs) := by
  unfold IsIdempotentElem
  ext f
  simp only [ContinuousLinearMap.mul_apply]
  filter_upwards [coeFn_cutoff hs (cutoff hs f), coeFn_cutoff hs f] with x h1 h2
  rw [h1]
  by_cases hx : x ∈ s <;> simp [hx, h2]

/-- The cutoff operator is self-adjoint. -/
theorem cutoff_selfAdjoint (hs : MeasurableSet s) : IsSelfAdjoint (cutoff hs) := by
  rw [IsSelfAdjoint, ContinuousLinearMap.star_eq_adjoint, eq_comm,
    ContinuousLinearMap.eq_adjoint_iff]
  intro f g
  rw [L2.inner_def, L2.inner_def]
  refine integral_congr_ae ?_
  filter_upwards [coeFn_cutoff hs f, coeFn_cutoff hs g] with x h1 h2
  rw [h1, h2]
  by_cases hx : x ∈ s <;> simp [hx]

/-- `1_s ξ = 0` in `L²` exactly when `ξ` vanishes almost everywhere on `s`. -/
theorem cutoff_eq_zero_iff (hs : MeasurableSet s) (g : L2R) :
    cutoff hs g = 0 ↔ ∀ᵐ x ∂(volume.restrict s), (g : ℝ → ℂ) x = 0 := by
  rw [Lp.ext_iff, ae_restrict_iff' hs]
  constructor
  · intro h
    filter_upwards [h, coeFn_cutoff hs g, Lp.coeFn_zero ℂ 2 (volume : Measure ℝ)]
      with x hx h1 h2 hmem
    rw [h1, h2] at hx
    rwa [Set.indicator_of_mem hmem] at hx
  · intro h
    filter_upwards [h, coeFn_cutoff hs g, Lp.coeFn_zero ℂ 2 (volume : Measure ℝ)] with x hx h1 h2
    rw [h1, h2]
    by_cases hmem : x ∈ s
    · rw [Set.indicator_of_mem hmem]
      exact hx hmem
    · simp [hmem]

end Cutoff

/-! ## The two cutoff projections `P₁` and `P̂₁`, and Sonin's space -/

/-- For a self-adjoint operator, the kernel is the orthogonal complement of the range. -/
theorem ker_eq_orthogonal_range {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℂ E]
    [CompleteSpace E] {P : E →L[ℂ] E} (hsa : IsSelfAdjoint P) :
    LinearMap.ker (P : E →ₗ[ℂ] E) = (LinearMap.range (P : E →ₗ[ℂ] E))ᗮ := by
  rw [ContinuousLinearMap.orthogonal_range, ← ContinuousLinearMap.star_eq_adjoint, hsa]

/-- The interval `[-1,1]` in which the cutoffs take place (`Λ = 1` in the paper). -/
def cutoffInterval : Set ℝ := Set.Icc (-1) 1

lemma measurableSet_cutoffInterval : MeasurableSet cutoffInterval := measurableSet_Icc

/-- The cutoff projection in "space": multiplication by `1_{[-1,1]}`. -/
def P1 : L2R →L[ℂ] L2R := cutoff measurableSet_cutoffInterval

/-- The Fourier transform (Plancherel) as a unitary of `L²(ℝ)`. -/
def fourierL2 : L2R ≃ₗᵢ[ℂ] L2R := MeasureTheory.Lp.fourierTransformₗᵢ ℝ ℂ

/-- The cutoff projection in "frequency": the conjugate of `P₁` by the Fourier transform. -/
def P1hat : L2R →L[ℂ] L2R :=
  (fourierL2.symm.toContinuousLinearEquiv : L2R →L[ℂ] L2R).comp
    (P1.comp (fourierL2.toContinuousLinearEquiv : L2R →L[ℂ] L2R))

lemma P1hat_apply (f : L2R) : P1hat f = fourierL2.symm (P1 (fourierL2 f)) := rfl

theorem P1_idempotent : IsIdempotentElem P1 := cutoff_idempotent _

theorem P1_selfAdjoint : IsSelfAdjoint P1 := cutoff_selfAdjoint _

theorem P1hat_idempotent : IsIdempotentElem P1hat := by
  unfold IsIdempotentElem
  ext f
  simp only [ContinuousLinearMap.mul_apply, P1hat_apply, LinearIsometryEquiv.apply_symm_apply]
  rw [show P1 (P1 (fourierL2 f)) = P1 (fourierL2 f) from
    congrArg (fun T => T (fourierL2 f)) P1_idempotent]

theorem P1hat_selfAdjoint : IsSelfAdjoint P1hat := by
  rw [IsSelfAdjoint, ContinuousLinearMap.star_eq_adjoint, eq_comm,
    ContinuousLinearMap.eq_adjoint_iff]
  intro f g
  have h1 : ∀ x y : L2R, inner ℂ (fourierL2.symm x) y = inner ℂ x (fourierL2 y) := by
    intro x y
    rw [← fourierL2.inner_map_map (fourierL2.symm x) y, LinearIsometryEquiv.apply_symm_apply]
  have h2 : ∀ x y : L2R, inner ℂ x (fourierL2.symm y) = inner ℂ (fourierL2 x) y := by
    intro x y
    rw [← fourierL2.inner_map_map x (fourierL2.symm y), LinearIsometryEquiv.apply_symm_apply]
  have hP1 : ∀ x y : L2R, inner ℂ (P1 x) y = inner ℂ x (P1 y) := by
    intro x y
    have hsa := P1_selfAdjoint
    rw [IsSelfAdjoint, ContinuousLinearMap.star_eq_adjoint] at hsa
    calc inner ℂ (P1 x) y = inner ℂ ((ContinuousLinearMap.adjoint P1) x) y := by rw [hsa]
    _ = inner ℂ x (P1 y) := ContinuousLinearMap.adjoint_inner_left _ _ _
  rw [P1hat_apply, P1hat_apply, h1, h2, hP1]

/-- **Sonin's space**: the `L²` functions which vanish on `[-1,1]` and whose Fourier
transform vanishes on `[-1,1]`. -/
def SoninSpace : Submodule ℂ L2R :=
  LinearMap.ker (P1 : L2R →ₗ[ℂ] L2R) ⊓ LinearMap.ker (P1hat : L2R →ₗ[ℂ] L2R)

/-- Sonin's space is the orthogonal complement of the sum of the ranges of the two cutoff
projections; this is the description `S = 1 - (P₁ ∨ P̂₁)` used in the paper. -/
theorem SoninSpace_eq_orthogonal :
    SoninSpace = (LinearMap.range (P1 : L2R →ₗ[ℂ] L2R)
      ⊔ LinearMap.range (P1hat : L2R →ₗ[ℂ] L2R))ᗮ := by
  rw [SoninSpace, ← Submodule.inf_orthogonal,
    ker_eq_orthogonal_range (P := P1) P1_selfAdjoint,
    ker_eq_orthogonal_range P1hat_selfAdjoint]

instance : SoninSpace.HasOrthogonalProjection := by
  rw [SoninSpace_eq_orthogonal]
  infer_instance

/-- The orthogonal projection `S` onto Sonin's space. -/
def SoninProjection : L2R →L[ℂ] L2R := SoninSpace.starProjection

theorem SoninProjection_isSelfAdjoint : IsSelfAdjoint SoninProjection :=
  isSelfAdjoint_starProjection SoninSpace

theorem SoninProjection_isIdempotent : IsIdempotentElem SoninProjection :=
  (isStarProjection_starProjection (U := SoninSpace)).isIdempotentElem

/-- The Sonin projection is a positive operator; this is the elementary reason why the
Sonin trace functional `f ↦ Tr(ϑ(f) S)` of the paper is positive definite. -/
theorem SoninProjection_isPositive : (SoninProjection : L2R →L[ℂ] L2R).IsPositive :=
  ContinuousLinearMap.IsPositive.of_isStarProjection (isStarProjection_starProjection)

/-- Membership in Sonin's space, spelled out: `ξ` and its Fourier transform vanish almost
everywhere on `[-1,1]`. -/
theorem mem_SoninSpace_iff (f : L2R) :
    f ∈ SoninSpace ↔
      ((∀ᵐ x ∂(volume.restrict cutoffInterval), (f : ℝ → ℂ) x = 0) ∧
        (∀ᵐ x ∂(volume.restrict cutoffInterval), (fourierL2 f : ℝ → ℂ) x = 0)) := by
  rw [SoninSpace, Submodule.mem_inf, LinearMap.mem_ker, LinearMap.mem_ker]
  constructor
  · rintro ⟨h1, h2⟩
    refine ⟨(cutoff_eq_zero_iff measurableSet_cutoffInterval f).1 h1,
      (cutoff_eq_zero_iff measurableSet_cutoffInterval (fourierL2 f)).1 ?_⟩
    have h3 : fourierL2.symm (P1 (fourierL2 f)) = 0 := h2
    have h4 := congrArg fourierL2 h3
    rwa [LinearIsometryEquiv.apply_symm_apply, map_zero] at h4
  · rintro ⟨h1, h2⟩
    refine ⟨(cutoff_eq_zero_iff measurableSet_cutoffInterval f).2 h1, ?_⟩
    show fourierL2.symm (P1 (fourierL2 f)) = 0
    rw [show P1 (fourierL2 f) = 0 from
      (cutoff_eq_zero_iff measurableSet_cutoffInterval (fourierL2 f)).2 h2, map_zero]

end ConnesConsani.WeilPositivity
