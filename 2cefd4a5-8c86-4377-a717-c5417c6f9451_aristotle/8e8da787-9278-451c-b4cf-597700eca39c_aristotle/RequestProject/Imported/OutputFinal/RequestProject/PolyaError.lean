/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The certified L¹ bound for the error of the Pólya model of
`RequestProject/PolyaModel.lean`:

  `∫₀^∞ |δ(e^v) - h(v)| dv ≤ ε`,   `h(v) = e^{-v/2} + 2.11 e^{-3v}`.

Writing `q = e^{v/2}`, `r = q²` and

  `Φ(v) = e^{v/2}(δ(e^v) - h(v)) = 2r(σ(a) + σ(b)) - 1 - 2.11 q^{-5}`,
  `σ(x) = Si(x)/x`,  `a = 2π(1+r)`,  `b = 2π(r-1)`,

a bound `|Φ| ≤ M` on a `q`-interval `[q₀,q₁]` integrates to
`∫ |δ(e^v) - h(v)| ≤ 2M(1/q₀ - 1/q₁)` (this is the architecture of
`RequestProject/DeltaVariation.lean`).  The two terms `2rσ(a)`, `2rσ(b)` are bracketed on
each interval by

* the asymptotic bracket `|Si(x) - π/2| ≤ 1/x + 1/x²` together with the monotonicity of the
  prefactors `r/(π(1+r))` (increasing) and `r/(π(r-1))` (decreasing), and
* for the `b`-term near `r = 1`, the Taylor brackets `taylorQ ≤ σ ≤ taylorQup` evaluated at
  a rational point, which are transported to the whole interval by the antitonicity of `σ`
  (`siDiv_antitoneOn` of `RequestProject/SiDivMono.lean`).

The partition itself, and the resulting certified value `ε ≤ 0.2153`
(`integral_Ioi_abs_errFun_le`), are in `RequestProject/PolyaPartition1.lean` and
`RequestProject/PolyaPartition2.lean`.  The true value is `≈ 0.1741`.
-/
import RequestProject.Imported.OutputFinal.RequestProject.SiDivMono
import RequestProject.Imported.OutputFinal.RequestProject.PolyaModel

noncomputable section

open MeasureTheory Set Real Filter Topology

namespace ConnesConsani.WeilPositivity

/-! ## 1. The rescaled error `Φ` -/

/-- The rescaled error `Φ(v) = e^{v/2}(δ(e^v) - h(v))`. -/
def PhiErr (v : ℝ) : ℝ :=
  2 * Real.exp v * (siDiv (uPlus v) + siDiv (uMinus v)) - 1 - 2.11 * Real.exp (-(5 * v / 2))

theorem errFun_eq (v : ℝ) : errFun v = Real.exp (-(v / 2)) * PhiErr v := by
  have h1 : Real.exp (-(v / 2)) * Real.exp v = Real.exp (v / 2) := by
    rw [← Real.exp_add]; ring_nf
  have h2 : Real.exp (-(v / 2)) * Real.exp (-(5 * v / 2)) = Real.exp (-(3 * v)) := by
    rw [← Real.exp_add]; ring_nf
  unfold errFun expModel PhiErr
  rw [deltaLogAux_eq, show uPlus v = 2 * π * (1 + Real.exp v) from rfl,
    show uMinus v = 2 * π * (Real.exp v - 1) from rfl]
  linear_combination
    (-2 * (siDiv (2 * π * (1 + Real.exp v)) + siDiv (2 * π * (Real.exp v - 1)))) * h1
    + (211 / 100 : ℝ) * h2

theorem abs_errFun_le_of_PhiErr {v M : ℝ} (h : |PhiErr v| ≤ M) :
    |errFun v| ≤ M * Real.exp (-(v / 2)) := by
  rw [errFun_eq, abs_mul, abs_of_pos (Real.exp_pos _)]
  nlinarith [mul_le_mul_of_nonneg_left h (Real.exp_pos (-(v / 2))).le]

/-! ## 2. The two terms of `Φ` on an interval -/

/-- Upper bound for `2 e^v σ(2π(1+e^v))`. -/
theorem term_a_le {v r0 r1 : ℝ} (h0 : 1 ≤ r0) (hr0 : r0 ≤ Real.exp v) (hr1 : Real.exp v ≤ r1) :
    2 * Real.exp v * siDiv (uPlus v)
      ≤ (r1 / (3.14159 * (1 + r1)))
        * (1.5708 + 1 / (6.28318 * (1 + r0)) + 1 / (6.28318 * (1 + r0)) ^ 2) := by
  have hpi1 : (3.14159:ℝ) < π := by linarith [Real.pi_gt_d6]
  set r := Real.exp v with hrdef
  have hr : 1 ≤ r := le_trans h0 hr0
  have hr1' : 1 ≤ r1 := le_trans hr hr1
  set a : ℝ := 2 * π * (1 + r) with ha
  have hapos : (0:ℝ) < a := by rw [ha]; nlinarith
  have hA0pos : (0:ℝ) < 6.28318 * (1 + r0) := by nlinarith
  have hA0 : 6.28318 * (1 + r0) ≤ a := by rw [ha]; nlinarith
  have hSi : Si a ≤ 1.5708 + 1 / (6.28318 * (1 + r0)) + 1 / (6.28318 * (1 + r0)) ^ 2 :=
    Si_le_rat hA0pos hA0
  have hSinn : 0 ≤ Si a := Si_nonneg hapos.le
  have hfac : 2 * r / a ≤ r1 / (3.14159 * (1 + r1)) := by
    rw [ha, div_le_div_iff₀ (by positivity) (by positivity)]
    have t1 : (0:ℝ) ≤ (π - 3.14159) * (r1 * (1 + r)) := by
      apply mul_nonneg (by linarith); nlinarith
    nlinarith [t1, hr1]
  have heq : 2 * r * siDiv (uPlus v) = (2 * r / a) * Si a := by
    rw [show uPlus v = a from rfl, siDiv_of_ne_zero (ne_of_gt hapos)]
    field_simp
  rw [heq]
  exact mul_le_mul hfac hSi hSinn (by positivity)

