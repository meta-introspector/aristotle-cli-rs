/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaPartition3

/-!
# The Pólya-model threshold for the Fourier-side inequality

Combining

* the uniform lower bound `δ̂(t) ≥ -2ε` of `RequestProject/PolyaModel.lean`, valid for **every**
  real `t`, with the certified value `ε ≤ 0.21088` of `RequestProject/PolyaError.lean`, and
* the effective lower bound `2θ'(t) ≥ 2θ'(0) + ∑_{n<80} (t²/4)/(aₙ(aₙ² + t²/4))`,

gives `2θ'(t) + δ̂(t) ≥ 0` for all `|t| ≥ 12`.  Retaining the (nonnegative) cosine transform
of the model instead of discarding it lowers this further to `|t| ≥ 8`, so the previous
threshold `23` of `fourierSide_nonneg_of_twentythree_le_abs` is improved to `8`.
-/

noncomputable section

open scoped Real
open MeasureTheory Set

namespace ConnesConsani.WeilPositivity

/-- The eighty terms `n < 80` of the series for `Θ` contribute more than `6.016` at `t = 12`,
hence at every `|t| ≥ 12`. -/
theorem sum_thetaSeriesTerm_ge_of_twelve {t : ℝ} (ht : 12 ≤ |t|) :
    (6.016 : ℝ) ≤ ∑ n ∈ Finset.range 80, thetaSeriesTerm t n := by
  have hmono : ∀ n ∈ Finset.range 80, thetaSeriesTerm 12 n ≤ thetaSeriesTerm t n := by
    intro n _
    rw [← thetaSeriesTerm_abs t n]
    exact thetaSeriesTerm_mono (by norm_num) ht n
  have hnum : (6.016 : ℝ) ≤ ∑ n ∈ Finset.range 80, thetaSeriesTerm (12 : ℝ) n := by
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  linarith [Finset.sum_le_sum hmono]

/-- **An effective lower bound for `2θ'` at moderate arguments**: `2θ'(t) ≥ 0.6437` for
`|t| ≥ 12`.  (The true value at `t = 12` is `2θ'(12) = 0.6467…`.) -/
theorem two_thetaDeriv_ge_of_twelve_le_abs {t : ℝ} (ht : 12 ≤ |t|) :
    (0.6437 : ℝ) ≤ 2 * thetaDeriv t := by
  have hpartial : (∑ n ∈ Finset.range 80, thetaSeriesTerm t n)
      ≤ 2 * thetaDeriv t - 2 * thetaDeriv 0 :=
    sum_le_hasSum _ (fun n _ => thetaSeriesTerm_nonneg t n) (hasSum_thetaDeriv_sub t)
  have hsum := sum_thetaSeriesTerm_ge_of_twelve ht
  have hzero : 2 * thetaDeriv 0
      = -(Real.log π + Real.eulerMascheroniConstant + 3 * Real.log 2 + π / 2) := by
    rw [thetaDeriv_zero, ← fourierSide_threshold_eq]
    ring
  have hlt := fourierSide_threshold_lt_d5
  rw [hzero] at hpartial
  linarith

/-- **The Fourier-side inequality for `|t| ≥ 12`**: `f(t) = 2θ'(t) + δ̂(t) ≥ 0` outside the
interval `|t| < 12`.  This improves the threshold `|t| ≥ 23` of
`fourierSide_nonneg_of_twentythree_le_abs`; the gain comes from the Pólya-model bound
`δ̂(t) ≥ -2ε` with `ε ≤ 0.21088`, which is uniform in `t` instead of decaying like `1/|t|`. -/
theorem fourierSide_nonneg_of_twelve_le_abs {t : ℝ} (ht : 12 ≤ |t|) :
    0 ≤ fourierSide t := by
  have hd := deltaFourier_ge_of_l1_bound integral_Ioi_abs_errFun_le t
  have hth := two_thetaDeriv_ge_of_twelve_le_abs ht
  rw [fourierSide]
  norm_num at hd
  linarith

/-! ## The step argument: keeping the model term lowers the threshold to `10` -/

/-- The series lower bound for `2θ'` at a point: `2θ'(a) ≥ ∑_{n<80} termₙ(a) - 5.37221`. -/
theorem two_thetaDeriv_ge_series (a : ℝ) :
    (∑ n ∈ Finset.range 80, thetaSeriesTerm a n) - 5.37221 ≤ 2 * thetaDeriv a := by
  have hpartial : (∑ n ∈ Finset.range 80, thetaSeriesTerm a n)
      ≤ 2 * thetaDeriv a - 2 * thetaDeriv 0 :=
    sum_le_hasSum _ (fun n _ => thetaSeriesTerm_nonneg a n) (hasSum_thetaDeriv_sub a)
  have hzero : 2 * thetaDeriv 0
      = -(Real.log π + Real.eulerMascheroniConstant + 3 * Real.log 2 + π / 2) := by
    rw [thetaDeriv_zero, ← fourierSide_threshold_eq]
    ring
  have hlt := fourierSide_threshold_lt_d5
  rw [hzero] at hpartial
  linarith

