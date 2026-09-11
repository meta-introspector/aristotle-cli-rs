/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The classical asymptotic expansion of the sine integral

  `Si(x) = π/2 - f(x) cos x - g(x) sin x`,  `0 ≤ f(x) ≤ 1/x`,  `0 ≤ g(x) ≤ 1/x²`,

with the **auxiliary functions** given by absolutely convergent Laplace integrals

  `f(x) = ∫_0^∞ e^{-xy}/(1+y²) dy`,   `g(x) = ∫_0^∞ y e^{-xy}/(1+y²) dy`.

In particular this contains the **Dirichlet integral** `∫_0^∞ sin t/t dt = π/2`
(`tendsto_Si_atTop`), which is not in Mathlib, and the effective bound
`|Si x - π/2| ≤ 1/x + 1/x²` (`abs_Si_sub_pi_div_two_le`).

The proof is the classical one: substituting `1/x = ∫_0^∞ e^{-xy} dy` into
`Si(X) = ∫_0^X (sin x) / x dx` and exchanging the two integrations (legitimate: the double
integral converges absolutely, since `∫_0^∞ |sin x| e^{-xy} dy = |sin x|/x ≤ 1`) reduces
everything to the elementary integral `∫_0^X e^{-xy} sin x dx`.

These bounds are the analytic input identified in `RequestProject/CompactInterval.lean` as
missing for a rigorous numerical evaluation of `δ̂(0)`.
-/
import RequestProject.Imported.OutputFinal2.SineIntegral

noncomputable section

open MeasureTheory Set Real Filter Topology intervalIntegral

namespace ConnesConsani.WeilPositivity

/-! ## The two auxiliary functions -/

/-- The auxiliary function `f(x) = ∫_0^∞ e^{-xy}/(1+y²) dy` multiplying `cos x` in the
asymptotic expansion of `Si`. -/
def siAuxCos (x : ℝ) : ℝ := ∫ y in Ioi (0:ℝ), Real.exp (-(x * y)) / (1 + y ^ 2)

/-- The auxiliary function `g(x) = ∫_0^∞ y e^{-xy}/(1+y²) dy` multiplying `sin x` in the
asymptotic expansion of `Si`. -/
def siAuxSin (x : ℝ) : ℝ := ∫ y in Ioi (0:ℝ), y * Real.exp (-(x * y)) / (1 + y ^ 2)

/-! ### Elementary Laplace integrals -/

theorem integrableOn_exp_neg_mul {x : ℝ} (hx : 0 < x) :
    IntegrableOn (fun y => Real.exp (-(x * y))) (Ioi 0) volume := by
  simpa [neg_mul] using exp_neg_integrableOn_Ioi (a := (0:ℝ)) (b := x) hx

theorem integral_exp_neg_mul {x : ℝ} (hx : 0 < x) :
    (∫ y in Ioi (0:ℝ), Real.exp (-(x * y))) = 1 / x := by
  have h := integral_exp_mul_Ioi (a := -x) (c := (0:ℝ)) (by linarith)
  rw [show (fun y : ℝ => Real.exp (-(x * y))) = fun y : ℝ => Real.exp (-x * y) by
    funext y; ring_nf]
  rw [h]; simp

/-- `y ≤ e^{a y}/a` for `a, y > 0`, the elementary bound behind the integrability of
`y e^{-xy}`. -/
theorem le_exp_div {a y : ℝ} (ha : 0 < a) : y ≤ Real.exp (a * y) / a := by
  have h := Real.add_one_le_exp (a * y)
  rw [le_div_iff₀ ha]
  nlinarith