/-- Lower bound for `2 e^v σ(2π(1+e^v))`. -/
theorem term_a_ge {v r0 : ℝ} (h0 : 1 ≤ r0) (hr0 : r0 ≤ Real.exp v) :
    (r0 / (3.1416 * (1 + r0)))
        * (1.5707 - 1 / (6.28318 * (1 + r0)) - 1 / (6.28318 * (1 + r0)) ^ 2)
      ≤ 2 * Real.exp v * siDiv (uPlus v) := by
  have hpi1 : (3.14159:ℝ) < π := by linarith [Real.pi_gt_d6]
  have hpi2 : π < 3.1416 := by linarith [Real.pi_lt_d6]
  set r := Real.exp v with hrdef
  have hr : 1 ≤ r := le_trans h0 hr0
  set a : ℝ := 2 * π * (1 + r) with ha
  have hapos : (0:ℝ) < a := by rw [ha]; nlinarith
  have hA0pos : (0:ℝ) < 6.28318 * (1 + r0) := by nlinarith
  have hA0 : 6.28318 * (1 + r0) ≤ a := by rw [ha]; nlinarith
  have hSi : 1.5707 - 1 / (6.28318 * (1 + r0)) - 1 / (6.28318 * (1 + r0)) ^ 2 ≤ Si a :=
    Si_ge_rat hA0pos hA0
  have hSnn : (0:ℝ) ≤ 1.5707 - 1 / (6.28318 * (1 + r0)) - 1 / (6.28318 * (1 + r0)) ^ 2 := by
    have hb1 : 1 / (6.28318 * (1 + r0)) ≤ 1 / 12.56636 := by
      apply one_div_le_one_div_of_le (by norm_num); nlinarith
    have hb2 : 1 / (6.28318 * (1 + r0)) ^ 2 ≤ 1 / 12.56636 ^ 2 := by
      apply one_div_le_one_div_of_le (by norm_num); nlinarith
    norm_num at hb1 hb2 ⊢
    linarith
  have hfac : r0 / (3.1416 * (1 + r0)) ≤ 2 * r / a := by
    rw [ha, div_le_div_iff₀ (by positivity) (by positivity)]
    have t1 : (0:ℝ) ≤ (3.1416 - π) * (r * (1 + r0)) := by
      apply mul_nonneg (by linarith); nlinarith
    nlinarith [t1, hr0, Real.pi_pos]
  have heq : 2 * r * siDiv (uPlus v) = (2 * r / a) * Si a := by
    rw [show uPlus v = a from rfl, siDiv_of_ne_zero (ne_of_gt hapos)]
    field_simp
  rw [heq]
  exact mul_le_mul hfac hSi hSnn (by positivity)

/-- Upper bound for `2 e^v σ(2π(e^v-1))` by the Taylor bracket at a rational point. -/
theorem term_b_le_taylor {v r0 r1 : ℝ} (h0 : 1 ≤ r0) (hr0 : r0 ≤ Real.exp v)
    (hr1 : Real.exp v ≤ r1) :
    2 * Real.exp v * siDiv (uMinus v) ≤ 2 * r1 * taylorQup (6.28318 * (r0 - 1)) := by
  have hpi1 : (3.14159:ℝ) < π := by linarith [Real.pi_gt_d6]
  set r := Real.exp v with hrdef
  have hr : 1 ≤ r := le_trans h0 hr0
  have hB0 : (0:ℝ) ≤ 6.28318 * (r0 - 1) := by nlinarith
  have hble : 6.28318 * (r0 - 1) ≤ uMinus v := by
    rw [uMinus, ← hrdef]; nlinarith
  have hle1 : siDiv (uMinus v) ≤ siDiv (6.28318 * (r0 - 1)) := siDiv_le_siDiv_of_le hB0 hble
  have hle2 : siDiv (6.28318 * (r0 - 1)) ≤ taylorQup (6.28318 * (r0 - 1)) :=
    siDiv_le_taylorQup hB0
  have hpos : 0 < siDiv (uMinus v) := siDiv_pos _
  nlinarith [hpos, hr1, hr]

