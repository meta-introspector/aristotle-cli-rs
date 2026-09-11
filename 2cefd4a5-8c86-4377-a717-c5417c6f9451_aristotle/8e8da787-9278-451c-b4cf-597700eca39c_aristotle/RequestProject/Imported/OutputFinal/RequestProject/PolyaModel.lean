/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

A Pólya-type completely monotone model for the trace remainder `δ(e^v)` of

  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771.

The decay estimates of `RequestProject/DeltaDecay.lean` and
`RequestProject/DeltaDecaySharp.lean` bound `|δ̂(t)|` by `C/|t|`; combined with the growth of
`2θ'` this gives the Fourier-side inequality `2θ'(t) + δ̂(t) ≥ 0` only for `|t| ≥ 23`
(`fourierSide_nonneg_of_twentythree_le_abs`).  The bottleneck is that a `1/|t|` bound is far
weaker than the true size of `δ̂` for moderate `t`.

Here we use a completely different device, which produces a bound that is *uniform in `t`*.
Write `g(v) = δ(e^v)` and let

  `h(v) = e^{-v/2} + 2.11 e^{-3v}`   (`expModel`)

be a nonnegative combination of decaying exponentials.  Its cosine transform

  `∫₀^∞ h(v) cos(tv) dv = (1/2)/((1/2)² + t²) + 2.11 · 3/(3² + t²)`

is *nonnegative for every `t`* (`integral_Ioi_expModel_cos_nonneg`), because each summand is.
Consequently

  `δ̂(t) = 2∫₀^∞ g cos(tv) dv ≥ -2 ∫₀^∞ |g - h| dv`   (`deltaFourier_ge_of_l1_bound`),

a bound with no decay in `t` at all but with a small constant: the L¹ distance
`ε = ∫₀^∞ |g - h| dv` is `≈ 0.174`, and `RequestProject/PolyaError.lean` certifies
`ε ≤ 0.31`.

This file sets up the model, the exact cosine transform of a decaying exponential, and the
reduction of the lower bound for `δ̂` to an L¹ bound for `g - h`.
-/
import RequestProject.Imported.OutputFinal.RequestProject.DeltaVariation

noncomputable section

open MeasureTheory Set Real Filter Topology

namespace ConnesConsani.WeilPositivity

/-! ## The cosine transform of a decaying exponential -/

