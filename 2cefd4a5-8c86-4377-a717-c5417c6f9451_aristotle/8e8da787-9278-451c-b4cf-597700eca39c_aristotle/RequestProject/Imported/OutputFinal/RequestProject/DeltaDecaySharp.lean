/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

A sharper decay bound for the Fourier transform `δ̂` of the trace remainder of

  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771.

`RequestProject/DeltaDecay.lean` proves `|δ̂(t)| ≤ 32 π e^{π/(2|t|)}/|t|`, hence
`|δ̂(t)| ≤ 104/|t|` for `|t| ≥ 60`, by the half-period shift device.  Here the same
input — the pointwise derivative bound `|(d/dv) δ(e^v)| ≤ 16 e^{-v/2}` — is used through a
genuine integration by parts, which is more efficient by a factor `π/2` and removes the
extra factor `e^{π/(2t)}`:

  `δ̂(t) = -(2/t) ∫₀^∞ (d/dv) δ(e^v) · sin(tv) dv`   (`integral_Ioi_deltaLogAux_cos_eq`),

whence `|δ̂(t)| ≤ (2/|t|) ∫₀^∞ |(d/dv) δ(e^v)| dv ≤ 64/|t|`.

Together with the effective lower bound `2θ'(t) ≥ log(t/2π) - 4/t² - π/t` of
`RequestProject/ThetaGrowth.lean` this lowers the threshold beyond which the Fourier-side
inequality `2θ'(t) + δ̂(t) ≥ 0` of Corollary 2.3 (ii) is proved from `|t| ≥ 60` to
`|t| ≥ 38`.
-/
import RequestProject.Imported.OutputFinal.RequestProject.ThetaGrowth

noncomputable section

open MeasureTheory Set Real Filter Topology

namespace ConnesConsani.WeilPositivity

/-! ## Elementary facts about `δ(e^v)` and its derivative on the right branch -/

/-- The derivative of `v ↦ δ(e^v)` is continuous. -/
theorem continuous_dl1 : Continuous dl1 := by
  have h : Differentiable ℝ dl1 := fun t => (hasDerivAt_dl1 t).differentiableAt
  exact h.continuous

/-- `v ↦ δ(e^v)` is continuous. -/
theorem continuous_deltaLogAux : Continuous deltaLogAux := by
  have h : Differentiable ℝ deltaLogAux := fun t => (hasDerivAt_deltaLogAux t).differentiableAt
  exact h.continuous

/-- `δ(e^v) ≤ 17 e^{-v/2}` for `v ≥ 0`. -/
theorem deltaLogAux_le {v : ℝ} (hv : 0 ≤ v) : deltaLogAux v ≤ 17 * Real.exp (-(v / 2)) := by
  have h := delta_expHomeo_le v
  rw [delta_expHomeo_eq_deltaLogAux, abs_of_nonneg hv] at h
  have hSi : Si π ≤ π := Si_le_self Real.pi_pos.le
  have hpi : π ≤ 3.15 := by linarith [Real.pi_lt_d2]
  nlinarith [h, Real.exp_pos (-(v / 2))]

/-- `δ(e^v) > 0` for `v ≥ 0`. -/
theorem deltaLogAux_pos {v : ℝ} (hv : 0 ≤ v) : 0 < deltaLogAux v := by
  have h := delta_pos (Rplus.expHomeo v)
  rwa [delta_expHomeo_eq_deltaLogAux, abs_of_nonneg hv] at h

theorem integrableOn_exp_neg_half : IntegrableOn (fun v => Real.exp (-(v / 2))) (Ioi (0:ℝ)) := by
  have h : IntegrableOn (fun v : ℝ => Real.exp (-(|v| / 2))) (Ioi (0:ℝ)) :=
    integrable_exp_neg_half_abs.integrableOn
  exact h.congr_fun (fun v hv => by rw [abs_of_pos hv]) measurableSet_Ioi

