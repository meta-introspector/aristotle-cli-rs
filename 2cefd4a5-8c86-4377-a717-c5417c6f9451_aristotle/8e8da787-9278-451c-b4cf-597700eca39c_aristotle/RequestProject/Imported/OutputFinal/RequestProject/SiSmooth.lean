/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Smoothness of the normalized sine integral `siDiv a = Si(a)/a`, obtained from the
integral representation `siDiv a = ∫₀¹ cos(a t)(-log t) dt` by differentiating under the
integral sign.  This is what makes the trace remainder `δ` of arXiv:2006.13771 smooth on
each side of `ρ = 1`.
-/
import RequestProject.Imported.OutputFinal.RequestProject.SineIntegral

noncomputable section

open MeasureTheory Set Real intervalIntegral

namespace ConnesConsani.WeilPositivity

/-- The cosine moments `∫₀¹ tᵏ cos(a t)(-log t) dt`; `cosMoment 0` is `siDiv`. -/
def cosMoment (k : ℕ) (a : ℝ) : ℝ := ∫ t in (0:ℝ)..1, t ^ k * Real.cos (a * t) * (-Real.log t)

/-- The sine moments `∫₀¹ tᵏ sin(a t)(-log t) dt`. -/
def sinMoment (k : ℕ) (a : ℝ) : ℝ := ∫ t in (0:ℝ)..1, t ^ k * Real.sin (a * t) * (-Real.log t)

theorem intervalIntegrable_neg_log : IntervalIntegrable (fun t : ℝ => -Real.log t) volume 0 1 :=
  intervalIntegrable_log'.neg

/-- Integrability of the integrands defining the moments. -/
theorem intervalIntegrable_moment {g : ℝ → ℝ} (hg : Continuous g) (k : ℕ) :
    IntervalIntegrable (fun t : ℝ => t ^ k * g t * (-Real.log t)) volume 0 1 :=
  intervalIntegrable_neg_log.continuousOn_mul (g := fun t : ℝ => t ^ k * g t) (by fun_prop)

/-- On `(0,1]` the integrands are dominated by `-log t`. -/
private theorem moment_bound {t : ℝ} (ht : t ∈ Set.Ioc (0:ℝ) 1) {u : ℝ} (hu : |u| ≤ 1) (k : ℕ) :
    ‖t ^ k * u * (-Real.log t)‖ ≤ -Real.log t := by
  have h1 : (0:ℝ) < t := ht.1
  have h2 : t ≤ 1 := ht.2
  have hlog : 0 ≤ -Real.log t := by
    have := Real.log_nonpos h1.le h2
    linarith
  have hpow : |t ^ k| ≤ 1 := by
    rw [abs_of_nonneg (by positivity)]
    exact pow_le_one₀ h1.le h2
  calc ‖t ^ k * u * (-Real.log t)‖ = |t ^ k| * |u| * |(-Real.log t)| := by
        simp [Real.norm_eq_abs]
    _ ≤ 1 * 1 * (-Real.log t) := by
        rw [abs_of_nonneg hlog]
        gcongr
    _ = -Real.log t := by ring