/-- `∫₀^∞ e^{-a x} cos(b x) dx = a/(a² + b²)` for `a > 0`. -/
theorem integral_Ioi_exp_neg_mul_cos {a : ℝ} (ha : 0 < a) (b : ℝ) :
    (∫ x in Ioi (0:ℝ), Real.exp (-(a * x)) * Real.cos (b * x)) = a / (a ^ 2 + b ^ 2) := by
  have hden : (0:ℝ) < a ^ 2 + b ^ 2 := by positivity
  have hlin : ∀ x : ℝ, HasDerivAt (fun x : ℝ => b * x) b x := by
    intro x; simpa using (hasDerivAt_id x).const_mul b
  set F : ℝ → ℝ :=
    fun x => Real.exp (-(a * x)) * (b * Real.sin (b * x) - a * Real.cos (b * x)) / (a ^ 2 + b ^ 2)
    with hF
  have hderiv : ∀ x : ℝ, HasDerivAt F (Real.exp (-(a * x)) * Real.cos (b * x)) x := by
    intro x
    have h1 : HasDerivAt (fun x : ℝ => Real.exp (-(a * x))) (-a * Real.exp (-(a * x))) x := by
      have := (((hasDerivAt_id x).const_mul a).neg).exp
      simpa [mul_comm] using this
    have h2 : HasDerivAt (fun x : ℝ => b * Real.sin (b * x) - a * Real.cos (b * x))
        (b * b * Real.cos (b * x) + a * b * Real.sin (b * x)) x := by
      have hs : HasDerivAt (fun x : ℝ => Real.sin (b * x)) (Real.cos (b * x) * b) x :=
        (Real.hasDerivAt_sin (b * x)).comp x (hlin x)
      have hc : HasDerivAt (fun x : ℝ => Real.cos (b * x)) (-Real.sin (b * x) * b) x :=
        (Real.hasDerivAt_cos (b * x)).comp x (hlin x)
      have := (hs.const_mul b).sub (hc.const_mul a)
      convert this using 1; ring
    have := (h1.mul h2).div_const (a ^ 2 + b ^ 2)
    convert this using 1
    field_simp
    ring
  have hexpt : Tendsto (fun x : ℝ => Real.exp (-(a * x))) atTop (𝓝 0) := by
    have h0 : Tendsto (fun x : ℝ => -(a * x)) atTop atBot :=
      Filter.tendsto_neg_atTop_atBot.comp (Filter.Tendsto.const_mul_atTop ha tendsto_id)
    exact Real.tendsto_exp_atBot.comp h0
  have htend : Tendsto F atTop (𝓝 0) := by
    have hb : ∀ x : ℝ, ‖F x‖ ≤ (|b| + |a|) / (a ^ 2 + b ^ 2) * Real.exp (-(a * x)) := by
      intro x
      rw [hF]
      simp only [norm_div, Real.norm_eq_abs]
      rw [abs_of_pos hden, abs_mul, abs_of_pos (Real.exp_pos _)]
      have hs := Real.abs_sin_le_one (b * x)
      have hc := Real.abs_cos_le_one (b * x)
      have h1 : |b * Real.sin (b * x) - a * Real.cos (b * x)| ≤ |b| + |a| := by
        refine (abs_sub _ _).trans ?_
        rw [abs_mul, abs_mul]
        nlinarith [abs_nonneg a, abs_nonneg b]
      rw [div_le_iff₀ hden]
      have h2 : Real.exp (-(a * x)) * |b * Real.sin (b * x) - a * Real.cos (b * x)|
          ≤ Real.exp (-(a * x)) * (|b| + |a|) := mul_le_mul_of_nonneg_left h1 (Real.exp_pos _).le
      calc Real.exp (-(a * x)) * |b * Real.sin (b * x) - a * Real.cos (b * x)|
          ≤ Real.exp (-(a * x)) * (|b| + |a|) := h2
        _ = (|b| + |a|) / (a ^ 2 + b ^ 2) * Real.exp (-(a * x)) * (a ^ 2 + b ^ 2) := by field_simp
    refine squeeze_zero_norm hb ?_
    simpa using hexpt.const_mul ((|b| + |a|) / (a ^ 2 + b ^ 2))
  have hint : IntegrableOn (fun x : ℝ => Real.exp (-(a * x)) * Real.cos (b * x)) (Ioi 0) := by
    have hexp : IntegrableOn (fun x : ℝ => Real.exp (-(a * x))) (Ioi (0:ℝ)) := by
      simpa using exp_neg_integrableOn_Ioi 0 ha
    refine Integrable.mono' hexp
      ((by fun_prop : Continuous fun x : ℝ =>
        Real.exp (-(a * x)) * Real.cos (b * x))).aestronglyMeasurable.restrict ?_
    filter_upwards with x
    rw [Real.norm_eq_abs, abs_mul, abs_of_pos (Real.exp_pos _)]
    nlinarith [Real.abs_cos_le_one (b * x), (Real.exp_pos (-(a * x))).le,
      abs_nonneg (Real.cos (b * x))]
  have hmain := integral_Ioi_of_hasDerivAt_of_tendsto (f := F) (a := (0:ℝ))
    (m := 0) (by fun_prop) (fun x _ => hderiv x) hint htend
  rw [hmain, hF]
  simp
  field_simp

/-- `x ↦ e^{-a x}` is integrable on `(0,∞)` for `a > 0`. -/
theorem integrableOn_exp_neg_mul_Ioi {a : ℝ} (ha : 0 < a) :
    IntegrableOn (fun x : ℝ => Real.exp (-(a * x))) (Ioi (0:ℝ)) := by
  simpa using exp_neg_integrableOn_Ioi 0 ha

/-! ## The exponential model and the error function -/

/-- The Pólya model `h(v) = e^{-v/2} + 2.11 e^{-3v}` for `δ(e^v)`. -/
def expModel (v : ℝ) : ℝ := Real.exp (-(v / 2)) + 2.11 * Real.exp (-(3 * v))

/-- The error `δ(e^v) - h(v)` of the model. -/
def errFun (v : ℝ) : ℝ := deltaLogAux v - expModel v

theorem continuous_expModel : Continuous expModel := by
  unfold expModel; fun_prop

theorem continuous_errFun : Continuous errFun :=
  continuous_deltaLogAux.sub continuous_expModel

theorem expModel_nonneg (v : ℝ) : 0 ≤ expModel v := by
  unfold expModel
  positivity

theorem integrableOn_expModel : IntegrableOn expModel (Ioi (0:ℝ)) := by
  have h1 : IntegrableOn (fun v : ℝ => Real.exp (-(v / 2))) (Ioi (0:ℝ)) :=
    integrableOn_exp_neg_half
  have h2 : IntegrableOn (fun v : ℝ => Real.exp (-(3 * v))) (Ioi (0:ℝ)) :=
    integrableOn_exp_neg_mul_Ioi (by norm_num)
  exact h1.add (h2.const_mul 2.11)

