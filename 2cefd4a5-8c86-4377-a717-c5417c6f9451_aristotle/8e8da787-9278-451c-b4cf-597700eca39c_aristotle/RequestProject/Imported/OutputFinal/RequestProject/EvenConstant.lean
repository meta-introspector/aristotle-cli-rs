/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
Authors: Formalization of
  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771

**The universal constant of the even (Sonin) renormalized trace formula.**

`RequestProject/EvenCutoffTrace.lean` proves that

  `Tr(ϑ(f) S^{(Λ)} P_ev) - 2 f(1) log Λ  ⟶  W_ℝ(∆^{-1/2} F) + f(1) z_ev`

for a *universal* constant `z_ev`.  This file evaluates that constant:

  `z_ev = 2 K / π - γ`,

where `γ` is Euler's constant and `K = ∫_0^1 Si(s) ds/s + ∫_1^∞ (Si s - π/2) ds/s` is the
finite part of `∫_0^X Si(s) ds/s` relative to `(π/2) log X` (`siLogConst`).

All the contributions cancel except these two:

* the logarithmic profile of the reference bump contributes `thetaAVal + (4/π)(K - π/2)
  + 2 log(2π)`;
* the archimedean Weil functional of the reference bump contributes `- c₀ + J` with
  `c₀ = log(4π) + γ + log 2 + π/2` and `J = triJVal`;
* the even projection contributes the extra `(π - c₀)/2`;

and `thetaAVal + J = 4 log 2 + 2` (`RequestProject/EvenConstantAux.lean`) makes all the
elementary constants cancel.
-/
import RequestProject.Imported.OutputFinal.RequestProject.EvenConstantAux
import RequestProject.Imported.OutputFinal.RequestProject.EvenCutoffTrace

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory Filter Topology Set Real

open scoped CompactlySupported

namespace ConnesConsani.WeilPositivity

variable {ι : Type*}

/-! ## 1. The full-line finite part with an explicit constant -/

/-- The value form of `exists_universal_finitePart`: the universal constant is
`z₀ - (W_ℝ(∆^{-1/2} H) + E(H))` for the reference function `h`, with `H = logTest h`. -/
theorem universal_finitePart_value [Countable ι] (b : HilbertBasis ι ℂ L2R)
    {h : C_c(Rplus, ℂ)} {c z₀ : ℂ} (hprof : HasCutoffLogProfile b h c z₀)
    (hh1 : h 1 = 1) {Ch : ℝ} (hhLip : ∀ lam : Rplus, ‖h lam - h 1‖ ≤ Ch * |1 - (lam : ℝ)|)
    (f : C_c(Rplus, ℂ)) (C : ℝ)
    (hfLip : ∀ lam : Rplus, ‖f lam - f 1‖ ≤ C * |1 - (lam : ℝ)|) :
    Tendsto (fun cut : ℝ => modelCutTrace b cut f - f 1 * c * (Real.log cut : ℂ)) atTop
      (𝓝 (WeilR (deltaHalfInv (ofLog (logTest f))) + reflectionPairingReg (logTest f)
            + f 1 * (z₀ - (WeilR (deltaHalfInv (ofLog (logTest h)))
                + reflectionPairingReg (logTest h))))) := by
  set H : ℝ → ℂ := logTest h with hHdef
  have hHc : Continuous H := continuous_logTest h
  obtain ⟨CH, hHLip⟩ := exists_logTest_lipschitz_sub h hhLip
  have hHLip' : ∀ u : ℝ, ‖H u - H 0‖ ≤ CH * |u| := hHLip
  set G : ℝ → ℂ := logTest f with hGdef
  have hGc : Continuous G := continuous_logTest f
  obtain ⟨CG, hGLip⟩ := exists_logTest_lipschitz_sub f hfLip
  have hGLip' : ∀ u : ℝ, ‖G u - G 0‖ ≤ CG * |u| := hGLip
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
  have hlip0 : ∀ lam : Rplus, ‖(f - f 1 • h) lam‖ ≤ (C + ‖f 1‖ * Ch) * |1 - (lam : ℝ)| := by
    intro lam; simpa using hdev lam
  have hpair := weilPairing_eq_weilR_add_reflectionPairing (f - f 1 • h) hlip0
  have hK : logTest (f - f 1 • h) = fun u => G u - f 1 * H u := logTest_sub_smul f h
  have hK0 : (fun u => G u - f 1 * H u) 0 = 0 := by
    have h1 : G 0 = f 1 := logTest_apply_zero f
    have h2 : H 0 = h 1 := logTest_apply_zero h
    show G 0 - f 1 * H 0 = 0
    rw [h1, h2, hh1]
    ring
  rw [hK] at hpair
  rw [← reflectionPairingReg_of_apply_zero hK0] at hpair
  rw [weilR_ofLog_sub_smul hGc hHc hGLip' hHLip' (f 1),
    reflectionPairingReg_sub_smul hGc hHc hGLip' hHLip' (f 1)] at hpair
  rw [hpair] at hmain
  convert hmain using 2
  ring