/-- Lower bound for `2 e^v σ(2π(e^v-1))` by the Taylor bracket at a rational point. -/
theorem term_b_ge_taylor {v r0 r1 : ℝ} (h0 : 1 ≤ r0) (hr0 : r0 ≤ Real.exp v)
    (hr1 : Real.exp v ≤ r1) :
    2 * r0 * taylorQ (6.2832 * (r1 - 1)) ≤ 2 * Real.exp v * siDiv (uMinus v) := by
  have hpi2 : π < 3.1416 := by linarith [Real.pi_lt_d6]
  set r := Real.exp v with hrdef
  have hr : 1 ≤ r := le_trans h0 hr0
  have hr1' : 1 ≤ r1 := le_trans hr hr1
  have hB1 : (0:ℝ) ≤ 6.2832 * (r1 - 1) := by nlinarith
  have hbge : uMinus v ≤ 6.2832 * (r1 - 1) := by
    rw [uMinus, ← hrdef]; nlinarith
  have hmnn : (0:ℝ) ≤ uMinus v := by rw [uMinus, ← hrdef]; nlinarith [Real.pi_pos]
  have hge1 : siDiv (6.2832 * (r1 - 1)) ≤ siDiv (uMinus v) := siDiv_le_siDiv_of_le hmnn hbge
  have hge2 : taylorQ (6.2832 * (r1 - 1)) ≤ siDiv (6.2832 * (r1 - 1)) := siDiv_ge_taylorQ hB1
  have hpos : 0 < siDiv (uMinus v) := siDiv_pos _
  nlinarith [hpos, hr0, h0]

/-- Upper bound for `2 e^v σ(2π(e^v-1))` by the asymptotics of `Si`. -/
theorem term_b_le_asymp {v r0 : ℝ} (h0 : 1 < r0) (hr0 : r0 ≤ Real.exp v) :
    2 * Real.exp v * siDiv (uMinus v)
      ≤ (r0 / (3.14159 * (r0 - 1)))
        * (1.5708 + 1 / (6.28318 * (r0 - 1)) + 1 / (6.28318 * (r0 - 1)) ^ 2) := by
  have hpi1 : (3.14159:ℝ) < π := by linarith [Real.pi_gt_d6]
  set r := Real.exp v with hrdef
  have hr : 1 < r := lt_of_lt_of_le h0 hr0
  set b : ℝ := 2 * π * (r - 1) with hb
  have hbpos : (0:ℝ) < b := by rw [hb]; nlinarith [Real.pi_pos]
  have hB0pos : (0:ℝ) < 6.28318 * (r0 - 1) := by nlinarith
  have hB0 : 6.28318 * (r0 - 1) ≤ b := by rw [hb]; nlinarith
  have hSi : Si b ≤ 1.5708 + 1 / (6.28318 * (r0 - 1)) + 1 / (6.28318 * (r0 - 1)) ^ 2 :=
    Si_le_rat hB0pos hB0
  have hSinn : 0 ≤ Si b := Si_nonneg hbpos.le
  have hfac : 2 * r / b ≤ r0 / (3.14159 * (r0 - 1)) := by
    rw [hb, div_le_div_iff₀ (by nlinarith [Real.pi_pos]) (by nlinarith)]
    have t1 : (0:ℝ) ≤ (π - 3.14159) * (r0 * (r - 1)) := by
      apply mul_nonneg (by linarith); nlinarith
    nlinarith [t1, hr0]
  have heq : 2 * r * siDiv (uMinus v) = (2 * r / b) * Si b := by
    rw [show uMinus v = b from rfl, siDiv_of_ne_zero (ne_of_gt hbpos)]
    field_simp
  rw [heq]
  refine mul_le_mul hfac hSi hSinn ?_
  apply div_nonneg <;> nlinarith

/-- Lower bound for `2 e^v σ(2π(e^v-1))` by the asymptotics of `Si`. -/
theorem term_b_ge_asymp {v r0 r1 : ℝ} (h0 : 1 < r0) (hr0 : r0 ≤ Real.exp v)
    (hr1 : Real.exp v ≤ r1)
    (hnn : (0:ℝ) ≤ 1.5707 - 1 / (6.28318 * (r0 - 1)) - 1 / (6.28318 * (r0 - 1)) ^ 2) :
    (r1 / (3.1416 * (r1 - 1)))
        * (1.5707 - 1 / (6.28318 * (r0 - 1)) - 1 / (6.28318 * (r0 - 1)) ^ 2)
      ≤ 2 * Real.exp v * siDiv (uMinus v) := by
  have hpi1 : (3.14159:ℝ) < π := by linarith [Real.pi_gt_d6]
  have hpi2 : π < 3.1416 := by linarith [Real.pi_lt_d6]
  set r := Real.exp v with hrdef
  have hr : 1 < r := lt_of_lt_of_le h0 hr0
  have hr1' : 1 < r1 := lt_of_lt_of_le hr hr1
  set b : ℝ := 2 * π * (r - 1) with hb
  have hbpos : (0:ℝ) < b := by rw [hb]; nlinarith [Real.pi_pos]
  have hB0pos : (0:ℝ) < 6.28318 * (r0 - 1) := by nlinarith
  have hB0 : 6.28318 * (r0 - 1) ≤ b := by rw [hb]; nlinarith
  have hSi : 1.5707 - 1 / (6.28318 * (r0 - 1)) - 1 / (6.28318 * (r0 - 1)) ^ 2 ≤ Si b :=
    Si_ge_rat hB0pos hB0
  have hfac : r1 / (3.1416 * (r1 - 1)) ≤ 2 * r / b := by
    rw [hb, div_le_div_iff₀ (by nlinarith) (by nlinarith [Real.pi_pos])]
    have t1 : (0:ℝ) ≤ (3.1416 - π) * (r * (r1 - 1)) := by
      apply mul_nonneg (by linarith); nlinarith
    nlinarith [t1, hr1, Real.pi_pos]
  have heq : 2 * r * siDiv (uMinus v) = (2 * r / b) * Si b := by
    rw [show uMinus v = b from rfl, siDiv_of_ne_zero (ne_of_gt hbpos)]
    field_simp
  rw [heq]
  refine mul_le_mul hfac hSi hnn ?_
  apply div_nonneg <;> nlinarith [Real.pi_pos]

