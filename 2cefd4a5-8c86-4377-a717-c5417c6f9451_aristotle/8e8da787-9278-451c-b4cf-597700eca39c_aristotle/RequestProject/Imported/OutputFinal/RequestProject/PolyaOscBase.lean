/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Infrastructure for the *oscillatory* refinement of the Pólya-model error bound of
`RequestProject/PolyaModel.lean`.

The bound `|∫₀^∞ err(v) cos(tv) dv| ≤ ∫₀^∞ |err(v)| dv ≤ 0.21088` of
`RequestProject/PolyaPartition3.lean` discards all cancellation in the oscillatory integral.
Here we set up the machinery which replaces, on each piece of the partition, the estimate
`|cos(tv)| ≤ 1` by a genuine bracket `C - h ≤ cos(tv) ≤ C + h` valid on that piece, and then
sums the *signed* contributions.  The ingredients are

* `errIntBracket a b P₀ P₁ S`: the package of the three numerical facts about a block
  `[a,b]` that the argument uses, namely `P₀ ≤ ∫ₐᵇ err ≤ P₁` and `∫ₐᵇ |err| ≤ S`;
* `errPiece_taylor` / `errPiece_asymp`: the two-sided (signed) versions of the pointwise
  brackets of `RequestProject/PolyaError.lean`, integrated over one piece of the partition;
* `errCos_block_ge`: the block estimate
  `∫ₐᵇ err(v)cos(tv) dv ≥ min(C P₀, C P₁) - h S`;
* rational brackets for `cos` at a real point (`cos_bracket_case0`–`cos_bracket_case3`) and
  for the breakpoints `vBP q = 2 log q` (`vBP_bracket`), which make the block estimate
  effective;
* `deltaFourier_ge_of_cos_bound`, the bridge back to `δ̂`.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaError

noncomputable section

open MeasureTheory Set Real Filter Topology

namespace ConnesConsani.WeilPositivity

/-! ## 1. Integral brackets for a block -/

/-- The numerical data attached to a block `[a,b]` of the partition: two-sided bounds for
`∫ₐᵇ err` and an upper bound for `∫ₐᵇ |err|`. -/
def errIntBracket (a b P0 P1 S : ℝ) : Prop :=
  P0 ≤ (∫ v in a..b, errFun v) ∧ (∫ v in a..b, errFun v) ≤ P1 ∧
    (∫ v in a..b, |errFun v|) ≤ S

theorem intervalIntegrable_errFun (a b : ℝ) :
    IntervalIntegrable errFun volume a b :=
  continuous_errFun.intervalIntegrable a b

theorem intervalIntegrable_abs_errFun (a b : ℝ) :
    IntervalIntegrable (fun v => |errFun v|) volume a b :=
  continuous_errFun.abs.intervalIntegrable a b

theorem intervalIntegrable_errFun_mul_cos (t a b : ℝ) :
    IntervalIntegrable (fun v => errFun v * Real.cos (t * v)) volume a b :=
  (continuous_errFun.mul (by fun_prop)).intervalIntegrable a b

/-- Two adjacent blocks combine. -/
theorem errIntBracket.add {a b c P0 P1 S Q0 Q1 T : ℝ}
    (h : errIntBracket a b P0 P1 S) (k : errIntBracket b c Q0 Q1 T) :
    errIntBracket a c (P0 + Q0) (P1 + Q1) (S + T) := by
  obtain ⟨h0, h1, h2⟩ := h
  obtain ⟨k0, k1, k2⟩ := k
  refine ⟨?_, ?_, ?_⟩
  · rw [← intervalIntegral.integral_add_adjacent_intervals (intervalIntegrable_errFun a b)
      (intervalIntegrable_errFun b c)]
    linarith
  · rw [← intervalIntegral.integral_add_adjacent_intervals (intervalIntegrable_errFun a b)
      (intervalIntegrable_errFun b c)]
    linarith
  · rw [← intervalIntegral.integral_add_adjacent_intervals (intervalIntegrable_abs_errFun a b)
      (intervalIntegrable_abs_errFun b c)]
    linarith

