/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
Authors: Formalization of
  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771
-/
import RequestProject.Imported.OutputFinal.RequestProject.WeilKernelComparison
import RequestProject.Imported.OutputFinal.RequestProject.UnnormalizedCounterexample

/-!
# The renormalized cut-off trace: full asymptotic expansion and the finite part

This file completes the extraction of the **finite part** of the renormalized cut-off trace.

## What is proved here

For the concrete semi-local model (`modelCutTrace`, see
`RequestProject/RenormalizedFinitePart.lean`), and for *every* compactly supported continuous
test function `f` on `ℝ⋆₊` which is Lipschitz at `λ = 1`, we prove

  `Tr(ϑ(f) S^{(Λ)}) - f(1) · c · log Λ  ⟶  W_ℝ(∆^{-1/2} F) + E(F) + f(1) · z₁`,

where

* `F = logTest f` is `f` read in the logarithmic coordinate `λ = e^u`;
* `W_ℝ(∆^{-1/2} F)` is the **archimedean Weil distribution** already formalized in
  `RequestProject/WeilDistribution.lean` / `RequestProject/ArchimedeanExplicit.lean`
  (equivalently, by `weilR_eq_sub_LfunNorm`, `D(F) - L_Norm(F)`);
* `E(F) = reflectionPairingReg F` is the explicitly identified pairing with the **reflected
  kernel** `e^{-|u|/2}/(e^{|u|}-e^{-|u|})`, i.e. the contribution of the *odd* part of
  `L²(ℝ)`, which is present in the full-line model used here but absent in the even
  (Sonin) picture of the paper;
* `c` and `z₁` are **two universal scalars** (independent of `f`), coming from the
  logarithmic profile `HasCutoffLogProfile` of a *single* reference test function.

So the entire asymptotic expansion of the renormalized cut-off trace is reduced to the two
scalars `(c, z₁)` attached to one reference function; the whole `f`-dependence of the finite
part is the archimedean Weil distribution (plus the odd-part term).  No `sorry` is used.

## What is not proved here

The values `c` (expected `4` in this full-line model, i.e. `2 log Λ²`, and `2` in the even
picture of the paper) and `z₁` are *not* computed: they require the diagonal asymptotics of
the Si-kernel at `λ = 1`, which is the remaining analytic input.  They enter only through the
hypothesis `HasCutoffLogProfile`, which is a `Prop`, never an axiom.
-/

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory Filter Topology Set

open scoped CompactlySupported

namespace ConnesConsani.WeilPositivity

variable {ι : Type*}

/-! ## 1. The regularized pairing with the reflected kernel -/

/-- The **regularized** pairing of a test function with the reflected (odd-part) kernel
`e^{-|u|/2}/(e^{|u|}-e^{-|u|})`.  The kernel is singular like `1/(2|u|)` at `u = 0`, so the
pairing is regularized exactly as in the definition of `W_ℝ`, by subtracting the value at the
origin.  For test functions vanishing at `0` it is the naive pairing `reflectionPairing`. -/
def reflectionPairingReg (G : ℝ → ℂ) : ℂ :=
  -∫ u : ℝ, (G 0 - G u) * ((sinhKernelRefl u : ℝ) : ℂ)

theorem integrable_sub_mul_sinhKernelRefl {G : ℝ → ℂ} (hGc : Continuous G) {C : ℝ}
    (hLip : ∀ u : ℝ, ‖G u - G 0‖ ≤ C * |u|) :
    Integrable (fun u : ℝ => (G 0 - G u) * ((sinhKernelRefl u : ℝ) : ℂ)) := by
  refine Integrable.mono' (integrable_norm_sub_mul_sinhKernel hGc hLip) ?_
    (.of_forall fun u => ?_)
  · exact (continuous_const.sub hGc).aestronglyMeasurable.mul
      (Complex.continuous_ofReal.measurable.comp measurable_sinhKernelRefl).aestronglyMeasurable
  · rw [norm_mul, Complex.norm_real, Real.norm_eq_abs,
      abs_of_nonneg (sinhKernelRefl_nonneg u)]
    exact mul_le_mul_of_nonneg_left (sinhKernelRefl_le_sinhKernel u) (norm_nonneg _)

