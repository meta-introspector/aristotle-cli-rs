/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
Authors: Formalization of
  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771

**Frullani's integral for the logarithm.**

For every `t > 0`,

  `∫_0^∞ (e^{-v} - e^{-tv}) dv / v = log t`.

This is the representation of `log` used to evaluate the universal constant of the
even (Sonin) renormalized trace formula.  The proof differentiates under the integral
sign: the `t`-derivative of the integrand is `e^{-tv}`, whose integral over `(0,∞)` is
`1/t`, and the value at `t = 1` is `0`.
-/
import Mathlib

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Filter Topology Set Real

namespace ConnesConsani.WeilPositivity

/-! ## 1. Elementary bounds -/

/-- `x ↦ exp (-x)` is `1`-Lipschitz on `[0,∞)`. -/
theorem abs_exp_neg_sub_exp_neg_le {a b : ℝ} (ha : 0 ≤ a) (hb : 0 ≤ b) :
    |Real.exp (-a) - Real.exp (-b)| ≤ |a - b| := by
  -- reduce to the case `a ≤ b`
  rcases le_total a b with h | h
  · have hkey : Real.exp (-a) - Real.exp (-b) ≤ b - a := by
      have h1 : Real.exp (-(b - a)) ≥ 1 - (b - a) := by
        have := Real.add_one_le_exp (-(b - a))
        linarith
      have h2 : Real.exp (-b) = Real.exp (-a) * Real.exp (-(b - a)) := by
        rw [← Real.exp_add]; ring_nf
      have h3 : Real.exp (-a) ≤ 1 := by
        rw [Real.exp_le_one_iff]; linarith
      have h4 : (0:ℝ) < Real.exp (-a) := Real.exp_pos _
      nlinarith [Real.exp_pos (-(b-a))]
    have hlow : 0 ≤ Real.exp (-a) - Real.exp (-b) := by
      have : Real.exp (-b) ≤ Real.exp (-a) := Real.exp_le_exp.2 (by linarith)
      linarith
    rw [abs_of_nonneg hlow, abs_of_nonpos (by linarith : a - b ≤ 0)]
    linarith
  · have hkey : Real.exp (-b) - Real.exp (-a) ≤ a - b := by
      have hab : 0 ≤ a - b := by linarith
      have h1 : Real.exp (-(a - b)) ≥ 1 - (a - b) := by
        have := Real.add_one_le_exp (-(a - b))
        linarith
      have h2 : Real.exp (-a) = Real.exp (-b) * Real.exp (-(a - b)) := by
        rw [← Real.exp_add]; ring_nf
      have h3 : Real.exp (-b) ≤ 1 := by
        rw [Real.exp_le_one_iff]; linarith
      have hexp : Real.exp (-b) - Real.exp (-a)
          = Real.exp (-b) * (1 - Real.exp (-(a - b))) := by rw [h2]; ring
      have hstep : Real.exp (-b) * (1 - Real.exp (-(a - b))) ≤ Real.exp (-b) * (a - b) :=
        mul_le_mul_of_nonneg_left (by linarith) (Real.exp_pos _).le
      have hstep2 : Real.exp (-b) * (a - b) ≤ 1 * (a - b) :=
        mul_le_mul_of_nonneg_right h3 hab
      linarith
    have hlow : 0 ≤ Real.exp (-b) - Real.exp (-a) := by
      have : Real.exp (-a) ≤ Real.exp (-b) := Real.exp_le_exp.2 (by linarith)
      linarith
    rw [abs_of_nonpos (by linarith : Real.exp (-a) - Real.exp (-b) ≤ 0),
      abs_of_nonneg (by linarith : (0:ℝ) ≤ a - b)]
    linarith

/-! ## 2. The Frullani integrand -/

/-- The Frullani integrand `(e^{-v} - e^{-tv})/v`. -/
def frullaniFun (t v : ℝ) : ℝ := (Real.exp (-v) - Real.exp (-(t * v))) / v

theorem abs_frullaniFun_le {t v : ℝ} (ht : 0 ≤ t) (hv : 0 < v) :
    |frullaniFun t v| ≤ |1 - t| := by
  have h := abs_exp_neg_sub_exp_neg_le (a := v) (b := t * v) hv.le (by positivity)
  rw [frullaniFun, abs_div, abs_of_pos hv, div_le_iff₀ hv]
  calc |Real.exp (-v) - Real.exp (-(t * v))| ≤ |v - t * v| := h
    _ = |1 - t| * v := by
        rw [show v - t * v = (1 - t) * v by ring, abs_mul, abs_of_pos hv]

theorem measurable_frullaniFun (t : ℝ) : Measurable (frullaniFun t) := by
  unfold frullaniFun
  fun_prop

