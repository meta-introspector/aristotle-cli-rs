/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The *sharpened* pointwise brackets for the Pólya model error.

`RequestProject/PolyaError.lean` brackets

  `Φ(v) = e^{v/2}(δ(e^v) - h(v)) = 2r σ(a) + 2r σ(b) - 1 - 2.11 q^{-5}`,
  `σ(x) = Si(x)/x`,  `r = q² = e^v`,  `a = 2π(1+r)`,  `b = 2π(r-1)`,

on a `q`-interval by means of `|Si x - π/2| ≤ 1/x + 1/x²`.  At `r = 1` that costs
`± 0.086` in `Si`, i.e. a bracket for `Φ` of width `≈ 0.03`; the width is what limits the
oscillatory estimate of `RequestProject/PolyaOscBase.lean`.

Here `Si` is instead bracketed by the sharpened expansion of `RequestProject/SiSharp.lean`,

  `Si x = π/2 - f(x) cos x - g(x) sin x`,  `1/x - 2/x³ ≤ f ≤ 1/x`, `1/x² - 6/x⁴ ≤ g ≤ 1/x²`,

which requires brackets for `cos x` and `sin x`.  Since `a` and `b` differ from `2πr` by
`± 2π`, both are governed by `cos (2πr)` and `sin (2πr)`, and those are obtained from the
Taylor minorants/majorants of `RequestProject/PolyaOscBase.lean` after reducing `r` modulo
`1/4` (`trigBracket0`–`trigBracket3`).  The resulting brackets for `Φ` are 4–10 times
narrower than the old ones.
-/
import RequestProject.Imported.OutputFinal.RequestProject.SiSharp

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real Filter Topology

namespace ConnesConsani.WeilPositivity

/-! ## 1. Brackets for `cos (2πr)` and `sin (2πr)` -/

/-- Brackets for `cos` and `sin` of an angle known to lie in `[0, π/2]`. -/
theorem trig_core {y ylo yhi : ℝ} (h0 : 0 ≤ ylo) (h1 : ylo ≤ y) (h2 : y ≤ yhi)
    (h3 : yhi ≤ π / 2) :
    cosLoP yhi ≤ Real.cos y ∧ Real.cos y ≤ cosHiP ylo ∧
      sinLoP ylo ≤ Real.sin y ∧ Real.sin y ≤ sinHiP yhi := by
  have hy0 : 0 ≤ y := le_trans h0 h1
  have hyhi : y ≤ π / 2 := le_trans h2 h3
  exact ⟨le_trans (cosLoP_le_cos (le_trans hy0 h2)) (cos_le_cos_of_le hy0 h2 h3),
    le_trans (cos_le_cos_of_le h0 h1 hyhi) (cos_le_cosHiP h0),
    le_trans (sinLoP_le_sin h0) (sin_le_sin_of_le h0 h1 hyhi),
    le_trans (sin_le_sin_of_le hy0 h2 h3) (sin_le_sinHiP (le_trans hy0 h2))⟩

/-- Rational bracket for `2πu`, `u ≥ 0`. -/
theorem twoPi_bracket {u u0 u1 : ℝ} (hu0 : 0 ≤ u0) (h0 : u0 ≤ u) (h1 : u ≤ u1) :
    6.2831853 * u0 ≤ 2 * π * u ∧ 2 * π * u ≤ 6.28318531 * u1 := by
  have hpl : (6.2831853:ℝ) < 2 * π := by linarith [Real.pi_gt_d20]
  have hph : 2 * π < 6.28318531 := by linarith [Real.pi_lt_d20]
  have hu : 0 ≤ u := le_trans hu0 h0
  exact ⟨by nlinarith, by nlinarith⟩