/-! ## 3. The pointwise bounds on a `q`-interval -/

theorem exp_bounds_of_mem_Icc {q0 q1 v : ℝ} (h1 : 1 ≤ q0) (h01 : q0 ≤ q1)
    (hv : v ∈ Icc (vBP q0) (vBP q1)) :
    q0 ^ 2 ≤ Real.exp v ∧ Real.exp v ≤ q1 ^ 2 ∧
      1 / q1 ^ 5 ≤ Real.exp (-(5 * v / 2)) ∧ Real.exp (-(5 * v / 2)) ≤ 1 / q0 ^ 5 := by
  have hq0 : (0:ℝ) < q0 := by linarith
  have hq1 : (0:ℝ) < q1 := by linarith
  obtain ⟨hva, hvb⟩ := hv
  have h5 : Real.exp (-(5 * v / 2)) = (Real.exp (-(v / 2))) ^ 5 := by
    rw [← Real.exp_nat_mul]; ring_nf
  refine ⟨?_, ?_, ?_, ?_⟩
  · rw [← exp_vBP hq0]; exact Real.exp_le_exp.2 hva
  · rw [← exp_vBP hq1]; exact Real.exp_le_exp.2 hvb
  · have hge : 1 / q1 ≤ Real.exp (-(v / 2)) := by
      rw [← exp_neg_half_vBP hq1]
      exact Real.exp_le_exp.2 (by linarith)
    rw [h5, show (1:ℝ) / q1 ^ 5 = (1 / q1) ^ 5 by field_simp]
    exact pow_le_pow_left₀ (by positivity) hge 5
  · have hle : Real.exp (-(v / 2)) ≤ 1 / q0 := by
      rw [← exp_neg_half_vBP hq0]
      exact Real.exp_le_exp.2 (by linarith)
    rw [h5, show (1:ℝ) / q0 ^ 5 = (1 / q0) ^ 5 by field_simp]
    exact pow_le_pow_left₀ (Real.exp_pos _).le hle 5

/-- **The pointwise bound on a `q`-interval, Taylor version for the `b`-term.** -/
theorem abs_errFun_le_piece_taylor {q0 q1 M : ℝ} (h1 : 1 ≤ q0) (h01 : q0 ≤ q1)
    (hHi : (q1 ^ 2 / (3.14159 * (1 + q1 ^ 2)))
          * (1.5708 + 1 / (6.28318 * (1 + q0 ^ 2)) + 1 / (6.28318 * (1 + q0 ^ 2)) ^ 2)
        + 2 * q1 ^ 2 * taylorQup (6.28318 * (q0 ^ 2 - 1)) - 1 - 2.11 / q1 ^ 5 ≤ M)
    (hLo : -M ≤ (q0 ^ 2 / (3.1416 * (1 + q0 ^ 2)))
          * (1.5707 - 1 / (6.28318 * (1 + q0 ^ 2)) - 1 / (6.28318 * (1 + q0 ^ 2)) ^ 2)
        + 2 * q0 ^ 2 * taylorQ (6.2832 * (q1 ^ 2 - 1)) - 1 - 2.11 / q0 ^ 5) :
    ∀ v ∈ Icc (vBP q0) (vBP q1), |errFun v| ≤ M * Real.exp (-(v / 2)) := by
  intro v hv
  obtain ⟨he0, he1, hE0, hE1⟩ := exp_bounds_of_mem_Icc h1 h01 hv
  have hr0 : (1:ℝ) ≤ q0 ^ 2 := by nlinarith
  refine abs_errFun_le_of_PhiErr ?_
  rw [abs_le]
  have hA1 := term_a_le hr0 he0 he1
  have hA0 := term_a_ge hr0 he0
  have hB1 := term_b_le_taylor hr0 he0 he1
  have hB0 := term_b_ge_taylor hr0 he0 he1
  have hsplit : 2 * Real.exp v * (siDiv (uPlus v) + siDiv (uMinus v))
      = 2 * Real.exp v * siDiv (uPlus v) + 2 * Real.exp v * siDiv (uMinus v) := by ring
  have hd0 : (2.11:ℝ) / q0 ^ 5 = 2.11 * (1 / q0 ^ 5) := by ring
  have hd1 : (2.11:ℝ) / q1 ^ 5 = 2.11 * (1 / q1 ^ 5) := by ring
  rw [hd0] at hLo
  rw [hd1] at hHi
  constructor
  · rw [PhiErr, hsplit]
    linarith
  · rw [PhiErr, hsplit]
    linarith

