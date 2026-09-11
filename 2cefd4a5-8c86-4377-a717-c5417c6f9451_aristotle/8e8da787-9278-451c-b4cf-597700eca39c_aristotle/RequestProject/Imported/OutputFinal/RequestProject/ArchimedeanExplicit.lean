/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The `W_∞`-half of the Parseval identity (52) of

  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771,

i.e. the **archimedean explicit formula**

  `W_∞(f) = (2π)⁻¹ ∫ f̂(t) · 2θ'(t) dt`,   `2θ'(t) = -log π + Re ψ(1/4 + i t/2)`.

Two things are done here.

* **The normalization is corrected.**  The distribution `W_ℝ` of formula (150) of the paper
  is applied to `∆^{-1/2} f` and not to `f`: the paper says explicitly (§1, after formula
  (39)) that "(39) is coherent with the equality `W_ℝ(f) = W_ℝ(∆^{-1/2} f)`".  In the
  logarithmic coordinate the two differ by a nonzero functional (see
  `WeilR_ofLog` versus `WeilR_deltaHalfInv_ofLog`), so the hypothesis `WinftyParseval` of
  `RequestProject/Parseval.lean`, which pairs `Winfty (ofLog F)` with `2θ'`, is *not* the
  archimedean explicit formula; the correct statement is `WinftyParsevalNorm` below.

* **The Fourier analysis is carried out.**  The two classical facts about the digamma
  function that Mathlib does not have —

  - `DigammaPartialFractions`: the Gauss partial-fraction expansion of `ψ` on the line
    `1/4 + i t/2`, and
  - `DigammaQuarter`: the value `ψ(1/4) = -γ - 3 log 2 - π/2` (Gauss' digamma theorem) —

  are proved in `RequestProject/Digamma.lean` and instantiated here
  (`digammaPartialFractions`, `digammaQuarter`).  With them the archimedean explicit
  formula is *proved unconditionally* for test functions in the logarithmic coordinate
  (`Winfty_deltaHalfInv_ofLog`, `WinftyParsevalNorm_of_digamma`).  Everything
  else (the Poisson-kernel Fourier transform, the interchange of the sum and the integral,
  the evaluation of the elementary constant `∫₀^∞ (e^{u/2}-1)/(e^u - e^{-u}) du`, and the
  change of variables `x = e^u` in (150)) is proved from scratch.

So the answer to "which classical input of the archimedean explicit formula is still
missing" is: *none of it*.

The elementary analysis of the kernel (the expansion of `κ` into Poisson kernels, their
Fourier transforms, and the constant `∫₀^∞ (e^{u/2}-1)/(e^u-e^{-u}) du = (log 2)/2 + π/4`)
is in `RequestProject/ArchimedeanKernel.lean`.

As a consequence the Parseval identity (52) of the paper and its positivity corollary are
obtained here in the normalization of the paper (`LfunNorm_parseval`,
`LfunNorm_re_nonneg_of_fourierSide_nonneg`) without the `W_∞`-half as a hypothesis.
-/
import RequestProject.Imported.OutputFinal.RequestProject.ArchimedeanKernel
import RequestProject.Imported.OutputFinal.RequestProject.Digamma

noncomputable section

open MeasureTheory Set Real Filter Topology

namespace ConnesConsani.WeilPositivity

/-! ## The two classical facts about the digamma function

Both are proved in `RequestProject/Digamma.lean`; they are recorded here as `Prop`s
(`DigammaPartialFractions`, `DigammaQuarter`) in the exact shape in which the Fourier
analysis below uses them, and immediately instantiated. -/

/-- `P(t) = Re ψ(1/4 + i t/2) - ψ(1/4)`, the increment of the real part of the digamma
function along the line `Re s = 1/4`. -/
def digammaDiff (t : ℝ) : ℝ :=
  (Complex.digamma (1 / 4 + Complex.I * t / 2)).re - (Complex.digamma (1 / 4 : ℂ)).re

theorem digammaDiff_zero : digammaDiff 0 = 0 := by
  simp [digammaDiff]

/-- The single term of the partial-fraction expansion of `P`. -/
def digammaTerm (n : ℕ) (t : ℝ) : ℝ :=
  (t ^ 2 / 4) / (poleA n * ((poleA n) ^ 2 + t ^ 2 / 4))

theorem digammaTerm_nonneg (n : ℕ) (t : ℝ) : 0 ≤ digammaTerm n t := by
  have h := poleA_pos n
  have hd : 0 < poleA n * ((poleA n) ^ 2 + t ^ 2 / 4) := by positivity
  exact div_nonneg (by positivity) hd.le

/-- **Classical input 1** (proved in `RequestProject/Digamma.lean`, see
`digammaPartialFractions` below): the Gauss partial-fraction expansion of the digamma
function, `ψ(s) = -γ + ∑_{n≥0} (1/(n+1) - 1/(n+s))`, in the form it is used here:
on the line `s = 1/4 + i t/2` it gives

  `Re ψ(1/4 + i t/2) - ψ(1/4) = ∑_{n≥0} (t²/4) / ((n+1/4)((n+1/4)² + t²/4))`.

(Each term is the difference `1/(n+1/4) - Re (1/(n+1/4+it/2))`.)  Mathlib knows only
`digamma_zero`, `digamma_one`, `digamma_one_half` and the functional equation, so the
expansion is developed from scratch in `RequestProject/Digamma.lean`. -/
def DigammaPartialFractions : Prop :=
  ∀ t : ℝ, HasSum (fun n : ℕ => digammaTerm n t) (digammaDiff t)

/-- **Classical input 2** (proved in `RequestProject/Digamma.lean`, see `digammaQuarter`
below): the value `ψ(1/4) = -γ - 3 log 2 - π/2` (Gauss' digamma theorem, obtained from the
reflection and duplication formulas for `Γ`). -/
def DigammaQuarter : Prop :=
  (Complex.digamma (1 / 4 : ℂ)).re
    = -Real.eulerMascheroniConstant - 3 * Real.log 2 - π / 2

/-- **The first classical input is a theorem**: the Gauss partial-fraction expansion on the
line `Re s = 1/4`, obtained from `hasSum_digamma` of `RequestProject/Digamma.lean`. -/
theorem digammaPartialFractions : DigammaPartialFractions := by
  intro t
  set s : ℂ := 1 / 4 + Complex.I * t / 2 with hs_def
  have hsre : (0:ℝ) < s.re := by
    have hre : s.re = 1 / 4 := by simp [hs_def]
    rw [hre]; norm_num
  have hqre : (0:ℝ) < ((1 / 4 : ℂ)).re := by norm_num
  have hsub := (hasSum_digamma hsre).sub (hasSum_digamma hqre)
  have hval : (Complex.digamma s + (Real.eulerMascheroniConstant : ℂ)
      - (Complex.digamma (1 / 4 : ℂ) + (Real.eulerMascheroniConstant : ℂ))).re
      = digammaDiff t := by
    simp [digammaDiff, hs_def]
  have hfun : ∀ n : ℕ, digammaTerm n t
      = Complex.reCLM ((1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + s))
          - (1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + (1 / 4 : ℂ)))) := by
    intro n
    have ha : (0:ℝ) < poleA n := poleA_pos n
    have hz1 : ((n : ℂ) + s) = ((poleA n : ℝ) : ℂ) + Complex.I * ((t / 2 : ℝ) : ℂ) := by
      rw [hs_def, poleA]
      push_cast
      ring
    have hz2 : ((n : ℂ) + (1 / 4 : ℂ)) = ((poleA n : ℝ) : ℂ) := by
      rw [poleA]
      push_cast
      ring
    have hane : ((poleA n : ℝ) : ℂ) ≠ 0 := by
      simp only [ne_eq, Complex.ofReal_eq_zero]
      exact ha.ne'
    have hwne : ((poleA n : ℝ) : ℂ) + Complex.I * ((t / 2 : ℝ) : ℂ) ≠ 0 := by
      intro hc
      have hre : (((poleA n : ℝ) : ℂ) + Complex.I * ((t / 2 : ℝ) : ℂ)).re = 0 := by
        rw [hc]; simp
      simp only [Complex.add_re, Complex.mul_re, Complex.I_re, Complex.I_im, Complex.ofReal_re,
        Complex.ofReal_im] at hre
      simp at hre
      linarith [hre ▸ ha]
    have hn1 : ((n : ℂ) + 1) ≠ 0 := by
      intro hc
      have hre : ((n : ℂ) + 1).re = 0 := by rw [hc]; simp
      simp only [Complex.add_re, Complex.natCast_re, Complex.one_re] at hre
      have : (0:ℝ) ≤ (n : ℝ) := n.cast_nonneg
      linarith
    have hsimp : (1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + s))
          - (1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + (1 / 4 : ℂ)))
        = 1 / ((poleA n : ℝ) : ℂ)
          - 1 / (((poleA n : ℝ) : ℂ) + Complex.I * ((t / 2 : ℝ) : ℂ)) := by
      rw [hz1, hz2]
      ring
    rw [hsimp]
    have h1 : ((1 : ℂ) / ((poleA n : ℝ) : ℂ)).re = 1 / poleA n := by
      rw [show (1 : ℂ) / ((poleA n : ℝ) : ℂ) = ((1 / poleA n : ℝ) : ℂ) by push_cast; ring]
      simp
    have hwre : (((poleA n : ℝ) : ℂ) + Complex.I * ((t / 2 : ℝ) : ℂ)).re = poleA n := by simp
    have hwsq : Complex.normSq (((poleA n : ℝ) : ℂ) + Complex.I * ((t / 2 : ℝ) : ℂ))
        = poleA n ^ 2 + t ^ 2 / 4 := by
      simp [Complex.normSq_apply]
      ring
    have h2 : ((1 : ℂ) / (((poleA n : ℝ) : ℂ) + Complex.I * ((t / 2 : ℝ) : ℂ))).re
        = poleA n / (poleA n ^ 2 + t ^ 2 / 4) := by
      rw [one_div, Complex.inv_re, hwre, hwsq]
    simp only [Complex.reCLM_apply, Complex.sub_re, h1, h2]
    rw [digammaTerm]
    have hd : (0:ℝ) < poleA n ^ 2 + t ^ 2 / 4 := by positivity
    field_simp
    ring
  rw [funext hfun, ← hval]
  exact Complex.reCLM.hasSum hsub

