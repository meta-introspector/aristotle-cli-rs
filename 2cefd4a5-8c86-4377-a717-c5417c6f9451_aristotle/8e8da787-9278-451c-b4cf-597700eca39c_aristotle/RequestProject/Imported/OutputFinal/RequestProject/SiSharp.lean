/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The *sharpened* asymptotic bracket for the sine integral.

`RequestProject/SiAsymptotic.lean` proves the exact expansion

  `Si x = π/2 - f(x) cos x - g(x) sin x`,
  `f(x) = ∫₀^∞ e^{-xy}/(1+y²) dy`,  `g(x) = ∫₀^∞ y e^{-xy}/(1+y²) dy`,

together with the one-sided bounds `0 ≤ f ≤ 1/x`, `0 ≤ g ≤ 1/x²`, which give the crude
bracket `|Si x - π/2| ≤ 1/x + 1/x²` used in `RequestProject/PolyaError.lean`.

Here the *lower* bounds

  `1/x - 2/x³ ≤ f(x)`,   `1/x² - 6/x⁴ ≤ g(x)`

are added (from `1/(1+y²) ≥ 1 - y²` and `y/(1+y²) ≥ y - y³` together with the Laplace
moments `∫₀^∞ y² e^{-xy} dy = 2/x³`, `∫₀^∞ y³ e^{-xy} dy = 6/x⁴`).  Consequently

  `Si x = π/2 - cos x / x - sin x / x² + O(2/x³ + 6/x⁴)`,

which at the smallest argument occurring in the Pólya error analysis, `x = 4π`, replaces an
uncertainty of `1/x + 1/x² ≈ 0.086` by one of `≈ 0.0013`.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBase

noncomputable section

open MeasureTheory Set Real Filter Topology

namespace ConnesConsani.WeilPositivity

/-! ## 1. The Laplace moments of order 2 and 3 -/

theorem integrableOn_sq_mul_exp_neg_mul {x : ℝ} (hx : 0 < x) :
    IntegrableOn (fun y : ℝ => y ^ 2 * Real.exp (-(x * y))) (Ioi 0) volume := by
  have hcont : Continuous fun y : ℝ => y ^ 2 * Real.exp (-(x * y)) := by fun_prop
  refine Integrable.mono' ((integrableOn_exp_neg_mul (x := x / 2) (by linarith)).const_mul
    (8 / x ^ 2)) hcont.aestronglyMeasurable ?_
  filter_upwards [ae_restrict_mem measurableSet_Ioi] with y hy
  have hy0 : (0:ℝ) < y := hy
  have hkey : y ^ 2 ≤ 8 / x ^ 2 * Real.exp (x / 2 * y) := by
    have h := Real.add_one_le_exp (x / 2 * y)
    have h2 : (x / 2 * y) ^ 2 / 2 ≤ Real.exp (x / 2 * y) := by
      have := Real.sum_le_exp_of_nonneg (x := x / 2 * y) (by positivity) 3
      simp [Finset.sum_range_succ, Nat.factorial] at this
      nlinarith [this, mul_pos (by linarith : (0:ℝ) < x / 2) hy0]
    rw [div_mul_eq_mul_div, le_div_iff₀ (by positivity : (0:ℝ) < x ^ 2)]
    nlinarith [h2]
  rw [Real.norm_eq_abs, abs_of_nonneg (by positivity)]
  have hsplit : Real.exp (-(x * y)) = Real.exp (-(x / 2 * y)) * Real.exp (-(x / 2 * y)) := by
    rw [← Real.exp_add]; ring_nf
  rw [hsplit, ← mul_assoc]
  refine mul_le_mul_of_nonneg_right ?_ (Real.exp_pos _).le
  calc y ^ 2 * Real.exp (-(x / 2 * y))
      ≤ (8 / x ^ 2 * Real.exp (x / 2 * y)) * Real.exp (-(x / 2 * y)) :=
        mul_le_mul_of_nonneg_right hkey (Real.exp_pos _).le
    _ = 8 / x ^ 2 := by
        rw [mul_assoc, ← Real.exp_add]; norm_num