/-- **Quadrant 0**: `r - j ∈ [u0,u1] ⊆ [0,1/4]`. -/
theorem trigBracket0 {r u0 u1 C0 C1 S0 S1 : ℝ} {j : ℤ}
    (hu0 : 0 ≤ u0) (hu1 : 6.28318531 * u1 ≤ 1.5707963)
    (h0 : u0 ≤ r - j) (h1 : r - j ≤ u1)
    (hC0 : C0 ≤ cosLoP (6.28318531 * u1)) (hC1 : cosHiP (6.2831853 * u0) ≤ C1)
    (hS0 : S0 ≤ sinLoP (6.2831853 * u0)) (hS1 : sinHiP (6.28318531 * u1) ≤ S1) :
    C0 ≤ Real.cos (2 * π * r) ∧ Real.cos (2 * π * r) ≤ C1 ∧
      S0 ≤ Real.sin (2 * π * r) ∧ Real.sin (2 * π * r) ≤ S1 := by
  have hpi : (1.5707963:ℝ) ≤ π / 2 := by linarith [Real.pi_gt_d20]
  obtain ⟨hy0, hy1⟩ := twoPi_bracket hu0 h0 h1
  obtain ⟨a1, a2, a3, a4⟩ := trig_core (mul_nonneg (by norm_num) hu0) hy0 hy1 (by linarith)
  have hcos : Real.cos (2 * π * r) = Real.cos (2 * π * (r - j)) := by
    rw [show 2 * π * r = 2 * π * (r - j) + (j : ℝ) * (2 * π) by ring, Real.cos_add_int_mul_two_pi]
  have hsin : Real.sin (2 * π * r) = Real.sin (2 * π * (r - j)) := by
    rw [show 2 * π * r = 2 * π * (r - j) + (j : ℝ) * (2 * π) by ring, Real.sin_add_int_mul_two_pi]
  rw [hcos, hsin]
  exact ⟨le_trans hC0 a1, le_trans a2 hC1, le_trans hS0 a3, le_trans a4 hS1⟩

/-- **Quadrant 1**: `r - j - 1/4 ∈ [u0,u1] ⊆ [0,1/4]`. -/
theorem trigBracket1 {r u0 u1 C0 C1 S0 S1 : ℝ} {j : ℤ}
    (hu0 : 0 ≤ u0) (hu1 : 6.28318531 * u1 ≤ 1.5707963)
    (h0 : u0 ≤ r - j - 0.25) (h1 : r - j - 0.25 ≤ u1)
    (hC0 : C0 ≤ -sinHiP (6.28318531 * u1)) (hC1 : -sinLoP (6.2831853 * u0) ≤ C1)
    (hS0 : S0 ≤ cosLoP (6.28318531 * u1)) (hS1 : cosHiP (6.2831853 * u0) ≤ S1) :
    C0 ≤ Real.cos (2 * π * r) ∧ Real.cos (2 * π * r) ≤ C1 ∧
      S0 ≤ Real.sin (2 * π * r) ∧ Real.sin (2 * π * r) ≤ S1 := by
  have hpi : (1.5707963:ℝ) ≤ π / 2 := by linarith [Real.pi_gt_d20]
  obtain ⟨hy0, hy1⟩ := twoPi_bracket hu0 h0 h1
  obtain ⟨a1, a2, a3, a4⟩ := trig_core (mul_nonneg (by norm_num) hu0) hy0 hy1 (by linarith)
  have hcos : Real.cos (2 * π * r) = -Real.sin (2 * π * (r - j - 0.25)) := by
    rw [show 2 * π * r = (2 * π * (r - j - 0.25) + π / 2) + (j : ℝ) * (2 * π) by ring,
      Real.cos_add_int_mul_two_pi, Real.cos_add_pi_div_two]
  have hsin : Real.sin (2 * π * r) = Real.cos (2 * π * (r - j - 0.25)) := by
    rw [show 2 * π * r = (2 * π * (r - j - 0.25) + π / 2) + (j : ℝ) * (2 * π) by ring,
      Real.sin_add_int_mul_two_pi, Real.sin_add_pi_div_two]
  rw [hcos, hsin]
  exact ⟨by linarith, by linarith, le_trans hS0 a1, le_trans a2 hS1⟩

/-- **Quadrant 2**: `r - j - 1/2 ∈ [u0,u1] ⊆ [0,1/4]`. -/
theorem trigBracket2 {r u0 u1 C0 C1 S0 S1 : ℝ} {j : ℤ}
    (hu0 : 0 ≤ u0) (hu1 : 6.28318531 * u1 ≤ 1.5707963)
    (h0 : u0 ≤ r - j - 0.5) (h1 : r - j - 0.5 ≤ u1)
    (hC0 : C0 ≤ -cosHiP (6.2831853 * u0)) (hC1 : -cosLoP (6.28318531 * u1) ≤ C1)
    (hS0 : S0 ≤ -sinHiP (6.28318531 * u1)) (hS1 : -sinLoP (6.2831853 * u0) ≤ S1) :
    C0 ≤ Real.cos (2 * π * r) ∧ Real.cos (2 * π * r) ≤ C1 ∧
      S0 ≤ Real.sin (2 * π * r) ∧ Real.sin (2 * π * r) ≤ S1 := by
  have hpi : (1.5707963:ℝ) ≤ π / 2 := by linarith [Real.pi_gt_d20]
  obtain ⟨hy0, hy1⟩ := twoPi_bracket hu0 h0 h1
  obtain ⟨a1, a2, a3, a4⟩ := trig_core (mul_nonneg (by norm_num) hu0) hy0 hy1 (by linarith)
  have hcos : Real.cos (2 * π * r) = -Real.cos (2 * π * (r - j - 0.5)) := by
    rw [show 2 * π * r = (2 * π * (r - j - 0.5) + π) + (j : ℝ) * (2 * π) by ring,
      Real.cos_add_int_mul_two_pi, Real.cos_add_pi]
  have hsin : Real.sin (2 * π * r) = -Real.sin (2 * π * (r - j - 0.5)) := by
    rw [show 2 * π * r = (2 * π * (r - j - 0.5) + π) + (j : ℝ) * (2 * π) by ring,
      Real.sin_add_int_mul_two_pi, Real.sin_add_pi]
  rw [hcos, hsin]
  exact ⟨by linarith, by linarith, by linarith, by linarith⟩

