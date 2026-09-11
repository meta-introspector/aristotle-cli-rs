/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
Authors: Formalization of
  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771

**The closed form of the sine-integral logarithmic constant.**

`RequestProject/CutoffConstants.lean` introduces

  `siLogConst = lim_{X→∞} (∫_0^X Si(s) ds/s - (π/2) log X)`.

This file evaluates it:  `siLogConst = π γ / 2`, `γ` Euler's constant.

The proof runs through the *sine plateau*

  `P(t) = Si t - π/2 + (π/2) e^{-t}`,

the primitive of `sinc t - (π/2) e^{-t}` vanishing at `0` and at `+∞`, and decaying like
`1/t`.  Its Laplace transform is the regularized arctangent
`arctanReg v = (π/2)/(1+v) - (arctan v)/v`, so Fubini for `1/t = ∫_0^∞ e^{-tv} dv` gives

  `∫_0^∞ P(t) dt/t = ∫_0^∞ arctanReg v dv = 0`,

and two integrations by parts turn this into `siLogConst = π γ / 2`.
-/
import RequestProject.Imported.OutputFinal.RequestProject.LaplaceSinc
import RequestProject.Imported.OutputFinal.RequestProject.ArctanSymmetry
import RequestProject.Imported.OutputFinal.RequestProject.CutoffConstants

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Filter Topology Set Real

namespace ConnesConsani.WeilPositivity

/-! ## 1. The sine plateau and its elementary bounds -/

/-- The *sine plateau* `P(t) = Si t - π/2 + (π/2) e^{-t}`: the primitive of
`sinc t - (π/2) e^{-t}` which vanishes both at `0` and at `+∞`. -/
def sinePlateau (t : ℝ) : ℝ := Si t - π / 2 + (π / 2) * Real.exp (-t)

@[simp] theorem sinePlateau_zero : sinePlateau 0 = 0 := by
  simp [sinePlateau]

theorem hasDerivAt_sinePlateau (t : ℝ) :
    HasDerivAt sinePlateau (Real.sinc t - (π / 2) * Real.exp (-t)) t := by
  have h1 := (Si_hasDerivAt t).sub_const (π / 2)
  have h2 : HasDerivAt (fun t : ℝ => Real.exp (-t)) (-Real.exp (-t)) t := by
    simpa using ((hasDerivAt_id t).neg).exp
  have h3 := h2.const_mul (π / 2)
  have := h1.add h3
  convert this using 1
  ring

theorem abs_Si_le (t : ℝ) (ht : 0 ≤ t) : |Si t| ≤ t := by
  have h := intervalIntegral.norm_integral_le_of_norm_le_const
    (a := (0:ℝ)) (b := t) (f := Real.sinc) (C := 1)
    (fun x _ => by simpa using Real.abs_sinc_le_one x)
  simpa [Si, abs_of_nonneg ht] using h

theorem abs_sinePlateau_le_linear {t : ℝ} (ht : 0 ≤ t) :
    |sinePlateau t| ≤ (1 + π / 2) * t := by
  have h1 : |Si t| ≤ t := abs_Si_le t ht
  have h2 : |Real.exp (-t) - 1| ≤ t := by
    have h := abs_exp_neg_sub_exp_neg_le (a := t) (b := 0) ht le_rfl
    rw [neg_zero, Real.exp_zero, sub_zero, abs_of_nonneg ht] at h
    exact h
  have hpi : (0:ℝ) < π := Real.pi_pos
  have hrw : sinePlateau t = Si t + (π / 2) * (Real.exp (-t) - 1) := by
    rw [sinePlateau]; ring
  rw [hrw]
  have h3 : |(π / 2) * (Real.exp (-t) - 1)| ≤ (π / 2) * t := by
    rw [abs_mul, abs_of_pos (by positivity : (0:ℝ) < π / 2)]
    exact mul_le_mul_of_nonneg_left h2 (by positivity)
  calc |Si t + (π / 2) * (Real.exp (-t) - 1)| ≤ |Si t| + |(π / 2) * (Real.exp (-t) - 1)| :=
        abs_add_le _ _
    _ ≤ t + (π / 2) * t := by linarith
    _ = (1 + π / 2) * t := by ring