theorem integrableOn_deltaLogAux : IntegrableOn deltaLogAux (Ioi (0:ℝ)) := by
  have h := integrableOn_deltaLogAux_mul (w := fun _ => (1:ℝ)) continuous_const
    (fun _ => by norm_num)
  simpa using h

theorem integrableOn_errFun : IntegrableOn errFun (Ioi (0:ℝ)) :=
  integrableOn_deltaLogAux.sub integrableOn_expModel

theorem integrableOn_expModel_mul_cos (t : ℝ) :
    IntegrableOn (fun v => expModel v * Real.cos (t * v)) (Ioi (0:ℝ)) := by
  refine Integrable.mono' integrableOn_expModel.norm
    ((continuous_expModel.mul (by fun_prop)).aestronglyMeasurable.restrict) ?_
  filter_upwards with v
  rw [Real.norm_eq_abs, Real.norm_eq_abs, abs_mul]
  nlinarith [Real.abs_cos_le_one (t * v), abs_nonneg (expModel v),
    abs_nonneg (Real.cos (t * v))]

theorem integrableOn_errFun_mul_cos (t : ℝ) :
    IntegrableOn (fun v => errFun v * Real.cos (t * v)) (Ioi (0:ℝ)) := by
  have h := integrableOn_deltaLogAux_mul (w := fun v => Real.cos (t * v)) (by fun_prop)
    (fun v => Real.abs_cos_le_one _)
  have h2 := integrableOn_expModel_mul_cos t
  have : (fun v => errFun v * Real.cos (t * v))
      = fun v => deltaLogAux v * Real.cos (t * v) - expModel v * Real.cos (t * v) := by
    funext v; unfold errFun; ring
  rw [this]
  exact h.sub h2

/-! ## Nonnegativity of the cosine transform of the model -/

/-- The exact cosine transform of the model. -/
theorem integral_Ioi_expModel_cos (t : ℝ) :
    (∫ v in Ioi (0:ℝ), expModel v * Real.cos (t * v))
      = (1/2) / ((1/2) ^ 2 + t ^ 2) + 2.11 * (3 / (3 ^ 2 + t ^ 2)) := by
  have hsplit : ∀ v : ℝ, expModel v * Real.cos (t * v)
      = Real.exp (-((1/2 : ℝ) * v)) * Real.cos (t * v)
        + 2.11 * (Real.exp (-((3:ℝ) * v)) * Real.cos (t * v)) := by
    intro v
    unfold expModel
    rw [show -((1/2 : ℝ) * v) = -(v / 2) by ring]
    ring
  rw [setIntegral_congr_fun measurableSet_Ioi (fun v _ => hsplit v)]
  rw [integral_add]
  · rw [integral_const_mul, integral_Ioi_exp_neg_mul_cos (by norm_num), 
      integral_Ioi_exp_neg_mul_cos (by norm_num)]
  · have h1 : IntegrableOn (fun v : ℝ => Real.exp (-((1/2 : ℝ) * v))) (Ioi (0:ℝ)) :=
      integrableOn_exp_neg_mul_Ioi (by norm_num)
    refine Integrable.mono' h1.norm
      ((by fun_prop : Continuous fun v : ℝ =>
        Real.exp (-((1/2:ℝ) * v)) * Real.cos (t * v)).aestronglyMeasurable.restrict) ?_
    filter_upwards with v
    rw [Real.norm_eq_abs, Real.norm_eq_abs, abs_mul]
    nlinarith [Real.abs_cos_le_one (t * v), abs_nonneg (Real.exp (-((1/2:ℝ) * v))),
      abs_nonneg (Real.cos (t * v))]
  · have h2 : IntegrableOn (fun v : ℝ => Real.exp (-((3:ℝ) * v))) (Ioi (0:ℝ)) :=
      integrableOn_exp_neg_mul_Ioi (by norm_num)
    refine Integrable.const_mul ?_ _
    refine Integrable.mono' h2.norm
      ((by fun_prop : Continuous fun v : ℝ =>
        Real.exp (-((3:ℝ) * v)) * Real.cos (t * v)).aestronglyMeasurable.restrict) ?_
    filter_upwards with v
    rw [Real.norm_eq_abs, Real.norm_eq_abs, abs_mul]
    nlinarith [Real.abs_cos_le_one (t * v), abs_nonneg (Real.exp (-((3:ℝ) * v))),
      abs_nonneg (Real.cos (t * v))]

