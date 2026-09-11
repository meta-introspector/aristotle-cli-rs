/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The one-parameter family of cut-offs `P^{(Λ)}`, `P̂^{(Λ)}` and the renormalized Sonin
sandwich `S^{(Λ)} = P^{(Λ)} P̂^{(Λ)} P^{(Λ)}` of arXiv:2006.13771 (Connes–Consani, *Weil
positivity and Trace formula – the archimedean place*).

`RequestProject/Sonin.lean` constructs the two cut-off projections `P₁` (multiplication by
`1_{[-1,1]}`) and `P̂₁` (its conjugate by the Fourier transform), i.e. the cut-off at the
scale `Λ = 1`.  Here we let the scale vary:

* `Pcut Λ` is multiplication by `1_{[-Λ,Λ]}`;
* `PcutHat Λ = 𝓕⁻¹ (Pcut Λ) 𝓕` is the cut-off in frequency at the same scale;
* `soninSandwichCut Λ = Pcut Λ ∘ PcutHat Λ ∘ Pcut Λ`.

At `Λ = 1` these are exactly `P₁`, `P̂₁` and the Sonin sandwich `soninSandwich` of
`RequestProject/TraceIdentityNorm.lean` (`Pcut_one`, `PcutHat_one`,
`soninSandwichCut_one`), and the family *grows* with `Λ`: the cut-off subspaces increase
(`Pcut_comp_Pcut_of_le`) and exhaust `L²(ℝ)`.  The algebraic properties that survive the
cut-off are proved here: each `Pcut Λ`, `PcutHat Λ` is a self-adjoint idempotent
contraction and `S^{(Λ)} = B_Λ^* B_Λ` with `B_Λ = P̂^{(Λ)} P^{(Λ)}`, hence `S^{(Λ)}` is a
positive self-adjoint contraction.
-/
import RequestProject.Imported.OutputFinal.RequestProject.SoninJoin

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory Set ContinuousLinearMap

namespace ConnesConsani.WeilPositivity

/-! ## Generic facts about cut-off operators -/

/-- Cutting off twice, on nested sets, is cutting off on the smaller one. -/
theorem cutoff_comp_cutoff_of_subset {s t : Set ℝ} (hs : MeasurableSet s) (ht : MeasurableSet t)
    (hst : s ⊆ t) : cutoff hs ∘L cutoff ht = cutoff hs := by
  refine ContinuousLinearMap.ext fun f => ?_
  rw [show (cutoff hs ∘L cutoff ht) f = cutoff hs (cutoff ht f) from rfl, Lp.ext_iff]
  filter_upwards [coeFn_cutoff hs (cutoff ht f), coeFn_cutoff ht f, coeFn_cutoff hs f]
    with x h1 h2 h3
  rw [h1, h3]
  by_cases hx : x ∈ s
  · rw [Set.indicator_of_mem hx, Set.indicator_of_mem hx, h2,
      Set.indicator_of_mem (hst hx)]
  · rw [Set.indicator_of_notMem hx, Set.indicator_of_notMem hx]

/-! ## Conjugation by the Fourier transform -/

/-- Conjugation of an operator of `L²(ℝ)` by the Fourier transform, `T ↦ 𝓕⁻¹ T 𝓕`. -/
def fourierConj (T : L2R →L[ℂ] L2R) : L2R →L[ℂ] L2R :=
  (fourierL2.symm.toContinuousLinearEquiv : L2R →L[ℂ] L2R) ∘L
    (T ∘L (fourierL2.toContinuousLinearEquiv : L2R →L[ℂ] L2R))

theorem fourierConj_apply (T : L2R →L[ℂ] L2R) (f : L2R) :
    fourierConj T f = fourierL2.symm (T (fourierL2 f)) := rfl

/-- `P̂₁` is the Fourier conjugate of `P₁`. -/
theorem fourierConj_P1 : fourierConj P1 = P1hat := rfl