/-- **The pointwise bound on a `q`-interval, asymptotic version for the `b`-term.** -/
theorem abs_errFun_le_piece_asymp {q0 q1 M : ℝ} (h1 : 1 < q0) (h01 : q0 ≤ q1)
    (hnn : (0:ℝ) ≤ 1.5707 - 1 / (6.28318 * (q0 ^ 2 - 1)) - 1 / (6.28318 * (q0 ^ 2 - 1)) ^ 2)
    (hHi : (q1 ^ 2 / (3.14159 * (1 + q1 ^ 2)))
          * (1.5708 + 1 / (6.28318 * (1 + q0 ^ 2)) + 1 / (6.28318 * (1 + q0 ^ 2)) ^ 2)
        + (q0 ^ 2 / (3.14159 * (q0 ^ 2 - 1)))
          * (1.5708 + 1 / (6.28318 * (q0 ^ 2 - 1)) + 1 / (6.28318 * (q0 ^ 2 - 1)) ^ 2)
        - 1 - 2.11 / q1 ^ 5 ≤ M)
    (hLo : -M ≤ (q0 ^ 2 / (3.1416 * (1 + q0 ^ 2)))
          * (1.5707 - 1 / (6.28318 * (1 + q0 ^ 2)) - 1 / (6.28318 * (1 + q0 ^ 2)) ^ 2)
        + (q1 ^ 2 / (3.1416 * (q1 ^ 2 - 1)))
          * (1.5707 - 1 / (6.28318 * (q0 ^ 2 - 1)) - 1 / (6.28318 * (q0 ^ 2 - 1)) ^ 2)
        - 1 - 2.11 / q0 ^ 5) :
    ∀ v ∈ Icc (vBP q0) (vBP q1), |errFun v| ≤ M * Real.exp (-(v / 2)) := by
  intro v hv
  obtain ⟨he0, he1, hE0, hE1⟩ := exp_bounds_of_mem_Icc h1.le h01 hv
  have hr0 : (1:ℝ) < q0 ^ 2 := by nlinarith
  refine abs_errFun_le_of_PhiErr ?_
  rw [abs_le]
  have hA1 := term_a_le hr0.le he0 he1
  have hA0 := term_a_ge hr0.le he0
  have hB1 := term_b_le_asymp hr0 he0
  have hB0 := term_b_ge_asymp hr0 he0 he1 hnn
  have hsplit : 2 * Real.exp v * (siDiv (uPlus v) + siDiv (uMinus v))
      = 2 * Real.exp v * siDiv (uPlus v) + 2 * Real.exp v * siDiv (uMinus v) := by ring
  have hd0 : (2.11:ℝ) / q0 ^ 5 = 2.11 * (1 / q0 ^ 5) := by ring
  have hd1 : (2.11:ℝ) / q1 ^ 5 = 2.11 * (1 / q1 ^ 5) := by ring
  rw [hd0] at hLo
  rw [hd1] at hHi
  constructor
  · rw [PhiErr, hsplit]
    linarith
  · rw [PhiErr, hsplit]
    linarith

/-- Upper bound for the `a`-term valid on the whole tail `r ≥ r₀`. -/
theorem term_a_le_tail {v r0 : ℝ} (h0 : 1 ≤ r0) (hr0 : r0 ≤ Real.exp v) :
    2 * Real.exp v * siDiv (uPlus v)
      ≤ (1 / 3.14159) * (1.5708 + 1 / (6.28318 * (1 + r0)) + 1 / (6.28318 * (1 + r0)) ^ 2) := by
  have hpi1 : (3.14159:ℝ) < π := by linarith [Real.pi_gt_d6]
  set r := Real.exp v with hrdef
  have hr : 1 ≤ r := le_trans h0 hr0
  set a : ℝ := 2 * π * (1 + r) with ha
  have hapos : (0:ℝ) < a := by rw [ha]; nlinarith
  have hA0pos : (0:ℝ) < 6.28318 * (1 + r0) := by nlinarith
  have hA0 : 6.28318 * (1 + r0) ≤ a := by rw [ha]; nlinarith
  have hSi : Si a ≤ 1.5708 + 1 / (6.28318 * (1 + r0)) + 1 / (6.28318 * (1 + r0)) ^ 2 :=
    Si_le_rat hA0pos hA0
  have hSinn : 0 ≤ Si a := Si_nonneg hapos.le
  have hfac : 2 * r / a ≤ 1 / 3.14159 := by
    rw [ha, div_le_div_iff₀ (by nlinarith) (by norm_num)]
    nlinarith [Real.pi_pos]
  have heq : 2 * r * siDiv (uPlus v) = (2 * r / a) * Si a := by
    rw [show uPlus v = a from rfl, siDiv_of_ne_zero (ne_of_gt hapos)]
    field_simp
  rw [heq]
  exact mul_le_mul hfac hSi hSinn (by norm_num)

