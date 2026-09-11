/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Infrastructure for the *linear phase correction* refinement of the oscillatory block
estimate of `RequestProject/PolyaOscBase.lean`.

On a block `[a,b]` the estimate of `errCos_block_ge` replaces `cos(tv)` by a constant `C`
and pays `h · ∫|err|` with `h` of the order of half the phase width `t(b-a)`.  That forces
blocks whose phase width is `≤ 0.1`, i.e. some 70–200 blocks per band.

Here the first-order term is retained.  With `m` an interior point of the block,

  `cos(tv) = cos(tm) cos(t(v-m)) - sin(tm) sin(t(v-m))`,
  `cos g = 1 + O(g²/2)`,  `sin g = g + O(|g|³/6)`,

so that

  `∫ₐᵇ err(v) cos(tv) dv ≥ cos(tm)·P - (t sin(tm))·R - (t₁²/2) d² S - (t₁³/6) d³ S`,

where `P = ∫ₐᵇ err`, `R = ∫ₐᵇ (v-m) err`, `S ≥ ∫ₐᵇ |err|` and `d ≥ max|v-m|`.  The error is
now *quadratic* in the phase width, so blocks of phase width `≈ 0.5` suffice and only some
20 blocks per band are needed.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaErrorSharp

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

/-! ## 1. Corner bounds for a product of two bracketed reals -/

/-- Minimum of the four corner products of two intervals. -/
def mn4 (x0 x1 y0 y1 : ℝ) : ℝ := min (min (x0 * y0) (x0 * y1)) (min (x1 * y0) (x1 * y1))

/-- Maximum of the four corner products of two intervals. -/
def mx4 (x0 x1 y0 y1 : ℝ) : ℝ := max (max (x0 * y0) (x0 * y1)) (max (x1 * y0) (x1 * y1))

theorem min_mul_le (x : ℝ) {y0 y1 y : ℝ} (h0 : y0 ≤ y) (h1 : y ≤ y1) :
    min (x * y0) (x * y1) ≤ x * y := by
  rcases le_total 0 x with h | h
  · exact le_trans (min_le_left _ _) (by nlinarith)
  · exact le_trans (min_le_right _ _) (by nlinarith)

theorem le_max_mul (x : ℝ) {y0 y1 y : ℝ} (h0 : y0 ≤ y) (h1 : y ≤ y1) :
    x * y ≤ max (x * y0) (x * y1) := by
  rcases le_total 0 x with h | h
  · exact le_trans (by nlinarith) (le_max_right _ _)
  · exact le_trans (by nlinarith) (le_max_left _ _)

theorem mn4_le_mul {x0 x1 y0 y1 x y : ℝ} (hx0 : x0 ≤ x) (hx1 : x ≤ x1)
    (hy0 : y0 ≤ y) (hy1 : y ≤ y1) : mn4 x0 x1 y0 y1 ≤ x * y := by
  refine (min_le_min (min_mul_le x0 hy0 hy1) (min_mul_le x1 hy0 hy1)).trans ?_
  have h := min_mul_le (x := y) (y0 := x0) (y1 := x1) hx0 hx1
  rw [mul_comm y x0, mul_comm y x1, mul_comm y x] at h
  exact h

theorem mul_le_mx4 {x0 x1 y0 y1 x y : ℝ} (hx0 : x0 ≤ x) (hx1 : x ≤ x1)
    (hy0 : y0 ≤ y) (hy1 : y ≤ y1) : x * y ≤ mx4 x0 x1 y0 y1 := by
  refine le_trans ?_ (max_le_max (le_max_mul x0 hy0 hy1) (le_max_mul x1 hy0 hy1))
  have h := le_max_mul (x := y) (y0 := x0) (y1 := x1) hx0 hx1
  rw [mul_comm y x0, mul_comm y x1, mul_comm y x] at h
  exact h

/-! ## 2. Elementary Taylor bounds for `cos` and `sin` -/

theorem abs_cos_sub_one_le (y : ℝ) : |Real.cos y - 1| ≤ y ^ 2 / 2 := by
  have key : ∀ z : ℝ, 0 ≤ z → |Real.cos z - 1| ≤ z ^ 2 / 2 := by
    intro z hz
    have h := (taylor_sign (n := 2) (by norm_num) hz).1
    have hc : cosPart 2 z = 1 - z ^ 2 / 2 := by
      simp only [cosPart, Finset.sum_range_succ, Finset.sum_range_zero]
      norm_num [Nat.factorial]; ring
    rw [show ((-1:ℝ) ^ 2) = 1 by norm_num, one_mul, hc] at h
    rw [abs_le]
    exact ⟨by linarith, by linarith [Real.cos_le_one z]⟩
  rcases le_total 0 y with h | h
  · exact key y h
  · have h2 := key (-y) (by linarith)
    rwa [Real.cos_neg, neg_pow, show ((-1:ℝ)) ^ 2 = 1 by norm_num, one_mul] at h2

theorem abs_sin_sub_le (y : ℝ) : |Real.sin y - y| ≤ |y| ^ 3 / 6 := by
  have key : ∀ z : ℝ, 0 ≤ z → |Real.sin z - z| ≤ z ^ 3 / 6 := by
    intro z hz
    have h := (taylor_sign (n := 2) (by norm_num) hz).2
    have hc : sinPart 2 z = z - z ^ 3 / 6 := by
      simp only [sinPart, Finset.sum_range_succ, Finset.sum_range_zero]
      norm_num [Nat.factorial]; ring
    rw [show ((-1:ℝ) ^ 2) = 1 by norm_num, one_mul, hc] at h
    rw [abs_le]
    exact ⟨by linarith, by linarith [Real.sin_le hz]⟩
  rcases le_total 0 y with h | h
  · rw [abs_of_nonneg h]; exact key y h
  · have h2 := key (-y) (by linarith)
    rw [Real.sin_neg, show (-Real.sin y) - (-y) = -(Real.sin y - y) by ring, abs_neg] at h2
    rw [abs_of_nonpos h]
    exact h2

/-! ## 3. Rational brackets for `sin` -/