/-- Weakening of a block bracket (used to round the constants). -/
theorem errIntBracket.mono {a b P0 P1 S P0' P1' S' : ℝ} (h : errIntBracket a b P0 P1 S)
    (h0 : P0' ≤ P0) (h1 : P1 ≤ P1') (h2 : S ≤ S') : errIntBracket a b P0' P1' S' :=
  ⟨le_trans h0 h.1, le_trans h.2.1 h1, le_trans h.2.2 h2⟩

/-! ## 2. The pointwise signed brackets on a piece -/

/-- From a two-sided bound on `Φ` to a two-sided bound on `err`. -/
theorem errFun_bracket_of_PhiErr {v Lo Hi : ℝ} (h0 : Lo ≤ PhiErr v) (h1 : PhiErr v ≤ Hi) :
    Lo * Real.exp (-(v / 2)) ≤ errFun v ∧ errFun v ≤ Hi * Real.exp (-(v / 2)) := by
  have hpos := Real.exp_pos (-(v / 2))
  rw [errFun_eq]
  constructor
  · nlinarith
  · nlinarith

/-- The integral of a constant multiple of `e^{-v/2}` over a piece, in the `q` variable. -/
theorem integral_const_mul_exp_neg_half {q0 q1 : ℝ} (h0 : 0 < q0) (h1 : 0 < q1) (K : ℝ) :
    (∫ v in (vBP q0)..(vBP q1), K * Real.exp (-(v / 2))) = 2 * K * (1 / q0 - 1 / q1) := by
  rw [intervalIntegral.integral_const_mul, intervalIntegral_exp_neg_half,
    exp_neg_half_vBP h0, exp_neg_half_vBP h1]
  ring

/-- The integral bracket for a piece, from the pointwise bracket. -/
theorem errIntBracket_of_pointwise {q0 q1 Lo Hi M : ℝ} (h0 : 0 < q0) (h01 : q0 ≤ q1)
    (hpt : ∀ v ∈ Icc (vBP q0) (vBP q1),
      Lo * Real.exp (-(v / 2)) ≤ errFun v ∧ errFun v ≤ Hi * Real.exp (-(v / 2)))
    (hM0 : -M ≤ Lo) (hM1 : Hi ≤ M) :
    errIntBracket (vBP q0) (vBP q1) (2 * Lo * (1 / q0 - 1 / q1)) (2 * Hi * (1 / q0 - 1 / q1))
      (2 * M * (1 / q0 - 1 / q1)) := by
  have h1 : (0:ℝ) < q1 := lt_of_lt_of_le h0 h01
  have hab : vBP q0 ≤ vBP q1 := vBP_mono h0 h01
  have hcont : IntervalIntegrable (fun v : ℝ => Real.exp (-(v / 2))) volume (vBP q0) (vBP q1) :=
    (by fun_prop : Continuous fun v : ℝ => Real.exp (-(v / 2))).intervalIntegrable _ _
  refine ⟨?_, ?_, ?_⟩
  · rw [← integral_const_mul_exp_neg_half h0 h1 Lo]
    exact intervalIntegral.integral_mono_on hab (hcont.const_mul Lo)
      (intervalIntegrable_errFun _ _) (fun v hv => (hpt v hv).1)
  · rw [← integral_const_mul_exp_neg_half h0 h1 Hi]
    exact intervalIntegral.integral_mono_on hab (intervalIntegrable_errFun _ _)
      (hcont.const_mul Hi) (fun v hv => (hpt v hv).2)
  · rw [← integral_const_mul_exp_neg_half h0 h1 M]
    refine intervalIntegral.integral_mono_on hab (intervalIntegrable_abs_errFun _ _)
      (hcont.const_mul M) (fun v hv => ?_)
    have hp := hpt v hv
    have hpos := (Real.exp_pos (-(v / 2))).le
    rw [abs_le]
    constructor
    · nlinarith [hp.1]
    · nlinarith [hp.2]

/-- **The signed bracket on a piece, Taylor version for the `b`-term.** -/
theorem errPiece_taylor {q0 q1 Lo Hi M : ℝ} (h1 : 1 ≤ q0) (h01 : q0 ≤ q1)
    (hHi : (q1 ^ 2 / (3.14159 * (1 + q1 ^ 2)))
          * (1.5708 + 1 / (6.28318 * (1 + q0 ^ 2)) + 1 / (6.28318 * (1 + q0 ^ 2)) ^ 2)
        + 2 * q1 ^ 2 * taylorQup (6.28318 * (q0 ^ 2 - 1)) - 1 - 2.11 / q1 ^ 5 ≤ Hi)
    (hLo : Lo ≤ (q0 ^ 2 / (3.1416 * (1 + q0 ^ 2)))
          * (1.5707 - 1 / (6.28318 * (1 + q0 ^ 2)) - 1 / (6.28318 * (1 + q0 ^ 2)) ^ 2)
        + 2 * q0 ^ 2 * taylorQ (6.2832 * (q1 ^ 2 - 1)) - 1 - 2.11 / q0 ^ 5)
    (hM0 : -M ≤ Lo) (hM1 : Hi ≤ M) :
    errIntBracket (vBP q0) (vBP q1) (2 * Lo * (1 / q0 - 1 / q1)) (2 * Hi * (1 / q0 - 1 / q1))
      (2 * M * (1 / q0 - 1 / q1)) := by
  have hq0 : (0:ℝ) < q0 := by linarith
  refine errIntBracket_of_pointwise hq0 h01 (fun v hv => ?_) hM0 hM1
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

/-- **The signed bracket on a piece, asymptotic version for the `b`-term.** -/
theorem errPiece_asymp {q0 q1 Lo Hi M : ℝ} (h1 : 1 < q0) (h01 : q0 ≤ q1)
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
        - 1 - 2.11 / q0 ^ 5)
    (hM0 : -M ≤ Lo) (hM1 : Hi ≤ M) :
    errIntBracket (vBP q0) (vBP q1) (2 * Lo * (1 / q0 - 1 / q1)) (2 * Hi * (1 / q0 - 1 / q1))
      (2 * M * (1 / q0 - 1 / q1)) := by
  have hq0 : (0:ℝ) < q0 := by linarith
  refine errIntBracket_of_pointwise hq0 h01 (fun v hv => ?_) hM0 hM1
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

/-! ## 3. The block estimate for the oscillatory integral -/

theorem errCos_block_ge {a b t C h P0 P1 S L : ℝ} (hab : a ≤ b)
    (hbr : errIntBracket a b P0 P1 S)
    (hcos : ∀ v, a ≤ v → v ≤ b → |Real.cos (t * v) - C| ≤ h) (hh : 0 ≤ h)
    (hL1 : L ≤ C * P0 - h * S) (hL2 : L ≤ C * P1 - h * S) :
    L ≤ ∫ v in a..b, errFun v * Real.cos (t * v) := by
  obtain ⟨h0, h1, h2⟩ := hbr
  set I : ℝ := ∫ v in a..b, errFun v with hI
  have hsplit : (∫ v in a..b, errFun v * Real.cos (t * v))
      = C * I + ∫ v in a..b, errFun v * (Real.cos (t * v) - C) := by
    have hd : (∫ v in a..b, errFun v * (Real.cos (t * v) - C))
        = (∫ v in a..b, errFun v * Real.cos (t * v)) - ∫ v in a..b, C * errFun v := by
      rw [← intervalIntegral.integral_sub (intervalIntegrable_errFun_mul_cos t a b)
        ((intervalIntegrable_errFun a b).const_mul C)]
      exact intervalIntegral.integral_congr fun v _ => by ring
    rw [hd, intervalIntegral.integral_const_mul, hI]
    ring
  have hrem : |∫ v in a..b, errFun v * (Real.cos (t * v) - C)| ≤ h * S := by
    have hbound : |∫ v in a..b, errFun v * (Real.cos (t * v) - C)|
        ≤ ∫ v in a..b, h * |errFun v| := by
      have h1' : |∫ v in a..b, errFun v * (Real.cos (t * v) - C)|
          ≤ ∫ v in a..b, |errFun v * (Real.cos (t * v) - C)| := by
        simpa [Real.norm_eq_abs] using
          intervalIntegral.abs_integral_le_integral_abs (μ := volume) (f := fun v =>
            errFun v * (Real.cos (t * v) - C)) hab
      have hcint : IntervalIntegrable (fun v => |errFun v * (Real.cos (t * v) - C)|)
          volume a b :=
        ((continuous_errFun.mul ((by fun_prop : Continuous fun v : ℝ =>
          Real.cos (t * v)).sub continuous_const)).abs).intervalIntegrable a b
      refine h1'.trans (intervalIntegral.integral_mono_on hab hcint
        ((intervalIntegrable_abs_errFun a b).const_mul h) (fun v hv => ?_))
      rw [abs_mul, mul_comm h |errFun v|]
      exact mul_le_mul_of_nonneg_left (hcos v hv.1 hv.2) (abs_nonneg _)
    have hSint : (∫ v in a..b, h * |errFun v|) ≤ h * S := by
      rw [intervalIntegral.integral_const_mul]
      exact mul_le_mul_of_nonneg_left h2 hh
    linarith
  have hmin : min (C * P0) (C * P1) ≤ C * I := by
    rcases le_total 0 C with hC | hC
    · exact le_trans (min_le_left _ _) (mul_le_mul_of_nonneg_left h0 hC)
    · exact le_trans (min_le_right _ _) (by nlinarith)
  have hminL : L + h * S ≤ min (C * P0) (C * P1) := le_min (by linarith) (by linarith)
  have := neg_abs_le (∫ v in a..b, errFun v * (Real.cos (t * v) - C))
  rw [hsplit]
  linarith