/-- **The second classical input is a theorem**: Gauss' value `ψ(1/4) = -γ - 3 log 2 - π/2`,
proved in `RequestProject/Digamma.lean`. -/
theorem digammaQuarter : DigammaQuarter := by
  have hlog : Complex.log 2 = ((Real.log 2 : ℝ) : ℂ) :=
    (Complex.ofReal_log (by norm_num)).symm
  have h := digamma_quarter
  rw [hlog] at h
  have hcast : -((Real.eulerMascheroniConstant : ℝ) : ℂ) - 3 * ((Real.log 2 : ℝ) : ℂ)
      - ((π : ℝ) : ℂ) / 2
      = ((-Real.eulerMascheroniConstant - 3 * Real.log 2 - π / 2 : ℝ) : ℂ) := by
    push_cast
    ring
  rw [DigammaQuarter, h, hcast, Complex.ofReal_re]

/-! ## The spectral side -/

/-- `∫ e^{-b|u|} du = 2/b`. -/
theorem integral_expNegAbs {b : ℝ} (hb : 0 < b) :
    (∫ u : ℝ, ((Real.exp (-b * |u|) : ℝ) : ℂ)) = ((2 / b : ℝ) : ℂ) := by
  have h := fourierLog_expNegAbs hb 0
  rw [fourierLog, mellinLog] at h
  simp only [Complex.ofReal_zero, mul_zero, zero_mul, Complex.exp_zero, mul_one] at h
  rw [h]
  have hbc : (b : ℂ) ≠ 0 := by exact_mod_cast hb.ne'
  push_cast
  field_simp
  ring

theorem integrable_fourierLog_mul_poissonKernel {G : ℝ → ℂ} (hG : Integrable (fourierLog G))
    {b : ℝ} (hb : 0 < b) :
    Integrable (fun t : ℝ => fourierLog G t * ((2 * b / (b ^ 2 + t ^ 2) : ℝ) : ℂ)) := by
  refine Integrable.mono' (hG.norm.mul_const (2 / b)) ?_ (Filter.Eventually.of_forall fun t => ?_)
  · refine hG.aestronglyMeasurable.mul
      ((Complex.continuous_ofReal.comp ?_).aestronglyMeasurable)
    exact continuous_const.div (by fun_prop) (fun t => by positivity)
  · rw [norm_mul, Complex.norm_real, Real.norm_eq_abs,
      abs_of_nonneg (by positivity : (0:ℝ) ≤ 2 * b / (b ^ 2 + t ^ 2))]
    refine mul_le_mul_of_nonneg_left ?_ (norm_nonneg _)
    rw [div_le_div_iff₀ (by positivity) hb]
    nlinarith [sq_nonneg t, hb.le]

/-- The `n`-th term of the expansion, paired with a test function. -/
theorem integral_fourierLog_mul_digammaTerm {G : ℝ → ℂ} (hGc : Continuous G)
    (hGs : HasCompactSupport G) (hG : Integrable (fourierLog G)) (n : ℕ) :
    ((1 / (2 * π) : ℝ) : ℂ) * ∫ t : ℝ, fourierLog G t * ((digammaTerm n t : ℝ) : ℂ)
      = ∫ u : ℝ, (G 0 - G u) * ((Real.exp (-poleB n * |u|) : ℝ) : ℂ) := by
  have hGint : Integrable G := hGc.integrable_of_hasCompactSupport hGs
  have ha : 0 < poleA n := poleA_pos n
  have hb : 0 < poleB n := poleB_pos n
  have hab : poleB n = 2 * poleA n := poleB_eq n
  -- the term as a difference
  have hterm : ∀ t : ℝ, digammaTerm n t
      = 1 / poleA n - 2 * poleB n / ((poleB n) ^ 2 + t ^ 2) := by
    intro t
    rw [digammaTerm, hab]
    have h1 : (0:ℝ) < poleA n * ((poleA n) ^ 2 + t ^ 2 / 4) := by positivity
    have h2 : (0:ℝ) < (2 * poleA n) ^ 2 + t ^ 2 := by positivity
    field_simp
    ring
  have hsplit : (∫ t : ℝ, fourierLog G t * ((digammaTerm n t : ℝ) : ℂ))
      = ((1 / poleA n : ℝ) : ℂ) * (∫ t : ℝ, fourierLog G t)
        - ∫ t : ℝ, fourierLog G t * ((2 * poleB n / ((poleB n) ^ 2 + t ^ 2) : ℝ) : ℂ) := by
    rw [← integral_const_mul, ← integral_sub (hG.const_mul _)
      (integrable_fourierLog_mul_poissonKernel hG hb)]
    refine integral_congr_ae (Filter.Eventually.of_forall fun t => ?_)
    show fourierLog G t * ((digammaTerm n t : ℝ) : ℂ) = _
    rw [hterm t]
    push_cast
    ring
  -- the two pieces
  have hzero : ((1 / (2 * π) : ℝ) : ℂ) * (∫ t : ℝ, fourierLog G t) = G 0 := by
    have h := fourierLog_inversion hGc hGint hG 0
    simpa using h.symm
  have hpois := integral_fourierLog_mul_poisson hGc hGs hG hb
  have hconst : (∫ u : ℝ, G 0 * ((Real.exp (-poleB n * |u|) : ℝ) : ℂ))
      = ((1 / poleA n : ℝ) : ℂ) * G 0 := by
    rw [integral_const_mul, integral_expNegAbs hb]
    rw [hab]
    rw [show (2 / (2 * poleA n) : ℝ) = 1 / poleA n by field_simp]
    ring
  have hGkk : Integrable (fun u : ℝ => G u * ((Real.exp (-poleB n * |u|) : ℝ) : ℂ)) := by
    refine Integrable.mono' (hGint.norm) ?_ (Filter.Eventually.of_forall fun u => ?_)
    · exact hGint.aestronglyMeasurable.mul
        ((Complex.continuous_ofReal.comp (by fun_prop)).aestronglyMeasurable)
    · rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
      have hle : Real.exp (-poleB n * |u|) ≤ 1 := by
        rw [Real.exp_le_one_iff]
        have : 0 ≤ poleB n * |u| := by positivity
        linarith
      nlinarith [norm_nonneg (G u), (Real.exp_pos (-poleB n * |u|)).le]
  have hRHS : (∫ u : ℝ, (G 0 - G u) * ((Real.exp (-poleB n * |u|) : ℝ) : ℂ))
      = ((1 / poleA n : ℝ) : ℂ) * G 0
        - ∫ u : ℝ, G u * ((Real.exp (-poleB n * |u|) : ℝ) : ℂ) := by
    rw [← hconst, ← integral_sub ((integrable_expNegAbs hb).const_mul (G 0)) hGkk]
    refine integral_congr_ae (Filter.Eventually.of_forall fun u => ?_)
    ring
  have hfirst : ((1 / (2 * π) : ℝ) : ℂ) * (((1 / poleA n : ℝ) : ℂ) * ∫ t : ℝ, fourierLog G t)
      = ((1 / poleA n : ℝ) : ℂ) * G 0 := by
    rw [← hzero]; ring
  rw [hsplit, mul_sub, hfirst, hpois, hRHS]

