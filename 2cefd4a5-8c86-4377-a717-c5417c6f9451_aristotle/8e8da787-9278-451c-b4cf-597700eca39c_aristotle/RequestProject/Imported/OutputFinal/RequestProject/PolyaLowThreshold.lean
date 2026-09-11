/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLinThreshold
import RequestProject.Imported.OutputFinal.RequestProject.NearOrigin
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLowBase
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLowBand0
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLowBand1
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLowBand2
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLowBand3
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLowBand4
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLowBand5
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLowBand6
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLowBand7
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLowBand8
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLowBand9
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLowBand10

/-!
# The low-frequency threshold: the Fourier-side inequality for every `t`

The bands of `RequestProject/PolyaLowBand*.lean` cover `0.18 ≤ |t| ≤ 1.8`, the gap
left between `fourierSide_nonneg_of_abs_le` (`|t| ≤ 0.18`) and
`fourierSide_nonneg_of_lin_threshold` (`|t| ≥ 1.8`).

Two devices make the small-frequency range accessible: the exact cancellation of
the first pole of the digamma series against the first pole of the Pólya model
(`fourierSide_nonneg_band_sharp`), and the extension of the resolved partition
from `q = 2.094` to `q = 5`, which lowers the unresolved tail from `0.013709` to
`0.0022`.
-/

set_option maxHeartbeats 4000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

/-- **The Fourier-side inequality on the remaining band `0.18 ≤ |t| ≤ 1.8`.**
Together with `fourierSide_nonneg_of_lin_threshold` this covers every `|t| ≥ 0.18`. -/
theorem fourierSide_nonneg_of_low_threshold {t : ℝ} (ht : (0.18:ℝ) ≤ |t|) :
    0 ≤ fourierSide t := by
  rcases le_or_gt 1.8 |t| with hb | hb
  · exact fourierSide_nonneg_of_lin_threshold hb
  rw [← fourierSide_abs t]
  rcases le_or_gt 1.7425 |t| with g0 | g0
  · refine fourierSide_nonneg_band_sharp (a := 1.7425) (b := 1.8) (by norm_num) g0 hb.le
      (oscLowBand10 g0 hb.le) ?_
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 1.64875 |t| with g1 | g1
  · refine fourierSide_nonneg_band_sharp (a := 1.64875) (b := 1.7425) (by norm_num) g1 g0.le
      (oscLowBand9 g1 g0.le) ?_
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 1.555 |t| with g2 | g2
  · refine fourierSide_nonneg_band_sharp (a := 1.555) (b := 1.64875) (by norm_num) g2 g1.le
      (oscLowBand8 g2 g1.le) ?_
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 1.43 |t| with g3 | g3
  · refine fourierSide_nonneg_band_sharp (a := 1.43) (b := 1.555) (by norm_num) g3 g2.le
      (oscLowBand7 g3 g2.le) ?_
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 1.305 |t| with g4 | g4
  · refine fourierSide_nonneg_band_sharp (a := 1.305) (b := 1.43) (by norm_num) g4 g3.le
      (oscLowBand6 g4 g3.le) ?_
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 1.18 |t| with g5 | g5
  · refine fourierSide_nonneg_band_sharp (a := 1.18) (b := 1.305) (by norm_num) g5 g4.le
      (oscLowBand5 g5 g4.le) ?_
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 1.055 |t| with g6 | g6
  · refine fourierSide_nonneg_band_sharp (a := 1.055) (b := 1.18) (by norm_num) g6 g5.le
      (oscLowBand4 g6 g5.le) ?_
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 0.8675 |t| with g7 | g7
  · refine fourierSide_nonneg_band_sharp (a := 0.8675) (b := 1.055) (by norm_num) g7 g6.le
      (oscLowBand3 g7 g6.le) ?_
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 0.68 |t| with g8 | g8
  · refine fourierSide_nonneg_band_sharp (a := 0.68) (b := 0.8675) (by norm_num) g8 g7.le
      (oscLowBand2 g8 g7.le) ?_
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  rcases le_or_gt 0.43 |t| with g9 | g9
  · refine fourierSide_nonneg_band_sharp (a := 0.43) (b := 0.68) (by norm_num) g9 g8.le
      (oscLowBand1 g9 g8.le) ?_
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]
  · refine fourierSide_nonneg_band_sharp (a := 0.18) (b := 0.43) (by norm_num) ht g9.le
      (oscLowBand0 ht g9.le) ?_
    simp only [thetaSeriesTerm, poleAbscissa]
    norm_num [Finset.sum_Ico_succ_top]

/-- **The Fourier-side inequality, unconditionally**: `2θ'(t) + δ̂(t) ≥ 0` for every
real `t`.  Near the origin (`|t| ≤ 0.18`) this is `fourierSide_nonneg_of_abs_le`, and
beyond that it is the band argument. -/
theorem fourierSide_nonneg (t : ℝ) : 0 ≤ fourierSide t := by
  rcases le_or_gt |t| 0.18 with h | h
  · exact fourierSide_nonneg_of_abs_le h
  · exact fourierSide_nonneg_of_low_threshold h.le

/-- **Corollary 2.3 (ii) of the paper**: the Fourier transform `2θ' + δ̂` of the
distribution defining `L = D + W_∞` is nonnegative. -/
theorem two_thetaDeriv_add_deltaFourier_nonneg (t : ℝ) :
    0 ≤ 2 * thetaDeriv t + deltaFourier t := fourierSide_nonneg t

end ConnesConsani.WeilPositivity
