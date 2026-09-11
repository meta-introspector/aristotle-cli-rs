/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Sharp explicit bounds for the constants entering the Fourier-side inequality at the origin.

The threshold of Corollary 2.3 (ii) at `t = 0` is

  `T = log π + γ + 3 log 2 + π/2 = log π - ψ(1/4) = 5.3721834…`,

and `RequestProject/DeltaFourierZero.lean` proves `δ̂(0) ≥ 5.3765`.  In order to have a
*quantitative* margin `f(0) = δ̂(0) - T > 0` — which is what makes the inequality survive on
a whole neighbourhood of the origin, see `RequestProject/NearOrigin.lean` — one needs `T`
to an accuracy of a few units in the fifth decimal.  The bottleneck is the
Euler–Mascheroni constant: Mathlib's two-sided bounds `H_n - log (n+1) < γ < H_n - log n`
converge like `1/n`, and `n = 128` only gives `γ < 0.58119`.

This file replaces them by the classical `γ < H_n - log (n + 1/2)`, whose error is
`O(1/n²)`; at `n = 128` it gives `γ < 0.5772287` (the true value is `0.5772156…`).
-/
import RequestProject.Imported.OutputFinal2.DeltaFourierZero

noncomputable section

open Filter Topology Real

namespace ConnesConsani.WeilPositivity

local notation "γ" => Real.eulerMascheroniConstant

/-! ## The sequence `H_n - log (n + 1/2)` -/

/-- The classical refinement `H_n - log (n + 1/2)` of the two sequences used by Mathlib to
define `γ`; it decreases to `γ` with error `O(1/n²)` instead of `O(1/n)`. -/
def gammaSeqMid (n : ℕ) : ℝ := (harmonic n : ℝ) - Real.log (n + 1 / 2)

/-- `x/(1+x) ≤ log (1+x)` for `x ≥ 0`. -/
theorem le_log_one_add {x : ℝ} (hx : 0 ≤ x) : x / (1 + x) ≤ Real.log (1 + x) := by
  have hpos : (0:ℝ) < 1 + x := by linarith
  have h := Real.log_le_sub_one_of_pos (x := (1 + x)⁻¹) (by positivity)
  rw [Real.log_inv] at h
  have hrw : (1 + x)⁻¹ - 1 = -(x / (1 + x)) := by field_simp; ring
  rw [hrw] at h
  linarith

/-- `2w ≤ log(1+w) - log(1-w)` for `0 ≤ w ≤ 1/4`: the third-order estimate that is needed
for the monotonicity of `gammaSeqMid` (the second-order estimates are exactly too weak). -/
theorem two_mul_le_log_sub_log {w : ℝ} (hw0 : 0 ≤ w) (hw : w ≤ 1 / 4) :
    2 * w ≤ Real.log (1 + w) - Real.log (1 - w) := by
  have habs : |w| < 1 := by rw [abs_of_nonneg hw0]; linarith
  have habs' : |(-w)| < 1 := by rw [abs_neg, abs_of_nonneg hw0]; linarith
  have h1 := Real.abs_log_sub_add_sum_range_le habs 3
  have h2 := Real.abs_log_sub_add_sum_range_le habs' 3
  rw [abs_of_nonneg hw0] at h1
  rw [abs_neg, abs_of_nonneg hw0] at h2
  simp only [Finset.sum_range_succ, Finset.sum_range_zero] at h1 h2
  norm_num at h1 h2
  have hden : (0:ℝ) < 1 - w := by linarith
  have hb1 := (abs_le.1 h1).2
  have hb2 := (abs_le.1 h2).1
  have hquart : w ^ 4 / (1 - w) ≤ w ^ 3 / 3 := by
    rw [div_le_div_iff₀ hden (by norm_num)]
    nlinarith [pow_nonneg hw0 3, pow_nonneg hw0 4]
  nlinarith [hb1, hb2, hquart, pow_nonneg hw0 3]

