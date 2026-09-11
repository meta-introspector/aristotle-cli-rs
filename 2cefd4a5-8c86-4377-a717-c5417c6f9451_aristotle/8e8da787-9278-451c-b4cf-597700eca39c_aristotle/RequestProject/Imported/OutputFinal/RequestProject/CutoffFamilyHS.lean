/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Trace-classness of the renormalized Sonin sandwich `S^{(Λ)} = P^{(Λ)} P̂^{(Λ)} P^{(Λ)}`,
for arXiv:2006.13771 (Connes–Consani, *Weil positivity and Trace formula – the archimedean
place*).

`RequestProject/CutoffHilbertSchmidt.lean` proves that the operator `B = P̂₁ P₁` (the case
`Λ = 1`) is Hilbert–Schmidt.  The argument only used that the cut-off set is measurable of
finite measure, so it is repeated here for an arbitrary such set; the case of the family
`Pcut Λ`, `PcutHat Λ` of `RequestProject/CutoffFamily.lean` follows.  Consequently

* `B_Λ = P̂^{(Λ)} P^{(Λ)}` is Hilbert–Schmidt (`isHilbertSchmidt_PcutHat_comp_Pcut`),
* `S^{(Λ)} = B_Λ^* B_Λ` is trace class (`isTraceClass_soninSandwichCut`),
* `ϑ(f) S^{(Λ)}` is trace class for every test function `f`, with an absolutely convergent
  and basis-independent trace, nonnegative on convolution squares.
-/
import RequestProject.Imported.OutputFinal.RequestProject.CutoffFamily
import RequestProject.Imported.OutputFinal.RequestProject.CutoffHilbertSchmidt
import RequestProject.Imported.OutputFinal.RequestProject.LogPicture
import RequestProject.Imported.OutputFinal.RequestProject.SoninSandwich
import RequestProject.Imported.OutputFinal.RequestProject.TraceBasisIndep

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory FourierTransform Real Set ContinuousLinearMap

open scoped ENNReal NNReal CompactlySupported

namespace ConnesConsani.WeilPositivity

section GeneralSet

variable {s : Set ℝ}

/-- The cut-off character `1_s(v) e^{2πi v x}` is square integrable when `s` has finite
measure. -/
theorem memLp_indicator_unitChar_set (hs : MeasurableSet s) (hfin : volume s ≠ ⊤) (x : ℝ) :
    MemLp (s.indicator (unitChar x)) 2 volume := by
  refine MemLp.mono (g := s.indicator (fun _ : ℝ => (1 : ℂ)))
    (memLp_indicator_const 2 hs 1 (Or.inr hfin)) ?_ ?_
  · exact ((continuous_unitChar x).aestronglyMeasurable).indicator hs
  · filter_upwards with v
    by_cases hv : v ∈ s <;> simp [hv, norm_unitChar]

/-- The constant cut-off vector `1_s`, used as a norm bound for the kernel. -/
def cutoffConstVecOn (hs : MeasurableSet s) (hfin : volume s ≠ ⊤) : L2R :=
  (memLp_indicator_const 2 hs (1 : ℂ) (Or.inr hfin)).toLp _

open Classical in
/-- The kernel vectors of the doubly cut Fourier transform on the set `s`. -/
def cutoffKernelVecOn (hs : MeasurableSet s) (hfin : volume s ≠ ⊤) (x : ℝ) : L2R :=
  if x ∈ s then (memLp_indicator_unitChar_set hs hfin x).toLp _ else 0

theorem norm_cutoffKernelVecOn_le (hs : MeasurableSet s) (hfin : volume s ≠ ⊤) (x : ℝ) :
    ‖cutoffKernelVecOn hs hfin x‖ ≤ ‖cutoffConstVecOn hs hfin‖ := by
  classical
  simp only [cutoffKernelVecOn]
  split_ifs with hx
  · refine Lp.norm_le_norm_of_ae_le ?_
    filter_upwards [MemLp.coeFn_toLp (memLp_indicator_unitChar_set hs hfin x),
      MemLp.coeFn_toLp (f := s.indicator (fun _ : ℝ => (1 : ℂ)))
        (memLp_indicator_const 2 hs (1 : ℂ) (Or.inr hfin))] with v h1 h2
    rw [h1, show ((cutoffConstVecOn hs hfin : ℝ → ℂ) v)
      = s.indicator (fun _ : ℝ => (1 : ℂ)) v from h2]
    by_cases hv : v ∈ s <;> simp [hv, norm_unitChar]
  · simp

