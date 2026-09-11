/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Companion effort: arithmetic holonomy certificate for `ζ_5(3)`.
-/
import Mathlib

/-!
# Certified rational bounds for logarithms

This file provides the small amount of *validated numerics* needed by the
`ζ_5(3)` certificate: rigorous rational upper and lower bounds for `Real.log 5`
(and hence for `Real.log 25`, the value of the Bost–Charles integral of the
auxiliary factor used in `Zeta5.BostCharles`).

Everything is derived from two Mathlib facts about the exponential series,

* `Real.sum_le_exp_of_nonneg` (partial sums of the exponential series are lower
  bounds), and
* `Real.exp_bound` (an explicit bound on the tail of the exponential series for
  `|x| ≤ 1`),

applied at `x = 0.8047` and `x = 0.80475`, i.e. at half of the target value, so
that the hypothesis `|x| ≤ 1` of `Real.exp_bound` is available.  The resulting
enclosure is

`1.6094 < Real.log 5 < 1.6095`.
-/

namespace Zeta5

open Real Finset

/-- The tenth partial sum of the exponential series. -/
private noncomputable def expSum10 (x : ℝ) : ℝ :=
  ∑ i ∈ Finset.range 10, x ^ i / (Nat.factorial i)

private lemma expSum10_le_exp {x : ℝ} (hx : 0 ≤ x) : expSum10 x ≤ Real.exp x :=
  Real.sum_le_exp_of_nonneg hx 10

private lemma exp_le_expSum10_add {x : ℝ} (hx : |x| ≤ 1) :
    Real.exp x ≤ expSum10 x + |x| ^ 10 * (11 / (Nat.factorial 10 * 10)) := by
  have h := Real.exp_bound hx (n := 10) (by norm_num)
  have h' : Real.exp x - expSum10 x ≤ |x| ^ 10 * (11 / (Nat.factorial 10 * 10)) := by
    calc Real.exp x - expSum10 x ≤ |Real.exp x - expSum10 x| := le_abs_self _
      _ ≤ |x| ^ 10 * ((Nat.succ 10 : ℝ) / (Nat.factorial 10 * 10)) := by
          simpa [expSum10] using h
      _ = |x| ^ 10 * (11 / (Nat.factorial 10 * 10)) := by norm_num
  linarith

/-- `exp (0.8047) < 2.23603`. -/
private lemma exp_8047_lt : Real.exp 0.8047 < 2.23603 := by
  have hx : |(0.8047 : ℝ)| ≤ 1 := by rw [abs_of_nonneg] <;> norm_num
  have h := exp_le_expSum10_add hx
  have habs : |(0.8047 : ℝ)| = 0.8047 := by rw [abs_of_nonneg]; norm_num
  rw [habs] at h
  have hnum : expSum10 (0.8047 : ℝ) + (0.8047 : ℝ) ^ 10 * (11 / (Nat.factorial 10 * 10))
      < 2.23603 := by
    simp only [expSum10, Finset.sum_range_succ, Finset.sum_range_zero]
    norm_num [Nat.factorial]
  linarith

/-- `2.23613 < exp (0.80475)`. -/
private lemma lt_exp_80475 : (2.23613 : ℝ) < Real.exp 0.80475 := by
  have h := expSum10_le_exp (x := (0.80475 : ℝ)) (by norm_num)
  have hnum : (2.23613 : ℝ) < expSum10 (0.80475 : ℝ) := by
    simp only [expSum10, Finset.sum_range_succ, Finset.sum_range_zero]
    norm_num [Nat.factorial]
  linarith

/-- Certified lower bound: `1.6094 < log 5`. -/
theorem log_five_gt : (1.6094 : ℝ) < Real.log 5 := by
  have hexp : Real.exp (1.6094 : ℝ) < 5 := by
    have h2 : Real.exp (1.6094 : ℝ) = Real.exp 0.8047 * Real.exp 0.8047 := by
      rw [← Real.exp_add]; norm_num
    have hpos : (0 : ℝ) < Real.exp 0.8047 := Real.exp_pos _
    have h := exp_8047_lt
    calc Real.exp (1.6094 : ℝ) = Real.exp 0.8047 * Real.exp 0.8047 := h2
      _ < 2.23603 * 2.23603 := by
          apply mul_lt_mul' h.le h hpos.le (by norm_num)
      _ < 5 := by norm_num
  exact (Real.lt_log_iff_exp_lt (by norm_num)).2 hexp

/-- Certified upper bound: `log 5 < 1.6095`. -/
theorem log_five_lt : Real.log 5 < (1.6095 : ℝ) := by
  have hexp : (5 : ℝ) < Real.exp (1.6095 : ℝ) := by
    have h2 : Real.exp (1.6095 : ℝ) = Real.exp 0.80475 * Real.exp 0.80475 := by
      rw [← Real.exp_add]; norm_num
    have h := lt_exp_80475
    calc (5 : ℝ) < 2.23613 * 2.23613 := by norm_num
      _ < Real.exp 0.80475 * Real.exp 0.80475 := by
          apply mul_lt_mul' h.le h (by norm_num) (by positivity)
      _ = Real.exp (1.6095 : ℝ) := h2.symm
  exact (Real.log_lt_iff_lt_exp (by norm_num)).2 hexp

private lemma log_25_eq : Real.log 25 = 2 * Real.log 5 := by
  rw [show (25 : ℝ) = 5 ^ 2 by norm_num, Real.log_pow]
  push_cast; ring

/-- Certified lower bound for `log 25 = 2 log 5`. -/
theorem log_twentyfive_gt : (3.2188 : ℝ) < Real.log 25 := by
  have := log_five_gt
  rw [log_25_eq]; linarith

/-- Certified upper bound for `log 25 = 2 log 5`. -/
theorem log_twentyfive_lt : Real.log 25 < (3.219 : ℝ) := by
  have := log_five_lt
  rw [log_25_eq]; linarith

end Zeta5
