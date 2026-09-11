/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The analytic kernel of the archimedean explicit formula of

  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771.

This file collects the elementary analysis that the explicit formula (proved in
`RequestProject/ArchimedeanExplicit.lean`) rests on:

* the kernel `κ(u) = e^{|u|/2}/(e^{|u|} - e^{-|u|})` and its expansion
  `κ(u) = ∑_{n≥0} e^{-(2n+1/2)|u|}` as a series of inverse Fourier transforms of Poisson
  kernels attached to the poles `1/4 + n` of `Γ`;
* the Fourier transform `∫ e^{-b|v|} e^{itv} dv = 2b/(b²+t²)` of the Poisson kernel and the
  associated multiplication formula;
* the elementary constant `∫₀^∞ (e^{u/2}-1)/(e^u - e^{-u}) du = (log 2)/2 + π/4`.
-/
import RequestProject.Imported.OutputFinal.RequestProject.Parseval

noncomputable section

open MeasureTheory Set Real Filter Topology

namespace ConnesConsani.WeilPositivity

/-! ## The kernel `κ` and its expansion as a series of Poisson kernels -/

/-- `b n = 2n + 1/2`, the exponents occurring in the partial-fraction expansion of `ψ` at
`1/4 + i t/2`; `a n = n + 1/4 = (b n)/2` are the poles. -/
def poleA (n : ℕ) : ℝ := n + 1 / 4

/-- `b n = 2 n + 1/2 = 2 * poleA n`. -/
def poleB (n : ℕ) : ℝ := 2 * n + 1 / 2

theorem poleA_pos (n : ℕ) : 0 < poleA n := by
  have : (0:ℝ) ≤ n := Nat.cast_nonneg n
  simp only [poleA]; linarith

theorem poleB_pos (n : ℕ) : 0 < poleB n := by
  have : (0:ℝ) ≤ n := Nat.cast_nonneg n
  simp only [poleB]; linarith

theorem poleB_eq (n : ℕ) : poleB n = 2 * poleA n := by
  simp only [poleB, poleA]; ring

/-- **The kernel of the archimedean explicit formula in the logarithmic coordinate**,
`κ(u) = e^{|u|/2}/(e^{|u|} - e^{-|u|})`.  It is the sum of the exponentials
`e^{-(2n+1/2)|u|}`, i.e. of the inverse Fourier transforms of the Poisson kernels attached
to the poles `1/4 + n` of `Γ`. -/
def sinhKernel (u : ℝ) : ℝ := Real.exp (|u| / 2) / (Real.exp |u| - Real.exp (-|u|))

theorem sinhKernel_even (u : ℝ) : sinhKernel (-u) = sinhKernel u := by
  simp [sinhKernel]

theorem sinhKernel_nonneg (u : ℝ) : 0 ≤ sinhKernel u := by
  rcases eq_or_ne u 0 with rfl | hu
  · simp [sinhKernel]
  · have h : 0 < |u| := abs_pos.2 hu
    have hlt : Real.exp (-|u|) < Real.exp |u| := Real.exp_lt_exp.2 (by linarith)
    exact div_nonneg (Real.exp_pos _).le (by linarith)

private theorem sinhKernel_alg (a : ℝ) (ha : 1 < a) :
    a / (a ^ 2 - (a ^ 2)⁻¹) = a⁻¹ * (1 - (a ^ 4)⁻¹)⁻¹ := by
  have h0 : 0 < a := by linarith
  have ha2 : 1 < a ^ 2 := by nlinarith
  have ha4 : 1 < a ^ 4 := by nlinarith
  have hi2 : (a ^ 2)⁻¹ < 1 := by rw [inv_lt_one_iff₀]; right; exact ha2
  have hi4 : (a ^ 4)⁻¹ < 1 := by rw [inv_lt_one_iff₀]; right; exact ha4
  have hd1 : a ^ 2 - (a ^ 2)⁻¹ ≠ 0 := by linarith
  have hd2 : 1 - (a ^ 4)⁻¹ ≠ 0 := by linarith
  field_simp

