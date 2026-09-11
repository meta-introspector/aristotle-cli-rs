/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The Parseval computation (52) of

  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771,

which expresses the functional `L = D + W_∞` through the Fourier transform of the test
function and the function `2θ' + δ̂` of Corollary 2.3:

  `L(f) = (2π)⁻¹ ∫_ℝ f̂(t) (2θ'(t) + δ̂(t)) dt`.

The half of the identity concerning `D` is *proved* here (`Dcomplex_parseval`); it is the
Fourier inversion formula on the line together with Fubini's theorem.  The half concerning
the archimedean Weil functional `W_∞` is the archimedean Weil explicit formula
`W_∞(f) = (2π)⁻¹ ∫ f̂(t) 2θ'(t) dt`; it is *not* proved here (it needs the integral
representation of the digamma function), and is carried as an explicit hypothesis
`WinftyParseval` — no statement below uses it silently.
-/
import RequestProject.Imported.OutputFinal2.FourierSide

noncomputable section

open MeasureTheory Set Real FourierTransform

namespace ConnesConsani.WeilPositivity

/-! ## The Fourier transform of a test function in the logarithmic coordinate -/

/-- `f̂(t) = ∫ f(u) e^{i t u} du`, the Fourier–Mellin transform of a test function on the
unitary characters `z = i t`. -/
def fourierLog (F : ℝ → ℂ) (t : ℝ) : ℂ := mellinLog F (Complex.I * t)

/-- The dictionary with Mathlib's Fourier transform, `𝓕 f (w) = ∫ e^{-2π i v w} f(v) dv`. -/
theorem fourierLog_eq_fourier (F : ℝ → ℂ) (t : ℝ) :
    fourierLog F t = 𝓕 F (-t / (2 * π)) := by
  rw [Real.fourier_eq, fourierLog, mellinLog]
  refine integral_congr_ae (Filter.Eventually.of_forall fun v => ?_)
  simp only [RCLike.inner_apply, conj_trivial, Circle.smul_def]
  rw [mul_comm, Real.fourierChar_apply]
  have hpi : (π : ℝ) ≠ 0 := Real.pi_ne_zero
  have h : ((2 * π * -(-t / (2 * π) * v) : ℝ) : ℂ) = (t : ℂ) * v := by
    push_cast; field_simp
  rw [h, smul_eq_mul]
  congr 2
  ring

theorem fourier_eq_fourierLog (F : ℝ → ℂ) (w : ℝ) :
    𝓕 F w = fourierLog F (-(2 * π) * w) := by
  rw [fourierLog_eq_fourier]
  have hpi : (π : ℝ) ≠ 0 := Real.pi_ne_zero
  field_simp

theorem integrable_fourier_of_fourierLog {F : ℝ → ℂ} (hG : Integrable (fourierLog F)) :
    Integrable (𝓕 F) := by
  have h : Integrable (fun w : ℝ => fourierLog F (-(2 * π) * w)) :=
    hG.comp_mul_left' (by norm_num [Real.pi_ne_zero])
  exact h.congr (Filter.Eventually.of_forall fun w => (fourier_eq_fourierLog F w).symm)