/-- `∫₀^∞ e^{-v/2} dv = 2`. -/
theorem integral_Ioi_exp_neg_half : ∫ v in Ioi (0:ℝ), Real.exp (-(v / 2)) = 2 := by
  have hderiv : ∀ v : ℝ, HasDerivAt (fun v : ℝ => -2 * Real.exp (-(v / 2)))
      (Real.exp (-(v / 2))) v := by
    intro v
    have h0 : HasDerivAt (fun v : ℝ => -(v / 2)) (-(1 / 2)) v := by
      simpa using ((hasDerivAt_id v).div_const 2).neg
    have h := (h0.exp).const_mul (-2 : ℝ)
    convert h using 1
    ring
  have htend : Tendsto (fun v : ℝ => -2 * Real.exp (-(v / 2))) atTop (𝓝 0) := by
    have hexp : Tendsto (fun v : ℝ => Real.exp (-(v / 2))) atTop (𝓝 0) :=
      Real.tendsto_exp_atBot.comp
        (Filter.tendsto_neg_atTop_atBot.comp (Filter.Tendsto.atTop_div_const (by norm_num)
          tendsto_id))
    simpa using hexp.const_mul (-2 : ℝ)
  have h := integral_Ioi_of_hasDerivAt_of_nonneg (a := (0:ℝ))
    (by fun_prop : Continuous fun v : ℝ => -2 * Real.exp (-(v / 2))).continuousWithinAt
    (fun x (_ : x ∈ Ioi (0:ℝ)) => hderiv x)
    (fun x (_ : x ∈ Ioi (0:ℝ)) => (Real.exp_pos _).le) htend
  rw [h]
  norm_num

theorem integrableOn_dl1_Ioi : IntegrableOn dl1 (Ioi (0:ℝ)) volume := by
  refine Integrable.mono' (integrableOn_exp_neg_half.const_mul 16)
    continuous_dl1.aestronglyMeasurable.restrict ?_
  filter_upwards [ae_restrict_mem measurableSet_Ioi] with v hv
  rw [Real.norm_eq_abs]
  exact abs_dl1_le (le_of_lt hv)

theorem integrableOn_dl1_mul {w : ℝ → ℝ} (hw : Continuous w) (hb : ∀ v, |w v| ≤ 1) :
    IntegrableOn (fun v => dl1 v * w v) (Ioi (0:ℝ)) volume := by
  refine Integrable.mono' integrableOn_dl1_Ioi.norm
    (continuous_dl1.mul hw).aestronglyMeasurable.restrict ?_
  filter_upwards with v
  simp only [Real.norm_eq_abs, abs_mul]
  nlinarith [abs_nonneg (dl1 v), abs_nonneg (w v), hb v]

theorem integrableOn_deltaLogAux_mul {w : ℝ → ℝ} (hw : Continuous w) (hb : ∀ v, |w v| ≤ 1) :
    IntegrableOn (fun v => deltaLogAux v * w v) (Ioi (0:ℝ)) volume := by
  refine Integrable.mono' (integrableOn_exp_neg_half.const_mul 17)
    (continuous_deltaLogAux.mul hw).aestronglyMeasurable.restrict ?_
  filter_upwards [ae_restrict_mem measurableSet_Ioi] with v hv
  have hv0 : (0:ℝ) ≤ v := le_of_lt hv
  rw [Real.norm_eq_abs, abs_mul, abs_of_pos (deltaLogAux_pos hv0)]
  nlinarith [deltaLogAux_le hv0, abs_nonneg (w v), hb v, (deltaLogAux_pos hv0).le]

/-- **The total variation bound**: `∫₀^∞ |(d/dv) δ(e^v)| dv ≤ 32`. -/
theorem integral_Ioi_abs_dl1_le : (∫ v in Ioi (0:ℝ), |dl1 v|) ≤ 32 := by
  have h1 : (∫ v in Ioi (0:ℝ), |dl1 v|) ≤ ∫ v in Ioi (0:ℝ), 16 * Real.exp (-(v / 2)) :=
    setIntegral_mono_on integrableOn_dl1_Ioi.abs (integrableOn_exp_neg_half.const_mul 16)
      measurableSet_Ioi (fun v hv => abs_dl1_le (le_of_lt hv))
  rw [integral_const_mul, integral_Ioi_exp_neg_half] at h1
  linarith

