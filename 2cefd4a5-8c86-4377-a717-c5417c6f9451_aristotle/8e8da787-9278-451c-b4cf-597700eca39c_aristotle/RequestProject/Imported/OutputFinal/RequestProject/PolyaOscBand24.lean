/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscTail

/-!
# Oscillatory lower bound on the band `5.5625 ≤ t ≤ 5.59375`

On each of the 73 blocks the factor `cos(tv)` is bracketed by a rational constant
`C` up to a rational error `h`; the signed contribution `min(C·P₀, C·P₁) - h·S` is
then summed, and the unresolved tail beyond `q = 2.094` is estimated in absolute
value.  The result is the bound `∫₀^∞ err(v) cos(tv) dv ≥ -0.10841096`.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosB24i0 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00641868):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.0038), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.02121597) (m := (0:ℤ)) (ylo := 0.02121597) (yhi := 0.02121597)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1) (q1 := 1.0038) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.0) (B := 0.0075856) (X := 0.02121597) (rho := 0.02121599)
    (clo := 0.99977494) (chi := 0.99977495) (C := 0.98927947) (h := 0.01072053)
    (by norm_num) (by norm_num) oscBlock0 vbpBr0.1 vbpBr1.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i1 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00625872):ℝ) ≤ ∫ v in (vBP 1.0038)..(vBP 1.0078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.0645594) (m := (0:ℤ)) (ylo := 0.0645594) (yhi := 0.0645594)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0038) (q1 := 1.0078) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.00758559) (B := 0.01553948) (X := 0.0645594) (rho := 0.02236458)
    (clo := 0.99791676) (chi := 0.99791677) (C := 0.98777609) (h := 0.01222391)
    (by norm_num) (by norm_num) oscBlock1 vbpBr1.1 vbpBr2.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i2 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.0057677):ℝ) ≤ ∫ v in (vBP 1.0078)..(vBP 1.0118), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.10883901) (m := (0:ℤ)) (ylo := 0.10883901) (yhi := 0.10883901)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0078) (q1 := 1.0118) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.01553947) (B := 0.02346185) (X := 0.10883901) (rho := 0.02240073)
    (clo := 0.99408287) (chi := 0.99408288) (C := 0.98584107) (h := 0.01415893)
    (by norm_num) (by norm_num) oscBlock2 vbpBr2.1 vbpBr3.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i3 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00554846):ℝ) ≤ ∫ v in (vBP 1.0118)..(vBP 1.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.15404479) (m := (0:ℤ)) (ylo := 0.15404479) (yhi := 0.15404479)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0118) (q1 := 1.016) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.02346184) (B := 0.0317467) (X := 0.15404479) (rho := 0.02353832)
    (clo := 0.98815854) (chi := 0.98815855) (C := 0.98231011) (h := 0.01768989)
    (by norm_num) (by norm_num) oscBlock3 vbpBr3.1 vbpBr4.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i4 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00539232):ℝ) ≤ ∫ v in (vBP 1.016)..(vBP 1.0205), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.2018078) (m := (0:ℤ)) (ylo := 0.2018078) (yhi := 0.2018078)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.016) (q1 := 1.0205) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.03174669) (B := 0.04058541) (X := 0.2018078) (rho := 0.02521685)
    (clo := 0.97970582) (chi := 0.97970583) (C := 0.97724448) (h := 0.02275552)
    (by norm_num) (by norm_num) oscBlock4 vbpBr4.1 vbpBr5.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i5 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00482142):ℝ) ≤ ∫ v in (vBP 1.0205)..(vBP 1.025), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.25100245) (m := (0:ℤ)) (ylo := 0.25100245) (yhi := 0.25100245)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0205) (q1 := 1.025) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.0405854) (B := 0.04938523) (X := 0.25100245) (rho := 0.02524619)
    (clo := 0.96866392) (chi := 0.96866393) (C := 0.96866392) (h := 0.0252462)
    (by norm_num) (by norm_num) oscBlock5 vbpBr5.1 vbpBr6.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i6 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00470713):ℝ) ≤ ∫ v in (vBP 1.025)..(vBP 1.03), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.3026972) (m := (0:ℤ)) (ylo := 0.3026972) (yhi := 0.3026972)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.025) (q1 := 1.03) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.04938522) (B := 0.05911761) (X := 0.3026972) (rho := 0.02799194)
    (clo := 0.95453593) (chi := 0.95453594) (C := 0.95453593) (h := 0.02799195)
    (by norm_num) (by norm_num) oscBlock6 vbpBr6.1 vbpBr7.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i7 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00441526):ℝ) ≤ ∫ v in (vBP 1.03)..(vBP 1.0355), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.35955546) (m := (0:ℤ)) (ylo := 0.35955546) (yhi := 0.35955546)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.03) (q1 := 1.0355) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.0591176) (B := 0.06976881) (X := 0.35955546) (rho := 0.03071383)
    (clo := 0.93605333) (chi := 0.93605334) (C := 0.93605333) (h := 0.03071384)
    (by norm_num) (by norm_num) oscBlock7 vbpBr7.1 vbpBr8.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i8 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00396522):ℝ) ≤ ∫ v in (vBP 1.0355)..(vBP 1.0415), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.42149745) (m := (0:ℤ)) (ylo := 0.42149745) (yhi := 0.42149745)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0355) (q1 := 1.0415) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.0697688) (B := 0.08132397) (X := 0.42149745) (rho := 0.03340852)
    (clo := 0.91247731) (chi := 0.91247732) (C := 0.91247731) (h := 0.03340853)
    (by norm_num) (by norm_num) oscBlock8 vbpBr8.1 vbpBr9.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i9 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00338171):ℝ) ≤ ∫ v in (vBP 1.0415)..(vBP 1.048), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.48843734) (m := (0:ℤ)) (ylo := 0.48843734) (yhi := 0.48843734)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0415) (q1 := 1.048) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.08132396) (B := 0.09376718) (X := 0.48843734) (rho := 0.03607283)
    (clo := 0.8830672) (chi := 0.88306721) (C := 0.8830672) (h := 0.03607284)
    (by norm_num) (by norm_num) oscBlock9 vbpBr9.1 vbpBr10.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i10 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00271501):ℝ) ≤ ∫ v in (vBP 1.048)..(vBP 1.055), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.56028362) (m := (0:ℤ)) (ylo := 0.56028362) (yhi := 0.56028362)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.048) (q1 := 1.055) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.09376717) (B := 0.10708154) (X := 0.56028362) (rho := 0.03870376)
    (clo := 0.84710442) (chi := 0.84710443) (C := 0.84710442) (h := 0.03870377)
    (by norm_num) (by norm_num) oscBlock10 vbpBr10.1 vbpBr11.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i11 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00226221):ℝ) ≤ ∫ v in (vBP 1.055)..(vBP 1.064), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.64483099) (m := (0:ℤ)) (ylo := 0.64483099) (yhi := 0.64483099)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.055) (q1 := 1.064) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.10708153) (B := 0.12407079) (X := 0.64483099) (rho := 0.04919)
    (clo := 0.79920136) (chi := 0.79920137) (C := 0.79920136) (h := 0.04919001)
    (by norm_num) (by norm_num) oscBlock11 vbpBr11.1 vbpBr12.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i12 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.0014813):ℝ) ≤ ∫ v in (vBP 1.064)..(vBP 1.078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.76520429) (m := (0:ℤ)) (ylo := 0.76520429) (yhi := 0.76520429)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.064) (q1 := 1.078) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.12407078) (B := 0.15021495) (X := 0.76520429) (rho := 0.0750606)
    (clo := 0.72124086) (chi := 0.72124089) (C := 0.72124087) (h := 0.07506062)
    (by norm_num) (by norm_num) oscBlock12 vbpBr12.1 vbpBr13.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i13 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    (0.00021204:ℝ) ≤ ∫ v in (vBP 1.078)..(vBP 1.09), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.89984181) (m := (0:ℤ)) (ylo := 0.89984181) (yhi := 0.89984181)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.078) (q1 := 1.09) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.15021494) (B := 0.1723554) (X := 0.89984181) (rho := 0.06427122)
    (clo := 0.62173387) (chi := 0.62173398) (C := 0.62173392) (h := 0.06427128)
    (by norm_num) (by norm_num) oscBlock13 vbpBr13.1 vbpBr14.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i14 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    (0.00081016:ℝ) ≤ ∫ v in (vBP 1.09)..(vBP 1.1), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.01250474) (m := (0:ℤ)) (ylo := 1.01250474) (yhi := 1.01250474)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.09) (q1 := 1.1) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.17235539) (B := 0.19062036) (X := 1.01250474) (rho := 0.05377791)
    (clo := 0.52973795) (chi := 0.52973828) (C := 0.52973811) (h := 0.05377808)
    (by norm_num) (by norm_num) oscBlock14 vbpBr14.1 vbpBr15.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i15 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    (0.00093903:ℝ) ≤ ∫ v in (vBP 1.1)..(vBP 1.109), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.108885) (m := (0:ℤ)) (ylo := 1.108885) (yhi := 1.108885)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.1) (q1 := 1.109) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.19062035) (B := 0.20691742) (X := 1.108885) (rho := 0.04855933)
    (clo := 0.44565993) (chi := 0.44566072) (C := 0.44566032) (h := 0.04855973)
    (by norm_num) (by norm_num) oscBlock15 vbpBr15.1 vbpBr16.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i16 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    (0.00084775:ℝ) ≤ ∫ v in (vBP 1.109)..(vBP 1.117), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.19441804) (m := (0:ℤ)) (ylo := 1.19441804) (yhi := 1.19441804)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.109) (q1 := 1.117) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.20691741) (B := 0.22129305) (X := 1.19441804) (rho := 0.04343997)
    (clo := 0.36755466) (chi := 0.3675563) (C := 0.36755548) (h := 0.04344079)
    (by norm_num) (by norm_num) oscBlock16 vbpBr16.1 vbpBr17.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i17 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    (0.00067623:ℝ) ≤ ∫ v in (vBP 1.117)..(vBP 1.124), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.2693457) (m := (0:ℤ)) (ylo := 1.2693457) (yhi := 1.2693457)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.117) (q1 := 1.124) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.22129304) (B := 0.23378751) (X := 1.2693457) (rho := 0.03840319)
    (clo := 0.29690569) (chi := 0.29690869) (C := 0.29690719) (h := 0.03840469)
    (by norm_num) (by norm_num) oscBlock17 vbpBr17.1 vbpBr18.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i18 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    (0.00054573:ℝ) ≤ ∫ v in (vBP 1.124)..(vBP 1.131), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.33882441) (m := (0:ℤ)) (ylo := 1.33882441) (yhi := 1.33882441)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.124) (q1 := 1.131) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.2337875) (B := 0.2462044) (X := 1.33882441) (rho := 0.03838146)
    (clo := 0.22989699) (chi := 0.2299021) (C := 0.22989954) (h := 0.03838402)
    (by norm_num) (by norm_num) oscBlock18 vbpBr18.1 vbpBr19.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i19 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    (0.00037258:ℝ) ≤ ∫ v in (vBP 1.131)..(vBP 1.138), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.40787311) (m := (0:ℤ)) (ylo := 1.40787311) (yhi := 1.40787311)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.131) (q1 := 1.138) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.24620439) (B := 0.25854468) (X := 1.40787311) (rho := 0.03836121)
    (clo := 0.16220327) (chi := 0.16221171) (C := 0.16220749) (h := 0.03836543)
    (by norm_num) (by norm_num) oscBlock19 vbpBr19.1 vbpBr20.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i20 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    (0.00017217:ℝ) ≤ ∫ v in (vBP 1.138)..(vBP 1.145), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.47649706) (m := (0:ℤ)) (ylo := 1.47649706) (yhi := 1.47649706)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.138) (q1 := 1.145) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.25854467) (B := 0.27080928) (X := 1.47649706) (rho := 0.03834236)
    (clo := 0.09415935) (chi := 0.09417292) (C := 0.09416613) (h := 0.03834915)
    (by norm_num) (by norm_num) oscBlock20 vbpBr20.1 vbpBr21.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i21 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00005632):ℝ) ≤ ∫ v in (vBP 1.145)..(vBP 1.152), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.54470147) (m := (0:ℤ)) (ylo := 1.54470147) (yhi := 1.54470147)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.145) (q1 := 1.152) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.27080927) (B := 0.28299913) (X := 1.54470147) (rho := 0.03832492)
    (clo := 0.02609151) (chi := 0.02611283) (C := 0.02610217) (h := 0.03833558)
    (by norm_num) (by norm_num) oscBlock21 vbpBr21.1 vbpBr22.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i22 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00031211):ℝ) ≤ ∫ v in (vBP 1.152)..(vBP 1.159), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.61249143) (m := (0:ℤ)) (ylo := 0.0416951) (yhi := 0.04169511)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.152) (q1 := 1.159) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.28299912) (B := 0.29511513) (X := 1.61249143) (rho := 0.03830884)
    (clo := (-0.04168304)) (chi := (-0.04168302)) (C := (-0.04168303)) (h := 0.03830885)
    (by norm_num) (by norm_num) oscBlock22 vbpBr22.1 vbpBr23.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i23 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00057905):ℝ) ≤ ∫ v in (vBP 1.159)..(vBP 1.166), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.67987196) (m := (0:ℤ)) (ylo := 0.10907563) (yhi := 0.10907564)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.159) (q1 := 1.166) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.29511512) (B := 0.30715818) (X := 1.67987196) (rho := 0.03829412)
    (clo := (-0.10885949)) (chi := (-0.10885947)) (C := (-0.10885948)) (h := 0.03829413)
    (by norm_num) (by norm_num) oscBlock23 vbpBr23.1 vbpBr24.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i24 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00083936):ℝ) ≤ ∫ v in (vBP 1.166)..(vBP 1.173), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.74684797) (m := (0:ℤ)) (ylo := 0.17605164) (yhi := 0.17605165)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.166) (q1 := 1.173) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.30715817) (B := 0.31912914) (X := 1.74684797) (rho := 0.03828067)
    (clo := (-0.17514363)) (chi := (-0.17514361)) (C := (-0.17514362)) (h := 0.03828068)
    (by norm_num) (by norm_num) oscBlock24 vbpBr24.1 vbpBr25.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i25 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00108564):ℝ) ≤ ∫ v in (vBP 1.173)..(vBP 1.18), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.81342429) (m := (0:ℤ)) (ylo := 0.24262796) (yhi := 0.24262797)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.173) (q1 := 1.18) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.31912913) (B := 0.33102888) (X := 1.81342429) (rho := 0.03826852)
    (clo := (-0.24025445)) (chi := (-0.24025444)) (C := (-0.24025445)) (h := 0.03826853)
    (by norm_num) (by norm_num) oscBlock25 vbpBr25.1 vbpBr26.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i26 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00131151):ℝ) ≤ ∫ v in (vBP 1.18)..(vBP 1.187), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.87960568) (m := (0:ℤ)) (ylo := 0.30880935) (yhi := 0.30880936)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.18) (q1 := 1.187) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.33102887) (B := 0.34285824) (X := 1.87960568) (rho := 0.03825761)
    (clo := (-0.30392454)) (chi := (-0.30392452)) (C := (-0.30392453)) (h := 0.03825762)
    (by norm_num) (by norm_num) oscBlock26 vbpBr26.1 vbpBr27.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i27 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00151166):ℝ) ≤ ∫ v in (vBP 1.187)..(vBP 1.194), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.94539678) (m := (0:ℤ)) (ylo := 0.37460045) (yhi := 0.37460046)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.187) (q1 := 1.194) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.34285823) (B := 0.35461804) (X := 1.94539678) (rho := 0.03824789)
    (clo := (-0.36590073)) (chi := (-0.36590071)) (C := (-0.36590072)) (h := 0.0382479)
    (by norm_num) (by norm_num) oscBlock27 vbpBr27.1 vbpBr28.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i28 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.0016991):ℝ) ≤ ∫ v in (vBP 1.194)..(vBP 1.201), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.0108021) (m := (0:ℤ)) (ylo := 0.44000577) (yhi := 0.44000578)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.194) (q1 := 1.201) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.35461802) (B := 0.36630909) (X := 2.0108021) (rho := 0.03823938)
    (clo := (-0.4259447)) (chi := (-0.42594468)) (C := (-0.42594469)) (h := 0.03823939)
    (by norm_num) (by norm_num) oscBlock28 vbpBr28.1 vbpBr29.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i29 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00183799):ℝ) ≤ ∫ v in (vBP 1.201)..(vBP 1.208), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.07582625) (m := (0:ℤ)) (ylo := 0.50502992) (yhi := 0.50502993)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.201) (q1 := 1.208) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.36630908) (B := 0.3779322) (X := 2.07582625) (rho := 0.03823201)
    (clo := (-0.48383364)) (chi := (-0.48383362)) (C := (-0.48383363)) (h := 0.03823202)
    (by norm_num) (by norm_num) oscBlock29 vbpBr29.1 vbpBr30.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i30 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00194145):ℝ) ≤ ∫ v in (vBP 1.208)..(vBP 1.215), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.1404736) (m := (0:ℤ)) (ylo := 0.56967727) (yhi := 0.56967728)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.208) (q1 := 1.215) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.37793219) (B := 0.38948816) (X := 2.1404736) (rho := 0.03822581)
    (clo := (-0.53936033)) (chi := (-0.53936031)) (C := (-0.53936032)) (h := 0.03822582)
    (by norm_num) (by norm_num) oscBlock30 vbpBr30.1 vbpBr31.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i31 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.0023156):ℝ) ≤ ∫ v in (vBP 1.215)..(vBP 1.223), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.20932416) (m := (0:ℤ)) (ylo := 0.63852783) (yhi := 0.63852784)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.215) (q1 := 1.223) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.38948815) (B := 0.40261372) (X := 2.20932416) (rho := 0.04279635)
    (clo := (-0.59601399)) (chi := (-0.59601397)) (C := (-0.59601398)) (h := 0.04279636)
    (by norm_num) (by norm_num) oscBlock31 vbpBr31.1 vbpBr32.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i32 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00234714):ℝ) ≤ ∫ v in (vBP 1.223)..(vBP 1.231), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.28230082) (m := (0:ℤ)) (ylo := 0.71150449) (yhi := 0.7115045)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.223) (q1 := 1.231) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.40261371) (B := 0.4156537) (X := 2.28230082) (rho := 0.04276208)
    (clo := (-0.65297399)) (chi := (-0.65297398)) (C := (-0.65297399)) (h := 0.04276209)
    (by norm_num) (by norm_num) oscBlock32 vbpBr32.1 vbpBr33.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i33 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00232547):ℝ) ≤ ∫ v in (vBP 1.231)..(vBP 1.239), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.3548032) (m := (0:ℤ)) (ylo := 0.78400687) (yhi := 0.78400688)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.231) (q1 := 1.239) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.41565369) (B := 0.42860921) (X := 2.3548032) (rho := 0.04272957)
    (clo := (-0.70612232)) (chi := (-0.7061223)) (C := (-0.70612231)) (h := 0.04272958)
    (by norm_num) (by norm_num) oscBlock33 vbpBr33.1 vbpBr34.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i34 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00254263):ℝ) ≤ ∫ v in (vBP 1.239)..(vBP 1.248), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.43132143) (m := (0:ℤ)) (ylo := 0.8605251) (yhi := 0.86052511)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.239) (q1 := 1.248) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.4286092) (B := 0.44308455) (X := 2.43132143) (rho := 0.04718278)
    (clo := (-0.75818507)) (chi := (-0.75818505)) (C := (-0.75818506)) (h := 0.04718279)
    (by norm_num) (by norm_num) oscBlock34 vbpBr34.1 vbpBr35.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i35 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00265251):ℝ) ≤ ∫ v in (vBP 1.248)..(vBP 1.258), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.51622402) (m := (0:ℤ)) (ylo := 0.94542769) (yhi := 0.9454277)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.248) (q1 := 1.258) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.44308453) (B := 0.45904632) (X := 2.51622402) (rho := 0.05156634)
    (clo := (-0.8107474)) (chi := (-0.81074737)) (C := (-0.81074739)) (h := 0.05156636)
    (by norm_num) (by norm_num) oscBlock35 vbpBr35.1 vbpBr36.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i36 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00241206):ℝ) ≤ ∫ v in (vBP 1.258)..(vBP 1.268), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.60490736) (m := (0:ℤ)) (ylo := 1.03411103) (yhi := 1.03411104)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.258) (q1 := 1.268) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.45904631) (B := 0.47488172) (X := 2.60490736) (rho := 0.05146228)
    (clo := (-0.85940822)) (chi := (-0.85940817)) (C := (-0.8594082)) (h := 0.05146231)
    (by norm_num) (by norm_num) oscBlock36 vbpBr36.1 vbpBr37.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i37 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00251881):ℝ) ≤ ∫ v in (vBP 1.268)..(vBP 1.28), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.70163832) (m := (0:ℤ)) (ylo := 1.13084199) (yhi := 1.130842)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.268) (q1 := 1.28) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.4748817) (B := 0.49372017) (X := 2.70163832) (rho := 0.06010889)
    (clo := (-0.90477122)) (chi := (-0.90477111)) (C := (-0.90477117)) (h := 0.06010895)
    (by norm_num) (by norm_num) oscBlock37 vbpBr37.1 vbpBr38.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i38 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.0022862):ℝ) ≤ ∫ v in (vBP 1.28)..(vBP 1.294), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.81488222) (m := (0:ℤ)) (ylo := 1.24408589) (yhi := 1.2440859)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.28) (q1 := 1.294) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.49372014) (B := 0.51547641) (X := 2.81488222) (rho := 0.06856396)
    (clo := (-0.94710347)) (chi := (-0.94710318)) (C := (-0.93926961)) (h := 0.06073039)
    (by norm_num) (by norm_num) oscBlock38 vbpBr38.1 vbpBr39.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i39 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00152768):ℝ) ≤ ∫ v in (vBP 1.294)..(vBP 1.308), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.93558644) (m := (0:ℤ)) (ylo := 1.36479011) (yhi := 1.36479012)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.294) (q1 := 1.308) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.51547638) (B := 0.53699853) (X := 2.93558644) (rho := 0.0682491)
    (clo := (-0.97885642)) (chi := (-0.97885564)) (C := (-0.95530327)) (h := 0.04469673)
    (by norm_num) (by norm_num) oscBlock39 vbpBr39.1 vbpBr40.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i40 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.000994):ℝ) ≤ ∫ v in (vBP 1.308)..(vBP 1.326), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.07189817) (m := (0:ℤ)) (ylo := 1.50110184) (yhi := 1.50110185)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.308) (q1 := 1.326) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.53699848) (B := 0.56433382) (X := 3.07189817) (rho := 0.08484415)
    (clo := (-0.99757448)) (chi := (-0.99757229)) (C := (-0.95636407)) (h := 0.04363593)
    (by norm_num) (by norm_num) oscBlock40 vbpBr40.1 vbpBr41.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i41 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    (0.00003215:ℝ) ≤ ∫ v in (vBP 1.326)..(vBP 1.345), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.22750737) (m := (0:ℤ)) (ylo := 0.08591471) (yhi := 0.08591472)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.326) (q1 := 1.345) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.56433374) (B := 0.59278808) (X := 3.22750737) (rho := 0.08840096)
    (clo := (-0.99631161)) (chi := (-0.9963116)) (C := (-0.95395532)) (h := 0.04604468)
    (by norm_num) (by norm_num) oscBlock41 vbpBr41.1 vbpBr42.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i42 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    (0.00093584:ℝ) ≤ ∫ v in (vBP 1.345)..(vBP 1.362), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.37690434) (m := (0:ℤ)) (ylo := 0.23531168) (yhi := 0.23531169)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.345) (q1 := 1.362) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.59278796) (B := 0.6179085) (X := 3.37690434) (rho := 0.07952134)
    (clo := (-0.97244173)) (chi := (-0.97244171)) (C := (-0.94646019)) (h := 0.05353982)
    (by norm_num) (by norm_num) oscBlock42 vbpBr42.1 vbpBr43.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i43 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    (0.00109351:ℝ) ≤ ∫ v in (vBP 1.362)..(vBP 1.376), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.50397508) (m := (0:ℤ)) (ylo := 0.36238242) (yhi := 0.36238243)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.362) (q1 := 1.376) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.61790831) (B := 0.6383616) (X := 3.50397508) (rho := 0.06686013)
    (clo := (-0.93505491)) (chi := (-0.93505489)) (C := (-0.93409738)) (h := 0.06590262)
    (by norm_num) (by norm_num) oscBlock43 vbpBr43.1 vbpBr44.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i44 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    (0.00122409:ℝ) ≤ ∫ v in (vBP 1.376)..(vBP 1.39), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.61748577) (m := (0:ℤ)) (ylo := 0.47589311) (yhi := 0.47589312)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.376) (q1 := 1.39) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.63836133) (B := 0.65860767) (X := 3.61748577) (rho := 0.06660089)
    (clo := (-0.88888392)) (chi := (-0.8888839)) (C := (-0.88888391)) (h := 0.0666009)
    (by norm_num) (by norm_num) oscBlock44 vbpBr44.1 vbpBr45.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i45 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    (0.00122669:ℝ) ≤ ∫ v in (vBP 1.39)..(vBP 1.404), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.72985314) (m := (0:ℤ)) (ylo := 0.58826048) (yhi := 0.58826049)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.39) (q1 := 1.404) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.65860729) (B := 0.67865086) (X := 3.72985314) (rho := 0.06635011)
    (clo := (-0.83190723)) (chi := (-0.83190721)) (C := (-0.83190722)) (h := 0.06635012)
    (by norm_num) (by norm_num) oscBlock45 vbpBr45.1 vbpBr46.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i46 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    (0.001124:ℝ) ≤ ∫ v in (vBP 1.404)..(vBP 1.418), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.84109996) (m := (0:ℤ)) (ylo := 0.6995073) (yhi := 0.69950731)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.404) (q1 := 1.418) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.67865033) (B := 0.69849519) (X := 3.84109996) (rho := 0.06610752)
    (clo := (-0.76515951)) (chi := (-0.76515949)) (C := (-0.7651595)) (h := 0.06610753)
    (by norm_num) (by norm_num) oscBlock46 vbpBr46.1 vbpBr47.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i47 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    (0.00094546:ℝ) ≤ ∫ v in (vBP 1.418)..(vBP 1.432), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.95124839) (m := (0:ℤ)) (ylo := 0.80965573) (yhi := 0.80965574)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.418) (q1 := 1.432) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.69849446) (B := 0.7181446) (X := 3.95124839) (rho := 0.06587298)
    (clo := (-0.68974778)) (chi := (-0.68974773)) (C := (-0.68974776)) (h := 0.06587301)
    (by norm_num) (by norm_num) oscBlock47 vbpBr47.1 vbpBr48.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i48 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    (0.00072267:ℝ) ≤ ∫ v in (vBP 1.432)..(vBP 1.446), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.06031988) (m := (0:ℤ)) (ylo := 0.91872722) (yhi := 0.91872723)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.432) (q1 := 1.446) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.7181436) (B := 0.73760286) (X := 4.06031988) (rho := 0.06564613)
    (clo := (-0.60683241)) (chi := (-0.60683228)) (C := (-0.60683235)) (h := 0.0656462)
    (by norm_num) (by norm_num) oscBlock48 vbpBr48.1 vbpBr49.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i49 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    (0.00051925:ℝ) ≤ ∫ v in (vBP 1.446)..(vBP 1.462), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.17599289) (m := (0:ℤ)) (ylo := 1.03440023) (yhi := 1.03440024)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.446) (q1 := 1.462) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.73760153) (B := 0.75961158) (X := 4.17599289) (rho := 0.0730844)
    (clo := (-0.51104195)) (chi := (-0.51104154)) (C := (-0.51104175)) (h := 0.07308461)
    (by norm_num) (by norm_num) oscBlock49 vbpBr49.1 vbpBr50.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i50 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00031158):ℝ) ≤ ∫ v in (vBP 1.462)..(vBP 1.478), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.29808901) (m := (0:ℤ)) (ylo := 1.15649635) (yhi := 1.15649636)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.462) (q1 := 1.478) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.75960973) (B := 0.78138081) (X := 4.29808901) (rho := 0.07275991)
    (clo := (-0.4025504)) (chi := (-0.4025492)) (C := (-0.4025498)) (h := 0.07276051)
    (by norm_num) (by norm_num) oscBlock50 vbpBr50.1 vbpBr51.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i51 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00045946):ℝ) ≤ ∫ v in (vBP 1.478)..(vBP 1.495), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.42260633) (m := (0:ℤ)) (ylo := 1.28101367) (yhi := 1.28101368)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.478) (q1 := 1.495) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.7813783) (B := 0.80425401) (X := 4.42260633) (rho := 0.07618955)
    (clo := (-0.28574719)) (chi := (-0.2857439)) (C := (-0.28574555)) (h := 0.0761912)
    (by norm_num) (by norm_num) oscBlock51 vbpBr51.1 vbpBr52.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i52 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00030508):ℝ) ≤ ∫ v in (vBP 1.495)..(vBP 1.512), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.54947032) (m := (0:ℤ)) (ylo := 1.40787766) (yhi := 1.40787767)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.495) (q1 := 1.512) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.80425056) (B := 0.82686872) (X := 4.54947032) (rho := 0.0758266)
    (clo := (-0.16220722)) (chi := (-0.16219877)) (C := (-0.162203)) (h := 0.07583083)
    (by norm_num) (by norm_num) oscBlock52 vbpBr52.1 vbpBr53.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i53 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00019457):ℝ) ≤ ∫ v in (vBP 1.512)..(vBP 1.531), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.68222023) (m := (0:ℤ)) (ylo := 1.54062757) (yhi := 1.54062758)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.512) (q1 := 1.531) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.82686405) (B := 0.85184522) (X := 4.68222023) (rho := 0.08278898)
    (clo := (-0.03018458)) (chi := (-0.0301638)) (C := (-0.03017419)) (h := 0.08279937)
    (by norm_num) (by norm_num) oscBlock53 vbpBr53.1 vbpBr54.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i54 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00034514):ℝ) ≤ ∫ v in (vBP 1.531)..(vBP 1.55), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.82067647) (m := (0:ℤ)) (ylo := 0.10828748) (yhi := 0.10828749)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.531) (q1 := 1.55) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.85183877) (B := 0.87651393) (X := 4.82067647) (rho := 0.08232333)
    (clo := 0.10807597) (chi := 0.10807599) (C := 0.10807598) (h := 0.08232334)
    (by norm_num) (by norm_num) oscBlock54 vbpBr54.1 vbpBr55.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i55 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00057972):ℝ) ≤ ∫ v in (vBP 1.55)..(vBP 1.57), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.96099969) (m := (0:ℤ)) (ylo := 0.2486107) (yhi := 0.24861071)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.55) (q1 := 1.57) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.87650515) (B := 0.90215678) (X := 4.96099969) (rho := 0.08543981)
    (clo := 0.24605761) (chi := 0.24605763) (C := 0.24605762) (h := 0.08543982)
    (by norm_num) (by norm_num) oscBlock55 vbpBr55.1 vbpBr56.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i56 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00074485):ℝ) ≤ ∫ v in (vBP 1.57)..(vBP 1.59), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.10312323) (m := (0:ℤ)) (ylo := 0.39073424) (yhi := 0.39073425)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.57) (q1 := 1.59) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.90214481) (B := 0.92747548) (X := 5.10312323) (rho := 0.08494275)
    (clo := 0.38086741) (chi := 0.38086743) (C := 0.38086742) (h := 0.08494276)
    (by norm_num) (by norm_num) oscBlock56 vbpBr56.1 vbpBr57.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i57 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00086514):ℝ) ≤ ∫ v in (vBP 1.59)..(vBP 1.61), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.24345903) (m := (0:ℤ)) (ylo := 0.53107004) (yhi := 0.53107005)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.59) (q1 := 1.61) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.92745939) (B := 0.95247825) (X := 5.24345903) (rho := 0.08446619)
    (clo := 0.50645628) (chi := 0.5064563) (C := 0.50645629) (h := 0.0844662)
    (by norm_num) (by norm_num) oscBlock57 vbpBr57.1 vbpBr58.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i58 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00106982):ℝ) ≤ ∫ v in (vBP 1.61)..(vBP 1.632), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.38891174) (m := (0:ℤ)) (ylo := 0.67652275) (yhi := 0.67652276)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.61) (q1 := 1.632) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.95245689) (B := 0.97962584) (X := 5.38891174) (rho := 0.09087031)
    (clo := 0.62608541) (chi := 0.62608543) (C := 0.62608542) (h := 0.09087032)
    (by norm_num) (by norm_num) oscBlock58 vbpBr58.1 vbpBr59.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i59 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00125621):ℝ) ≤ ∫ v in (vBP 1.632)..(vBP 1.656), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.54607091) (m := (0:ℤ)) (ylo := 0.83368192) (yhi := 0.83368193)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.632) (q1 := 1.656) (t0 := 5.5625) (t1 := 5.59375)
    (A := 0.97959707) (B := 1.00882827) (X := 5.54607091) (rho := 0.09706223)
    (clo := 0.7404112) (chi := 0.74041122) (C := 0.74041121) (h := 0.09706224)
    (by norm_num) (by norm_num) oscBlock59 vbpBr59.1 vbpBr60.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i60 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00126834):ℝ) ≤ ∫ v in (vBP 1.656)..(vBP 1.68), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.70776555) (m := (0:ℤ)) (ylo := 0.99537656) (yhi := 0.99537657)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.656) (q1 := 1.68) (t0 := 5.5625) (t1 := 5.59375)
    (A := 1.00878907) (B := 1.03761196) (X := 5.70776555) (rho := 0.09637636)
    (clo := 0.83896394) (chi := 0.83896398) (C := 0.83896396) (h := 0.09637638)
    (by norm_num) (by norm_num) oscBlock60 vbpBr60.1 vbpBr61.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i61 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00122808):ℝ) ≤ ∫ v in (vBP 1.68)..(vBP 1.704), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.86715029) (m := (0:ℤ)) (ylo := 1.1547613) (yhi := 1.15476131)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.68) (q1 := 1.704) (t0 := 5.5625) (t1 := 5.59375)
    (A := 1.03755935) (B := 1.06598913) (X := 5.86715029) (rho := 0.09572642)
    (clo := 0.91469851) (chi := 0.91469865) (C := 0.90948604) (h := 0.09051396)
    (by norm_num) (by norm_num) oscBlock61 vbpBr61.1 vbpBr62.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i62 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00137159):ℝ) ≤ ∫ v in (vBP 1.704)..(vBP 1.734), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.04368723) (m := (0:ℤ)) (ylo := 1.33129824) (yhi := 1.33129825)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.704) (q1 := 1.734) (t0 := 5.5625) (t1 := 5.59375)
    (A := 1.06591948) (B := 1.10090679) (X := 6.04368723) (rho := 0.11451014)
    (clo := 0.97145715) (chi := 0.97145774) (C := 0.9284735) (h := 0.0715265)
    (by norm_num) (by norm_num) oscBlock62 vbpBr62.1 vbpBr63.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i63 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00129873):ℝ) ≤ ∫ v in (vBP 1.734)..(vBP 1.766), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.24306415) (m := (0:ℤ)) (ylo := 1.53067516) (yhi := 1.53067517)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.734) (q1 := 1.766) (t0 := 5.5625) (t1 := 5.59375)
    (A := 1.10080961) (B := 1.13749718) (X := 6.24306415) (rho := 0.11981071)
    (clo := 0.99919521) (chi := 0.99919793) (C := 0.93969225) (h := 0.06030775)
    (by norm_num) (by norm_num) oscBlock63 vbpBr63.1 vbpBr64.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i64 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00107612):ℝ) ≤ ∫ v in (vBP 1.766)..(vBP 1.796), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.43901053) (m := (1:ℤ)) (ylo := 0.15582522) (yhi := 0.15582523)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.766) (q1 := 1.796) (t0 := 5.5625) (t1 := 5.59375)
    (A := 1.1373613) (B := 1.17120873) (X := 6.43901053) (rho := 0.11243832)
    (clo := 0.98788379) (chi := 0.9878838) (C := 0.93772273) (h := 0.06227727)
    (by norm_num) (by norm_num) oscBlock64 vbpBr64.1 vbpBr65.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i65 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00105478):ℝ) ≤ ∫ v in (vBP 1.796)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.63151152) (m := (1:ℤ)) (ylo := 0.34832621) (yhi := 0.34832622)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.796) (q1 := 1.828) (t0 := 5.5625) (t1 := 5.59375)
    (A := 1.1710258) (B := 1.20655947) (X := 6.63151152) (rho := 0.11768053)
    (clo := 0.93994533) (chi := 0.93994534) (C := 0.9111324) (h := 0.0888676)
    (by norm_num) (by norm_num) oscBlock65 vbpBr65.1 vbpBr66.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i66 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00093923):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.86), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.82683206) (m := (1:ℤ)) (ylo := 0.54364675) (yhi := 0.54364676)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.828) (q1 := 1.86) (t0 := 5.5625) (t1 := 5.59375)
    (A := 1.20631244) (B := 1.24130524) (X := 6.82683206) (rho := 0.11671913)
    (clo := 0.85582805) (chi := 0.85582806) (C := 0.85582805) (h := 0.11671914)
    (by norm_num) (by norm_num) oscBlock66 vbpBr66.1 vbpBr67.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i67 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.0006878):ℝ) ≤ ∫ v in (vBP 1.86)..(vBP 1.89), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.01286744) (m := (1:ℤ)) (ylo := 0.72968213) (yhi := 0.72968214)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.86) (q1 := 1.89) (t0 := 5.5625) (t1 := 5.59375)
    (A := 1.24097685) (B := 1.27334993) (X := 7.01286744) (rho := 0.10993374)
    (clo := 0.74538633) (chi := 0.74538636) (C := 0.74538634) (h := 0.10993376)
    (by norm_num) (by norm_num) oscBlock67 vbpBr67.1 vbpBr68.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i68 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00056329):ℝ) ≤ ∫ v in (vBP 1.89)..(vBP 1.922), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.19580558) (m := (1:ℤ)) (ylo := 0.91262027) (yhi := 0.91262028)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.89) (q1 := 1.922) (t0 := 5.5625) (t1 := 5.59375)
    (A := 1.27292668) (B := 1.30698664) (X := 7.19580558) (rho := 0.11515094)
    (clo := 0.61167492) (chi := 0.61167505) (C := 0.61167498) (h := 0.11515101)
    (by norm_num) (by norm_num) oscBlock68 vbpBr68.1 vbpBr69.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i69 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00057013):ℝ) ≤ ∫ v in (vBP 1.922)..(vBP 1.969), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.42445823) (m := (1:ℤ)) (ylo := 1.14127292) (yhi := 1.14127293)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.922) (q1 := 1.969) (t0 := 5.5625) (t1 := 5.59375)
    (A := 1.30643896) (B := 1.35541448) (X := 7.42445823) (rho := 0.15739153)
    (clo := 0.41643752) (chi := 0.41643858) (C := 0.41643805) (h := 0.15739206)
    (by norm_num) (by norm_num) oscBlock69 vbpBr69.1 vbpBr70.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i70 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00027508):ℝ) ≤ ∫ v in (vBP 1.969)..(vBP 2.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.69085074) (m := (1:ℤ)) (ylo := 1.40766543) (yhi := 1.40766544)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.969) (q1 := 2.016) (t0 := 5.5625) (t1 := 5.59375)
    (A := 1.35463226) (B := 1.4027369) (X := 7.69085074) (rho := 0.15570881)
    (clo := 0.16240819) (chi := 0.16241663) (C := 0.16241241) (h := 0.15571303)
    (by norm_num) (by norm_num) oscBlock70 vbpBr70.1 vbpBr71.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i71 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00019332):ℝ) ≤ ∫ v in (vBP 2.016)..(vBP 2.062), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 7.94831355) (m := (1:ℤ)) (ylo := 0.09433191) (yhi := 0.09433192)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.016) (q1 := 2.062) (t0 := 5.5625) (t1 := 5.59375)
    (A := 1.40164597) (B := 1.44803958) (X := 7.94831355) (rho := 0.15165786)
    (clo := (-0.09419208)) (chi := (-0.09419207)) (C := (-0.09419208)) (h := 0.15165787)
    (by norm_num) (by norm_num) oscBlock71 vbpBr71.1 vbpBr72.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB24i72 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.00021182):ℝ) ≤ ∫ v in (vBP 2.062)..(vBP 2.094), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.15980047) (m := (1:ℤ)) (ylo := 0.30581883) (yhi := 0.30581884)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.062) (q1 := 2.094) (t0 := 5.5625) (t1 := 5.59375)
    (A := 1.44655973) (B := 1.47899217) (X := 8.15980047) (rho := 0.11331199)
    (clo := (-0.30107413)) (chi := (-0.30107411)) (C := (-0.30107412)) (h := 0.113312)
    (by norm_num) (by norm_num) oscBlock72 vbpBr72.1 vbpBr73.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