/-! ## 2. The reference bump: the Weil functional and the reflection term -/

theorem logTest_refBump : logTest refBump = triC 1 := logTest_logBump one_pos

theorem exists_triC_one_lipschitz : ∃ C' : ℝ, ∀ u : ℝ, ‖triC 1 u - triC 1 0‖ ≤ C' * |u| := by
  obtain ⟨C', hC'⟩ := exists_logTest_lipschitz_sub refBump refBump_lipschitz
  refine ⟨C', fun u => ?_⟩
  have h := hC' u
  rwa [logTest_refBump] at h

/-- The pairing of the reference bump with the full archimedean kernel, in complex form. -/
theorem weilR_add_reflectionPairingReg_refBump :
    WeilR (deltaHalfInv (ofLog (triC 1))) + reflectionPairingReg (triC 1)
      = ((weilConst : ℝ) : ℂ) - ((triJVal : ℝ) : ℂ) := by
  obtain ⟨C', hLip⟩ := exists_triC_one_lipschitz
  have hcont : Continuous (triC 1) := continuous_triC 1
  have h0 : triC 1 0 = 1 := triC_zero 1
  have hW := WeilR_deltaHalfInv_ofLog_value (G := triC 1) hcont hLip
  have hSc : Integrable (fun u : ℝ => (triC 1 0 - triC 1 u) * ((sinhKernel u : ℝ) : ℂ)) :=
    integrable_sub_mul_sinhKernel hcont hLip
  have hRc : Integrable (fun u : ℝ => (triC 1 0 - triC 1 u) * ((sinhKernelRefl u : ℝ) : ℂ)) :=
    integrable_sub_mul_sinhKernelRefl hcont hLip
  set S : ℂ := ∫ u : ℝ, (triC 1 0 - triC 1 u) * ((sinhKernel u : ℝ) : ℂ) with hSdef
  set R : ℂ := ∫ u : ℝ, (triC 1 0 - triC 1 u) * ((sinhKernelRefl u : ℝ) : ℂ) with hRdef
  have hsum : S + R = ((triJVal : ℝ) : ℂ) := by
    rw [hSdef, hRdef, ← integral_add hSc hRc, triJVal, ← integral_complex_ofReal]
    refine integral_congr_ae (.of_forall fun u => ?_)
    have hv : triC 1 0 - triC 1 u = (((1 - triReal 1 u : ℝ)) : ℂ) := by
      rw [h0, triC]
      push_cast
      ring
    show (triC 1 0 - triC 1 u) * ((sinhKernel u : ℝ) : ℂ)
        + (triC 1 0 - triC 1 u) * ((sinhKernelRefl u : ℝ) : ℂ)
      = (((1 - triReal 1 u) * (sinhKernel u + sinhKernelRefl u) : ℝ) : ℂ)
    rw [hv]
    push_cast
    ring
  have hE : reflectionPairingReg (triC 1) = -R := rfl
  have hSval : S = ((triJVal : ℝ) : ℂ) - R := by linear_combination hsum
  rw [hW, hE, h0, mul_one, hSval]
  ring

/-! ## 3. The arithmetic of the constants -/

/-- The value of the even universal constant: `z_ev = 2K/π - γ`. -/
def zEvenVal : ℝ := 2 * siLogConst / π - Real.eulerMascheroniConstant

theorem zRef_add_triJVal_value :
    zRef + triJVal - 2 * weilConst + π = 2 * zEvenVal := by
  have hA := thetaAVal_add_triJVal
  have hpi : (π:ℝ) ≠ 0 := Real.pi_ne_zero
  have hc : 4 / π * (siLogConst - π / 2) = 2 * (2 * siLogConst / π) - 2 := by
    field_simp
    ring
  have hlog2pi : Real.log (2 * π) = Real.log 2 + Real.log π :=
    Real.log_mul two_ne_zero hpi
  have hlog4pi : Real.log (4 * π) = 2 * Real.log 2 + Real.log π := by
    rw [Real.log_mul (by norm_num) hpi, show (4:ℝ) = 2 ^ 2 by norm_num, Real.log_pow]
    push_cast
    ring
  rw [zRef, hc, hlog2pi, weilConst, hlog4pi, zEvenVal]
  linarith [hA]

