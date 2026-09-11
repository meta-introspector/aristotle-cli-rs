/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

**Identification of the finite part with the archimedean Weil distribution.**

`RequestProject/RenormalizedFinitePart.lean` proves that, for a test function vanishing at
`λ = 1` at a Lipschitz rate, the cut-off traces of the Sonin sandwich converge to the pairing
of the test function with the archimedean Weil kernel `λ^{1/2}/|1-λ|`:

  `Tr(ϑ(f) S^{(Λ)}) → ∫ f(λ) λ^{1/2}/|1-λ| d*λ`   (`weilPairing f`).

Here that finite part is identified with the archimedean Weil distribution `W_ℝ` (formula
(150) of arXiv:2006.13771), which the project has already formalised in
`RequestProject/WeilDistribution.lean` and evaluated in the logarithmic coordinate in
`RequestProject/ArchimedeanExplicit.lean`.

The comparison is a kernel identity.  In the logarithmic coordinate `λ = e^u` the limiting
kernel is `1/(2 sinh(|u|/2))`, whereas the kernel of `W_ℝ` in the `∆^{1/2}` normalization is
`sinhKernel u = e^{|u|/2}/(e^{|u|} - e^{-|u|})`.  These differ, and precisely by the
reflected kernel

  `sinhKernelRefl u = e^{-|u|/2}/(e^{|u|} - e^{-|u|})`,

since `weilKernelLog_eq_sinhKernel_add`

  `1/(2 sinh(|u|/2)) = e^{|u|/2}/(e^{|u|}-e^{-|u|}) + e^{-|u|/2}/(e^{|u|}-e^{-|u|})`.

Consequently (`weilPairing_eq_weilR_add_reflectionPairing`)

  `∫ f(λ) λ^{1/2}/|1-λ| d*λ = W_ℝ(∆^{-1/2} f) + (reflection term)`,

and therefore (`tendsto_modelCutTrace_weilR`, `tendsto_modelCutTrace_LfunNorm`)

  `Tr(ϑ(f) S^{(Λ)}) → W_ℝ(∆^{-1/2} f) + E(f) = D(f) - L_Norm(f) + E(f)`,

`E` being the reflection term and `L_Norm = D + W_∞ = D - W_ℝ` the functional of the paper.

Interpretation of the discrepancy `E`.  The model of `RequestProject/SemiLocalKernel.lean`
computes the trace of `ϑ(λ) S^{(Λ)}` on the *whole* of `L²(ℝ)`, while the paper's Hilbert
space is the even part `L²(ℝ)_ev` (the range of the unitary `weilMap`).  The kernel splits
accordingly: `sinhKernel` is the even-part density and `sinhKernelRefl` is the odd-part
density, and only the even part is the archimedean Weil kernel of the paper.  So the
identity above says that the finite part of the renormalized cut-off trace *is* the
archimedean Weil distribution, up to the explicitly identified odd-part contribution.
-/
import RequestProject.Imported.OutputFinal.RequestProject.RenormalizedFinitePart
import RequestProject.Imported.OutputFinal.RequestProject.ArchimedeanExplicit

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory Filter Topology Set

open scoped CompactlySupported

namespace ConnesConsani.WeilPositivity

variable {ι : Type*}

/-! ## 1. The reflected kernel -/

/-- **The reflected (odd-part) kernel** `e^{-|u|/2} / (e^{|u|} - e^{-|u|})`.  Together with
`sinhKernel` it makes up the limiting density of the semi-local trace on all of `L²(ℝ)`. -/
def sinhKernelRefl (u : ℝ) : ℝ :=
  Real.exp (-(|u| / 2)) / (Real.exp |u| - Real.exp (-|u|))

theorem sinhKernelRefl_even (u : ℝ) : sinhKernelRefl (-u) = sinhKernelRefl u := by
  simp [sinhKernelRefl, abs_neg]

theorem measurable_sinhKernelRefl : Measurable sinhKernelRefl := by
  unfold sinhKernelRefl
  fun_prop

theorem sinhKernelRefl_nonneg (u : ℝ) : 0 ≤ sinhKernelRefl u := by
  rcases eq_or_ne u 0 with rfl | hu
  · simp [sinhKernelRefl]
  · have hpos : 0 < |u| := abs_pos.2 hu
    have hden : 0 < Real.exp |u| - Real.exp (-|u|) := by
      have : Real.exp (-|u|) < Real.exp |u| := Real.exp_lt_exp.2 (by linarith)
      linarith
    exact le_of_lt (div_pos (Real.exp_pos _) hden)