/-- The expansion `κ(u) = ∑_{n≥0} e^{-(2n+1/2)|u|}`. -/
theorem hasSum_sinhKernel {u : ℝ} (hu : u ≠ 0) :
    HasSum (fun n : ℕ => Real.exp (-poleB n * |u|)) (sinhKernel u) := by
  have hpos : 0 < |u| := abs_pos.2 hu
  have hr : Real.exp (-(2 * |u|)) < 1 := by
    rw [Real.exp_lt_one_iff]; linarith
  have hr0 : 0 ≤ Real.exp (-(2 * |u|)) := (Real.exp_pos _).le
  have h := (hasSum_geometric_of_lt_one hr0 hr).mul_left (Real.exp (-(|u| / 2)))
  have heq : ∀ n : ℕ, Real.exp (-(|u| / 2)) * Real.exp (-(2 * |u|)) ^ n
      = Real.exp (-poleB n * |u|) := by
    intro n
    rw [← Real.exp_nat_mul, ← Real.exp_add]
    congr 1
    simp only [poleB]
    ring
  rw [funext heq] at h
  convert h using 1
  have ha1 : 1 < Real.exp (|u| / 2) := by
    have := Real.exp_lt_exp.2 (show (0:ℝ) < |u| / 2 by linarith)
    rwa [Real.exp_zero] at this
  have h1 : Real.exp |u| = Real.exp (|u| / 2) ^ 2 := by
    rw [← Real.exp_nat_mul]; congr 1; ring
  have h2 : Real.exp (-|u|) = (Real.exp (|u| / 2) ^ 2)⁻¹ := by rw [Real.exp_neg, h1]
  have h3 : Real.exp (-(2 * |u|)) = (Real.exp (|u| / 2) ^ 4)⁻¹ := by
    rw [Real.exp_neg, ← Real.exp_nat_mul]
    congr 2
    ring
  have h4 : Real.exp (-(|u| / 2)) = (Real.exp (|u| / 2))⁻¹ := by rw [Real.exp_neg]
  rw [sinhKernel, h1, h2, h3, h4]
  exact sinhKernel_alg _ ha1

/-! ## The Fourier transform of the Poisson kernel -/