/-! ### Elementary estimates on the terms and on the kernel -/

theorem continuous_digammaTerm (n : ℕ) : Continuous (digammaTerm n) := by
  have h := poleA_pos n
  refine Continuous.div (by fun_prop) (by fun_prop) (fun t => ?_)
  positivity

theorem digammaTerm_le (n : ℕ) (t : ℝ) : digammaTerm n t ≤ 1 / poleA n := by
  have h := poleA_pos n
  have hd : 0 < poleA n * ((poleA n) ^ 2 + t ^ 2 / 4) := by positivity
  rw [digammaTerm, div_le_div_iff₀ hd h]
  nlinarith [sq_nonneg t, sq_nonneg (poleA n)]

theorem digammaDiff_nonneg (t : ℝ) : 0 ≤ digammaDiff t :=
  (digammaPartialFractions t).nonneg (fun n => digammaTerm_nonneg n t)

theorem sum_digammaTerm_le (N : Finset ℕ) (t : ℝ) :
    ∑ n ∈ N, digammaTerm n t ≤ digammaDiff t :=
  sum_le_hasSum N (fun n _ => digammaTerm_nonneg n t) (digammaPartialFractions t)

theorem integrable_fourierLog_mul_digammaTerm_fn {G : ℝ → ℂ} (hG : Integrable (fourierLog G))
    (n : ℕ) : Integrable (fun t : ℝ => fourierLog G t * ((digammaTerm n t : ℝ) : ℂ)) := by
  have h := poleA_pos n
  refine Integrable.mono' (hG.norm.mul_const (1 / poleA n)) ?_
    (Filter.Eventually.of_forall fun t => ?_)
  · exact hG.aestronglyMeasurable.mul
      ((Complex.continuous_ofReal.comp (continuous_digammaTerm n)).aestronglyMeasurable)
  · rw [norm_mul, Complex.norm_real, Real.norm_eq_abs,
      abs_of_nonneg (digammaTerm_nonneg n t)]
    exact mul_le_mul_of_nonneg_left (digammaTerm_le n t) (norm_nonneg _)

/-- The series of the `L¹`-norms of the terms of the spectral side converges. -/
theorem summable_integral_norm_digammaTerm {G : ℝ → ℂ}
    (hG : Integrable (fourierLog G))
    (hGP : Integrable (fun t : ℝ => ‖fourierLog G t‖ * digammaDiff t)) :
    Summable (fun n : ℕ => ∫ t : ℝ, ‖fourierLog G t * ((digammaTerm n t : ℝ) : ℂ)‖) := by
  have hnorm : ∀ (n : ℕ) (t : ℝ), ‖fourierLog G t * ((digammaTerm n t : ℝ) : ℂ)‖
      = ‖fourierLog G t‖ * digammaTerm n t := by
    intro n t
    rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg (digammaTerm_nonneg n t)]
  have hint_n : ∀ n : ℕ, Integrable (fun t : ℝ => ‖fourierLog G t‖ * digammaTerm n t) :=
    fun n => ((integrable_fourierLog_mul_digammaTerm_fn hG n).norm).congr
      (Filter.Eventually.of_forall (hnorm n))
  refine summable_of_sum_range_le (c := ∫ t : ℝ, ‖fourierLog G t‖ * digammaDiff t)
    (fun n => integral_nonneg (fun t => norm_nonneg _)) (fun N => ?_)
  have hcongr : ∀ n : ℕ, (∫ t : ℝ, ‖fourierLog G t * ((digammaTerm n t : ℝ) : ℂ)‖)
      = ∫ t : ℝ, ‖fourierLog G t‖ * digammaTerm n t :=
    fun n => integral_congr_ae (Filter.Eventually.of_forall (hnorm n))
  simp only [hcongr]
  rw [← integral_finset_sum _ (fun n _ => hint_n n)]
  refine integral_mono (integrable_finset_sum _ (fun n _ => hint_n n)) hGP (fun t => ?_)
  rw [← Finset.mul_sum]
  exact mul_le_mul_of_nonneg_left (sum_digammaTerm_le _ t) (norm_nonneg _)

theorem integrable_expNegAbs_real {b : ℝ} (hb : 0 < b) :
    Integrable (fun u : ℝ => Real.exp (-b * |u|)) := by
  have h := (integrable_expNegAbs hb).re
  simpa only [Complex.ofReal_re] using h

/-- `κ(u) = a³/(a⁴-1)` with `a = e^{|u|/2}`. -/
theorem sinhKernel_eq_pow {u : ℝ} (hu : u ≠ 0) :
    sinhKernel u = Real.exp (|u| / 2) ^ 3 / (Real.exp (|u| / 2) ^ 4 - 1) := by
  have hpos : 0 < |u| := abs_pos.2 hu
  set a := Real.exp (|u| / 2) with ha
  have ha1 : 1 < a := by
    have := Real.exp_lt_exp.2 (show (0:ℝ) < |u| / 2 by linarith)
    rwa [Real.exp_zero] at this
  have ha0 : 0 < a := by linarith
  have h1 : Real.exp |u| = a ^ 2 := by rw [ha, ← Real.exp_nat_mul]; congr 1; ring
  have h2 : Real.exp (-|u|) = (a ^ 2)⁻¹ := by rw [Real.exp_neg, h1]
  have ha4 : 1 < a ^ 4 := one_lt_pow₀ ha1 (by norm_num)
  have ha2 : 1 < a ^ 2 := one_lt_pow₀ ha1 (by norm_num)
  have hd1 : a ^ 2 - (a ^ 2)⁻¹ ≠ 0 := by
    have : (a ^ 2)⁻¹ < 1 := by rw [inv_lt_one_iff₀]; right; exact ha2
    intro h; nlinarith
  rw [sinhKernel, h1, h2, ← ha, div_eq_div_iff hd1 (by intro h; nlinarith)]
  field_simp