theorem integrableOn_cube_mul_exp_neg_mul {x : ℝ} (hx : 0 < x) :
    IntegrableOn (fun y : ℝ => y ^ 3 * Real.exp (-(x * y))) (Ioi 0) volume := by
  have hcont : Continuous fun y : ℝ => y ^ 3 * Real.exp (-(x * y)) := by fun_prop
  refine Integrable.mono' ((integrableOn_exp_neg_mul (x := x / 2) (by linarith)).const_mul
    (48 / x ^ 3)) hcont.aestronglyMeasurable ?_
  filter_upwards [ae_restrict_mem measurableSet_Ioi] with y hy
  have hy0 : (0:ℝ) < y := hy
  have hkey : y ^ 3 ≤ 48 / x ^ 3 * Real.exp (x / 2 * y) := by
    have h3 : (x / 2 * y) ^ 3 / 6 ≤ Real.exp (x / 2 * y) := by
      have := Real.sum_le_exp_of_nonneg (x := x / 2 * y) (by positivity) 4
      simp [Finset.sum_range_succ, Nat.factorial] at this
      nlinarith [this, mul_pos (by linarith : (0:ℝ) < x / 2) hy0, sq_nonneg (x / 2 * y)]
    rw [div_mul_eq_mul_div, le_div_iff₀ (by positivity : (0:ℝ) < x ^ 3)]
    nlinarith [h3]
  rw [Real.norm_eq_abs, abs_of_nonneg (by positivity)]
  have hsplit : Real.exp (-(x * y)) = Real.exp (-(x / 2 * y)) * Real.exp (-(x / 2 * y)) := by
    rw [← Real.exp_add]; ring_nf
  rw [hsplit, ← mul_assoc]
  refine mul_le_mul_of_nonneg_right ?_ (Real.exp_pos _).le
  calc y ^ 3 * Real.exp (-(x / 2 * y))
      ≤ (48 / x ^ 3 * Real.exp (x / 2 * y)) * Real.exp (-(x / 2 * y)) :=
        mul_le_mul_of_nonneg_right hkey (Real.exp_pos _).le
    _ = 48 / x ^ 3 := by
        rw [mul_assoc, ← Real.exp_add]; norm_num

/-- `∫₀^∞ y² e^{-xy} dy = 2/x³`. -/
theorem integral_sq_mul_exp_neg_mul {x : ℝ} (hx : 0 < x) :
    (∫ y in Ioi (0:ℝ), y ^ 2 * Real.exp (-(x * y))) = 2 / x ^ 3 := by
  have h := integral_rpow_mul_exp_neg_mul_Ioi (a := 3) (r := x) (by norm_num) hx
  rw [show ((3:ℝ) - 1) = 2 by norm_num] at h
  rw [show (∫ y in Ioi (0:ℝ), y ^ 2 * Real.exp (-(x * y)))
      = ∫ y in Ioi (0:ℝ), y ^ (2:ℝ) * Real.exp (-(x * y)) from
    setIntegral_congr_fun measurableSet_Ioi (fun y _ => by
      rw [Real.rpow_two, ← Real.rpow_natCast y 2])]
  rw [h, Real.Gamma_ofNat_eq_factorial 2,
    show ((Nat.factorial 2 : ℝ)) = 2 by norm_num,
    show (3:ℝ) = ((3:ℕ):ℝ) by norm_num, Real.rpow_natCast, div_pow, one_pow]
  ring

/-- `∫₀^∞ y³ e^{-xy} dy = 6/x⁴`. -/
theorem integral_cube_mul_exp_neg_mul {x : ℝ} (hx : 0 < x) :
    (∫ y in Ioi (0:ℝ), y ^ 3 * Real.exp (-(x * y))) = 6 / x ^ 4 := by
  have h := integral_rpow_mul_exp_neg_mul_Ioi (a := 4) (r := x) (by norm_num) hx
  rw [show ((4:ℝ) - 1) = 3 by norm_num] at h
  rw [show (∫ y in Ioi (0:ℝ), y ^ 3 * Real.exp (-(x * y)))
      = ∫ y in Ioi (0:ℝ), y ^ (3:ℝ) * Real.exp (-(x * y)) from
    setIntegral_congr_fun measurableSet_Ioi (fun y _ => by
      rw [← Real.rpow_natCast y 3]; norm_num)]
  rw [h, Real.Gamma_ofNat_eq_factorial 3,
    show ((Nat.factorial 3 : ℝ)) = 6 by norm_num,
    show (4:ℝ) = ((4:ℕ):ℝ) by norm_num, Real.rpow_natCast, div_pow, one_pow]
  ring