/-! ## The integration by parts -/

/-- `δ̂(t) = 2 ∫₀^∞ δ(e^v) cos(tv) dv`, by evenness. -/
theorem deltaFourier_eq_two_mul_integral_Ioi (t : ℝ) :
    deltaFourier t = 2 * ∫ v in Ioi (0:ℝ), deltaLogAux v * Real.cos (t * v) := by
  have heven : ∀ u : ℝ, delta (Rplus.expHomeo u) * Real.cos (t * u)
      = (fun x : ℝ => deltaLogAux x * Real.cos (t * x)) |u| := by
    intro u
    rw [delta_expHomeo_eq_deltaLogAux]
    rcases abs_cases u with ⟨h, _⟩ | ⟨h, _⟩
    · simp only [h]
    · simp only [h, show t * -u = -(t * u) by ring, Real.cos_neg]
  rw [deltaFourier, integral_congr_ae (Filter.Eventually.of_forall heven)]
  exact integral_comp_abs (f := fun x : ℝ => deltaLogAux x * Real.cos (t * x))

/-- **Integration by parts**: `∫₀^∞ δ(e^v) cos(tv) dv = -(1/t) ∫₀^∞ (d/dv)δ(e^v) sin(tv) dv`. -/
theorem integral_Ioi_deltaLogAux_cos_eq {t : ℝ} (ht : 0 < t) :
    (∫ v in Ioi (0:ℝ), deltaLogAux v * Real.cos (t * v))
      = -(1 / t) * ∫ v in Ioi (0:ℝ), dl1 v * Real.sin (t * v) := by
  have htne : t ≠ 0 := ne_of_gt ht
  set H : ℝ → ℝ := fun v => deltaLogAux v * Real.sin (t * v) / t with hH
  have hderiv : ∀ v : ℝ, HasDerivAt H
      (dl1 v * Real.sin (t * v) / t + deltaLogAux v * Real.cos (t * v)) v := by
    intro v
    have hs : HasDerivAt (fun v : ℝ => Real.sin (t * v)) (t * Real.cos (t * v)) v := by
      have h0 : HasDerivAt (fun v : ℝ => t * v) t v := by
        simpa using (hasDerivAt_id v).const_mul t
      simpa [mul_comm] using h0.sin
    have h := ((hasDerivAt_deltaLogAux v).mul hs).div_const t
    convert h using 1
    field_simp
  have hint1 : IntegrableOn (fun v => dl1 v * Real.sin (t * v) / t) (Ioi (0:ℝ)) volume :=
    (integrableOn_dl1_mul (by fun_prop) (fun v => Real.abs_sin_le_one _)).div_const t
  have hint2 : IntegrableOn (fun v => deltaLogAux v * Real.cos (t * v)) (Ioi (0:ℝ)) volume :=
    integrableOn_deltaLogAux_mul (by fun_prop) (fun v => Real.abs_cos_le_one _)
  have hcontH : Continuous H :=
    (continuous_deltaLogAux.mul (by fun_prop)).div_const t
  have htend : Tendsto H atTop (𝓝 0) := by
    refine squeeze_zero_norm' (a := fun v : ℝ => 17 * Real.exp (-(v / 2)) / t) ?_ ?_
    · filter_upwards [eventually_ge_atTop (0:ℝ)] with v hv
      have h1 : |deltaLogAux v * Real.sin (t * v)| ≤ 17 * Real.exp (-(v / 2)) := by
        rw [abs_mul, abs_of_pos (deltaLogAux_pos hv)]
        nlinarith [deltaLogAux_le hv, Real.abs_sin_le_one (t * v),
          abs_nonneg (Real.sin (t * v)), (deltaLogAux_pos hv).le]
      have : ‖H v‖ = |deltaLogAux v * Real.sin (t * v)| / t := by
        rw [hH]
        simp only [Real.norm_eq_abs, abs_div, abs_of_pos ht]
      rw [this]
      gcongr
    · have hexp : Tendsto (fun v : ℝ => Real.exp (-(v / 2))) atTop (𝓝 0) :=
        Real.tendsto_exp_atBot.comp
          (Filter.tendsto_neg_atTop_atBot.comp (Filter.Tendsto.atTop_div_const (by norm_num)
            tendsto_id))
      have h := (hexp.const_mul (17:ℝ)).div_const t
      simpa using h
  have hmain := integral_Ioi_of_hasDerivAt_of_tendsto (a := (0:ℝ))
    hcontH.continuousWithinAt (fun v (_ : v ∈ Ioi (0:ℝ)) => hderiv v) (hint1.add hint2) htend
  have hH0 : H 0 = 0 := by simp [hH]
  rw [integral_add hint1 hint2, hH0] at hmain
  have hdiv : (∫ v in Ioi (0:ℝ), dl1 v * Real.sin (t * v) / t)
      = (∫ v in Ioi (0:ℝ), dl1 v * Real.sin (t * v)) / t := integral_div _ _
  rw [hdiv] at hmain
  field_simp at hmain ⊢
  linarith