/-- **The kernel `κ` decays exponentially**: `|u| κ(u) ≤ 5 e^{-|u|/4}`.  (Near `u = 0` the
kernel has a simple pole, which is exactly compensated by the factor `|u|`.) -/
theorem abs_mul_sinhKernel_le (u : ℝ) :
    |u| * sinhKernel u ≤ 5 * Real.exp (-(1/4) * |u|) := by
  rcases eq_or_ne u 0 with rfl | hu
  · simp [sinhKernel]
  have hpos : 0 < |u| := abs_pos.2 hu
  set s := |u| with hs
  set b := Real.exp (s / 4) with hbdef
  have hb1 : 1 + s / 4 ≤ b := by
    have := Real.add_one_le_exp (s / 4)
    linarith
  have hb0 : 0 < b := Real.exp_pos _
  have hab : Real.exp (s / 2) = b ^ 2 := by
    rw [hbdef, ← Real.exp_nat_mul]; congr 1; ring
  set a := Real.exp (s / 2) with ha
  have ha1 : 1 < a := by
    have := Real.exp_lt_exp.2 (show (0:ℝ) < s / 2 by linarith)
    rwa [Real.exp_zero] at this
  have ha4' : 1 + 2 * s ≤ a ^ 4 := by
    have h := Real.add_one_le_exp (2 * s)
    have he : Real.exp (2 * s) = a ^ 4 := by rw [ha, ← Real.exp_nat_mul]; congr 1; ring
    rw [he] at h; linarith
  have ha4 : 1 < a ^ 4 := one_lt_pow₀ ha1 (by norm_num)
  have hstep1 : s * sinhKernel u ≤ (1 + 2 * s) / (2 * a) := by
    rw [sinhKernel_eq_pow hu, ← ha, mul_div_assoc', div_le_div_iff₀ (by linarith) (by linarith)]
    nlinarith
  have hstep2 : (1 + 2 * s) / (2 * a) ≤ 5 * Real.exp (-(1/4) * s) := by
    have hexp : Real.exp (-(1/4) * s) = b⁻¹ := by
      rw [hbdef, ← Real.exp_neg]; congr 1; ring
    rw [hexp, hab, div_le_iff₀ (by positivity)]
    have h10 : 1 + 2 * s ≤ 10 * b := by nlinarith
    have hb : 5 * b⁻¹ * (2 * b ^ 2) = 10 * b := by field_simp; ring
    rw [hb]
    exact h10
  linarith

theorem measurable_sinhKernel : Measurable sinhKernel := by
  unfold sinhKernel
  fun_prop

/-- The `L¹`-majorant of the geometric side. -/
theorem integrable_norm_sub_mul_sinhKernel {G : ℝ → ℂ} (hGc : Continuous G) {C : ℝ}
    (hLip : ∀ u : ℝ, ‖G u - G 0‖ ≤ C * |u|) :
    Integrable (fun u : ℝ => ‖G 0 - G u‖ * sinhKernel u) := by
  have hexpint : Integrable (fun u : ℝ => Real.exp (-(1/4 : ℝ) * |u|)) :=
    integrable_expNegAbs_real (by norm_num)
  have hC : 0 ≤ C := by
    have h := hLip 1
    have h0 : (0:ℝ) ≤ ‖G 1 - G 0‖ := norm_nonneg _
    simpa using le_trans h0 (by simpa using h)
  refine Integrable.mono' (hexpint.const_mul (5 * C)) ?_ (Filter.Eventually.of_forall fun u => ?_)
  · exact (continuous_const.sub hGc).norm.aestronglyMeasurable.mul
      measurable_sinhKernel.aestronglyMeasurable
  · have hk : 0 ≤ sinhKernel u := sinhKernel_nonneg u
    have h1 : ‖G 0 - G u‖ ≤ C * |u| := by
      rw [← norm_neg]; simpa using hLip u
    have h2 : ‖G 0 - G u‖ * sinhKernel u ≤ (C * |u|) * sinhKernel u :=
      mul_le_mul_of_nonneg_right h1 hk
    have h3 : (C * |u|) * sinhKernel u ≤ C * (5 * Real.exp (-(1/4) * |u|)) := by
      rw [mul_assoc]
      exact mul_le_mul_of_nonneg_left (abs_mul_sinhKernel_le u) hC
    rw [Real.norm_eq_abs, abs_of_nonneg (by positivity : (0:ℝ) ≤ ‖G 0 - G u‖ * sinhKernel u)]
    linarith

theorem integrable_sub_mul_expNegAbs {G : ℝ → ℂ} (hGint : Integrable G) {b : ℝ} (hb : 0 < b) :
    Integrable (fun u : ℝ => (G 0 - G u) * ((Real.exp (-b * |u|) : ℝ) : ℂ)) := by
  have hk : Integrable (fun u : ℝ => ((Real.exp (-b * |u|) : ℝ) : ℂ)) := integrable_expNegAbs hb
  have hGk : Integrable (fun u : ℝ => G u * ((Real.exp (-b * |u|) : ℝ) : ℂ)) := by
    refine Integrable.mono' (hGint.norm) ?_ (Filter.Eventually.of_forall fun u => ?_)
    · exact hGint.aestronglyMeasurable.mul
        ((Complex.continuous_ofReal.comp (by fun_prop)).aestronglyMeasurable)
    · rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
      have hle : Real.exp (-b * |u|) ≤ 1 := by
        rw [Real.exp_le_one_iff]
        have : 0 ≤ b * |u| := by positivity
        linarith
      nlinarith [norm_nonneg (G u), (Real.exp_pos (-b * |u|)).le]
  refine ((hk.const_mul (G 0)).sub hGk).congr (Filter.Eventually.of_forall fun u => ?_)
  simp only [Pi.sub_apply]
  ring

/-- The series of the `L¹`-norms of the terms of the geometric side converges. -/
theorem summable_integral_norm_expNegAbs {G : ℝ → ℂ} (hGc : Continuous G)
    (hGint : Integrable G) {C : ℝ} (hLip : ∀ u : ℝ, ‖G u - G 0‖ ≤ C * |u|) :
    Summable (fun n : ℕ =>
      ∫ u : ℝ, ‖(G 0 - G u) * ((Real.exp (-poleB n * |u|) : ℝ) : ℂ)‖) := by
  have hnorm : ∀ (n : ℕ) (u : ℝ), ‖(G 0 - G u) * ((Real.exp (-poleB n * |u|) : ℝ) : ℂ)‖
      = ‖G 0 - G u‖ * Real.exp (-poleB n * |u|) := by
    intro n u
    rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
  have hint_n : ∀ n : ℕ, Integrable (fun u : ℝ => ‖G 0 - G u‖ * Real.exp (-poleB n * |u|)) :=
    fun n => ((integrable_sub_mul_expNegAbs hGint (poleB_pos n)).norm).congr
      (Filter.Eventually.of_forall (hnorm n))
  have hae : ∀ᵐ u : ℝ, u ≠ 0 := by rw [ae_iff]; simp
  refine summable_of_sum_range_le (c := ∫ u : ℝ, ‖G 0 - G u‖ * sinhKernel u)
    (fun n => integral_nonneg (fun u => norm_nonneg _)) (fun N => ?_)
  have hcongr : ∀ n : ℕ, (∫ u : ℝ, ‖(G 0 - G u) * ((Real.exp (-poleB n * |u|) : ℝ) : ℂ)‖)
      = ∫ u : ℝ, ‖G 0 - G u‖ * Real.exp (-poleB n * |u|) :=
    fun n => integral_congr_ae (Filter.Eventually.of_forall (hnorm n))
  simp only [hcongr]
  rw [← integral_finset_sum _ (fun n _ => hint_n n)]
  refine integral_mono_ae (integrable_finset_sum _ (fun n _ => hint_n n))
    (integrable_norm_sub_mul_sinhKernel hGc hLip) ?_
  filter_upwards [hae] with u hu
  rw [← Finset.mul_sum]
  refine mul_le_mul_of_nonneg_left ?_ (norm_nonneg _)
  exact sum_le_hasSum _ (fun n _ => (Real.exp_pos _).le) (hasSum_sinhKernel hu)

/-- **The spectral side of the archimedean explicit formula.**  Using the partial
fraction expansion of `ψ`, the pairing of `Ĝ` with `Re ψ(1/4+it/2) - ψ(1/4)` is the
integral of `G(0) - G(u)` against the kernel `κ`. -/
theorem integral_fourierLog_mul_digammaDiff {G : ℝ → ℂ}
    (hGc : Continuous G) (hGs : HasCompactSupport G) (hG : Integrable (fourierLog G))
    (hGP : Integrable (fun t : ℝ => ‖fourierLog G t‖ * digammaDiff t))
    {C : ℝ} (hLip : ∀ u : ℝ, ‖G u - G 0‖ ≤ C * |u|) :
    ((1 / (2 * π) : ℝ) : ℂ) * ∫ t : ℝ, fourierLog G t * ((digammaDiff t : ℝ) : ℂ)
      = ∫ u : ℝ, (G 0 - G u) * ((sinhKernel u : ℝ) : ℂ) := by
  have hGint : Integrable G := hGc.integrable_of_hasCompactSupport hGs
  have hae : ∀ᵐ u : ℝ, u ≠ 0 := by rw [ae_iff]; simp
  have hLsum : (∑' n : ℕ, ∫ t : ℝ, fourierLog G t * ((digammaTerm n t : ℝ) : ℂ))
      = ∫ t : ℝ, fourierLog G t * ((digammaDiff t : ℝ) : ℂ) := by
    rw [integral_tsum_of_summable_integral_norm
      (fun n => integrable_fourierLog_mul_digammaTerm_fn hG n)
      (summable_integral_norm_digammaTerm hG hGP)]
    refine integral_congr_ae (Filter.Eventually.of_forall fun t => ?_)
    exact ((Complex.ofRealCLM.hasSum (digammaPartialFractions t)).mul_left (fourierLog G t)).tsum_eq
  have hRsum : (∑' n : ℕ, ∫ u : ℝ, (G 0 - G u) * ((Real.exp (-poleB n * |u|) : ℝ) : ℂ))
      = ∫ u : ℝ, (G 0 - G u) * ((sinhKernel u : ℝ) : ℂ) := by
    rw [integral_tsum_of_summable_integral_norm
      (fun n => integrable_sub_mul_expNegAbs hGint (poleB_pos n))
      (summable_integral_norm_expNegAbs hGc hGint hLip)]
    refine integral_congr_ae ?_
    filter_upwards [hae] with u hu
    exact ((Complex.ofRealCLM.hasSum (hasSum_sinhKernel hu)).mul_left (G 0 - G u)).tsum_eq
  rw [← hLsum, ← hRsum, ← tsum_mul_left]
  exact tsum_congr (fun n => integral_fourierLog_mul_digammaTerm hGc hGs hG n)

/-! ### Measurability and integrability of the paired functions -/

theorem measurable_digammaDiff : Measurable digammaDiff := by
  have htend : Filter.Tendsto (fun N : ℕ => fun t : ℝ => ∑ n ∈ Finset.range N, digammaTerm n t)
      Filter.atTop (nhds digammaDiff) := by
    rw [tendsto_pi_nhds]
    intro t
    exact (digammaPartialFractions t).tendsto_sum_nat
  exact measurable_of_tendsto_metrizable
    (fun N => Finset.measurable_sum _ (fun n _ => (continuous_digammaTerm n).measurable)) htend

theorem integrable_fourierLog_mul_digammaDiff_fn {G : ℝ → ℂ}
    (hG : Integrable (fourierLog G))
    (hGP : Integrable (fun t : ℝ => ‖fourierLog G t‖ * digammaDiff t)) :
    Integrable (fun t : ℝ => fourierLog G t * ((digammaDiff t : ℝ) : ℂ)) := by
  refine Integrable.mono' hGP ?_ (Filter.Eventually.of_forall fun t => ?_)
  · exact hG.aestronglyMeasurable.mul
      ((Complex.continuous_ofReal.measurable.comp
        (measurable_digammaDiff)).aestronglyMeasurable)
  · rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg (digammaDiff_nonneg t)]

theorem integrable_sub_mul_sinhKernel {G : ℝ → ℂ} (hGc : Continuous G) {C : ℝ}
    (hLip : ∀ u : ℝ, ‖G u - G 0‖ ≤ C * |u|) :
    Integrable (fun u : ℝ => (G 0 - G u) * ((sinhKernel u : ℝ) : ℂ)) := by
  have h := integrable_norm_sub_mul_sinhKernel hGc hLip
  refine Integrable.mono' h ?_ (Filter.Eventually.of_forall fun u => ?_)
  · exact (continuous_const.sub hGc).aestronglyMeasurable.mul
      (Complex.continuous_ofReal.measurable.comp measurable_sinhKernel).aestronglyMeasurable
  · rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg (sinhKernel_nonneg u)]

/-- **The pairing with `κ` folded onto the half line** (`κ` is even). -/
theorem integral_sub_mul_sinhKernel_Ioi {G : ℝ → ℂ} (hGc : Continuous G) {C : ℝ}
    (hLip : ∀ u : ℝ, ‖G u - G 0‖ ≤ C * |u|) :
    (∫ u : ℝ, (G 0 - G u) * ((sinhKernel u : ℝ) : ℂ))
      = ∫ u in Ioi (0:ℝ), (2 * G 0 - G u - G (-u))
          * ((Real.exp (u / 2) / (Real.exp u - Real.exp (-u)) : ℝ) : ℂ) := by
  set F : ℝ → ℂ := fun u => (G 0 - G u) * ((sinhKernel u : ℝ) : ℂ) with hF
  have hint : Integrable F := integrable_sub_mul_sinhKernel hGc hLip
  have hsplit := intervalIntegral.integral_Iic_add_Ioi (f := F) (b := (0:ℝ)) (μ := volume)
    hint.integrableOn hint.integrableOn
  have hneg : (∫ u in Iic (0:ℝ), F u) = ∫ u in Ioi (0:ℝ), F (-u) := by
    rw [integral_comp_neg_Ioi (0:ℝ) F]
    norm_num
  rw [← hsplit, hneg, ← integral_add (hint.comp_neg).integrableOn hint.integrableOn]
  refine setIntegral_congr_fun measurableSet_Ioi (fun u hu => ?_)
  have hu' : (0:ℝ) < u := hu
  have habs : |u| = u := abs_of_pos hu'
  have hk : sinhKernel u = Real.exp (u / 2) / (Real.exp u - Real.exp (-u)) := by
    rw [sinhKernel, habs]
  have hkneg : sinhKernel (-u) = sinhKernel u := sinhKernel_even u
  simp only [hF, hkneg, hk]
  ring

/-- The elementary kernel `(e^{u/2}-1)/(e^u-e^{-u})` is integrable on `(0,∞)`. -/
theorem integrableOn_sinhKernelConst :
    IntegrableOn (fun u : ℝ => (Real.exp (u / 2) - 1) / (Real.exp u - Real.exp (-u)))
      (Ioi (0:ℝ)) := by
  have hdom : Integrable (fun u : ℝ => (5/2 : ℝ) * Real.exp (-(1/4 : ℝ) * |u|)) :=
    (integrable_expNegAbs_real (by norm_num)).const_mul _
  refine Integrable.mono' hdom.restrict (Measurable.aestronglyMeasurable (by fun_prop)) ?_
  refine (ae_restrict_iff' measurableSet_Ioi).2 (Filter.Eventually.of_forall fun u hu => ?_)
  have hu' : (0:ℝ) < u := hu
  have habs : |u| = u := abs_of_pos hu'
  have hDen : 0 < Real.exp u - Real.exp (-u) := by
    have : Real.exp (-u) < Real.exp u := Real.exp_lt_exp.2 (by linarith)
    linarith
  have h1 : 1 < Real.exp (u / 2) := by
    have := Real.exp_lt_exp.2 (show (0:ℝ) < u / 2 by linarith)
    rwa [Real.exp_zero] at this
  have hexp : Real.exp (u / 2) - 1 ≤ (u / 2) * Real.exp (u / 2) := by
    have h := Real.add_one_le_exp (-(u / 2))
    have hpos : 0 < Real.exp (u / 2) := Real.exp_pos _
    have hinv : Real.exp (-(u / 2)) = (Real.exp (u / 2))⁻¹ := Real.exp_neg _
    rw [hinv] at h
    have := mul_le_mul_of_nonneg_right h hpos.le
    rw [inv_mul_cancel₀ hpos.ne'] at this
    nlinarith
  have hk : |u| * sinhKernel u ≤ 5 * Real.exp (-(1/4) * |u|) := abs_mul_sinhKernel_le u
  have hkk : sinhKernel u = Real.exp (u / 2) / (Real.exp u - Real.exp (-u)) := by
    rw [sinhKernel, habs]
  rw [habs, hkk] at hk
  have h2 : (Real.exp (u / 2) - 1) / (Real.exp u - Real.exp (-u))
      ≤ ((u / 2) * Real.exp (u / 2)) / (Real.exp u - Real.exp (-u)) := by gcongr
  have h3 : ((u / 2) * Real.exp (u / 2)) / (Real.exp u - Real.exp (-u))
      = (1/2) * (u * (Real.exp (u / 2) / (Real.exp u - Real.exp (-u)))) := by field_simp
  rw [h3] at h2
  have hnn : 0 ≤ (Real.exp (u / 2) - 1) / (Real.exp u - Real.exp (-u)) :=
    div_nonneg (by linarith) hDen.le
  rw [Real.norm_eq_abs, abs_of_nonneg hnn, habs]
  linarith

/-! ## The geometric side -/

private theorem weilR_cov_aux (r : ℂ) (hr : r ≠ 0) (a b c : ℂ) :
    (r * r) * ((r⁻¹ * a + (r * r)⁻¹ * (r * b) - 2 * c / (r * r)) / ((r * r) - (r * r)⁻¹))
      = (r * (a + b) - 2 * c) / ((r * r) - (r * r)⁻¹) := by
  field_simp

/-- **The distribution (150) in the logarithmic coordinate**, in the `∆^{1/2}`
normalization used by the paper: for `f = ∆^{-1/2}(G ∘ log)`,

  `W_ℝ(f) = (log 4π + γ) G(0) + ∫₀^∞ (e^{u/2}(G(u)+G(-u)) - 2G(0)) du/(e^u - e^{-u})`. -/
theorem WeilR_deltaHalfInv_ofLog {G : ℝ → ℂ} :
    WeilR (deltaHalfInv (ofLog G))
      = ((Real.log (4 * π) + Real.eulerMascheroniConstant : ℝ) : ℂ) * G 0
        + ∫ u in Ioi (0:ℝ),
            (((Real.exp (u / 2) : ℝ) : ℂ) * (G u + G (-u)) - 2 * G 0)
              / ((Real.exp u - Real.exp (-u) : ℝ) : ℂ) := by
  have hone : deltaHalfInv (ofLog G) 1 = G 0 := by simp [deltaHalfInv, ofLog]
  set f : ℝ → ℂ := deltaHalfInv (ofLog G) with hf
  set g : ℝ → ℂ := fun x => (f x + sharp f x - 2 * f 1 / (x : ℂ)) / ((x : ℂ) - (x : ℂ)⁻¹)
    with hgdef
  have himg : Real.exp '' (Ioi 0) = Ioi 1 := by
    ext y
    constructor
    · rintro ⟨u, hu, rfl⟩
      exact one_lt_exp_iff.mpr hu
    · intro hy
      exact ⟨Real.log y, Real.log_pos hy, Real.exp_log (by linarith [hy.out])⟩
  have hderiv : ∀ u ∈ Ioi (0:ℝ), HasDerivWithinAt Real.exp (Real.exp u) (Ioi 0) u :=
    fun u _ => (Real.hasDerivAt_exp u).hasDerivWithinAt
  have hinj : Set.InjOn Real.exp (Ioi 0) := Real.exp_injective.injOn
  have hcov := MeasureTheory.integral_image_eq_integral_abs_deriv_smul measurableSet_Ioi
    hderiv hinj g
  have key : (∫ x in Ioi (1:ℝ), g x)
      = ∫ u in Ioi (0:ℝ), (((Real.exp (u / 2) : ℝ) : ℂ) * (G u + G (-u)) - 2 * G 0)
          / ((Real.exp u - Real.exp (-u) : ℝ) : ℂ) := by
    rw [← himg, hcov]
    refine setIntegral_congr_fun measurableSet_Ioi (fun u hu => ?_)
    have hu' : (0:ℝ) < u := hu
    have hsq : Real.sqrt (Real.exp u) = Real.exp (u / 2) := (Real.exp_half u).symm
    have hsqinv : Real.sqrt ((Real.exp u)⁻¹) = (Real.exp (u / 2))⁻¹ := by
      rw [← Real.exp_neg u, ← Real.exp_half (-u), show -u / 2 = -(u / 2) by ring, Real.exp_neg]
    have hrpos : (0:ℝ) < Real.exp (u / 2) := Real.exp_pos _
    have hr : ((Real.exp (u / 2) : ℝ) : ℂ) ≠ 0 := by exact_mod_cast ne_of_gt hrpos
    have hrr : ((Real.exp (u / 2) : ℝ) : ℂ) * ((Real.exp (u / 2) : ℝ) : ℂ)
        = ((Real.exp u : ℝ) : ℂ) := by
      rw [← Complex.ofReal_mul, ← Real.exp_add]; norm_num
    have hnegu : ((Real.exp (-u) : ℝ) : ℂ)
        = (((Real.exp (u / 2) : ℝ) : ℂ) * ((Real.exp (u / 2) : ℝ) : ℂ))⁻¹ := by
      rw [hrr, ← Complex.ofReal_inv, ← Real.exp_neg]
    have h1 : f (Real.exp u) = ((Real.exp (u / 2) : ℝ) : ℂ)⁻¹ * G u := by
      simp [hf, deltaHalfInv, ofLog, Real.exp_pos, hsq, Real.log_exp]
    have h2 : sharp f (Real.exp u)
        = (((Real.exp (u / 2) : ℝ) : ℂ) * ((Real.exp (u / 2) : ℝ) : ℂ))⁻¹
            * (((Real.exp (u / 2) : ℝ) : ℂ) * G (-u)) := by
      simp only [sharp, hf, deltaHalfInv, ofLog]
      rw [hrr, if_pos (by positivity : (0:ℝ) < (Real.exp u)⁻¹), hsqinv, Real.log_inv,
        Real.log_exp]
      push_cast
      field_simp
    have hdenR : ((Real.exp u - Real.exp (-u) : ℝ) : ℂ)
        = ((Real.exp (u / 2) : ℝ) : ℂ) * ((Real.exp (u / 2) : ℝ) : ℂ)
          - (((Real.exp (u / 2) : ℝ) : ℂ) * ((Real.exp (u / 2) : ℝ) : ℂ))⁻¹ := by
      rw [Complex.ofReal_sub, hnegu, hrr]
    simp only [hgdef, hone]
    rw [Complex.real_smul, abs_of_pos (Real.exp_pos u), h1, h2, hdenR, ← hrr]
    exact weilR_cov_aux _ hr _ _ _
  rw [WeilR, key, hone]

/-! ## The archimedean explicit formula -/

/-- **The archimedean explicit formula** (the `W_∞`-half of the Parseval identity (52)),
in the correct `∆^{1/2}` normalization, granted the two classical properties of the digamma
function. -/
theorem Winfty_deltaHalfInv_ofLog
    {G : ℝ → ℂ} (hGc : Continuous G) (hGs : HasCompactSupport G)
    (hG : Integrable (fourierLog G))
    (hGP : Integrable (fun t : ℝ => ‖fourierLog G t‖ * digammaDiff t))
    {C : ℝ} (hLip : ∀ u : ℝ, ‖G u - G 0‖ ≤ C * |u|) :
    Winfty (deltaHalfInv (ofLog G))
      = ((1 / (2 * π) : ℝ) : ℂ) * ∫ t : ℝ, fourierLog G t * ((2 * thetaDeriv t : ℝ) : ℂ) := by
  have hGint : Integrable G := hGc.integrable_of_hasCompactSupport hGs
  set S : ℂ := ∫ u : ℝ, (G 0 - G u) * ((sinhKernel u : ℝ) : ℂ) with hS
  set c : ℝ := (Complex.digamma (1 / 4 : ℂ)).re - Real.log π with hc
  -- the spectral side
  have hzero : ((1 / (2 * π) : ℝ) : ℂ) * (∫ t : ℝ, fourierLog G t) = G 0 := by
    have h := fourierLog_inversion hGc hGint hG 0
    simpa using h.symm
  have hthpt : ∀ t : ℝ, ((2 * thetaDeriv t : ℝ) : ℂ)
      = ((digammaDiff t : ℝ) : ℂ) + ((c : ℝ) : ℂ) := by
    intro t
    have h : (2 * thetaDeriv t : ℝ) = digammaDiff t + c := by
      simp only [thetaDeriv, digammaDiff, hc]
      ring
    rw [h]
    push_cast
    ring
  have hsplit : (∫ t : ℝ, fourierLog G t * ((2 * thetaDeriv t : ℝ) : ℂ))
      = (∫ t : ℝ, fourierLog G t * ((digammaDiff t : ℝ) : ℂ))
        + ((c : ℝ) : ℂ) * ∫ t : ℝ, fourierLog G t := by
    rw [← integral_const_mul,
      ← integral_add (integrable_fourierLog_mul_digammaDiff_fn hG hGP) (hG.const_mul _)]
    refine integral_congr_ae (Filter.Eventually.of_forall fun t => ?_)
    show fourierLog G t * ((2 * thetaDeriv t : ℝ) : ℂ) = _
    rw [hthpt t]
    ring
  have hRHS : ((1 / (2 * π) : ℝ) : ℂ) * ∫ t : ℝ, fourierLog G t * ((2 * thetaDeriv t : ℝ) : ℂ)
      = S + ((c : ℝ) : ℂ) * G 0 := by
    rw [hsplit, mul_add, integral_fourierLog_mul_digammaDiff hGc hGs hG hGP hLip, ← hS]
    congr 1
    rw [← mul_assoc, mul_comm (((1 / (2 * π) : ℝ) : ℂ)) (((c : ℝ) : ℂ)), mul_assoc, hzero]
  -- the geometric side
  have hAint : IntegrableOn (fun u : ℝ => (2 * G 0 - G u - G (-u))
      * ((Real.exp (u / 2) / (Real.exp u - Real.exp (-u)) : ℝ) : ℂ)) (Ioi (0:ℝ)) := by
    have hint : Integrable (fun u : ℝ => (G 0 - G u) * ((sinhKernel u : ℝ) : ℂ)) :=
      integrable_sub_mul_sinhKernel hGc hLip
    refine IntegrableOn.congr_fun ((hint.comp_neg).integrableOn.add hint.integrableOn)
      ?_ measurableSet_Ioi
    intro u hu
    have hu' : (0:ℝ) < u := hu
    have habs : |u| = u := abs_of_pos hu'
    have hk : sinhKernel u = Real.exp (u / 2) / (Real.exp u - Real.exp (-u)) := by
      rw [sinhKernel, habs]
    have hkneg : sinhKernel (-u) = sinhKernel u := sinhKernel_even u
    simp only [Pi.add_apply, hkneg, hk]
    ring
  have hBint : IntegrableOn (fun u : ℝ =>
      (((Real.exp (u / 2) - 1) / (Real.exp u - Real.exp (-u)) : ℝ) : ℂ)) (Ioi (0:ℝ)) :=
    integrableOn_sinhKernelConst.ofReal
  have hBval : (∫ u in Ioi (0:ℝ),
      (((Real.exp (u / 2) - 1) / (Real.exp u - Real.exp (-u)) : ℝ) : ℂ))
      = ((Real.log 2 / 2 + π / 4 : ℝ) : ℂ) := by
    have h := Complex.ofRealCLM.integral_comp_comm integrableOn_sinhKernelConst
    simp only [Complex.ofRealCLM_apply] at h
    rw [h, integral_sinhKernel_const]
  have hI : (∫ u in Ioi (0:ℝ),
        (((Real.exp (u / 2) : ℝ) : ℂ) * (G u + G (-u)) - 2 * G 0)
          / ((Real.exp u - Real.exp (-u) : ℝ) : ℂ))
      = 2 * G 0 * ((Real.log 2 / 2 + π / 4 : ℝ) : ℂ) - S := by
    have hcomb : (∫ u in Ioi (0:ℝ),
        (((Real.exp (u / 2) : ℝ) : ℂ) * (G u + G (-u)) - 2 * G 0)
          / ((Real.exp u - Real.exp (-u) : ℝ) : ℂ))
        = (∫ u in Ioi (0:ℝ), 2 * G 0 *
            (((Real.exp (u / 2) - 1) / (Real.exp u - Real.exp (-u)) : ℝ) : ℂ))
          - ∫ u in Ioi (0:ℝ), (2 * G 0 - G u - G (-u))
              * ((Real.exp (u / 2) / (Real.exp u - Real.exp (-u)) : ℝ) : ℂ) := by
      rw [← integral_sub (hBint.const_mul _) hAint]
      refine setIntegral_congr_fun measurableSet_Ioi (fun u hu => ?_)
      have hu' : (0:ℝ) < u := hu
      have hDpos : (0:ℝ) < Real.exp u - Real.exp (-u) := by
        have : Real.exp (-u) < Real.exp u := Real.exp_lt_exp.2 (by linarith)
        linarith
      have hDne : ((Real.exp u - Real.exp (-u) : ℝ) : ℂ) ≠ 0 := by exact_mod_cast hDpos.ne'
      push_cast
      field_simp
      ring
    rw [hcomb, integral_const_mul, hBval, hS, integral_sub_mul_sinhKernel_Ioi hGc hLip]
  -- the constants cancel
  have hlog : Real.log (4 * π) = 2 * Real.log 2 + Real.log π := by
    rw [Real.log_mul (by norm_num) Real.pi_ne_zero]
    congr 1
    rw [show (4:ℝ) = 2 ^ 2 by norm_num, Real.log_pow]
    push_cast
    ring
  have hconst : -(Real.log (4 * π) + Real.eulerMascheroniConstant)
      - 2 * (Real.log 2 / 2 + π / 4) = c := by
    rw [hc, digammaQuarter, hlog]
    ring
  have hconstC : ((-(Real.log (4 * π) + Real.eulerMascheroniConstant)
      - 2 * (Real.log 2 / 2 + π / 4) : ℝ) : ℂ) = ((c : ℝ) : ℂ) := by
    exact_mod_cast congrArg (fun x : ℝ => (x : ℂ)) hconst
  rw [Winfty, WeilR_deltaHalfInv_ofLog, hI, hRHS]
  push_cast at hconstC ⊢
  linear_combination (G 0) * hconstC

/-- **The corrected `W_∞`-half of the Parseval identity (52)**: the archimedean explicit
formula, for test functions in the logarithmic coordinate, with the `∆^{1/2}`
normalization of the paper. -/
def WinftyParsevalNorm : Prop :=
  ∀ G : ℝ → ℂ, Continuous G → HasCompactSupport G → Integrable (fourierLog G) →
    Integrable (fun t : ℝ => ‖fourierLog G t‖ * digammaDiff t) →
    (∃ C : ℝ, ∀ u : ℝ, ‖G u - G 0‖ ≤ C * |u|) →
      Winfty (deltaHalfInv (ofLog G))
        = ((1 / (2 * π) : ℝ) : ℂ) * ∫ t : ℝ, fourierLog G t * ((2 * thetaDeriv t : ℝ) : ℂ)

/-- **The archimedean explicit formula holds** (unconditionally: the two classical facts
about the digamma function it uses are proved in `RequestProject/Digamma.lean`). -/
theorem WinftyParsevalNorm_of_digamma : WinftyParsevalNorm := by
  rintro G hGc hGs hG hGP ⟨C, hLip⟩
  exact Winfty_deltaHalfInv_ofLog hGc hGs hG hGP hLip

/-! ## The threshold of the Fourier-side inequality at the origin -/

/-- By Gauss' value `ψ(1/4) = -γ - 3 log 2 - π/2`, the right-hand side of the
Fourier-side inequality at the origin is `log π + γ + 3 log 2 + π/2` (numerically
`≈ 5.3721834`). -/
theorem fourierSide_threshold_eq :
    Real.log π - (Complex.digamma (1 / 4 : ℂ)).re
      = Real.log π + Real.eulerMascheroniConstant + 3 * Real.log 2 + π / 2 := by
  rw [digammaQuarter]
  ring

/-- The value of `2θ' + δ̂` at the origin in closed form, by Gauss' value of `ψ(1/4)`. -/
theorem fourierSide_zero_eq :
    fourierSide 0
      = deltaFourier 0 - (Real.log π + Real.eulerMascheroniConstant + 3 * Real.log 2 + π / 2) := by
  rw [fourierSide_zero, fourierSide_threshold_eq]

/-! ## The Parseval identity (52) in the normalization of the paper -/

theorem integrable_fourierLog_mul_thetaDeriv {G : ℝ → ℂ}
    (hG : Integrable (fourierLog G))
    (hGP : Integrable (fun t : ℝ => ‖fourierLog G t‖ * digammaDiff t)) :
    Integrable (fun t : ℝ => fourierLog G t * ((2 * thetaDeriv t : ℝ) : ℂ)) := by
  set c : ℝ := (Complex.digamma (1 / 4 : ℂ)).re - Real.log π with hc
  refine ((integrable_fourierLog_mul_digammaDiff_fn hG hGP).add
    (hG.const_mul ((c : ℝ) : ℂ))).congr (Filter.Eventually.of_forall fun t => ?_)
  have h : (2 * thetaDeriv t : ℝ) = digammaDiff t + c := by
    simp only [thetaDeriv, digammaDiff, hc]
    ring
  simp only [Pi.add_apply, h]
  push_cast
  ring

/-- **The functional `L = D + W_∞`** of §2 of the paper, in the logarithmic coordinate and
in the `∆^{1/2}` normalization: the archimedean term is the distribution (150) applied to
`∆^{-1/2} f`, as the paper prescribes. -/
def LfunNorm (G : ℝ → ℂ) : ℂ := Dcomplex (ofLog G) + Winfty (deltaHalfInv (ofLog G))

/-- **The Parseval identity (52) of the paper**: `L(f) = (2π)⁻¹ ∫ f̂(t) (2θ'(t) + δ̂(t)) dt`.
The `W_∞`-half is no longer a hypothesis: it is the archimedean explicit formula proved
above, and the two digamma inputs it uses are theorems. -/
theorem LfunNorm_parseval {G : ℝ → ℂ}
    (hGc : Continuous G) (hGs : HasCompactSupport G) (hG : Integrable (fourierLog G))
    (hGP : Integrable (fun t : ℝ => ‖fourierLog G t‖ * digammaDiff t))
    {C : ℝ} (hLip : ∀ u : ℝ, ‖G u - G 0‖ ≤ C * |u|) :
    LfunNorm G = ((1 / (2 * π) : ℝ) : ℂ)
      * ∫ t : ℝ, fourierLog G t * ((2 * thetaDeriv t + deltaFourier t : ℝ) : ℂ) := by
  have hsum : (∫ t : ℝ, fourierLog G t * ((2 * thetaDeriv t + deltaFourier t : ℝ) : ℂ))
      = (∫ t : ℝ, fourierLog G t * ((2 * thetaDeriv t : ℝ) : ℂ))
        + ∫ t : ℝ, fourierLog G t * ((deltaFourier t : ℝ) : ℂ) := by
    rw [← integral_add (integrable_fourierLog_mul_thetaDeriv hG hGP)
      (integrable_fourierLog_mul_deltaFourier hG)]
    refine integral_congr_ae (Filter.Eventually.of_forall fun t => ?_)
    push_cast
    ring
  rw [LfunNorm, Dcomplex_parseval hGc hGs hG,
    Winfty_deltaHalfInv_ofLog hGc hGs hG hGP hLip, hsum]
  ring

/-- **Corollary 2.3 (i) of the paper in the normalization of the paper**, on test functions
with integrable transform: granted the Fourier-side inequality `2θ' + δ̂ ≥ 0`, the
functional `L` is nonnegative on positive definite test functions. -/
theorem LfunNorm_re_nonneg_of_fourierSide_nonneg
    (hpos : ∀ t : ℝ, 0 ≤ 2 * thetaDeriv t + deltaFourier t) {G : ℝ → ℂ}
    (hGc : Continuous G) (hGs : HasCompactSupport G) (hG : Integrable (fourierLog G))
    (hGP : Integrable (fun t : ℝ => ‖fourierLog G t‖ * digammaDiff t))
    {C : ℝ} (hLip : ∀ u : ℝ, ‖G u - G 0‖ ≤ C * |u|)
    (hpd : PositiveDefiniteLog G) :
    0 ≤ (LfunNorm G).re := by
  have hint : Integrable
      (fun t : ℝ => fourierLog G t * ((2 * thetaDeriv t + deltaFourier t : ℝ) : ℂ)) := by
    refine ((integrable_fourierLog_mul_thetaDeriv hG hGP).add
      (integrable_fourierLog_mul_deltaFourier hG)).congr (Filter.Eventually.of_forall fun t => ?_)
    simp only [Pi.add_apply]
    push_cast
    ring
  have hre : (∫ t : ℝ, fourierLog G t * ((2 * thetaDeriv t + deltaFourier t : ℝ) : ℂ)).re
      = ∫ t : ℝ, (fourierLog G t).re * (2 * thetaDeriv t + deltaFourier t) := by
    have hri := integral_re hint
    simp only [RCLike.re_to_complex] at hri
    rw [← hri]
    refine integral_congr_ae (Filter.Eventually.of_forall fun t => ?_)
    simp [Complex.mul_re]
  have hnn : 0 ≤ ∫ t : ℝ, (fourierLog G t).re * (2 * thetaDeriv t + deltaFourier t) :=
    integral_nonneg fun t => mul_nonneg (hpd t) (hpos t)
  rw [LfunNorm_parseval hGc hGs hG hGP hLip, Complex.re_ofReal_mul, hre]
  have hpi : (0:ℝ) < 1 / (2 * π) := by positivity
  exact mul_nonneg hpi.le hnn

end ConnesConsani.WeilPositivity