/-- `1_s ξ` is integrable when `s` has finite measure. -/
theorem integrable_coeFn_cutoff (hs : MeasurableSet s) (hfin : volume s ≠ ⊤) (xi : L2R) :
    Integrable ((cutoff hs xi : L2R) : ℝ → ℂ) volume := by
  have hae : ((cutoff hs xi : L2R) : ℝ → ℂ) =ᵐ[volume]
      s.indicator ((xi : L2R) : ℝ → ℂ) := coeFn_cutoff _ _
  haveI : IsFiniteMeasure (volume.restrict s) :=
    ⟨by rwa [Measure.restrict_apply_univ, lt_top_iff_ne_top]⟩
  have hon : IntegrableOn ((xi : L2R) : ℝ → ℂ) s volume :=
    MemLp.integrable (by norm_num) ((Lp.memLp xi).restrict s)
  exact (Integrable.congr (hon.integrable_indicator hs) hae.symm)

/-- **The kernel identity**: `1_s 𝓕 1_s` is the integral operator with kernel
`1_s(x) e^{-2πi xv} 1_s(v)`. -/
theorem coeFn_cutFourierCutOn (hs : MeasurableSet s) (hfin : volume s ≠ ⊤) (xi : L2R) :
    ((cutoff hs ∘L fourierCLM ∘L cutoff hs) xi : ℝ → ℂ)
      =ᵐ[volume] fun x => inner ℂ (cutoffKernelVecOn hs hfin x) xi := by
  have h1 : ((cutoff hs xi : L2R) : ℝ → ℂ) =ᵐ[volume]
      s.indicator ((xi : L2R) : ℝ → ℂ) := coeFn_cutoff _ _
  have h2 : ((fourierL2 (cutoff hs xi) : L2R) : ℝ → ℂ)
      =ᵐ[volume] 𝓕 ((cutoff hs xi : L2R) : ℝ → ℂ) :=
    coeFn_fourierL2_of_integrable _ (integrable_coeFn_cutoff hs hfin xi)
  have h3 : 𝓕 ((cutoff hs xi : L2R) : ℝ → ℂ) = 𝓕 (s.indicator ((xi : L2R) : ℝ → ℂ)) :=
    fourier_congr_ae h1
  have h4 : ((cutoff hs (fourierL2 (cutoff hs xi)) : L2R) : ℝ → ℂ) =ᵐ[volume]
      s.indicator ((fourierL2 (cutoff hs xi) : L2R) : ℝ → ℂ) := coeFn_cutoff _ _
  have hstep : ((cutoff hs ∘L fourierCLM ∘L cutoff hs) xi : ℝ → ℂ) =ᵐ[volume]
      s.indicator (𝓕 (s.indicator ((xi : L2R) : ℝ → ℂ))) := by
    refine h4.trans ?_
    rw [← h3]
    exact h2.mono fun x hx => by
      by_cases hxI : x ∈ s <;> simp [hxI, hx]
  refine hstep.trans (.of_forall fun x => ?_)
  by_cases hxI : x ∈ s
  · classical
    rw [Set.indicator_of_mem hxI]
    simp only [cutoffKernelVecOn, if_pos hxI]
    rw [L2.inner_def, Real.fourier_eq]
    refine (integral_congr_ae ?_).symm
    filter_upwards [MemLp.coeFn_toLp (memLp_indicator_unitChar_set hs hfin x)] with v hv
    rw [hv]
    by_cases hvI : v ∈ s
    · simp only [Set.indicator_of_mem hvI, RCLike.inner_apply, unitChar, Circle.smul_def,
        smul_eq_mul, starRingEnd_apply, star_trivial]
      rw [show (star ((𝐞 (v * x) : Circle) : ℂ)) = ((𝐞 (-(v * x)) : Circle) : ℂ) from
        conj_fourierChar (v * x), mul_comm x v]
      exact mul_comm _ _
    · simp [hvI]
  · rw [Set.indicator_of_notMem hxI]
    simp only [cutoffKernelVecOn, if_neg hxI]
    simp