/-- **Quadrant 3**: `r - j - 3/4 ∈ [u0,u1] ⊆ [0,1/4]`. -/
theorem trigBracket3 {r u0 u1 C0 C1 S0 S1 : ℝ} {j : ℤ}
    (hu0 : 0 ≤ u0) (hu1 : 6.28318531 * u1 ≤ 1.5707963)
    (h0 : u0 ≤ r - j - 0.75) (h1 : r - j - 0.75 ≤ u1)
    (hC0 : C0 ≤ sinLoP (6.2831853 * u0)) (hC1 : sinHiP (6.28318531 * u1) ≤ C1)
    (hS0 : S0 ≤ -cosHiP (6.2831853 * u0)) (hS1 : -cosLoP (6.28318531 * u1) ≤ S1) :
    C0 ≤ Real.cos (2 * π * r) ∧ Real.cos (2 * π * r) ≤ C1 ∧
      S0 ≤ Real.sin (2 * π * r) ∧ Real.sin (2 * π * r) ≤ S1 := by
  have hpi : (1.5707963:ℝ) ≤ π / 2 := by linarith [Real.pi_gt_d20]
  obtain ⟨hy0, hy1⟩ := twoPi_bracket hu0 h0 h1
  obtain ⟨a1, a2, a3, a4⟩ := trig_core (mul_nonneg (by norm_num) hu0) hy0 hy1 (by linarith)
  have hcos : Real.cos (2 * π * r) = Real.sin (2 * π * (r - j - 0.75)) := by
    rw [show 2 * π * r = (2 * π * (r - j - 0.75) - π / 2) + ((j : ℝ) + 1) * (2 * π) by ring,
      show ((j:ℝ) + 1) = (((j + 1 : ℤ)) : ℝ) by push_cast; ring,
      Real.cos_add_int_mul_two_pi, Real.cos_sub_pi_div_two]
  have hsin : Real.sin (2 * π * r) = -Real.cos (2 * π * (r - j - 0.75)) := by
    rw [show 2 * π * r = (2 * π * (r - j - 0.75) - π / 2) + ((j : ℝ) + 1) * (2 * π) by ring,
      show ((j:ℝ) + 1) = (((j + 1 : ℤ)) : ℝ) by push_cast; ring,
      Real.sin_add_int_mul_two_pi, Real.sin_sub_pi_div_two]
  rw [hcos, hsin]
  exact ⟨le_trans hC0 a3, le_trans a4 hC1, by linarith, by linarith⟩

/-! ## 2. The sharpened bracket for `Si` in closed rational form -/

/-- Rational minorant for `Si x` when `x ∈ [X0,X1]`, `cos x ≤ C1`, `sin x ≤ S1`. -/
def siLoSharp (X0 X1 C1 S1 : ℝ) : ℝ :=
  1.5707963 - max ((1 / X0) * C1) ((1 / X1 - 2 / X0 ^ 3) * C1)
    - max ((1 / X0 ^ 2) * S1) ((1 / X1 ^ 2 - 6 / X0 ^ 4) * S1)

/-- Rational majorant for `Si x` when `x ∈ [X0,X1]`, `C0 ≤ cos x`, `S0 ≤ sin x`. -/
def siHiSharp (X0 X1 C0 S0 : ℝ) : ℝ :=
  1.5707964 - min ((1 / X0) * C0) ((1 / X1 - 2 / X0 ^ 3) * C0)
    - min ((1 / X0 ^ 2) * S0) ((1 / X1 ^ 2 - 6 / X0 ^ 4) * S0)