/-! ## 2. The sharpened bounds for the two auxiliary functions -/

/-- **Lower bound for `f(x) = ∫₀^∞ e^{-xy}/(1+y²) dy`**: `f(x) ≥ 1/x - 2/x³`. -/
theorem siAuxCos_ge {x : ℝ} (hx : 0 < x) : 1 / x - 2 / x ^ 3 ≤ siAuxCos x := by
  have hint : IntegrableOn (fun y : ℝ => Real.exp (-(x * y)) - y ^ 2 * Real.exp (-(x * y)))
      (Ioi 0) volume := (integrableOn_exp_neg_mul hx).sub (integrableOn_sq_mul_exp_neg_mul hx)
  have hval : (∫ y in Ioi (0:ℝ), (Real.exp (-(x * y)) - y ^ 2 * Real.exp (-(x * y))))
      = 1 / x - 2 / x ^ 3 := by
    rw [integral_sub (integrableOn_exp_neg_mul hx) (integrableOn_sq_mul_exp_neg_mul hx),
      integral_exp_neg_mul hx, integral_sq_mul_exp_neg_mul hx]
  rw [siAuxCos, ← hval]
  refine setIntegral_mono_on hint (integrableOn_siAuxCos hx) measurableSet_Ioi fun y _ => ?_
  rw [le_div_iff₀ (by positivity)]
  nlinarith [Real.exp_pos (-(x * y)), sq_nonneg y, sq_nonneg (y ^ 2)]

/-- **Lower bound for `g(x) = ∫₀^∞ y e^{-xy}/(1+y²) dy`**: `g(x) ≥ 1/x² - 6/x⁴`. -/
theorem siAuxSin_ge {x : ℝ} (hx : 0 < x) : 1 / x ^ 2 - 6 / x ^ 4 ≤ siAuxSin x := by
  have hint : IntegrableOn
      (fun y : ℝ => y * Real.exp (-(x * y)) - y ^ 3 * Real.exp (-(x * y))) (Ioi 0) volume :=
    (integrableOn_mul_exp_neg_mul hx).sub (integrableOn_cube_mul_exp_neg_mul hx)
  have hval : (∫ y in Ioi (0:ℝ), (y * Real.exp (-(x * y)) - y ^ 3 * Real.exp (-(x * y))))
      = 1 / x ^ 2 - 6 / x ^ 4 := by
    rw [integral_sub (integrableOn_mul_exp_neg_mul hx) (integrableOn_cube_mul_exp_neg_mul hx),
      integral_mul_exp_neg_mul hx, integral_cube_mul_exp_neg_mul hx]
  rw [siAuxSin, ← hval]
  refine setIntegral_mono_on hint (integrableOn_siAuxSin hx) measurableSet_Ioi fun y hy => ?_
  have hy0 : (0:ℝ) < y := hy
  rw [le_div_iff₀ (by positivity)]
  nlinarith [mul_nonneg (mul_pos hy0 (Real.exp_pos (-(x * y)))).le (pow_nonneg hy0.le 4)]

