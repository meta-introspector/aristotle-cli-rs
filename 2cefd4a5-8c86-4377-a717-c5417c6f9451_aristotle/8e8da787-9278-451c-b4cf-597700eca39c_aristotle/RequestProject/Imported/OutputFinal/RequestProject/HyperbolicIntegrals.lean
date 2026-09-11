/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
Authors: Formalization of
  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771

**The elementary hyperbolic integrals of the archimedean kernel.**

The evaluation of the universal constant of the renormalized trace formula needs the two
elementary integrals of `1/sinh(t/2)`, regularized at the origin by the pole `2/t`:

  `∫_0^1 (1/sinh(t/2) - 2/t) dt + ∫_1^∞ dt/sinh(t/2) = 4 log 2`.

Both are computed from the primitive `2 log tanh(t/4)`, written here as
`cschHalfPrim t = 2 log sinh(t/4) - 2 log cosh(t/4)`.
-/
import RequestProject.Imported.OutputFinal.RequestProject.CutoffLogProfile

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Filter Topology Set Real

namespace ConnesConsani.WeilPositivity

/-! ## 1. The primitive `2 log tanh(t/4)` -/

/-- The primitive `2 log tanh(t/4)` of `1/sinh(t/2)`, written through `sinh` and `cosh`. -/
def cschHalfPrim (t : ℝ) : ℝ :=
  2 * Real.log (Real.sinh (t / 4)) - 2 * Real.log (Real.cosh (t / 4))