/-- **The decay of `δ̂` from any total variation bound**: if `∫₀^∞ |(d/dv)δ(e^v)| dv ≤ C`
then `|δ̂(t)| ≤ 2C/|t|` for all `t ≠ 0`. -/
theorem abs_deltaFourier_le_of_integral_bound {C : ℝ}
    (hC : (∫ v in Ioi (0:ℝ), |dl1 v|) ≤ C) {t : ℝ} (ht : t ≠ 0) :
    |deltaFourier t| ≤ 2 * C / |t| := by
  have key : ∀ s : ℝ, 0 < s → |deltaFourier s| ≤ 2 * C / s := by
    intro s hs
    have hbound : |∫ v in Ioi (0:ℝ), dl1 v * Real.sin (s * v)| ≤ C := by
      have h1 : |∫ v in Ioi (0:ℝ), dl1 v * Real.sin (s * v)|
          ≤ ∫ v in Ioi (0:ℝ), |dl1 v * Real.sin (s * v)| := by
        simpa [Real.norm_eq_abs] using
          norm_integral_le_integral_norm (μ := volume.restrict (Ioi (0:ℝ)))
            (fun v => dl1 v * Real.sin (s * v))
      have h2 : (∫ v in Ioi (0:ℝ), |dl1 v * Real.sin (s * v)|)
          ≤ ∫ v in Ioi (0:ℝ), |dl1 v| := by
        refine setIntegral_mono_on
          ((integrableOn_dl1_mul (by fun_prop) (fun v => Real.abs_sin_le_one _)).abs)
          integrableOn_dl1_Ioi.abs measurableSet_Ioi fun v _ => ?_
        rw [abs_mul]
        nlinarith [abs_nonneg (dl1 v), Real.abs_sin_le_one (s * v),
          abs_nonneg (Real.sin (s * v))]
      linarith
    rw [deltaFourier_eq_two_mul_integral_Ioi, integral_Ioi_deltaLogAux_cos_eq hs]
    rw [abs_mul, abs_mul, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 2), abs_neg,
      abs_of_pos (by positivity : (0:ℝ) < 1 / s)]
    have h1 : (0:ℝ) < 1 / s := by positivity
    calc 2 * (1 / s * |∫ v in Ioi (0:ℝ), dl1 v * Real.sin (s * v)|)
        ≤ 2 * (1 / s * C) := by
          have := mul_le_mul_of_nonneg_left hbound h1.le
          linarith
      _ = 2 * C / s := by field_simp
  rcases lt_or_gt_of_ne ht with hneg | hpos
  · have h := key (-t) (by linarith)
    rw [deltaFourier_even] at h
    rwa [abs_of_neg hneg]
  · rw [abs_of_pos hpos]
    exact key t hpos

