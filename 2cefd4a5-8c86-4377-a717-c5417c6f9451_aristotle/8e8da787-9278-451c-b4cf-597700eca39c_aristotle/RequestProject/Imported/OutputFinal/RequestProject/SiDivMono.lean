/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Monotonicity of the normalized sine integral `σ(x) = Si(x)/x` and the numerical brackets
for `Si` and `σ` used in `RequestProject/PolyaError.lean`.

The key new fact is

  `sin x ≤ Si x` for `x ≥ 0`   (`sin_le_Si`),

which says exactly that `σ' (x) = (sin x - Si x)/x² ≤ 0`, i.e. that `σ` is *antitone* on
`[0,∞)` (`siDiv_antitoneOn`).  Antitonicity is what turns a Taylor bracket for `σ` at a
*rational* point into a bracket valid on a whole interval, and this is what makes the
piecewise L¹ estimate of `RequestProject/PolyaError.lean` efficient.
-/
import RequestProject.Imported.OutputFinal.RequestProject.MidThreshold

noncomputable section

open MeasureTheory Set Real Filter Topology

namespace ConnesConsani.WeilPositivity

/-! ## `sin x ≤ Si x` and the antitonicity of `σ = Si x / x` -/

/-- **`sin x ≤ Si x` for `x ≥ 0`.**  For `x ≤ 4` this is a Taylor comparison
(`Si x - sin x ≥ x³/9 - x⁵/150 + …`), for `x ≥ 4` it follows from `Si x ≥ π/2 - 1/x - 1/x²`
together with `sin x ≤ 1`. -/
theorem sin_le_Si {x : ℝ} (hx : 0 ≤ x) : Real.sin x ≤ Si x := by
  rcases le_or_gt x 4 with h4 | h4
  · have hU := sin_le_sinPart (n := 5) (by norm_num) (by decide) hx
    have hL := siPart_le_Si (n := 6) (by norm_num) (by decide) hx
    simp only [sinPart, siPart, Finset.sum_range_succ, Finset.sum_range_zero] at hU hL
    norm_num [Nat.factorial] at hU hL
    have hy0 : (0:ℝ) ≤ x ^ 2 := sq_nonneg x
    have hy1 : x ^ 2 ≤ 16 := by nlinarith
    have hp : 0 ≤ 1/9 - x^2/150 + (x^2)^2/5880 - (x^2)^3/408240 - (x^2)^4/439084800 := by
      nlinarith [mul_nonneg hy0 (sub_nonneg.2 hy1),
        mul_nonneg (mul_nonneg hy0 hy0) (sub_nonneg.2 hy1),
        mul_nonneg (mul_nonneg (mul_nonneg hy0 hy0) hy0) (sub_nonneg.2 hy1)]
    nlinarith [mul_nonneg (pow_nonneg hx 3) hp]
  · have h1 : Real.sin x ≤ 1 := Real.sin_le_one x
    have hSi := Si_ge (by linarith : (0:ℝ) < x)
    have hpi : (3.14159:ℝ) < π := by linarith [Real.pi_gt_d6]
    have hx1 : 1 / x ≤ 1 / 4 := by
      apply one_div_le_one_div_of_le (by norm_num); linarith
    have hx2 : 1 / x ^ 2 ≤ 1 / 16 := by
      apply one_div_le_one_div_of_le (by norm_num); nlinarith
    linarith

/-- **`σ(x) = Si(x)/x` is antitone on `[0,∞)`.** -/
theorem siDiv_antitoneOn : AntitoneOn siDiv (Ici (0:ℝ)) := by
  have hcont : ContinuousOn siDiv (Ici (0:ℝ)) := (contDiff_siDiv 1).continuous.continuousOn
  refine antitoneOn_of_deriv_nonpos (convex_Ici 0) hcont ?_ ?_
  · intro x hx
    rw [interior_Ici] at hx
    exact ((siDiv_hasDerivAt (ne_of_gt hx)).differentiableAt).differentiableWithinAt
  · intro x hx
    rw [interior_Ici] at hx
    have hne : x ≠ 0 := ne_of_gt hx
    rw [(siDiv_hasDerivAt hne).deriv]
    have hs : Real.sinc x * x = Real.sin x := by
      rw [Real.sinc_of_ne_zero hne]; field_simp
    rw [hs]
    exact div_nonpos_of_nonpos_of_nonneg (by linarith [sin_le_Si hx.le]) (by positivity)