/-- The reflected kernel is dominated by the Weil kernel `sinhKernel`. -/
theorem sinhKernelRefl_le_sinhKernel (u : ℝ) : sinhKernelRefl u ≤ sinhKernel u := by
  rcases eq_or_ne u 0 with rfl | hu
  · simp [sinhKernelRefl, sinhKernel]
  · have hpos : 0 < |u| := abs_pos.2 hu
    have hden : 0 < Real.exp |u| - Real.exp (-|u|) := by
      have : Real.exp (-|u|) < Real.exp |u| := Real.exp_lt_exp.2 (by linarith)
      linarith
    have hnum : Real.exp (-(|u| / 2)) ≤ Real.exp (|u| / 2) :=
      Real.exp_le_exp.2 (by linarith)
    rw [sinhKernelRefl, sinhKernel]
    exact div_le_div_of_nonneg_right hnum hden.le

/-- **The kernel splitting**: the limiting density of the semi-local trace is the sum of the
archimedean Weil kernel and the reflected kernel. -/
theorem weilKernelLog_eq_sinhKernel_add {u : ℝ} (hu : u ≠ 0) :
    Real.sqrt (Real.exp u) / |1 - Real.exp u| = sinhKernel u + sinhKernelRefl u := by
  have hpos : 0 < |u| := abs_pos.2 hu
  set t : ℝ := Real.exp (|u| / 2) with ht
  have ht0 : 0 < t := Real.exp_pos _
  have ht1 : 1 < t := by
    rw [ht, show (1:ℝ) = Real.exp 0 by simp]
    exact Real.exp_lt_exp.2 (by linarith)
  have habs : Real.exp |u| = t * t := by
    rw [ht, ← Real.exp_add]; ring_nf
  have habsneg : Real.exp (-|u|) = (t * t)⁻¹ := by
    rw [← habs, ← Real.exp_neg]
  have hhalfneg : Real.exp (-(|u| / 2)) = t⁻¹ := by
    rw [ht, ← Real.exp_neg]
  have hsinh : Real.sinh (|u| / 2) = (t - t⁻¹) / 2 := by
    rw [Real.sinh_eq, ht, ← Real.exp_neg]
  have hne : t - t⁻¹ ≠ 0 := by
    have : t⁻¹ < 1 := by
      rw [inv_lt_one₀ ht0]
      exact ht1
    intro h
    have : t = t⁻¹ := by linarith [sub_eq_zero.1 h]
    linarith
  rw [weilKernel_exp hu, sinhKernel, sinhKernelRefl, habs, habsneg, hhalfneg, hsinh, ← ht]
  have hden : t * t - (t * t)⁻¹ ≠ 0 := by
    have h1 : (t * t)⁻¹ < 1 := by
      rw [inv_lt_one₀ (by positivity)]
      nlinarith
    intro h
    have : t * t = (t * t)⁻¹ := by linarith [sub_eq_zero.1 h]
    nlinarith
  have h2 : (-1 + t ^ 2) ≠ 0 := ne_of_gt (by nlinarith)
  have h1t : (1 + t ^ 2) ≠ 0 := by positivity
  have ht0' : t ≠ 0 := ne_of_gt ht0
  clear_value t
  rw [show 2 * ((t - t⁻¹) / 2) = t - t⁻¹ by ring, ← add_div, div_eq_div_iff hne hden]
  field_simp
  ring

/-! ## 2. Passage to the logarithmic coordinate -/

theorem logTest_apply_zero (g : C_c(Rplus, ℂ)) : logTest g 0 = g 1 := by
  have : Rplus.expHomeo (0:ℝ) = (1 : Rplus) := Subtype.ext (by simp)
  rw [logTest, this]

