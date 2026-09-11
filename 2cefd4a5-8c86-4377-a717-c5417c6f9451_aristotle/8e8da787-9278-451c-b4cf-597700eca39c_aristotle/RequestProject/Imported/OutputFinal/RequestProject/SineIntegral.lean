/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The sine integral function `Si` and the integral identity

  ∫₀¹ cos(a t) (-log t) dt = Si(a)/a,

which is the analytic ingredient behind formula (49) of arXiv:2006.13771.
-/
import RequestProject.Imported.OutputFinal.RequestProject.Basic

noncomputable section

open MeasureTheory Real Set intervalIntegral

namespace ConnesConsani.WeilPositivity

/-- The sine integral `Si z = ∫₀^z sin t / t dt`, defined through the (continuous)
cardinal sine so that the integrand is genuinely continuous at `0`. -/
def Si (x : ℝ) : ℝ := ∫ t in (0:ℝ)..x, Real.sinc t

@[simp] lemma Si_zero : Si 0 = 0 := by simp [Si]

lemma Si_eq_integral_sin_div (x : ℝ) : Si x = ∫ t in (0:ℝ)..x, Real.sin t / t := by
  refine intervalIntegral.integral_congr_ae ?_
  have h0 : ∀ᵐ t : ℝ, t ≠ 0 := by
    rw [MeasureTheory.ae_iff]
    simp
  filter_upwards [h0] with t ht _ using Real.sinc_of_ne_zero ht

/-- `Si` is odd. -/
lemma Si_neg (x : ℝ) : Si (-x) = -Si x := by
  have h := intervalIntegral.integral_comp_neg (a := 0) (b := x) (f := Real.sinc)
  simp only [Real.sinc_neg, neg_zero] at h
  have h2 : (∫ t in (-x:ℝ)..0, Real.sinc t) = -∫ t in (0:ℝ)..(-x), Real.sinc t :=
    intervalIntegral.integral_symm _ _
  rw [h2] at h
  simp only [Si]
  linarith

lemma Si_differentiable : Differentiable ℝ Si := by
  intro x
  simpa [Si] using
    (intervalIntegral.integral_hasStrictDerivAt_right
      (Real.continuous_sinc.intervalIntegrable 0 x)
      (Real.continuous_sinc.stronglyMeasurableAtFilter _ _)
      Real.continuous_sinc.continuousAt).hasDerivAt.differentiableAt

lemma Si_hasDerivAt (x : ℝ) : HasDerivAt Si (Real.sinc x) x := by
  simpa [Si] using
    (intervalIntegral.integral_hasStrictDerivAt_right
      (Real.continuous_sinc.intervalIntegrable 0 x)
      (Real.continuous_sinc.stronglyMeasurableAtFilter _ _)
      Real.continuous_sinc.continuousAt).hasDerivAt

lemma Si_continuous : Continuous Si := Si_differentiable.continuous

/-- The normalized sine integral `a ↦ Si(a)/a`, extended by its limiting value `1` at
`a = 0`.  This is the function that occurs in formula (49) of the paper. -/
def siDiv (a : ℝ) : ℝ := if a = 0 then 1 else Si a / a

@[simp] lemma siDiv_zero : siDiv 0 = 1 := by simp [siDiv]

lemma siDiv_of_ne_zero {a : ℝ} (ha : a ≠ 0) : siDiv a = Si a / a := by simp [siDiv, ha]

lemma siDiv_neg (a : ℝ) : siDiv (-a) = siDiv a := by
  rcases eq_or_ne a 0 with rfl | h
  · simp
  · rw [siDiv_of_ne_zero (neg_ne_zero.2 h), siDiv_of_ne_zero h, Si_neg]
    field_simp

/-- `siDiv a = ∫₀¹ sinc (a t) dt`; the integral form makes the value at `a = 0` evident. -/
lemma siDiv_eq_integral (a : ℝ) : siDiv a = ∫ t in (0:ℝ)..1, Real.sinc (a * t) := by
  rcases eq_or_ne a 0 with rfl | ha
  · simp
  · rw [siDiv_of_ne_zero ha]
    have := intervalIntegral.integral_comp_mul_left (a := 0) (b := 1) (c := a)
      (f := Real.sinc) ha
    simp only [mul_zero, mul_one] at this
    rw [this, Si, smul_eq_mul]
    field_simp