/-- **Fourier inversion in the normalization of the paper.**  If `f` is continuous and
integrable and its transform `f̂` is integrable, then `f(u) = (2π)⁻¹ ∫ f̂(t) e^{-i u t} dt`. -/
theorem fourierLog_inversion {F : ℝ → ℂ} (hFc : Continuous F) (hF : Integrable F)
    (hG : Integrable (fourierLog F)) (u : ℝ) :
    F u = ((1 / (2 * π) : ℝ) : ℂ)
      * ∫ t : ℝ, fourierLog F t * Complex.exp (-(Complex.I * u * t)) := by
  have hinv := congrFun (hFc.fourierInv_fourier_eq hF (integrable_fourier_of_fourierLog hG)) u
  rw [Real.fourierInv_eq] at hinv
  set g : ℝ → ℂ := fun t => fourierLog F t * Complex.exp (-(Complex.I * u * t)) with hg
  have hpt : ∀ v : ℝ, Real.fourierChar (inner ℝ v u) • 𝓕 F v = g (-(2 * π) * v) := by
    intro v
    simp only [hg, RCLike.inner_apply, conj_trivial, Circle.smul_def, Real.fourierChar_apply,
      smul_eq_mul]
    rw [fourier_eq_fourierLog, mul_comm]
    congr 1
    have h : ((-(Complex.I * u * ((-(2 * π) * v : ℝ) : ℂ)))) = ((2 * π * (v * u) : ℝ) : ℂ)
        * Complex.I := by
      push_cast
      ring
    rw [h, mul_comm u v]
  have hcomp : (∫ v : ℝ, Real.fourierChar (inner ℝ v u) • 𝓕 F v) = ∫ v : ℝ, g (-(2 * π) * v) :=
    integral_congr_ae (Filter.Eventually.of_forall hpt)
  rw [hcomp, Measure.integral_comp_mul_left g (-(2 * π))] at hinv
  rw [← hinv]
  have habs : |(-(2 * π))⁻¹| = 1 / (2 * π) := by
    rw [abs_inv, abs_neg, abs_of_pos (by positivity : (0:ℝ) < 2 * π)]
    ring
  rw [habs, Complex.real_smul]

/-! ## The Parseval identity for `D` -/

theorem integrable_deltaLog_complex :
    Integrable (fun u : ℝ => ((delta (Rplus.expHomeo u) : ℝ) : ℂ)) :=
  integrable_delta_log.ofReal

theorem fourierLog_delta (t : ℝ) :
    (∫ u : ℝ, ((delta (Rplus.expHomeo u) : ℝ) : ℂ) * Complex.exp (-(Complex.I * u * t)))
      = ((deltaFourier t : ℝ) : ℂ) := by
  have h : ∀ u : ℝ, ((delta (Rplus.expHomeo u) : ℝ) : ℂ) * Complex.exp (-(Complex.I * u * t))
      = ((delta (Rplus.expHomeo u) : ℝ) : ℂ) * Complex.exp (Complex.I * ((-t : ℝ) : ℂ) * u) := by
    intro u
    congr 1
    congr 1
    push_cast
    ring
  rw [integral_congr_ae (Filter.Eventually.of_forall h)]
  have := mellinLog_delta_eq_deltaFourier (-t)
  rw [mellinLog] at this
  rw [this, deltaFourier_even]

