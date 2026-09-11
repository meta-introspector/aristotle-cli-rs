/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaThreshold
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBand0
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBand1
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBand2
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBand3
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBand4
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBand5
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBand6
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBand7
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBand8
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBand9
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBand10
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBand11
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBand12
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBand13
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBand14
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBand15
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBand16
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBand17
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBand18
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBand19
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBand20
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBand21
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBand22
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBand23
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBand24
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBand25
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBand26

/-!
# The oscillatory Pólya threshold for the Fourier-side inequality

`RequestProject/PolyaThreshold.lean` proves `f(t) = 2θ'(t) + δ̂(t) ≥ 0` for `|t| ≥ 8` using the
crude `L¹` bound `|∫₀^∞ err(v) cos(tv) dv| ≤ ∫₀^∞ |err(v)| dv ≤ 0.21088`, which throws away all
cancellation in the oscillatory integral.

Here the estimate is replaced by the *signed* block bounds of
`RequestProject/PolyaOscBand0.lean`–`PolyaOscBand6.lean`: on each of the 73 blocks of the
partition of the `q`-range `[1, 2.094]`, `cos(tv)` is bracketed by a rational constant `C` up to
a rational error `h`, and the contributions `min(C·P₀, C·P₁) - h·S` are summed.  On the band
`7 ≤ t ≤ 7.25`, for instance, this yields `∫₀^∞ err(v) cos(tv) dv ≥ -0.16014` instead of the
crude `-0.21088`, and that is enough to push the threshold from `8` down to `6.5`.
-/

set_option maxHeartbeats 1000000

noncomputable section

open scoped Real
open MeasureTheory Set

namespace ConnesConsani.WeilPositivity

/-- **One band of the oscillatory threshold argument.**  On a band `a ≤ s ≤ b` with `s ≥ 0`,
the increasing function `2θ'` is bounded below at `a`, the decreasing cosine transform of the
exponential model at `b`, and the oscillatory error integral below by `η`. -/
theorem fourierSide_nonneg_band_osc {a b s η : ℝ} (ha : 0 ≤ a) (hsa : a ≤ s) (hsb : s ≤ b)
    (hη : η ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (s * v))
    (hnum : 0 ≤ ((∑ n ∈ Finset.range 80, thetaSeriesTerm a n) - 5.37221)
      + (1 / (0.25 + b ^ 2) + 12.66 / (9 + b ^ 2)) + 2 * η) :
    0 ≤ fourierSide s := by
  have hs0 : 0 ≤ s := le_trans ha hsa
  have habs : |s| = s := abs_of_nonneg hs0
  have h1 := two_thetaDeriv_ge_series a
  have h2 := two_thetaDeriv_le_of_le_abs ha (by rw [habs]; exact hsa)
  have h3 := modelHat_ge_of_abs_le (b := b) (t := s) (by rw [habs]; exact hsb)
  have h4 := deltaFourier_ge_of_cos_bound hη
  rw [fourierSide]
  linarith