/-- **`1_s 𝓕 1_s` is Hilbert–Schmidt** for every measurable `s` of finite measure. -/
theorem isHilbertSchmidt_cutFourierCutOn {ι : Type*} (hs : MeasurableSet s)
    (hfin : volume s ≠ ⊤) (b : HilbertBasis ι ℂ L2R) :
    IsHilbertSchmidt b (cutoff hs ∘L fourierCLM ∘L cutoff hs) := by
  classical
  have hle := hsNormSq_le_of_kernel b (cutoff hs ∘L fourierCLM ∘L cutoff hs)
    (cutoffKernelVecOn hs hfin) (coeFn_cutFourierCutOn hs hfin)
  have hfin' : ‖cutoffConstVecOn hs hfin‖ₑ ^ 2 * volume s ≠ ⊤ :=
    ENNReal.mul_ne_top (ENNReal.pow_ne_top (by simp [enorm_eq_nnnorm])) hfin
  refine ne_top_of_le_ne_top hfin' (hle.trans ?_)
  calc ∫⁻ x, ‖cutoffKernelVecOn hs hfin x‖ₑ ^ 2
        ≤ ∫⁻ x, s.indicator (fun _ => ‖cutoffConstVecOn hs hfin‖ₑ ^ 2) x := by
          refine lintegral_mono fun x => ?_
          by_cases hx : x ∈ s
          · rw [Set.indicator_of_mem hx]
            have hnn : (‖cutoffKernelVecOn hs hfin x‖₊ : ℝ≥0∞)
                ≤ (‖cutoffConstVecOn hs hfin‖₊ : ℝ≥0∞) := by
              exact_mod_cast norm_cutoffKernelVecOn_le hs hfin x
            simpa [enorm_eq_nnnorm] using pow_le_pow_left' hnn 2
          · rw [Set.indicator_of_notMem hx]
            simp only [cutoffKernelVecOn, if_neg hx]
            simp
      _ = ‖cutoffConstVecOn hs hfin‖ₑ ^ 2 * volume s := by
          rw [lintegral_indicator_const hs]

/-- **`(𝓕⁻¹ 1_s 𝓕) 1_s` is Hilbert–Schmidt.** -/
theorem isHilbertSchmidt_fourierConj_cutoff_comp {ι : Type*} (hs : MeasurableSet s)
    (hfin : volume s ≠ ⊤) (b : HilbertBasis ι ℂ L2R) :
    IsHilbertSchmidt b (fourierConj (cutoff hs) ∘L cutoff hs) := by
  have hcomp : fourierConj (cutoff hs) ∘L cutoff hs
      = (fourierL2.symm.toContinuousLinearEquiv : L2R →L[ℂ] L2R) ∘L
        (cutoff hs ∘L fourierCLM ∘L cutoff hs) := by
    ext xi
    simp [fourierConj_apply, fourierCLM]
  rw [IsHilbertSchmidt, hcomp, hsNormSq_isometry_comp b fourierL2.symm]
  exact isHilbertSchmidt_cutFourierCutOn hs hfin b

end GeneralSet

/-! ## The Hilbert–Schmidt property along the family -/

variable {ι : Type*}

/-- **`B_Λ = P̂^{(Λ)} P^{(Λ)}` is Hilbert–Schmidt** for every cut-off scale `Λ`. -/
theorem isHilbertSchmidt_PcutHat_comp_Pcut (lam : ℝ) (b : HilbertBasis ι ℂ L2R) :
    IsHilbertSchmidt b (PcutHat lam ∘L Pcut lam) :=
  isHilbertSchmidt_fourierConj_cutoff_comp (measurableSet_cutoffSet lam)
    (volume_cutoffSet_ne_top lam) b

