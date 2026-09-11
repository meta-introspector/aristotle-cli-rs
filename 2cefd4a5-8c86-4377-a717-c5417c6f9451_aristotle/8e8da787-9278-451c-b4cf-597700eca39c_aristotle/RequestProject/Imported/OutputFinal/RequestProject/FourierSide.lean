/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The Fourier side of §2 of

  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771.

Corollary 2.3 of the paper states that the Fourier transform of the distribution `L`
of formula (51) is the function `2θ'(t) + δ̂(t)`, where `θ` is the Riemann–Siegel angular
function and `δ̂` is the Fourier transform of the trace remainder `δ` on the multiplicative
group, and that the positivity of `L` is *equivalent* to the pointwise inequality
`2θ'(t) + δ̂(t) ≥ 0`.

This file constructs the two functions and develops the elementary reductions of the
inequality.  The inequality itself, `0 ≤ fourierSide t` for every real `t`, is **proved**
in `RequestProject/PolyaLowThreshold.lean`, which needs the whole Pólya-model machinery and
therefore cannot be placed here.  This file contains no `sorry`: the implication from the
Fourier-side inequality to the positivity of `L` in the *unnormalized* pairing of
`LPositivity` is not provable (see the discussion at the end of the file), and the
corresponding statement in the `∆^{1/2}` normalization of the paper is proved
unconditionally in `RequestProject/ArchimedeanPositivity.lean` and
`RequestProject/NormalizedPositivity.lean`.
-/
import RequestProject.Imported.OutputFinal.RequestProject.Positivity
import RequestProject.Imported.OutputFinal.RequestProject.DigammaAsymptotic

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

/-! ## The derivative of the Riemann–Siegel angular function

The Riemann–Siegel angular function is
`θ(E) = -(E/2) log π + Im log Γ(1/4 + iE/2)`, formula (154) of the paper, and the paper
uses (Appendix B) that its derivative is

  `2 θ'(t) = -log π + Re ψ(1/4 + i t/2)`,   `ψ = Γ'/Γ`.

We take this formula as the definition of `θ'`, using Mathlib's `Complex.digamma`. -/

/-- **The derivative of the Riemann–Siegel angular function**,
`θ'(t) = (Re ψ(1/4 + i t/2) - log π)/2`, where `ψ = Γ'/Γ` is the digamma function. -/
def thetaDeriv (t : ℝ) : ℝ :=
  (Complex.digamma (1 / 4 + Complex.I * t / 2)).re / 2 - Real.log π / 2

/-- The digamma function commutes with complex conjugation on the right half plane (a form
of the Schwarz reflection principle for `Γ`). -/
theorem digamma_conj {s : ℂ} (hs : 0 < s.re) :
    Complex.digamma (starRingEnd ℂ s) = starRingEnd ℂ (Complex.digamma s) := by
  have hne : ∀ m : ℕ, s ≠ -(m : ℂ) := by
    intro m h
    rw [h] at hs
    simp at hs
    linarith [hs]
  have hd : DifferentiableAt ℂ Complex.Gamma s := Complex.differentiableAt_Gamma s hne
  have h2 := hd.hasDerivAt.conj_conj
  have h3 : (⇑(starRingEnd ℂ) ∘ Complex.Gamma ∘ ⇑(starRingEnd ℂ)) = Complex.Gamma := by
    funext z
    simp [Function.comp, Complex.Gamma_conj]
  rw [h3] at h2
  simp only [Complex.digamma, logDeriv_apply, h2.deriv, Complex.Gamma_conj, map_div₀]

/-- **`θ'` is an even function** (§2 of the paper). -/
theorem thetaDeriv_even (t : ℝ) : thetaDeriv (-t) = thetaDeriv t := by
  have hz : (1 / 4 + Complex.I * ((-t : ℝ) : ℂ) / 2)
      = starRingEnd ℂ (1 / 4 + Complex.I * (t : ℂ) / 2) := by
    simp only [map_add, map_div₀, map_mul, Complex.conj_I, map_one, map_ofNat,
      Complex.conj_ofReal, Complex.ofReal_neg]
    ring
  have hre : ((1 / 4 + Complex.I * (t : ℂ) / 2) : ℂ).re = 1 / 4 := by simp
  rw [thetaDeriv, thetaDeriv, hz, digamma_conj (by rw [hre]; norm_num), Complex.conj_re]

