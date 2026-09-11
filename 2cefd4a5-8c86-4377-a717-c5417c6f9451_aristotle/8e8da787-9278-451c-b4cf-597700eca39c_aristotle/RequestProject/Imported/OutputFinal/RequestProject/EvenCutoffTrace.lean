/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
Authors: Formalization of
  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771

**The renormalized cut-off trace on the even (Sonin) subspace.**

`RequestProject/EvenSemiLocalKernel.lean` computes the semi-local trace density of the
cut-off Sonin sandwich on the even subspace `L²(ℝ)_ev` of the paper,

  `Tr(ϑ(λ) S^{(Λ)} P_ev) = ½ [ κ_Λ(λ) + κ^{refl}_Λ(λ) ]`,

where `κ_Λ` is the full-line density (whose `Λ → ∞` limit is `λ^{1/2}/|1-λ|`) and
`κ^{refl}_Λ(λ) = √a (2/(π(a+1))) Si(2π(a+1)Λ²/max(1,a))`, `a = λ⁻¹`, is the *regular*
reflected density, with limit `λ^{1/2}/(1+λ)`.

This file draws the two consequences announced in the paper's normalisation.

* **The logarithmic coefficient is `2 f(1)`, not `4 f(1)`.**  The reflected density is
  bounded uniformly in `Λ` (no singularity at `λ = 1`), so it contributes no divergence:
  the whole `log Λ` divergence is half of the full-line one.

* **The finite part is exactly the archimedean Weil distribution.**  In the logarithmic
  coordinate the even limiting kernel is

    `½ (1/(2 sinh(|u|/2)) + 1/(2 cosh(u/2))) = e^{|u|/2}/(e^{|u|} - e^{-|u|}) = sinhKernel u`,

  the kernel of `W_ℝ`: the odd-part contribution `E(F) = reflectionPairingReg F`, which was
  present in the full-line model, **cancels exactly**.  Hence

    `Tr(ϑ(f) S^{(Λ)} P_ev) - 2 f(1) log Λ  ⟶  W_ℝ(∆^{-1/2} F) + f(1) z_ev`
      `= D(F) - L_Norm(F) + f(1) z_ev`,

  with a single universal constant `z_ev` multiplying the local value `f(1)`
  (`exists_universal_even_finitePart`, `exists_universal_even_finitePart_LfunNorm`).

The value of `z_ev` is computed in `RequestProject/EvenConstant.lean`.
-/
import RequestProject.Imported.OutputFinal.RequestProject.EvenSemiLocalKernel
import RequestProject.Imported.OutputFinal.RequestProject.CutoffLogProfile

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory Filter Topology Set Real

open scoped CompactlySupported

namespace ConnesConsani.WeilPositivity

variable {ι : Type*}

/-! ## 1. The reflected density -/

/-- **The reflected part of the even semi-local density**,
`√a (2/(π(a+1))) Si(2π(a+1) Λ²/max(1,a))`.  Contrary to the full-line density it is regular
at `a = 1`, and bounded uniformly in the cut-off. -/
def reflDensityVal (cut : ℝ) (a : Rplus) : ℝ :=
  Real.sqrt (a : ℝ) * (2 / (π * ((a : ℝ) + 1))) *
    Si (2 * π * ((a : ℝ) + 1) * (cut / max 1 (a : ℝ)) * cut)

/-- **The even density is the half-sum of the full-line density and the reflected one.** -/
theorem evenSemiLocalDensity_eq_half [Countable ι] (b : HilbertBasis ι ℂ L2R) {cut : ℝ}
    (hcut : 0 ≤ cut) (a : Rplus) (ha : (a : ℝ) ≠ 1) :
    evenSemiLocalDensity b cut a
      = 2⁻¹ * (semiLocalDensity b cut a + ((reflDensityVal cut a : ℝ) : ℂ)) := by
  rw [evenSemiLocalDensity_eq_Si b hcut a ha, semiLocalDensity_eq_Si b hcut a ha, reflDensityVal]
  push_cast
  ring

theorem two_sqrt_le_one_add (a : ℝ) (ha : 0 ≤ a) : 2 * Real.sqrt a ≤ 1 + a := by
  nlinarith [sq_nonneg (Real.sqrt a - 1), Real.sq_sqrt ha, Real.sqrt_nonneg a]