/-- **The Fourier-side inequality for `|t| ≥ 7`.**  This improves the threshold `8` of
`fourierSide_nonneg_of_eight_le_abs`; the gain comes entirely from retaining the cancellation
in the oscillatory integral `∫₀^∞ err(v) cos(tv) dv`. -/
theorem fourierSide_nonneg_of_seven_le_abs {t : ℝ} (ht : 7 ≤ |t|) : 0 ≤ fourierSide t := by
  rcases le_or_gt 8 |t| with h8 | h8
  · exact fourierSide_nonneg_of_eight_le_abs h8
  rw [← fourierSide_abs t]
  rcases le_or_gt 7.5 |t| with h | h
  · refine fourierSide_nonneg_band_osc (a := 7.5) (b := 8) (by norm_num) h h8.le
      (oscBandLower0 h h8.le) ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 7.25 |t| with h' | h'
  · refine fourierSide_nonneg_band_osc (a := 7.25) (b := 7.5) (by norm_num) h' h.le
      (oscBandLower1 h' h.le) ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  · refine fourierSide_nonneg_band_osc (a := 7) (b := 7.25) (by norm_num) ht h'.le
      (oscBandLower2 ht h'.le) ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]

/-- **The Fourier-side inequality for `|t| ≥ 6.5`.** -/
theorem fourierSide_nonneg_of_six_and_half_le_abs {t : ℝ} (ht : 6.5 ≤ |t|) :
    0 ≤ fourierSide t := by
  rcases le_or_gt 7 |t| with h7 | h7
  · exact fourierSide_nonneg_of_seven_le_abs h7
  rw [← fourierSide_abs t]
  rcases le_or_gt 6.875 |t| with h | h
  · refine fourierSide_nonneg_band_osc (a := 6.875) (b := 7) (by norm_num) h h7.le
      (oscBandLower3 h h7.le) ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 6.75 |t| with h' | h'
  · refine fourierSide_nonneg_band_osc (a := 6.75) (b := 6.875) (by norm_num) h' h.le
      (oscBandLower4 h' h.le) ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 6.625 |t| with h'' | h''
  · refine fourierSide_nonneg_band_osc (a := 6.625) (b := 6.75) (by norm_num) h'' h'.le
      (oscBandLower5 h'' h'.le) ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  · refine fourierSide_nonneg_band_osc (a := 6.5) (b := 6.625) (by norm_num) ht h''.le
      (oscBandLower6 ht h''.le) ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]

/-- **The Fourier-side inequality for `|t| ≥ 6`**: `f(t) = 2θ'(t) + δ̂(t) ≥ 0` outside the
interval `|t| < 6`.  Note that this is already below the point `t ≈ 6.29` where the series
lower bound `2θ'(t) ≥ ∑_{n<80} termₙ(t) - 5.37221` for the theta side changes sign. -/
theorem fourierSide_nonneg_of_six_le_abs {t : ℝ} (ht : 6 ≤ |t|) : 0 ≤ fourierSide t := by
  rcases le_or_gt 6.5 |t| with h | h
  · exact fourierSide_nonneg_of_six_and_half_le_abs h
  rw [← fourierSide_abs t]
  rcases le_or_gt 6.375 |t| with h1 | h1
  · refine fourierSide_nonneg_band_osc (a := 6.375) (b := 6.5) (by norm_num) h1 h.le
      (oscBandLower7 h1 h.le) ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 6.3125 |t| with h2 | h2
  · refine fourierSide_nonneg_band_osc (a := 6.3125) (b := 6.375) (by norm_num) h2 h1.le
      (oscBandLower8 h2 h1.le) ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 6.25 |t| with h3 | h3
  · refine fourierSide_nonneg_band_osc (a := 6.25) (b := 6.3125) (by norm_num) h3 h2.le
      (oscBandLower9 h3 h2.le) ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 6.1875 |t| with h4 | h4
  · refine fourierSide_nonneg_band_osc (a := 6.1875) (b := 6.25) (by norm_num) h4 h3.le
      (oscBandLower10 h4 h3.le) ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 6.125 |t| with h5 | h5
  · refine fourierSide_nonneg_band_osc (a := 6.125) (b := 6.1875) (by norm_num) h5 h4.le
      (oscBandLower11 h5 h4.le) ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 6.0625 |t| with h6 | h6
  · refine fourierSide_nonneg_band_osc (a := 6.0625) (b := 6.125) (by norm_num) h6 h5.le
      (oscBandLower12 h6 h5.le) ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  · refine fourierSide_nonneg_band_osc (a := 6) (b := 6.0625) (by norm_num) ht h6.le
      (oscBandLower13 ht h6.le) ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]

/-- **The Fourier-side inequality for `|t| ≥ 5.5`**: `f(t) = 2θ'(t) + δ̂(t) ≥ 0` outside the
interval `|t| < 5.5`.  This is the best large-frequency threshold established in the project,
and it is essentially the limit of the present method: at `t ≈ 5` the requirement
`2E(t) ≥ -(∑_{n<80} termₙ(t) - 5.37221 + 2ĥ(t))` and the signed block bound for
`E(t) = ∫₀^∞ err(v) cos(tv) dv` cross, so below `5` the residual slack of the pointwise
brackets of `RequestProject/PolyaError.lean` would have to be reduced. -/
theorem fourierSide_nonneg_of_five_and_half_le_abs {t : ℝ} (ht : 5.5 ≤ |t|) :
    0 ≤ fourierSide t := by
  rcases le_or_gt 6 |t| with hb | hb
  · exact fourierSide_nonneg_of_six_le_abs hb
  rw [← fourierSide_abs t]
  rcases le_or_gt 5.9375 |t| with g14 | g14
  · refine fourierSide_nonneg_band_osc (a := 5.9375) (b := 6) (by norm_num) g14 hb.le
      (oscBandLower14 g14 hb.le) ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 5.875 |t| with g15 | g15
  · refine fourierSide_nonneg_band_osc (a := 5.875) (b := 5.9375) (by norm_num) g15 g14.le
      (oscBandLower15 g15 g14.le) ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 5.8125 |t| with g16 | g16
  · refine fourierSide_nonneg_band_osc (a := 5.8125) (b := 5.875) (by norm_num) g16 g15.le
      (oscBandLower16 g16 g15.le) ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 5.78125 |t| with g17 | g17
  · refine fourierSide_nonneg_band_osc (a := 5.78125) (b := 5.8125) (by norm_num) g17 g16.le
      (oscBandLower17 g17 g16.le) ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 5.75 |t| with g18 | g18
  · refine fourierSide_nonneg_band_osc (a := 5.75) (b := 5.78125) (by norm_num) g18 g17.le
      (oscBandLower18 g18 g17.le) ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 5.71875 |t| with g19 | g19
  · refine fourierSide_nonneg_band_osc (a := 5.71875) (b := 5.75) (by norm_num) g19 g18.le
      (oscBandLower19 g19 g18.le) ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 5.6875 |t| with g20 | g20
  · refine fourierSide_nonneg_band_osc (a := 5.6875) (b := 5.71875) (by norm_num) g20 g19.le
      (oscBandLower20 g20 g19.le) ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 5.65625 |t| with g21 | g21
  · refine fourierSide_nonneg_band_osc (a := 5.65625) (b := 5.6875) (by norm_num) g21 g20.le
      (oscBandLower21 g21 g20.le) ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 5.625 |t| with g22 | g22
  · refine fourierSide_nonneg_band_osc (a := 5.625) (b := 5.65625) (by norm_num) g22 g21.le
      (oscBandLower22 g22 g21.le) ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 5.59375 |t| with g23 | g23
  · refine fourierSide_nonneg_band_osc (a := 5.59375) (b := 5.625) (by norm_num) g23 g22.le
      (oscBandLower23 g23 g22.le) ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 5.5625 |t| with g24 | g24
  · refine fourierSide_nonneg_band_osc (a := 5.5625) (b := 5.59375) (by norm_num) g24 g23.le
      (oscBandLower24 g24 g23.le) ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 5.53125 |t| with g25 | g25
  · refine fourierSide_nonneg_band_osc (a := 5.53125) (b := 5.5625) (by norm_num) g25 g24.le
      (oscBandLower25 g25 g24.le) ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  · refine fourierSide_nonneg_band_osc (a := 5.5) (b := 5.53125) (by norm_num) ht g25.le
      (oscBandLower26 ht g25.le) ?_
    rw [Finset.range_eq_Ico]
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]

end ConnesConsani.WeilPositivity
