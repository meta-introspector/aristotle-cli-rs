/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The two cutoff projections of arXiv:2006.13771 (Connes–Consani, *Weil positivity and Trace
formula – the archimedean place*) have a **Hilbert–Schmidt** product: the operator
`P̂₁ P₁` on `L²(ℝ)` is Hilbert–Schmidt, hence the Sonin sandwich `P₁ P̂₁ P₁ = (P̂₁P₁)* (P̂₁P₁)`
is trace class.

The reason is classical: modulo the (unitary) Fourier transform the operator is

  `ξ ↦ 1_{[-1,1]}(x) ∫_{-1}^{1} e^{-2πi x v} ξ(v) dv`,

an integral operator whose kernel `1_{[-1,1]}(x) e^{-2πi xv} 1_{[-1,1]}(v)` is square
integrable on `ℝ × ℝ` (its `L²` norm squared is `4`).  We use the criterion
`hsNormSq_le_of_kernel` of `RequestProject/HilbertSchmidtKernel.lean` together with the
identification of the `L²` Fourier transform with the Fourier integral proved in
`RequestProject/FourierL2Integral.lean`.
-/
import RequestProject.Imported.OutputFinal.RequestProject.FourierL2Integral
import RequestProject.Imported.OutputFinal.RequestProject.HilbertSchmidtKernel

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory FourierTransform Real Set

open scoped ENNReal NNReal RealInnerProductSpace

namespace ConnesConsani.WeilPositivity

/-! ## The Fourier transform as a bounded operator -/

/-- The `L²` Fourier transform as a continuous linear map. -/
def fourierCLM : L2R →L[ℂ] L2R := (fourierL2.toContinuousLinearEquiv : L2R →L[ℂ] L2R)

@[simp] theorem fourierCLM_apply (f : L2R) : fourierCLM f = fourierL2 f := rfl

/-- The Fourier integral only depends on the almost everywhere class of its argument. -/
theorem fourier_congr_ae {u w : ℝ → ℂ} (h : u =ᵐ[volume] w) : 𝓕 u = 𝓕 w := by
  funext x
  rw [Real.fourier_eq, Real.fourier_eq]
  exact integral_congr_ae (h.mono fun v hv => by dsimp only; rw [hv])

/-! ## The kernel of the doubly cut Fourier transform -/

/-- The character `v ↦ e^{2πi v x}`. -/
def unitChar (x v : ℝ) : ℂ := ((𝐞 (v * x) : Circle) : ℂ)

theorem norm_unitChar (x v : ℝ) : ‖unitChar x v‖ = 1 := by
  simp [unitChar]

theorem continuous_unitChar (x : ℝ) : Continuous (unitChar x) :=
  continuous_subtype_val.comp
    (Real.continuous_fourierChar.comp (continuous_id.mul continuous_const))

/-- The cutoff character `1_{[-1,1]}(v) e^{2πi v x}` is square integrable. -/
theorem memLp_indicator_unitChar (x : ℝ) :
    MemLp (cutoffInterval.indicator (unitChar x)) 2 volume := by
  refine MemLp.mono (g := cutoffInterval.indicator (fun _ : ℝ => (1 : ℂ)))
    (memLp_indicator_const 2 measurableSet_cutoffInterval 1 (Or.inr ?_)) ?_ ?_
  · rw [cutoffInterval]
    simp
  · exact ((continuous_unitChar x).aestronglyMeasurable).indicator measurableSet_cutoffInterval
  · filter_upwards with v
    by_cases hv : v ∈ cutoffInterval <;> simp [hv, norm_unitChar]

/-- The constant cutoff vector `1_{[-1,1]}`, used as a norm bound for the kernel. -/
def cutoffConstVec : L2R :=
  (memLp_indicator_const 2 measurableSet_cutoffInterval (1 : ℂ) (Or.inr (by
    rw [cutoffInterval]; simp))).toLp _

open Classical in
/-- The kernel vectors `k x` of the doubly cut Fourier transform: `k x` is the function
`v ↦ 1_{[-1,1]}(x) 1_{[-1,1]}(v) e^{2πi v x}`. -/
def cutoffKernelVec (x : ℝ) : L2R :=
  if x ∈ cutoffInterval then (memLp_indicator_unitChar x).toLp _ else 0