theorem integrableOn_frullaniFun {t : ℝ} (ht : 0 < t) :
    IntegrableOn (frullaniFun t) (Ioi 0) := by
  have hsplit : Ioi (0:ℝ) = Ioc 0 1 ∪ Ioi 1 := by
    ext x; simp only [mem_Ioi, mem_union, mem_Ioc]; constructor
    · intro hx; rcases le_or_gt x 1 with h | h
      · exact Or.inl ⟨hx, h⟩
      · exact Or.inr h
    · rintro (⟨hx, _⟩ | hx) <;> linarith
  rw [hsplit]
  refine IntegrableOn.union ?_ ?_
  · -- bounded on `(0,1]`
    refine Measure.integrableOn_of_bounded (M := |1 - t|) (by simp) ?_ ?_
    · exact (measurable_frullaniFun t).aestronglyMeasurable
    · filter_upwards [self_mem_ae_restrict measurableSet_Ioc] with v hv
      exact abs_frullaniFun_le ht.le hv.1
  · -- exponentially small on `(1,∞)`
    have h1 : IntegrableOn (fun v : ℝ => Real.exp (-v)) (Ioi 1) := integrableOn_exp_neg_Ioi 1
    have h2 : IntegrableOn (fun v : ℝ => Real.exp (-(t * v))) (Ioi 1) := by
      have := exp_neg_integrableOn_Ioi (1:ℝ) ht
      simpa [neg_mul] using this
    have h3 : IntegrableOn (fun v : ℝ => Real.exp (-v) + Real.exp (-(t * v))) (Ioi 1) :=
      h1.add h2
    refine Integrable.mono' h3 ((measurable_frullaniFun t).aestronglyMeasurable.restrict) ?_
    filter_upwards [self_mem_ae_restrict measurableSet_Ioi] with v hv
    have hv1 : (1:ℝ) < v := hv
    have hv0 : (0:ℝ) < v := lt_trans zero_lt_one hv1
    rw [frullaniFun, norm_div, Real.norm_eq_abs, Real.norm_eq_abs, abs_of_pos hv0,
      div_le_iff₀ hv0]
    have habs : |Real.exp (-v) - Real.exp (-(t * v))|
        ≤ Real.exp (-v) + Real.exp (-(t * v)) := by
      have := abs_sub (Real.exp (-v)) (Real.exp (-(t * v)))
      rw [abs_of_pos (Real.exp_pos _), abs_of_pos (Real.exp_pos _)] at this
      exact this
    nlinarith [Real.exp_pos (-v), Real.exp_pos (-(t*v))]

/-! ## 3. Differentiation under the integral sign -/