/-- Differentiating `cosMoment k` under the integral sign. -/
theorem hasDerivAt_cosMoment (k : ℕ) (a : ℝ) :
    HasDerivAt (cosMoment k) (-sinMoment (k + 1) a) a := by
  have hdiff : ∀ t x : ℝ,
      HasDerivAt (fun x : ℝ => t ^ k * Real.cos (x * t) * (-Real.log t))
        (-(t ^ (k + 1) * Real.sin (x * t) * (-Real.log t))) x := by
    intro t x
    have h1 : HasDerivAt (fun x : ℝ => x * t) t x := by
      simpa using (hasDerivAt_id x).mul_const t
    have h2 := ((h1.cos.const_mul (t ^ k)).mul_const (-Real.log t))
    convert h2 using 1
    rw [pow_succ]
    ring
  have hmeas : ∀ x : ℝ, AEStronglyMeasurable
      (fun t : ℝ => t ^ k * Real.cos (x * t) * (-Real.log t))
      (volume.restrict (Set.uIoc (0:ℝ) 1)) := fun x =>
    (by fun_prop : Measurable
      fun t : ℝ => t ^ k * Real.cos (x * t) * (-Real.log t)).aestronglyMeasurable
  have hmeas' : AEStronglyMeasurable
      (fun t : ℝ => -(t ^ (k + 1) * Real.sin (a * t) * (-Real.log t)))
      (volume.restrict (Set.uIoc (0:ℝ) 1)) :=
    (by fun_prop : Measurable
      fun t : ℝ => -(t ^ (k + 1) * Real.sin (a * t) * (-Real.log t))).aestronglyMeasurable
  have hbound : ∀ᵐ t ∂(volume : Measure ℝ), t ∈ Set.uIoc (0:ℝ) 1 →
      ∀ x ∈ Set.univ, ‖-(t ^ (k + 1) * Real.sin (x * t) * (-Real.log t))‖ ≤ -Real.log t := by
    filter_upwards with t ht x _
    rw [Set.uIoc_of_le zero_le_one] at ht
    rw [norm_neg]
    exact moment_bound ht (u := Real.sin (x * t)) (Real.abs_sin_le_one _) (k + 1)
  have hkey := intervalIntegral.hasDerivAt_integral_of_dominated_loc_of_deriv_le
    (F := fun x t => t ^ k * Real.cos (x * t) * (-Real.log t))
    (F' := fun x t => -(t ^ (k + 1) * Real.sin (x * t) * (-Real.log t)))
    (x₀ := a) (s := Set.univ) (bound := fun t => -Real.log t)
    (μ := volume) (a := 0) (b := 1)
    Filter.univ_mem
    (Filter.Eventually.of_forall hmeas)
    (intervalIntegrable_moment (g := fun t => Real.cos (a * t)) (by fun_prop) k)
    hmeas'
    hbound
    intervalIntegrable_neg_log
    (Filter.Eventually.of_forall fun t _ x _ => hdiff t x)
  have hint : (∫ t in (0:ℝ)..1, -(t ^ (k + 1) * Real.sin (a * t) * (-Real.log t)))
      = -sinMoment (k + 1) a := by
    rw [sinMoment, ← intervalIntegral.integral_neg]
  rw [hint] at hkey
  exact hkey.2

/-- Differentiating `sinMoment k` under the integral sign. -/
theorem hasDerivAt_sinMoment (k : ℕ) (a : ℝ) :
    HasDerivAt (sinMoment k) (cosMoment (k + 1) a) a := by
  have hdiff : ∀ t x : ℝ,
      HasDerivAt (fun x : ℝ => t ^ k * Real.sin (x * t) * (-Real.log t))
        (t ^ (k + 1) * Real.cos (x * t) * (-Real.log t)) x := by
    intro t x
    have h1 : HasDerivAt (fun x : ℝ => x * t) t x := by
      simpa using (hasDerivAt_id x).mul_const t
    have h2 := ((h1.sin.const_mul (t ^ k)).mul_const (-Real.log t))
    convert h2 using 1
    rw [pow_succ]
    ring
  have hmeas : ∀ x : ℝ, AEStronglyMeasurable
      (fun t : ℝ => t ^ k * Real.sin (x * t) * (-Real.log t))
      (volume.restrict (Set.uIoc (0:ℝ) 1)) := fun x =>
    (by fun_prop : Measurable
      fun t : ℝ => t ^ k * Real.sin (x * t) * (-Real.log t)).aestronglyMeasurable
  have hmeas' : AEStronglyMeasurable
      (fun t : ℝ => t ^ (k + 1) * Real.cos (a * t) * (-Real.log t))
      (volume.restrict (Set.uIoc (0:ℝ) 1)) :=
    (by fun_prop : Measurable
      fun t : ℝ => t ^ (k + 1) * Real.cos (a * t) * (-Real.log t)).aestronglyMeasurable
  have hbound : ∀ᵐ t ∂(volume : Measure ℝ), t ∈ Set.uIoc (0:ℝ) 1 →
      ∀ x ∈ Set.univ, ‖t ^ (k + 1) * Real.cos (x * t) * (-Real.log t)‖ ≤ -Real.log t := by
    filter_upwards with t ht x _
    rw [Set.uIoc_of_le zero_le_one] at ht
    exact moment_bound ht (u := Real.cos (x * t)) (Real.abs_cos_le_one _) (k + 1)
  have hkey := intervalIntegral.hasDerivAt_integral_of_dominated_loc_of_deriv_le
    (F := fun x t => t ^ k * Real.sin (x * t) * (-Real.log t))
    (F' := fun x t => t ^ (k + 1) * Real.cos (x * t) * (-Real.log t))
    (x₀ := a) (s := Set.univ) (bound := fun t => -Real.log t)
    (μ := volume) (a := 0) (b := 1)
    Filter.univ_mem
    (Filter.Eventually.of_forall hmeas)
    (intervalIntegrable_moment (g := fun t => Real.sin (a * t)) (by fun_prop) k)
    hmeas'
    hbound
    intervalIntegrable_neg_log
    (Filter.Eventually.of_forall fun t _ x _ => hdiff t x)
  exact hkey.2

theorem differentiable_cosMoment (k : ℕ) : Differentiable ℝ (cosMoment k) :=
  fun a => (hasDerivAt_cosMoment k a).differentiableAt

theorem differentiable_sinMoment (k : ℕ) : Differentiable ℝ (sinMoment k) :=
  fun a => (hasDerivAt_sinMoment k a).differentiableAt

theorem deriv_cosMoment (k : ℕ) : deriv (cosMoment k) = fun a => -sinMoment (k + 1) a :=
  funext fun a => (hasDerivAt_cosMoment k a).deriv

theorem deriv_sinMoment (k : ℕ) : deriv (sinMoment k) = fun a => cosMoment (k + 1) a :=
  funext fun a => (hasDerivAt_sinMoment k a).deriv

/-- The moments are `C^n` for every `n`. -/
theorem contDiff_moments (n : ℕ) :
    ∀ k : ℕ, ContDiff ℝ n (cosMoment k) ∧ ContDiff ℝ n (sinMoment k) := by
  induction n with
  | zero =>
    intro k
    exact ⟨contDiff_zero.2 (differentiable_cosMoment k).continuous,
      contDiff_zero.2 (differentiable_sinMoment k).continuous⟩
  | succ n ih =>
    intro k
    have hcast : ((n + 1 : ℕ) : WithTop ℕ∞) = (n : WithTop ℕ∞) + 1 := by push_cast; ring
    have hne : ¬ ((n : WithTop ℕ∞) = ⊤) := by simp
    constructor
    · rw [hcast]
      refine contDiff_succ_iff_deriv.2 ⟨differentiable_cosMoment k, fun h => absurd h hne, ?_⟩
      rw [deriv_cosMoment]
      exact ((ih (k + 1)).2).neg
    · rw [hcast]
      refine contDiff_succ_iff_deriv.2 ⟨differentiable_sinMoment k, fun h => absurd h hne, ?_⟩
      rw [deriv_sinMoment]
      exact (ih (k + 1)).1

/-- `siDiv` is the zeroth cosine moment. -/
theorem siDiv_eq_cosMoment (a : ℝ) : siDiv a = cosMoment 0 a := by
  rw [← integral_cos_mul_neg_log a, cosMoment]
  exact intervalIntegral.integral_congr fun t _ => by simp

/-- **The normalized sine integral is smooth.** -/
theorem contDiff_siDiv (n : ℕ) : ContDiff ℝ n siDiv := by
  have h : siDiv = cosMoment 0 := funext siDiv_eq_cosMoment
  rw [h]
  exact (contDiff_moments n 0).1

end ConnesConsani.WeilPositivity