/-- Lower bound for the `b`-term valid on the whole tail `r ≥ r₀`. -/
theorem term_b_ge_tail {v r0 : ℝ} (h0 : 1 < r0) (hr0 : r0 ≤ Real.exp v)
    (hnn : (0:ℝ) ≤ 1.5707 - 1 / (6.28318 * (r0 - 1)) - 1 / (6.28318 * (r0 - 1)) ^ 2) :
    (1 / 3.1416) * (1.5707 - 1 / (6.28318 * (r0 - 1)) - 1 / (6.28318 * (r0 - 1)) ^ 2)
      ≤ 2 * Real.exp v * siDiv (uMinus v) := by
  have hpi2 : π < 3.1416 := by linarith [Real.pi_lt_d6]
  set r := Real.exp v with hrdef
  have hr : 1 < r := lt_of_lt_of_le h0 hr0
  set b : ℝ := 2 * π * (r - 1) with hb
  have hbpos : (0:ℝ) < b := by rw [hb]; nlinarith [Real.pi_pos]
  have hB0pos : (0:ℝ) < 6.28318 * (r0 - 1) := by nlinarith
  have hB0 : 6.28318 * (r0 - 1) ≤ b := by
    rw [hb]; nlinarith [Real.pi_gt_d6]
  have hSi : 1.5707 - 1 / (6.28318 * (r0 - 1)) - 1 / (6.28318 * (r0 - 1)) ^ 2 ≤ Si b :=
    Si_ge_rat hB0pos hB0
  have hfac : (1:ℝ) / 3.1416 ≤ 2 * r / b := by
    rw [hb, div_le_div_iff₀ (by norm_num) (by nlinarith [Real.pi_pos])]
    nlinarith [Real.pi_pos]
  have heq : 2 * r * siDiv (uMinus v) = (2 * r / b) * Si b := by
    rw [show uMinus v = b from rfl, siDiv_of_ne_zero (ne_of_gt hbpos)]
    field_simp
  rw [heq]
  exact mul_le_mul hfac hSi hnn (by positivity)

/-- **The pointwise bound on the tail `q ≥ q₀`.** -/
theorem abs_errFun_le_tail {q0 M : ℝ} (h1 : 1 < q0)
    (hnn : (0:ℝ) ≤ 1.5707 - 1 / (6.28318 * (q0 ^ 2 - 1)) - 1 / (6.28318 * (q0 ^ 2 - 1)) ^ 2)
    (hHi : (1 / 3.14159)
          * (1.5708 + 1 / (6.28318 * (1 + q0 ^ 2)) + 1 / (6.28318 * (1 + q0 ^ 2)) ^ 2)
        + (q0 ^ 2 / (3.14159 * (q0 ^ 2 - 1)))
          * (1.5708 + 1 / (6.28318 * (q0 ^ 2 - 1)) + 1 / (6.28318 * (q0 ^ 2 - 1)) ^ 2)
        - 1 ≤ M)
    (hLo : -M ≤ (q0 ^ 2 / (3.1416 * (1 + q0 ^ 2)))
          * (1.5707 - 1 / (6.28318 * (1 + q0 ^ 2)) - 1 / (6.28318 * (1 + q0 ^ 2)) ^ 2)
        + (1 / 3.1416)
          * (1.5707 - 1 / (6.28318 * (q0 ^ 2 - 1)) - 1 / (6.28318 * (q0 ^ 2 - 1)) ^ 2)
        - 1 - 2.11 / q0 ^ 5) :
    ∀ v ∈ Ici (vBP q0), |errFun v| ≤ M * Real.exp (-(v / 2)) := by
  intro v hv
  have hq0 : (0:ℝ) < q0 := by linarith
  have hr0 : (1:ℝ) < q0 ^ 2 := by nlinarith
  have he0 : q0 ^ 2 ≤ Real.exp v := by
    rw [← exp_vBP hq0]; exact Real.exp_le_exp.2 hv
  have h5 : Real.exp (-(5 * v / 2)) = (Real.exp (-(v / 2))) ^ 5 := by
    rw [← Real.exp_nat_mul]; ring_nf
  have hE1 : Real.exp (-(5 * v / 2)) ≤ 1 / q0 ^ 5 := by
    have hle : Real.exp (-(v / 2)) ≤ 1 / q0 := by
      rw [← exp_neg_half_vBP hq0]
      exact Real.exp_le_exp.2 (by simp only [mem_Ici] at hv; linarith)
    rw [h5, show (1:ℝ) / q0 ^ 5 = (1 / q0) ^ 5 by field_simp]
    exact pow_le_pow_left₀ (Real.exp_pos _).le hle 5
  have hE0 : (0:ℝ) ≤ Real.exp (-(5 * v / 2)) := (Real.exp_pos _).le
  refine abs_errFun_le_of_PhiErr ?_
  rw [abs_le]
  have hA1 := term_a_le_tail hr0.le he0
  have hA0 := term_a_ge hr0.le he0
  have hB1 := term_b_le_asymp hr0 he0
  have hB0 := term_b_ge_tail hr0 he0 hnn
  have hsplit : 2 * Real.exp v * (siDiv (uPlus v) + siDiv (uMinus v))
      = 2 * Real.exp v * siDiv (uPlus v) + 2 * Real.exp v * siDiv (uMinus v) := by ring
  have hd0 : (2.11:ℝ) / q0 ^ 5 = 2.11 * (1 / q0 ^ 5) := by ring
  rw [hd0] at hLo
  constructor
  · rw [PhiErr, hsplit]
    linarith
  · rw [PhiErr, hsplit]
    linarith