theorem norm_cutoffKernelVec_le (x : ℝ) : ‖cutoffKernelVec x‖ ≤ ‖cutoffConstVec‖ := by
  classical
  simp only [cutoffKernelVec]
  split_ifs with hx
  · refine Lp.norm_le_norm_of_ae_le ?_
    filter_upwards [MemLp.coeFn_toLp (memLp_indicator_unitChar x),
      MemLp.coeFn_toLp (f := cutoffInterval.indicator (fun _ : ℝ => (1 : ℂ)))
        (memLp_indicator_const 2 measurableSet_cutoffInterval (1 : ℂ)
          (Or.inr (by rw [cutoffInterval]; simp)))] with v h1 h2
    rw [h1, show ((cutoffConstVec : ℝ → ℂ) v) = cutoffInterval.indicator
      (fun _ : ℝ => (1 : ℂ)) v from h2]
    by_cases hv : v ∈ cutoffInterval <;> simp [hv, norm_unitChar]
  · simp

/-! ## The doubly cut Fourier transform is Hilbert–Schmidt -/

/-- `P₁ ξ` is integrable: it is square integrable and supported in a set of finite
measure. -/
theorem integrable_coeFn_P1 (xi : L2R) : Integrable ((P1 xi : L2R) : ℝ → ℂ) volume := by
  have hmem : MemLp ((P1 xi : L2R) : ℝ → ℂ) 2 volume := Lp.memLp _
  have hae : ((P1 xi : L2R) : ℝ → ℂ) =ᵐ[volume]
      cutoffInterval.indicator ((xi : L2R) : ℝ → ℂ) := coeFn_cutoff _ _
  have hfin : (volume (cutoffInterval)) ≠ ⊤ := by
    rw [cutoffInterval]; simp
  haveI : IsFiniteMeasure (volume.restrict cutoffInterval) :=
    ⟨by rwa [Measure.restrict_apply_univ, lt_top_iff_ne_top]⟩
  have hon : IntegrableOn ((xi : L2R) : ℝ → ℂ) cutoffInterval volume :=
    MemLp.integrable (by norm_num) ((Lp.memLp xi).restrict cutoffInterval)
  exact (Integrable.congr (hon.integrable_indicator measurableSet_cutoffInterval) hae.symm)

/-- **The kernel identity**: the doubly cut Fourier transform `P₁ 𝓕 P₁` is the integral
operator with kernel `1_{[-1,1]}(x) e^{-2πi xv} 1_{[-1,1]}(v)`. -/
theorem coeFn_cutFourierCut (xi : L2R) :
    ((P1 ∘L fourierCLM ∘L P1) xi : ℝ → ℂ)
      =ᵐ[volume] fun x => inner ℂ (cutoffKernelVec x) xi := by
  have h1 : ((P1 xi : L2R) : ℝ → ℂ) =ᵐ[volume]
      cutoffInterval.indicator ((xi : L2R) : ℝ → ℂ) := coeFn_cutoff _ _
  have h2 : ((fourierL2 (P1 xi) : L2R) : ℝ → ℂ) =ᵐ[volume] 𝓕 ((P1 xi : L2R) : ℝ → ℂ) :=
    coeFn_fourierL2_of_integrable _ (integrable_coeFn_P1 xi)
  have h3 : 𝓕 ((P1 xi : L2R) : ℝ → ℂ) = 𝓕 (cutoffInterval.indicator ((xi : L2R) : ℝ → ℂ)) :=
    fourier_congr_ae h1
  have h4 : ((P1 (fourierL2 (P1 xi)) : L2R) : ℝ → ℂ) =ᵐ[volume]
      cutoffInterval.indicator ((fourierL2 (P1 xi) : L2R) : ℝ → ℂ) := coeFn_cutoff _ _
  have hstep : ((P1 ∘L fourierCLM ∘L P1) xi : ℝ → ℂ) =ᵐ[volume]
      cutoffInterval.indicator (𝓕 (cutoffInterval.indicator ((xi : L2R) : ℝ → ℂ))) := by
    refine h4.trans ?_
    rw [← h3]
    exact h2.mono fun x hx => by
      by_cases hxI : x ∈ cutoffInterval <;> simp [hxI, hx]
  refine hstep.trans (.of_forall fun x => ?_)
  by_cases hxI : x ∈ cutoffInterval
  · classical
    rw [Set.indicator_of_mem hxI]
    simp only [cutoffKernelVec, if_pos hxI]
    rw [L2.inner_def, Real.fourier_eq]
    refine (integral_congr_ae ?_).symm
    filter_upwards [MemLp.coeFn_toLp (memLp_indicator_unitChar x)] with v hv
    rw [hv]
    by_cases hvI : v ∈ cutoffInterval
    · simp only [Set.indicator_of_mem hvI, RCLike.inner_apply, unitChar, Circle.smul_def,
        smul_eq_mul, starRingEnd_apply, star_trivial]
      rw [show (star ((𝐞 (v * x) : Circle) : ℂ)) = ((𝐞 (-(v * x)) : Circle) : ℂ) from
        conj_fourierChar (v * x), mul_comm x v]
      exact mul_comm _ _
    · simp [hvI]
  · rw [Set.indicator_of_notMem hxI]
    simp only [cutoffKernelVec, if_neg hxI]
    simp