/-- **`S^{(Λ)}` is trace class.** -/
theorem isTraceClass_soninSandwichCut (lam : ℝ) (b : HilbertBasis ι ℂ L2R) :
    IsTraceClass b (soninSandwichCut lam) := by
  have hB : IsHilbertSchmidt b (PcutHat lam ∘L Pcut lam) :=
    isHilbertSchmidt_PcutHat_comp_Pcut lam b
  rw [soninSandwichCut_eq_adjoint_comp]
  exact IsTraceClass.of_hilbertSchmidt_comp hB.adjoint hB

/-- **Any bounded operator times `S^{(Λ)}` is trace class.** -/
theorem isTraceClass_comp_soninSandwichCut (lam : ℝ) (b : HilbertBasis ι ℂ L2R)
    (A : L2R →L[ℂ] L2R) : IsTraceClass b (A ∘L soninSandwichCut lam) := by
  have hB : IsHilbertSchmidt b (PcutHat lam ∘L Pcut lam) :=
    isHilbertSchmidt_PcutHat_comp_Pcut lam b
  refine ⟨A ∘L ContinuousLinearMap.adjoint (PcutHat lam ∘L Pcut lam), PcutHat lam ∘L Pcut lam,
    hB.adjoint.comp_left A, hB, ?_⟩
  rw [soninSandwichCut_eq_adjoint_comp, ContinuousLinearMap.comp_assoc]

/-- **`ϑ(f) S^{(Λ)}` is trace class** for every continuous compactly supported test
function. -/
theorem isTraceClass_thetaOp_soninSandwichCut (lam : ℝ) (b : HilbertBasis ι ℂ L2R)
    (U : L2Rplus ≃ₗᵢ[ℂ] L2R) (g : C_c(Rplus, ℂ)) :
    IsTraceClass b (thetaOpOf U g ∘L soninSandwichCut lam) :=
  isTraceClass_comp_soninSandwichCut lam b (thetaOpOf U g)

/-- Its trace series converges absolutely. -/
theorem summable_norm_inner_thetaOp_soninSandwichCut (lam : ℝ) (b : HilbertBasis ι ℂ L2R)
    (U : L2Rplus ≃ₗᵢ[ℂ] L2R) (g : C_c(Rplus, ℂ)) :
    Summable fun i => ‖inner ℂ (b i) ((thetaOpOf U g ∘L soninSandwichCut lam) (b i))‖ :=
  summable_norm_inner_of_isTraceClass (isTraceClass_thetaOp_soninSandwichCut lam b U g)

/-- Its trace does not depend on the chosen Hilbert basis. -/
theorem traceAlong_thetaOp_soninSandwichCut_basis_indep {κ : Type*} (lam : ℝ)
    (b : HilbertBasis ι ℂ L2R) (c : HilbertBasis κ ℂ L2R) (U : L2Rplus ≃ₗᵢ[ℂ] L2R)
    (g : C_c(Rplus, ℂ)) :
    traceAlong b (thetaOpOf U g ∘L soninSandwichCut lam)
      = traceAlong c (thetaOpOf U g ∘L soninSandwichCut lam) :=
  traceAlong_basis_indep_of_isTraceClass b c (isTraceClass_thetaOp_soninSandwichCut lam b U g)

/-- **`Tr(ϑ(g ∗ g^♯) S^{(Λ)}) ≥ 0`**: at every cut-off scale the trace functional is
nonnegative on convolution squares. -/
theorem re_traceAlong_thetaOp_convSquare_soninSandwichCut_nonneg (lam : ℝ)
    (b : HilbertBasis ι ℂ L2R) (U : L2Rplus ≃ₗᵢ[ℂ] L2R) (g : C_c(Rplus, ℂ)) :
    0 ≤ (traceAlong b (thetaOpOf U (testConv g (starTest g)) ∘L soninSandwichCut lam)).re := by
  rw [thetaOpOf_testConv_starTest, soninSandwichCut_eq_adjoint_comp]
  exact re_traceAlong_selfAdjointSandwich_nonneg b (thetaOpOf U g)
    (isHilbertSchmidt_PcutHat_comp_Pcut lam b)

end ConnesConsani.WeilPositivity
