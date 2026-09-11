/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBase
import RequestProject.Imported.OutputFinal.RequestProject.PolyaThreshold

/-!
# The band criterion with the poles of the model cancelled

The band criterion `fourierSide_nonneg_band_osc` of `RequestProject/PolyaOscThreshold.lean`
bounds the increasing part `2θ'` at the left endpoint `a` of the band and the decreasing
cosine transform of the Pólya model at the right endpoint `b`.  For small `|t|` that is
hopeless: the model transform `M(t) = 1/(1/4+t²) + 12.66/(9+t²)` varies by `4.5` per unit
of `t` near the origin, while the whole margin of the inequality is `≈ 0.05`.

The remedy is an exact cancellation.  The `n`-th term of the series for `2θ'(t) - 2θ'(0)` is

  `thetaSeriesTerm t n = (t²/4) / (aₙ (aₙ² + t²/4))`,   `aₙ = n + 1/4`,

so that for `n = 0` (`a₀ = 1/4`) one has `thetaSeriesTerm t 0 = 4t²/(1/4 + t²)` and therefore

  `thetaSeriesTerm t 0 + 1/(1/4 + t²) = 4`   (`thetaSeriesTerm_zero_add_model`),

*identically in `t`*: the first pole of the digamma side cancels the first pole of the model
exactly.  The second pair combines into

  `P(t) = 4/5 - 5/(25/4 + t²) + 12.66/(9 + t²)`,

which is decreasing but with `|P'| ≤ 0.12` (`modelPair_antitone`), and the remaining terms
`n ≥ 2` are increasing.  The resulting band criterion `fourierSide_nonneg_band_sharp` loses
only `P(a) - P(b)` on a band, instead of `M(a) - M(b)`.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

/-- **The exact cancellation of the first pole**: the `n = 0` term of the digamma series and
the first term of the model transform add up to the constant `4`. -/
theorem thetaSeriesTerm_zero_add_model (t : ℝ) :
    thetaSeriesTerm t 0 + 1 / (0.25 + t ^ 2) = 4 := by
  have h : (0:ℝ) < 0.25 + t ^ 2 := by positivity
  rw [thetaSeriesTerm, poleAbscissa]
  norm_num
  field_simp
  ring

/-- The `n = 1` term of the digamma series in closed form. -/
theorem thetaSeriesTerm_one_eq (t : ℝ) :
    thetaSeriesTerm t 1 = 0.8 - 5 / (6.25 + t ^ 2) := by
  have h : (0:ℝ) < 6.25 + t ^ 2 := by positivity
  rw [thetaSeriesTerm, poleAbscissa]
  norm_num
  field_simp
  ring

/-- The second pair (the `n = 1` digamma term together with the second model term) is
antitone on `[0,∞)`. -/
theorem modelPair_antitone {s b : ℝ} (hs : 0 ≤ s) (hsb : s ≤ b) :
    0.8 - 5 / (6.25 + b ^ 2) + 12.66 / (9 + b ^ 2)
      ≤ 0.8 - 5 / (6.25 + s ^ 2) + 12.66 / (9 + s ^ 2) := by
  have hs2 : s ^ 2 ≤ b ^ 2 := by nlinarith
  have h1 : (0:ℝ) < 6.25 + s ^ 2 := by positivity
  have h2 : (0:ℝ) < 6.25 + b ^ 2 := by positivity
  have h3 : (0:ℝ) < 9 + s ^ 2 := by positivity
  have h4 : (0:ℝ) < 9 + b ^ 2 := by positivity
  have e1 : 5 / (6.25 + s ^ 2) - 5 / (6.25 + b ^ 2)
      = 5 * (b ^ 2 - s ^ 2) / ((6.25 + s ^ 2) * (6.25 + b ^ 2)) := by
    field_simp; ring
  have e2 : (12.66:ℝ) / (9 + s ^ 2) - 12.66 / (9 + b ^ 2)
      = 12.66 * (b ^ 2 - s ^ 2) / ((9 + s ^ 2) * (9 + b ^ 2)) := by
    field_simp; ring
  have key : 5 * (b ^ 2 - s ^ 2) / ((6.25 + s ^ 2) * (6.25 + b ^ 2))
      ≤ 12.66 * (b ^ 2 - s ^ 2) / ((9 + s ^ 2) * (9 + b ^ 2)) := by
    rw [div_le_div_iff₀ (by positivity) (by positivity)]
    nlinarith [sub_nonneg.2 hs2, sq_nonneg s, sq_nonneg b,
      mul_nonneg (sub_nonneg.2 hs2) (sq_nonneg s), mul_nonneg (sub_nonneg.2 hs2) (sq_nonneg b),
      mul_nonneg (sub_nonneg.2 hs2) (mul_nonneg (sq_nonneg s) (sq_nonneg b))]
  linarith