theorem integral_exp_neg_mul_Ioi_zero {t : ℝ} (ht : 0 < t) :
    ∫ v in Ioi (0:ℝ), Real.exp (-(t * v)) = 1 / t := by
  have hderiv : ∀ v : ℝ,
      HasDerivAt (fun v : ℝ => -(1 / t) * Real.exp (-(t * v))) (Real.exp (-(t * v))) v := by
    intro v
    have h1 : HasDerivAt (fun v : ℝ => -(t * v)) (-t) v := by
      simpa using ((hasDerivAt_id v).const_mul t).neg
    have h2 := (Real.hasDerivAt_exp (-(t * v))).comp v h1
    have h3 := h2.const_mul (-(1 / t))
    convert h3 using 1
    field_simp
  have hint : IntegrableOn (fun v : ℝ => Real.exp (-(t * v))) (Ioi 0) := by
    have := exp_neg_integrableOn_Ioi (0:ℝ) ht
    simpa [neg_mul] using this
  have hlim : Tendsto (fun v : ℝ => -(1 / t) * Real.exp (-(t * v))) atTop (𝓝 0) := by
    have hmul : Tendsto (fun v : ℝ => t * v) atTop atTop :=
      Filter.Tendsto.const_mul_atTop ht tendsto_id
    have hneg : Tendsto (fun v : ℝ => -(t * v)) atTop atBot := tendsto_neg_atTop_atBot.comp hmul
    have h0 : Tendsto (fun v : ℝ => Real.exp (-(t * v))) atTop (𝓝 0) :=
      Real.tendsto_exp_atBot.comp hneg
    simpa using h0.const_mul (-(1 / t))
  have hmain := integral_Ioi_of_hasDerivAt_of_tendsto'
    (f := fun v : ℝ => -(1 / t) * Real.exp (-(t * v)))
    (f' := fun v : ℝ => Real.exp (-(t * v))) (a := 0) (m := 0)
    (fun v _ => hderiv v) hint hlim
  rw [hmain]
  simp

/-! ## 4. Frullani's formula -/

/-- The Frullani integral `∫_0^∞ (e^{-v} - e^{-tv}) dv/v`. -/
def frullaniLog (t : ℝ) : ℝ := ∫ v in Ioi (0:ℝ), frullaniFun t v

theorem hasDerivAt_frullaniLog {t : ℝ} (ht : 0 < t) : HasDerivAt frullaniLog (1 / t) t := by
  have hs : Ioo (t / 2) (2 * t) ∈ 𝓝 t := Ioo_mem_nhds (by linarith) (by linarith)
  have hbdd : IntegrableOn (fun v : ℝ => Real.exp (-(t / 2 * v))) (Ioi 0) := by
    have := exp_neg_integrableOn_Ioi (0:ℝ) (by linarith : (0:ℝ) < t / 2)
    simpa [neg_mul] using this
  have hdiff : ∀ᵐ v ∂(volume.restrict (Ioi (0:ℝ))), ∀ x ∈ Ioo (t / 2) (2 * t),
      HasDerivAt (fun x : ℝ => frullaniFun x v) (Real.exp (-(x * v))) x := by
    filter_upwards [self_mem_ae_restrict measurableSet_Ioi] with v hv x _
    have hv0 : (0:ℝ) < v := hv
    have h1 : HasDerivAt (fun x : ℝ => -(x * v)) (-v) x := by
      simpa using ((hasDerivAt_id x).mul_const v).neg
    have h2 := (Real.hasDerivAt_exp (-(x * v))).comp x h1
    have h3 : HasDerivAt (fun x : ℝ => Real.exp (-v) - Real.exp (-(x * v)))
        (Real.exp (-(x * v)) * v) x := by
      have := (hasDerivAt_const x (Real.exp (-v))).sub h2
      convert this using 1
      ring
    have h4 := h3.div_const v
    convert h4 using 1
    field_simp
  have hmeas : ∀ᶠ x in 𝓝 t, AEStronglyMeasurable (fun v => frullaniFun x v)
      (volume.restrict (Ioi (0:ℝ))) := by
    filter_upwards with x
    exact (measurable_frullaniFun x).aestronglyMeasurable
  have hbound : ∀ᵐ v ∂(volume.restrict (Ioi (0:ℝ))), ∀ x ∈ Ioo (t / 2) (2 * t),
      ‖Real.exp (-(x * v))‖ ≤ Real.exp (-(t / 2 * v)) := by
    filter_upwards [self_mem_ae_restrict measurableSet_Ioi] with v hv x hx
    have hv0 : (0:ℝ) < v := hv
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
    exact Real.exp_le_exp.2 (by nlinarith [hx.1])
  have hkey := hasDerivAt_integral_of_dominated_loc_of_deriv_le
    (F := fun x v => frullaniFun x v) (F' := fun x v => Real.exp (-(x * v)))
    (bound := fun v => Real.exp (-(t / 2 * v))) (x₀ := t)
    hs hmeas (integrableOn_frullaniFun ht)
    (by fun_prop) hbound hbdd hdiff
  have := hkey.2
  rwa [integral_exp_neg_mul_Ioi_zero ht] at this

/-- **Frullani's integral for the logarithm.** -/
theorem frullaniLog_eq_log {t : ℝ} (ht : 0 < t) : frullaniLog t = Real.log t := by
  have hpos : ∀ x ∈ uIcc (1:ℝ) t, 0 < x := by
    intro x hx
    rcases le_total (1:ℝ) t with h | h
    · rw [uIcc_of_le h] at hx; linarith [hx.1]
    · rw [uIcc_of_ge h] at hx; linarith [hx.1]
  have hzero : (0:ℝ) ∉ uIcc (1:ℝ) t := fun h => lt_irrefl (0:ℝ) (hpos 0 h)
  have hderiv : ∀ x ∈ uIcc (1:ℝ) t, HasDerivAt frullaniLog (1 / x) x :=
    fun x hx => hasDerivAt_frullaniLog (hpos x hx)
  have hint : IntervalIntegrable (fun x : ℝ => 1 / x) volume 1 t :=
    intervalIntegral.intervalIntegrable_one_div (fun x hx => (hpos x hx).ne') (by fun_prop)
  have hFTC := intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv hint
  have hval : ∫ x in (1:ℝ)..t, 1 / x = Real.log t := by
    rw [integral_one_div hzero]
    simp
  have h1 : frullaniLog 1 = 0 := by
    simp [frullaniLog, frullaniFun]
  rw [hval, h1, sub_zero] at hFTC
  exact hFTC.symm

/-- Frullani's formula in integral form. -/
theorem integral_frullaniFun {t : ℝ} (ht : 0 < t) :
    ∫ v in Ioi (0:ℝ), (Real.exp (-v) - Real.exp (-(t * v))) / v = Real.log t :=
  frullaniLog_eq_log ht

end ConnesConsani.WeilPositivity