/-- **The cosine transform of the model is nonnegative at every frequency.** -/
theorem integral_Ioi_expModel_cos_nonneg (t : ℝ) :
    0 ≤ ∫ v in Ioi (0:ℝ), expModel v * Real.cos (t * v) := by
  rw [integral_Ioi_expModel_cos]
  have h1 : (0:ℝ) ≤ (1/2) / ((1/2) ^ 2 + t ^ 2) := by positivity
  have h2 : (0:ℝ) ≤ 2.11 * (3 / (3 ^ 2 + t ^ 2)) := by positivity
  linarith

/-! ## The uniform lower bound for `δ̂` -/

/-- **The Pólya lower bound**: if `∫₀^∞ |δ(e^v) - h(v)| dv ≤ ε` then `δ̂(t) ≥ -2ε` for
*every* real `t`. -/
theorem deltaFourier_ge_of_l1_bound {ε : ℝ} (hε : (∫ v in Ioi (0:ℝ), |errFun v|) ≤ ε) (t : ℝ) :
    -(2 * ε) ≤ deltaFourier t := by
  have hsplit : ∀ v : ℝ, deltaLogAux v * Real.cos (t * v)
      = expModel v * Real.cos (t * v) + errFun v * Real.cos (t * v) := by
    intro v; unfold errFun; ring
  have hmodel := integral_Ioi_expModel_cos_nonneg t
  have herr : -ε ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
    have habs : |∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v)|
        ≤ ∫ v in Ioi (0:ℝ), |errFun v| := by
      refine (abs_integral_le_integral_abs).trans ?_
      refine setIntegral_mono_on (integrableOn_errFun_mul_cos t).abs
        integrableOn_errFun.abs measurableSet_Ioi (fun v _ => ?_)
      rw [abs_mul]
      nlinarith [Real.abs_cos_le_one (t * v), abs_nonneg (errFun v),
        abs_nonneg (Real.cos (t * v))]
    have := neg_abs_le (∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v))
    linarith
  have hint : (∫ v in Ioi (0:ℝ), deltaLogAux v * Real.cos (t * v))
      = (∫ v in Ioi (0:ℝ), expModel v * Real.cos (t * v))
        + ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
    rw [setIntegral_congr_fun measurableSet_Ioi (fun v _ => hsplit v)]
    exact integral_add (integrableOn_expModel_mul_cos t) (integrableOn_errFun_mul_cos t)
  rw [deltaFourier_eq_two_mul_integral_Ioi, hint]
  linarith

/-- **The Pólya lower bound, model term retained**: if `∫₀^∞ |δ(e^v) - h(v)| dv ≤ ε` then
`δ̂(t) ≥ 2 ĥ(t) - 2ε` for every real `t`, where `ĥ(t) = (1/2)/((1/2)² + t²) + 2.11·3/(3² + t²)`
is the (nonnegative) cosine transform of the model.  This refines
`deltaFourier_ge_of_l1_bound`, which simply drops the model term. -/
theorem deltaFourier_ge_of_l1_bound' {ε : ℝ} (hε : (∫ v in Ioi (0:ℝ), |errFun v|) ≤ ε) (t : ℝ) :
    2 * ((1/2) / ((1/2) ^ 2 + t ^ 2) + 2.11 * (3 / (3 ^ 2 + t ^ 2))) - 2 * ε ≤ deltaFourier t := by
  have hsplit : ∀ v : ℝ, deltaLogAux v * Real.cos (t * v)
      = expModel v * Real.cos (t * v) + errFun v * Real.cos (t * v) := by
    intro v; unfold errFun; ring
  have hmodel := integral_Ioi_expModel_cos t
  have herr : -ε ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
    have habs : |∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v)|
        ≤ ∫ v in Ioi (0:ℝ), |errFun v| := by
      refine (abs_integral_le_integral_abs).trans ?_
      refine setIntegral_mono_on (integrableOn_errFun_mul_cos t).abs
        integrableOn_errFun.abs measurableSet_Ioi (fun v _ => ?_)
      rw [abs_mul]
      nlinarith [Real.abs_cos_le_one (t * v), abs_nonneg (errFun v),
        abs_nonneg (Real.cos (t * v))]
    have := neg_abs_le (∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v))
    linarith
  have hint : (∫ v in Ioi (0:ℝ), deltaLogAux v * Real.cos (t * v))
      = (∫ v in Ioi (0:ℝ), expModel v * Real.cos (t * v))
        + ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
    rw [setIntegral_congr_fun measurableSet_Ioi (fun v _ => hsplit v)]
    exact integral_add (integrableOn_expModel_mul_cos t) (integrableOn_errFun_mul_cos t)
  rw [deltaFourier_eq_two_mul_integral_Ioi, hint, hmodel]
  linarith

end ConnesConsani.WeilPositivity