/-- Lower bound for the oscillatory integral `∫₀^∞ err(v) cos(tv) dv` on the band
`5.5625 ≤ t ≤ 5.59375`. -/
theorem oscBandLower24 {t : ℝ} (ht0 : (5.5625:ℝ) ≤ t) (ht1 : t ≤ 5.59375) :
    ((-0.10841096):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosB24i0 ht0 ht1)
    (cosB24i1 ht0 ht1))
    (cosB24i2 ht0 ht1))
    (cosB24i3 ht0 ht1))
    (cosB24i4 ht0 ht1))
    (cosB24i5 ht0 ht1))
    (cosB24i6 ht0 ht1))
    (cosB24i7 ht0 ht1))
    (cosB24i8 ht0 ht1))
    (cosB24i9 ht0 ht1))
    (cosB24i10 ht0 ht1))
    (cosB24i11 ht0 ht1))
    (cosB24i12 ht0 ht1))
    (cosB24i13 ht0 ht1))
    (cosB24i14 ht0 ht1))
    (cosB24i15 ht0 ht1))
    (cosB24i16 ht0 ht1))
    (cosB24i17 ht0 ht1))
    (cosB24i18 ht0 ht1))
    (cosB24i19 ht0 ht1))
    (cosB24i20 ht0 ht1))
    (cosB24i21 ht0 ht1))
    (cosB24i22 ht0 ht1))
    (cosB24i23 ht0 ht1))
    (cosB24i24 ht0 ht1))
    (cosB24i25 ht0 ht1))
    (cosB24i26 ht0 ht1))
    (cosB24i27 ht0 ht1))
    (cosB24i28 ht0 ht1))
    (cosB24i29 ht0 ht1))
    (cosB24i30 ht0 ht1))
    (cosB24i31 ht0 ht1))
    (cosB24i32 ht0 ht1))
    (cosB24i33 ht0 ht1))
    (cosB24i34 ht0 ht1))
    (cosB24i35 ht0 ht1))
    (cosB24i36 ht0 ht1))
    (cosB24i37 ht0 ht1))
    (cosB24i38 ht0 ht1))
    (cosB24i39 ht0 ht1))
    (cosB24i40 ht0 ht1))
    (cosB24i41 ht0 ht1))
    (cosB24i42 ht0 ht1))
    (cosB24i43 ht0 ht1))
    (cosB24i44 ht0 ht1))
    (cosB24i45 ht0 ht1))
    (cosB24i46 ht0 ht1))
    (cosB24i47 ht0 ht1))
    (cosB24i48 ht0 ht1))
    (cosB24i49 ht0 ht1))
    (cosB24i50 ht0 ht1))
    (cosB24i51 ht0 ht1))
    (cosB24i52 ht0 ht1))
    (cosB24i53 ht0 ht1))
    (cosB24i54 ht0 ht1))
    (cosB24i55 ht0 ht1))
    (cosB24i56 ht0 ht1))
    (cosB24i57 ht0 ht1))
    (cosB24i58 ht0 ht1))
    (cosB24i59 ht0 ht1))
    (cosB24i60 ht0 ht1))
    (cosB24i61 ht0 ht1))
    (cosB24i62 ht0 ht1))
    (cosB24i63 ht0 ht1))
    (cosB24i64 ht0 ht1))
    (cosB24i65 ht0 ht1))
    (cosB24i66 ht0 ht1))
    (cosB24i67 ht0 ht1))
    (cosB24i68 ht0 ht1))
    (cosB24i69 ht0 ht1))
    (cosB24i70 ht0 ht1))
    (cosB24i71 ht0 ht1))
    (cosB24i72 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 2.094) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 2.094) (S := 0.013709)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_cut
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