theorem abs_sinePlateau_le_inv {t : ℝ} (ht : 1 ≤ t) :
    |sinePlateau t| ≤ (2 + π / 2) / t := by
  have ht0 : (0:ℝ) < t := lt_of_lt_of_le zero_lt_one ht
  have h1 : |Si t - π / 2| ≤ 1 / t + 1 / t ^ 2 := abs_Si_sub_pi_div_two_le ht0
  have h1' : 1 / t ^ 2 ≤ 1 / t := by
    rw [div_le_div_iff₀ (by positivity) ht0]
    nlinarith
  have h2 : Real.exp (-t) ≤ 1 / t := by
    have hexp : t ≤ Real.exp t := by
      have := Real.add_one_le_exp t; linarith
    have hpos := Real.exp_pos t
    rw [Real.exp_neg, inv_eq_one_div, div_le_div_iff₀ hpos ht0]
    nlinarith
  have h3 : |(π / 2) * Real.exp (-t)| ≤ (π / 2) * (1 / t) := by
    rw [abs_mul, abs_of_pos (by positivity : (0:ℝ) < π / 2), abs_of_pos (Real.exp_pos _)]
    exact mul_le_mul_of_nonneg_left h2 (by positivity)
  have hrw : sinePlateau t = (Si t - π / 2) + (π / 2) * Real.exp (-t) := by
    rw [sinePlateau]
  rw [hrw]
  have hsum : |(Si t - π / 2) + (π / 2) * Real.exp (-t)|
      ≤ |Si t - π / 2| + |(π / 2) * Real.exp (-t)| := abs_add_le _ _
  have : (2 + π / 2) / t = 1 / t + 1 / t + (π / 2) * (1 / t) := by field_simp; ring
  rw [this]
  linarith

theorem abs_sinePlateau_le_const (t : ℝ) (ht : 0 ≤ t) : |sinePlateau t| ≤ 1 + π := by
  rcases le_or_gt t 1 with h | h
  · have := abs_sinePlateau_le_linear ht
    nlinarith [Real.pi_pos]
  · have h2 := abs_sinePlateau_le_inv h.le
    have ht0 : (0:ℝ) < t := lt_trans zero_lt_one h
    have h3 : (2 + π / 2) / t ≤ 2 + π / 2 := by
      rw [div_le_iff₀ ht0]
      nlinarith [Real.pi_pos]
    linarith [Real.pi_gt_three]

theorem continuous_sinePlateau : Continuous sinePlateau := by
  unfold sinePlateau
  exact (Si_continuous.sub continuous_const).add
    (continuous_const.mul (Real.continuous_exp.comp continuous_neg))

/-! ## 2. Integrability of `P(t)/t` -/