/-- **The band criterion with the first poles cancelled.**  On a band `a ≤ s ≤ b` with
`0 ≤ a`, the terms `n ≥ 2` of the digamma series are bounded below at `a`, the pair
`P(t) = 4/5 - 5/(25/4+t²) + 12.66/(9+t²)` at `b`, the first pair contributes the exact
constant `4`, and the oscillatory error integral is bounded below by `η`. -/
theorem fourierSide_nonneg_band_sharp {a b s η : ℝ} (ha : 0 ≤ a) (hsa : a ≤ s) (hsb : s ≤ b)
    (hη : η ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (s * v))
    (hnum : 0 ≤ (∑ n ∈ Finset.Ico 2 80, thetaSeriesTerm a n)
      + (4 - 5.37221 + (0.8 - 5 / (6.25 + b ^ 2) + 12.66 / (9 + b ^ 2))) + 2 * η) :
    0 ≤ fourierSide s := by
  have hs0 : 0 ≤ s := le_trans ha hsa
  have h1 := two_thetaDeriv_ge_series s
  have h4 := deltaFourier_ge_of_cos_bound hη
  have hmodel : 2 * ((1/2) / ((1/2:ℝ) ^ 2 + s ^ 2) + 2.11 * (3 / (3 ^ 2 + s ^ 2)))
      = 1 / (0.25 + s ^ 2) + 12.66 / (9 + s ^ 2) := by
    have e1 : ((1:ℝ)/2) ^ 2 + s ^ 2 = 0.25 + s ^ 2 := by norm_num
    have e2 : ((3:ℝ)) ^ 2 + s ^ 2 = 9 + s ^ 2 := by norm_num
    rw [e1, e2]
    field_simp
    ring
  rw [hmodel] at h4
  -- split the partial sum
  have hsplit : (∑ n ∈ Finset.range 80, thetaSeriesTerm s n)
      = thetaSeriesTerm s 0 + thetaSeriesTerm s 1 + ∑ n ∈ Finset.Ico 2 80, thetaSeriesTerm s n := by
    rw [Finset.range_eq_Ico]
    rw [← Finset.sum_Ico_consecutive (fun n => thetaSeriesTerm s n) (by norm_num : (0:ℕ) ≤ 2)
      (by norm_num : (2:ℕ) ≤ 80)]
    congr 1
    rw [show (2:ℕ) = 0 + 1 + 1 by norm_num]
    rw [Finset.sum_Ico_succ_top (by norm_num), Finset.sum_Ico_succ_top (by norm_num)]
    simp
  have hmono : (∑ n ∈ Finset.Ico 2 80, thetaSeriesTerm a n)
      ≤ ∑ n ∈ Finset.Ico 2 80, thetaSeriesTerm s n :=
    Finset.sum_le_sum fun n _ => thetaSeriesTerm_mono ha hsa n
  have h0 := thetaSeriesTerm_zero_add_model s
  have hP := modelPair_antitone hs0 hsb
  rw [← thetaSeriesTerm_one_eq s] at hP
  rw [fourierSide]
  rw [hsplit] at h1
  linarith

end ConnesConsani.WeilPositivity