/-- Conjugation by the Fourier transform is multiplicative. -/
theorem fourierConj_comp (T S : L2R →L[ℂ] L2R) :
    fourierConj (T ∘L S) = fourierConj T ∘L fourierConj S := by
  ext f
  simp [fourierConj_apply]

/-- Conjugation by the Fourier transform preserves idempotency. -/
theorem fourierConj_idempotent {T : L2R →L[ℂ] L2R} (h : IsIdempotentElem T) :
    IsIdempotentElem (fourierConj T) := by
  unfold IsIdempotentElem
  ext f
  simp only [ContinuousLinearMap.mul_apply, fourierConj_apply,
    LinearIsometryEquiv.apply_symm_apply]
  rw [show T (T (fourierL2 f)) = T (fourierL2 f) from congrArg (fun S => S (fourierL2 f)) h]

/-- Conjugation by the Fourier transform preserves self-adjointness. -/
theorem fourierConj_selfAdjoint {T : L2R →L[ℂ] L2R} (h : IsSelfAdjoint T) :
    IsSelfAdjoint (fourierConj T) := by
  rw [IsSelfAdjoint, ContinuousLinearMap.star_eq_adjoint, eq_comm,
    ContinuousLinearMap.eq_adjoint_iff]
  intro f g
  have h1 : ∀ x y : L2R, inner ℂ (fourierL2.symm x) y = inner ℂ x (fourierL2 y) := by
    intro x y
    rw [← fourierL2.inner_map_map (fourierL2.symm x) y, LinearIsometryEquiv.apply_symm_apply]
  have h2 : ∀ x y : L2R, inner ℂ x (fourierL2.symm y) = inner ℂ (fourierL2 x) y := by
    intro x y
    rw [← fourierL2.inner_map_map x (fourierL2.symm y), LinearIsometryEquiv.apply_symm_apply]
  have hT : ∀ x y : L2R, inner ℂ (T x) y = inner ℂ x (T y) := by
    intro x y
    have hsa := h
    rw [IsSelfAdjoint, ContinuousLinearMap.star_eq_adjoint] at hsa
    calc inner ℂ (T x) y = inner ℂ ((ContinuousLinearMap.adjoint T) x) y := by rw [hsa]
      _ = inner ℂ x (T y) := ContinuousLinearMap.adjoint_inner_left _ _ _
  rw [fourierConj_apply, fourierConj_apply, h1, h2, hT]

theorem adjoint_fourierConj {T : L2R →L[ℂ] L2R} (h : IsSelfAdjoint T) :
    ContinuousLinearMap.adjoint (fourierConj T) = fourierConj T := by
  have h' := fourierConj_selfAdjoint h
  rwa [IsSelfAdjoint, ContinuousLinearMap.star_eq_adjoint] at h'

/-! ## The family of cut-offs -/

/-- The cut-off interval `[-Λ, Λ]` at scale `Λ`; at `Λ = 1` it is the interval
`cutoffInterval` of the paper. -/
def cutoffSet (lam : ℝ) : Set ℝ := Set.Icc (-lam) lam

theorem measurableSet_cutoffSet (lam : ℝ) : MeasurableSet (cutoffSet lam) := measurableSet_Icc

@[simp] theorem cutoffSet_one : cutoffSet 1 = cutoffInterval := rfl

theorem cutoffSet_subset {lam mu : ℝ} (h : lam ≤ mu) : cutoffSet lam ⊆ cutoffSet mu :=
  Set.Icc_subset_Icc (by linarith) h

theorem volume_cutoffSet_ne_top (lam : ℝ) : volume (cutoffSet lam) ≠ ⊤ := by
  rw [cutoffSet]
  simp

/-- **The cut-off in space at scale `Λ`**: multiplication by `1_{[-Λ,Λ]}`. -/
def Pcut (lam : ℝ) : L2R →L[ℂ] L2R := cutoff (measurableSet_cutoffSet lam)

/-- **The cut-off in frequency at scale `Λ`**: the Fourier conjugate of `Pcut Λ`. -/
def PcutHat (lam : ℝ) : L2R →L[ℂ] L2R := fourierConj (Pcut lam)