/-- The four bounds for the auxiliary functions at a point of an interval `[X0,X1]`. -/
theorem siAux_bracket {x X0 X1 : ℝ} (hX0 : 0 < X0) (h0 : X0 ≤ x) (h1 : x ≤ X1) :
    (1 / X1 - 2 / X0 ^ 3 ≤ siAuxCos x ∧ siAuxCos x ≤ 1 / X0) ∧
      (1 / X1 ^ 2 - 6 / X0 ^ 4 ≤ siAuxSin x ∧ siAuxSin x ≤ 1 / X0 ^ 2) := by
  have hx : 0 < x := lt_of_lt_of_le hX0 h0
  have hX1 : 0 < X1 := lt_of_lt_of_le hx h1
  have e1 : 1 / X1 ≤ 1 / x := one_div_le_one_div_of_le hx h1
  have e2 : 2 / x ^ 3 ≤ 2 / X0 ^ 3 :=
    div_le_div_of_nonneg_left (by norm_num) (by positivity) (pow_le_pow_left₀ hX0.le h0 3)
  have e3 : 1 / x ≤ 1 / X0 := one_div_le_one_div_of_le hX0 h0
  have e4 : 1 / X1 ^ 2 ≤ 1 / x ^ 2 :=
    one_div_le_one_div_of_le (by positivity) (pow_le_pow_left₀ hx.le h1 2)
  have e5 : 6 / x ^ 4 ≤ 6 / X0 ^ 4 :=
    div_le_div_of_nonneg_left (by norm_num) (by positivity) (pow_le_pow_left₀ hX0.le h0 4)
  have e6 : 1 / x ^ 2 ≤ 1 / X0 ^ 2 :=
    one_div_le_one_div_of_le (by positivity) (pow_le_pow_left₀ hX0.le h0 2)
  exact ⟨⟨by linarith [siAuxCos_ge hx], le_trans (siAuxCos_le hx) e3⟩,
    ⟨by linarith [siAuxSin_ge hx], le_trans (siAuxSin_le hx) e6⟩⟩

/-! ## 3. Interval arithmetic helpers -/

/-- Lower bound for a product whose left factor is bracketed by nonnegative numbers. -/
theorem mul_ge_of_bracket {p P q z w L : ℝ} (hp : 0 ≤ p) (h1 : p ≤ z) (h2 : z ≤ P)
    (h3 : q ≤ w) (hL1 : L ≤ P * q) (hL2 : L ≤ p * q) : L ≤ z * w := by
  have hz : 0 ≤ z := le_trans hp h1
  have hzw : z * q ≤ z * w := mul_le_mul_of_nonneg_left h3 hz
  rcases le_total 0 q with hq | hq
  · nlinarith
  · nlinarith

/-- Upper bound for a product whose left factor is bracketed by nonnegative numbers. -/
theorem mul_le_of_bracket {p P Q z w U : ℝ} (hp : 0 ≤ p) (h1 : p ≤ z) (h2 : z ≤ P)
    (h4 : w ≤ Q) (hU1 : P * Q ≤ U) (hU2 : p * Q ≤ U) : z * w ≤ U := by
  have hz : 0 ≤ z := le_trans hp h1
  have hzw : z * w ≤ z * Q := mul_le_mul_of_nonneg_left h4 hz
  rcases le_total 0 Q with hQ | hQ
  · nlinarith
  · nlinarith