/-- `siDiv` is continuous; in particular `Si(a)/a → 1` as `a → 0`. -/
lemma siDiv_continuous : Continuous siDiv := by
  have h : siDiv = fun a : ℝ => ∫ t in (0:ℝ)..1, Real.sinc (a * t) := by
    funext a
    exact siDiv_eq_integral a
  rw [h]
  have hc : Continuous (Function.uncurry fun a t : ℝ => Real.sinc (a * t)) := by
    unfold Function.uncurry
    exact Real.continuous_sinc.comp (by fun_prop)
  exact continuous_parametric_intervalIntegral_of_continuous hc continuous_const

/-! ### Behaviour of `siDiv` near `0` -/

/-- A quadratic bound for the cardinal sine near its value at `0`. -/
lemma abs_sinc_sub_one_le (x : ℝ) : |Real.sinc x - 1| ≤ 2 * x ^ 2 := by
  rcases le_or_gt 1 |x| with h | h
  · have h1 : |Real.sinc x - 1| ≤ |Real.sinc x| + 1 := by
      calc |Real.sinc x - 1| ≤ |Real.sinc x| + |(1:ℝ)| := abs_sub _ _
      _ = |Real.sinc x| + 1 := by norm_num
    have h2 : |Real.sinc x| ≤ 1 := Real.abs_sinc_le_one x
    have h3 : (1:ℝ) ≤ x ^ 2 := by nlinarith [abs_nonneg x, sq_abs x]
    linarith
  · rcases eq_or_ne x 0 with rfl | hx
    · simp
    · have key : ∀ y : ℝ, 0 < y → y ≤ 1 → |Real.sin y - y| ≤ y ^ 3 / 4 := by
        intro y hy hy1
        have h1 := Real.sin_lt hy
        have h2 := Real.sin_gt_sub_cube hy hy1
        rw [abs_le]
        constructor <;> nlinarith
      have habs : |Real.sin x - x| ≤ |x| ^ 3 / 4 := by
        rcases lt_or_gt_of_ne hx with hneg | hpos
        · have hk := key (-x) (by linarith) (by rw [abs_of_neg hneg] at h; linarith)
          rw [Real.sin_neg] at hk
          have he : |Real.sin x - x| = |Real.sin (-x) - (-x)| := by
            rw [Real.sin_neg, ← abs_neg]
            ring_nf
          rw [he, abs_of_neg hneg]
          simpa using hk
        · have hk := key x hpos (by rw [abs_of_pos hpos] at h; linarith)
          rw [abs_of_pos hpos]
          exact hk
      rw [Real.sinc_of_ne_zero hx]
      have hx0 : |x| > 0 := abs_pos.2 hx
      have heq : |Real.sin x / x - 1| = |Real.sin x - x| / |x| := by
        rw [← abs_div]
        congr 1
        field_simp
      rw [heq, div_le_iff₀ hx0]
      have hcube : |x| ^ 3 = x ^ 2 * |x| := by rw [pow_succ, sq_abs]
      calc |Real.sin x - x| ≤ |x| ^ 3 / 4 := habs
      _ = x ^ 2 * |x| / 4 := by rw [hcube]
      _ ≤ 2 * x ^ 2 * |x| := by nlinarith [abs_nonneg x, sq_nonneg x]

lemma abs_siDiv_sub_one_le (a : ℝ) : |siDiv a - 1| ≤ 2 * a ^ 2 := by
  have hcont : Continuous fun t : ℝ => Real.sinc (a * t) :=
    Real.continuous_sinc.comp (continuous_const.mul continuous_id)
  have h1 : siDiv a - 1 = ∫ t in (0:ℝ)..1, (Real.sinc (a * t) - 1) := by
    rw [siDiv_eq_integral, intervalIntegral.integral_sub
      (hcont.intervalIntegrable _ _) (_root_.intervalIntegrable_const)]
    simp
  rw [h1]
  have hb : ∀ t ∈ Set.uIoc (0:ℝ) 1, ‖Real.sinc (a * t) - 1‖ ≤ 2 * a ^ 2 := by
    intro t ht
    rw [Set.uIoc_of_le zero_le_one] at ht
    have ht1 : t ^ 2 ≤ 1 := by nlinarith [ht.1, ht.2]
    calc ‖Real.sinc (a * t) - 1‖ = |Real.sinc (a * t) - 1| := rfl
    _ ≤ 2 * (a * t) ^ 2 := abs_sinc_sub_one_le _
    _ ≤ 2 * a ^ 2 := by nlinarith [sq_nonneg a, sq_nonneg t]
  have h2 := intervalIntegral.norm_integral_le_of_norm_le_const hb
  simpa using h2