theorem integrableOn_mul_exp_neg_mul {x : ℝ} (hx : 0 < x) :
    IntegrableOn (fun y => y * Real.exp (-(x * y))) (Ioi 0) volume := by
  refine Integrable.mono' (g := fun y => (2 / x) * Real.exp (-(x / 2 * y)))
    ((integrableOn_exp_neg_mul (x := x / 2) (by linarith)).const_mul _)
    (by fun_prop) ?_
  filter_upwards [ae_restrict_mem measurableSet_Ioi] with y hy
  have hy0 : (0:ℝ) < y := hy
  have hle : y ≤ Real.exp (x / 2 * y) / (x / 2) := le_exp_div (by linarith)
  have hsplit : Real.exp (-(x * y)) = Real.exp (-(x / 2 * y)) * Real.exp (-(x / 2 * y)) := by
    rw [← Real.exp_add]; ring_nf
  rw [Real.norm_eq_abs, abs_of_nonneg (by positivity), hsplit]
  have hpos : (0:ℝ) < Real.exp (-(x / 2 * y)) := Real.exp_pos _
  have hkey : y * Real.exp (-(x / 2 * y)) ≤ 2 / x := by
    rw [Real.exp_neg, mul_inv_le_iff₀ (Real.exp_pos _)]
    have : Real.exp (x / 2 * y) / (x / 2) = 2 / x * Real.exp (x / 2 * y) := by
      field_simp
    calc y ≤ Real.exp (x / 2 * y) / (x / 2) := hle
      _ = 2 / x * Real.exp (x / 2 * y) := this
  calc y * (Real.exp (-(x / 2 * y)) * Real.exp (-(x / 2 * y)))
      = (y * Real.exp (-(x / 2 * y))) * Real.exp (-(x / 2 * y)) := by ring
    _ ≤ (2 / x) * Real.exp (-(x / 2 * y)) := by
        exact mul_le_mul_of_nonneg_right hkey hpos.le

theorem integral_mul_exp_neg_mul {x : ℝ} (hx : 0 < x) :
    (∫ y in Ioi (0:ℝ), y * Real.exp (-(x * y))) = 1 / x ^ 2 := by
  set F : ℝ → ℝ := fun y => -((y / x + 1 / x ^ 2) * Real.exp (-(x * y))) with hF
  have hderiv : ∀ y ∈ Ioi (0:ℝ), HasDerivAt F (y * Real.exp (-(x * y))) y := by
    intro y _
    have he : HasDerivAt (fun y : ℝ => Real.exp (-(x * y))) (Real.exp (-(x * y)) * (-x)) y := by
      have h1 : HasDerivAt (fun y : ℝ => -(x * y)) (-x) y := by
        simpa using ((hasDerivAt_id y).const_mul x).neg
      simpa using (Real.hasDerivAt_exp (-(x * y))).comp y h1
    have hl : HasDerivAt (fun y : ℝ => y / x + 1 / x ^ 2) (1 / x) y := by
      simpa using ((hasDerivAt_id y).div_const x).add_const (1 / x ^ 2)
    have := (hl.mul he).neg
    convert this using 1
    field_simp
    ring
  have hcont : ContinuousWithinAt F (Ici 0) 0 := by
    apply Continuous.continuousWithinAt
    fun_prop
  have hnonneg : ∀ y ∈ Ioi (0:ℝ), 0 ≤ y * Real.exp (-(x * y)) := by
    intro y hy
    have : (0:ℝ) < y := hy
    positivity
  have hxy : Tendsto (fun y : ℝ => x * y) atTop atTop :=
    Filter.Tendsto.const_mul_atTop hx tendsto_id
  have hA : Tendsto (fun y : ℝ => y * Real.exp (-(x * y))) atTop (𝓝 0) := by
    have base : Tendsto (fun z : ℝ => z * Real.exp (-z)) atTop (𝓝 0) := by
      simpa using tendsto_pow_mul_exp_neg_atTop_nhds_zero 1
    have h := (base.comp hxy).const_mul (1 / x)
    rw [mul_zero] at h
    refine h.congr fun y => ?_
    simp only [Function.comp_apply]
    field_simp
  have hB : Tendsto (fun y : ℝ => Real.exp (-(x * y))) atTop (𝓝 0) := by
    have h : Tendsto (fun y : ℝ => -(x * y)) atTop atBot := tendsto_neg_atTop_atBot.comp hxy
    exact Real.tendsto_exp_atBot.comp h
  have hmain : Tendsto (fun y : ℝ => (y / x + 1 / x ^ 2) * Real.exp (-(x * y))) atTop (𝓝 0) := by
    have hsum := (hA.const_mul (1 / x)).add (hB.const_mul (1 / x ^ 2))
    rw [mul_zero, mul_zero, add_zero] at hsum
    exact hsum.congr fun y => by field_simp
  have hlim : Tendsto F atTop (𝓝 0) := by
    have h := hmain.neg
    rw [neg_zero] at h
    exact h
  have h := integral_Ioi_of_hasDerivAt_of_nonneg hcont hderiv hnonneg hlim
  rw [h, hF]
  simp