theorem siSharp_bracket {x X0 X1 C0 C1 S0 S1 : ℝ}
    (hX0 : 0 < X0) (hx0 : X0 ≤ x) (hx1 : x ≤ X1)
    (hFnn : 0 ≤ 1 / X1 - 2 / X0 ^ 3) (hGnn : 0 ≤ 1 / X1 ^ 2 - 6 / X0 ^ 4)
    (hC0 : C0 ≤ Real.cos x) (hC1 : Real.cos x ≤ C1)
    (hS0 : S0 ≤ Real.sin x) (hS1 : Real.sin x ≤ S1) :
    siLoSharp X0 X1 C1 S1 ≤ Si x ∧ Si x ≤ siHiSharp X0 X1 C0 S0 := by
  have m1 := le_max_left ((1 / X0) * C1) ((1 / X1 - 2 / X0 ^ 3) * C1)
  have m2 := le_max_right ((1 / X0) * C1) ((1 / X1 - 2 / X0 ^ 3) * C1)
  have m3 := le_max_left ((1 / X0 ^ 2) * S1) ((1 / X1 ^ 2 - 6 / X0 ^ 4) * S1)
  have m4 := le_max_right ((1 / X0 ^ 2) * S1) ((1 / X1 ^ 2 - 6 / X0 ^ 4) * S1)
  have n1 := min_le_left ((1 / X0) * C0) ((1 / X1 - 2 / X0 ^ 3) * C0)
  have n2 := min_le_right ((1 / X0) * C0) ((1 / X1 - 2 / X0 ^ 3) * C0)
  have n3 := min_le_left ((1 / X0 ^ 2) * S0) ((1 / X1 ^ 2 - 6 / X0 ^ 4) * S0)
  have n4 := min_le_right ((1 / X0 ^ 2) * S0) ((1 / X1 ^ 2 - 6 / X0 ^ 4) * S0)
  refine Si_sharp_bracket hX0 hx0 hx1 hFnn hGnn hC0 hC1 hS0 hS1 ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    simp only [siLoSharp, siHiSharp] <;> linarith

/-! ## 3. The two terms of `Φ` -/

/-- Sharpened bracket for the `a`-term `2 e^v σ(2π(1+e^v))`. -/
theorem term_a_sharp {v r0 r1 SiLo SiHi Alo Ahi : ℝ} (h0 : 1 ≤ r0) (hr0 : r0 ≤ Real.exp v)
    (hr1 : Real.exp v ≤ r1)
    (hSi0 : SiLo ≤ Si (uPlus v)) (hSi1 : Si (uPlus v) ≤ SiHi) (hSinn : 0 ≤ SiLo)
    (hA0 : Alo ≤ (r0 / (3.14159266 * (1 + r0))) * SiLo)
    (hA1 : (r1 / (3.14159265 * (1 + r1))) * SiHi ≤ Ahi) :
    Alo ≤ 2 * Real.exp v * siDiv (uPlus v) ∧ 2 * Real.exp v * siDiv (uPlus v) ≤ Ahi := by
  have hpi1 : (3.14159265:ℝ) < π := by linarith [Real.pi_gt_d20]
  have hpi2 : π < 3.14159266 := by linarith [Real.pi_lt_d20]
  set r := Real.exp v with hrdef
  have hr : 1 ≤ r := le_trans h0 hr0
  have hr1' : 1 ≤ r1 := le_trans hr hr1
  set a : ℝ := 2 * π * (1 + r) with ha
  have hapos : (0:ℝ) < a := by rw [ha]; nlinarith [Real.pi_pos]
  have heq : 2 * r * siDiv (uPlus v) = (2 * r / a) * Si a := by
    rw [show uPlus v = a from rfl, siDiv_of_ne_zero (ne_of_gt hapos)]
    field_simp
  have hfac0 : r0 / (3.14159266 * (1 + r0)) ≤ 2 * r / a := by
    rw [ha, div_le_div_iff₀ (by positivity) (by positivity)]
    nlinarith [hr0, Real.pi_pos, mul_nonneg (sub_nonneg.2 hpi2.le) (mul_nonneg (by linarith : (0:ℝ) ≤ r) (by linarith : (0:ℝ) ≤ 1 + r0))]
  have hfac1 : 2 * r / a ≤ r1 / (3.14159265 * (1 + r1)) := by
    rw [ha, div_le_div_iff₀ (by positivity) (by positivity)]
    nlinarith [hr1, Real.pi_pos, mul_nonneg (sub_nonneg.2 hpi1.le) (mul_nonneg (by linarith : (0:ℝ) ≤ r1) (by linarith : (0:ℝ) ≤ 1 + r))]
  have hSinn' : 0 ≤ Si a := le_trans hSinn hSi0
  have hfacnn : 0 ≤ r0 / (3.14159266 * (1 + r0)) := by positivity
  constructor
  · calc Alo ≤ (r0 / (3.14159266 * (1 + r0))) * SiLo := hA0
      _ ≤ (2 * r / a) * Si a := mul_le_mul hfac0 hSi0 hSinn (le_trans hfacnn hfac0)
      _ = 2 * r * siDiv (uPlus v) := heq.symm
  · calc 2 * Real.exp v * siDiv (uPlus v) = (2 * r / a) * Si a := heq
      _ ≤ (r1 / (3.14159265 * (1 + r1))) * SiHi :=
          mul_le_mul hfac1 hSi1 hSinn' (div_nonneg (by linarith) (by nlinarith))
      _ ≤ Ahi := hA1