/-! ## 4. The even finite part with the constant evaluated -/

/-- **The even (Sonin) renormalized trace formula with the universal constant evaluated.**

For every compactly supported continuous `f` on `ℝ⋆₊` which is Lipschitz at `λ = 1`,

  `Tr(ϑ(f) S^{(Λ)} P_ev) - 2 f(1) log Λ  ⟶  W_ℝ(∆^{-1/2} F) + f(1) (2K/π - γ)`,

with `F = logTest f` and `K = siLogConst`.  The logarithmic coefficient is exactly `2 f(1)`,
and the only remaining constant is the completely explicit `zEvenVal = 2K/π - γ`. -/
theorem even_finitePart_value [Countable ι] (b : HilbertBasis ι ℂ L2R)
    (f : C_c(Rplus, ℂ)) (C : ℝ)
    (hf : ∀ lam : Rplus, ‖f lam - f 1‖ ≤ C * |1 - (lam : ℝ)|) :
    Tendsto (fun cut : ℝ => evenModelCutTrace b cut f - f 1 * 2 * (Real.log cut : ℂ)) atTop
      (𝓝 (WeilR (deltaHalfInv (ofLog (logTest f))) + f 1 * ((zEvenVal : ℝ) : ℂ))) := by
  have hfull := universal_finitePart_value b (hasCutoffLogProfile_refBump b) refBump_one
    refBump_lipschitz f C hf
  rw [logTest_refBump, weilR_add_reflectionPairingReg_refBump] at hfull
  have hrefl := tendsto_reflModelCutTrace f
  have hsum := (hfull.add hrefl).const_mul (2⁻¹ : ℂ)
  rw [coshPairing_eq_weilR_sub f hf] at hsum
  have hconst : (2⁻¹ : ℂ) * (((zRef : ℝ) : ℂ) - (((weilConst : ℝ) : ℂ) - ((triJVal : ℝ) : ℂ))
      + ((π - weilConst : ℝ) : ℂ)) = ((zEvenVal : ℝ) : ℂ) := by
    have hC : ((zRef + triJVal - 2 * weilConst + π : ℝ) : ℂ) = ((2 * zEvenVal : ℝ) : ℂ) := by
      exact_mod_cast congrArg (fun x : ℝ => (x : ℂ)) zRef_add_triJVal_value
    push_cast at hC ⊢
    linear_combination hC / 2
  have hval : (2⁻¹ : ℂ) * ((WeilR (deltaHalfInv (ofLog (logTest f)))
        + reflectionPairingReg (logTest f)
        + f 1 * (((zRef : ℝ) : ℂ) - (((weilConst : ℝ) : ℂ) - ((triJVal : ℝ) : ℂ))))
      + (WeilR (deltaHalfInv (ofLog (logTest f))) - reflectionPairingReg (logTest f)
        + f 1 * ((π - weilConst : ℝ) : ℂ)))
      = WeilR (deltaHalfInv (ofLog (logTest f)))
        + f 1 * ((2⁻¹ : ℂ) * (((zRef : ℝ) : ℂ) - (((weilConst : ℝ) : ℂ) - ((triJVal : ℝ) : ℂ))
            + ((π - weilConst : ℝ) : ℂ))) := by ring
  rw [hval, hconst] at hsum
  refine hsum.congr' ?_
  filter_upwards [eventually_ge_atTop (0:ℝ)] with cut hcut
  rw [evenModelCutTrace_eq_half b hcut f]
  ring

/-- **The even finite part in terms of `L_Norm`**, with the constant evaluated. -/
theorem even_finitePart_value_LfunNorm [Countable ι] (b : HilbertBasis ι ℂ L2R)
    (f : C_c(Rplus, ℂ)) (C : ℝ)
    (hf : ∀ lam : Rplus, ‖f lam - f 1‖ ≤ C * |1 - (lam : ℝ)|) :
    Tendsto (fun cut : ℝ => evenModelCutTrace b cut f - f 1 * 2 * (Real.log cut : ℂ)) atTop
      (𝓝 (Dcomplex (ofLog (logTest f)) - LfunNorm (logTest f)
            + f 1 * ((zEvenVal : ℝ) : ℂ))) := by
  have h := even_finitePart_value b f C hf
  rwa [weilR_eq_sub_LfunNorm] at h

end ConnesConsani.WeilPositivity