/-- `|1 - e^u| ≤ |u| e^{|u|}`. -/
theorem abs_one_sub_exp_le (u : ℝ) : |1 - Real.exp u| ≤ |u| * Real.exp |u| := by
  rcases le_or_gt 0 u with hu | hu
  · have h1 : 1 ≤ Real.exp u := Real.one_le_exp hu
    have habs : |1 - Real.exp u| = Real.exp u - 1 := by
      rw [abs_of_nonpos (by linarith)]; ring
    have hkey : 1 - u ≤ Real.exp (-u) := by
      have := Real.add_one_le_exp (-u)
      linarith
    have hexp : Real.exp u * Real.exp (-u) = 1 := by
      rw [← Real.exp_add]; simp
    have : Real.exp u - 1 ≤ u * Real.exp u := by
      nlinarith [Real.exp_pos u]
    rw [habs, abs_of_nonneg hu]
    exact this
  · have h1 : Real.exp u < 1 := by
      rw [show (1:ℝ) = Real.exp 0 by simp]
      exact Real.exp_lt_exp.2 hu
    have habs : |1 - Real.exp u| = 1 - Real.exp u := abs_of_nonneg (by linarith)
    have hkey : 1 + u ≤ Real.exp u := Real.add_one_le_exp u |>.trans_eq' (by ring)
    have hle : 1 - Real.exp u ≤ -u := by linarith
    have hexp2 : (1:ℝ) ≤ Real.exp (-u) := Real.one_le_exp (by linarith)
    rw [habs, abs_of_neg hu]
    nlinarith [hexp2, hle, hu]
/-! ## 3. The Lipschitz hypothesis in the logarithmic coordinate -/

/-- A test function vanishing at `1` at a Lipschitz rate has a logarithmic transcription
which vanishes at `0` at a Lipschitz rate. -/
theorem exists_logTest_lipschitz (g : C_c(Rplus, ℂ)) {C : ℝ}
    (hg : ∀ lam : Rplus, ‖g lam‖ ≤ C * |1 - (lam : ℝ)|) :
    ∃ C' : ℝ, ∀ u : ℝ, ‖logTest g u‖ ≤ C' * |u| := by
  obtain ⟨R, hR⟩ :=
    (hasCompactSupport_logTest g).isBounded.subset_closedBall (0:ℝ)
  refine ⟨max C 0 * Real.exp |R|, fun u => ?_⟩
  by_cases hu : u ∈ tsupport (logTest g)
  · have hmem := hR hu
    have hle : |u| ≤ R := by
      simpa [Real.norm_eq_abs] using mem_closedBall_zero_iff.1 hmem
    have hC : C ≤ max C 0 := le_max_left _ _
    have hC0 : (0:ℝ) ≤ max C 0 := le_max_right _ _
    have h1 : ‖logTest g u‖ ≤ max C 0 * |1 - Real.exp u| := by
      refine le_trans (hg (Rplus.expHomeo u)) ?_
      have : ((Rplus.expHomeo u : Rplus) : ℝ) = Real.exp u := rfl
      rw [this]
      exact mul_le_mul_of_nonneg_right hC (abs_nonneg _)
    refine le_trans h1 ?_
    have h2 : |1 - Real.exp u| ≤ |u| * Real.exp |R| := by
      refine le_trans (abs_one_sub_exp_le u) ?_
      have : Real.exp |u| ≤ Real.exp |R| :=
        Real.exp_le_exp.2 (le_trans hle (le_abs_self R))
      exact mul_le_mul_of_nonneg_left this (abs_nonneg u)
    calc max C 0 * |1 - Real.exp u| ≤ max C 0 * (|u| * Real.exp |R|) := by
          exact mul_le_mul_of_nonneg_left h2 hC0
      _ = max C 0 * Real.exp |R| * |u| := by ring
  · rw [image_eq_zero_of_notMem_tsupport hu, norm_zero]
    have : (0:ℝ) ≤ max C 0 * Real.exp |R| := by positivity
    exact mul_nonneg this (abs_nonneg u)

/-! ## 4. The finite part is the archimedean Weil distribution -/

/-- The pairing of a test function with the reflected (odd-part) kernel. -/
def reflectionPairing (G : ℝ → ℂ) : ℂ := ∫ u : ℝ, G u * ((sinhKernelRefl u : ℝ) : ℂ)

theorem ae_ne_zero_real : ∀ᵐ u : ℝ, u ≠ 0 := by
  rw [MeasureTheory.ae_iff]
  simp

/-- The Weil-kernel pairing in the logarithmic coordinate. -/
theorem weilPairing_eq_integral_log (g : C_c(Rplus, ℂ)) :
    weilPairing g
      = ∫ u : ℝ, logTest g u * ((sinhKernel u + sinhKernelRefl u : ℝ) : ℂ) := by
  rw [weilPairing, Rplus.integral_haar]
  refine integral_congr_ae ?_
  filter_upwards [ae_ne_zero_real] with u hu
  have hval : weilKernelRplus (Rplus.expHomeo u) = sinhKernel u + sinhKernelRefl u := by
    rw [weilKernelRplus]
    have hcoe : ((Rplus.expHomeo u : Rplus) : ℝ) = Real.exp u := rfl
    rw [hcoe]
    exact weilKernelLog_eq_sinhKernel_add hu
  rw [hval]
  rfl