/-- `siDiv` is differentiable at `0`, with vanishing derivative (it is an even function). -/
lemma siDiv_hasDerivAt_zero : HasDerivAt siDiv 0 0 := by
  rw [hasDerivAt_iff_tendsto_slope]
  have hsq : Filter.Tendsto (fun a : ℝ => 2 * |a|) (nhdsWithin (0:ℝ) {(0:ℝ)}ᶜ) (nhds 0) := by
    have h : Filter.Tendsto (fun a : ℝ => 2 * |a|) (nhds (0:ℝ)) (nhds 0) := by
      simpa using (continuous_const.mul continuous_abs).tendsto (0:ℝ)
    exact h.mono_left nhdsWithin_le_nhds
  refine squeeze_zero_norm (fun a => ?_) hsq
  rcases eq_or_ne a 0 with rfl | ha
  · simp
  · rw [slope_def_field, siDiv_zero,
      show (siDiv a - 1) / (a - 0) = (siDiv a - 1) / a by ring_nf, norm_div,
      div_le_iff₀ (by positivity)]
    calc ‖siDiv a - 1‖ = |siDiv a - 1| := rfl
    _ ≤ 2 * a ^ 2 := abs_siDiv_sub_one_le a
    _ = 2 * |a| * ‖a‖ := by
        rw [Real.norm_eq_abs, mul_assoc, ← abs_mul, abs_mul_self]
        ring_nf

/-- Away from `0`, `siDiv` is differentiable with the derivative given by the quotient rule. -/
lemma siDiv_hasDerivAt {a : ℝ} (ha : a ≠ 0) :
    HasDerivAt siDiv ((Real.sinc a * a - Si a) / a ^ 2) a := by
  have h : HasDerivAt (fun x => Si x / x) ((Real.sinc a * a - Si a * 1) / a ^ 2) a :=
    (Si_hasDerivAt a).div (hasDerivAt_id a) ha
  rw [mul_one] at h
  refine h.congr_of_eventuallyEq ?_
  filter_upwards [isOpen_ne.mem_nhds ha] with x hx
  exact siDiv_of_ne_zero hx

lemma intervalIntegrable_cos_mul_neg_log (c : ℝ) :
    IntervalIntegrable (fun t => Real.cos (c * t) * (-Real.log t)) volume 0 1 := by
  have hlog : IntervalIntegrable (fun t : ℝ => -Real.log t) volume 0 1 :=
    intervalIntegrable_log'.neg
  exact hlog.continuousOn_mul (by fun_prop)