theorem integrableOn_expNegAbs_Iic {b : ℝ} (hb : 0 < b) (t : ℝ) :
    IntegrableOn
      (fun v : ℝ => ((Real.exp (-b * |v|) : ℝ) : ℂ) * Complex.exp (Complex.I * t * v))
      (Iic 0) := by
  have hre : (0:ℝ) < ((b:ℂ) + Complex.I * t).re := by simp [hb]
  refine (integrableOn_exp_mul_complex_Iic hre 0).congr_fun ?_ measurableSet_Iic
  intro v hv
  have hv' : |v| = -v := abs_of_nonpos hv
  show Complex.exp (((b:ℂ) + Complex.I * t) * v)
    = ((Real.exp (-b * |v|) : ℝ) : ℂ) * Complex.exp (Complex.I * t * v)
  rw [hv', show -b * -v = b * v by ring, Complex.ofReal_exp, ← Complex.exp_add]
  push_cast
  ring_nf

theorem integrableOn_expNegAbs_Ioi {b : ℝ} (hb : 0 < b) (t : ℝ) :
    IntegrableOn
      (fun v : ℝ => ((Real.exp (-b * |v|) : ℝ) : ℂ) * Complex.exp (Complex.I * t * v))
      (Ioi 0) := by
  have hre : (-(b:ℂ) + Complex.I * t).re < 0 := by simp [hb]
  refine (integrableOn_exp_mul_complex_Ioi hre 0).congr_fun ?_ measurableSet_Ioi
  intro v hv
  have hv' : |v| = v := abs_of_pos hv
  show Complex.exp ((-(b:ℂ) + Complex.I * t) * v)
    = ((Real.exp (-b * |v|) : ℝ) : ℂ) * Complex.exp (Complex.I * t * v)
  rw [hv', Complex.ofReal_exp, ← Complex.exp_add]
  push_cast
  ring_nf

theorem integrable_expNegAbs_mul {b : ℝ} (hb : 0 < b) (t : ℝ) :
    Integrable
      (fun v : ℝ => ((Real.exp (-b * |v|) : ℝ) : ℂ) * Complex.exp (Complex.I * t * v)) := by
  rw [← integrableOn_univ, ← Iic_union_Ioi (a := (0:ℝ))]
  exact (integrableOn_expNegAbs_Iic hb t).union (integrableOn_expNegAbs_Ioi hb t)

theorem integrable_expNegAbs {b : ℝ} (hb : 0 < b) :
    Integrable (fun v : ℝ => ((Real.exp (-b * |v|) : ℝ) : ℂ)) := by
  have h := integrable_expNegAbs_mul hb 0
  simpa using h

theorem integral_expNegAbs_Iic {b : ℝ} (hb : 0 < b) (t : ℝ) :
    (∫ v : ℝ in Iic (0:ℝ), ((Real.exp (-b * |v|) : ℝ) : ℂ) * Complex.exp (Complex.I * t * v))
      = 1 / ((b:ℂ) + Complex.I * t) := by
  have hre : (0:ℝ) < ((b:ℂ) + Complex.I * t).re := by simp [hb]
  have h := integral_exp_mul_complex_Iic (a := (b:ℂ) + Complex.I * t) hre 0
  simp only [Complex.ofReal_zero, mul_zero, Complex.exp_zero] at h
  rw [← h]
  refine setIntegral_congr_fun measurableSet_Iic (fun v hv => ?_)
  have hv' : |v| = -v := abs_of_nonpos hv
  show ((Real.exp (-b * |v|) : ℝ) : ℂ) * Complex.exp (Complex.I * t * v) = _
  rw [hv', show -b * -v = b * v by ring, Complex.ofReal_exp, ← Complex.exp_add]
  push_cast
  ring_nf

theorem integral_expNegAbs_Ioi {b : ℝ} (hb : 0 < b) (t : ℝ) :
    (∫ v : ℝ in Ioi (0:ℝ), ((Real.exp (-b * |v|) : ℝ) : ℂ) * Complex.exp (Complex.I * t * v))
      = 1 / ((b:ℂ) - Complex.I * t) := by
  have hre : (-(b:ℂ) + Complex.I * t).re < 0 := by simp [hb]
  have h := integral_exp_mul_complex_Ioi (a := -(b:ℂ) + Complex.I * t) hre 0
  simp only [Complex.ofReal_zero, mul_zero, Complex.exp_zero] at h
  rw [show (1:ℂ) / ((b:ℂ) - Complex.I * t) = -1 / (-(b:ℂ) + Complex.I * t) by
    rw [show -(b:ℂ) + Complex.I * t = -((b:ℂ) - Complex.I * t) by ring, neg_div_neg_eq], ← h]
  refine setIntegral_congr_fun measurableSet_Ioi (fun v hv => ?_)
  have hv' : |v| = v := abs_of_pos hv
  show ((Real.exp (-b * |v|) : ℝ) : ℂ) * Complex.exp (Complex.I * t * v) = _
  rw [hv', Complex.ofReal_exp, ← Complex.exp_add]
  push_cast
  ring_nf

/-- `∫ e^{-b|v|} e^{itv} dv = 2b/(b²+t²)`. -/
theorem fourierLog_expNegAbs {b : ℝ} (hb : 0 < b) (t : ℝ) :
    fourierLog (fun v => ((Real.exp (-b * |v|) : ℝ) : ℂ)) t
      = ((2 * b / (b ^ 2 + t ^ 2) : ℝ) : ℂ) := by
  have hsplit := intervalIntegral.integral_Iic_add_Ioi (f := fun v : ℝ =>
      ((Real.exp (-b * |v|) : ℝ) : ℂ) * Complex.exp (Complex.I * t * v))
    (b := (0:ℝ)) (μ := volume) (integrableOn_expNegAbs_Iic hb t) (integrableOn_expNegAbs_Ioi hb t)
  have h1 : ((b:ℂ) + Complex.I * t) * ((b:ℂ) - Complex.I * t) = ((b^2 + t^2 : ℝ) : ℂ) := by
    push_cast
    linear_combination (-(t:ℂ)^2) * Complex.I_sq
  have hne : ((b^2 + t^2 : ℝ) : ℂ) ≠ 0 := by
    have : (0:ℝ) < b^2 + t^2 := by positivity
    exact_mod_cast this.ne'
  have h2 : ((b:ℂ) + Complex.I * t) ≠ 0 := by
    intro h; rw [h, zero_mul] at h1; exact hne h1.symm
  have h3 : ((b:ℂ) - Complex.I * t) ≠ 0 := by
    intro h; rw [h, mul_zero] at h1; exact hne h1.symm
  rw [fourierLog, mellinLog, ← hsplit, integral_expNegAbs_Iic hb t, integral_expNegAbs_Ioi hb t,
    div_add_div _ _ h2 h3, h1]
  push_cast
  ring

/-- **The multiplication formula for the Poisson kernel.**  If the transform of `G` is
integrable then `(2π)⁻¹ ∫ Ĝ(t) · 2b/(b²+t²) dt = ∫ G(u) e^{-b|u|} du`. -/
theorem integral_fourierLog_mul_poisson {G : ℝ → ℂ} (hGc : Continuous G)
    (hGs : HasCompactSupport G) (hG : Integrable (fourierLog G)) {b : ℝ} (hb : 0 < b) :
    ((1 / (2 * π) : ℝ) : ℂ) * ∫ t : ℝ, fourierLog G t * ((2 * b / (b ^ 2 + t ^ 2) : ℝ) : ℂ)
      = ∫ u : ℝ, G u * ((Real.exp (-b * |u|) : ℝ) : ℂ) := by
  have hGint : Integrable G := hGc.integrable_of_hasCompactSupport hGs
  set kk : ℝ → ℂ := fun v => ((Real.exp (-b * |v|) : ℝ) : ℂ) with hkk
  have hkkint : Integrable kk := integrable_expNegAbs hb
  set K : ℝ → ℝ → ℂ :=
    fun t v => fourierLog G t * (kk v * Complex.exp (Complex.I * t * v)) with hK
  have hmeas : AEStronglyMeasurable (Function.uncurry K) (volume.prod volume) := by
    have h1 : AEStronglyMeasurable (fun z : ℝ × ℝ => fourierLog G z.1) (volume.prod volume) :=
      hG.aestronglyMeasurable.comp_fst
    have h2 : AEStronglyMeasurable (fun z : ℝ × ℝ => kk z.2) (volume.prod volume) :=
      hkkint.aestronglyMeasurable.comp_snd
    have h3 : Continuous fun z : ℝ × ℝ => Complex.exp (Complex.I * z.1 * z.2) := by fun_prop
    exact h1.mul (h2.mul h3.aestronglyMeasurable)
  have hKint : Integrable (Function.uncurry K) (volume.prod volume) := by
    refine Integrable.mono' (hG.norm.mul_prod hkkint.norm) hmeas
      (Filter.Eventually.of_forall fun z => ?_)
    have hexp : ‖Complex.exp (Complex.I * (z.1 : ℂ) * (z.2 : ℂ))‖ = 1 := by
      have h : Complex.I * (z.1 : ℂ) * (z.2 : ℂ) = ((z.1 * z.2 : ℝ) : ℂ) * Complex.I := by
        push_cast; ring
      rw [h, Complex.norm_exp_ofReal_mul_I]
    simp only [Function.uncurry, hK, norm_mul, hexp, mul_one]
    exact le_rfl
  -- the inner integral in `v`
  have hstep1 : ∀ t : ℝ, (∫ v : ℝ, K t v)
      = fourierLog G t * ((2 * b / (b ^ 2 + t ^ 2) : ℝ) : ℂ) := by
    intro t
    show (∫ v : ℝ, fourierLog G t * (kk v * Complex.exp (Complex.I * t * v))) = _
    rw [integral_const_mul, ← fourierLog_expNegAbs hb t]
    rfl
  -- the inner integral in `t`
  have hstep2 : ∀ v : ℝ, (∫ t : ℝ, K t v)
      = kk v * (((2 * π : ℝ) : ℂ) * G (-v)) := by
    intro v
    have hinv := fourierLog_inversion hGc hGint hG (-v)
    have hcong : ∀ t : ℝ, K t v = kk v * (fourierLog G t
        * Complex.exp (-(Complex.I * ((-v : ℝ) : ℂ) * t))) := by
      intro t
      simp only [hK]
      push_cast
      ring_nf
    rw [integral_congr_ae (Filter.Eventually.of_forall hcong), integral_const_mul]
    congr 1
    rw [hinv]
    have hpi : (2 * π : ℝ) ≠ 0 := by positivity
    rw [← mul_assoc]
    norm_cast
    rw [show (2 * π : ℝ) * (1 / (2 * π)) = 1 by field_simp]
    simp
  have hswap := integral_integral_swap hKint
  simp only at hswap
  rw [integral_congr_ae (Filter.Eventually.of_forall hstep1),
    integral_congr_ae (Filter.Eventually.of_forall hstep2)] at hswap
  rw [hswap]
  have hfin : (∫ v : ℝ, kk v * (((2 * π : ℝ) : ℂ) * G (-v)))
      = ((2 * π : ℝ) : ℂ) * ∫ u : ℝ, G u * kk u := by
    rw [← integral_const_mul]
    have h := integral_neg_eq_self (fun u : ℝ => ((2 * π : ℝ) : ℂ) * (G u * kk u)) volume
    rw [← h]
    refine integral_congr_ae (Filter.Eventually.of_forall fun v => ?_)
    simp only [hkk, abs_neg]
    ring
  rw [hfin, ← mul_assoc]
  norm_cast
  rw [show (1 / (2 * π) : ℝ) * (2 * π) = 1 by field_simp, Complex.ofReal_one, one_mul]

/-! ## The elementary constant -/

/-- `∫₀^∞ (e^{u/2} - 1)/(e^u - e^{-u}) du = (log 2)/2 + π/4`.  This is the constant that
reconciles the kernel `κ` of the spectral side with the kernel `1/(x - x⁻¹)` of formula
(150). -/
private theorem sinhKernel_const_alg (s : ℝ) (hs : 1 < s) :
    (s - 1) / (s * s - (s * s)⁻¹)
      = 1 / (1 + s ^ 2) * (s * (1 / 2)) + -(s * s)⁻¹ / (1 + (s * s)⁻¹) / 2
        - s⁻¹ * (-1 / 2) / (1 + s⁻¹) := by
  have h0 : 0 < s := by linarith
  have h2' : 1 < s ^ 2 := by nlinarith
  have h4 : 1 < s ^ 4 := by nlinarith
  have hne : s ^ 4 - 1 ≠ 0 := by intro h; nlinarith
  have h1 : s ≠ 0 := ne_of_gt h0
  have h2 : (1 : ℝ) + s ^ 2 ≠ 0 := by positivity
  have h3 : (1 : ℝ) + (s * s)⁻¹ ≠ 0 := by positivity
  have h5 : (1 : ℝ) + s⁻¹ ≠ 0 := by positivity
  have h6 : s * s - (s * s)⁻¹ ≠ 0 := by
    have hi : (s * s)⁻¹ < 1 := by
      rw [inv_lt_one_iff₀]; right; nlinarith
    nlinarith
  field_simp
  ring

/-- The antiderivative of the kernel `(e^{u/2}-1)/(e^u - e^{-u})`. -/
def sinhKernelPrimitive (u : ℝ) : ℝ :=
  Real.arctan (Real.exp (u / 2)) + Real.log (1 + Real.exp (-u)) / 2
    - Real.log (1 + Real.exp (-u / 2))

theorem hasDerivAt_sinhKernelPrimitive {u : ℝ} (hu : 0 < u) :
    HasDerivAt sinhKernelPrimitive
      ((Real.exp (u / 2) - 1) / (Real.exp u - Real.exp (-u))) u := by
  have hs : HasDerivAt (fun x : ℝ => Real.exp (x / 2)) (Real.exp (u / 2) * (1 / 2)) u := by
    have h1 : HasDerivAt (fun x : ℝ => x / 2) (1 / 2 : ℝ) u := (hasDerivAt_id u).div_const 2
    exact (Real.hasDerivAt_exp (u / 2)).comp u h1
  have h2 : HasDerivAt (fun x : ℝ => Real.exp (-x)) (-Real.exp (-u)) u := by
    have h1 : HasDerivAt (fun x : ℝ => -x) (-1 : ℝ) u := (hasDerivAt_id u).neg
    simpa using (Real.hasDerivAt_exp (-u)).comp u h1
  have h3 : HasDerivAt (fun x : ℝ => Real.exp (-x / 2)) (Real.exp (-u / 2) * (-1 / 2)) u := by
    have h1 : HasDerivAt (fun x : ℝ => -x / 2) (-1 / 2 : ℝ) u := by
      simpa using ((hasDerivAt_id u).neg.div_const 2)
    exact (Real.hasDerivAt_exp (-u / 2)).comp u h1
  have hA := hs.arctan
  have hB : HasDerivAt (fun x : ℝ => Real.log (1 + Real.exp (-x)))
      ((-Real.exp (-u)) / (1 + Real.exp (-u))) u := by
    have := (h2.const_add 1).log (by positivity)
    simpa using this
  have hC : HasDerivAt (fun x : ℝ => Real.log (1 + Real.exp (-x / 2)))
      ((Real.exp (-u / 2) * (-1 / 2)) / (1 + Real.exp (-u / 2))) u := by
    have := (h3.const_add 1).log (by positivity)
    simpa using this
  have hcomb := (hA.add (hB.div_const 2)).sub hC
  convert hcomb using 1
  have hs1 : 1 < Real.exp (u / 2) := by
    have := Real.exp_lt_exp.2 (show (0:ℝ) < u / 2 by linarith)
    rwa [Real.exp_zero] at this
  have he : Real.exp u = Real.exp (u / 2) * Real.exp (u / 2) := by
    rw [← Real.exp_add]; ring_nf
  have h1 : Real.exp (-u) = (Real.exp (u / 2) * Real.exp (u / 2))⁻¹ := by
    rw [Real.exp_neg, he]
  have h2' : Real.exp (-u / 2) = (Real.exp (u / 2))⁻¹ := by
    rw [show -u / 2 = -(u / 2) by ring, Real.exp_neg]
  rw [he, h1, h2']
  exact sinhKernel_const_alg _ hs1

theorem continuous_sinhKernelPrimitive : Continuous sinhKernelPrimitive := by
  have hlog1 : Continuous (fun u : ℝ => Real.log (1 + Real.exp (-u))) := by
    refine (continuous_const.add (by fun_prop)).log (fun x => ?_)
    have : 0 < 1 + Real.exp (-x) := by positivity
    exact this.ne'
  have hlog2 : Continuous (fun u : ℝ => Real.log (1 + Real.exp (-u / 2))) := by
    refine (continuous_const.add (by fun_prop)).log (fun x => ?_)
    have : 0 < 1 + Real.exp (-x / 2) := by positivity
    exact this.ne'
  exact ((Real.continuous_arctan.comp (by fun_prop)).add (hlog1.div_const 2)).sub hlog2

theorem tendsto_sinhKernelPrimitive :
    Filter.Tendsto sinhKernelPrimitive Filter.atTop (nhds (π / 2)) := by
  have hhalf : Filter.Tendsto (fun u : ℝ => u / 2) Filter.atTop Filter.atTop :=
    Filter.tendsto_id.atTop_div_const (by norm_num)
  have hexp : Filter.Tendsto (fun u : ℝ => Real.exp (u / 2)) Filter.atTop Filter.atTop :=
    Real.tendsto_exp_atTop.comp hhalf
  have hA : Filter.Tendsto (fun u : ℝ => Real.arctan (Real.exp (u / 2))) Filter.atTop
      (nhds (π / 2)) :=
    (Real.tendsto_arctan_atTop.mono_right nhdsWithin_le_nhds).comp hexp
  have hneg : Filter.Tendsto (fun u : ℝ => Real.exp (-u)) Filter.atTop (nhds 0) := by
    simpa using Real.tendsto_exp_neg_atTop_nhds_zero
  have hneg2 : Filter.Tendsto (fun u : ℝ => Real.exp (-u / 2)) Filter.atTop (nhds 0) := by
    refine Real.tendsto_exp_atBot.comp ?_
    have h2 : (fun u : ℝ => -u / 2) = fun u : ℝ => -(u / 2) := by funext u; ring
    rw [h2]
    exact Filter.tendsto_neg_atTop_atBot.comp hhalf
  have hB : Filter.Tendsto (fun u : ℝ => Real.log (1 + Real.exp (-u)) / 2) Filter.atTop
      (nhds 0) := by
    have h1 : Filter.Tendsto (fun u : ℝ => 1 + Real.exp (-u)) Filter.atTop (nhds 1) := by
      simpa using hneg.const_add 1
    have := (Real.continuousAt_log (by norm_num : (1:ℝ) ≠ 0)).tendsto.comp h1
    simpa using this.div_const 2
  have hC : Filter.Tendsto (fun u : ℝ => Real.log (1 + Real.exp (-u / 2))) Filter.atTop
      (nhds 0) := by
    have h1 : Filter.Tendsto (fun u : ℝ => 1 + Real.exp (-u / 2)) Filter.atTop (nhds 1) := by
      simpa using hneg2.const_add 1
    have := (Real.continuousAt_log (by norm_num : (1:ℝ) ≠ 0)).tendsto.comp h1
    simpa using this
  have := (hA.add hB).sub hC
  simpa [sinhKernelPrimitive] using this

theorem integral_sinhKernel_const :
    (∫ u in Ioi (0:ℝ), (Real.exp (u / 2) - 1) / (Real.exp u - Real.exp (-u)))
      = Real.log 2 / 2 + π / 4 := by
  have hnn : ∀ u ∈ Ioi (0:ℝ), 0 ≤ (Real.exp (u / 2) - 1) / (Real.exp u - Real.exp (-u)) := by
    intro u hu
    have hu' : 0 < u := hu
    have h1 : 1 < Real.exp (u / 2) := by
      have := Real.exp_lt_exp.2 (show (0:ℝ) < u / 2 by linarith)
      rwa [Real.exp_zero] at this
    have h2 : Real.exp (-u) < Real.exp u := Real.exp_lt_exp.2 (by linarith)
    exact div_nonneg (by linarith) (by linarith)
  have h := integral_Ioi_of_hasDerivAt_of_nonneg
    (continuous_sinhKernelPrimitive.continuousWithinAt)
    (fun u hu => hasDerivAt_sinhKernelPrimitive hu) hnn tendsto_sinhKernelPrimitive
  rw [h]
  have h0 : sinhKernelPrimitive 0 = π / 4 - Real.log 2 / 2 := by
    simp only [sinhKernelPrimitive]
    norm_num [Real.arctan_one]
    ring
  rw [h0]
  ring

end ConnesConsani.WeilPositivity
