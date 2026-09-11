/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Companion effort: arithmetic holonomy certificate for `ζ_5(3)`.
-/
import Mathlib
import RequestProject.Imported.OutputFinal.Zeta5.LogBounds

/-!
# The certified Bost–Charles integral

For a function `f` on a neighbourhood of the closed unit disc we write

`BC(f) = (1/2π) ∫_0^{2π} log |f(e^{iθ})| dθ = ∫_0^1 log |f(e^{2πit})| dt`,

which in Mathlib is `circleAverage (fun z ↦ Real.log ‖f z‖) 0 1`.  This is the
archimedean ("Bost–Charles") contribution of the auxiliary factor `f` to the
cost side of an arithmetic-holonomy estimate.

The file contains two things.

1. *Reusable machinery*: for a polynomial given by an explicit list of rational
   coefficients whose constant term dominates the sum of the absolute values of
   the remaining ones (a "diagonally dominant" polynomial), the polynomial has
   no zero in the closed unit disc, and consequently — by the Mathlib form of
   Jensen's formula, `AnalyticOnNhd.circleAverage_log_norm_of_ne_zero` — its
   Bost–Charles integral is *exactly* `log |a₀|`.  This is an exact evaluation,
   not a quadrature: there is no discretisation error at all.

2. The certificate for the auxiliary factor of the `ζ_5(3)` instantiation,

   `φ(z) = (5 - z)² = 25 - 10 z + z²`,

   for which the machinery gives `BC(φ) = log 25 = 2 log 5`, and hence, with the
   certified logarithm bounds of `Zeta5.LogBounds`, the two-sided enclosure

   `3.2188 < BC(φ) < 3.219`.

   (The comparison of this number with `3.23494` is recorded, but *demoted*, in
   `Zeta5.Certificate`: it is not the criterion of the paper.)
-/

namespace Zeta5

open Finset Metric Real

/-- The polynomial with rational coefficient list `a`, evaluated on `ℂ`. -/
noncomputable def polyEval (a : List ℚ) (z : ℂ) : ℂ :=
  ∑ k ∈ range a.length, (a.getD k 0 : ℂ) * z ^ k

theorem analyticOnNhd_polyEval (a : List ℚ) (s : Set ℂ) :
    AnalyticOnNhd ℂ (polyEval a) s := by
  unfold polyEval
  apply Finset.analyticOnNhd_fun_sum
  intro k _
  exact analyticOnNhd_const.mul (analyticOnNhd_id.pow k)

/-- A "diagonally dominant" polynomial does not vanish on the closed unit disc:
if `Σ_{k ≥ 1} |a_k| < |a₀|` then `|p(z)| ≥ |a₀| - Σ_{k≥1}|a_k| > 0` for `‖z‖ ≤ 1`. -/
theorem norm_polyEval_ge_of_dominant (a : List ℚ) {z : ℂ} (hz : ‖z‖ ≤ 1) :
    (|a.getD 0 0| : ℝ) - ∑ k ∈ Ico 1 a.length, (|a.getD k 0| : ℝ) ≤ ‖polyEval a z‖ := by
  rcases Nat.eq_zero_or_pos a.length with h | h
  · have : a = [] := List.eq_nil_of_length_eq_zero h
    simp [polyEval, this]
  · have hsplit : polyEval a z
        = (a.getD 0 0 : ℂ) + ∑ k ∈ Ico 1 a.length, (a.getD k 0 : ℂ) * z ^ k := by
      unfold polyEval
      rw [Finset.range_eq_Ico, Finset.sum_eq_sum_Ico_succ_bot h]
      simp
    have hterm : ∀ k ∈ Ico 1 a.length,
        ‖(a.getD k 0 : ℂ) * z ^ k‖ ≤ (|a.getD k 0| : ℝ) := by
      intro k _
      rw [norm_mul, norm_pow]
      have h1 : ‖(a.getD k 0 : ℂ)‖ = (|a.getD k 0| : ℝ) := by
        simp [Complex.norm_ratCast]
      rw [h1]
      calc (|a.getD k 0| : ℝ) * ‖z‖ ^ k ≤ (|a.getD k 0| : ℝ) * 1 := by
            apply mul_le_mul_of_nonneg_left _ (by positivity)
            exact pow_le_one₀ (norm_nonneg z) hz
        _ = (|a.getD k 0| : ℝ) := by ring
    have htail : ‖∑ k ∈ Ico 1 a.length, (a.getD k 0 : ℂ) * z ^ k‖
        ≤ ∑ k ∈ Ico 1 a.length, (|a.getD k 0| : ℝ) :=
      (norm_sum_le _ _).trans (Finset.sum_le_sum hterm)
    have h0 : ‖(a.getD 0 0 : ℂ)‖ = (|a.getD 0 0| : ℝ) := by
      simp [Complex.norm_ratCast]
    have := norm_sub_norm_le ((a.getD 0 0 : ℂ))
      (-(∑ k ∈ Ico 1 a.length, (a.getD k 0 : ℂ) * z ^ k))
    rw [sub_neg_eq_add, ← hsplit, h0, norm_neg] at this
    linarith