/-! ### Bounds for the auxiliary functions -/

theorem integrableOn_siAuxCos {x : ℝ} (hx : 0 < x) :
    IntegrableOn (fun y => Real.exp (-(x * y)) / (1 + y ^ 2)) (Ioi 0) volume := by
  have hcont : Continuous fun y : ℝ => Real.exp (-(x * y)) / (1 + y ^ 2) := by
    apply Continuous.div (by fun_prop) (by fun_prop)
    intro y; positivity
  refine Integrable.mono' (integrableOn_exp_neg_mul hx) hcont.aestronglyMeasurable ?_
  filter_upwards with y
  rw [Real.norm_eq_abs, abs_of_nonneg (by positivity)]
  rw [div_le_iff₀ (by positivity)]
  nlinarith [Real.exp_pos (-(x * y)), sq_nonneg y]

theorem integrableOn_siAuxSin {x : ℝ} (hx : 0 < x) :
    IntegrableOn (fun y => y * Real.exp (-(x * y)) / (1 + y ^ 2)) (Ioi 0) volume := by
  have hcont : Continuous fun y : ℝ => y * Real.exp (-(x * y)) / (1 + y ^ 2) := by
    apply Continuous.div (by fun_prop) (by fun_prop)
    intro y; positivity
  refine Integrable.mono' (integrableOn_mul_exp_neg_mul hx) hcont.aestronglyMeasurable ?_
  filter_upwards [ae_restrict_mem measurableSet_Ioi] with y hy
  have hy0 : (0:ℝ) < y := hy
  rw [Real.norm_eq_abs, abs_of_nonneg (by positivity)]
  rw [div_le_iff₀ (by positivity)]
  nlinarith [Real.exp_pos (-(x * y)), sq_nonneg y, mul_pos hy0 (Real.exp_pos (-(x * y)))]

theorem siAuxCos_nonneg (x : ℝ) : 0 ≤ siAuxCos x := by
  refine setIntegral_nonneg measurableSet_Ioi fun y _ => ?_
  positivity

theorem siAuxSin_nonneg (x : ℝ) : 0 ≤ siAuxSin x := by
  refine setIntegral_nonneg measurableSet_Ioi fun y hy => ?_
  have : (0:ℝ) < y := hy
  positivity

theorem siAuxCos_le {x : ℝ} (hx : 0 < x) : siAuxCos x ≤ 1 / x := by
  rw [siAuxCos, ← integral_exp_neg_mul hx]
  refine setIntegral_mono_on (integrableOn_siAuxCos hx) (integrableOn_exp_neg_mul hx)
    measurableSet_Ioi fun y _ => ?_
  rw [div_le_iff₀ (by positivity)]
  nlinarith [Real.exp_pos (-(x * y)), sq_nonneg y]

theorem siAuxSin_le {x : ℝ} (hx : 0 < x) : siAuxSin x ≤ 1 / x ^ 2 := by
  rw [siAuxSin, ← integral_mul_exp_neg_mul hx]
  refine setIntegral_mono_on (integrableOn_siAuxSin hx) (integrableOn_mul_exp_neg_mul hx)
    measurableSet_Ioi fun y hy => ?_
  have hy0 : (0:ℝ) < y := hy
  rw [div_le_iff₀ (by positivity)]
  nlinarith [Real.exp_pos (-(x * y)), sq_nonneg y, mul_pos hy0 (Real.exp_pos (-(x * y)))]