/-! ## 4. Rational brackets for `cos` -/

/-- The degree-10 Taylor minorant of `cos` on `[0,∞)`. -/
def cosLoP (y : ℝ) : ℝ :=
  1 - y ^ 2 / 2 + y ^ 4 / 24 - y ^ 6 / 720 + y ^ 8 / 40320 - y ^ 10 / 3628800

/-- The degree-8 Taylor majorant of `cos` on `[0,∞)`. -/
def cosHiP (y : ℝ) : ℝ := 1 - y ^ 2 / 2 + y ^ 4 / 24 - y ^ 6 / 720 + y ^ 8 / 40320

/-- The degree-11 Taylor minorant of `sin` on `[0,∞)`. -/
def sinLoP (y : ℝ) : ℝ :=
  y - y ^ 3 / 6 + y ^ 5 / 120 - y ^ 7 / 5040 + y ^ 9 / 362880 - y ^ 11 / 39916800

/-- The degree-9 Taylor majorant of `sin` on `[0,∞)`. -/
def sinHiP (y : ℝ) : ℝ := y - y ^ 3 / 6 + y ^ 5 / 120 - y ^ 7 / 5040 + y ^ 9 / 362880

theorem cosLoP_le_cos {y : ℝ} (hy : 0 ≤ y) : cosLoP y ≤ Real.cos y := by
  have h := (taylor_sign (n := 6) (by norm_num) hy).1
  rw [show ((-1:ℝ) ^ 6) = 1 by norm_num, one_mul] at h
  have hc : cosPart 6 y = cosLoP y := by
    simp only [cosPart, cosLoP, Finset.sum_range_succ, Finset.sum_range_zero]
    norm_num [Nat.factorial]
    ring
  linarith [hc ▸ h]