theorem integrable_mul_sinhKernel_of_lipschitz {G : ℝ → ℂ} (hGc : Continuous G) (hG0 : G 0 = 0)
    {C : ℝ} (hLip : ∀ u : ℝ, ‖G u‖ ≤ C * |u|) :
    Integrable (fun u : ℝ => G u * ((sinhKernel u : ℝ) : ℂ)) := by
  have hLip' : ∀ u : ℝ, ‖G u - G 0‖ ≤ C * |u| := by simpa [hG0] using hLip
  have h := (integrable_sub_mul_sinhKernel hGc hLip').neg
  refine h.congr (.of_forall fun u => ?_)
  simp [hG0]

theorem integrable_mul_sinhKernelRefl_of_lipschitz {G : ℝ → ℂ} (hGc : Continuous G)
    (hG0 : G 0 = 0) {C : ℝ} (hLip : ∀ u : ℝ, ‖G u‖ ≤ C * |u|) :
    Integrable (fun u : ℝ => G u * ((sinhKernelRefl u : ℝ) : ℂ)) := by
  have hLip' : ∀ u : ℝ, ‖G u - G 0‖ ≤ C * |u| := by simpa [hG0] using hLip
  refine Integrable.mono' (integrable_norm_sub_mul_sinhKernel hGc hLip') ?_
    (.of_forall fun u => ?_)
  · exact hGc.aestronglyMeasurable.mul
      (Complex.continuous_ofReal.measurable.comp measurable_sinhKernelRefl).aestronglyMeasurable
  · rw [norm_mul, Complex.norm_real, Real.norm_eq_abs,
      abs_of_nonneg (sinhKernelRefl_nonneg u), hG0]
    have hGu : ‖G u‖ = ‖(0 : ℂ) - G u‖ := by rw [zero_sub, norm_neg]
    rw [hGu]
    exact mul_le_mul_of_nonneg_left (sinhKernelRefl_le_sinhKernel u) (norm_nonneg _)

/-- **The pairing with the archimedean Weil kernel is the Weil distribution `W_ℝ`** (in the
`∆^{1/2}` normalization of the paper) **plus the reflected pairing.** -/
theorem integral_mul_sinhKernel_eq_weilR {G : ℝ → ℂ} (hGc : Continuous G) (hG0 : G 0 = 0)
    {C : ℝ} (hLip : ∀ u : ℝ, ‖G u‖ ≤ C * |u|) :
    (∫ u : ℝ, G u * ((sinhKernel u : ℝ) : ℂ)) = WeilR (deltaHalfInv (ofLog G)) := by
  have hLip' : ∀ u : ℝ, ‖G u - G 0‖ ≤ C * |u| := by simpa [hG0] using hLip
  have h1 := integral_sub_mul_sinhKernel_Ioi hGc hLip'
  have hneg : (∫ u : ℝ, (G 0 - G u) * ((sinhKernel u : ℝ) : ℂ))
      = -∫ u : ℝ, G u * ((sinhKernel u : ℝ) : ℂ) := by
    rw [← integral_neg]
    refine integral_congr_ae (.of_forall fun u => ?_)
    rw [hG0]
    ring
  rw [hneg] at h1
  have h2 : (∫ u : ℝ, G u * ((sinhKernel u : ℝ) : ℂ))
      = ∫ u in Ioi (0:ℝ), (G u + G (-u))
          * ((Real.exp (u / 2) / (Real.exp u - Real.exp (-u)) : ℝ) : ℂ) := by
    rw [eq_comm, ← neg_eq_iff_eq_neg.2 h1.symm, ← integral_neg]
    refine setIntegral_congr_fun measurableSet_Ioi (fun u _ => ?_)
    rw [hG0]
    ring
  rw [h2, WeilR_deltaHalfInv_ofLog, hG0]
  simp only [mul_zero, zero_add, sub_zero]
  refine setIntegral_congr_fun measurableSet_Ioi (fun u _ => ?_)
  rw [Complex.ofReal_div]
  ring