/-- The step inequality `1/(n+1) ≤ log (n + 3/2) - log (n + 1/2)` behind the monotonicity of
`gammaSeqMid`. -/
theorem inv_le_log_sub_log (n : ℕ) :
    1 / ((n : ℝ) + 1) ≤ Real.log ((n : ℝ) + 3 / 2) - Real.log ((n : ℝ) + 1 / 2) := by
  rcases Nat.eq_zero_or_pos n with rfl | hn
  · have h : Real.log ((0 : ℝ) + 3 / 2) - Real.log ((0 : ℝ) + 1 / 2) = Real.log 3 := by
      rw [← Real.log_div (by norm_num) (by norm_num)]
      norm_num
    rw [Nat.cast_zero, h]
    linarith [log_three_gt]
  · have hn1 : (1:ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
    set w : ℝ := 1 / (2 * (n : ℝ) + 2) with hw
    have hw0 : 0 ≤ w := by rw [hw]; positivity
    have hw4 : w ≤ 1 / 4 := by
      rw [hw, div_le_div_iff₀ (by linarith) (by norm_num)]
      linarith
    have hpos : (0:ℝ) < (n : ℝ) + 1 := by linarith
    have hA : (n : ℝ) + 3 / 2 = ((n : ℝ) + 1) * (1 + w) := by
      rw [hw]; field_simp; ring
    have hB : (n : ℝ) + 1 / 2 = ((n : ℝ) + 1) * (1 - w) := by
      rw [hw]; field_simp; ring
    have hwpos : (0:ℝ) < 1 - w := by
      rw [hw]
      have : 1 / (2 * (n:ℝ) + 2) < 1 := by
        rw [div_lt_one (by linarith)]; linarith
      linarith
    rw [hA, hB, Real.log_mul (by linarith) (by linarith), Real.log_mul (by linarith)
      (by linarith)]
    have hkey := two_mul_le_log_sub_log hw0 hw4
    have h2w : 2 * w = 1 / ((n : ℝ) + 1) := by
      rw [hw]; field_simp
    linarith [hkey, h2w.symm.le, h2w.le]

/-- `gammaSeqMid` is antitone. -/
theorem antitone_gammaSeqMid : Antitone gammaSeqMid := by
  refine antitone_nat_of_succ_le fun n => ?_
  have hharm : ((harmonic (n + 1) : ℚ) : ℝ) = (harmonic n : ℝ) + 1 / ((n : ℝ) + 1) := by
    rw [harmonic_succ]
    push_cast
    ring
  have hstep := inv_le_log_sub_log n
  simp only [gammaSeqMid]
  push_cast [hharm]
  have hcast : ((n : ℝ) + 1 + 1 / 2) = ((n : ℝ) + 3 / 2) := by ring
  rw [hcast]
  linarith

/-- `gammaSeqMid → γ`. -/
theorem tendsto_gammaSeqMid : Tendsto gammaSeqMid atTop (𝓝 γ) := by
  have hlim : Tendsto (fun x : ℝ => Real.log (x + 1 / 2) - Real.log x) atTop (𝓝 0) :=
    Real.tendsto_log_comp_add_sub_log (1 / 2)
  have hnat : Tendsto (fun n : ℕ => Real.log ((n : ℝ) + 1 / 2) - Real.log (n : ℝ))
      atTop (𝓝 0) := hlim.comp tendsto_natCast_atTop_atTop
  have hsum := Real.tendsto_harmonic_sub_log.sub hnat
  have hfun : (fun n : ℕ => ((harmonic n : ℝ) - Real.log (n : ℝ))
      - (Real.log ((n : ℝ) + 1 / 2) - Real.log (n : ℝ))) = gammaSeqMid := by
    funext n
    simp only [gammaSeqMid]
    ring
  rw [hfun] at hsum
  simpa using hsum

/-- `γ ≤ H_n - log (n + 1/2)` for every `n`. -/
theorem eulerMascheroniConstant_le_gammaSeqMid (n : ℕ) : γ ≤ gammaSeqMid n :=
  antitone_gammaSeqMid.le_of_tendsto tendsto_gammaSeqMid n

/-! ## The numerical bounds -/

/-- `γ < 0.5772287`.  (The true value is `0.5772156…`.) -/
theorem eulerMascheroniConstant_lt_d6 : γ < 0.5772287 := by
  have hkey := eulerMascheroniConstant_le_gammaSeqMid 128
  have hH : (harmonic 128 : ℝ) < 5.43315 := by norm_num [harmonic]
  have hlog2 : (0.6931471803 : ℝ) < Real.log 2 := Real.log_two_gt_d9
  have hsplit : Real.log ((128 : ℕ) + 1 / 2 : ℝ) = 7 * Real.log 2 + Real.log (1 + 1 / 256) := by
    have h : ((128 : ℕ) + 1 / 2 : ℝ) = 2 ^ (7 : ℕ) * (1 + 1 / 256) := by norm_num
    rw [h, Real.log_mul (by positivity) (by norm_num), Real.log_pow]
    push_cast
    ring
  have hlow : (1 / 257 : ℝ) ≤ Real.log (1 + 1 / 256) := by
    have := le_log_one_add (x := (1 / 256 : ℝ)) (by norm_num)
    norm_num at this ⊢
    linarith
  simp only [gammaSeqMid] at hkey
  rw [hsplit] at hkey
  norm_num at hkey ⊢
  linarith

/-- `log π < 1.14474`.  (The true value is `1.1447298…`.) -/
theorem log_pi_lt_d5 : Real.log π < 1.14474 := by
  have hpi : π < 3.14159266 := by linarith [Real.pi_lt_d20]
  have hexp : (3.14159266 : ℝ) < Real.exp 1.14474 := by
    have h := Real.sum_le_exp_of_nonneg (x := (1.14474 : ℝ)) (by norm_num) 12
    refine lt_of_lt_of_le ?_ h
    norm_num [Finset.sum_range_succ, Nat.factorial]
  calc Real.log π < Real.log (Real.exp 1.14474) := Real.log_lt_log Real.pi_pos (hpi.trans hexp)
    _ = 1.14474 := Real.log_exp _

/-- **A sharpened bound for the threshold at the origin**:
`log π + γ + 3 log 2 + π/2 < 5.37221` (the true value is `5.3721834…`).  Compare
`fourierSide_threshold_lt`, which only gives `< 5.3765`. -/
theorem fourierSide_threshold_lt_d5 :
    Real.log π + γ + 3 * Real.log 2 + π / 2 < 5.37221 := by
  have h2 : Real.log 2 < 0.6931471808 := Real.log_two_lt_d9
  have hpi : π < 3.14159266 := by linarith [Real.pi_lt_d20]
  linarith [eulerMascheroniConstant_lt_d6, log_pi_lt_d5]

/-- **A quantitative form of the Fourier-side inequality at the origin**: `f(0) ≥ 0.0072`.
(The true value is `f(0) = 0.0490707…`; the loss comes from the certified lower bound
`δ̂(0) ≥ 5.3795` of `RequestProject/DeltaFourierZero.lean`.) -/
theorem fourierSide_zero_ge : (0.0072 : ℝ) ≤ fourierSide 0 := by
  rw [fourierSide_zero_eq]
  linarith [deltaFourier_zero_ge_d4, fourierSide_threshold_lt_d5]

end ConnesConsani.WeilPositivity