theorem hasDerivAt_cschHalfPrim {t : ℝ} (ht : 0 < t) :
    HasDerivAt cschHalfPrim (1 / Real.sinh (t / 2)) t := by
  have hq : HasDerivAt (fun x : ℝ => x / 4) (1 / 4 : ℝ) t := (hasDerivAt_id t).div_const 4
  have hs : HasDerivAt (fun x : ℝ => Real.sinh (x / 4)) (Real.cosh (t / 4) * (1 / 4)) t :=
    hq.sinh
  have hc : HasDerivAt (fun x : ℝ => Real.cosh (x / 4)) (Real.sinh (t / 4) * (1 / 4)) t :=
    hq.cosh
  have hsp : 0 < Real.sinh (t / 4) := Real.sinh_pos_iff.2 (by linarith)
  have hcp : 0 < Real.cosh (t / 4) := Real.cosh_pos _
  have h1 := (hs.log hsp.ne').const_mul (2 : ℝ)
  have h2 := (hc.log hcp.ne').const_mul (2 : ℝ)
  have h := h1.sub h2
  convert h using 1
  have hpyth : Real.cosh (t / 4) ^ 2 - Real.sinh (t / 4) ^ 2 = 1 :=
    Real.cosh_sq_sub_sinh_sq _
  have h2m : Real.sinh (t / 2) = 2 * Real.sinh (t / 4) * Real.cosh (t / 4) := by
    rw [show t / 2 = 2 * (t / 4) by ring, Real.sinh_two_mul]
  rw [h2m]
  field_simp
  nlinarith [hpyth, hsp, hcp]

theorem cschHalfPrim_one_le_zero : cschHalfPrim 1 ≤ 0 := by
  have hsp : 0 < Real.sinh ((1:ℝ) / 4) := Real.sinh_pos_iff.2 (by norm_num)
  have hlt : Real.sinh ((1:ℝ) / 4) < Real.cosh ((1:ℝ) / 4) := by
    nlinarith [Real.cosh_sq_sub_sinh_sq ((1:ℝ)/4), Real.cosh_pos ((1:ℝ)/4), hsp]
  have := Real.log_lt_log hsp hlt
  rw [cschHalfPrim]
  linarith

/-- `tanh(t/4) → 1` as `t → ∞`, in the `sinh/cosh` form. -/
theorem tendsto_sinh_div_cosh_quarter :
    Tendsto (fun t : ℝ => Real.sinh (t / 4) / Real.cosh (t / 4)) atTop (𝓝 1) := by
  have hexp : Tendsto (fun t : ℝ => Real.exp (-(t / 2))) atTop (𝓝 0) := by
    have hb : Tendsto (fun t : ℝ => -(t / 2)) atTop atBot := by
      have : Tendsto (fun t : ℝ => t / 2) atTop atTop :=
        Filter.tendsto_id.atTop_div_const (by norm_num)
      exact tendsto_neg_atTop_atBot.comp this
    exact Real.tendsto_exp_atBot.comp hb
  have hlim : Tendsto (fun t : ℝ => (1 - Real.exp (-(t / 2))) / (1 + Real.exp (-(t / 2))))
      atTop (𝓝 ((1 - 0) / (1 + 0))) := by
    refine Tendsto.div (tendsto_const_nhds.sub hexp) (tendsto_const_nhds.add hexp) (by norm_num)
  rw [show ((1:ℝ) - 0) / (1 + 0) = 1 by norm_num] at hlim
  refine hlim.congr fun t => ?_
  have he : (0:ℝ) < Real.exp (t / 4) := Real.exp_pos _
  have hsum : Real.exp (-(t / 2)) = Real.exp (-(t / 4)) * Real.exp (-(t / 4)) := by
    rw [← Real.exp_add]; ring_nf
  have hinv : Real.exp (-(t / 4)) = (Real.exp (t / 4))⁻¹ := by rw [← Real.exp_neg]
  rw [Real.sinh_eq, Real.cosh_eq, hsum, hinv]
  have hc : (0:ℝ) < (Real.exp (t/4) + (Real.exp (t/4))⁻¹) / 2 := by positivity
  field_simp

theorem tendsto_cschHalfPrim_atTop : Tendsto cschHalfPrim atTop (𝓝 0) := by
  have hlog : Tendsto (fun t : ℝ => Real.log (Real.sinh (t / 4) / Real.cosh (t / 4)))
      atTop (𝓝 (Real.log 1)) :=
    (Real.continuousAt_log one_ne_zero).tendsto.comp tendsto_sinh_div_cosh_quarter
  rw [Real.log_one] at hlog
  have h2 := hlog.const_mul (2 : ℝ)
  rw [mul_zero] at h2
  refine h2.congr' ?_
  filter_upwards [eventually_gt_atTop (0:ℝ)] with t ht
  have hsp : 0 < Real.sinh (t / 4) := Real.sinh_pos_iff.2 (by linarith)
  have hcp : 0 < Real.cosh (t / 4) := Real.cosh_pos _
  rw [Real.log_div hsp.ne' hcp.ne', cschHalfPrim]
  ring

/-! ## 2. The tail integral `∫_1^∞ dt/sinh(t/2)` -/

theorem integral_Ioi_one_cschHalf :
    (∫ t in Ioi (1:ℝ), 1 / Real.sinh (t / 2)) = -cschHalfPrim 1 := by
  have h := integral_Ioi_of_hasDerivAt_of_nonneg (a := (1:ℝ)) (g := cschHalfPrim)
    (g' := fun t => 1 / Real.sinh (t / 2))
    (hasDerivAt_cschHalfPrim (by norm_num)).continuousAt.continuousWithinAt
    (fun x hx => hasDerivAt_cschHalfPrim (lt_trans zero_lt_one hx))
    (fun x hx => by
      have hx1 : (1:ℝ) < x := hx
      have : 0 < Real.sinh (x / 2) := Real.sinh_pos_iff.2 (by linarith)
      positivity)
    tendsto_cschHalfPrim_atTop
  rw [h]
  ring

theorem integrableOn_Ioi_one_cschHalf :
    IntegrableOn (fun t : ℝ => 1 / Real.sinh (t / 2)) (Ioi (1:ℝ)) volume :=
  integrableOn_Ioi_deriv_of_nonneg (a := (1:ℝ))
    (hasDerivAt_cschHalfPrim (by norm_num)).continuousAt.continuousWithinAt
    (fun x hx => hasDerivAt_cschHalfPrim (lt_trans zero_lt_one hx))
    (fun x hx => by
      have hx1 : (1:ℝ) < x := hx
      have : 0 < Real.sinh (x / 2) := Real.sinh_pos_iff.2 (by linarith)
      positivity)
    tendsto_cschHalfPrim_atTop

/-! ## 3. The regularized integral `∫_0^1 (1/sinh(t/2) - 2/t) dt` -/

/-- The regularized primitive `2 log (tanh(t/4)/t)`. -/
def cschRegPrim (t : ℝ) : ℝ := cschHalfPrim t - 2 * Real.log t

theorem hasDerivAt_cschRegPrim {t : ℝ} (ht : 0 < t) :
    HasDerivAt cschRegPrim (1 / Real.sinh (t / 2) - 2 / t) t := by
  have h1 := hasDerivAt_cschHalfPrim ht
  have h2 := ((Real.hasDerivAt_log ht.ne').const_mul (2 : ℝ))
  have h := h1.sub h2
  convert h using 1

/-- `sinh(t/4)/t → 1/4` as `t → 0⁺`. -/
theorem tendsto_sinh_quarter_div :
    Tendsto (fun t : ℝ => Real.sinh (t / 4) / t) (𝓝[>] (0:ℝ)) (𝓝 (1 / 4)) := by
  have hslope : Tendsto (fun x : ℝ => Real.sinh x / x) (𝓝[≠] (0:ℝ)) (𝓝 1) := by
    have h := Real.hasDerivAt_sinh 0
    rw [hasDerivAt_iff_tendsto_slope] at h
    simp only [Real.cosh_zero] at h
    refine h.congr fun x => ?_
    rw [slope_def_field]
    simp [div_eq_inv_mul]
  have hmap : Tendsto (fun t : ℝ => t / 4) (𝓝[>] (0:ℝ)) (𝓝[≠] (0:ℝ)) := by
    refine tendsto_nhdsWithin_of_tendsto_nhds_of_eventually_within _ ?_ ?_
    · have : Tendsto (fun t : ℝ => t / 4) (𝓝 (0:ℝ)) (𝓝 (0/4 : ℝ)) :=
        (continuous_id.div_const 4).tendsto 0
      simpa using this.mono_left nhdsWithin_le_nhds
    · filter_upwards [self_mem_nhdsWithin] with t ht
      have : (0:ℝ) < t := ht
      exact ne_of_gt (by linarith)
  have hcomp := hslope.comp hmap
  have h4 := hcomp.const_mul (1 / 4 : ℝ)
  rw [mul_one] at h4
  refine h4.congr' ?_
  filter_upwards [self_mem_nhdsWithin] with t ht
  have ht0 : (0:ℝ) < t := ht
  simp only [Function.comp_apply]
  field_simp

theorem tendsto_cschRegPrim_zero :
    Tendsto cschRegPrim (𝓝[>] (0:ℝ)) (𝓝 (-(2 * Real.log 4))) := by
  have hlog : Tendsto (fun t : ℝ => Real.log (Real.sinh (t / 4) / t)) (𝓝[>] (0:ℝ))
      (𝓝 (Real.log (1 / 4))) :=
    (Real.continuousAt_log (by norm_num)).tendsto.comp tendsto_sinh_quarter_div
  have hcosh : Tendsto (fun t : ℝ => Real.log (Real.cosh (t / 4))) (𝓝[>] (0:ℝ)) (𝓝 0) := by
    have hct : ContinuousAt (fun t : ℝ => Real.log (Real.cosh (t / 4))) 0 := by
      refine ContinuousAt.log ?_ ?_
      · exact (Real.continuous_cosh.comp (continuous_id.div_const 4)).continuousAt
      · exact (Real.cosh_pos _).ne'
    have h := hct.tendsto
    simp only [zero_div, Real.cosh_zero, Real.log_one] at h
    exact h.mono_left nhdsWithin_le_nhds
  have h := (hlog.const_mul (2:ℝ)).sub (hcosh.const_mul (2:ℝ))
  have hval : (2:ℝ) * Real.log (1 / 4) - 2 * 0 = -(2 * Real.log 4) := by
    rw [show (1:ℝ)/4 = (4:ℝ)⁻¹ by norm_num, Real.log_inv]
    ring
  rw [hval] at h
  refine h.congr' ?_
  filter_upwards [self_mem_nhdsWithin] with t ht
  have ht0 : (0:ℝ) < t := ht
  have hsp : 0 < Real.sinh (t / 4) := Real.sinh_pos_iff.2 (by linarith)
  rw [Real.log_div hsp.ne' ht0.ne', cschRegPrim, cschHalfPrim]
  ring

/-- The regularized integrand `1/sinh(t/2) - 2/t` is `π · wKer`, hence bounded on `[0,1]`. -/
theorem pi_mul_wKer_eq {t : ℝ} : π * wKer t = 1 / Real.sinh (t / 2) - 2 / t := by
  have hpi : (π:ℝ) ≠ 0 := Real.pi_ne_zero
  rw [wKer]
  rcases eq_or_ne (Real.sinh (t / 2)) 0 with hs | hs
  · rcases eq_or_ne t 0 with rfl | ht
    · simp
    · simp
      field_simp
  · rcases eq_or_ne t 0 with rfl | ht
    · simp at hs
    · field_simp

theorem intervalIntegrable_cschReg :
    IntervalIntegrable (fun t : ℝ => 1 / Real.sinh (t / 2) - 2 / t) volume 0 1 := by
  have hmeas : Measurable fun t : ℝ => 1 / Real.sinh (t / 2) - 2 / t := by
    have h := (measurable_const (a := π)).mul measurable_wKer
    simpa only [pi_mul_wKer_eq] using h
  have hbd : ∀ t ∈ Ioc (0:ℝ) 1, ‖1 / Real.sinh (t / 2) - 2 / t‖ ≤ 1 := by
    intro t ht
    have habs : |t| ≤ 1 := by
      rw [abs_of_pos ht.1]; exact ht.2
    have h := abs_wKer_le habs
    rw [← pi_mul_wKer_eq, Real.norm_eq_abs, abs_mul, abs_of_pos Real.pi_pos]
    calc π * |wKer t| ≤ π * (1 / π) :=
          mul_le_mul_of_nonneg_left h Real.pi_pos.le
      _ = 1 := by field_simp
  rw [intervalIntegrable_iff, uIoc_of_le zero_le_one]
  refine Measure.integrableOn_of_bounded (M := (1:ℝ)) measure_Ioc_lt_top.ne
    hmeas.aestronglyMeasurable ?_
  filter_upwards [self_mem_ae_restrict measurableSet_Ioc] with t ht using hbd t ht

theorem integral_zero_one_cschReg :
    (∫ t in (0:ℝ)..1, (1 / Real.sinh (t / 2) - 2 / t)) = cschHalfPrim 1 + 2 * Real.log 4 := by
  have hint := intervalIntegrable_cschReg
  have hlim := tendsto_integral_left_endpoint hint
  have heq : ∀ ε ∈ Ioo (0:ℝ) 1,
      (∫ t in ε..(1:ℝ), (1 / Real.sinh (t / 2) - 2 / t)) = cschRegPrim 1 - cschRegPrim ε := by
    intro ε hε
    have hsub : IntervalIntegrable (fun t : ℝ => 1 / Real.sinh (t / 2) - 2 / t) volume ε 1 :=
      hint.mono_set (by
        rw [uIcc_of_le hε.2.le, uIcc_of_le (zero_le_one : (0:ℝ) ≤ 1)]
        exact Icc_subset_Icc hε.1.le le_rfl)
    exact intervalIntegral.integral_eq_sub_of_hasDerivAt
      (fun x hx => by
        rw [uIcc_of_le hε.2.le] at hx
        exact hasDerivAt_cschRegPrim (lt_of_lt_of_le hε.1 hx.1)) hsub
  have hlim2 : Tendsto (fun ε : ℝ => cschRegPrim 1 - cschRegPrim ε) (𝓝[>] (0:ℝ))
      (𝓝 (cschRegPrim 1 - -(2 * Real.log 4))) :=
    tendsto_const_nhds.sub tendsto_cschRegPrim_zero
  have hcongr : Tendsto (fun ε : ℝ => ∫ t in ε..(1:ℝ), (1 / Real.sinh (t / 2) - 2 / t))
      (𝓝[>] (0:ℝ)) (𝓝 (cschRegPrim 1 - -(2 * Real.log 4))) := by
    refine hlim2.congr' ?_
    filter_upwards [Ioo_mem_nhdsGT one_pos] with ε hε
    exact (heq ε hε).symm
  have huniq := tendsto_nhds_unique hlim hcongr
  rw [huniq, cschRegPrim, Real.log_one]
  ring

/-- **The regularized hyperbolic integral identity**:
`∫_0^1 (1/sinh(t/2) - 2/t) dt + ∫_1^∞ dt/sinh(t/2) = 4 log 2`. -/
theorem cschHalf_regularized_identity :
    (∫ t in (0:ℝ)..1, (1 / Real.sinh (t / 2) - 2 / t))
      + (∫ t in Ioi (1:ℝ), 1 / Real.sinh (t / 2)) = 4 * Real.log 2 := by
  rw [integral_zero_one_cschReg, integral_Ioi_one_cschHalf]
  have h4 : Real.log 4 = 2 * Real.log 2 := by
    rw [show (4:ℝ) = 2 ^ 2 by norm_num, Real.log_pow]
    push_cast
    ring
  rw [h4]
  ring

end ConnesConsani.WeilPositivity