/-! ## 4. Integrating the pointwise bounds -/

theorem integral_abs_errFun_interval_le {a b M : ℝ} (hab : a ≤ b)
    (hM : ∀ v ∈ Icc a b, |errFun v| ≤ M * Real.exp (-(v / 2))) :
    (∫ v in a..b, |errFun v|) ≤ 2 * M * (Real.exp (-(a / 2)) - Real.exp (-(b / 2))) := by
  have h1 : (∫ v in a..b, |errFun v|) ≤ ∫ v in a..b, M * Real.exp (-(v / 2)) :=
    intervalIntegral.integral_mono_on hab (continuous_errFun.abs.intervalIntegrable _ _)
      ((continuous_const.mul (by fun_prop)).intervalIntegrable _ _) hM
  rw [intervalIntegral.integral_const_mul, intervalIntegral_exp_neg_half] at h1
  calc (∫ v in a..b, |errFun v|) ≤ M * (2 * Real.exp (-(a / 2)) - 2 * Real.exp (-(b / 2))) := h1
    _ = 2 * M * (Real.exp (-(a / 2)) - Real.exp (-(b / 2))) := by ring

theorem integral_Ioi_abs_errFun_tail_le {a M : ℝ} (ha : 0 ≤ a)
    (hM : ∀ v ∈ Ici a, |errFun v| ≤ M * Real.exp (-(v / 2))) :
    (∫ v in Ioi a, |errFun v|) ≤ 2 * M * Real.exp (-(a / 2)) := by
  have hint : IntegrableOn (fun v => |errFun v|) (Ioi a) volume :=
    IntegrableOn.mono_set integrableOn_errFun.abs (Ioi_subset_Ioi ha)
  have hexpint : IntegrableOn (fun v : ℝ => Real.exp (-(v / 2))) (Ioi a) volume :=
    IntegrableOn.mono_set integrableOn_exp_neg_half (Ioi_subset_Ioi ha)
  have h1 : (∫ v in Ioi a, |errFun v|) ≤ ∫ v in Ioi a, M * Real.exp (-(v / 2)) :=
    setIntegral_mono_on hint (hexpint.const_mul M) measurableSet_Ioi
      (fun v hv => hM v (mem_Ici.2 (le_of_lt hv)))
  rw [integral_const_mul, integral_Ioi_exp_neg_half_from] at h1
  calc (∫ v in Ioi a, |errFun v|) ≤ M * (2 * Real.exp (-(a / 2))) := h1
    _ = 2 * M * Real.exp (-(a / 2)) := by ring