/-- Sharpened bracket for the `b`-term `2 e^v σ(2π(e^v-1))`, asymptotic branch. -/
theorem term_b_sharp {v r0 r1 SiLo SiHi Blo Bhi : ℝ} (h0 : 1 < r0) (hr0 : r0 ≤ Real.exp v)
    (hr1 : Real.exp v ≤ r1)
    (hSi0 : SiLo ≤ Si (uMinus v)) (hSi1 : Si (uMinus v) ≤ SiHi) (hSinn : 0 ≤ SiLo)
    (hB0 : Blo ≤ (r1 / (3.14159266 * (r1 - 1))) * SiLo)
    (hB1 : (r0 / (3.14159265 * (r0 - 1))) * SiHi ≤ Bhi) :
    Blo ≤ 2 * Real.exp v * siDiv (uMinus v) ∧ 2 * Real.exp v * siDiv (uMinus v) ≤ Bhi := by
  have hpi1 : (3.14159265:ℝ) < π := by linarith [Real.pi_gt_d20]
  have hpi2 : π < 3.14159266 := by linarith [Real.pi_lt_d20]
  set r := Real.exp v with hrdef
  have hr : 1 < r := lt_of_lt_of_le h0 hr0
  have hr1' : 1 < r1 := lt_of_lt_of_le hr hr1
  set b : ℝ := 2 * π * (r - 1) with hb
  have hbpos : (0:ℝ) < b := by rw [hb]; nlinarith [Real.pi_pos]
  have heq : 2 * r * siDiv (uMinus v) = (2 * r / b) * Si b := by
    rw [show uMinus v = b from rfl, siDiv_of_ne_zero (ne_of_gt hbpos)]
    field_simp
  have hfac0 : r1 / (3.14159266 * (r1 - 1)) ≤ 2 * r / b := by
    rw [hb, div_le_div_iff₀ (by nlinarith) (by nlinarith [Real.pi_pos])]
    nlinarith [hr1, Real.pi_pos, mul_nonneg (sub_nonneg.2 hpi2.le)
      (mul_nonneg (by linarith : (0:ℝ) ≤ r) (by linarith : (0:ℝ) ≤ r1 - 1))]
  have hfac1 : 2 * r / b ≤ r0 / (3.14159265 * (r0 - 1)) := by
    rw [hb, div_le_div_iff₀ (by nlinarith [Real.pi_pos]) (by nlinarith)]
    nlinarith [hr0, Real.pi_pos, mul_nonneg (sub_nonneg.2 hpi1.le)
      (mul_nonneg (by linarith : (0:ℝ) ≤ r0) (by linarith : (0:ℝ) ≤ r - 1))]
  have hSinn' : 0 ≤ Si b := le_trans hSinn hSi0
  have hfacnn : 0 ≤ r1 / (3.14159266 * (r1 - 1)) :=
    div_nonneg (by linarith) (by nlinarith)
  constructor
  · calc Blo ≤ (r1 / (3.14159266 * (r1 - 1))) * SiLo := hB0
      _ ≤ (2 * r / b) * Si b := mul_le_mul hfac0 hSi0 hSinn (le_trans hfacnn hfac0)
      _ = 2 * r * siDiv (uMinus v) := heq.symm
  · calc 2 * Real.exp v * siDiv (uMinus v) = (2 * r / b) * Si b := heq
      _ ≤ (r0 / (3.14159265 * (r0 - 1))) * SiHi :=
          mul_le_mul hfac1 hSi1 hSinn' (div_nonneg (by linarith) (by nlinarith))
      _ ≤ Bhi := hB1

/-! ## 4. The sharpened piece brackets -/

/-- Rational minorant for the `a`-term on the piece `[q0,q1]`. -/
def aLoSharp (q0 q1 C1 S1 : ℝ) : ℝ :=
  (q0 ^ 2 / (3.14159266 * (1 + q0 ^ 2)))
    * siLoSharp (6.2831853 * (1 + q0 ^ 2)) (6.28318531 * (1 + q1 ^ 2)) C1 S1