/-- **`θ'` is continuous.**  (It is in fact real analytic: `Γ` is analytic and zero free on
the half plane `Re z > 0`, which contains the line `1/4 + i t/2`.) -/
theorem continuous_thetaDeriv : Continuous thetaDeriv := by
  set U : Set ℂ := {z : ℂ | 0 < z.re} with hUdef
  have hU : IsOpen U := isOpen_lt continuous_const Complex.continuous_re
  have hne : ∀ z ∈ U, ∀ m : ℕ, z ≠ -(m : ℂ) := by
    intro z hz m h
    have hz' : 0 < z.re := hz
    rw [h] at hz'
    simp at hz'
    linarith [hz']
  have hΓ : DifferentiableOn ℂ Complex.Gamma U := fun z hz =>
    (Complex.differentiableAt_Gamma z (hne z hz)).differentiableWithinAt
  have hA : AnalyticOnNhd ℂ Complex.Gamma U := hΓ.analyticOnNhd hU
  have hcont : ContinuousOn Complex.digamma U := by
    have h : ContinuousOn (fun z => deriv Complex.Gamma z / Complex.Gamma z) U :=
      hA.deriv.continuousOn.div hA.continuousOn fun z hz => Complex.Gamma_ne_zero (hne z hz)
    simpa [Complex.digamma, logDeriv_apply] using h
  have hg : Continuous (fun t : ℝ => (1 / 4 + Complex.I * t / 2 : ℂ)) := by fun_prop
  have hmaps : ∀ t : ℝ, (1 / 4 + Complex.I * t / 2 : ℂ) ∈ U := by
    intro t
    show 0 < ((1 / 4 + Complex.I * t / 2 : ℂ)).re
    simp
  exact ((Complex.continuous_re.comp (hcont.comp_continuous hg hmaps)).div_const 2).sub
    continuous_const

/-- **The classical asymptotic `θ'(t) ~ (1/2) log (t/2π)`** (Stirling's formula for the
digamma function).  It follows from the vertical-line asymptotic
`Re ψ(a + i b) - log b → 0` proved in `RequestProject/DigammaAsymptotic.lean`, applied with
`a = 1/4` and `b = t/2`. -/
theorem thetaDeriv_asymptotic :
    Filter.Tendsto (fun t : ℝ => thetaDeriv t - Real.log (t / (2 * π)) / 2)
      Filter.atTop (nhds 0) := by
  have hhalf : Filter.Tendsto (fun t : ℝ => t / 2) Filter.atTop Filter.atTop :=
    Filter.Tendsto.atTop_div_const (by norm_num) Filter.tendsto_id
  have hbase := (tendsto_digamma_re_sub_log (a := (1/4 : ℝ)) (by norm_num)).comp hhalf
  have hscaled := hbase.const_mul ((1 : ℝ) / 2)
  rw [mul_zero] at hscaled
  refine hscaled.congr' ?_
  filter_upwards [Filter.eventually_gt_atTop (0 : ℝ)] with t ht
  have harg : ((1 / 4 : ℝ) : ℂ) + Complex.I * ((t / 2 : ℝ) : ℂ)
      = 1 / 4 + Complex.I * (t : ℂ) / 2 := by
    push_cast
    ring
  have hlog : Real.log (t / (2 * π)) = Real.log (t / 2) - Real.log π := by
    rw [show t / (2 * π) = (t / 2) / π by ring, Real.log_div (by positivity) Real.pi_ne_zero]
  simp only [Function.comp_apply, harg]
  rw [thetaDeriv, hlog]
  ring

/-! ## The Fourier transform `δ̂` of the trace remainder -/

/-- **The Fourier transform of the trace remainder** on the multiplicative group,
`δ̂(t) = ∫ δ(ρ) ρ^{-it} d*ρ` (Corollary 2.3 (ii) of the paper).  Written in the logarithmic
coordinate `ρ = e^u`, and using that `δ` is invariant under `ρ ↦ ρ⁻¹`, the transform is the
cosine transform of `δ`; in particular it is real valued. -/
def deltaFourier (t : ℝ) : ℝ := ∫ u : ℝ, delta (Rplus.expHomeo u) * Real.cos (t * u)

theorem integrable_delta_log : Integrable (fun u : ℝ => delta (Rplus.expHomeo u)) volume :=
  (Rplus.integrable_haar_iff delta).1 delta_integrable

/-- `δ` times a bounded continuous function is integrable, by the decay `δ(ρ) = O(ρ^{-1/2})`
proved in `RequestProject/TraceRemainder.lean`. -/
theorem integrable_delta_log_mul {g : ℝ → ℝ} (hg : Continuous g) (hb : ∀ u, |g u| ≤ 1) :
    Integrable (fun u : ℝ => delta (Rplus.expHomeo u) * g u) volume := by
  refine Integrable.mono' integrable_delta_log
    ((delta_continuous.comp Rplus.expHomeo.continuous).mul hg).aestronglyMeasurable ?_
  filter_upwards with u
  rw [Real.norm_eq_abs, abs_mul, abs_of_pos (delta_pos _)]
  nlinarith [hb u, abs_nonneg (g u), (delta_pos (Rplus.expHomeo u)).le]

/-- The sine transform of `δ` vanishes, `δ` being invariant under `ρ ↦ ρ⁻¹`. -/
theorem integral_delta_log_mul_sin (t : ℝ) :
    (∫ u : ℝ, delta (Rplus.expHomeo u) * Real.sin (t * u)) = 0 := by
  set f : ℝ → ℝ := fun u => delta (Rplus.expHomeo u) * Real.sin (t * u) with hf
  have hodd : ∀ u : ℝ, f (-u) = -f u := by
    intro u
    show delta (Rplus.expHomeo (-u)) * Real.sin (t * -u)
      = -(delta (Rplus.expHomeo u) * Real.sin (t * u))
    rw [delta_expHomeo_neg, show t * -u = -(t * u) by ring, Real.sin_neg]
    ring
  have h1 : (∫ u : ℝ, f (-u)) = ∫ u : ℝ, f u := integral_neg_eq_self f volume
  rw [show (fun u : ℝ => f (-u)) = fun u => -f u from funext hodd, integral_neg] at h1
  linarith

/-- `δ̂` is even. -/
theorem deltaFourier_even (t : ℝ) : deltaFourier (-t) = deltaFourier t := by
  simp only [deltaFourier, neg_mul, Real.cos_neg]

/-- `δ̂` is continuous, by dominated convergence with the integrable dominating function `δ`. -/
theorem continuous_deltaFourier : Continuous deltaFourier := by
  refine continuous_of_dominated (bound := fun u : ℝ => delta (Rplus.expHomeo u))
    (fun t => (integrable_delta_log_mul (by fun_prop)
      fun u => Real.abs_cos_le_one _).aestronglyMeasurable)
    (fun t => Filter.Eventually.of_forall fun u => ?_) integrable_delta_log
    (Filter.Eventually.of_forall fun u => by fun_prop)
  rw [Real.norm_eq_abs, abs_mul, abs_of_pos (delta_pos _)]
  nlinarith [Real.abs_cos_le_one (t * u), abs_nonneg (Real.cos (t * u)),
    (delta_pos (Rplus.expHomeo u)).le]

/-- **`δ̂` is the Fourier–Mellin transform of `δ` on the unitary characters.**  This
identifies the cosine transform used as definition with the transform
`∫ δ(ρ) ρ^{-it} d*ρ` of the paper (the two agree because `δ` is even). -/
theorem mellinLog_delta_eq_deltaFourier (t : ℝ) :
    mellinLog (fun u => ((delta (Rplus.expHomeo u) : ℝ) : ℂ)) (Complex.I * t)
      = ((deltaFourier t : ℝ) : ℂ) := by
  have hpt : ∀ u : ℝ, ((delta (Rplus.expHomeo u) : ℝ) : ℂ) * Complex.exp (Complex.I * t * u)
      = ((delta (Rplus.expHomeo u) * Real.cos (t * u) : ℝ) : ℂ)
        + ((delta (Rplus.expHomeo u) * Real.sin (t * u) : ℝ) : ℂ) * Complex.I := by
    intro u
    have hexp : Complex.exp (Complex.I * t * u) = ((Real.cos (t * u) : ℝ) : ℂ)
        + ((Real.sin (t * u) : ℝ) : ℂ) * Complex.I := by
      rw [show Complex.I * (t : ℂ) * (u : ℂ) = ((t * u : ℝ) : ℂ) * Complex.I by push_cast; ring,
        Complex.exp_mul_I, Complex.ofReal_cos, Complex.ofReal_sin]
    rw [hexp]
    push_cast
    ring
  have hcos : Integrable (fun u : ℝ => delta (Rplus.expHomeo u) * Real.cos (t * u)) volume :=
    integrable_delta_log_mul (by fun_prop) fun u => Real.abs_cos_le_one _
  have hsin : Integrable (fun u : ℝ => delta (Rplus.expHomeo u) * Real.sin (t * u)) volume :=
    integrable_delta_log_mul (by fun_prop) fun u => Real.abs_sin_le_one _
  have hcosC : Integrable
      (fun a : ℝ => ((delta (Rplus.expHomeo a) * Real.cos (t * a) : ℝ) : ℂ)) volume := hcos.ofReal
  have hsinC : Integrable
      (fun a : ℝ => ((delta (Rplus.expHomeo a) * Real.sin (t * a) : ℝ) : ℂ) * Complex.I) volume :=
    (hsin.ofReal : Integrable
      (fun a : ℝ => ((delta (Rplus.expHomeo a) * Real.sin (t * a) : ℝ) : ℂ)) volume).mul_const
      Complex.I
  rw [mellinLog, integral_congr_ae (Filter.Eventually.of_forall hpt),
    integral_add hcosC hsinC, integral_mul_const, integral_complex_ofReal,
    integral_complex_ofReal, integral_delta_log_mul_sin]
  simp [deltaFourier]

/-- `δ̂` is positive at `t = 0`, `δ` being a positive function. -/
theorem deltaFourier_zero_pos : 0 < deltaFourier 0 := by
  have h : deltaFourier 0 = ∫ u : ℝ, delta (Rplus.expHomeo u) := by
    simp [deltaFourier]
  rw [h]
  refine (integral_pos_iff_support_of_nonneg (fun u => (delta_pos _).le) integrable_delta_log).2 ?_
  have hsupp : Function.support (fun u : ℝ => delta (Rplus.expHomeo u)) = univ := by
    ext u
    simp [Function.mem_support, ne_of_gt (delta_pos (Rplus.expHomeo u))]
  rw [hsupp]
  simp

/-- `∫ e^{-|u|/2} du = 4`. -/
theorem integral_exp_neg_half_abs_eq : (∫ u : ℝ, Real.exp (-(|u| / 2))) = 4 := by
  have h1 : IntegrableOn (fun u : ℝ => Real.exp (-(|u| / 2))) (Iic 0) volume :=
    integrable_exp_neg_half_abs.integrableOn
  have h2 : IntegrableOn (fun u : ℝ => Real.exp (-(|u| / 2))) (Ioi 0) volume :=
    integrable_exp_neg_half_abs.integrableOn
  have hIic : (∫ u in Iic (0:ℝ), Real.exp (-(|u| / 2))) = 2 := by
    rw [show (∫ u in Iic (0:ℝ), Real.exp (-(|u| / 2)))
        = ∫ u in Iic (0:ℝ), Real.exp ((1 / 2) * u) from
      setIntegral_congr_fun measurableSet_Iic fun u hu => by
        rw [abs_of_nonpos hu]; ring_nf,
      integral_exp_mul_Iic (a := (1 / 2 : ℝ)) (by norm_num)]
    norm_num
  have hIoi : (∫ u in Ioi (0:ℝ), Real.exp (-(|u| / 2))) = 2 := by
    rw [show (∫ u in Ioi (0:ℝ), Real.exp (-(|u| / 2)))
        = ∫ u in Ioi (0:ℝ), Real.exp (-(1 / 2) * u) from
      setIntegral_congr_fun measurableSet_Ioi fun u hu => by
        rw [abs_of_pos hu]; ring_nf,
      integral_exp_mul_Ioi (a := -(1 / 2 : ℝ)) (by norm_num)]
    norm_num
  rw [← intervalIntegral.integral_Iic_add_Ioi h1 h2, hIic, hIoi]
  norm_num

/-- **An explicit bound for `δ̂(0) = ∫ δ`**, from the decay bound
`δ(e^u) ≤ (4 Si π + 4) e^{-|u|/2}`. -/
theorem deltaFourier_zero_le : deltaFourier 0 ≤ 16 * Si π + 16 := by
  have hval : deltaFourier 0 = ∫ u : ℝ, delta (Rplus.expHomeo u) := by
    simp [deltaFourier]
  have hbound : Integrable (fun u : ℝ => (4 * Si π + 4) * Real.exp (-(|u| / 2))) volume :=
    integrable_exp_neg_half_abs.const_mul _
  have hle : (∫ u : ℝ, delta (Rplus.expHomeo u))
      ≤ ∫ u : ℝ, (4 * Si π + 4) * Real.exp (-(|u| / 2)) :=
    integral_mono integrable_delta_log hbound fun u => delta_expHomeo_le u
  rw [hval]
  refine hle.trans (le_of_eq ?_)
  rw [integral_const_mul, integral_exp_neg_half_abs_eq]
  ring

/-- The same bound with the elementary constant `Si π ≤ π`: `δ̂(0) ≤ 16π + 16`. -/
theorem deltaFourier_zero_le_pi : deltaFourier 0 ≤ 16 * π + 16 := by
  have hSi : Si π ≤ π := Si_le_self Real.pi_pos.le
  have := deltaFourier_zero_le
  linarith

/-- **`δ̂` attains its maximum modulus at the origin**: `|δ̂(t)| ≤ δ̂(0)`, because `δ > 0`.
This crude bound does not decay; the decaying bound `|δ̂(t)| ≤ 32 π e^{π/(2|t|)}/|t|` is
proved in `RequestProject/DeltaDecay.lean` (`abs_deltaFourier_le_decay`). -/
theorem abs_deltaFourier_le (t : ℝ) : |deltaFourier t| ≤ deltaFourier 0 := by
  have hle : ‖∫ u : ℝ, delta (Rplus.expHomeo u) * Real.cos (t * u)‖
      ≤ ∫ u : ℝ, ‖delta (Rplus.expHomeo u) * Real.cos (t * u)‖ :=
    norm_integral_le_integral_norm _
  have heq : (∫ u : ℝ, ‖delta (Rplus.expHomeo u) * Real.cos (t * u)‖)
      ≤ ∫ u : ℝ, delta (Rplus.expHomeo u) := by
    refine integral_mono ((integrable_delta_log_mul (by fun_prop)
      (fun u => Real.abs_cos_le_one _)).norm) integrable_delta_log fun u => ?_
    rw [Real.norm_eq_abs, abs_mul, abs_of_pos (delta_pos _)]
    nlinarith [Real.abs_cos_le_one (t * u), abs_nonneg (Real.cos (t * u)),
      (delta_pos (Rplus.expHomeo u)).le]
  have h0 : deltaFourier 0 = ∫ u : ℝ, delta (Rplus.expHomeo u) := by simp [deltaFourier]
  rw [deltaFourier, h0]
  exact hle.trans heq

/-! ## The Fourier-side positivity -/

/-- **The function `2θ' + δ̂`** of Corollary 2.3 of the paper: the Fourier transform of the
distribution defining the functional `L = D + W_∞` (see `RequestProject/Parseval.lean` for
the Parseval identity (52) that makes this precise). -/
def fourierSide (t : ℝ) : ℝ := 2 * thetaDeriv t + deltaFourier t

/-- `2θ' + δ̂` is even, both summands being even. -/
theorem fourierSide_even (t : ℝ) : fourierSide (-t) = fourierSide t := by
  rw [fourierSide, fourierSide, thetaDeriv_even, deltaFourier_even]

/-- `2θ' + δ̂` is continuous. -/
theorem continuous_fourierSide : Continuous fourierSide :=
  (continuous_const.mul continuous_thetaDeriv).add continuous_deltaFourier

/-- **The reduction of the Fourier-side inequality to a single value at the origin.**
Since `2θ' + δ̂` is even, its monotonicity on `[0,∞)` reduces the pointwise inequality
`2θ'(t) + δ̂(t) ≥ 0` of Corollary 2.3 to the single numerical inequality
`δ̂(0) ≥ log π - Re ψ(1/4)` at the origin.  Numerically the two sides differ by
`≈ 0.0491`, and the function is numerically increasing in `|t|` on `[0,8]`; neither the
monotonicity nor the value at the origin is proved here. -/
theorem fourierSide_nonneg_of_monotoneOn (hmono : MonotoneOn fourierSide (Ici 0))
    (h0 : 0 ≤ fourierSide 0) (t : ℝ) : 0 ≤ fourierSide t := by
  rcases le_or_gt 0 t with ht | ht
  · exact h0.trans (hmono self_mem_Ici (mem_Ici.2 ht) ht)
  · have h := hmono self_mem_Ici (mem_Ici.2 (by linarith : (0:ℝ) ≤ -t)) (by linarith)
    rw [← fourierSide_even t]
    linarith

/-- `θ'(0) = (Re ψ(1/4) - log π)/2`. -/
theorem thetaDeriv_zero : thetaDeriv 0 = ((Complex.digamma (1 / 4 : ℂ)).re - Real.log π) / 2 := by
  simp only [thetaDeriv, Complex.ofReal_zero, mul_zero, zero_div, add_zero]
  ring

/-- **The value of `2θ' + δ̂` at the origin**: the Fourier-side inequality at `t = 0` is the
single real-number comparison `δ̂(0) ≥ log π - Re ψ(1/4)`. -/
theorem fourierSide_zero :
    fourierSide 0 = deltaFourier 0 - (Real.log π - (Complex.digamma (1 / 4 : ℂ)).re) := by
  rw [fourierSide, thetaDeriv_zero]
  ring

theorem fourierSide_zero_nonneg_iff :
    0 ≤ fourierSide 0 ↔ Real.log π - (Complex.digamma (1 / 4 : ℂ)).re ≤ deltaFourier 0 := by
  rw [fourierSide_zero, sub_nonneg]

/-- **The reduction of the Fourier-side inequality to one numerical comparison.**  If
`2θ' + δ̂` is monotone on `[0,∞)` then the pointwise inequality `2θ'(t) + δ̂(t) ≥ 0` follows
from the single inequality `δ̂(0) ≥ log π - Re ψ(1/4)`.  (Numerically the left side is
`≈ 5.4212` and the right side `≈ 5.3722`; neither the monotonicity nor the numerical
inequality is proved in this project.) -/
theorem fourierSide_nonneg_of_monotoneOn_of_deltaFourier_zero
    (hmono : MonotoneOn fourierSide (Ici 0))
    (h0 : Real.log π - (Complex.digamma (1 / 4 : ℂ)).re ≤ deltaFourier 0) (t : ℝ) :
    0 ≤ fourierSide t :=
  fourierSide_nonneg_of_monotoneOn hmono (fourierSide_zero_nonneg_iff.2 h0) t

/-!
The statement `two_thetaDeriv_add_deltaFourier_nonneg` — the Fourier-side inequality
`2θ'(t) + δ̂(t) ≥ 0` of Corollary 2.3 (ii) — used to be recorded here with a `sorry`.
It is now **proved**, for every real `t`, in `RequestProject/PolyaLowThreshold.lean`
(`fourierSide_nonneg` and `two_thetaDeriv_add_deltaFourier_nonneg`), which needs the whole
Pólya-model machinery and therefore cannot be placed in this file.  The original
statement, with the historical description of the successive thresholds, is kept below in
a comment.
-/

/-
/-- **The Fourier-side inequality of §2 of the paper** (Corollary 2.3 (ii), illustrated by
Figures 3 and 4):
`2θ'(t) + δ̂(t) ≥ 0` for every real `t`.
It is *not* proved here: the paper obtains it from the positivity of the functional `L`,
which in turn comes from the trace identity `L(f) = Tr(ϑ(f) P P̂ P)`, and this project has
neither trace-class operators nor the integrated representation `ϑ(f)`.

What *is* proved, in `RequestProject/ThetaGrowth.lean`, is the inequality outside an
explicit bounded interval.  Two thresholds are available there:

* `fourierSide_nonneg_of_explicit_le_abs`: valid for `|t| ≥ 2π exp(17π + 20)`, obtained
  from the crude bound `|δ̂(t)| ≤ δ̂(0) ≤ 16π + 16`;
* `fourierSide_nonneg_of_sixty_le_abs`: valid for `|t| ≥ 60`, obtained from the decaying
  bound `|δ̂(t)| ≤ 104/|t|` of `RequestProject/DeltaDecay.lean`.

`RequestProject/MidThreshold.lean` lowers that threshold to `|t| ≥ 34`
(`fourierSide_nonneg_of_thirtyfour_le_abs`) by comparing the spread of `δ̂` with the
partial sums of the series for `Θ` directly.  `RequestProject/DeltaVariation.lean`
reaches `|t| ≥ 23`
(`fourierSide_nonneg_of_twentythree_le_abs`) from the total-variation bound
`|δ̂(t)| ≤ 24/|t|`, and `RequestProject/PolyaThreshold.lean` reaches `|t| ≥ 8`
(`fourierSide_nonneg_of_eight_le_abs`) from the Pólya-model bound
`δ̂(t) ≥ 2ĥ(t) - 2ε` with `ε ≤ 0.21088`, which — unlike the decay bounds — loses nothing
as `|t|` grows.

On the other side, `RequestProject/NearOrigin.lean` proves the inequality on a
neighbourhood of the origin, `fourierSide_nonneg_of_abs_le`: `|t| ≤ 0.18`, by comparing the
spread of `δ̂` with the increment of `2θ'` (`Δ(t) ≤ Θ(t) + t²/5`) and spending the
certified margin `f(0) ≥ 0.0072` at the origin.

So the inequality remains open exactly on `0.18 < |t| < 8`.  (Historical: the thresholds
`|t| ≥ 5.5` of `RequestProject/PolyaOscThreshold.lean` and `|t| ≥ 1.8` of
`RequestProject/PolyaLinThreshold.lean`, and finally the low-frequency bands covering
`0.18 ≤ |t| ≤ 1.8` in `RequestProject/PolyaLowThreshold.lean`, closed that range; the
inequality is now proved for every real `t`.)

`RequestProject/CompactInterval.lean` analyses that remaining compact case.  It reduces
the inequality at the origin to the single explicit numerical statement `δ̂(0) ≥ 5.3765`
(`fourierSide_zero_nonneg_of_deltaFourier_zero_ge`), and documents quantitatively why the
two elementary routes — monotonicity of `f` on `[0,∞)`, and interval arithmetic on a fine
partition — do not close it: the margin is `f(0) ≈ 0.049` against summands of size `5`, and
the second moments of the two competing terms agree to four significant digits.
The route that avoids numerics altogether is an exact representation of `f` as an integral
of a square (the tail-energy identity, which is not proved in this project). -/
theorem two_thetaDeriv_add_deltaFourier_nonneg (t : ℝ) :
    0 ≤ 2 * thetaDeriv t + deltaFourier t := by
  sorry
-/

/-!
**Corollary 2.3 of the paper**: the Fourier transform of the distribution defining
`L = D + W_∞` is `2θ' + δ̂`, so the pointwise positivity of `2θ' + δ̂` is equivalent to the
positivity of the functional `L`.  The direction that is used downstream used to be
recorded here, with a `sorry`, in the form

  `(∀ t, 0 ≤ 2 θ'(t) + δ̂(t)) → LPositivity`.

That statement is **not** provable, and is kept below only as a comment, for two separate
reasons.

* *Normalization.*  `LPositivity` pairs the trace remainder `δ` with the test function `f`
  and the Weil distribution `W_ℝ` with the same `f`, whereas the paper applies `W_ℝ` to
  `∆^{-1/2} f` (§1, after formula (39)).  In the logarithmic coordinate the two pairings
  differ: by `Dcomplex_parseval` the first pairs `δ̂` with the transform of `f` on the
  unitary line, while by `Winfty_deltaHalfInv_ofLog` the archimedean explicit formula
  pairs `2θ'` with the transform on the line `Re z = 1/2`, where positive definiteness says
  nothing.  The hypothesis `WinftyParseval` of `RequestProject/Parseval.lean`, which is
  what would be needed here, is therefore *not* the archimedean explicit formula; the
  correct statement is `WinftyParsevalNorm` of
  `RequestProject/ArchimedeanExplicit.lean`, and it is a theorem there.

* *Integrability.*  The Parseval computation requires the transform `f̂` to be integrable,
  which is not part of the hypotheses of `LPositivity` (for a merely continuous positive
  definite `f` this is a Bochner-type theorem).

Both points are settled in `RequestProject/NormalizedPositivity.lean`:

* `LPositivityNorm_holds` proves, with no hypothesis, the positivity of `L = D + W_∞` in
  the `∆^{1/2}` normalization of the paper on every `C⁴` compactly supported positive
  definite test function — the integrability of the transform being supplied by the
  quartic decay estimates of `RequestProject/QuarticDecay.lean`;
* `LPositivityC4_of_WinftyParseval` proves the implication recorded here, restricted to
  `C⁴` test functions, from the (unnormalized) hypothesis `WinftyParseval`, so that the
  integrability gap is removed there as well.
-/

/-
theorem LPositivity_of_fourierSide_nonneg
    (h : ∀ t : ℝ, 0 ≤ 2 * thetaDeriv t + deltaFourier t) : LPositivity := by
  sorry
-/

end ConnesConsani.WeilPositivity