theorem integral_Ioi_abs_errFun_split {a b : ℝ} (ha : 0 ≤ a) (hab : a ≤ b) :
    (∫ v in Ioi a, |errFun v|) = (∫ v in a..b, |errFun v|) + ∫ v in Ioi b, |errFun v| := by
  have hint : IntegrableOn (fun v => |errFun v|) (Ioi a) volume :=
    IntegrableOn.mono_set integrableOn_errFun.abs (Ioi_subset_Ioi ha)
  have hunion : Ioc a b ∪ Ioi b = Ioi a := Ioc_union_Ioi_eq_Ioi hab
  have h1 : IntegrableOn (fun v => |errFun v|) (Ioc a b) volume :=
    IntegrableOn.mono_set hint (fun x hx => hx.1)
  have h2 : IntegrableOn (fun v => |errFun v|) (Ioi b) volume :=
    IntegrableOn.mono_set hint (Ioi_subset_Ioi hab)
  have hdisj : Disjoint (Ioc a b) (Ioi b) := by
    rw [Set.disjoint_left]
    intro x hx hx'
    exact absurd hx.2 (not_le.2 hx')
  rw [← hunion, setIntegral_union hdisj measurableSet_Ioi h1 h2,
    intervalIntegral.integral_of_le hab]

/-- A piece of the partition, Taylor version. -/
theorem integral_piece_taylor_le {q0 q1 M : ℝ} (h1 : 1 ≤ q0) (h01 : q0 ≤ q1)
    (hHi : (q1 ^ 2 / (3.14159 * (1 + q1 ^ 2)))
          * (1.5708 + 1 / (6.28318 * (1 + q0 ^ 2)) + 1 / (6.28318 * (1 + q0 ^ 2)) ^ 2)
        + 2 * q1 ^ 2 * taylorQup (6.28318 * (q0 ^ 2 - 1)) - 1 - 2.11 / q1 ^ 5 ≤ M)
    (hLo : -M ≤ (q0 ^ 2 / (3.1416 * (1 + q0 ^ 2)))
          * (1.5707 - 1 / (6.28318 * (1 + q0 ^ 2)) - 1 / (6.28318 * (1 + q0 ^ 2)) ^ 2)
        + 2 * q0 ^ 2 * taylorQ (6.2832 * (q1 ^ 2 - 1)) - 1 - 2.11 / q0 ^ 5) :
    (∫ v in (vBP q0)..(vBP q1), |errFun v|) ≤ 2 * M * (1 / q0 - 1 / q1) := by
  have hq0 : (0:ℝ) < q0 := by linarith
  have hq1 : (0:ℝ) < q1 := by linarith
  have hab : vBP q0 ≤ vBP q1 := vBP_mono hq0 h01
  have h := integral_abs_errFun_interval_le hab (abs_errFun_le_piece_taylor h1 h01 hHi hLo)
  rwa [exp_neg_half_vBP hq0, exp_neg_half_vBP hq1] at h

/-- A piece of the partition, asymptotic version. -/
theorem integral_piece_asymp_le {q0 q1 M : ℝ} (h1 : 1 < q0) (h01 : q0 ≤ q1)
    (hnn : (0:ℝ) ≤ 1.5707 - 1 / (6.28318 * (q0 ^ 2 - 1)) - 1 / (6.28318 * (q0 ^ 2 - 1)) ^ 2)
    (hHi : (q1 ^ 2 / (3.14159 * (1 + q1 ^ 2)))
          * (1.5708 + 1 / (6.28318 * (1 + q0 ^ 2)) + 1 / (6.28318 * (1 + q0 ^ 2)) ^ 2)
        + (q0 ^ 2 / (3.14159 * (q0 ^ 2 - 1)))
          * (1.5708 + 1 / (6.28318 * (q0 ^ 2 - 1)) + 1 / (6.28318 * (q0 ^ 2 - 1)) ^ 2)
        - 1 - 2.11 / q1 ^ 5 ≤ M)
    (hLo : -M ≤ (q0 ^ 2 / (3.1416 * (1 + q0 ^ 2)))
          * (1.5707 - 1 / (6.28318 * (1 + q0 ^ 2)) - 1 / (6.28318 * (1 + q0 ^ 2)) ^ 2)
        + (q1 ^ 2 / (3.1416 * (q1 ^ 2 - 1)))
          * (1.5707 - 1 / (6.28318 * (q0 ^ 2 - 1)) - 1 / (6.28318 * (q0 ^ 2 - 1)) ^ 2)
        - 1 - 2.11 / q0 ^ 5) :
    (∫ v in (vBP q0)..(vBP q1), |errFun v|) ≤ 2 * M * (1 / q0 - 1 / q1) := by
  have hq0 : (0:ℝ) < q0 := by linarith
  have hq1 : (0:ℝ) < q1 := by linarith
  have hab : vBP q0 ≤ vBP q1 := vBP_mono hq0 h01
  have h := integral_abs_errFun_interval_le hab (abs_errFun_le_piece_asymp h1 h01 hnn hHi hLo)
  rwa [exp_neg_half_vBP hq0, exp_neg_half_vBP hq1] at h

/-- The tail of the partition. -/
theorem integral_tail_le {q0 M : ℝ} (h1 : 1 < q0)
    (hnn : (0:ℝ) ≤ 1.5707 - 1 / (6.28318 * (q0 ^ 2 - 1)) - 1 / (6.28318 * (q0 ^ 2 - 1)) ^ 2)
    (hHi : (1 / 3.14159)
          * (1.5708 + 1 / (6.28318 * (1 + q0 ^ 2)) + 1 / (6.28318 * (1 + q0 ^ 2)) ^ 2)
        + (q0 ^ 2 / (3.14159 * (q0 ^ 2 - 1)))
          * (1.5708 + 1 / (6.28318 * (q0 ^ 2 - 1)) + 1 / (6.28318 * (q0 ^ 2 - 1)) ^ 2)
        - 1 ≤ M)
    (hLo : -M ≤ (q0 ^ 2 / (3.1416 * (1 + q0 ^ 2)))
          * (1.5707 - 1 / (6.28318 * (1 + q0 ^ 2)) - 1 / (6.28318 * (1 + q0 ^ 2)) ^ 2)
        + (1 / 3.1416)
          * (1.5707 - 1 / (6.28318 * (q0 ^ 2 - 1)) - 1 / (6.28318 * (q0 ^ 2 - 1)) ^ 2)
        - 1 - 2.11 / q0 ^ 5) :
    (∫ v in Ioi (vBP q0), |errFun v|) ≤ 2 * M / q0 := by
  have hq0 : (0:ℝ) < q0 := by linarith
  have h := integral_Ioi_abs_errFun_tail_le (vBP_nonneg h1.le) (abs_errFun_le_tail h1 hnn hHi hLo)
  rw [exp_neg_half_vBP hq0] at h
  calc (∫ v in Ioi (vBP q0), |errFun v|) ≤ 2 * M * (1 / q0) := h
    _ = 2 * M / q0 := by ring

end ConnesConsani.WeilPositivity