/-! ## The expansion of `Si` -/

/-- The elementary inner integral `∫_0^X e^{-xy} sin x dx`. -/
theorem integral_sin_mul_exp (y X : ℝ) :
    (∫ x in (0:ℝ)..X, Real.sin x * Real.exp (-(x * y)))
      = (1 - Real.exp (-(X * y)) * (Real.cos X + y * Real.sin X)) / (1 + y ^ 2) := by
  have hF : ∀ x : ℝ, HasDerivAt
      (fun x : ℝ => (1 - Real.exp (-(x * y)) * (Real.cos x + y * Real.sin x)) / (1 + y ^ 2))
      (Real.sin x * Real.exp (-(x * y))) x := by
    intro x
    have he : HasDerivAt (fun x : ℝ => Real.exp (-(x * y))) (Real.exp (-(x * y)) * (-y)) x := by
      have h1 : HasDerivAt (fun x : ℝ => -(x * y)) (-y) x := by
        simpa using ((hasDerivAt_id x).mul_const y).neg
      simpa using (Real.hasDerivAt_exp (-(x * y))).comp x h1
    have hc : HasDerivAt (fun x : ℝ => Real.cos x + y * Real.sin x)
        (-Real.sin x + y * Real.cos x) x :=
      (Real.hasDerivAt_cos x).add ((Real.hasDerivAt_sin x).const_mul y)
    have := ((he.mul hc).const_sub 1).div_const (1 + y ^ 2)
    convert this using 1
    have hden : (0:ℝ) < 1 + y ^ 2 := by positivity
    field_simp
    ring
  rw [integral_eq_sub_of_hasDerivAt (fun x _ => hF x)
    (Continuous.intervalIntegrable (by fun_prop) _ _)]
  simp