theorem cos_le_cosHiP {y : ℝ} (hy : 0 ≤ y) : Real.cos y ≤ cosHiP y := by
  have h := (taylor_sign (n := 5) (by norm_num) hy).1
  rw [show ((-1:ℝ) ^ 5) = -1 by norm_num] at h
  have hc : cosPart 5 y = cosHiP y := by
    simp only [cosPart, cosHiP, Finset.sum_range_succ, Finset.sum_range_zero]
    norm_num [Nat.factorial]
    ring
  rw [← hc]; linarith

theorem sinLoP_le_sin {y : ℝ} (hy : 0 ≤ y) : sinLoP y ≤ Real.sin y := by
  have h := (taylor_sign (n := 6) (by norm_num) hy).2
  rw [show ((-1:ℝ) ^ 6) = 1 by norm_num, one_mul] at h
  have hc : sinPart 6 y = sinLoP y := by
    simp only [sinPart, sinLoP, Finset.sum_range_succ, Finset.sum_range_zero]
    norm_num [Nat.factorial]
    ring
  linarith [hc ▸ h]

theorem sin_le_sinHiP {y : ℝ} (hy : 0 ≤ y) : Real.sin y ≤ sinHiP y := by
  have h := (taylor_sign (n := 5) (by norm_num) hy).2
  rw [show ((-1:ℝ) ^ 5) = -1 by norm_num] at h
  have hc : sinPart 5 y = sinHiP y := by
    simp only [sinPart, sinHiP, Finset.sum_range_succ, Finset.sum_range_zero]
    norm_num [Nat.factorial]
    ring
  rw [← hc]; linarith