/-- **The finite part of the cut-off trace, identified with the archimedean Weil
distribution.**  For a test function vanishing at `1` at a Lipschitz rate,

  `∫ f(λ) λ^{1/2}/|1-λ| d*λ = W_ℝ(∆^{-1/2} f) + E(f)`,

`E` the pairing with the reflected (odd-part) kernel. -/
theorem weilPairing_eq_weilR_add_reflectionPairing (g : C_c(Rplus, ℂ)) {C : ℝ}
    (hg : ∀ lam : Rplus, ‖g lam‖ ≤ C * |1 - (lam : ℝ)|) :
    weilPairing g
      = WeilR (deltaHalfInv (ofLog (logTest g))) + reflectionPairing (logTest g) := by
  obtain ⟨C', hLip⟩ := exists_logTest_lipschitz g hg
  set G : ℝ → ℂ := logTest g with hG
  have hGc : Continuous G := continuous_logTest g
  have hG0 : G 0 = 0 := by
    rw [hG, logTest_apply_zero]
    have h := hg 1
    have h1 : ((1 : Rplus) : ℝ) = 1 := rfl
    rw [h1] at h
    simpa using h
  have hsplit : (∫ u : ℝ, G u * ((sinhKernel u + sinhKernelRefl u : ℝ) : ℂ))
      = (∫ u : ℝ, G u * ((sinhKernel u : ℝ) : ℂ))
        + ∫ u : ℝ, G u * ((sinhKernelRefl u : ℝ) : ℂ) := by
    rw [← integral_add (integrable_mul_sinhKernel_of_lipschitz hGc hG0 hLip)
      (integrable_mul_sinhKernelRefl_of_lipschitz hGc hG0 hLip)]
    refine integral_congr_ae (.of_forall fun u => ?_)
    push_cast
    ring
  rw [weilPairing_eq_integral_log g, hsplit,
    integral_mul_sinhKernel_eq_weilR hGc hG0 hLip, reflectionPairing]

/-- **The limit of the cut-off traces is the archimedean Weil distribution** (plus the
explicitly identified odd-part contribution):

  `Tr(ϑ(f) S^{(Λ)}) → W_ℝ(∆^{-1/2} f) + E(f)`. -/
theorem tendsto_modelCutTrace_weilR [Countable ι] (b : HilbertBasis ι ℂ L2R)
    (g : C_c(Rplus, ℂ)) {C : ℝ} (hg : ∀ lam : Rplus, ‖g lam‖ ≤ C * |1 - (lam : ℝ)|) :
    Tendsto (fun cut : ℝ => modelCutTrace b cut g) atTop
      (𝓝 (WeilR (deltaHalfInv (ofLog (logTest g))) + reflectionPairing (logTest g))) := by
  rw [← weilPairing_eq_weilR_add_reflectionPairing g hg]
  exact tendsto_modelCutTrace_of_lipschitz_at_one b g hg

/-- `W_ℝ(∆^{-1/2} f) = D(f) - L_Norm(f)`: the Weil distribution is the archimedean part of
the functional `L_Norm = D + W_∞` of the paper, and `W_∞ = -W_ℝ`. -/
theorem weilR_eq_sub_LfunNorm (G : ℝ → ℂ) :
    WeilR (deltaHalfInv (ofLog G)) = Dcomplex (ofLog G) - LfunNorm G := by
  rw [LfunNorm, Winfty]
  ring

/-- **The finite part of the renormalized cut-off trace in terms of `L_Norm`.**  For a test
function vanishing at `1` at a Lipschitz rate,

  `Tr(ϑ(f) S^{(Λ)}) → D(f) - L_Norm(f) + E(f)`,

with `E` the pairing against the reflected (odd-part) kernel.  On such test functions no
logarithmic subtraction is needed, so this *is* the finite part of the renormalized cut-off
trace. -/
theorem tendsto_modelCutTrace_LfunNorm [Countable ι] (b : HilbertBasis ι ℂ L2R)
    (g : C_c(Rplus, ℂ)) {C : ℝ} (hg : ∀ lam : Rplus, ‖g lam‖ ≤ C * |1 - (lam : ℝ)|) :
    Tendsto (fun cut : ℝ => modelCutTrace b cut g) atTop
      (𝓝 (Dcomplex (ofLog (logTest g)) - LfunNorm (logTest g)
        + reflectionPairing (logTest g))) := by
  have h := tendsto_modelCutTrace_weilR b g hg
  rwa [weilR_eq_sub_LfunNorm] at h

end ConnesConsani.WeilPositivity