/-- **The reflected density is bounded uniformly in the cut-off**: `|κ^{refl}_Λ(a)| ≤ Si(π)/π`. -/
theorem abs_reflDensityVal_le (cut : ℝ) (a : Rplus) : |reflDensityVal cut a| ≤ Si π / π := by
  have ha0 : (0:ℝ) < (a : ℝ) := a.2
  have hpi : (0:ℝ) < π := Real.pi_pos
  have hsi : 0 ≤ Si π := le_trans (abs_nonneg _) (abs_Si_le_Si_pi π)
  have hfac : Real.sqrt (a : ℝ) * (2 / (π * ((a : ℝ) + 1))) ≤ 1 / π := by
    have h := two_sqrt_le_one_add (a : ℝ) ha0.le
    have hden : (0:ℝ) < π * ((a : ℝ) + 1) := by positivity
    rw [mul_div_assoc', div_le_div_iff₀ hden hpi]
    nlinarith [Real.sqrt_nonneg (a : ℝ)]
  have hfac0 : 0 ≤ Real.sqrt (a : ℝ) * (2 / (π * ((a : ℝ) + 1))) := by positivity
  rw [reflDensityVal, abs_mul, abs_of_nonneg hfac0]
  calc Real.sqrt (a : ℝ) * (2 / (π * ((a : ℝ) + 1))) *
        |Si (2 * π * ((a : ℝ) + 1) * (cut / max 1 (a : ℝ)) * cut)|
      ≤ (1 / π) * Si π := by
        refine mul_le_mul hfac (abs_Si_le_Si_pi _) (abs_nonneg _) (by positivity)
    _ = Si π / π := by ring

/-- **The reflected density converges to the regular kernel `√a/(1+a)`.** -/
theorem tendsto_reflDensityVal (a : Rplus) :
    Tendsto (fun cut : ℝ => reflDensityVal cut a) atTop
      (𝓝 (Real.sqrt (a : ℝ) / (1 + (a : ℝ)))) := by
  have ha0 : (0:ℝ) < (a : ℝ) := a.2
  have hmax : (0:ℝ) < max 1 (a : ℝ) := lt_of_lt_of_le zero_lt_one (le_max_left _ _)
  set c : ℝ := 2 * π * ((a : ℝ) + 1) / max 1 (a : ℝ) with hc
  have hcpos : 0 < c := by
    rw [hc]
    exact div_pos (by positivity) hmax
  have hsq : Tendsto (fun cut : ℝ => cut ^ 2) atTop atTop := tendsto_pow_atTop (by norm_num)
  have h1 : Tendsto (fun cut : ℝ => c * cut ^ 2) atTop atTop := Tendsto.const_mul_atTop hcpos hsq
  have h2 := (tendsto_Si_atTop.comp h1).const_mul
    (Real.sqrt (a : ℝ) * (2 / (π * ((a : ℝ) + 1))))
  have hval : Real.sqrt (a : ℝ) * (2 / (π * ((a : ℝ) + 1))) * (π / 2)
      = Real.sqrt (a : ℝ) / (1 + (a : ℝ)) := by
    have hpi : (π:ℝ) ≠ 0 := Real.pi_ne_zero
    have h : ((a : ℝ) + 1) ≠ 0 := by positivity
    field_simp
    ring
  rw [hval] at h2
  refine h2.congr' ?_
  filter_upwards [eventually_ge_atTop (0:ℝ)] with cut _
  rw [reflDensityVal]
  simp only [Function.comp_apply]
  congr 2
  rw [hc]
  field_simp

theorem continuous_reflDensityVal (cut : ℝ) : Continuous (fun a : Rplus => reflDensityVal cut a) := by
  have hval : Continuous fun a : Rplus => (a : ℝ) := continuous_subtype_val
  have hpos : ∀ a : Rplus, ((a : ℝ) + 1) ≠ 0 := fun a => by have := a.2; positivity
  refine Continuous.mul (Continuous.mul (Real.continuous_sqrt.comp hval) ?_) ?_
  · exact continuous_const.div (continuous_const.mul (hval.add continuous_const))
      (fun a => by have := hpos a; positivity)
  · refine Si_continuous.comp (Continuous.mul (Continuous.mul ?_ ?_) continuous_const)
    · exact continuous_const.mul (hval.add continuous_const)
    · exact continuous_const.div (continuous_const.max hval)
        (fun a => ne_of_gt (lt_of_lt_of_le zero_lt_one (le_max_left _ _)))

/-! ## 2. The reflected kernel in the scaling variable -/

/-- **The regular part of the even limiting kernel**, `λ^{1/2}/(1+λ)`.  It is the trace
density on `ℝ⋆₋`-side of the archimedean Weil term: `|1-λ| = 1+|λ|` for negative `λ`. -/
def coshKernelRplus (lam : Rplus) : ℝ := Real.sqrt (lam : ℝ) / (1 + (lam : ℝ))

theorem coshKernelRplus_nonneg (lam : Rplus) : 0 ≤ coshKernelRplus lam := by
  have h := lam.2
  exact div_nonneg (Real.sqrt_nonneg _) (by linarith)

/-- The reflected density in the paper's scaling variable, `κ^{refl}_Λ(λ)`. -/
def reflScalingVal (cut : ℝ) (lam : Rplus) : ℝ := reflDensityVal cut lam⁻¹

theorem abs_reflScalingVal_le (cut : ℝ) (lam : Rplus) : |reflScalingVal cut lam| ≤ Si π / π :=
  abs_reflDensityVal_le cut lam⁻¹

theorem continuous_reflScalingVal (cut : ℝ) : Continuous (reflScalingVal cut) :=
  (continuous_reflDensityVal cut).comp (continuous_inv)

theorem sqrt_inv_div_one_add (lam : Rplus) :
    Real.sqrt ((lam : ℝ)⁻¹) / (1 + (lam : ℝ)⁻¹) = coshKernelRplus lam := by
  have hl : (0:ℝ) < (lam : ℝ) := lam.2
  have hs : (0:ℝ) < Real.sqrt (lam : ℝ) := Real.sqrt_pos.2 hl
  rw [coshKernelRplus, Real.sqrt_inv]
  rw [div_eq_div_iff (by positivity) (by positivity)]
  have hsq : Real.sqrt (lam : ℝ) ^ 2 = (lam : ℝ) := Real.sq_sqrt hl.le
  field_simp
  nlinarith [hsq]

theorem tendsto_reflScalingVal (lam : Rplus) :
    Tendsto (fun cut : ℝ => reflScalingVal cut lam) atTop (𝓝 (coshKernelRplus lam)) := by
  have h := tendsto_reflDensityVal lam⁻¹
  have hinv : ((lam⁻¹ : Rplus) : ℝ) = (lam : ℝ)⁻¹ := rfl
  rw [hinv, sqrt_inv_div_one_add lam] at h
  exact h

/-! ## 3. The even cut-off trace -/

/-- The even semi-local density in the paper's scaling variable, `Tr(ϑ(λ) S^{(Λ)} P_ev)`. -/
def evenScalingDensity (b : HilbertBasis ι ℂ L2R) (cut : ℝ) (lam : Rplus) : ℂ :=
  evenSemiLocalDensity b cut lam⁻¹

/-- **The even cut-off trace** `Tr(ϑ(f) S^{(Λ)} P_ev)`. -/
def evenModelCutTrace (b : HilbertBasis ι ℂ L2R) (cut : ℝ) (g : C_c(Rplus, ℂ)) : ℂ :=
  ∫ lam, g lam * evenScalingDensity b cut lam ∂(Rplus.haar)

/-- The reflected cut-off trace. -/
def reflModelCutTrace (cut : ℝ) (g : C_c(Rplus, ℂ)) : ℂ :=
  ∫ lam, g lam * ((reflScalingVal cut lam : ℝ) : ℂ) ∂(Rplus.haar)

/-- The pairing of a test function with the regular kernel `λ^{1/2}/(1+λ)`. -/
def coshPairing (g : C_c(Rplus, ℂ)) : ℂ :=
  ∫ lam, g lam * ((coshKernelRplus lam : ℝ) : ℂ) ∂(Rplus.haar)

theorem integrable_mul_reflScalingVal (cut : ℝ) (g : C_c(Rplus, ℂ)) :
    Integrable (fun lam : Rplus => g lam * ((reflScalingVal cut lam : ℝ) : ℂ)) Rplus.haar := by
  refine Integrable.mono' ((integrable_norm g).mul_const (Si π / π)) ?_ (.of_forall fun lam => ?_)
  · exact (map_continuous g).measurable.aestronglyMeasurable.mul
      ((Complex.continuous_ofReal.comp (continuous_reflScalingVal cut)).measurable).aestronglyMeasurable
  · rw [norm_mul, Complex.norm_real, Real.norm_eq_abs]
    exact mul_le_mul_of_nonneg_left (abs_reflScalingVal_le cut lam) (norm_nonneg _)

theorem integrable_mul_coshKernelRplus (g : C_c(Rplus, ℂ)) :
    Integrable (fun lam : Rplus => g lam * ((coshKernelRplus lam : ℝ) : ℂ)) Rplus.haar := by
  have hcont : Continuous coshKernelRplus := by
    refine Continuous.div (Real.continuous_sqrt.comp continuous_subtype_val)
      (continuous_const.add continuous_subtype_val) (fun lam => ?_)
    have := lam.2
    positivity
  refine Integrable.mono' ((integrable_norm g).mul_const (1 / 2)) ?_ (.of_forall fun lam => ?_)
  · exact (map_continuous g).measurable.aestronglyMeasurable.mul
      ((Complex.continuous_ofReal.comp hcont).measurable).aestronglyMeasurable
  · have hl : (0:ℝ) < (lam : ℝ) := lam.2
    have hle : coshKernelRplus lam ≤ 1 / 2 := by
      rw [coshKernelRplus, div_le_div_iff₀ (by positivity) (by norm_num)]
      nlinarith [two_sqrt_le_one_add (lam : ℝ) hl.le]
    rw [norm_mul, Complex.norm_real, Real.norm_eq_abs,
      abs_of_nonneg (coshKernelRplus_nonneg lam)]
    exact mul_le_mul_of_nonneg_left hle (norm_nonneg _)

/-- **The even cut-off trace is the half-sum of the full-line trace and the reflected one.** -/
theorem evenModelCutTrace_eq_half [Countable ι] (b : HilbertBasis ι ℂ L2R) {cut : ℝ}
    (hcut : 0 ≤ cut) (g : C_c(Rplus, ℂ)) :
    evenModelCutTrace b cut g = 2⁻¹ * (modelCutTrace b cut g + reflModelCutTrace cut g) := by
  rw [evenModelCutTrace, modelCutTrace, reflModelCutTrace,
    ← integral_add (integrable_mul_scalingDensity b hcut g) (integrable_mul_reflScalingVal cut g),
    ← integral_const_mul]
  refine integral_congr_ae ?_
  filter_upwards [ae_ne_one] with lam hlam
  have hne : ((lam⁻¹ : Rplus) : ℝ) ≠ 1 := by
    show (lam : ℝ)⁻¹ ≠ 1
    intro h
    exact hlam (inv_eq_one.1 h)
  rw [evenScalingDensity, evenSemiLocalDensity_eq_half b hcut lam⁻¹ hne]
  show _ = 2⁻¹ * (g lam * scalingDensity b cut lam + g lam * ((reflScalingVal cut lam : ℝ) : ℂ))
  rw [scalingDensity, reflScalingVal]
  ring

/-- **The reflected cut-off trace converges**, with no renormalization, to the pairing with
the regular kernel `λ^{1/2}/(1+λ)`. -/
theorem tendsto_reflModelCutTrace (g : C_c(Rplus, ℂ)) :
    Tendsto (fun cut : ℝ => reflModelCutTrace cut g) atTop (𝓝 (coshPairing g)) := by
  refine MeasureTheory.tendsto_integral_filter_of_dominated_convergence
    (fun lam : Rplus => ‖g lam‖ * (Si π / π)) ?_ ?_ ((integrable_norm g).mul_const _) ?_
  · refine .of_forall fun cut => ?_
    exact (map_continuous g).measurable.aestronglyMeasurable.mul
      ((Complex.continuous_ofReal.comp (continuous_reflScalingVal cut)).measurable).aestronglyMeasurable
  · refine .of_forall fun cut => .of_forall fun lam => ?_
    rw [norm_mul, Complex.norm_real, Real.norm_eq_abs]
    exact mul_le_mul_of_nonneg_left (abs_reflScalingVal_le cut lam) (norm_nonneg _)
  · refine .of_forall fun lam => ?_
    exact ((Complex.continuous_ofReal.tendsto _).comp (tendsto_reflScalingVal lam)).const_mul
      (g lam)

/-! ## 4. The even kernel in the logarithmic coordinate -/

/-- The regular kernel in the logarithmic coordinate: `e^{u/2}/(1+e^u) = 1/(2 cosh(u/2))`. -/
def coshKernelLog (u : ℝ) : ℝ := Real.exp (u / 2) / (1 + Real.exp u)

theorem coshKernelLog_pos (u : ℝ) : 0 < coshKernelLog u := by
  rw [coshKernelLog]
  have h1 : 0 < Real.exp (u / 2) := Real.exp_pos _
  have h2 : 0 < 1 + Real.exp u := by positivity
  positivity

theorem coshKernelLog_even (u : ℝ) : coshKernelLog (-u) = coshKernelLog u := by
  have hpos : 0 < Real.exp u := Real.exp_pos u
  rw [coshKernelLog, coshKernelLog, show -u / 2 = -(u / 2) by ring, Real.exp_neg, Real.exp_neg,
    show Real.exp (u / 2) = Real.exp (u / 2) from rfl]
  have h2 : Real.exp (u / 2) * Real.exp (u / 2) = Real.exp u := by
    rw [← Real.exp_add]; ring_nf
  have h3 : (0:ℝ) < Real.exp (u / 2) := Real.exp_pos _
  rw [div_eq_div_iff (by positivity) (by positivity)]
  field_simp
  nlinarith [h2]

theorem continuous_coshKernelLog : Continuous coshKernelLog := by
  refine Continuous.div (by fun_prop) (by fun_prop) (fun u => ?_)
  have : (0:ℝ) < 1 + Real.exp u := by positivity
  exact this.ne'

theorem coshKernelRplus_expHomeo (u : ℝ) :
    coshKernelRplus (Rplus.expHomeo u) = coshKernelLog u := by
  have hcoe : ((Rplus.expHomeo u : Rplus) : ℝ) = Real.exp u := rfl
  rw [coshKernelRplus, hcoe, coshKernelLog]
  congr 1
  rw [show Real.exp u = Real.exp (u / 2) * Real.exp (u / 2) by rw [← Real.exp_add]; ring_nf,
    Real.sqrt_mul_self (Real.exp_pos _).le]

/-- **The even kernel is the difference of the Weil kernel and its reflection**:
`1/(2 cosh(u/2)) = sinhKernel u - sinhKernelRefl u`. -/
theorem coshKernelLog_eq_sub {u : ℝ} (hu : u ≠ 0) :
    coshKernelLog u = sinhKernel u - sinhKernelRefl u := by
  have hpos : 0 < |u| := abs_pos.2 hu
  set t : ℝ := Real.exp (|u| / 2) with ht
  have ht0 : 0 < t := Real.exp_pos _
  have ht1 : 1 < t := by
    rw [ht, show (1:ℝ) = Real.exp 0 by simp]
    exact Real.exp_lt_exp.2 (by linarith)
  have habs : Real.exp |u| = t * t := by rw [ht, ← Real.exp_add]; ring_nf
  have habsneg : Real.exp (-|u|) = (t * t)⁻¹ := by rw [← habs, ← Real.exp_neg]
  have hhalfneg : Real.exp (-(|u| / 2)) = t⁻¹ := by rw [ht, ← Real.exp_neg]
  have heven : coshKernelLog u = Real.exp (|u| / 2) / (1 + Real.exp |u|) := by
    rcases abs_cases u with ⟨h, _⟩ | ⟨h, _⟩
    · rw [h, coshKernelLog]
    · rw [h, ← coshKernelLog_even u, coshKernelLog]
  rw [heven, sinhKernel, sinhKernelRefl, habs, habsneg, hhalfneg, ← ht]
  have hden : t * t - (t * t)⁻¹ ≠ 0 := by
    have h1 : (t * t)⁻¹ < 1 := by
      rw [inv_lt_one₀ (by positivity)]
      nlinarith
    intro h
    have : t * t = (t * t)⁻¹ := by linarith [sub_eq_zero.1 h]
    nlinarith
  have ht0' : t ≠ 0 := ne_of_gt ht0
  rw [div_sub_div_same, div_eq_div_iff (by positivity) hden]
  field_simp
  ring

/-! ## 5. The integral of the even kernel -/

/-- The antiderivative `2 arctan(e^{u/2})` of the regular kernel. -/
def coshKernelLogPrimitive (u : ℝ) : ℝ := 2 * Real.arctan (Real.exp (u / 2))

theorem hasDerivAt_coshKernelLogPrimitive (u : ℝ) :
    HasDerivAt coshKernelLogPrimitive (coshKernelLog u) u := by
  have hs : HasDerivAt (fun x : ℝ => Real.exp (x / 2)) (Real.exp (u / 2) * (1 / 2)) u := by
    have h1 : HasDerivAt (fun x : ℝ => x / 2) (1 / 2 : ℝ) u := (hasDerivAt_id u).div_const 2
    exact (Real.hasDerivAt_exp (u / 2)).comp u h1
  have hA := (hs.arctan).const_mul (2:ℝ)
  convert hA using 1
  have hsq : Real.exp (u / 2) * Real.exp (u / 2) = Real.exp u := by
    rw [← Real.exp_add]; ring_nf
  have h1 : (0:ℝ) < 1 + Real.exp (u / 2) ^ 2 := by positivity
  rw [coshKernelLog]
  field_simp
  nlinarith [hsq]

theorem continuous_coshKernelLogPrimitive : Continuous coshKernelLogPrimitive := by
  unfold coshKernelLogPrimitive
  fun_prop

theorem tendsto_coshKernelLogPrimitive :
    Tendsto coshKernelLogPrimitive atTop (𝓝 π) := by
  have hhalf : Tendsto (fun u : ℝ => u / 2) atTop atTop :=
    Filter.tendsto_id.atTop_div_const (by norm_num)
  have hexp : Tendsto (fun u : ℝ => Real.exp (u / 2)) atTop atTop :=
    Real.tendsto_exp_atTop.comp hhalf
  have hA : Tendsto (fun u : ℝ => Real.arctan (Real.exp (u / 2))) atTop (𝓝 (π / 2)) :=
    (Real.tendsto_arctan_atTop.mono_right nhdsWithin_le_nhds).comp hexp
  have := hA.const_mul (2:ℝ)
  have hval : (2:ℝ) * (π / 2) = π := by ring
  rw [hval] at this
  exact this

theorem integrableOn_coshKernelLog_Ioi :
    IntegrableOn coshKernelLog (Ioi (0:ℝ)) volume :=
  integrableOn_Ioi_deriv_of_nonneg (a := (0:ℝ))
    continuous_coshKernelLogPrimitive.continuousWithinAt
    (fun u _ => hasDerivAt_coshKernelLogPrimitive u)
    (fun u _ => (coshKernelLog_pos u).le) tendsto_coshKernelLogPrimitive

theorem integral_coshKernelLog_Ioi :
    (∫ u in Ioi (0:ℝ), coshKernelLog u) = π / 2 := by
  have h := integral_Ioi_of_hasDerivAt_of_nonneg (a := (0:ℝ))
    continuous_coshKernelLogPrimitive.continuousWithinAt
    (fun u _ => hasDerivAt_coshKernelLogPrimitive u)
    (fun u _ => (coshKernelLog_pos u).le) tendsto_coshKernelLogPrimitive
  rw [h, coshKernelLogPrimitive]
  norm_num [Real.arctan_one]
  ring

/-- **The total mass of the even (regular) kernel is `π`.** -/
theorem integral_coshKernelLog : (∫ u : ℝ, coshKernelLog u) = π := by
  have heq : (fun u : ℝ => coshKernelLog u) = fun u : ℝ => coshKernelLog |u| := by
    funext u
    rcases abs_cases u with ⟨h, _⟩ | ⟨h, _⟩
    · rw [h]
    · rw [h, coshKernelLog_even]
  rw [heq, integral_comp_abs, integral_coshKernelLog_Ioi]
  ring

theorem integrable_coshKernelLog : Integrable coshKernelLog volume := by
  have hbound : ∀ u : ℝ, ‖coshKernelLog u‖ ≤ Real.exp (-(1/2) * |u|) := by
    intro u
    rw [Real.norm_eq_abs, abs_of_pos (coshKernelLog_pos u)]
    rcases le_or_gt 0 u with hu | hu
    · rw [abs_of_nonneg hu, coshKernelLog, show -(1/2 : ℝ) * u = -(u/2) by ring, Real.exp_neg]
      rw [inv_eq_one_div, div_le_div_iff₀ (by positivity) (by positivity)]
      have h2 : Real.exp (u / 2) * Real.exp (u / 2) = Real.exp u := by
        rw [← Real.exp_add]; ring_nf
      nlinarith [Real.exp_pos (u/2), Real.exp_pos u]
    · rw [abs_of_neg hu, coshKernelLog, show -(1/2 : ℝ) * -u = u/2 by ring]
      rw [div_le_iff₀ (by positivity)]
      nlinarith [Real.exp_pos (u/2), Real.exp_pos u]
  have hint : Integrable (fun u : ℝ => Real.exp (-(1/2) * |u|)) volume := by
    exact integrable_expNegAbs_real (b := (1/2 : ℝ)) (by norm_num)
  exact Integrable.mono' hint continuous_coshKernelLog.aestronglyMeasurable
    (.of_forall hbound)

/-! ## 6. The regular pairing in terms of `W_ℝ` -/

theorem coshPairing_eq_integral_log (f : C_c(Rplus, ℂ)) :
    coshPairing f = ∫ u : ℝ, logTest f u * ((coshKernelLog u : ℝ) : ℂ) := by
  rw [coshPairing, Rplus.integral_haar]
  refine integral_congr_ae (.of_forall fun u => ?_)
  dsimp only
  rw [coshKernelRplus_expHomeo, logTest]

theorem integrable_logTest_mul_coshKernelLog (f : C_c(Rplus, ℂ)) :
    Integrable (fun u : ℝ => logTest f u * ((coshKernelLog u : ℝ) : ℂ)) := by
  obtain ⟨M, hM⟩ :=
    (hasCompactSupport_logTest f).exists_bound_of_continuous (continuous_logTest f)
  refine Integrable.mono' (integrable_coshKernelLog.const_mul M) ?_ (.of_forall fun u => ?_)
  · exact (continuous_logTest f).aestronglyMeasurable.mul
      (Complex.continuous_ofReal.comp continuous_coshKernelLog).aestronglyMeasurable
  · rw [norm_mul, Complex.norm_real, Real.norm_eq_abs,
      abs_of_pos (coshKernelLog_pos u)]
    exact mul_le_mul_of_nonneg_right (hM u) (coshKernelLog_pos u).le

theorem integrable_sub_logTest_mul_coshKernelLog (f : C_c(Rplus, ℂ)) :
    Integrable (fun u : ℝ => (logTest f 0 - logTest f u) * ((coshKernelLog u : ℝ) : ℂ)) := by
  obtain ⟨M, hM⟩ :=
    (hasCompactSupport_logTest f).exists_bound_of_continuous (continuous_logTest f)
  refine Integrable.mono' (integrable_coshKernelLog.const_mul (‖logTest f 0‖ + M)) ?_
    (.of_forall fun u => ?_)
  · exact (continuous_const.sub (continuous_logTest f)).aestronglyMeasurable.mul
      (Complex.continuous_ofReal.comp continuous_coshKernelLog).aestronglyMeasurable
  · rw [norm_mul, Complex.norm_real, Real.norm_eq_abs,
      abs_of_pos (coshKernelLog_pos u)]
    refine mul_le_mul_of_nonneg_right ?_ (coshKernelLog_pos u).le
    have h1 := norm_sub_le (logTest f 0) (logTest f u)
    have h2 := hM u
    linarith

/-- **The regular pairing is the Weil functional minus the odd-part contribution.**

`∫ f(λ) λ^{1/2}/(1+λ) d*λ = W_ℝ(∆^{-1/2} F) - E(F) + (π - c₀) f(1)`,

where `c₀ = weilConst`.  This is the exact cancellation making the even-subspace finite part
free of the reflection term `E`. -/
theorem coshPairing_eq_weilR_sub (f : C_c(Rplus, ℂ)) {C : ℝ}
    (hf : ∀ lam : Rplus, ‖f lam - f 1‖ ≤ C * |1 - (lam : ℝ)|) :
    coshPairing f = WeilR (deltaHalfInv (ofLog (logTest f)))
      - reflectionPairingReg (logTest f) + f 1 * ((π - weilConst : ℝ) : ℂ) := by
  set F : ℝ → ℂ := logTest f with hFdef
  have hFc : Continuous F := continuous_logTest f
  have hF0 : F 0 = f 1 := logTest_apply_zero f
  obtain ⟨C', hLip⟩ := exists_logTest_lipschitz_sub f hf
  have hLip' : ∀ u : ℝ, ‖F u - F 0‖ ≤ C' * |u| := hLip
  -- split off the constant
  have hsplit : (∫ u : ℝ, F u * ((coshKernelLog u : ℝ) : ℂ))
      = F 0 * ((π : ℝ) : ℂ) - ∫ u : ℝ, (F 0 - F u) * ((coshKernelLog u : ℝ) : ℂ) := by
    have hK : Integrable (fun u : ℝ => (F 0) * ((coshKernelLog u : ℝ) : ℂ)) := by
      have := (integrable_coshKernelLog.ofReal).const_mul (F 0)
      simpa using this
    have hd : (fun u : ℝ => (F 0 - F u) * ((coshKernelLog u : ℝ) : ℂ))
        = fun u : ℝ => (F 0) * ((coshKernelLog u : ℝ) : ℂ)
            - F u * ((coshKernelLog u : ℝ) : ℂ) := by
      funext u; ring
    rw [hd, integral_sub hK (integrable_logTest_mul_coshKernelLog f)]
    have hc : (∫ u : ℝ, (F 0) * ((coshKernelLog u : ℝ) : ℂ)) = F 0 * ((π : ℝ) : ℂ) := by
      rw [integral_const_mul, integral_complex_ofReal, integral_coshKernelLog]
    rw [hc]
    ring
  -- split the kernel
  have hker : (∫ u : ℝ, (F 0 - F u) * ((coshKernelLog u : ℝ) : ℂ))
      = (∫ u : ℝ, (F 0 - F u) * ((sinhKernel u : ℝ) : ℂ))
        - ∫ u : ℝ, (F 0 - F u) * ((sinhKernelRefl u : ℝ) : ℂ) := by
    rw [← integral_sub (integrable_sub_mul_sinhKernel hFc hLip')
      (integrable_sub_mul_sinhKernelRefl hFc hLip')]
    refine integral_congr_ae ?_
    have hae : ∀ᵐ u : ℝ, u ≠ 0 := by rw [ae_iff]; simp
    filter_upwards [hae] with u hu
    rw [coshKernelLog_eq_sub hu]
    push_cast
    ring
  have hW := WeilR_deltaHalfInv_ofLog_value (G := F) hFc hLip'
  have hE : reflectionPairingReg F
      = -∫ u : ℝ, (F 0 - F u) * ((sinhKernelRefl u : ℝ) : ℂ) := rfl
  have hS : (∫ u : ℝ, (F 0 - F u) * ((sinhKernel u : ℝ) : ℂ))
      = ((weilConst : ℝ) : ℂ) * F 0 - WeilR (deltaHalfInv (ofLog F)) := by
    rw [hW]; ring
  rw [coshPairing_eq_integral_log, ← hFdef, hsplit, hker, hE, hS, hF0]
  push_cast
  ring

/-! ## 7. The even renormalized trace: coefficient `2 f(1)`, finite part `W_ℝ` -/

/-- **Main theorem (even subspace).**  There is a universal constant `z_ev` such that for
every compactly supported continuous `f` on `ℝ⋆₊` which is Lipschitz at `λ = 1`,

  `Tr(ϑ(f) S^{(Λ)} P_ev) - 2 f(1) log Λ  ⟶  W_ℝ(∆^{-1/2} F) + f(1) z_ev`,

with `F = logTest f`.  The logarithmic coefficient is **exactly `2 f(1)`**, matching the
paper's normalisation, and the finite part is exactly the archimedean Weil functional: the
odd-part remainder `E(F)` present in the full-line statement has cancelled. -/
theorem exists_universal_even_finitePart [Countable ι] (b : HilbertBasis ι ℂ L2R) :
    ∃ z_ev : ℂ, ∀ (f : C_c(Rplus, ℂ)) (C : ℝ),
      (∀ lam : Rplus, ‖f lam - f 1‖ ≤ C * |1 - (lam : ℝ)|) →
      Tendsto (fun cut : ℝ => evenModelCutTrace b cut f - f 1 * 2 * (Real.log cut : ℂ)) atTop
        (𝓝 (WeilR (deltaHalfInv (ofLog (logTest f))) + f 1 * z_ev)) := by
  obtain ⟨z₁, hz₁⟩ := exists_universal_finitePart_unconditional b
  refine ⟨2⁻¹ * z₁ + 2⁻¹ * ((π - weilConst : ℝ) : ℂ), fun f C hf => ?_⟩
  have hfull := hz₁ f C hf
  have hrefl := tendsto_reflModelCutTrace f
  have hsum := (hfull.add hrefl).const_mul (2⁻¹ : ℂ)
  rw [coshPairing_eq_weilR_sub f hf] at hsum
  have hval : (2⁻¹ : ℂ) * ((WeilR (deltaHalfInv (ofLog (logTest f)))
        + reflectionPairingReg (logTest f) + f 1 * z₁)
      + (WeilR (deltaHalfInv (ofLog (logTest f))) - reflectionPairingReg (logTest f)
        + f 1 * ((π - weilConst : ℝ) : ℂ)))
      = WeilR (deltaHalfInv (ofLog (logTest f)))
        + f 1 * (2⁻¹ * z₁ + 2⁻¹ * ((π - weilConst : ℝ) : ℂ)) := by ring
  rw [hval] at hsum
  refine hsum.congr' ?_
  filter_upwards [eventually_ge_atTop (0:ℝ)] with cut hcut
  rw [evenModelCutTrace_eq_half b hcut f]
  ring

/-- **Main theorem (even subspace), in terms of `L_Norm`.**

  `Tr(ϑ(f) S^{(Λ)} P_ev) - 2 f(1) log Λ  ⟶  D(F) - L_Norm(F) + f(1) z_ev`. -/
theorem exists_universal_even_finitePart_LfunNorm [Countable ι] (b : HilbertBasis ι ℂ L2R) :
    ∃ z_ev : ℂ, ∀ (f : C_c(Rplus, ℂ)) (C : ℝ),
      (∀ lam : Rplus, ‖f lam - f 1‖ ≤ C * |1 - (lam : ℝ)|) →
      Tendsto (fun cut : ℝ => evenModelCutTrace b cut f - f 1 * 2 * (Real.log cut : ℂ)) atTop
        (𝓝 (Dcomplex (ofLog (logTest f)) - LfunNorm (logTest f) + f 1 * z_ev)) := by
  obtain ⟨z_ev, h⟩ := exists_universal_even_finitePart b
  refine ⟨z_ev, fun f C hf => ?_⟩
  have hlim := h f C hf
  rwa [weilR_eq_sub_LfunNorm] at hlim

end ConnesConsani.WeilPositivity