/-- `cos` is antitone on `[0, π/2]`, in the form used below. -/
theorem cos_le_cos_of_le {x y : ℝ} (hx : 0 ≤ x) (hxy : x ≤ y) (hy : y ≤ π / 2) :
    Real.cos y ≤ Real.cos x :=
  Real.cos_le_cos_of_nonneg_of_le_pi hx (by linarith [Real.pi_pos]) hxy

/-- `sin` is monotone on `[0, π/2]`, in the form used below. -/
theorem sin_le_sin_of_le {x y : ℝ} (hx : 0 ≤ x) (hxy : x ≤ y) (hy : y ≤ π / 2) :
    Real.sin x ≤ Real.sin y := by
  have h : Real.sin x ≤ Real.sin y :=
    Real.sin_le_sin_of_le_of_le_pi_div_two (by linarith [Real.pi_pos]) hy hxy
  exact h

/-- **Bracket for `cos X`, residue `0`**: `X = y + 2πm` with `y ∈ [0, π/2]`. -/
theorem cos_bracket_case0 {X ylo yhi : ℝ} {m : ℤ} (hy0 : 0 ≤ ylo) (hyhi : yhi ≤ π / 2)
    (h1 : ylo ≤ X - m * (2 * π)) (h2 : X - m * (2 * π) ≤ yhi) :
    cosLoP yhi ≤ Real.cos X ∧ Real.cos X ≤ cosHiP ylo := by
  set y := X - m * (2 * π) with hy
  have hX : Real.cos X = Real.cos y := by
    have hs : y = X + ((-m : ℤ) : ℝ) * (2 * π) := by rw [hy]; push_cast; ring
    rw [hs, Real.cos_add_int_mul_two_pi]
  have hylo : 0 ≤ y := le_trans hy0 h1
  constructor
  · rw [hX]
    exact le_trans (cosLoP_le_cos (le_trans hylo h2)) (cos_le_cos_of_le hylo h2 hyhi)
  · rw [hX]
    exact le_trans (cos_le_cos_of_le hy0 h1 (le_trans h2 hyhi)) (cos_le_cosHiP hy0)

/-- **Bracket for `cos X`, residue `1`**: `X = y + π/2 + 2πm`, so `cos X = -sin y`. -/
theorem cos_bracket_case1 {X ylo yhi : ℝ} {m : ℤ} (hy0 : 0 ≤ ylo) (hyhi : yhi ≤ π / 2)
    (h1 : ylo ≤ X - π / 2 - m * (2 * π)) (h2 : X - π / 2 - m * (2 * π) ≤ yhi) :
    -sinHiP yhi ≤ Real.cos X ∧ Real.cos X ≤ -sinLoP ylo := by
  set y := X - π / 2 - m * (2 * π) with hy
  have hX : Real.cos X = -Real.sin y := by
    have hs : X = (y + π / 2) + (m : ℝ) * (2 * π) := by rw [hy]; ring
    rw [hs, Real.cos_add_int_mul_two_pi, Real.cos_add_pi_div_two]
  have hylo : 0 ≤ y := le_trans hy0 h1
  have hyhi' : y ≤ π / 2 := le_trans h2 hyhi
  constructor
  · rw [hX]
    have := sin_le_sinHiP (le_trans hylo h2)
    have h3 := sin_le_sin_of_le hylo h2 hyhi
    linarith
  · rw [hX]
    have := sinLoP_le_sin hy0
    have h3 := sin_le_sin_of_le hy0 h1 hyhi'
    linarith