theorem polyEval_ne_zero_of_dominant (a : List ℚ)
    (hdom : ∑ k ∈ Ico 1 a.length, (|a.getD k 0| : ℝ) < (|a.getD 0 0| : ℝ))
    {z : ℂ} (hz : ‖z‖ ≤ 1) : polyEval a z ≠ 0 := by
  have h := norm_polyEval_ge_of_dominant a hz
  intro hzero
  rw [hzero, norm_zero] at h
  linarith

/-- **Jensen's formula, applied.**  The Bost–Charles integral of a diagonally
dominant polynomial is exactly `log |a₀|`. -/
theorem circleAverage_log_norm_polyEval (a : List ℚ)
    (hdom : ∑ k ∈ Ico 1 a.length, (|a.getD k 0| : ℝ) < (|a.getD 0 0| : ℝ)) :
    circleAverage (fun z ↦ Real.log ‖polyEval a z‖) 0 1
      = Real.log ‖polyEval a 0‖ := by
  have habs : |(1 : ℝ)| = 1 := abs_one
  have hAn : AnalyticOnNhd ℂ (polyEval a) (closedBall (0 : ℂ) |(1 : ℝ)|) :=
    analyticOnNhd_polyEval a _
  have hne : ∀ u ∈ closedBall (0 : ℂ) |(1 : ℝ)|, polyEval a u ≠ 0 := by
    intro u hu
    rw [habs, mem_closedBall, dist_zero_right] at hu
    exact polyEval_ne_zero_of_dominant a hdom hu
  exact hAn.circleAverage_log_norm_of_ne_zero hne

/-! ### The auxiliary factor of the `ζ_5(3)` certificate -/

/-- Coefficient list of the auxiliary factor `φ(z) = (5 - z)² = 25 - 10 z + z²`. -/
def phiCoeff : List ℚ := [25, -10, 1]

/-- The auxiliary factor `φ(z) = (5 - z)²`. -/
noncomputable def phi (z : ℂ) : ℂ := polyEval phiCoeff z

theorem phi_eq (z : ℂ) : phi z = (5 - z) ^ 2 := by
  simp [phi, polyEval, phiCoeff, Finset.sum_range_succ]
  ring

theorem phi_zero : phi 0 = 25 := by rw [phi_eq]; norm_num

/-- The Bost–Charles integral of the auxiliary factor. -/
noncomputable def BC : ℝ := circleAverage (fun z ↦ Real.log ‖phi z‖) 0 1

/-- **Task 2 (certified Bost–Charles integral), exact form.**
`BC(φ) = log 25 = 2 log 5`, with *no* numerical error: the integral is evaluated
in closed form by Jensen's formula, the hypothesis being that `φ` has no zero in
the closed unit disc (its only zero is the double zero at `z = 5`). -/
theorem BC_eq_log_25 : BC = Real.log 25 := by
  have hdom : ∑ k ∈ Ico 1 phiCoeff.length, (|phiCoeff.getD k 0| : ℝ)
      < (|phiCoeff.getD 0 0| : ℝ) := by
    norm_num [phiCoeff, Finset.sum_Ico_succ_top]
  have h := circleAverage_log_norm_polyEval phiCoeff hdom
  rw [BC]
  rw [show (fun z ↦ Real.log ‖phi z‖) = (fun z ↦ Real.log ‖polyEval phiCoeff z‖) from rfl, h]
  rw [show polyEval phiCoeff 0 = phi 0 from rfl, phi_zero]
  norm_num

/-- Certified two-sided enclosure of the Bost–Charles integral. -/
theorem BC_gt : (3.2188 : ℝ) < BC := by rw [BC_eq_log_25]; exact log_twentyfive_gt

/-- Certified two-sided enclosure of the Bost–Charles integral. -/
theorem BC_lt : BC < (3.219 : ℝ) := by rw [BC_eq_log_25]; exact log_twentyfive_lt

end Zeta5