/-- Integration by parts on `[ε, 1]` for the integral of `cos(a t)(-log t)`. -/
lemma integral_cos_mul_neg_log_aux {a : ℝ} (ha : a ≠ 0) {ε : ℝ} (hε : ε ∈ Set.Ioo (0:ℝ) 1) :
    (∫ t in ε..1, Real.cos (a * t) * (-Real.log t))
      = Real.log ε * (Real.sin (a * ε) / a) + ∫ t in ε..1, Real.sinc (a * t) := by
  have hpos : 0 < ε := hε.1
  have huIcc : Set.uIcc ε 1 = Set.Icc ε 1 := Set.uIcc_of_le hε.2.le
  have hne : ∀ x ∈ Set.uIcc ε 1, x ≠ 0 := by
    intro x hx
    rw [huIcc] at hx
    exact ne_of_gt (lt_of_lt_of_le hpos hx.1)
  have hu : ∀ x ∈ Set.uIcc ε 1, HasDerivAt (fun t => -Real.log t) (-(1/x)) x := by
    intro x hx
    simpa [one_div] using (Real.hasDerivAt_log (hne x hx)).neg
  have hv : ∀ x ∈ Set.uIcc ε 1,
      HasDerivAt (fun t => Real.sin (a * t) / a) (Real.cos (a * x)) x := by
    intro x _
    have h1 : HasDerivAt (fun t : ℝ => a * t) a x := by
      simpa using (hasDerivAt_id x).const_mul a
    have h2 : HasDerivAt (fun t : ℝ => Real.sin (a * t)) (Real.cos (a * x) * a) x :=
      (Real.hasDerivAt_sin (a * x)).comp x h1
    have := h2.div_const a
    rwa [mul_div_assoc, div_self ha, mul_one] at this
  have hu' : IntervalIntegrable (fun x : ℝ => -(1/x)) volume ε 1 := by
    refine ContinuousOn.intervalIntegrable ?_
    exact (continuousOn_const.div continuousOn_id fun y hy => hne y hy).neg
  have hv' : IntervalIntegrable (fun x : ℝ => Real.cos (a * x)) volume ε 1 :=
    (by fun_prop : Continuous fun x : ℝ => Real.cos (a * x)).intervalIntegrable _ _
  have IBP := intervalIntegral.integral_mul_deriv_eq_deriv_mul hu hv hu' hv'
  have hswap : (∫ t in ε..1, Real.cos (a * t) * (-Real.log t))
      = ∫ x in ε..1, (-Real.log x) * Real.cos (a * x) := by
    simp_rw [mul_comm]
  have hsinc : (∫ x in ε..1, (-(1/x)) * (Real.sin (a * x) / a))
      = -∫ t in ε..1, Real.sinc (a * t) := by
    rw [← intervalIntegral.integral_neg]
    refine intervalIntegral.integral_congr (fun x hx => ?_)
    have hx0 : x ≠ 0 := hne x hx
    have : a * x ≠ 0 := mul_ne_zero ha hx0
    rw [Real.sinc_of_ne_zero this]
    field_simp
  rw [hswap, IBP, hsinc]
  simp

/-- If `f` is interval integrable on `[0,1]`, then `∫_ε^1 f → ∫_0^1 f` as `ε → 0⁺`. -/
lemma tendsto_integral_left_endpoint {f : ℝ → ℝ} (hf : IntervalIntegrable f volume 0 1) :
    Filter.Tendsto (fun ε => ∫ t in ε..(1:ℝ), f t) (nhdsWithin (0:ℝ) (Set.Ioi 0))
      (nhds (∫ t in (0:ℝ)..1, f t)) := by
  have hmemIoo : Set.Ioo (0:ℝ) 1 ∈ nhdsWithin (0:ℝ) (Set.Ioi 0) := Ioo_mem_nhdsGT one_pos
  have hle : nhdsWithin (0:ℝ) (Set.Ioi 0) ≤ nhdsWithin (0:ℝ) (Set.uIcc (0:ℝ) 1) := by
    rw [nhdsWithin_le_iff, Set.uIcc_of_le (zero_le_one : (0:ℝ) ≤ 1)]
    exact Filter.mem_of_superset hmemIoo Set.Ioo_subset_Icc_self
  have hint : IntegrableOn f (Set.uIcc (0:ℝ) 1) volume := by
    rw [Set.uIcc_of_le (zero_le_one : (0:ℝ) ≤ 1)]
    exact (intervalIntegrable_iff_integrableOn_Icc_of_le zero_le_one).1 hf
  have hcont : ContinuousOn (fun x => ∫ t in (0:ℝ)..x, f t) (Set.uIcc (0:ℝ) 1) :=
    continuousOn_primitive_interval hint
  have h0 : Filter.Tendsto (fun x => ∫ t in (0:ℝ)..x, f t) (nhdsWithin (0:ℝ) (Set.Ioi 0))
      (nhds 0) := by
    have h := (hcont 0 (by simp)).mono_left hle
    simp only [intervalIntegral.integral_same] at h
    exact h
  have heq : ∀ ε ∈ Set.Ioo (0:ℝ) 1,
      (∫ t in ε..(1:ℝ), f t) = (∫ t in (0:ℝ)..1, f t) - ∫ t in (0:ℝ)..ε, f t := by
    intro ε hε
    have h1 : IntervalIntegrable f volume 0 ε := hf.mono_set (by
      rw [Set.uIcc_of_le hε.1.le, Set.uIcc_of_le (zero_le_one : (0:ℝ) ≤ 1)]
      exact Set.Icc_subset_Icc le_rfl hε.2.le)
    have h2 : IntervalIntegrable f volume ε 1 := hf.mono_set (by
      rw [Set.uIcc_of_le hε.2.le, Set.uIcc_of_le (zero_le_one : (0:ℝ) ≤ 1)]
      exact Set.Icc_subset_Icc hε.1.le le_rfl)
    rw [eq_sub_iff_add_eq, add_comm]
    exact intervalIntegral.integral_add_adjacent_intervals h1 h2
  have hsub := (tendsto_const_nhds (x := ∫ t in (0:ℝ)..1, f t)
    (f := nhdsWithin (0:ℝ) (Set.Ioi 0))).sub h0
  rw [sub_zero] at hsub
  refine hsub.congr' ?_
  filter_upwards [hmemIoo] with ε hε using (heq ε hε).symm