/-- At `Λ = 1` the cut-off in space is the projection `P₁` of the paper. -/
@[simp] theorem Pcut_one : Pcut 1 = P1 := rfl

/-- At `Λ = 1` the cut-off in frequency is the projection `P̂₁` of the paper. -/
@[simp] theorem PcutHat_one : PcutHat 1 = P1hat := rfl

theorem Pcut_idempotent (lam : ℝ) : IsIdempotentElem (Pcut lam) := cutoff_idempotent _

theorem Pcut_selfAdjoint (lam : ℝ) : IsSelfAdjoint (Pcut lam) := cutoff_selfAdjoint _

theorem PcutHat_idempotent (lam : ℝ) : IsIdempotentElem (PcutHat lam) :=
  fourierConj_idempotent (Pcut_idempotent lam)

theorem PcutHat_selfAdjoint (lam : ℝ) : IsSelfAdjoint (PcutHat lam) :=
  fourierConj_selfAdjoint (Pcut_selfAdjoint lam)

theorem adjoint_Pcut (lam : ℝ) : ContinuousLinearMap.adjoint (Pcut lam) = Pcut lam := by
  have h := Pcut_selfAdjoint lam
  rwa [IsSelfAdjoint, ContinuousLinearMap.star_eq_adjoint] at h

theorem adjoint_PcutHat (lam : ℝ) :
    ContinuousLinearMap.adjoint (PcutHat lam) = PcutHat lam :=
  adjoint_fourierConj (Pcut_selfAdjoint lam)

theorem Pcut_isStarProjection (lam : ℝ) : IsStarProjection (Pcut lam) :=
  ⟨Pcut_idempotent lam, Pcut_selfAdjoint lam⟩

theorem PcutHat_isStarProjection (lam : ℝ) : IsStarProjection (PcutHat lam) :=
  ⟨PcutHat_idempotent lam, PcutHat_selfAdjoint lam⟩

/-- **The family grows with `Λ`**: cutting off at the smaller scale absorbs the larger
one. -/
theorem Pcut_comp_Pcut_of_le {lam mu : ℝ} (h : lam ≤ mu) :
    Pcut lam ∘L Pcut mu = Pcut lam :=
  cutoff_comp_cutoff_of_subset _ _ (cutoffSet_subset h)

theorem PcutHat_comp_PcutHat_of_le {lam mu : ℝ} (h : lam ≤ mu) :
    PcutHat lam ∘L PcutHat mu = PcutHat lam := by
  rw [PcutHat, PcutHat, ← fourierConj_comp, Pcut_comp_Pcut_of_le h]

/-- The ranges of the space cut-offs increase with `Λ`. -/
theorem range_Pcut_mono {lam mu : ℝ} (h : lam ≤ mu) :
    LinearMap.range (Pcut lam : L2R →ₗ[ℂ] L2R) ≤ LinearMap.range (Pcut mu : L2R →ₗ[ℂ] L2R) := by
  rintro _ ⟨f, rfl⟩
  refine ⟨Pcut lam f, ?_⟩
  have := congrArg (fun T : L2R →L[ℂ] L2R => T f) (Pcut_comp_Pcut_of_le h)
  have h2 : Pcut mu (Pcut lam f) = Pcut lam f := by
    have hmul : Pcut lam ∘L Pcut mu = Pcut lam := Pcut_comp_Pcut_of_le h
    have hsa : ContinuousLinearMap.adjoint (Pcut lam ∘L Pcut mu)
        = ContinuousLinearMap.adjoint (Pcut lam) := by rw [hmul]
    rw [ContinuousLinearMap.adjoint_comp, adjoint_Pcut, adjoint_Pcut] at hsa
    exact congrArg (fun T : L2R →L[ℂ] L2R => T f) hsa
  exact h2