/-- **The Parseval identity for the functional `D`** (the `D`-half of formula (52) of the
paper): for a continuous, compactly supported test function whose transform is integrable,
`D(f) = (2π)⁻¹ ∫ f̂(t) δ̂(t) dt`. -/
theorem Dcomplex_parseval {F : ℝ → ℂ} (hFc : Continuous F) (hsF : HasCompactSupport F)
    (hG : Integrable (fourierLog F)) :
    Dcomplex (ofLog F)
      = ((1 / (2 * π) : ℝ) : ℂ) * ∫ t : ℝ, fourierLog F t * ((deltaFourier t : ℝ) : ℂ) := by
  have hFint : Integrable F := hFc.integrable_of_hasCompactSupport hsF
  set d : ℝ → ℂ := fun u => ((delta (Rplus.expHomeo u) : ℝ) : ℂ) with hd
  have hdint : Integrable d := integrable_deltaLog_complex
  set k : ℝ × ℝ → ℂ :=
    fun z => fourierLog F z.2 * Complex.exp (-(Complex.I * z.1 * z.2)) * d z.1 with hk
  -- integrability of the double integral
  have hmeas : AEStronglyMeasurable k (volume.prod volume) := by
    have h1 : AEStronglyMeasurable (fun z : ℝ × ℝ => fourierLog F z.2) (volume.prod volume) :=
      hG.aestronglyMeasurable.comp_snd
    have h2 : Continuous fun z : ℝ × ℝ => Complex.exp (-(Complex.I * z.1 * z.2)) := by
      fun_prop
    have h3 : AEStronglyMeasurable (fun z : ℝ × ℝ => d z.1) (volume.prod volume) :=
      hdint.aestronglyMeasurable.comp_fst
    exact (h1.mul h2.aestronglyMeasurable).mul h3
  have hdom : Integrable (fun z : ℝ × ℝ => ‖fourierLog F z.2‖ * ‖d z.1‖)
      (volume.prod volume) := by
    have := (hdint.norm.mul_prod hG.norm)
    exact this.congr (Filter.Eventually.of_forall fun z => by ring)
  have hkint : Integrable k (volume.prod volume) := by
    refine Integrable.mono' hdom hmeas (Filter.Eventually.of_forall fun z => ?_)
    have hexp : ‖Complex.exp (-(Complex.I * z.1 * z.2))‖ = 1 := by
      have h : -(Complex.I * (z.1 : ℂ) * (z.2 : ℂ)) = ((-(z.1 * z.2) : ℝ) : ℂ) * Complex.I := by
        push_cast; ring
      rw [h, Complex.norm_exp_ofReal_mul_I]
    simp only [hk, norm_mul, hexp, mul_one]
    exact le_rfl
  -- the two iterated integrals
  have hstep1 : ∀ u : ℝ, F u * d u = ((1 / (2 * π) : ℝ) : ℂ) * ∫ t : ℝ, k (u, t) := by
    intro u
    rw [fourierLog_inversion hFc hFint hG u, mul_assoc]
    congr 1
    rw [← integral_mul_const]
  have hstep2 : ∀ t : ℝ, (∫ u : ℝ, k (u, t)) = fourierLog F t * ((deltaFourier t : ℝ) : ℂ) := by
    intro t
    have h : ∀ u : ℝ, k (u, t)
        = fourierLog F t * (d u * Complex.exp (-(Complex.I * u * t))) := by
      intro u; simp only [hk]; ring
    rw [integral_congr_ae (Filter.Eventually.of_forall h), integral_const_mul, fourierLog_delta]
  rw [Dcomplex_ofLog, integral_congr_ae (Filter.Eventually.of_forall hstep1), integral_const_mul,
    integral_integral_swap hkint]
  congr 1
  exact integral_congr_ae (Filter.Eventually.of_forall hstep2)

/-! ## The full identity (52) -/

/-- **The archimedean Weil explicit formula**, i.e. the `W_∞`-half of the Parseval identity
(52): `W_∞(f) = (2π)⁻¹ ∫ f̂(t) · 2θ'(t) dt`.  It is *not* proved in this project — it is the
classical archimedean explicit formula, which needs the integral representation of the
digamma function — and is therefore carried as an explicit hypothesis. -/
def WinftyParseval : Prop :=
  ∀ F : ℝ → ℂ, Continuous F → HasCompactSupport F → Integrable (fourierLog F) →
    Integrable (fun t : ℝ => fourierLog F t * ((2 * thetaDeriv t : ℝ) : ℂ)) →
      Winfty (ofLog F)
        = ((1 / (2 * π) : ℝ) : ℂ) * ∫ t : ℝ, fourierLog F t * ((2 * thetaDeriv t : ℝ) : ℂ)

/-- `δ̂` is bounded by its value at the origin, so `f̂ δ̂` is integrable whenever `f̂` is. -/
theorem integrable_fourierLog_mul_deltaFourier {F : ℝ → ℂ} (hG : Integrable (fourierLog F)) :
    Integrable (fun t : ℝ => fourierLog F t * ((deltaFourier t : ℝ) : ℂ)) := by
  have hbdd : ∀ t : ℝ, |deltaFourier t| ≤ deltaFourier 0 := abs_deltaFourier_le
  refine Integrable.mono' (hG.norm.const_mul (deltaFourier 0)) ?_
    (Filter.Eventually.of_forall fun t => ?_)
  · exact hG.aestronglyMeasurable.mul
      ((Complex.continuous_ofReal.comp continuous_deltaFourier).aestronglyMeasurable)
  · rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, mul_comm]
    exact mul_le_mul_of_nonneg_right (hbdd t) (norm_nonneg _)

/-- **The Parseval identity (52) of the paper.**  Granting the archimedean explicit formula
`WinftyParseval`, the functional `L = D + W_∞` is given on test functions by

  `L(f) = (2π)⁻¹ ∫ f̂(t) (2θ'(t) + δ̂(t)) dt`. -/