/-- **Key integral identity** (the computation preceding equation (49) of arXiv:2006.13771):
`∫₀¹ cos(a t)(-log t) dt = Si(a)/a`. -/
theorem integral_cos_mul_neg_log (a : ℝ) :
    (∫ t in (0:ℝ)..1, Real.cos (a * t) * (-Real.log t)) = siDiv a := by
  rcases eq_or_ne a 0 with rfl | ha
  · simp only [zero_mul, Real.cos_zero, one_mul, siDiv_zero]
    rw [intervalIntegral.integral_neg, integral_log]
    norm_num
  have hsincint : IntervalIntegrable (fun t => Real.sinc (a * t)) volume 0 1 :=
    (Real.continuous_sinc.comp (by fun_prop)).intervalIntegrable _ _
  -- the left-hand side is the limit of the integrals over `[ε, 1]`
  have hA : Filter.Tendsto (fun ε => ∫ t in ε..(1:ℝ), Real.cos (a * t) * (-Real.log t))
      (nhdsWithin (0:ℝ) (Set.Ioi 0))
      (nhds (∫ t in (0:ℝ)..1, Real.cos (a * t) * (-Real.log t))) :=
    tendsto_integral_left_endpoint (intervalIntegrable_cos_mul_neg_log a)
  -- and, after integrating by parts, also the limit of `log ε · sin(aε)/a + ∫_ε^1 sinc(a t)`
  have hboundary : Filter.Tendsto (fun ε : ℝ => Real.log ε * (Real.sin (a * ε) / a))
      (nhdsWithin (0:ℝ) (Set.Ioi 0)) (nhds 0) := by
    have h1 : Filter.Tendsto (fun ε : ℝ => Real.log ε * ε)
        (nhdsWithin (0:ℝ) (Set.Ioi 0)) (nhds 0) := by
      have := tendsto_log_mul_rpow_nhdsGT_zero (r := 1) one_pos
      simpa using this
    have h2 : Filter.Tendsto (fun ε : ℝ => Real.sinc (a * ε))
        (nhdsWithin (0:ℝ) (Set.Ioi 0)) (nhds 1) := by
      have hc : Filter.Tendsto (fun ε : ℝ => Real.sinc (a * ε)) (nhds 0) (nhds (Real.sinc 0)) :=
        (Real.continuous_sinc.comp (by fun_prop)).tendsto' 0 _ (by simp)
      rw [Real.sinc_zero] at hc
      exact hc.mono_left nhdsWithin_le_nhds
    have h3 := h1.mul h2
    rw [zero_mul] at h3
    refine h3.congr' ?_
    filter_upwards [self_mem_nhdsWithin] with ε hε
    have hε0 : ε ≠ 0 := ne_of_gt hε
    rw [Real.sinc_of_ne_zero (mul_ne_zero ha hε0)]
    field_simp
  have hB : Filter.Tendsto (fun ε => ∫ t in ε..(1:ℝ), Real.cos (a * t) * (-Real.log t))
      (nhdsWithin (0:ℝ) (Set.Ioi 0)) (nhds (siDiv a)) := by
    have hlim := hboundary.add (tendsto_integral_left_endpoint hsincint)
    rw [zero_add, ← siDiv_eq_integral a] at hlim
    refine hlim.congr' ?_
    filter_upwards [Ioo_mem_nhdsGT (one_pos : (0:ℝ) < 1)] with ε hε
    exact (integral_cos_mul_neg_log_aux ha hε).symm
  exact tendsto_nhds_unique hA hB

end ConnesConsani.WeilPositivity