/-- The form of antitonicity used in the piecewise estimates: `σ(x) ≤ σ(X)` for `0 ≤ X ≤ x`. -/
theorem siDiv_le_siDiv_of_le {X x : ℝ} (hX : 0 ≤ X) (h : X ≤ x) : siDiv x ≤ siDiv X :=
  siDiv_antitoneOn hX (le_trans hX h) h

/-! ## Taylor brackets for `σ` at a point -/

/-- **The Taylor upper bound for `Si x / x`**: for odd `n` and `x ≥ 0`. -/
theorem siDiv_le_siDivPart {n : ℕ} (hn : 1 ≤ n) (hodd : Odd n) {x : ℝ} (hx : 0 ≤ x) :
    siDiv x ≤ siDivPart n x := by
  rcases eq_or_lt_of_le hx with h | h
  · subst_vars
    rw [siDivPart_zero hn]
    simp
  · have hSi := Si_le_siPart hn hodd (le_of_lt h)
    rw [siDiv_of_ne_zero (ne_of_gt h), ← siPart_div n (ne_of_gt h)]
    exact div_le_div_of_nonneg_right hSi h.le

/-- The degree-16 truncated Taylor series of `Si x / x`, ending on a positive term. -/
def taylorQup (x : ℝ) : ℝ := siDivPart 9 x

/-- `taylorQup` written out. -/
theorem taylorQup_eq (x : ℝ) :
    taylorQup x = 1 - x ^ 2 / 18 + x ^ 4 / 600 - x ^ 6 / 35280 + x ^ 8 / 3265920
      - x ^ 10 / 439084800 + x ^ 12 / 80951270400 - x ^ 14 / 19615115520000
      + x ^ 16 / 6046686277632000 := by
  simp only [taylorQup, siDivPart, Finset.sum_range_succ, Finset.sum_range_zero]
  norm_num [Nat.factorial]
  ring

/-- `Si x / x ≤ Qup(x)` for `x ≥ 0`. -/
theorem siDiv_le_taylorQup {x : ℝ} (hx : 0 ≤ x) : siDiv x ≤ taylorQup x :=
  siDiv_le_siDivPart (by norm_num) (by decide) hx

/-! ## Rational brackets for `Si` -/

/-- `Si x ≤ 1.5708 + 1/X + 1/X²` for `0 < X ≤ x`. -/
theorem Si_le_rat {X x : ℝ} (hX : 0 < X) (h : X ≤ x) : Si x ≤ 1.5708 + 1 / X + 1 / X ^ 2 := by
  have hx : 0 < x := lt_of_lt_of_le hX h
  have h1 : 1 / x ≤ 1 / X := one_div_le_one_div_of_le hX h
  have h2 : 1 / x ^ 2 ≤ 1 / X ^ 2 := by
    refine one_div_le_one_div_of_le (by positivity) ?_
    nlinarith
  have hpi : π < 3.1416 := by linarith [Real.pi_lt_d6]
  linarith [Si_le_of_pos hx]

/-- `Si x ≥ 1.5707 - 1/X - 1/X²` for `0 < X ≤ x`. -/
theorem Si_ge_rat {X x : ℝ} (hX : 0 < X) (h : X ≤ x) : 1.5707 - 1 / X - 1 / X ^ 2 ≤ Si x := by
  have hx : 0 < x := lt_of_lt_of_le hX h
  have h1 : 1 / x ≤ 1 / X := one_div_le_one_div_of_le hX h
  have h2 : 1 / x ^ 2 ≤ 1 / X ^ 2 := by
    refine one_div_le_one_div_of_le (by positivity) ?_
    nlinarith
  have hpi : (3.14159:ℝ) < π := by linarith [Real.pi_gt_d6]
  linarith [Si_ge hx]

end ConnesConsani.WeilPositivity