/-- **Bracket for `cos X`, residue `2`**: `X = y + π + 2πm`, so `cos X = -cos y`. -/
theorem cos_bracket_case2 {X ylo yhi : ℝ} {m : ℤ} (hy0 : 0 ≤ ylo) (hyhi : yhi ≤ π / 2)
    (h1 : ylo ≤ X - π - m * (2 * π)) (h2 : X - π - m * (2 * π) ≤ yhi) :
    -cosHiP ylo ≤ Real.cos X ∧ Real.cos X ≤ -cosLoP yhi := by
  set y := X - π - m * (2 * π) with hy
  have hX : Real.cos X = -Real.cos y := by
    have hs : X = (y + π) + (m : ℝ) * (2 * π) := by rw [hy]; ring
    rw [hs, Real.cos_add_int_mul_two_pi, Real.cos_add_pi]
  have hylo : 0 ≤ y := le_trans hy0 h1
  constructor
  · rw [hX]
    have := cos_le_cosHiP hy0
    have h3 := cos_le_cos_of_le hy0 h1 (le_trans h2 hyhi)
    linarith
  · rw [hX]
    have := cosLoP_le_cos (le_trans hylo h2)
    have h3 := cos_le_cos_of_le hylo h2 hyhi
    linarith

/-- **Bracket for `cos X`, residue `3`**: `X = y + 3π/2 + 2πm`, so `cos X = sin y`. -/
theorem cos_bracket_case3 {X ylo yhi : ℝ} {m : ℤ} (hy0 : 0 ≤ ylo) (hyhi : yhi ≤ π / 2)
    (h1 : ylo ≤ X - 3 * π / 2 - m * (2 * π)) (h2 : X - 3 * π / 2 - m * (2 * π) ≤ yhi) :
    sinLoP ylo ≤ Real.cos X ∧ Real.cos X ≤ sinHiP yhi := by
  set y := X - 3 * π / 2 - m * (2 * π) with hy
  have hX : Real.cos X = Real.sin y := by
    have hs : X = (y - π / 2) + ((m + 1 : ℤ) : ℝ) * (2 * π) := by
      rw [hy]; push_cast; ring
    rw [hs, Real.cos_add_int_mul_two_pi, Real.cos_sub_pi_div_two]
  have hylo : 0 ≤ y := le_trans hy0 h1
  have hyhi' : y ≤ π / 2 := le_trans h2 hyhi
  constructor
  · rw [hX]
    have := sinLoP_le_sin hy0
    have h3 := sin_le_sin_of_le hy0 h1 hyhi'
    linarith
  · rw [hX]
    have := sin_le_sinHiP (le_trans hylo h2)
    have h3 := sin_le_sin_of_le hylo h2 hyhi
    linarith

/-- Transfer of a bracket at a rational point to a neighbourhood, by the Lipschitz property
of `cos` (and the trivial bounds `-1 ≤ cos ≤ 1`). -/
theorem abs_cos_sub_le_of_bracket {x X clo chi C h rho : ℝ}
    (hx : |x - X| ≤ rho) (hlo : clo ≤ Real.cos X) (hhi : Real.cos X ≤ chi)
    (h1 : C - h ≤ max (clo - rho) (-1)) (h2 : min (chi + rho) 1 ≤ C + h) :
    |Real.cos x - C| ≤ h := by
  have hlip0 : |Real.cos x - Real.cos X| ≤ |x - X| := by
    have := Real.lipschitzWith_cos.dist_le_mul x X
    simpa [Real.dist_eq, NNReal.coe_one, one_mul] using this
  have hlip : |Real.cos x - Real.cos X| ≤ rho := le_trans hlip0 hx
  rw [abs_le] at hlip
  have hge : max (clo - rho) (-1) ≤ Real.cos x :=
    max_le_iff.2 ⟨by linarith [hlip.1], Real.neg_one_le_cos x⟩
  have hle : Real.cos x ≤ min (chi + rho) 1 :=
    le_min (by linarith [hlip.2]) (Real.cos_le_one x)
  rw [abs_le]
  constructor <;> linarith