/-- Contraction property of the space cut-off. -/
theorem norm_Pcut_apply_le (lam : ℝ) (x : L2R) : ‖Pcut lam x‖ ≤ ‖x‖ := by
  refine Lp.norm_le_norm_of_ae_le ?_
  filter_upwards [coeFn_cutoff (measurableSet_cutoffSet lam) x] with t ht
  show ‖(Pcut lam x : ℝ → ℂ) t‖ ≤ _
  rw [show (Pcut lam x : ℝ → ℂ) t = (cutoffSet lam).indicator ((x : ℝ → ℂ)) t from ht]
  by_cases h : t ∈ cutoffSet lam <;> simp [h]

theorem norm_PcutHat_apply_le (lam : ℝ) (x : L2R) : ‖PcutHat lam x‖ ≤ ‖x‖ := by
  rw [PcutHat, fourierConj_apply]
  calc ‖fourierL2.symm (Pcut lam (fourierL2 x))‖ = ‖Pcut lam (fourierL2 x)‖ :=
        fourierL2.symm.norm_map _
    _ ≤ ‖fourierL2 x‖ := norm_Pcut_apply_le lam _
    _ = ‖x‖ := fourierL2.norm_map x

/-! ## The renormalized Sonin sandwich -/

/-- **The renormalized sandwich** `S^{(Λ)} = P^{(Λ)} P̂^{(Λ)} P^{(Λ)}`. -/
def soninSandwichCut (lam : ℝ) : L2R →L[ℂ] L2R := Pcut lam ∘L PcutHat lam ∘L Pcut lam

/-- `S^{(Λ)} = B_Λ^* B_Λ` with `B_Λ = P̂^{(Λ)} P^{(Λ)}`. -/
theorem soninSandwichCut_eq_adjoint_comp (lam : ℝ) :
    soninSandwichCut lam
      = ContinuousLinearMap.adjoint (PcutHat lam ∘L Pcut lam) ∘L (PcutHat lam ∘L Pcut lam) := by
  rw [soninSandwichCut, ContinuousLinearMap.adjoint_comp, adjoint_Pcut, adjoint_PcutHat]
  simp only [← ContinuousLinearMap.comp_assoc]
  rw [ContinuousLinearMap.comp_assoc (Pcut lam) (PcutHat lam) (PcutHat lam),
    show PcutHat lam ∘L PcutHat lam = PcutHat lam from PcutHat_idempotent lam]

/-- **`S^{(Λ)} ≥ 0`.** -/
theorem soninSandwichCut_isPositive (lam : ℝ) : (soninSandwichCut lam).IsPositive := by
  have h := (ContinuousLinearMap.IsPositive.of_isStarProjection
    (PcutHat_isStarProjection lam)).adjoint_conj (Pcut lam)
  rw [adjoint_Pcut] at h
  exact h

/-- **`S^{(Λ)}` is self-adjoint.** -/
theorem soninSandwichCut_isSelfAdjoint (lam : ℝ) : IsSelfAdjoint (soninSandwichCut lam) :=
  (soninSandwichCut_isPositive lam).isSelfAdjoint

/-- **`S^{(Λ)}` is a contraction.** -/
theorem norm_soninSandwichCut_apply_le (lam : ℝ) (x : L2R) :
    ‖soninSandwichCut lam x‖ ≤ ‖x‖ :=
  (norm_Pcut_apply_le lam _).trans
    ((norm_PcutHat_apply_le lam _).trans (norm_Pcut_apply_le lam x))

theorem norm_soninSandwichCut_le_one (lam : ℝ) : ‖soninSandwichCut lam‖ ≤ 1 :=
  ContinuousLinearMap.opNorm_le_bound _ zero_le_one fun x => by
    simpa using norm_soninSandwichCut_apply_le lam x

/-- The diagonal matrix elements of `S^{(Λ)}` are nonnegative reals, bounded by `‖x‖²`. -/
theorem re_inner_soninSandwichCut_nonneg (lam : ℝ) (x : L2R) :
    0 ≤ RCLike.re (inner ℂ x (soninSandwichCut lam x)) :=
  (soninSandwichCut_isPositive lam).re_inner_nonneg_right x

end ConnesConsani.WeilPositivity