/-- **`P₁ 𝓕 P₁` is Hilbert–Schmidt.** -/
theorem isHilbertSchmidt_cutFourierCut {ι : Type*} (b : HilbertBasis ι ℂ L2R) :
    IsHilbertSchmidt b (P1 ∘L fourierCLM ∘L P1) := by
  classical
  have hle := hsNormSq_le_of_kernel b (P1 ∘L fourierCLM ∘L P1) cutoffKernelVec
    coeFn_cutFourierCut
  have hfin : ‖cutoffConstVec‖ₑ ^ 2 * volume cutoffInterval ≠ ⊤ :=
    ENNReal.mul_ne_top (ENNReal.pow_ne_top (by simp [enorm_eq_nnnorm]))
      (by rw [cutoffInterval]; simp)
  refine ne_top_of_le_ne_top hfin (hle.trans ?_)
  calc ∫⁻ x, ‖cutoffKernelVec x‖ₑ ^ 2
        ≤ ∫⁻ x, cutoffInterval.indicator (fun _ => ‖cutoffConstVec‖ₑ ^ 2) x := by
          refine lintegral_mono fun x => ?_
          by_cases hx : x ∈ cutoffInterval
          · rw [Set.indicator_of_mem hx]
            have hnn : (‖cutoffKernelVec x‖₊ : ℝ≥0∞) ≤ (‖cutoffConstVec‖₊ : ℝ≥0∞) := by
              exact_mod_cast norm_cutoffKernelVec_le x
            simpa [enorm_eq_nnnorm] using pow_le_pow_left' hnn 2
          · rw [Set.indicator_of_notMem hx]
            simp only [cutoffKernelVec, if_neg hx]
            simp
      _ = ‖cutoffConstVec‖ₑ ^ 2 * volume cutoffInterval := by
          rw [lintegral_indicator_const measurableSet_cutoffInterval]

/-- Composing with an isometry does not change the Hilbert–Schmidt norm. -/
theorem hsNormSq_isometry_comp {ι : Type*} (b : HilbertBasis ι ℂ L2R)
    (U : L2R ≃ₗᵢ[ℂ] L2R) (T : L2R →L[ℂ] L2R) :
    hsNormSq b ((U.toContinuousLinearEquiv : L2R →L[ℂ] L2R) ∘L T) = hsNormSq b T := by
  refine tsum_congr fun i => ?_
  simp

/-- **`P̂₁ P₁` is Hilbert–Schmidt**: this is the operator `B` for which the Sonin sandwich
of the paper is `B* B`. -/
theorem isHilbertSchmidt_P1hat_comp_P1 {ι : Type*} (b : HilbertBasis ι ℂ L2R) :
    IsHilbertSchmidt b (P1hat ∘L P1) := by
  have hcomp : P1hat ∘L P1
      = (fourierL2.symm.toContinuousLinearEquiv : L2R →L[ℂ] L2R) ∘L
        (P1 ∘L fourierCLM ∘L P1) := by
    ext xi
    simp [P1hat_apply, fourierCLM]
  rw [IsHilbertSchmidt, hcomp, hsNormSq_isometry_comp b fourierL2.symm]
  exact isHilbertSchmidt_cutFourierCut b

end ConnesConsani.WeilPositivity