/-- **The block estimate in fully rational form**, ready to be applied to numerical data. -/
theorem errCos_block_ge_rat {q0 q1 t t0 t1 A B X rho clo chi C h P0 P1 S L : ℝ}
    (hq0 : 0 < q0) (hq01 : q0 ≤ q1)
    (hbr : errIntBracket (vBP q0) (vBP q1) P0 P1 S)
    (hA : A ≤ vBP q0) (hB : vBP q1 ≤ B) (hA0 : 0 ≤ A)
    (ht0 : t0 ≤ t) (ht1 : t ≤ t1) (ht00 : 0 ≤ t0)
    (hlo : clo ≤ Real.cos X) (hhi : Real.cos X ≤ chi)
    (hx0 : X - rho ≤ t0 * A) (hx1 : t1 * B ≤ X + rho)
    (hc1 : C - h ≤ max (clo - rho) (-1)) (hc2 : min (chi + rho) 1 ≤ C + h)
    (hh : 0 ≤ h) (hL1 : L ≤ C * P0 - h * S) (hL2 : L ≤ C * P1 - h * S) :
    L ≤ ∫ v in (vBP q0)..(vBP q1), errFun v * Real.cos (t * v) := by
  refine errCos_block_ge (vBP_mono hq0 hq01) hbr (fun v hv1 hv2 => ?_) hh hL1 hL2
  have hv1' : A ≤ v := le_trans hA hv1
  have hv2' : v ≤ B := le_trans hv2 hB
  have htnn : 0 ≤ t := le_trans ht00 ht0
  have hmul1 : t0 * A ≤ t * v := mul_le_mul ht0 hv1' hA0 htnn
  have hmul2 : t * v ≤ t1 * B := mul_le_mul ht1 hv2' (le_trans hA0 hv1') (le_trans htnn ht1)
  have hx : |t * v - X| ≤ rho := by
    rw [abs_le]
    constructor <;> linarith
  exact abs_cos_sub_le_of_bracket hx hlo hhi hc1 hc2

/-- Additivity of the oscillatory integral over adjacent blocks. -/
theorem errCos_add_adjacent (t a b c : ℝ) :
    (∫ v in a..b, errFun v * Real.cos (t * v)) + (∫ v in b..c, errFun v * Real.cos (t * v))
      = ∫ v in a..c, errFun v * Real.cos (t * v) :=
  intervalIntegral.integral_add_adjacent_intervals (intervalIntegrable_errFun_mul_cos t a b)
    (intervalIntegrable_errFun_mul_cos t b c)

/-- Two adjacent block estimates combine. -/
theorem errCos_add_ge {t a b c L1 L2 : ℝ}
    (h1 : L1 ≤ ∫ v in a..b, errFun v * Real.cos (t * v))
    (h2 : L2 ≤ ∫ v in b..c, errFun v * Real.cos (t * v)) :
    L1 + L2 ≤ ∫ v in a..c, errFun v * Real.cos (t * v) := by
  rw [← errCos_add_adjacent t a b c]
  linarith

/-! ## 5. Rational brackets for the breakpoints `vBP q = 2 log q` -/

/-- A rational bracket for `vBP q = 2 log q`, from the logarithmic series at `x = 1 - 1/q`. -/
theorem vBP_bracket (n : ℕ) {q : ℝ} (hq : 1 ≤ q) :
    |vBP q - 2 * ∑ i ∈ Finset.range n, ((q - 1) / q) ^ (i + 1) / (i + 1)|
      ≤ 2 * (((q - 1) / q) ^ (n + 1) / (1 - (q - 1) / q)) := by
  have hq0 : (0:ℝ) < q := by linarith
  set x : ℝ := (q - 1) / q with hx
  have hx0 : 0 ≤ x := by rw [hx]; exact div_nonneg (by linarith) (by linarith)
  have hx1 : x < 1 := by
    rw [hx, div_lt_one hq0]; linarith
  have habs : |x| = x := abs_of_nonneg hx0
  have hone : 1 - x = 1 / q := by rw [hx]; field_simp; ring
  have hlog : Real.log (1 - x) = -Real.log q := by
    rw [hone, Real.log_div one_ne_zero (ne_of_gt hq0), Real.log_one]
    ring
  have h := Real.abs_log_sub_add_sum_range_le (x := x) (by rw [habs]; exact hx1) n
  rw [hlog, habs] at h
  have hv : vBP q = 2 * Real.log q := rfl
  rw [hv]
  have := abs_le.1 h
  rw [abs_le]
  constructor <;> [linarith [this.1, this.2]; linarith [this.1, this.2]]

/-! ## 6. The bridge back to `δ̂` -/