/-- **Bracket for `sin X`, residue `0`**: `X = y + 2πj` with `y ∈ [0, π/2]`. -/
theorem sin_bracket_case0 {X ylo yhi : ℝ} {j : ℤ} (hy0 : 0 ≤ ylo) (hyhi : yhi ≤ π / 2)
    (h1 : ylo ≤ X - j * (2 * π)) (h2 : X - j * (2 * π) ≤ yhi) :
    sinLoP ylo ≤ Real.sin X ∧ Real.sin X ≤ sinHiP yhi := by
  set y := X - j * (2 * π) with hy
  have hX : Real.sin X = Real.sin y := by
    have hs : y = X + ((-j : ℤ) : ℝ) * (2 * π) := by rw [hy]; push_cast; ring
    rw [hs, Real.sin_add_int_mul_two_pi]
  have hylo : 0 ≤ y := le_trans hy0 h1
  have hyhi' : y ≤ π / 2 := le_trans h2 hyhi
  rw [hX]
  exact ⟨le_trans (sinLoP_le_sin hy0) (sin_le_sin_of_le hy0 h1 hyhi'),
    le_trans (sin_le_sin_of_le hylo h2 hyhi) (sin_le_sinHiP (le_trans hylo h2))⟩

/-- **Bracket for `sin X`, residue `1`**: `X = y + π/2 + 2πj`, so `sin X = cos y`. -/
theorem sin_bracket_case1 {X ylo yhi : ℝ} {j : ℤ} (hy0 : 0 ≤ ylo) (hyhi : yhi ≤ π / 2)
    (h1 : ylo ≤ X - π / 2 - j * (2 * π)) (h2 : X - π / 2 - j * (2 * π) ≤ yhi) :
    cosLoP yhi ≤ Real.sin X ∧ Real.sin X ≤ cosHiP ylo := by
  set y := X - π / 2 - j * (2 * π) with hy
  have hX : Real.sin X = Real.cos y := by
    have hs : X = (y + π / 2) + (j : ℝ) * (2 * π) := by rw [hy]; ring
    rw [hs, Real.sin_add_int_mul_two_pi, Real.sin_add_pi_div_two]
  have hylo : 0 ≤ y := le_trans hy0 h1
  rw [hX]
  exact ⟨le_trans (cosLoP_le_cos (le_trans hylo h2)) (cos_le_cos_of_le hylo h2 hyhi),
    le_trans (cos_le_cos_of_le hy0 h1 (le_trans h2 hyhi)) (cos_le_cosHiP hy0)⟩

/-- **Bracket for `sin X`, residue `2`**: `X = y + π + 2πj`, so `sin X = -sin y`. -/
theorem sin_bracket_case2 {X ylo yhi : ℝ} {j : ℤ} (hy0 : 0 ≤ ylo) (hyhi : yhi ≤ π / 2)
    (h1 : ylo ≤ X - π - j * (2 * π)) (h2 : X - π - j * (2 * π) ≤ yhi) :
    -sinHiP yhi ≤ Real.sin X ∧ Real.sin X ≤ -sinLoP ylo := by
  set y := X - π - j * (2 * π) with hy
  have hX : Real.sin X = -Real.sin y := by
    have hs : X = (y + π) + (j : ℝ) * (2 * π) := by rw [hy]; ring
    rw [hs, Real.sin_add_int_mul_two_pi, Real.sin_add_pi]
  have hylo : 0 ≤ y := le_trans hy0 h1
  have hyhi' : y ≤ π / 2 := le_trans h2 hyhi
  rw [hX]
  constructor
  · have := sin_le_sinHiP (le_trans hylo h2)
    have h3 := sin_le_sin_of_le hylo h2 hyhi
    linarith
  · have := sinLoP_le_sin hy0
    have h3 := sin_le_sin_of_le hy0 h1 hyhi'
    linarith

/-- **Bracket for `sin X`, residue `3`**: `X = y + 3π/2 + 2πj`, so `sin X = -cos y`. -/
theorem sin_bracket_case3 {X ylo yhi : ℝ} {j : ℤ} (hy0 : 0 ≤ ylo) (hyhi : yhi ≤ π / 2)
    (h1 : ylo ≤ X - 3 * π / 2 - j * (2 * π)) (h2 : X - 3 * π / 2 - j * (2 * π) ≤ yhi) :
    -cosHiP ylo ≤ Real.sin X ∧ Real.sin X ≤ -cosLoP yhi := by
  set y := X - 3 * π / 2 - j * (2 * π) with hy
  have hX : Real.sin X = -Real.cos y := by
    have hs : X = (y - π / 2) + ((j + 1 : ℤ) : ℝ) * (2 * π) := by rw [hy]; push_cast; ring
    rw [hs, Real.sin_add_int_mul_two_pi, Real.sin_sub_pi_div_two]
  have hylo : 0 ≤ y := le_trans hy0 h1
  rw [hX]
  constructor
  · have := cos_le_cosHiP hy0
    have h3 := cos_le_cos_of_le hy0 h1 (le_trans h2 hyhi)
    linarith
  · have := cosLoP_le_cos (le_trans hylo h2)
    have h3 := cos_le_cos_of_le hylo h2 hyhi
    linarith

/-! ## 4. Trigonometric brackets on a short interval -/

/-- **Brackets for `cos x` and `sin x` for `x` in a short interval `[X₀, X₀+W]`**, obtained
from point brackets at `X₀` and the addition formulas.  The width of the resulting brackets
is `O(W)` times the size of the derivative, not `O(W)` outright. -/
theorem trig_shift_bracket {X0 W x c0 c1 s0 s1 : ℝ} (hW0 : 0 ≤ W) (hW1 : W ≤ 1.5)
    (hx0 : X0 ≤ x) (hx1 : x ≤ X0 + W)
    (hc0 : c0 ≤ Real.cos X0) (hc1 : Real.cos X0 ≤ c1)
    (hs0 : s0 ≤ Real.sin X0) (hs1 : Real.sin X0 ≤ s1) :
    mn4 c0 c1 (cosLoP W) 1 - mx4 s0 s1 0 (sinHiP W) ≤ Real.cos x ∧
      Real.cos x ≤ mx4 c0 c1 (cosLoP W) 1 - mn4 s0 s1 0 (sinHiP W) ∧
      mn4 s0 s1 (cosLoP W) 1 + mn4 c0 c1 0 (sinHiP W) ≤ Real.sin x ∧
      Real.sin x ≤ mx4 s0 s1 (cosLoP W) 1 + mx4 c0 c1 0 (sinHiP W) := by
  have hpi : (1.5:ℝ) ≤ π / 2 := by linarith [Real.pi_gt_d20]
  set g := x - X0 with hg
  have hg0 : 0 ≤ g := by rw [hg]; linarith
  have hgW : g ≤ W := by rw [hg]; linarith
  have hgpi : g ≤ π / 2 := le_trans hgW (le_trans hW1 hpi)
  have hcg0 : cosLoP W ≤ Real.cos g :=
    le_trans (cosLoP_le_cos (le_trans hW0 (le_refl W)))
      (cos_le_cos_of_le hg0 hgW (le_trans hW1 hpi))
  have hcg1 : Real.cos g ≤ 1 := Real.cos_le_one g
  have hsg0 : (0:ℝ) ≤ Real.sin g :=
    Real.sin_nonneg_of_nonneg_of_le_pi hg0 (by linarith [Real.pi_gt_d20])
  have hsg1 : Real.sin g ≤ sinHiP W :=
    le_trans (sin_le_sin_of_le hg0 hgW (le_trans hW1 hpi)) (sin_le_sinHiP hW0)
  have hxe : x = X0 + g := by rw [hg]; ring
  have hcx : Real.cos x = Real.cos X0 * Real.cos g - Real.sin X0 * Real.sin g := by
    rw [hxe, Real.cos_add]
  have hsx : Real.sin x = Real.sin X0 * Real.cos g + Real.cos X0 * Real.sin g := by
    rw [hxe, Real.sin_add]
  refine ⟨?_, ?_, ?_, ?_⟩
  · rw [hcx]
    have h1 := mn4_le_mul (x0 := c0) (x1 := c1) (y0 := cosLoP W) (y1 := 1) hc0 hc1 hcg0 hcg1
    have h2 := mul_le_mx4 (x0 := s0) (x1 := s1) (y0 := 0) (y1 := sinHiP W) hs0 hs1 hsg0 hsg1
    linarith
  · rw [hcx]
    have h1 := mul_le_mx4 (x0 := c0) (x1 := c1) (y0 := cosLoP W) (y1 := 1) hc0 hc1 hcg0 hcg1
    have h2 := mn4_le_mul (x0 := s0) (x1 := s1) (y0 := 0) (y1 := sinHiP W) hs0 hs1 hsg0 hsg1
    linarith
  · rw [hsx]
    have h1 := mn4_le_mul (x0 := s0) (x1 := s1) (y0 := cosLoP W) (y1 := 1) hs0 hs1 hcg0 hcg1
    have h2 := mn4_le_mul (x0 := c0) (x1 := c1) (y0 := 0) (y1 := sinHiP W) hc0 hc1 hsg0 hsg1
    linarith
  · rw [hsx]
    have h1 := mul_le_mx4 (x0 := s0) (x1 := s1) (y0 := cosLoP W) (y1 := 1) hs0 hs1 hcg0 hcg1
    have h2 := mul_le_mx4 (x0 := c0) (x1 := c1) (y0 := 0) (y1 := sinHiP W) hc0 hc1 hsg0 hsg1
    linarith

/-! ## 5. Pointwise piece brackets and the block data -/

/-- The first moment of `e^{-v/2}` on an interval. -/
theorem integral_lin_mul_exp_neg_half (m a b : ℝ) :
    (∫ v in a..b, (v - m) * Real.exp (-(v / 2)))
      = 2 * (a + 2 - m) * Real.exp (-(a / 2)) - 2 * (b + 2 - m) * Real.exp (-(b / 2)) := by
  have hd : ∀ v ∈ Set.uIcc a b,
      HasDerivAt (fun u : ℝ => -2 * (u + (2 - m)) * Real.exp (-(u / 2)))
        ((v - m) * Real.exp (-(v / 2))) v := by
    intro v _
    have h1 : HasDerivAt (fun u : ℝ => -2 * (u + (2 - m))) (-2 : ℝ) v := by
      simpa using (((hasDerivAt_id v).add_const (2 - m)).const_mul (-2 : ℝ))
    have h0 : HasDerivAt (fun u : ℝ => -(u / 2)) (-(1 / 2) : ℝ) v := by
      simpa using ((hasDerivAt_id v).div_const 2).neg
    have h2 : HasDerivAt (fun u : ℝ => Real.exp (-(u / 2)))
        (Real.exp (-(v / 2)) * (-(1 / 2))) v := h0.exp
    have h3 := h1.mul h2
    convert h3 using 1
    ring
  rw [intervalIntegral.integral_eq_sub_of_hasDerivAt hd
    ((by fun_prop : Continuous fun v : ℝ => (v - m) * Real.exp (-(v / 2))).intervalIntegrable a b)]
  ring

theorem mul_ge_of_abs_le {c x y E : ℝ} (hc : |c| ≤ 1) (h : |x - y| ≤ E) : c * y - E ≤ c * x := by
  have hb : |c * x - c * y| ≤ E := by
    rw [← mul_sub, abs_mul]
    calc |c| * |x - y| ≤ 1 * E := mul_le_mul hc h (abs_nonneg _) zero_le_one
      _ = E := one_mul E
  linarith [(abs_le.1 hb).1]

theorem mul_le_of_abs_le {c x y E : ℝ} (hc : |c| ≤ 1) (h : |x - y| ≤ E) : c * x ≤ c * y + E := by
  have hb : |c * x - c * y| ≤ E := by
    rw [← mul_sub, abs_mul]
    calc |c| * |x - y| ≤ 1 * E := mul_le_mul hc h (abs_nonneg _) zero_le_one
      _ = E := one_mul E
  linarith [(abs_le.1 hb).2]

/-- The pointwise two-sided bracket for `err` on a piece `[vBP q₀, vBP q₁]`. -/
def errPtBracket (q0 q1 Lo Hi : ℝ) : Prop :=
  ∀ v ∈ Icc (vBP q0) (vBP q1),
    Lo * Real.exp (-(v / 2)) ≤ errFun v ∧ errFun v ≤ Hi * Real.exp (-(v / 2))

/-- The numerical data attached to a block `[a,b]` with base point `m`: two-sided bounds for
`∫ₐᵇ err` and for the first moment `∫ₐᵇ (v-m) err`, and an upper bound for `∫ₐᵇ |err|`. -/
def errBlockLin (a b m P0 P1 R0 R1 S : ℝ) : Prop :=
  P0 ≤ (∫ v in a..b, errFun v) ∧ (∫ v in a..b, errFun v) ≤ P1 ∧
    R0 ≤ (∫ v in a..b, (v - m) * errFun v) ∧ (∫ v in a..b, (v - m) * errFun v) ≤ R1 ∧
    (∫ v in a..b, |errFun v|) ≤ S

theorem intervalIntegrable_lin_errFun (m a b : ℝ) :
    IntervalIntegrable (fun v => (v - m) * errFun v) volume a b :=
  ((continuous_id.sub continuous_const).mul continuous_errFun).intervalIntegrable a b

/-- Two adjacent blocks (with the same base point) combine. -/
theorem errBlockLin.add {a b c m P0 P1 R0 R1 S Q0 Q1 T0 T1 U : ℝ}
    (h : errBlockLin a b m P0 P1 R0 R1 S) (k : errBlockLin b c m Q0 Q1 T0 T1 U) :
    errBlockLin a c m (P0 + Q0) (P1 + Q1) (R0 + T0) (R1 + T1) (S + U) := by
  obtain ⟨h0, h1, h2, h3, h4⟩ := h
  obtain ⟨k0, k1, k2, k3, k4⟩ := k
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · rw [← intervalIntegral.integral_add_adjacent_intervals (intervalIntegrable_errFun a b)
      (intervalIntegrable_errFun b c)]; linarith
  · rw [← intervalIntegral.integral_add_adjacent_intervals (intervalIntegrable_errFun a b)
      (intervalIntegrable_errFun b c)]; linarith
  · rw [← intervalIntegral.integral_add_adjacent_intervals (intervalIntegrable_lin_errFun m a b)
      (intervalIntegrable_lin_errFun m b c)]; linarith
  · rw [← intervalIntegral.integral_add_adjacent_intervals (intervalIntegrable_lin_errFun m a b)
      (intervalIntegrable_lin_errFun m b c)]; linarith
  · rw [← intervalIntegral.integral_add_adjacent_intervals (intervalIntegrable_abs_errFun a b)
      (intervalIntegrable_abs_errFun b c)]; linarith

/-- Weakening of the block data (used to round the constants). -/
theorem errBlockLin.mono {a b m P0 P1 R0 R1 S P0' P1' R0' R1' S' : ℝ}
    (h : errBlockLin a b m P0 P1 R0 R1 S) (h0 : P0' ≤ P0) (h1 : P1 ≤ P1')
    (h2 : R0' ≤ R0) (h3 : R1 ≤ R1') (h4 : S ≤ S') :
    errBlockLin a b m P0' P1' R0' R1' S' :=
  ⟨le_trans h0 h.1, le_trans h.2.1 h1, le_trans h2 h.2.2.1, le_trans h.2.2.2.1 h3,
    le_trans h.2.2.2.2 h4⟩

/-- **The block data of a single piece.**  `A₀,A₁` and `B₀,B₁` are rational brackets for the
endpoints `vBP q₀`, `vBP q₁`, and `m` lies outside the open piece, so that `v - m` has a
constant sign on it. -/
theorem errBlockLin_of_piece {q0 q1 Lo Hi m Klo Khi : ℝ} {A0 A1 B0 B1 M0 M1 : ℝ}
    (hq0 : 0 < q0) (h01 : q0 ≤ q1) (hLoHi : Lo ≤ Hi)
    (hpt : errPtBracket q0 q1 Lo Hi)
    (hA0 : A0 ≤ vBP q0) (hA1 : vBP q0 ≤ A1) (hB0 : B0 ≤ vBP q1) (hB1 : vBP q1 ≤ B1)
    (hM0 : M0 ≤ m) (hM1 : m ≤ M1)
    (hsgn : m ≤ vBP q0 ∨ vBP q1 ≤ m)
    (hKlo : Klo ≤ 2 * (A0 + 2 - M1) / q0 - 2 * (B1 + 2 - M0) / q1)
    (hKhi : 2 * (A1 + 2 - M0) / q0 - 2 * (B0 + 2 - M1) / q1 ≤ Khi) :
    errBlockLin (vBP q0) (vBP q1) m (2 * Lo * (1 / q0 - 1 / q1)) (2 * Hi * (1 / q0 - 1 / q1))
      (mn4 Lo Hi Klo Khi) (mx4 Lo Hi Klo Khi)
      (2 * max (-Lo) Hi * (1 / q0 - 1 / q1)) := by
  have hq1 : (0:ℝ) < q1 := lt_of_lt_of_le hq0 h01
  have hab : vBP q0 ≤ vBP q1 := vBP_mono hq0 h01
  set M : ℝ := max (-Lo) Hi with hM
  have hM0 : -M ≤ Lo := by rw [hM]; simp only [neg_le]; exact le_max_left _ _
  have hM1 : Hi ≤ M := le_max_right _ _
  have hbase := errIntBracket_of_pointwise hq0 h01 hpt hM0 hM1
  -- the first moment
  have hKval : (∫ v in (vBP q0)..(vBP q1), (v - m) * Real.exp (-(v / 2)))
      = 2 * (vBP q0 + 2 - m) / q0 - 2 * (vBP q1 + 2 - m) / q1 := by
    rw [integral_lin_mul_exp_neg_half, exp_neg_half_vBP hq0, exp_neg_half_vBP hq1]
    ring
  have hKbr : Klo ≤ (∫ v in (vBP q0)..(vBP q1), (v - m) * Real.exp (-(v / 2))) ∧
      (∫ v in (vBP q0)..(vBP q1), (v - m) * Real.exp (-(v / 2))) ≤ Khi := by
    rw [hKval]
    constructor
    · refine le_trans hKlo ?_
      have e1 : 2 * (A0 + 2 - M1) / q0 ≤ 2 * (vBP q0 + 2 - m) / q0 := by
        have : A0 + 2 - M1 ≤ vBP q0 + 2 - m := by linarith
        gcongr
      have e2 : 2 * (vBP q1 + 2 - m) / q1 ≤ 2 * (B1 + 2 - M0) / q1 := by
        have : vBP q1 + 2 - m ≤ B1 + 2 - M0 := by linarith
        gcongr
      linarith
    · refine le_trans ?_ hKhi
      have e1 : 2 * (vBP q0 + 2 - m) / q0 ≤ 2 * (A1 + 2 - M0) / q0 := by
        have : vBP q0 + 2 - m ≤ A1 + 2 - M0 := by linarith
        gcongr
      have e2 : 2 * (B0 + 2 - M1) / q1 ≤ 2 * (vBP q1 + 2 - m) / q1 := by
        have : B0 + 2 - M1 ≤ vBP q1 + 2 - m := by linarith
        gcongr
      linarith
  have hcont : IntervalIntegrable (fun v : ℝ => (v - m) * Real.exp (-(v / 2))) volume
      (vBP q0) (vBP q1) :=
    (by fun_prop : Continuous fun v : ℝ => (v - m) * Real.exp (-(v / 2))).intervalIntegrable _ _
  have hmom : mn4 Lo Hi Klo Khi ≤ (∫ v in (vBP q0)..(vBP q1), (v - m) * errFun v) ∧
      (∫ v in (vBP q0)..(vBP q1), (v - m) * errFun v) ≤ mx4 Lo Hi Klo Khi := by
    rcases hsgn with hs | hs
    · -- `v - m ≥ 0` on the piece: bracket by `Lo` from below and `Hi` from above
      have hlow : (∫ v in (vBP q0)..(vBP q1), Lo * ((v - m) * Real.exp (-(v / 2))))
          ≤ ∫ v in (vBP q0)..(vBP q1), (v - m) * errFun v := by
        refine intervalIntegral.integral_mono_on hab (hcont.const_mul Lo)
          (intervalIntegrable_lin_errFun m _ _) (fun v hv => ?_)
        have hp := (hpt v hv).1
        have hvm : 0 ≤ v - m := by linarith [hv.1]
        nlinarith
      have hhigh : (∫ v in (vBP q0)..(vBP q1), (v - m) * errFun v)
          ≤ ∫ v in (vBP q0)..(vBP q1), Hi * ((v - m) * Real.exp (-(v / 2))) := by
        refine intervalIntegral.integral_mono_on hab (intervalIntegrable_lin_errFun m _ _)
          (hcont.const_mul Hi) (fun v hv => ?_)
        have hp := (hpt v hv).2
        have hvm : 0 ≤ v - m := by linarith [hv.1]
        nlinarith
      rw [intervalIntegral.integral_const_mul] at hlow hhigh
      exact ⟨le_trans (mn4_le_mul (le_refl Lo) hLoHi hKbr.1 hKbr.2) hlow,
        le_trans hhigh (mul_le_mx4 hLoHi (le_refl Hi) hKbr.1 hKbr.2)⟩
    · -- `v - m ≤ 0` on the piece: the roles of `Lo` and `Hi` are exchanged
      have hlow : (∫ v in (vBP q0)..(vBP q1), Hi * ((v - m) * Real.exp (-(v / 2))))
          ≤ ∫ v in (vBP q0)..(vBP q1), (v - m) * errFun v := by
        refine intervalIntegral.integral_mono_on hab (hcont.const_mul Hi)
          (intervalIntegrable_lin_errFun m _ _) (fun v hv => ?_)
        have hp := (hpt v hv).2
        have hvm : v - m ≤ 0 := by linarith [hv.2]
        nlinarith
      have hhigh : (∫ v in (vBP q0)..(vBP q1), (v - m) * errFun v)
          ≤ ∫ v in (vBP q0)..(vBP q1), Lo * ((v - m) * Real.exp (-(v / 2))) := by
        refine intervalIntegral.integral_mono_on hab (intervalIntegrable_lin_errFun m _ _)
          (hcont.const_mul Lo) (fun v hv => ?_)
        have hp := (hpt v hv).1
        have hvm : v - m ≤ 0 := by linarith [hv.2]
        nlinarith
      rw [intervalIntegral.integral_const_mul] at hlow hhigh
      exact ⟨le_trans (mn4_le_mul hLoHi (le_refl Hi) hKbr.1 hKbr.2) hlow,
        le_trans hhigh (mul_le_mx4 (le_refl Lo) hLoHi hKbr.1 hKbr.2)⟩
  exact ⟨hbase.1, hbase.2.1, hmom.1, hmom.2, hbase.2.2⟩

/-! ## 6. The block estimate with linear phase correction -/

theorem abs_integral_errFun_mul_le {a b K S : ℝ} (hab : a ≤ b) {g : ℝ → ℝ} (hg : Continuous g)
    (hK : ∀ v, a ≤ v → v ≤ b → |g v| ≤ K) (hK0 : 0 ≤ K)
    (hS : (∫ v in a..b, |errFun v|) ≤ S) :
    |∫ v in a..b, errFun v * g v| ≤ K * S := by
  have h1 : |∫ v in a..b, errFun v * g v| ≤ ∫ v in a..b, |errFun v * g v| := by
    simpa [Real.norm_eq_abs] using
      intervalIntegral.abs_integral_le_integral_abs (μ := volume)
        (f := fun v => errFun v * g v) hab
  have hcint : IntervalIntegrable (fun v => |errFun v * g v|) volume a b :=
    ((continuous_errFun.mul hg).abs).intervalIntegrable a b
  have h2 : (∫ v in a..b, |errFun v * g v|) ≤ ∫ v in a..b, K * |errFun v| := by
    refine intervalIntegral.integral_mono_on hab hcint
      ((intervalIntegrable_abs_errFun a b).const_mul K) (fun v hv => ?_)
    rw [abs_mul, mul_comm K |errFun v|]
    exact mul_le_mul_of_nonneg_left (hK v hv.1 hv.2) (abs_nonneg _)
  have h3 : (∫ v in a..b, K * |errFun v|) ≤ K * S := by
    rw [intervalIntegral.integral_const_mul]
    exact mul_le_mul_of_nonneg_left hS hK0
  linarith

/-- **The block estimate with linear phase correction.** -/
theorem errCos_block_ge_lin {a b m t t0 t1 P0 P1 R0 R1 S d ulo uhi vlo vhi L : ℝ}
    (hab : a ≤ b) (hd0 : 0 ≤ d) (hda : -d ≤ a - m) (hdb : b - m ≤ d)
    (ht0 : t0 ≤ t) (ht1 : t ≤ t1) (ht00 : 0 ≤ t0)
    (hbl : errBlockLin a b m P0 P1 R0 R1 S)
    (hu0 : ulo ≤ Real.cos (t * m)) (hu1 : Real.cos (t * m) ≤ uhi)
    (hv0 : vlo ≤ Real.sin (t * m)) (hv1 : Real.sin (t * m) ≤ vhi)
    (hL : L ≤ mn4 ulo uhi P0 P1
      - mx4 (mn4 t0 t1 vlo vhi) (mx4 t0 t1 vlo vhi) R0 R1
      - (t1 ^ 2 / 2) * d ^ 2 * S - (t1 ^ 3 / 6) * d ^ 3 * S) :
    L ≤ ∫ v in a..b, errFun v * Real.cos (t * v) := by
  obtain ⟨hP0, hP1, hR0, hR1, hS⟩ := hbl
  have ht : 0 ≤ t := le_trans ht00 ht0
  have ht1n : 0 ≤ t1 := le_trans ht ht1
  set I1 : ℝ := ∫ v in a..b, errFun v with hI1
  set I2 : ℝ := ∫ v in a..b, (v - m) * errFun v with hI2
  set J1 : ℝ := ∫ v in a..b, errFun v * Real.cos (t * (v - m)) with hJ1
  set J2 : ℝ := ∫ v in a..b, errFun v * Real.sin (t * (v - m)) with hJ2
  have hc1 : IntervalIntegrable (fun v => errFun v * Real.cos (t * (v - m))) volume a b :=
    (continuous_errFun.mul (by fun_prop)).intervalIntegrable a b
  have hc2 : IntervalIntegrable (fun v => errFun v * Real.sin (t * (v - m))) volume a b :=
    (continuous_errFun.mul (by fun_prop)).intervalIntegrable a b
  -- decomposition of the oscillatory integral
  have hdec : (∫ v in a..b, errFun v * Real.cos (t * v))
      = Real.cos (t * m) * J1 - Real.sin (t * m) * J2 := by
    rw [hJ1, hJ2, ← intervalIntegral.integral_const_mul, ← intervalIntegral.integral_const_mul,
      ← intervalIntegral.integral_sub (hc1.const_mul _) (hc2.const_mul _)]
    refine intervalIntegral.integral_congr fun v _ => ?_
    have he : t * v = t * m + t * (v - m) := by ring
    rw [he, Real.cos_add]
    ring
  -- the two remainders
  have hrem1 : |J1 - I1| ≤ (t1 ^ 2 / 2 * d ^ 2) * S := by
    have he : J1 - I1 = ∫ v in a..b, errFun v * (Real.cos (t * (v - m)) - 1) := by
      rw [hJ1, hI1, ← intervalIntegral.integral_sub hc1 (intervalIntegrable_errFun a b)]
      exact intervalIntegral.integral_congr fun v _ => by ring
    rw [he]
    refine abs_integral_errFun_mul_le hab (by fun_prop) (fun v hv1 hv2 => ?_)
      (by positivity) hS
    refine le_trans (abs_cos_sub_one_le (t * (v - m))) ?_
    have h1 : |v - m| ≤ d := by rw [abs_le]; constructor <;> linarith
    have h2 : |t * (v - m)| ≤ t1 * d := by
      rw [abs_mul, abs_of_nonneg ht]
      exact mul_le_mul ht1 h1 (abs_nonneg _) ht1n
    have h3 : (t * (v - m)) ^ 2 ≤ (t1 * d) ^ 2 := by
      rw [← sq_abs (t * (v - m))]
      exact pow_le_pow_left₀ (abs_nonneg _) h2 2
    nlinarith
  have hrem2 : |J2 - t * I2| ≤ (t1 ^ 3 / 6 * d ^ 3) * S := by
    have he : J2 - t * I2 = ∫ v in a..b, errFun v * (Real.sin (t * (v - m)) - t * (v - m)) := by
      rw [hJ2, hI2, ← intervalIntegral.integral_const_mul,
        ← intervalIntegral.integral_sub hc2 ((intervalIntegrable_lin_errFun m a b).const_mul t)]
      exact intervalIntegral.integral_congr fun v _ => by ring
    rw [he]
    refine abs_integral_errFun_mul_le hab (by fun_prop) (fun v hv1 hv2 => ?_)
      (mul_nonneg (div_nonneg (pow_nonneg ht1n 3) (by norm_num)) (pow_nonneg hd0 3)) hS
    refine le_trans (abs_sin_sub_le (t * (v - m))) ?_
    have h1 : |v - m| ≤ d := by rw [abs_le]; constructor <;> linarith
    have h2 : |t * (v - m)| ≤ t1 * d := by
      rw [abs_mul, abs_of_nonneg ht]
      exact mul_le_mul ht1 h1 (abs_nonneg _) ht1n
    have h3 : |t * (v - m)| ^ 3 ≤ (t1 * d) ^ 3 :=
      pow_le_pow_left₀ (abs_nonneg _) h2 3
    nlinarith
  -- combine
  have hcabs : |Real.cos (t * m)| ≤ 1 := Real.abs_cos_le_one _
  have hsabs : |Real.sin (t * m)| ≤ 1 := Real.abs_sin_le_one _
  have hcos1 : Real.cos (t * m) * I1 - (t1 ^ 2 / 2 * d ^ 2) * S ≤ Real.cos (t * m) * J1 :=
    mul_ge_of_abs_le hcabs hrem1
  have hsin1 : Real.sin (t * m) * J2
      ≤ Real.sin (t * m) * (t * I2) + (t1 ^ 3 / 6 * d ^ 3) * S :=
    mul_le_of_abs_le hsabs hrem2
  have hmain : mn4 ulo uhi P0 P1 ≤ Real.cos (t * m) * I1 :=
    mn4_le_mul hu0 hu1 hP0 hP1
  have hz0 : mn4 t0 t1 vlo vhi ≤ t * Real.sin (t * m) := mn4_le_mul ht0 ht1 hv0 hv1
  have hz1 : t * Real.sin (t * m) ≤ mx4 t0 t1 vlo vhi := mul_le_mx4 ht0 ht1 hv0 hv1
  have hsec : Real.sin (t * m) * (t * I2)
      ≤ mx4 (mn4 t0 t1 vlo vhi) (mx4 t0 t1 vlo vhi) R0 R1 := by
    have he : Real.sin (t * m) * (t * I2) = (t * Real.sin (t * m)) * I2 := by ring
    rw [he]
    exact mul_le_mx4 hz0 hz1 hR0 hR1
  rw [hdec]
  linarith

/-! ## 7. Point brackets for `cos` and `sin` at a rational argument -/

/-- Combined `cos`/`sin` bracket at `X`, residue `0`: `X = y + 2πj`, `y ∈ [ylo,yhi] ⊆ [0,π/2]`. -/
theorem trigPoint0 {X ylo yhi c0 c1 s0 s1 : ℝ} {j : ℤ} (hy0 : 0 ≤ ylo) (hyhi : yhi ≤ π / 2)
    (h1 : ylo ≤ X - j * (2 * π)) (h2 : X - j * (2 * π) ≤ yhi)
    (hc0 : c0 ≤ cosLoP yhi) (hc1 : cosHiP ylo ≤ c1)
    (hs0 : s0 ≤ sinLoP ylo) (hs1 : sinHiP yhi ≤ s1) :
    c0 ≤ Real.cos X ∧ Real.cos X ≤ c1 ∧ s0 ≤ Real.sin X ∧ Real.sin X ≤ s1 := by
  obtain ⟨a1, a2⟩ := cos_bracket_case0 (m := j) hy0 hyhi h1 h2
  obtain ⟨b1, b2⟩ := sin_bracket_case0 (j := j) hy0 hyhi h1 h2
  exact ⟨le_trans hc0 a1, le_trans a2 hc1, le_trans hs0 b1, le_trans b2 hs1⟩

/-- Combined `cos`/`sin` bracket at `X`, residue `1`: `X = y + π/2 + 2πj`. -/
theorem trigPoint1 {X ylo yhi c0 c1 s0 s1 : ℝ} {j : ℤ} (hy0 : 0 ≤ ylo) (hyhi : yhi ≤ π / 2)
    (h1 : ylo ≤ X - π / 2 - j * (2 * π)) (h2 : X - π / 2 - j * (2 * π) ≤ yhi)
    (hc0 : c0 ≤ -sinHiP yhi) (hc1 : -sinLoP ylo ≤ c1)
    (hs0 : s0 ≤ cosLoP yhi) (hs1 : cosHiP ylo ≤ s1) :
    c0 ≤ Real.cos X ∧ Real.cos X ≤ c1 ∧ s0 ≤ Real.sin X ∧ Real.sin X ≤ s1 := by
  obtain ⟨a1, a2⟩ := cos_bracket_case1 (m := j) hy0 hyhi h1 h2
  obtain ⟨b1, b2⟩ := sin_bracket_case1 (j := j) hy0 hyhi h1 h2
  exact ⟨le_trans hc0 a1, le_trans a2 hc1, le_trans hs0 b1, le_trans b2 hs1⟩

/-- Combined `cos`/`sin` bracket at `X`, residue `2`: `X = y + π + 2πj`. -/
theorem trigPoint2 {X ylo yhi c0 c1 s0 s1 : ℝ} {j : ℤ} (hy0 : 0 ≤ ylo) (hyhi : yhi ≤ π / 2)
    (h1 : ylo ≤ X - π - j * (2 * π)) (h2 : X - π - j * (2 * π) ≤ yhi)
    (hc0 : c0 ≤ -cosHiP ylo) (hc1 : -cosLoP yhi ≤ c1)
    (hs0 : s0 ≤ -sinHiP yhi) (hs1 : -sinLoP ylo ≤ s1) :
    c0 ≤ Real.cos X ∧ Real.cos X ≤ c1 ∧ s0 ≤ Real.sin X ∧ Real.sin X ≤ s1 := by
  obtain ⟨a1, a2⟩ := cos_bracket_case2 (m := j) hy0 hyhi h1 h2
  obtain ⟨b1, b2⟩ := sin_bracket_case2 (j := j) hy0 hyhi h1 h2
  exact ⟨le_trans hc0 a1, le_trans a2 hc1, le_trans hs0 b1, le_trans b2 hs1⟩

/-- Combined `cos`/`sin` bracket at `X`, residue `3`: `X = y + 3π/2 + 2πj`. -/
theorem trigPoint3 {X ylo yhi c0 c1 s0 s1 : ℝ} {j : ℤ} (hy0 : 0 ≤ ylo) (hyhi : yhi ≤ π / 2)
    (h1 : ylo ≤ X - 3 * π / 2 - j * (2 * π)) (h2 : X - 3 * π / 2 - j * (2 * π) ≤ yhi)
    (hc0 : c0 ≤ sinLoP ylo) (hc1 : sinHiP yhi ≤ c1)
    (hs0 : s0 ≤ -cosHiP ylo) (hs1 : -cosLoP yhi ≤ s1) :
    c0 ≤ Real.cos X ∧ Real.cos X ≤ c1 ∧ s0 ≤ Real.sin X ∧ Real.sin X ≤ s1 := by
  obtain ⟨a1, a2⟩ := cos_bracket_case3 (m := j) hy0 hyhi h1 h2
  obtain ⟨b1, b2⟩ := sin_bracket_case3 (j := j) hy0 hyhi h1 h2
  exact ⟨le_trans hc0 a1, le_trans a2 hc1, le_trans hs0 b1, le_trans b2 hs1⟩

/-- The product `t·m` stays in `[X₀, X₀+W]` when `t` and `m` do. -/
theorem mul_mem_of_bracket {t t0 t1 m M0 M1 X0 W : ℝ} (ht0 : t0 ≤ t) (ht1 : t ≤ t1)
    (hm0 : M0 ≤ m) (hm1 : m ≤ M1) (ht00 : 0 ≤ t0) (hM00 : 0 ≤ M0)
    (hX : X0 ≤ t0 * M0) (hW : t1 * M1 ≤ X0 + W) :
    X0 ≤ t * m ∧ t * m ≤ X0 + W := by
  have h1 : t0 * M0 ≤ t * m := mul_le_mul ht0 hm0 hM00 (le_trans ht00 ht0)
  have h2 : t * m ≤ t1 * M1 :=
    mul_le_mul ht1 hm1 (le_trans hM00 hm0) (le_trans (le_trans ht00 ht0) ht1)
  exact ⟨le_trans hX h1, le_trans h2 hW⟩

/-! ## 8. Pointwise versions of the crude piece brackets -/

/-- Pointwise crude bracket on a piece, Taylor branch (used on the few pieces on which the
`q²`-interval straddles a quadrant boundary, so that the sharpened bracket is unavailable). -/
theorem errPiece_crude_taylor {q0 q1 Lo Hi : ℝ} (h1 : 1 ≤ q0) (h01 : q0 ≤ q1)
    (hHi : (q1 ^ 2 / (3.14159 * (1 + q1 ^ 2)))
          * (1.5708 + 1 / (6.28318 * (1 + q0 ^ 2)) + 1 / (6.28318 * (1 + q0 ^ 2)) ^ 2)
        + 2 * q1 ^ 2 * taylorQup (6.28318 * (q0 ^ 2 - 1)) - 1 - 2.11 / q1 ^ 5 ≤ Hi)
    (hLo : Lo ≤ (q0 ^ 2 / (3.1416 * (1 + q0 ^ 2)))
          * (1.5707 - 1 / (6.28318 * (1 + q0 ^ 2)) - 1 / (6.28318 * (1 + q0 ^ 2)) ^ 2)
        + 2 * q0 ^ 2 * taylorQ (6.2832 * (q1 ^ 2 - 1)) - 1 - 2.11 / q0 ^ 5) :
    errPtBracket q0 q1 Lo Hi := by
  intro v hv
  obtain ⟨he0, he1, hE0, hE1⟩ := exp_bounds_of_mem_Icc h1 h01 hv
  have hr0 : (1:ℝ) ≤ q0 ^ 2 := by nlinarith
  refine errFun_bracket_of_PhiErr ?_ ?_
  · have hA0 := term_a_ge hr0 he0
    have hB0 := term_b_ge_taylor hr0 he0 he1
    have hsplit : 2 * Real.exp v * (siDiv (uPlus v) + siDiv (uMinus v))
        = 2 * Real.exp v * siDiv (uPlus v) + 2 * Real.exp v * siDiv (uMinus v) := by ring
    have hd0 : (2.11:ℝ) / q0 ^ 5 = 2.11 * (1 / q0 ^ 5) := by ring
    rw [hd0] at hLo
    rw [PhiErr, hsplit]
    linarith
  · have hA1 := term_a_le hr0 he0 he1
    have hB1 := term_b_le_taylor hr0 he0 he1
    have hsplit : 2 * Real.exp v * (siDiv (uPlus v) + siDiv (uMinus v))
        = 2 * Real.exp v * siDiv (uPlus v) + 2 * Real.exp v * siDiv (uMinus v) := by ring
    have hd1 : (2.11:ℝ) / q1 ^ 5 = 2.11 * (1 / q1 ^ 5) := by ring
    rw [hd1] at hHi
    rw [PhiErr, hsplit]
    linarith

/-- Pointwise crude bracket on a piece, asymptotic branch. -/
theorem errPiece_crude_asymp {q0 q1 Lo Hi : ℝ} (h1 : 1 < q0) (h01 : q0 ≤ q1)
    (hnn : (0:ℝ) ≤ 1.5707 - 1 / (6.28318 * (q0 ^ 2 - 1)) - 1 / (6.28318 * (q0 ^ 2 - 1)) ^ 2)
    (hHi : (q1 ^ 2 / (3.14159 * (1 + q1 ^ 2)))
          * (1.5708 + 1 / (6.28318 * (1 + q0 ^ 2)) + 1 / (6.28318 * (1 + q0 ^ 2)) ^ 2)
        + (q0 ^ 2 / (3.14159 * (q0 ^ 2 - 1)))
          * (1.5708 + 1 / (6.28318 * (q0 ^ 2 - 1)) + 1 / (6.28318 * (q0 ^ 2 - 1)) ^ 2)
        - 1 - 2.11 / q1 ^ 5 ≤ Hi)
    (hLo : Lo ≤ (q0 ^ 2 / (3.1416 * (1 + q0 ^ 2)))
          * (1.5707 - 1 / (6.28318 * (1 + q0 ^ 2)) - 1 / (6.28318 * (1 + q0 ^ 2)) ^ 2)
        + (q1 ^ 2 / (3.1416 * (q1 ^ 2 - 1)))
          * (1.5707 - 1 / (6.28318 * (q0 ^ 2 - 1)) - 1 / (6.28318 * (q0 ^ 2 - 1)) ^ 2)
        - 1 - 2.11 / q0 ^ 5) :
    errPtBracket q0 q1 Lo Hi := by
  intro v hv
  obtain ⟨he0, he1, hE0, hE1⟩ := exp_bounds_of_mem_Icc h1.le h01 hv
  have hr0 : (1:ℝ) < q0 ^ 2 := by nlinarith
  refine errFun_bracket_of_PhiErr ?_ ?_
  · have hA0 := term_a_ge hr0.le he0
    have hB0 := term_b_ge_asymp hr0 he0 he1 hnn
    have hsplit : 2 * Real.exp v * (siDiv (uPlus v) + siDiv (uMinus v))
        = 2 * Real.exp v * siDiv (uPlus v) + 2 * Real.exp v * siDiv (uMinus v) := by ring
    have hd0 : (2.11:ℝ) / q0 ^ 5 = 2.11 * (1 / q0 ^ 5) := by ring
    rw [hd0] at hLo
    rw [PhiErr, hsplit]
    linarith
  · have hA1 := term_a_le hr0.le he0 he1
    have hB1 := term_b_le_asymp hr0 he0
    have hsplit : 2 * Real.exp v * (siDiv (uPlus v) + siDiv (uMinus v))
        = 2 * Real.exp v * siDiv (uPlus v) + 2 * Real.exp v * siDiv (uMinus v) := by ring
    have hd1 : (2.11:ℝ) / q1 ^ 5 = 2.11 * (1 / q1 ^ 5) := by ring
    rw [hd1] at hHi
    rw [PhiErr, hsplit]
    linarith

end ConnesConsani.WeilPositivity