/-- **The sharpened bracket for `Si`** in rational form: from brackets for `x`, for `cos x`
and for `sin x` one gets a bracket for `Si x`. -/
theorem Si_sharp_bracket {x X0 X1 C0 C1 S0 S1 L U : ℝ}
    (hX0 : 0 < X0) (hx0 : X0 ≤ x) (hx1 : x ≤ X1)
    (hFnn : 0 ≤ 1 / X1 - 2 / X0 ^ 3) (hGnn : 0 ≤ 1 / X1 ^ 2 - 6 / X0 ^ 4)
    (hC0 : C0 ≤ Real.cos x) (hC1 : Real.cos x ≤ C1)
    (hS0 : S0 ≤ Real.sin x) (hS1 : Real.sin x ≤ S1)
    (hL1 : L ≤ 1.5707963 - (1 / X0) * C1 - (1 / X0 ^ 2) * S1)
    (hL2 : L ≤ 1.5707963 - (1 / X0) * C1 - (1 / X1 ^ 2 - 6 / X0 ^ 4) * S1)
    (hL3 : L ≤ 1.5707963 - (1 / X1 - 2 / X0 ^ 3) * C1 - (1 / X0 ^ 2) * S1)
    (hL4 : L ≤ 1.5707963 - (1 / X1 - 2 / X0 ^ 3) * C1 - (1 / X1 ^ 2 - 6 / X0 ^ 4) * S1)
    (hU1 : 1.5707964 - (1 / X0) * C0 - (1 / X0 ^ 2) * S0 ≤ U)
    (hU2 : 1.5707964 - (1 / X0) * C0 - (1 / X1 ^ 2 - 6 / X0 ^ 4) * S0 ≤ U)
    (hU3 : 1.5707964 - (1 / X1 - 2 / X0 ^ 3) * C0 - (1 / X0 ^ 2) * S0 ≤ U)
    (hU4 : 1.5707964 - (1 / X1 - 2 / X0 ^ 3) * C0 - (1 / X1 ^ 2 - 6 / X0 ^ 4) * S0 ≤ U) :
    L ≤ Si x ∧ Si x ≤ U := by
  have hx : 0 < x := lt_of_lt_of_le hX0 hx0
  obtain ⟨⟨hf0, hf1⟩, ⟨hg0, hg1⟩⟩ := siAux_bracket hX0 hx0 hx1
  have hpi1 : (1.5707963:ℝ) ≤ π / 2 := by linarith [Real.pi_gt_d20]
  have hpi2 : π / 2 ≤ 1.5707964 := by linarith [Real.pi_lt_d20]
  have hexp := Si_eq_pi_div_two_sub hx
  constructor
  · -- upper bounds for the two products
    have p1 : siAuxCos x * Real.cos x ≤ max ((1 / X0) * C1) ((1 / X1 - 2 / X0 ^ 3) * C1) := by
      refine mul_le_of_bracket (p := 1 / X1 - 2 / X0 ^ 3) (P := 1 / X0) (Q := C1)
        hFnn hf0 hf1 hC1 (le_max_left _ _) (le_max_right _ _)
    have p2 : siAuxSin x * Real.sin x
        ≤ max ((1 / X0 ^ 2) * S1) ((1 / X1 ^ 2 - 6 / X0 ^ 4) * S1) := by
      refine mul_le_of_bracket (p := 1 / X1 ^ 2 - 6 / X0 ^ 4) (P := 1 / X0 ^ 2) (Q := S1)
        hGnn hg0 hg1 hS1 (le_max_left _ _) (le_max_right _ _)
    rw [hexp]
    rcases max_cases ((1 / X0) * C1) ((1 / X1 - 2 / X0 ^ 3) * C1) with ⟨e1, _⟩ | ⟨e1, _⟩ <;>
      rcases max_cases ((1 / X0 ^ 2) * S1) ((1 / X1 ^ 2 - 6 / X0 ^ 4) * S1) with ⟨e2, _⟩ | ⟨e2, _⟩ <;>
      rw [e1] at p1 <;> rw [e2] at p2 <;> linarith
  · have p1 : min ((1 / X0) * C0) ((1 / X1 - 2 / X0 ^ 3) * C0) ≤ siAuxCos x * Real.cos x := by
      refine mul_ge_of_bracket (p := 1 / X1 - 2 / X0 ^ 3) (P := 1 / X0)
        hFnn hf0 hf1 hC0 (min_le_left _ _) (min_le_right _ _)
    have p2 : min ((1 / X0 ^ 2) * S0) ((1 / X1 ^ 2 - 6 / X0 ^ 4) * S0)
        ≤ siAuxSin x * Real.sin x := by
      refine mul_ge_of_bracket (p := 1 / X1 ^ 2 - 6 / X0 ^ 4) (P := 1 / X0 ^ 2)
        hGnn hg0 hg1 hS0 (min_le_left _ _) (min_le_right _ _)
    rw [hexp]
    rcases min_cases ((1 / X0) * C0) ((1 / X1 - 2 / X0 ^ 3) * C0) with ⟨e1, _⟩ | ⟨e1, _⟩ <;>
      rcases min_cases ((1 / X0 ^ 2) * S0) ((1 / X1 ^ 2 - 6 / X0 ^ 4) * S0) with ⟨e2, _⟩ | ⟨e2, _⟩ <;>
      rw [e1] at p1 <;> rw [e2] at p2 <;> linarith

end ConnesConsani.WeilPositivity