/-- **The Pólya lower bound with the oscillatory integral retained**: if
`η ≤ ∫₀^∞ err(v) cos(tv) dv` then `δ̂(t) ≥ 2ĥ(t) + 2η`. -/
theorem deltaFourier_ge_of_cos_bound {t η : ℝ}
    (hη : η ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v)) :
    2 * ((1/2) / ((1/2) ^ 2 + t ^ 2) + 2.11 * (3 / (3 ^ 2 + t ^ 2))) + 2 * η
      ≤ deltaFourier t := by
  have hsplit : ∀ v : ℝ, deltaLogAux v * Real.cos (t * v)
      = expModel v * Real.cos (t * v) + errFun v * Real.cos (t * v) := by
    intro v; unfold errFun; ring
  have hmodel := integral_Ioi_expModel_cos t
  have hint : (∫ v in Ioi (0:ℝ), deltaLogAux v * Real.cos (t * v))
      = (∫ v in Ioi (0:ℝ), expModel v * Real.cos (t * v))
        + ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
    rw [setIntegral_congr_fun measurableSet_Ioi (fun v _ => hsplit v)]
    exact integral_add (integrableOn_expModel_mul_cos t) (integrableOn_errFun_mul_cos t)
  rw [deltaFourier_eq_two_mul_integral_Ioi, hint, hmodel]
  linarith

/-- Splitting of the oscillatory integral at a point `c > 0`. -/
theorem integral_Ioi_errFun_cos_split (t : ℝ) {c : ℝ} (hc : 0 ≤ c) :
    (∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v))
      = (∫ v in (0:ℝ)..c, errFun v * Real.cos (t * v))
        + ∫ v in Ioi c, errFun v * Real.cos (t * v) := by
  have hint : IntegrableOn (fun v => errFun v * Real.cos (t * v)) (Ioi (0:ℝ)) volume :=
    integrableOn_errFun_mul_cos t
  have hunion : Ioc (0:ℝ) c ∪ Ioi c = Ioi (0:ℝ) := Ioc_union_Ioi_eq_Ioi hc
  have h1 : IntegrableOn (fun v => errFun v * Real.cos (t * v)) (Ioc (0:ℝ) c) volume :=
    IntegrableOn.mono_set hint (fun x hx => hx.1)
  have h2 : IntegrableOn (fun v => errFun v * Real.cos (t * v)) (Ioi c) volume :=
    IntegrableOn.mono_set hint (Ioi_subset_Ioi hc)
  have hdisj : Disjoint (Ioc (0:ℝ) c) (Ioi c) := by
    rw [Set.disjoint_left]
    intro x hx hx'
    exact absurd hx.2 (not_le.2 hx')
  rw [← hunion, setIntegral_union hdisj measurableSet_Ioi h1 h2,
    intervalIntegral.integral_of_le hc]

/-- The tail of the oscillatory integral is controlled by the tail of `∫|err|`. -/
theorem abs_integral_Ioi_errFun_cos_le {t c S : ℝ} (hc : 0 ≤ c)
    (hS : (∫ v in Ioi c, |errFun v|) ≤ S) :
    |∫ v in Ioi c, errFun v * Real.cos (t * v)| ≤ S := by
  have hint : IntegrableOn (fun v => errFun v * Real.cos (t * v)) (Ioi c) volume :=
    IntegrableOn.mono_set (integrableOn_errFun_mul_cos t) (Ioi_subset_Ioi hc)
  have habs : IntegrableOn (fun v => |errFun v|) (Ioi c) volume :=
    IntegrableOn.mono_set integrableOn_errFun.abs (Ioi_subset_Ioi hc)
  refine le_trans (abs_integral_le_integral_abs) (le_trans ?_ hS)
  refine setIntegral_mono_on hint.abs habs measurableSet_Ioi (fun v _ => ?_)
  rw [abs_mul]
  nlinarith [Real.abs_cos_le_one (t * v), abs_nonneg (errFun v), abs_nonneg (Real.cos (t * v))]

/-! ## 7. Evenness of the Fourier side -/

/-- `δ̂` is even. -/
theorem deltaFourier_abs (t : ℝ) : deltaFourier |t| = deltaFourier t := by
  rcases abs_choice t with h | h
  · rw [h]
  · rw [h]
    simp only [deltaFourier, neg_mul, Real.cos_neg]

/-- `f(t) = 2θ'(t) + δ̂(t)` is even. -/
theorem fourierSide_abs (t : ℝ) : fourierSide |t| = fourierSide t := by
  simp only [fourierSide, thetaDeriv_abs, deltaFourier_abs]

end ConnesConsani.WeilPositivity