/-- `2θ'` is monotone in `|t|`. -/
theorem two_thetaDeriv_le_of_le_abs {a t : ℝ} (ha : 0 ≤ a) (ht : a ≤ |t|) :
    2 * thetaDeriv a ≤ 2 * thetaDeriv t := by
  have h := thetaDeriv_monotoneOn ha (le_trans ha ht) ht
  rw [thetaDeriv_abs] at h
  linarith

/-- The cosine transform of the model decreases in `|t|`. -/
theorem modelHat_ge_of_abs_le {b t : ℝ} (hb : |t| ≤ b) :
    1 / (0.25 + b ^ 2) + 12.66 / (9 + b ^ 2)
      ≤ 2 * ((1/2) / ((1/2) ^ 2 + t ^ 2) + 2.11 * (3 / (3 ^ 2 + t ^ 2))) := by
  have hb0 : (0:ℝ) ≤ b := le_trans (abs_nonneg t) hb
  have hsq : t ^ 2 ≤ b ^ 2 := by
    rw [← sq_abs t]
    exact pow_le_pow_left₀ (abs_nonneg t) hb 2
  have h1 : 1 / (0.25 + b ^ 2) ≤ 2 * ((1/2) / ((1/2) ^ 2 + t ^ 2)) := by
    rw [show 2 * ((1/2 : ℝ) / ((1/2) ^ 2 + t ^ 2)) = 1 / (0.25 + t ^ 2) by norm_num; ring]
    apply one_div_le_one_div_of_le (by positivity)
    linarith
  have h2 : 12.66 / (9 + b ^ 2) ≤ 2 * (2.11 * (3 / (3 ^ 2 + t ^ 2))) := by
    rw [show 2 * (2.11 * (3 / ((3:ℝ) ^ 2 + t ^ 2))) = 12.66 / (9 + t ^ 2) by norm_num; ring]
    apply div_le_div_of_nonneg_left (by norm_num) (by positivity)
    linarith
  linarith

/-- **One step of the threshold argument.**  On a band `a ≤ |t| ≤ b`, the increasing function
`2θ'` is bounded below at `a` and the decreasing model transform at `b`; if the two exceed
`2ε = 0.42176` then the Fourier-side inequality holds throughout the band. -/
theorem fourierSide_nonneg_band {a b t : ℝ} (ha : 0 ≤ a) (hta : a ≤ |t|) (htb : |t| ≤ b)
    (hnum : (0.42176 : ℝ) ≤ ((∑ n ∈ Finset.range 80, thetaSeriesTerm a n) - 5.37221)
      + (1 / (0.25 + b ^ 2) + 12.66 / (9 + b ^ 2))) :
    0 ≤ fourierSide t := by
  have h1 := two_thetaDeriv_ge_series a
  have h2 := two_thetaDeriv_le_of_le_abs ha hta
  have h3 := modelHat_ge_of_abs_le htb
  have h4 := deltaFourier_ge_of_l1_bound' integral_Ioi_abs_errFun_le t
  rw [fourierSide]
  norm_num at h4
  linarith

/-- **The Fourier-side inequality for `|t| ≥ 8`**: `f(t) = 2θ'(t) + δ̂(t) ≥ 0` outside the
interval `|t| < 8`.  This is the best large-frequency threshold established in the project;
it improves `fourierSide_nonneg_of_twelve_le_abs` by retaining the (nonnegative) cosine
transform of the Pólya model instead of discarding it, and by working band by band on
`8 ≤ |t| ≤ 12`. -/
theorem fourierSide_nonneg_of_eight_le_abs {t : ℝ} (ht : 8 ≤ |t|) :
    0 ≤ fourierSide t := by
  rcases le_or_gt 12 |t| with h12 | h12
  · exact fourierSide_nonneg_of_twelve_le_abs h12
  rcases le_or_gt 11 |t| with h11 | h11
  · refine fourierSide_nonneg_band (a := 11) (b := 12) (by norm_num) h11 h12.le ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 10.5 |t| with h10_5 | h10_5
  · refine fourierSide_nonneg_band (a := 10.5) (b := 11) (by norm_num) h10_5 h11.le ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 10 |t| with h10 | h10
  · refine fourierSide_nonneg_band (a := 10) (b := 10.5) (by norm_num) h10 h10_5.le ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 9.5 |t| with h9_5 | h9_5
  · refine fourierSide_nonneg_band (a := 9.5) (b := 10) (by norm_num) h9_5 h10.le ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 9 |t| with h9 | h9
  · refine fourierSide_nonneg_band (a := 9) (b := 9.5) (by norm_num) h9 h9_5.le ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 8.75 |t| with h8_75 | h8_75
  · refine fourierSide_nonneg_band (a := 8.75) (b := 9) (by norm_num) h8_75 h9.le ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 8.5 |t| with h8_5 | h8_5
  · refine fourierSide_nonneg_band (a := 8.5) (b := 8.75) (by norm_num) h8_5 h8_75.le ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 8.25 |t| with h8_25 | h8_25
  · refine fourierSide_nonneg_band (a := 8.25) (b := 8.5) (by norm_num) h8_25 h8_5.le ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 8.1 |t| with h8_1 | h8_1
  · refine fourierSide_nonneg_band (a := 8.1) (b := 8.25) (by norm_num) h8_1 h8_25.le ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  · refine fourierSide_nonneg_band (a := 8) (b := 8.1) (by norm_num) ht h8_1.le ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]

end ConnesConsani.WeilPositivity