/-- Rational majorant for the `a`-term on the piece `[q0,q1]`. -/
def aHiSharp (q0 q1 C0 S0 : ℝ) : ℝ :=
  (q1 ^ 2 / (3.14159265 * (1 + q1 ^ 2)))
    * siHiSharp (6.2831853 * (1 + q0 ^ 2)) (6.28318531 * (1 + q1 ^ 2)) C0 S0

/-- Rational minorant for the `b`-term on the piece `[q0,q1]` (asymptotic branch). -/
def bLoSharp (q0 q1 C1 S1 : ℝ) : ℝ :=
  (q1 ^ 2 / (3.14159266 * (q1 ^ 2 - 1)))
    * siLoSharp (6.2831853 * (q0 ^ 2 - 1)) (6.28318531 * (q1 ^ 2 - 1)) C1 S1

/-- Rational majorant for the `b`-term on the piece `[q0,q1]` (asymptotic branch). -/
def bHiSharp (q0 q1 C0 S0 : ℝ) : ℝ :=
  (q0 ^ 2 / (3.14159265 * (q0 ^ 2 - 1)))
    * siHiSharp (6.2831853 * (q0 ^ 2 - 1)) (6.28318531 * (q1 ^ 2 - 1)) C0 S0

/-- **The sharpened signed bracket on a piece, Taylor branch for the `b`-term.** -/
theorem errPiece_sharp_taylor {q0 q1 C0 C1 S0 S1 Lo Hi : ℝ} (h1 : 1 ≤ q0) (h01 : q0 ≤ q1)
    (htrig : ∀ r : ℝ, q0 ^ 2 ≤ r → r ≤ q1 ^ 2 →
      C0 ≤ Real.cos (2 * π * r) ∧ Real.cos (2 * π * r) ≤ C1 ∧
        S0 ≤ Real.sin (2 * π * r) ∧ Real.sin (2 * π * r) ≤ S1)
    (hFnn : 0 ≤ 1 / (6.28318531 * (1 + q1 ^ 2)) - 2 / (6.2831853 * (1 + q0 ^ 2)) ^ 3)
    (hGnn : 0 ≤ 1 / (6.28318531 * (1 + q1 ^ 2)) ^ 2 - 6 / (6.2831853 * (1 + q0 ^ 2)) ^ 4)
    (hSinn : 0 ≤ siLoSharp (6.2831853 * (1 + q0 ^ 2)) (6.28318531 * (1 + q1 ^ 2)) C1 S1)
    (hLo : Lo ≤ aLoSharp q0 q1 C1 S1 + 2 * q0 ^ 2 * taylorQ (6.2832 * (q1 ^ 2 - 1))
      - 1 - 2.11 / q0 ^ 5)
    (hHi : aHiSharp q0 q1 C0 S0 + 2 * q1 ^ 2 * taylorQup (6.28318 * (q0 ^ 2 - 1))
      - 1 - 2.11 / q1 ^ 5 ≤ Hi) :
    ∀ v ∈ Icc (vBP q0) (vBP q1),
      Lo * Real.exp (-(v / 2)) ≤ errFun v ∧ errFun v ≤ Hi * Real.exp (-(v / 2)) := by
  intro v hv
  obtain ⟨he0, he1, hE0, hE1⟩ := exp_bounds_of_mem_Icc h1 h01 hv
  have hr0 : (1:ℝ) ≤ q0 ^ 2 := by nlinarith
  obtain ⟨hc0, hc1, hs0, hs1⟩ := htrig (Real.exp v) he0 he1
  -- the `a`-term
  have hcosa : Real.cos (uPlus v) = Real.cos (2 * π * Real.exp v) := by
    rw [show uPlus v = 2 * π * Real.exp v + 2 * π by rw [uPlus]; ring, Real.cos_add_two_pi]
  have hsina : Real.sin (uPlus v) = Real.sin (2 * π * Real.exp v) := by
    rw [show uPlus v = 2 * π * Real.exp v + 2 * π by rw [uPlus]; ring, Real.sin_add_two_pi]
  have hXa0 : 6.2831853 * (1 + q0 ^ 2) ≤ uPlus v := by
    rw [uPlus]; nlinarith [Real.pi_gt_d20, Real.exp_pos v]
  have hXa1 : uPlus v ≤ 6.28318531 * (1 + q1 ^ 2) := by
    rw [uPlus]; nlinarith [Real.pi_lt_d20, Real.exp_pos v]
  have hSiA := siSharp_bracket (x := uPlus v) (X0 := 6.2831853 * (1 + q0 ^ 2))
    (X1 := 6.28318531 * (1 + q1 ^ 2)) (C0 := C0) (C1 := C1) (S0 := S0) (S1 := S1)
    (by positivity) hXa0 hXa1 hFnn hGnn
    (by rw [hcosa]; exact hc0) (by rw [hcosa]; exact hc1)
    (by rw [hsina]; exact hs0) (by rw [hsina]; exact hs1)
  have hA := term_a_sharp (r0 := q0 ^ 2) (r1 := q1 ^ 2)
    (Alo := aLoSharp q0 q1 C1 S1) (Ahi := aHiSharp q0 q1 C0 S0)
    hr0 he0 he1 hSiA.1 hSiA.2 hSinn (by rw [aLoSharp]) (by rw [aHiSharp])
  -- the `b`-term
  have hB0 := term_b_ge_taylor hr0 he0 he1
  have hB1 := term_b_le_taylor hr0 he0 he1
  refine errFun_bracket_of_PhiErr ?_ ?_
  · have hsplit : 2 * Real.exp v * (siDiv (uPlus v) + siDiv (uMinus v))
        = 2 * Real.exp v * siDiv (uPlus v) + 2 * Real.exp v * siDiv (uMinus v) := by ring
    have hd0 : (2.11:ℝ) / q0 ^ 5 = 2.11 * (1 / q0 ^ 5) := by ring
    rw [hd0] at hLo
    rw [PhiErr, hsplit]
    linarith [hA.1, hB0]
  · have hsplit : 2 * Real.exp v * (siDiv (uPlus v) + siDiv (uMinus v))
        = 2 * Real.exp v * siDiv (uPlus v) + 2 * Real.exp v * siDiv (uMinus v) := by ring
    have hd1 : (2.11:ℝ) / q1 ^ 5 = 2.11 * (1 / q1 ^ 5) := by ring
    rw [hd1] at hHi
    rw [PhiErr, hsplit]
    linarith [hA.2, hB1]