theorem integrableOn_sinePlateau_div :
    IntegrableOn (fun t : ℝ => sinePlateau t / t) (Ioi 0) := by
  have hmeas : AEStronglyMeasurable (fun t : ℝ => sinePlateau t / t) volume :=
    (continuous_sinePlateau.measurable.div measurable_id).aestronglyMeasurable
  have hsplit : Ioi (0:ℝ) = Ioc 0 1 ∪ Ioi 1 := by
    ext x; simp only [mem_Ioi, mem_union, mem_Ioc]; constructor
    · intro hx; rcases le_or_gt x 1 with h | h
      · exact Or.inl ⟨hx, h⟩
      · exact Or.inr h
    · rintro (⟨hx, _⟩ | hx) <;> linarith
  rw [hsplit]
  refine IntegrableOn.union ?_ ?_
  · refine Measure.integrableOn_of_bounded (M := 1 + π / 2) (by simp) hmeas ?_
    filter_upwards [self_mem_ae_restrict measurableSet_Ioc] with t ht
    have ht0 : (0:ℝ) < t := ht.1
    rw [Real.norm_eq_abs, abs_div, abs_of_pos ht0, div_le_iff₀ ht0]
    have := abs_sinePlateau_le_linear ht0.le
    linarith
  · have hb : IntegrableOn (fun t : ℝ => (2 + π / 2) / t ^ 2) (Ioi 1) := by
      have h2 : IntegrableOn (fun v : ℝ => v ^ (-2 : ℝ)) (Ioi (1:ℝ)) :=
        integrableOn_Ioi_rpow_of_lt (by norm_num) (by norm_num : (0:ℝ) < 1)
      refine MeasureTheory.IntegrableOn.congr_fun (h2.const_mul (2 + π / 2)) ?_
        measurableSet_Ioi
      intro v hv
      have hv0 : (0:ℝ) < v := lt_trans zero_lt_one hv
      show (2 + π / 2) * v ^ (-2 : ℝ) = (2 + π / 2) / v ^ 2
      rw [show ((-2 : ℝ)) = -((2:ℕ):ℝ) by norm_num, Real.rpow_neg hv0.le, Real.rpow_natCast]
      field_simp
    refine Integrable.mono' hb hmeas.restrict ?_
    filter_upwards [self_mem_ae_restrict measurableSet_Ioi] with t ht
    have ht1 : (1:ℝ) < t := ht
    have ht0 : (0:ℝ) < t := lt_trans zero_lt_one ht1
    rw [Real.norm_eq_abs, abs_div, abs_of_pos ht0, div_le_div_iff₀ ht0 (by positivity)]
    have h := abs_sinePlateau_le_inv ht1.le
    have h' : |sinePlateau t| * t ≤ 2 + π / 2 := by
      have hm := mul_le_mul_of_nonneg_right h ht0.le
      rwa [div_mul_cancel₀ _ ht0.ne'] at hm
    nlinarith [abs_nonneg (sinePlateau t)]

/-! ## 3. The Laplace transform of the sine plateau -/

theorem integrableOn_sinePlateau_exp {v : ℝ} (hv : 0 < v) :
    IntegrableOn (fun t : ℝ => sinePlateau t * Real.exp (-(v * t))) (Ioi 0) := by
  have hb : IntegrableOn (fun t : ℝ => (1 + π) * Real.exp (-(v * t))) (Ioi 0) := by
    have h : IntegrableOn (fun t : ℝ => Real.exp (-(v * t))) (Ioi 0) := by
      simpa [neg_mul] using exp_neg_integrableOn_Ioi (0:ℝ) hv
    exact h.const_mul _
  refine Integrable.mono' hb
    ((continuous_sinePlateau.mul (by fun_prop)).aestronglyMeasurable.restrict) ?_
  filter_upwards [self_mem_ae_restrict measurableSet_Ioi] with t ht
  have ht0 : (0:ℝ) < t := ht
  rw [norm_mul, Real.norm_eq_abs, Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
  have := abs_sinePlateau_le_const t ht0.le
  nlinarith [Real.exp_pos (-(v * t)), abs_nonneg (sinePlateau t)]

/-- **The Laplace transform of the sine plateau is the regularized arctangent.** -/
theorem integral_sinePlateau_exp {v : ℝ} (hv : 0 < v) :
    ∫ t in Ioi (0:ℝ), sinePlateau t * Real.exp (-(v * t)) = arctanReg v := by
  have hv1 : (0:ℝ) < 1 + v := by linarith
  set F : ℝ → ℝ := fun t =>
    -(Si t - π / 2) * Real.exp (-(v * t)) / v
      - (π / 2) * Real.exp (-((1 + v) * t)) / (1 + v) with hF
  have hderiv : ∀ t : ℝ, HasDerivAt F
      (sinePlateau t * Real.exp (-(v * t)) - Real.sinc t * Real.exp (-(v * t)) / v) t := by
    intro t
    have he : HasDerivAt (fun t : ℝ => Real.exp (-(v * t))) (Real.exp (-(v * t)) * (-v)) t := by
      have h1 : HasDerivAt (fun t : ℝ => -(v * t)) (-v) t := by
        simpa using ((hasDerivAt_id t).const_mul v).neg
      exact h1.exp
    have hS : HasDerivAt (fun t : ℝ => -(Si t - π / 2)) (-Real.sinc t) t :=
      ((Si_hasDerivAt t).sub_const (π / 2)).neg
    have hA : HasDerivAt (fun t : ℝ => -(Si t - π / 2) * Real.exp (-(v * t)) / v)
        ((-Real.sinc t * Real.exp (-(v * t)) + -(Si t - π / 2) * (Real.exp (-(v * t)) * (-v))) / v)
        t := (hS.mul he).div_const v
    have he2 : HasDerivAt (fun t : ℝ => Real.exp (-((1 + v) * t)))
        (Real.exp (-((1 + v) * t)) * (-(1 + v))) t := by
      have h1 : HasDerivAt (fun t : ℝ => -((1 + v) * t)) (-(1 + v)) t := by
        simpa using ((hasDerivAt_id t).const_mul (1 + v)).neg
      exact h1.exp
    have hB : HasDerivAt (fun t : ℝ => (π / 2) * Real.exp (-((1 + v) * t)) / (1 + v))
        ((π / 2) * (Real.exp (-((1 + v) * t)) * (-(1 + v))) / (1 + v)) t :=
      (he2.const_mul (π / 2)).div_const (1 + v)
    have := hA.sub hB
    rw [hF]
    convert this using 1
    have hexp : Real.exp (-((1 + v) * t)) = Real.exp (-t) * Real.exp (-(v * t)) := by
      rw [← Real.exp_add]; ring_nf
    rw [sinePlateau, hexp]
    field_simp
    ring
  have hint : IntegrableOn
      (fun t : ℝ => sinePlateau t * Real.exp (-(v * t))
        - Real.sinc t * Real.exp (-(v * t)) / v) (Ioi 0) := by
    refine (integrableOn_sinePlateau_exp hv).sub ?_
    have hb : IntegrableOn (fun t : ℝ => Real.exp (-(v * t)) / v) (Ioi 0) := by
      have h : IntegrableOn (fun t : ℝ => Real.exp (-(v * t))) (Ioi 0) := by
        simpa [neg_mul] using exp_neg_integrableOn_Ioi (0:ℝ) hv
      exact h.div_const v
    refine Integrable.mono' hb (by fun_prop) ?_
    filter_upwards with t
    rw [norm_div, norm_mul, Real.norm_eq_abs, Real.norm_eq_abs, Real.norm_eq_abs,
      abs_of_pos (Real.exp_pos _), abs_of_pos hv]
    have := Real.abs_sinc_le_one t
    have hpos := Real.exp_pos (-(v * t))
    gcongr
    nlinarith
  have hlim : Tendsto F atTop (𝓝 0) := by
    have hmul : Tendsto (fun t : ℝ => v * t) atTop atTop :=
      Filter.Tendsto.const_mul_atTop hv tendsto_id
    have hneg : Tendsto (fun t : ℝ => -(v * t)) atTop atBot := tendsto_neg_atTop_atBot.comp hmul
    have h0 : Tendsto (fun t : ℝ => Real.exp (-(v * t))) atTop (𝓝 0) :=
      Real.tendsto_exp_atBot.comp hneg
    have hmul2 : Tendsto (fun t : ℝ => (1 + v) * t) atTop atTop :=
      Filter.Tendsto.const_mul_atTop hv1 tendsto_id
    have hneg2 : Tendsto (fun t : ℝ => -((1 + v) * t)) atTop atBot :=
      tendsto_neg_atTop_atBot.comp hmul2
    have h02 : Tendsto (fun t : ℝ => Real.exp (-((1 + v) * t))) atTop (𝓝 0) :=
      Real.tendsto_exp_atBot.comp hneg2
    have hSi : Tendsto (fun t : ℝ => -(Si t - π / 2)) atTop (𝓝 0) := by
      have := tendsto_Si_atTop
      simpa using (this.sub_const (π / 2)).neg
    have hp1 : Tendsto (fun t : ℝ => -(Si t - π / 2) * Real.exp (-(v * t)) / v) atTop (𝓝 0) := by
      simpa using ((hSi.mul h0).div_const v)
    have hp2 : Tendsto (fun t : ℝ => (π / 2) * Real.exp (-((1 + v) * t)) / (1 + v))
        atTop (𝓝 0) := by
      simpa using ((h02.const_mul (π / 2)).div_const (1 + v))
    simpa [hF] using hp1.sub hp2
  have hFTC := integral_Ioi_of_hasDerivAt_of_tendsto' (f := F)
    (f' := fun t : ℝ => sinePlateau t * Real.exp (-(v * t))
      - Real.sinc t * Real.exp (-(v * t)) / v)
    (a := 0) (m := 0) (fun t _ => hderiv t) hint hlim
  have hsinc : ∫ t in Ioi (0:ℝ), Real.sinc t * Real.exp (-(v * t)) / v
      = Real.arctan (1 / v) / v := by
    have hcongr : ∫ t in Ioi (0:ℝ), Real.sinc t * Real.exp (-(v * t)) / v
        = ∫ t in Ioi (0:ℝ), (Real.exp (-(v * t)) * (Real.sin t / t)) / v := by
      refine setIntegral_congr_fun measurableSet_Ioi ?_
      intro t ht
      have ht0 : (0:ℝ) < t := ht
      show Real.sinc t * Real.exp (-(v * t)) / v = Real.exp (-(v * t)) * (Real.sin t / t) / v
      rw [Real.sinc_of_ne_zero ht0.ne']
      ring
    rw [hcongr, MeasureTheory.integral_div]
    rw [show (∫ t in Ioi (0:ℝ), Real.exp (-(v * t)) * (Real.sin t / t)) = laplaceSinc v from rfl,
      laplaceSinc_eq_arctan hv]
  have hsplit : ∫ t in Ioi (0:ℝ), (sinePlateau t * Real.exp (-(v * t))
      - Real.sinc t * Real.exp (-(v * t)) / v)
      = (∫ t in Ioi (0:ℝ), sinePlateau t * Real.exp (-(v * t)))
        - ∫ t in Ioi (0:ℝ), Real.sinc t * Real.exp (-(v * t)) / v := by
    refine MeasureTheory.integral_sub (integrableOn_sinePlateau_exp hv) ?_
    have hb : IntegrableOn (fun t : ℝ => Real.exp (-(v * t)) / v) (Ioi 0) := by
      have h : IntegrableOn (fun t : ℝ => Real.exp (-(v * t))) (Ioi 0) := by
        simpa [neg_mul] using exp_neg_integrableOn_Ioi (0:ℝ) hv
      exact h.div_const v
    refine Integrable.mono' hb (by fun_prop) ?_
    filter_upwards with t
    rw [norm_div, norm_mul, Real.norm_eq_abs, Real.norm_eq_abs, Real.norm_eq_abs,
      abs_of_pos (Real.exp_pos _), abs_of_pos hv]
    have := Real.abs_sinc_le_one t
    gcongr
    nlinarith [Real.exp_pos (-(v * t))]
  rw [hsplit, hsinc] at hFTC
  have hF0 : F 0 = π / (2 * v) - (π / 2) / (1 + v) := by
    rw [hF]
    simp only [mul_zero, neg_zero, Real.exp_zero, mul_one, Si_zero, zero_sub, neg_neg]
    field_simp
  have harc : Real.arctan (1 / v) = π / 2 - Real.arctan v := by
    rw [one_div, Real.arctan_inv_of_pos hv]
  rw [hF0] at hFTC
  have : (∫ t in Ioi (0:ℝ), sinePlateau t * Real.exp (-(v * t)))
      = Real.arctan (1 / v) / v - (π / (2 * v) - (π / 2) / (1 + v)) := by linarith
  rw [this, harc, arctanReg]
  field_simp
  ring

/-! ## 4. Fubini: the total mass of the plateau profile vanishes -/

/-- The two-variable integrand `P(t) e^{-tv}` is integrable on `(0,∞) × (0,∞)`. -/
theorem integrable_sinePlateau_prod :
    Integrable (Function.uncurry (fun t v : ℝ => sinePlateau t * Real.exp (-(t * v))))
      ((volume.restrict (Ioi (0:ℝ))).prod (volume.restrict (Ioi (0:ℝ)))) := by
  have hcont : Continuous (Function.uncurry (fun t v : ℝ => sinePlateau t * Real.exp (-(t * v)))) := by
    have h1 : Continuous fun z : ℝ × ℝ => sinePlateau z.1 := continuous_sinePlateau.comp continuous_fst
    have h2 : Continuous fun z : ℝ × ℝ => Real.exp (-(z.1 * z.2)) :=
      Real.continuous_exp.comp ((continuous_fst.mul continuous_snd).neg)
    exact h1.mul h2
  refine (MeasureTheory.integrable_prod_iff hcont.aestronglyMeasurable).2 ⟨?_, ?_⟩
  · filter_upwards [self_mem_ae_restrict measurableSet_Ioi] with t ht
    have ht0 : (0:ℝ) < t := ht
    have hb : IntegrableOn (fun v : ℝ => Real.exp (-(t * v))) (Ioi 0) := by
      simpa [neg_mul] using exp_neg_integrableOn_Ioi (0:ℝ) ht0
    simpa [Function.uncurry] using hb.const_mul (sinePlateau t)
  · have hcongr : ∀ t ∈ Ioi (0:ℝ),
        (∫ v in Ioi (0:ℝ), ‖Function.uncurry
            (fun t v : ℝ => sinePlateau t * Real.exp (-(t * v))) (t, v)‖)
          = |sinePlateau t / t| := by
      intro t ht
      have ht0 : (0:ℝ) < t := ht
      have h1 : ∀ v : ℝ, ‖sinePlateau t * Real.exp (-(t * v))‖
          = |sinePlateau t| * Real.exp (-(t * v)) := by
        intro v
        rw [norm_mul, Real.norm_eq_abs, Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
      simp only [Function.uncurry, h1]
      rw [MeasureTheory.integral_const_mul, integral_exp_neg_mul_Ioi_zero ht0,
        abs_div, abs_of_pos ht0]
      ring
    refine MeasureTheory.IntegrableOn.congr_fun ?_ (fun t ht => (hcongr t ht).symm)
      measurableSet_Ioi
    exact integrableOn_sinePlateau_div.abs

/-- **The plateau profile has zero total mass**: `∫_0^∞ P(t) dt/t = 0`. -/
theorem integral_sinePlateau_div : ∫ t in Ioi (0:ℝ), sinePlateau t / t = 0 := by
  have hswap := MeasureTheory.integral_integral_swap
    (f := fun t v : ℝ => sinePlateau t * Real.exp (-(t * v))) integrable_sinePlateau_prod
  have hleft : (∫ t in Ioi (0:ℝ), ∫ v in Ioi (0:ℝ), sinePlateau t * Real.exp (-(t * v)))
      = ∫ t in Ioi (0:ℝ), sinePlateau t / t := by
    refine setIntegral_congr_fun measurableSet_Ioi ?_
    intro t ht
    have ht0 : (0:ℝ) < t := ht
    show (∫ v in Ioi (0:ℝ), sinePlateau t * Real.exp (-(t * v))) = sinePlateau t / t
    rw [MeasureTheory.integral_const_mul, integral_exp_neg_mul_Ioi_zero ht0]
    ring
  have hright : (∫ v in Ioi (0:ℝ), ∫ t in Ioi (0:ℝ), sinePlateau t * Real.exp (-(t * v)))
      = ∫ v in Ioi (0:ℝ), arctanReg v := by
    refine setIntegral_congr_fun measurableSet_Ioi ?_
    intro v hv
    have hv0 : (0:ℝ) < v := hv
    show (∫ t in Ioi (0:ℝ), sinePlateau t * Real.exp (-(t * v))) = arctanReg v
    rw [← integral_sinePlateau_exp hv0]
    refine setIntegral_congr_fun measurableSet_Ioi ?_
    intro t _
    show sinePlateau t * Real.exp (-(t * v)) = sinePlateau t * Real.exp (-(v * t))
    rw [mul_comm t v]
  rw [hleft, hright, integral_arctanReg] at hswap
  exact hswap

end ConnesConsani.WeilPositivity