/-- For a test function vanishing at the origin the regularized reflected pairing is the
naive one. -/
theorem reflectionPairingReg_of_apply_zero {G : ℝ → ℂ} (hG0 : G 0 = 0) :
    reflectionPairingReg G = reflectionPairing G := by
  rw [reflectionPairingReg, reflectionPairing, ← integral_neg]
  refine integral_congr_ae (.of_forall fun u => ?_)
  simp [hG0]

/-! ## 2. Linearity of the two regularized pairings -/

theorem reflectionPairingReg_sub_smul {G H : ℝ → ℂ} (hGc : Continuous G) (hHc : Continuous H)
    {C C' : ℝ} (hLipG : ∀ u : ℝ, ‖G u - G 0‖ ≤ C * |u|)
    (hLipH : ∀ u : ℝ, ‖H u - H 0‖ ≤ C' * |u|) (a : ℂ) :
    reflectionPairingReg (fun u => G u - a * H u)
      = reflectionPairingReg G - a * reflectionPairingReg H := by
  have hGi := integrable_sub_mul_sinhKernelRefl hGc hLipG
  have hHi := integrable_sub_mul_sinhKernelRefl hHc hLipH
  have hsplit : (∫ u : ℝ, ((G 0 - a * H 0) - (G u - a * H u)) * ((sinhKernelRefl u : ℝ) : ℂ))
      = (∫ u : ℝ, (G 0 - G u) * ((sinhKernelRefl u : ℝ) : ℂ))
        - a * ∫ u : ℝ, (H 0 - H u) * ((sinhKernelRefl u : ℝ) : ℂ) := by
    rw [← integral_const_mul, ← integral_sub hGi (hHi.const_mul a)]
    refine integral_congr_ae (.of_forall fun u => ?_)
    ring
  simp only [reflectionPairingReg]
  rw [hsplit]
  ring

/-- The archimedean Weil distribution read in the logarithmic coordinate is linear. -/
theorem weilR_ofLog_sub_smul {G H : ℝ → ℂ} (hGc : Continuous G) (hHc : Continuous H)
    {C C' : ℝ} (hLipG : ∀ u : ℝ, ‖G u - G 0‖ ≤ C * |u|)
    (hLipH : ∀ u : ℝ, ‖H u - H 0‖ ≤ C' * |u|) (a : ℂ) :
    WeilR (deltaHalfInv (ofLog (fun u => G u - a * H u)))
      = WeilR (deltaHalfInv (ofLog G)) - a * WeilR (deltaHalfInv (ofLog H)) := by
  have hKc : Continuous (fun u : ℝ => G u - a * H u) := hGc.sub (continuous_const.mul hHc)
  have hKLip : ∀ u : ℝ,
      ‖(fun u : ℝ => G u - a * H u) u - (fun u : ℝ => G u - a * H u) 0‖
        ≤ (C + ‖a‖ * C') * |u| := by
    intro u
    have h : (G u - a * H u) - (G 0 - a * H 0) = (G u - G 0) - a * (H u - H 0) := by ring
    calc ‖(G u - a * H u) - (G 0 - a * H 0)‖
        = ‖(G u - G 0) - a * (H u - H 0)‖ := by rw [h]
      _ ≤ ‖G u - G 0‖ + ‖a * (H u - H 0)‖ := norm_sub_le _ _
      _ ≤ C * |u| + ‖a‖ * (C' * |u|) := by
          gcongr
          · exact hLipG u
          · rw [norm_mul]
            exact mul_le_mul_of_nonneg_left (hLipH u) (norm_nonneg a)
      _ = (C + ‖a‖ * C') * |u| := by ring
  have hGi := integrable_sub_mul_sinhKernel hGc hLipG
  have hHi := integrable_sub_mul_sinhKernel hHc hLipH
  have hsplit : (∫ u : ℝ, ((G 0 - a * H 0) - (G u - a * H u)) * ((sinhKernel u : ℝ) : ℂ))
      = (∫ u : ℝ, (G 0 - G u) * ((sinhKernel u : ℝ) : ℂ))
        - a * ∫ u : ℝ, (H 0 - H u) * ((sinhKernel u : ℝ) : ℂ) := by
    rw [← integral_const_mul, ← integral_sub hGi (hHi.const_mul a)]
    refine integral_congr_ae (.of_forall fun u => ?_)
    ring
  rw [WeilR_deltaHalfInv_ofLog_value hKc hKLip, WeilR_deltaHalfInv_ofLog_value hGc hLipG,
    WeilR_deltaHalfInv_ofLog_value hHc hLipH, hsplit]
  ring

/-! ## 3. Lipschitz transcription in the logarithmic coordinate -/

/-- If `f` is Lipschitz at `λ = 1` relative to its value there, then its logarithmic
transcription is Lipschitz at `u = 0` relative to its value there. -/
theorem exists_logTest_lipschitz_sub (f : C_c(Rplus, ℂ)) {C : ℝ}
    (hf : ∀ lam : Rplus, ‖f lam - f 1‖ ≤ C * |1 - (lam : ℝ)|) :
    ∃ C' : ℝ, ∀ u : ℝ, ‖logTest f u - logTest f 0‖ ≤ C' * |u| := by
  obtain ⟨M, hM⟩ :=
    (hasCompactSupport_logTest f).exists_bound_of_continuous (continuous_logTest f)
  refine ⟨max (max C 0 * Real.exp 1) (M + ‖f 1‖), fun u => ?_⟩
  have hC0 : (0:ℝ) ≤ max C 0 := le_max_right _ _
  have hM0 : (0:ℝ) ≤ M := le_trans (norm_nonneg _) (hM 0)
  have hbig : (0:ℝ) ≤ max (max C 0 * Real.exp 1) (M + ‖f 1‖) := by
    refine le_trans ?_ (le_max_right _ _)
    positivity
  rw [logTest_apply_zero]
  rcases le_or_gt |u| 1 with hu | hu
  · have h1 : ‖logTest f u - f 1‖ ≤ max C 0 * |1 - Real.exp u| := by
      have h := hf (Rplus.expHomeo u)
      have hcoe : ((Rplus.expHomeo u : Rplus) : ℝ) = Real.exp u := rfl
      rw [hcoe] at h
      refine le_trans h (mul_le_mul_of_nonneg_right (le_max_left _ _) (abs_nonneg _))
    refine le_trans h1 ?_
    have h2 : |1 - Real.exp u| ≤ |u| * Real.exp 1 :=
      le_trans (abs_one_sub_exp_le u)
        (mul_le_mul_of_nonneg_left (Real.exp_le_exp.2 hu) (abs_nonneg u))
    calc max C 0 * |1 - Real.exp u| ≤ max C 0 * (|u| * Real.exp 1) :=
          mul_le_mul_of_nonneg_left h2 hC0
      _ = max C 0 * Real.exp 1 * |u| := by ring
      _ ≤ max (max C 0 * Real.exp 1) (M + ‖f 1‖) * |u| :=
          mul_le_mul_of_nonneg_right (le_max_left _ _) (abs_nonneg u)
  · have h1 : ‖logTest f u - f 1‖ ≤ M + ‖f 1‖ :=
      le_trans (norm_sub_le _ _) (by gcongr; exact hM u)
    refine le_trans h1 ?_
    calc M + ‖f 1‖ ≤ max (max C 0 * Real.exp 1) (M + ‖f 1‖) := le_max_right _ _
      _ = max (max C 0 * Real.exp 1) (M + ‖f 1‖) * 1 := by ring
      _ ≤ max (max C 0 * Real.exp 1) (M + ‖f 1‖) * |u| := by
          exact mul_le_mul_of_nonneg_left hu.le hbig

/-- The logarithmic transcription of `f - f(1) • h`. -/
theorem logTest_sub_smul (f h : C_c(Rplus, ℂ)) :
    logTest (f - f 1 • h) = fun u => logTest f u - f 1 * logTest h u := by
  funext u
  simp [logTest]

/-! ## 4. The full asymptotic expansion -/

/-- **The finite part of the renormalized cut-off trace is the archimedean Weil
distribution.**

Assume that a *single* reference test function `h` with `h(1) = 1`, Lipschitz at `1`, has a
logarithmic profile `Tr(ϑ(h) S^{(Λ)}) = c log Λ + z₀ + o(1)`.  Then there is a *universal*
constant `z₁` such that **every** test function `f` which is Lipschitz at `1` satisfies the
complete asymptotic expansion

  `Tr(ϑ(f) S^{(Λ)}) = f(1) · c · log Λ + [W_ℝ(∆^{-1/2} F) + E(F) + f(1) z₁] + o(1)`,

with `F = logTest f`, `W_ℝ` the archimedean Weil distribution and `E` the pairing against the
reflected (odd-part) kernel.  In particular the whole `f`-dependence of the finite part is
the Weil distribution: only the two scalars `c, z₁` remain unidentified. -/
theorem exists_universal_finitePart [Countable ι] (b : HilbertBasis ι ℂ L2R)
    {h : C_c(Rplus, ℂ)} {c z₀ : ℂ} (hprof : HasCutoffLogProfile b h c z₀)
    (hh1 : h 1 = 1) {Ch : ℝ} (hhLip : ∀ lam : Rplus, ‖h lam - h 1‖ ≤ Ch * |1 - (lam : ℝ)|) :
    ∃ z₁ : ℂ, ∀ (f : C_c(Rplus, ℂ)) (C : ℝ),
      (∀ lam : Rplus, ‖f lam - f 1‖ ≤ C * |1 - (lam : ℝ)|) →
      Tendsto (fun cut : ℝ => modelCutTrace b cut f - f 1 * c * (Real.log cut : ℂ)) atTop
        (𝓝 (WeilR (deltaHalfInv (ofLog (logTest f))) + reflectionPairingReg (logTest f)
              + f 1 * z₁)) := by
  set H : ℝ → ℂ := logTest h with hHdef
  have hHc : Continuous H := continuous_logTest h
  obtain ⟨CH, hHLip⟩ := exists_logTest_lipschitz_sub h hhLip
  have hHLip' : ∀ u : ℝ, ‖H u - H 0‖ ≤ CH * |u| := hHLip
  refine ⟨z₀ - (WeilR (deltaHalfInv (ofLog H)) + reflectionPairingReg H), ?_⟩
  intro f C hfLip
  set G : ℝ → ℂ := logTest f with hGdef
  have hGc : Continuous G := continuous_logTest f
  obtain ⟨CG, hGLip⟩ := exists_logTest_lipschitz_sub f hfLip
  have hGLip' : ∀ u : ℝ, ‖G u - G 0‖ ≤ CG * |u| := hGLip
  -- the deviation `f - f(1) h` vanishes at `1` at a Lipschitz rate
  have hdev : ∀ lam : Rplus, ‖f lam - f 1 * h lam‖ ≤ (C + ‖f 1‖ * Ch) * |1 - (lam : ℝ)| := by
    intro lam
    have hrw : f lam - f 1 * h lam = (f lam - f 1) - f 1 * (h lam - h 1) := by
      rw [hh1]; ring
    calc ‖f lam - f 1 * h lam‖
        = ‖(f lam - f 1) - f 1 * (h lam - h 1)‖ := by rw [hrw]
      _ ≤ ‖f lam - f 1‖ + ‖f 1 * (h lam - h 1)‖ := norm_sub_le _ _
      _ ≤ C * |1 - (lam : ℝ)| + ‖f 1‖ * (Ch * |1 - (lam : ℝ)|) := by
          gcongr
          · exact hfLip lam
          · rw [norm_mul]
            exact mul_le_mul_of_nonneg_left (hhLip lam) (norm_nonneg _)
      _ = (C + ‖f 1‖ * Ch) * |1 - (lam : ℝ)| := by ring
  have hmain := hasFinitePart_of_reference b hprof f hdev
  -- identify the pairing of the deviation
  have hlip0 : ∀ lam : Rplus, ‖(f - f 1 • h) lam‖ ≤ (C + ‖f 1‖ * Ch) * |1 - (lam : ℝ)| := by
    intro lam; simpa using hdev lam
  have hpair := weilPairing_eq_weilR_add_reflectionPairing (f - f 1 • h) hlip0
  have hK : logTest (f - f 1 • h) = fun u => G u - f 1 * H u := logTest_sub_smul f h
  have hK0 : (fun u => G u - f 1 * H u) 0 = 0 := by
    have : G 0 = f 1 := logTest_apply_zero f
    have h2 : H 0 = h 1 := logTest_apply_zero h
    show G 0 - f 1 * H 0 = 0
    rw [this, h2, hh1]
    ring
  rw [hK] at hpair
  rw [← reflectionPairingReg_of_apply_zero hK0] at hpair
  rw [weilR_ofLog_sub_smul hGc hHc hGLip' hHLip' (f 1),
    reflectionPairingReg_sub_smul hGc hHc hGLip' hHLip' (f 1)] at hpair
  rw [hpair] at hmain
  convert hmain using 2
  ring

end ConnesConsani.WeilPositivity