theorem integrable_uncurry_sin_exp (X : ℝ) :
    Integrable (Function.uncurry (fun x y : ℝ => Real.sin x * Real.exp (-(x * y))))
      ((volume.restrict (Ioo 0 X)).prod (volume.restrict (Ioi (0:ℝ)))) := by
  have hmeas : AEStronglyMeasurable
      (Function.uncurry (fun x y : ℝ => Real.sin x * Real.exp (-(x * y))))
      ((volume.restrict (Ioo 0 X)).prod (volume.restrict (Ioi (0:ℝ)))) := by
    apply Continuous.aestronglyMeasurable
    unfold Function.uncurry
    fun_prop
  rw [MeasureTheory.integrable_prod_iff hmeas]
  refine ⟨?_, ?_⟩
  · filter_upwards [ae_restrict_mem measurableSet_Ioo] with x hx
    simp only [Function.uncurry_apply_pair]
    exact (integrableOn_exp_neg_mul hx.1).const_mul _
  · refine Integrable.mono' (g := fun _ : ℝ => (1:ℝ))
      (integrableOn_const (hs := by simp [Real.volume_Ioo]) (hC := by simp))
      (hmeas.norm.integral_prod_right') ?_
    filter_upwards [ae_restrict_mem measurableSet_Ioo] with x hx
    have hx0 : 0 < x := hx.1
    simp only [Function.uncurry_apply_pair]
    have heq : (∫ y in Ioi (0:ℝ), ‖Real.sin x * Real.exp (-(x * y))‖)
        = |Real.sin x| * (1 / x) := by
      have h : ∀ y : ℝ, ‖Real.sin x * Real.exp (-(x * y))‖
          = |Real.sin x| * Real.exp (-(x * y)) := fun y => by
        rw [Real.norm_eq_abs, abs_mul, abs_of_pos (Real.exp_pos _)]
      simp_rw [h]
      rw [MeasureTheory.integral_const_mul, integral_exp_neg_mul hx0]
    rw [Real.norm_eq_abs, heq]
    have h1 : |Real.sin x| ≤ x := by
      have := Real.abs_sin_le_abs (x := x)
      rwa [abs_of_pos hx0] at this
    rw [abs_of_nonneg (by positivity), mul_one_div, div_le_one hx0]
    exact h1

/-- **The asymptotic expansion of the sine integral**:
`Si x = π/2 - f(x) cos x - g(x) sin x` with the two Laplace integrals `f = siAuxCos` and
`g = siAuxSin`. -/
theorem Si_eq_pi_div_two_sub {X : ℝ} (hX : 0 < X) :
    Si X = π / 2 - siAuxCos X * Real.cos X - siAuxSin X * Real.sin X := by
  -- write `Si X` as a double integral
  have hSi : Si X = ∫ x in Ioo (0:ℝ) X, Real.sin x / x := by
    rw [Si_eq_integral_sin_div, intervalIntegral.integral_of_le hX.le,
      MeasureTheory.integral_Ioc_eq_integral_Ioo]
  have hinner : ∀ x ∈ Ioo (0:ℝ) X,
      Real.sin x / x = ∫ y in Ioi (0:ℝ), Real.sin x * Real.exp (-(x * y)) := by
    intro x hx
    rw [MeasureTheory.integral_const_mul, integral_exp_neg_mul hx.1]
    ring
  have hdouble : Si X
      = ∫ x in Ioo (0:ℝ) X, ∫ y in Ioi (0:ℝ), Real.sin x * Real.exp (-(x * y)) := by
    rw [hSi]
    exact setIntegral_congr_fun measurableSet_Ioo hinner
  rw [hdouble, MeasureTheory.integral_integral_swap (integrable_uncurry_sin_exp X)]
  -- evaluate the inner (now `x`-) integral
  have hx : ∀ y : ℝ, (∫ x in Ioo (0:ℝ) X, Real.sin x * Real.exp (-(x * y)))
      = 1 / (1 + y ^ 2) - Real.cos X * (Real.exp (-(X * y)) / (1 + y ^ 2))
        - Real.sin X * (y * Real.exp (-(X * y)) / (1 + y ^ 2)) := by
    intro y
    have h : (∫ x in Ioo (0:ℝ) X, Real.sin x * Real.exp (-(x * y)))
        = ∫ x in (0:ℝ)..X, Real.sin x * Real.exp (-(x * y)) := by
      rw [intervalIntegral.integral_of_le hX.le, MeasureTheory.integral_Ioc_eq_integral_Ioo]
    rw [h, integral_sin_mul_exp]
    have hden : (0:ℝ) < 1 + y ^ 2 := by positivity
    field_simp
    ring
  simp only [hx]
  -- integrate the three pieces
  have h1 : IntegrableOn (fun y : ℝ => 1 / (1 + y ^ 2)) (Ioi 0) volume := by
    simpa [one_div] using (integrable_inv_one_add_sq.integrableOn (s := Ioi (0:ℝ)))
  have h2 : IntegrableOn (fun y : ℝ => Real.cos X * (Real.exp (-(X * y)) / (1 + y ^ 2)))
      (Ioi 0) volume := (integrableOn_siAuxCos hX).const_mul _
  have h3 : IntegrableOn (fun y : ℝ => Real.sin X * (y * Real.exp (-(X * y)) / (1 + y ^ 2)))
      (Ioi 0) volume := (integrableOn_siAuxSin hX).const_mul _
  have h12 : IntegrableOn (fun y : ℝ =>
      1 / (1 + y ^ 2) - Real.cos X * (Real.exp (-(X * y)) / (1 + y ^ 2))) (Ioi 0) volume :=
    h1.sub h2
  rw [integral_sub h12 h3, integral_sub h1 h2, MeasureTheory.integral_const_mul,
    MeasureTheory.integral_const_mul]
  have hpi : (∫ y in Ioi (0:ℝ), 1 / (1 + y ^ 2)) = π / 2 := by
    simp [one_div]
  rw [hpi, ← siAuxCos, ← siAuxSin]
  ring

/-- **The effective bound `|Si x - π/2| ≤ 1/x + 1/x²`**. -/
theorem abs_Si_sub_pi_div_two_le {x : ℝ} (hx : 0 < x) :
    |Si x - π / 2| ≤ 1 / x + 1 / x ^ 2 := by
  rw [Si_eq_pi_div_two_sub hx]
  have hc := siAuxCos_nonneg x
  have hs := siAuxSin_nonneg x
  have hc' := siAuxCos_le hx
  have hs' := siAuxSin_le hx
  have h1 : |siAuxCos x * Real.cos x| ≤ 1 / x := by
    rw [abs_mul, abs_of_nonneg hc]
    calc siAuxCos x * |Real.cos x| ≤ siAuxCos x * 1 :=
          mul_le_mul_of_nonneg_left (Real.abs_cos_le_one _) hc
      _ = siAuxCos x := mul_one _
      _ ≤ 1 / x := hc'
  have h2 : |siAuxSin x * Real.sin x| ≤ 1 / x ^ 2 := by
    rw [abs_mul, abs_of_nonneg hs]
    calc siAuxSin x * |Real.sin x| ≤ siAuxSin x * 1 :=
          mul_le_mul_of_nonneg_left (Real.abs_sin_le_one _) hs
      _ = siAuxSin x := mul_one _
      _ ≤ 1 / x ^ 2 := hs'
  have : π / 2 - siAuxCos x * Real.cos x - siAuxSin x * Real.sin x - π / 2
      = -(siAuxCos x * Real.cos x) - siAuxSin x * Real.sin x := by ring
  rw [this]
  calc |-(siAuxCos x * Real.cos x) - siAuxSin x * Real.sin x|
      ≤ |-(siAuxCos x * Real.cos x)| + |siAuxSin x * Real.sin x| := abs_sub _ _
    _ = |siAuxCos x * Real.cos x| + |siAuxSin x * Real.sin x| := by rw [abs_neg]
    _ ≤ 1 / x + 1 / x ^ 2 := add_le_add h1 h2

/-- **The Dirichlet integral**: `Si x → π/2` as `x → ∞`, i.e. `∫_0^∞ sin t/t dt = π/2`. -/
theorem tendsto_Si_atTop : Tendsto Si atTop (𝓝 (π / 2)) := by
  rw [← tendsto_sub_nhds_zero_iff]
  have hbound : ∀ᶠ x : ℝ in atTop, ‖Si x - π / 2‖ ≤ 1 / x + 1 / x ^ 2 := by
    filter_upwards [eventually_gt_atTop (0:ℝ)] with x hx
    exact abs_Si_sub_pi_div_two_le hx
  have hlim : Tendsto (fun x : ℝ => 1 / x + 1 / x ^ 2) atTop (𝓝 0) := by
    have h1 : Tendsto (fun x : ℝ => 1 / x) atTop (𝓝 0) :=
      tendsto_inv_atTop_zero.congr fun x => (one_div x).symm
    have h2 : Tendsto (fun x : ℝ => 1 / x ^ 2) atTop (𝓝 0) := by
      have h : Tendsto (fun x : ℝ => x ^ 2) atTop atTop := tendsto_pow_atTop (by norm_num)
      simpa [one_div] using h.inv_tendsto_atTop
    simpa using h1.add h2
  exact squeeze_zero_norm' hbound hlim

/-- The lower bound `Si x ≥ π/2 - 1/x - 1/x²`, in the form used for numerical work. -/
theorem Si_ge {x : ℝ} (hx : 0 < x) : π / 2 - 1 / x - 1 / x ^ 2 ≤ Si x := by
  have h := abs_Si_sub_pi_div_two_le hx
  have := abs_le.1 h
  linarith [this.1]

/-- The upper bound `Si x ≤ π/2 + 1/x + 1/x²`. -/
theorem Si_le_of_pos {x : ℝ} (hx : 0 < x) : Si x ≤ π / 2 + 1 / x + 1 / x ^ 2 := by
  have := abs_le.1 (abs_Si_sub_pi_div_two_le hx)
  linarith [this.2]

end ConnesConsani.WeilPositivity