/-- **The sharpened decay of `δ̂`**: `|δ̂(t)| ≤ 64/|t|`. -/
theorem abs_deltaFourier_le_sixtyfour_div {t : ℝ} (ht : t ≠ 0) :
    |deltaFourier t| ≤ 64 / |t| := by
  have h := abs_deltaFourier_le_of_integral_bound integral_Ioi_abs_dl1_le ht
  norm_num at h
  exact h

/-! ## The improved threshold -/

/-- `log(T/2π) ≥ 1.79` for `T ≥ 38`. -/
theorem log_div_two_pi_ge_of_thirtyeight_le {T : ℝ} (hT : 38 ≤ T) :
    1.79 ≤ Real.log (T / (2 * π)) := by
  have hpi : π ≤ 3.1416 := by linarith [Real.pi_lt_d6]
  have hpi0 : (0:ℝ) < π := Real.pi_pos
  have hexp2 : Real.exp 2 ≤ 7.39 := by
    have h1 : Real.exp 2 = Real.exp 1 * Real.exp 1 := by
      rw [← Real.exp_add]
      norm_num
    have h2 : Real.exp 1 < 2.7182818286 := Real.exp_one_lt_d9
    nlinarith [Real.exp_pos 1]
  have hexp021 : (1.232 : ℝ) ≤ Real.exp 0.21 := by
    have h := Real.sum_le_exp_of_nonneg (x := (0.21 : ℝ)) (by norm_num) 3
    have hs : (1.232 : ℝ) ≤ ∑ i ∈ Finset.range 3, (0.21 : ℝ) ^ i / (i.factorial : ℝ) := by
      norm_num [Finset.sum_range_succ, Nat.factorial]
    linarith
  have hexp179 : Real.exp 1.79 ≤ 6 := by
    have hmul : Real.exp 1.79 * Real.exp 0.21 = Real.exp 2 := by
      rw [← Real.exp_add]
      norm_num
    nlinarith [Real.exp_pos 1.79, Real.exp_pos 0.21]
  rw [Real.le_log_iff_exp_le (by positivity), le_div_iff₀ (by positivity)]
  nlinarith

/-- **The Fourier-side inequality of Corollary 2.3 (ii) outside `|t| ≤ 38`.**
`2θ'(t) + δ̂(t) ≥ 0` holds unconditionally for every real `t` with `|t| ≥ 38`.  This
sharpens `fourierSide_nonneg_of_sixty_le_abs` of `RequestProject/ThetaGrowth.lean`. -/
theorem fourierSide_nonneg_of_thirtyeight_le_abs {t : ℝ} (ht : 38 ≤ |t|) :
    0 ≤ fourierSide t := by
  have hpi : π ≤ 3.15 := by linarith [Real.pi_lt_d2]
  have hT0 : (0:ℝ) < |t| := by linarith
  have hge := two_thetaDeriv_ge hT0
  have hlog : 1.79 ≤ Real.log (|t| / (2 * π)) := log_div_two_pi_ge_of_thirtyeight_le ht
  have h4 : 4 / |t| ^ 2 ≤ 4 / 1444 := by
    apply div_le_div_of_nonneg_left (by norm_num) (by norm_num)
    nlinarith
  have hpiT : π / |t| ≤ 3.15 / 38 := by
    rw [div_le_div_iff₀ hT0 (by norm_num)]
    nlinarith
  have hth : 2 * thetaDeriv t = 2 * thetaDeriv |t| := by rw [thetaDeriv_abs]
  have hne : t ≠ 0 := by
    intro h
    rw [h] at ht
    norm_num at ht
  have hdec : |deltaFourier t| ≤ 64 / |t| := abs_deltaFourier_le_sixtyfour_div hne
  have hdec' : 64 / |t| ≤ 64 / 38 := by
    apply div_le_div_of_nonneg_left (by norm_num) (by norm_num) ht
  have hlow : -deltaFourier t ≤ 64 / 38 := by
    linarith [neg_abs_le (deltaFourier t), le_abs_self (deltaFourier t)]
  rw [fourierSide, hth]
  linarith

end ConnesConsani.WeilPositivity