/-- **The sharpened signed bracket on a piece, asymptotic branch for the `b`-term.** -/
theorem errPiece_sharp_asymp {q0 q1 C0 C1 S0 S1 Lo Hi : ℝ} (h1 : 1 < q0) (h01 : q0 ≤ q1)
    (htrig : ∀ r : ℝ, q0 ^ 2 ≤ r → r ≤ q1 ^ 2 →
      C0 ≤ Real.cos (2 * π * r) ∧ Real.cos (2 * π * r) ≤ C1 ∧
        S0 ≤ Real.sin (2 * π * r) ∧ Real.sin (2 * π * r) ≤ S1)
    (hFnnA : 0 ≤ 1 / (6.28318531 * (1 + q1 ^ 2)) - 2 / (6.2831853 * (1 + q0 ^ 2)) ^ 3)
    (hGnnA : 0 ≤ 1 / (6.28318531 * (1 + q1 ^ 2)) ^ 2 - 6 / (6.2831853 * (1 + q0 ^ 2)) ^ 4)
    (hSinnA : 0 ≤ siLoSharp (6.2831853 * (1 + q0 ^ 2)) (6.28318531 * (1 + q1 ^ 2)) C1 S1)
    (hFnnB : 0 ≤ 1 / (6.28318531 * (q1 ^ 2 - 1)) - 2 / (6.2831853 * (q0 ^ 2 - 1)) ^ 3)
    (hGnnB : 0 ≤ 1 / (6.28318531 * (q1 ^ 2 - 1)) ^ 2 - 6 / (6.2831853 * (q0 ^ 2 - 1)) ^ 4)
    (hSinnB : 0 ≤ siLoSharp (6.2831853 * (q0 ^ 2 - 1)) (6.28318531 * (q1 ^ 2 - 1)) C1 S1)
    (hLo : Lo ≤ aLoSharp q0 q1 C1 S1 + bLoSharp q0 q1 C1 S1 - 1 - 2.11 / q0 ^ 5)
    (hHi : aHiSharp q0 q1 C0 S0 + bHiSharp q0 q1 C0 S0 - 1 - 2.11 / q1 ^ 5 ≤ Hi) :
    ∀ v ∈ Icc (vBP q0) (vBP q1),
      Lo * Real.exp (-(v / 2)) ≤ errFun v ∧ errFun v ≤ Hi * Real.exp (-(v / 2)) := by
  intro v hv
  obtain ⟨he0, he1, hE0, hE1⟩ := exp_bounds_of_mem_Icc h1.le h01 hv
  have hr0 : (1:ℝ) < q0 ^ 2 := by nlinarith
  obtain ⟨hc0, hc1, hs0, hs1⟩ := htrig (Real.exp v) he0 he1
  -- the `a`-term
  have hcosa : Real.cos (uPlus v) = Real.cos (2 * π * Real.exp v) := by
    rw [show uPlus v = 2 * π * Real.exp v + 2 * π by rw [uPlus]; ring, Real.cos_add_two_pi]
  have hsina : Real.sin (uPlus v) = Real.sin (2 * π * Real.exp v) := by
    rw [show uPlus v = 2 * π * Real.exp v + 2 * π by rw [uPlus]; ring, Real.sin_add_two_pi]
  have hXa0 : 6.2831853 * (1 + q0 ^ 2) ≤ uPlus v := by
    rw [uPlus]; nlinarith [Real.pi_gt_d20, Real.exp_pos v]
  have hXa1 : uPlus v ≤ 6.28318531 * (1 + q1 ^ 2) := by
    rw [uPlus]; nlinarith [Real.pi_lt_d20, Real.exp_pos v]
  have hSiA := siSharp_bracket (x := uPlus v) (X0 := 6.2831853 * (1 + q0 ^ 2))
    (X1 := 6.28318531 * (1 + q1 ^ 2)) (C0 := C0) (C1 := C1) (S0 := S0) (S1 := S1)
    (by positivity) hXa0 hXa1 hFnnA hGnnA
    (by rw [hcosa]; exact hc0) (by rw [hcosa]; exact hc1)
    (by rw [hsina]; exact hs0) (by rw [hsina]; exact hs1)
  have hA := term_a_sharp (r0 := q0 ^ 2) (r1 := q1 ^ 2)
    (Alo := aLoSharp q0 q1 C1 S1) (Ahi := aHiSharp q0 q1 C0 S0)
    hr0.le he0 he1 hSiA.1 hSiA.2 hSinnA (by rw [aLoSharp]) (by rw [aHiSharp])
  -- the `b`-term
  have hcosb : Real.cos (uMinus v) = Real.cos (2 * π * Real.exp v) := by
    rw [show uMinus v = 2 * π * Real.exp v - 2 * π by rw [uMinus]; ring, Real.cos_sub_two_pi]
  have hsinb : Real.sin (uMinus v) = Real.sin (2 * π * Real.exp v) := by
    rw [show uMinus v = 2 * π * Real.exp v - 2 * π by rw [uMinus]; ring, Real.sin_sub_two_pi]
  have hXb0 : 6.2831853 * (q0 ^ 2 - 1) ≤ uMinus v := by
    rw [uMinus]; nlinarith [Real.pi_gt_d20, Real.exp_pos v]
  have hXb1 : uMinus v ≤ 6.28318531 * (q1 ^ 2 - 1) := by
    rw [uMinus]; nlinarith [Real.pi_lt_d20, Real.exp_pos v]
  have hSiB := siSharp_bracket (x := uMinus v) (X0 := 6.2831853 * (q0 ^ 2 - 1))
    (X1 := 6.28318531 * (q1 ^ 2 - 1)) (C0 := C0) (C1 := C1) (S0 := S0) (S1 := S1)
    (by nlinarith) hXb0 hXb1 hFnnB hGnnB
    (by rw [hcosb]; exact hc0) (by rw [hcosb]; exact hc1)
    (by rw [hsinb]; exact hs0) (by rw [hsinb]; exact hs1)
  have hB := term_b_sharp (r0 := q0 ^ 2) (r1 := q1 ^ 2)
    (Blo := bLoSharp q0 q1 C1 S1) (Bhi := bHiSharp q0 q1 C0 S0)
    hr0 he0 he1 hSiB.1 hSiB.2 hSinnB (by rw [bLoSharp]) (by rw [bHiSharp])
  refine errFun_bracket_of_PhiErr ?_ ?_
  · have hsplit : 2 * Real.exp v * (siDiv (uPlus v) + siDiv (uMinus v))
        = 2 * Real.exp v * siDiv (uPlus v) + 2 * Real.exp v * siDiv (uMinus v) := by ring
    have hd0 : (2.11:ℝ) / q0 ^ 5 = 2.11 * (1 / q0 ^ 5) := by ring
    rw [hd0] at hLo
    rw [PhiErr, hsplit]
    linarith [hA.1, hB.1]
  · have hsplit : 2 * Real.exp v * (siDiv (uPlus v) + siDiv (uMinus v))
        = 2 * Real.exp v * siDiv (uPlus v) + 2 * Real.exp v * siDiv (uMinus v) := by ring
    have hd1 : (2.11:ℝ) / q1 ^ 5 = 2.11 * (1 / q1 ^ 5) := by ring
    rw [hd1] at hHi
    rw [PhiErr, hsplit]
    linarith [hA.2, hB.2]

end ConnesConsani.WeilPositivity