theorem L_parseval (hW : WinftyParseval) {F : ℝ → ℂ} (hFc : Continuous F)
    (hsF : HasCompactSupport F) (hG : Integrable (fourierLog F))
    (hGtheta : Integrable (fun t : ℝ => fourierLog F t * ((2 * thetaDeriv t : ℝ) : ℂ))) :
    Lfun (ofLog F)
      = ((1 / (2 * π) : ℝ) : ℂ)
        * ∫ t : ℝ, fourierLog F t * ((2 * thetaDeriv t + deltaFourier t : ℝ) : ℂ) := by
  have hsum : (∫ t : ℝ, fourierLog F t * ((2 * thetaDeriv t + deltaFourier t : ℝ) : ℂ))
      = (∫ t : ℝ, fourierLog F t * ((2 * thetaDeriv t : ℝ) : ℂ))
        + ∫ t : ℝ, fourierLog F t * ((deltaFourier t : ℝ) : ℂ) := by
    rw [← integral_add hGtheta (integrable_fourierLog_mul_deltaFourier hG)]
    refine integral_congr_ae (Filter.Eventually.of_forall fun t => ?_)
    push_cast
    ring
  rw [Lfun, Dcomplex_parseval hFc hsF hG, hW F hFc hsF hG hGtheta, hsum]
  ring

/-! ## Positivity of `L` from the Fourier-side inequality -/

/-- **Corollary 2.3 (i) of the paper, on test functions with integrable transform.**
Granting the archimedean explicit formula and the pointwise inequality
`2θ'(t) + δ̂(t) ≥ 0`, the functional `L = D + W_∞` is nonnegative on positive definite test
functions whose Fourier transform is integrable (and integrable against `θ'`).

This is *not* the full statement `LPositivity` used in the rest of the project: that one
quantifies over all continuous compactly supported positive definite test functions,
whereas the Parseval computation needs the transform to be integrable.  (For a positive
definite `f` the integrability of `f̂` is a classical theorem of Bochner type, which is not
formalized here.) -/
theorem L_real_nonneg_of_fourierSide_nonneg (hW : WinftyParseval)
    (hpos : ∀ t : ℝ, 0 ≤ 2 * thetaDeriv t + deltaFourier t)
    {F : ℝ → ℂ} (hFc : Continuous F) (hsF : HasCompactSupport F)
    (hG : Integrable (fourierLog F))
    (hGtheta : Integrable (fun t : ℝ => fourierLog F t * ((2 * thetaDeriv t : ℝ) : ℂ)))
    (hpd : PositiveDefiniteLog F) :
    0 ≤ L_real (ofLog F) := by
  have hint : Integrable
      (fun t : ℝ => fourierLog F t * ((2 * thetaDeriv t + deltaFourier t : ℝ) : ℂ)) := by
    refine (hGtheta.add (integrable_fourierLog_mul_deltaFourier hG)).congr
      (Filter.Eventually.of_forall fun t => ?_)
    simp only [Pi.add_apply]
    push_cast
    ring
  have hre : (∫ t : ℝ, fourierLog F t * ((2 * thetaDeriv t + deltaFourier t : ℝ) : ℂ)).re
      = ∫ t : ℝ, (fourierLog F t).re * (2 * thetaDeriv t + deltaFourier t) := by
    have hri := integral_re hint
    simp only [RCLike.re_to_complex] at hri
    rw [← hri]
    refine integral_congr_ae (Filter.Eventually.of_forall fun t => ?_)
    simp [Complex.mul_re]
  have hnn : 0 ≤ ∫ t : ℝ, (fourierLog F t).re * (2 * thetaDeriv t + deltaFourier t) :=
    integral_nonneg fun t => mul_nonneg (hpd t) (hpos t)
  rw [L_real, L_parseval hW hFc hsF hG hGtheta]
  have hpi : (0:ℝ) < 1 / (2 * π) := by positivity
  rw [Complex.re_ofReal_mul, hre]
  exact mul_nonneg hpi.le hnn

end ConnesConsani.WeilPositivity
