/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscTail

/-!
# Oscillatory lower bound on the band `6.375 ≤ t ≤ 6.5`

On each of the 73 blocks the factor `cos(tv)` is bracketed by a rational constant
`C` up to a rational error `h`; the signed contribution `min(C·P₀, C·P₁) - h·S` is
then summed, and the unresolved tail beyond `q = 2.094` is estimated in absolute
value.  The result is the bound `∫₀^∞ err(v) cos(tv) dv ≥ -0.13931074`.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosB7i0 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00641868):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.0038), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.0246532) (m := (0:ℤ)) (ylo := 0.0246532) (yhi := 0.0246532)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1) (q1 := 1.0038) (t0 := 6.375) (t1 := 6.5)
    (A := 0.0) (B := 0.0075856) (X := 0.0246532) (rho := 0.02465321)
    (clo := 0.99969612) (chi := 0.99969613) (C := 0.98752145) (h := 0.01247855)
    (by norm_num) (by norm_num) oscBlock0 vbpBr0.1 vbpBr1.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i1 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00625872):ℝ) ≤ ∫ v in (vBP 1.0038)..(vBP 1.0078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.07468237) (m := (0:ℤ)) (ylo := 0.07468237) (yhi := 0.07468237)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0038) (q1 := 1.0078) (t0 := 6.375) (t1 := 6.5)
    (A := 0.00758559) (B := 0.01553948) (X := 0.07468237) (rho := 0.02632426)
    (clo := 0.99721256) (chi := 0.99721257) (C := 0.98544415) (h := 0.01455585)
    (by norm_num) (by norm_num) oscBlock1 vbpBr1.1 vbpBr2.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i2 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.0057677):ℝ) ≤ ∫ v in (vBP 1.0078)..(vBP 1.0118), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.12578307) (m := (0:ℤ)) (ylo := 0.12578307) (yhi := 0.12578307)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0078) (q1 := 1.0118) (t0 := 6.375) (t1 := 6.5)
    (A := 0.01553947) (B := 0.02346185) (X := 0.12578307) (rho := 0.02671897)
    (clo := 0.99209973) (chi := 0.99209974) (C := 0.98269038) (h := 0.01730962)
    (by norm_num) (by norm_num) oscBlock2 vbpBr2.1 vbpBr3.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i3 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00554846):ℝ) ≤ ∫ v in (vBP 1.0118)..(vBP 1.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.17796139) (m := (0:ℤ)) (ylo := 0.17796139) (yhi := 0.17796139)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0118) (q1 := 1.016) (t0 := 6.375) (t1 := 6.5)
    (A := 0.02346184) (B := 0.0317467) (X := 0.17796139) (rho := 0.02839217)
    (clo := 0.98420661) (chi := 0.98420662) (C := 0.97790722) (h := 0.02209278)
    (by norm_num) (by norm_num) oscBlock3 vbpBr3.1 vbpBr4.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i4 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00539232):ℝ) ≤ ∫ v in (vBP 1.016)..(vBP 1.0205), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.23309515) (m := (0:ℤ)) (ylo := 0.23309515) (yhi := 0.23309515)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.016) (q1 := 1.0205) (t0 := 6.375) (t1 := 6.5)
    (A := 0.03174669) (B := 0.04058541) (X := 0.23309515) (rho := 0.03071002)
    (clo := 0.9729561) (chi := 0.97295611) (C := 0.97112304) (h := 0.02887696)
    (by norm_num) (by norm_num) oscBlock4 vbpBr4.1 vbpBr5.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i5 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00479963):ℝ) ≤ ∫ v in (vBP 1.0205)..(vBP 1.025), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.28986796) (m := (0:ℤ)) (ylo := 0.28986796) (yhi := 0.28986796)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0205) (q1 := 1.025) (t0 := 6.375) (t1 := 6.5)
    (A := 0.0405854) (B := 0.04938523) (X := 0.28986796) (rho := 0.03113605)
    (clo := 0.95828162) (chi := 0.95828163) (C := 0.95828162) (h := 0.03113606)
    (by norm_num) (by norm_num) oscBlock5 vbpBr5.1 vbpBr6.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i6 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00466745):ℝ) ≤ ∫ v in (vBP 1.025)..(vBP 1.03), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.34954762) (m := (0:ℤ)) (ylo := 0.34954762) (yhi := 0.34954762)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.025) (q1 := 1.03) (t0 := 6.375) (t1 := 6.5)
    (A := 0.04938522) (B := 0.05911761) (X := 0.34954762) (rho := 0.03471686)
    (clo := 0.93952773) (chi := 0.93952774) (C := 0.93952773) (h := 0.03471687)
    (by norm_num) (by norm_num) oscBlock6 vbpBr6.1 vbpBr7.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i7 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.004354):ℝ) ≤ ∫ v in (vBP 1.03)..(vBP 1.0355), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.41518598) (m := (0:ℤ)) (ylo := 0.41518598) (yhi := 0.41518598)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.03) (q1 := 1.0355) (t0 := 6.375) (t1 := 6.5)
    (A := 0.0591176) (B := 0.06976881) (X := 0.41518598) (rho := 0.0383113)
    (clo := 0.91504131) (chi := 0.91504132) (C := 0.91504131) (h := 0.03831131)
    (by norm_num) (by norm_num) oscBlock7 vbpBr7.1 vbpBr8.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i8 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00388102):ℝ) ≤ ∫ v in (vBP 1.0355)..(vBP 1.0415), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.48669095) (m := (0:ℤ)) (ylo := 0.48669095) (yhi := 0.48669095)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0355) (q1 := 1.0415) (t0 := 6.375) (t1 := 6.5)
    (A := 0.0697688) (B := 0.08132397) (X := 0.48669095) (rho := 0.04191487)
    (clo := 0.88388534) (chi := 0.88388535) (C := 0.88388534) (h := 0.04191488)
    (by norm_num) (by norm_num) oscBlock8 vbpBr8.1 vbpBr9.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i9 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00327695):ℝ) ≤ ∫ v in (vBP 1.0415)..(vBP 1.048), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.56396345) (m := (0:ℤ)) (ylo := 0.56396345) (yhi := 0.56396345)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0415) (q1 := 1.048) (t0 := 6.375) (t1 := 6.5)
    (A := 0.08132396) (B := 0.09376718) (X := 0.56396345) (rho := 0.04552323)
    (clo := 0.84514313) (chi := 0.84514314) (C := 0.84514313) (h := 0.04552324)
    (by norm_num) (by norm_num) oscBlock9 vbpBr9.1 vbpBr10.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i10 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00259633):ℝ) ≤ ∫ v in (vBP 1.048)..(vBP 1.055), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.64689785) (m := (0:ℤ)) (ylo := 0.64689785) (yhi := 0.64689785)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.048) (q1 := 1.055) (t0 := 6.375) (t1 := 6.5)
    (A := 0.09376717) (B := 0.10708154) (X := 0.64689785) (rho := 0.04913217)
    (clo := 0.79795734) (chi := 0.79795735) (C := 0.79795734) (h := 0.04913218)
    (by norm_num) (by norm_num) oscBlock10 vbpBr10.1 vbpBr11.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i11 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00212597):ℝ) ≤ ∫ v in (vBP 1.055)..(vBP 1.064), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.74455244) (m := (0:ℤ)) (ylo := 0.74455244) (yhi := 0.74455244)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.055) (q1 := 1.064) (t0 := 6.375) (t1 := 6.5)
    (A := 0.10708153) (B := 0.12407079) (X := 0.74455244) (rho := 0.06190771)
    (clo := 0.73539126) (chi := 0.73539128) (C := 0.73539127) (h := 0.06190772)
    (by norm_num) (by norm_num) oscBlock11 vbpBr11.1 vbpBr12.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i12 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00135246):ℝ) ≤ ∫ v in (vBP 1.064)..(vBP 1.078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.88367419) (m := (0:ℤ)) (ylo := 0.88367419) (yhi := 0.88367419)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.064) (q1 := 1.078) (t0 := 6.375) (t1 := 6.5)
    (A := 0.12407078) (B := 0.15021495) (X := 0.88367419) (rho := 0.09272299)
    (clo := 0.634315) (chi := 0.63431509) (C := 0.63431504) (h := 0.09272304)
    (by norm_num) (by norm_num) oscBlock12 vbpBr12.1 vbpBr13.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i13 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    (0.00012035:ℝ) ≤ ∫ v in (vBP 1.078)..(vBP 1.09), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.03896517) (m := (0:ℤ)) (ylo := 1.03896517) (yhi := 1.03896517)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.078) (q1 := 1.09) (t0 := 6.375) (t1 := 6.5)
    (A := 0.15021494) (B := 0.1723554) (X := 1.03896517) (rho := 0.08134494)
    (clo := 0.50711242) (chi := 0.50711283) (C := 0.50711262) (h := 0.08134515)
    (by norm_num) (by norm_num) oscBlock13 vbpBr13.1 vbpBr14.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i14 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    (0.0005197:ℝ) ≤ ∫ v in (vBP 1.09)..(vBP 1.1), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.16889897) (m := (0:ℤ)) (ylo := 1.16889897) (yhi := 1.16889897)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.09) (q1 := 1.1) (t0 := 6.375) (t1 := 6.5)
    (A := 0.17235539) (B := 0.19062036) (X := 1.16889897) (rho := 0.07013338)
    (clo := 0.3911652) (chi := 0.39116653) (C := 0.39116586) (h := 0.07013405)
    (by norm_num) (by norm_num) oscBlock14 vbpBr14.1 vbpBr15.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i15 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    (0.00050123:ℝ) ≤ ∫ v in (vBP 1.1)..(vBP 1.109), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.28008398) (m := (0:ℤ)) (ylo := 1.28008398) (yhi := 1.28008398)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.1) (q1 := 1.109) (t0 := 6.375) (t1 := 6.5)
    (A := 0.19062035) (B := 0.20691742) (X := 1.28008398) (rho := 0.06487926)
    (clo := 0.28663471) (chi := 0.28663797) (C := 0.28663634) (h := 0.06488089)
    (by norm_num) (by norm_num) oscBlock15 vbpBr15.1 vbpBr16.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i16 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    (0.00032059:ℝ) ≤ ∫ v in (vBP 1.109)..(vBP 1.117), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.37875165) (m := (0:ℤ)) (ylo := 1.37875165) (yhi := 1.37875165)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.109) (q1 := 1.117) (t0 := 6.375) (t1 := 6.5)
    (A := 0.20691741) (B := 0.22129305) (X := 1.37875165) (rho := 0.05965318)
    (clo := 0.19086628) (chi := 0.19087313) (C := 0.1908697) (h := 0.05965661)
    (by norm_num) (by norm_num) oscBlock16 vbpBr16.1 vbpBr17.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i17 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    (0.0001116:ℝ) ≤ ∫ v in (vBP 1.117)..(vBP 1.124), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.46518097) (m := (0:ℤ)) (ylo := 1.46518097) (yhi := 1.46518097)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.117) (q1 := 1.124) (t0 := 6.375) (t1 := 6.5)
    (A := 0.22129304) (B := 0.23378751) (X := 1.46518097) (rho := 0.05443786)
    (clo := 0.10541891) (chi := 0.10543148) (C := 0.10542519) (h := 0.05444415)
    (by norm_num) (by norm_num) oscBlock17 vbpBr17.1 vbpBr18.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i18 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00011211):ℝ) ≤ ∫ v in (vBP 1.124)..(vBP 1.131), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.54536195) (m := (0:ℤ)) (ylo := 1.54536195) (yhi := 1.54536195)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.124) (q1 := 1.131) (t0 := 6.375) (t1 := 6.5)
    (A := 0.2337875) (B := 0.2462044) (X := 1.54536195) (rho := 0.05496666)
    (clo := 0.02543125) (chi := 0.02545266) (C := 0.02544195) (h := 0.05497737)
    (by norm_num) (by norm_num) oscBlock18 vbpBr18.1 vbpBr19.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i19 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00039527):ℝ) ≤ ∫ v in (vBP 1.131)..(vBP 1.138), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.6250467) (m := (0:ℤ)) (ylo := 0.05425037) (yhi := 0.05425038)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.131) (q1 := 1.138) (t0 := 6.375) (t1 := 6.5)
    (A := 0.24620439) (B := 0.25854468) (X := 1.6250467) (rho := 0.05549373)
    (clo := (-0.05422378)) (chi := (-0.05422376)) (C := (-0.05422377)) (h := 0.05549374)
    (by norm_num) (by norm_num) oscBlock19 vbpBr19.1 vbpBr20.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i20 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00070402):ℝ) ≤ ∫ v in (vBP 1.138)..(vBP 1.145), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.70424129) (m := (0:ℤ)) (ylo := 0.13344496) (yhi := 0.13344497)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.138) (q1 := 1.145) (t0 := 6.375) (t1 := 6.5)
    (A := 0.25854467) (B := 0.27080928) (X := 1.70424129) (rho := 0.05601904)
    (clo := (-0.13304927)) (chi := (-0.13304925)) (C := (-0.13304926)) (h := 0.05601905)
    (by norm_num) (by norm_num) oscBlock20 vbpBr20.1 vbpBr21.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i21 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00102308):ℝ) ≤ ∫ v in (vBP 1.145)..(vBP 1.152), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.78295172) (m := (0:ℤ)) (ylo := 0.21215539) (yhi := 0.2121554)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.145) (q1 := 1.152) (t0 := 6.375) (t1 := 6.5)
    (A := 0.27080927) (B := 0.28299913) (X := 1.78295172) (rho := 0.05654264)
    (clo := (-0.21056747)) (chi := (-0.21056745)) (C := (-0.21056746)) (h := 0.05654265)
    (by norm_num) (by norm_num) oscBlock21 vbpBr21.1 vbpBr22.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i22 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00133979):ℝ) ≤ ∫ v in (vBP 1.152)..(vBP 1.159), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.86118386) (m := (0:ℤ)) (ylo := 0.29038753) (yhi := 0.29038754)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.152) (q1 := 1.159) (t0 := 6.375) (t1 := 6.5)
    (A := 0.28299912) (B := 0.29511513) (X := 1.86118386) (rho := 0.05706449)
    (clo := (-0.28632357)) (chi := (-0.28632355)) (C := (-0.28632356)) (h := 0.0570645)
    (by norm_num) (by norm_num) oscBlock22 vbpBr22.1 vbpBr23.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i23 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00164275):ℝ) ≤ ∫ v in (vBP 1.159)..(vBP 1.166), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.93894353) (m := (0:ℤ)) (ylo := 0.3681472) (yhi := 0.36814721)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.159) (q1 := 1.166) (t0 := 6.375) (t1 := 6.5)
    (A := 0.29511512) (B := 0.30715818) (X := 1.93894353) (rho := 0.05758465)
    (clo := (-0.35988741)) (chi := (-0.35988739)) (C := (-0.3598874)) (h := 0.05758466)
    (by norm_num) (by norm_num) oscBlock23 vbpBr23.1 vbpBr24.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i24 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00192297):ℝ) ≤ ∫ v in (vBP 1.166)..(vBP 1.173), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.01623637) (m := (0:ℤ)) (ylo := 0.44544004) (yhi := 0.44544005)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.166) (q1 := 1.173) (t0 := 6.375) (t1 := 6.5)
    (A := 0.30715817) (B := 0.31912914) (X := 2.01623637) (rho := 0.05810305)
    (clo := (-0.43085504)) (chi := (-0.43085502)) (C := (-0.43085503)) (h := 0.05810306)
    (by norm_num) (by norm_num) oscBlock24 vbpBr24.1 vbpBr25.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i25 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00217292):ℝ) ≤ ∫ v in (vBP 1.173)..(vBP 1.18), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.09306796) (m := (0:ℤ)) (ylo := 0.52227163) (yhi := 0.52227164)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.173) (q1 := 1.18) (t0 := 6.375) (t1 := 6.5)
    (A := 0.31912913) (B := 0.33102888) (X := 2.09306796) (rho := 0.05861977)
    (clo := (-0.49885023)) (chi := (-0.49885021)) (C := (-0.49885022)) (h := 0.05861978)
    (by norm_num) (by norm_num) oscBlock25 vbpBr25.1 vbpBr26.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i26 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00238652):ℝ) ≤ ∫ v in (vBP 1.18)..(vBP 1.187), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.1694438) (m := (0:ℤ)) (ylo := 0.59864747) (yhi := 0.59864748)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.18) (q1 := 1.187) (t0 := 6.375) (t1 := 6.5)
    (A := 0.33102887) (B := 0.34285824) (X := 2.1694438) (rho := 0.05913477)
    (clo := (-0.56352568)) (chi := (-0.56352566)) (C := (-0.56352567)) (h := 0.05913478)
    (by norm_num) (by norm_num) oscBlock26 vbpBr26.1 vbpBr27.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i27 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00255919):ℝ) ≤ ∫ v in (vBP 1.187)..(vBP 1.194), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.24536923) (m := (0:ℤ)) (ylo := 0.6745729) (yhi := 0.67457291)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.187) (q1 := 1.194) (t0 := 6.375) (t1 := 6.5)
    (A := 0.34285823) (B := 0.35461804) (X := 2.24536923) (rho := 0.05964804)
    (clo := (-0.62456383)) (chi := (-0.62456381)) (C := (-0.62456382)) (h := 0.05964805)
    (by norm_num) (by norm_num) oscBlock27 vbpBr27.1 vbpBr28.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i28 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00271543):ℝ) ≤ ∫ v in (vBP 1.194)..(vBP 1.201), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.32084948) (m := (0:ℤ)) (ylo := 0.75005315) (yhi := 0.75005316)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.194) (q1 := 1.201) (t0 := 6.375) (t1 := 6.5)
    (A := 0.35461802) (B := 0.36630909) (X := 2.32084948) (rho := 0.06015962)
    (clo := (-0.68167766)) (chi := (-0.68167764)) (C := (-0.68167765)) (h := 0.06015963)
    (by norm_num) (by norm_num) oscBlock28 vbpBr28.1 vbpBr29.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i29 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00279987):ℝ) ≤ ∫ v in (vBP 1.201)..(vBP 1.208), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.39588984) (m := (0:ℤ)) (ylo := 0.82509351) (yhi := 0.82509352)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.201) (q1 := 1.208) (t0 := 6.375) (t1 := 6.5)
    (A := 0.36630908) (B := 0.3779322) (X := 2.39588984) (rho := 0.06066947)
    (clo := (-0.73461125)) (chi := (-0.73461123)) (C := (-0.73461124)) (h := 0.06066948)
    (by norm_num) (by norm_num) oscBlock29 vbpBr29.1 vbpBr30.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i30 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00283802):ℝ) ≤ ∫ v in (vBP 1.208)..(vBP 1.215), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.47049537) (m := (0:ℤ)) (ylo := 0.89969904) (yhi := 0.89969905)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.208) (q1 := 1.215) (t0 := 6.375) (t1 := 6.5)
    (A := 0.37793219) (B := 0.38948816) (X := 2.47049537) (rho := 0.06117768)
    (clo := (-0.78313981)) (chi := (-0.78313979)) (C := (-0.7831398)) (h := 0.06117769)
    (by norm_num) (by norm_num) oscBlock30 vbpBr30.1 vbpBr31.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i31 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00325168):ℝ) ≤ ∫ v in (vBP 1.215)..(vBP 1.223), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.54998806) (m := (0:ℤ)) (ylo := 0.97919173) (yhi := 0.97919174)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.215) (q1 := 1.223) (t0 := 6.375) (t1 := 6.5)
    (A := 0.38948815) (B := 0.40261372) (X := 2.54998806) (rho := 0.06700113)
    (clo := (-0.8300469)) (chi := (-0.83004687)) (C := (-0.83004689)) (h := 0.06700115)
    (by norm_num) (by norm_num) oscBlock31 vbpBr31.1 vbpBr32.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i32 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00317645):ℝ) ≤ ∫ v in (vBP 1.223)..(vBP 1.231), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.63420572) (m := (0:ℤ)) (ylo := 1.06340939) (yhi := 1.0634094)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.223) (q1 := 1.231) (t0 := 6.375) (t1 := 6.5)
    (A := 0.40261371) (B := 0.4156537) (X := 2.63420572) (rho := 0.06754334)
    (clo := (-0.87401722)) (chi := (-0.87401716)) (C := (-0.87401719)) (h := 0.06754337)
    (by norm_num) (by norm_num) oscBlock32 vbpBr32.1 vbpBr33.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i33 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00304219):ℝ) ≤ ∫ v in (vBP 1.231)..(vBP 1.239), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.71787606) (m := (0:ℤ)) (ylo := 1.14707973) (yhi := 1.14707974)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.231) (q1 := 1.239) (t0 := 6.375) (t1 := 6.5)
    (A := 0.41565369) (B := 0.42860921) (X := 2.71787606) (rho := 0.06808381)
    (clo := (-0.91156728)) (chi := (-0.91156715)) (C := (-0.91156722)) (h := 0.06808388)
    (by norm_num) (by norm_num) oscBlock33 vbpBr33.1 vbpBr34.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i34 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.0031571):ℝ) ≤ ∫ v in (vBP 1.239)..(vBP 1.248), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.80621661) (m := (0:ℤ)) (ylo := 1.23542028) (yhi := 1.23542029)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.239) (q1 := 1.248) (t0 := 6.375) (t1 := 6.5)
    (A := 0.4286092) (B := 0.44308455) (X := 2.80621661) (rho := 0.07383298)
    (clo := (-0.94428687)) (chi := (-0.9442866)) (C := (-0.93522681)) (h := 0.06477319)
    (by norm_num) (by norm_num) oscBlock34 vbpBr34.1 vbpBr35.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i35 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00307604):ℝ) ≤ ∫ v in (vBP 1.248)..(vBP 1.258), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.90423247) (m := (0:ℤ)) (ylo := 1.33343614) (yhi := 1.33343615)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.248) (q1 := 1.258) (t0 := 6.375) (t1 := 6.5)
    (A := 0.44308453) (B := 0.45904632) (X := 2.90423247) (rho := 0.07956862)
    (clo := (-0.97196267)) (chi := (-0.97196207)) (C := (-0.94619673)) (h := 0.05380328)
    (by norm_num) (by norm_num) oscBlock35 vbpBr35.1 vbpBr36.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i36 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00264808):ℝ) ≤ ∫ v in (vBP 1.258)..(vBP 1.268), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.0065757) (m := (0:ℤ)) (ylo := 1.43577937) (yhi := 1.43577938)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.258) (q1 := 1.268) (t0 := 6.375) (t1 := 6.5)
    (A := 0.45904631) (B := 0.47488172) (X := 3.0065757) (rho := 0.08015549)
    (clo := (-0.99090038)) (chi := (-0.99089903)) (C := (-0.95537177)) (h := 0.04462823)
    (by norm_num) (by norm_num) oscBlock36 vbpBr36.1 vbpBr37.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i37 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00261048):ℝ) ≤ ∫ v in (vBP 1.268)..(vBP 1.28), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.11827597) (m := (0:ℤ)) (ylo := 1.54747964) (yhi := 1.54747965)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.268) (q1 := 1.28) (t0 := 6.375) (t1 := 6.5)
    (A := 0.4748817) (B := 0.49372017) (X := 3.11827597) (rho := 0.09090515)
    (clo := (-0.99973119)) (chi := (-0.99972813)) (C := (-0.95441149)) (h := 0.04558851)
    (by norm_num) (by norm_num) oscBlock37 vbpBr37.1 vbpBr38.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i38 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.0022862):ℝ) ≤ ∫ v in (vBP 1.28)..(vBP 1.294), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.24903127) (m := (0:ℤ)) (ylo := 0.10743861) (yhi := 0.10743862)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.28) (q1 := 1.294) (t0 := 6.375) (t1 := 6.5)
    (A := 0.49372014) (B := 0.51547641) (X := 3.24903127) (rho := 0.1015654)
    (clo := (-0.99423403)) (chi := (-0.99423402)) (C := (-0.94633431)) (h := 0.05366569)
    (by norm_num) (by norm_num) oscBlock38 vbpBr38.1 vbpBr39.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i39 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00152768):ℝ) ≤ ∫ v in (vBP 1.294)..(vBP 1.308), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.38832618) (m := (0:ℤ)) (ylo := 0.24673352) (yhi := 0.24673353)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.294) (q1 := 1.308) (t0 := 6.375) (t1 := 6.5)
    (A := 0.51547638) (B := 0.53699853) (X := 3.38832618) (rho := 0.10216428)
    (clo := (-0.9697154)) (chi := (-0.96971538)) (C := (-0.93377555)) (h := 0.06622445)
    (by norm_num) (by norm_num) oscBlock39 vbpBr39.1 vbpBr40.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i40 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.0009999):ℝ) ≤ ∫ v in (vBP 1.308)..(vBP 1.326), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.54576757) (m := (0:ℤ)) (ylo := 0.40417491) (yhi := 0.40417492)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.308) (q1 := 1.326) (t0 := 6.375) (t1 := 6.5)
    (A := 0.53699848) (B := 0.56433382) (X := 3.54576757) (rho := 0.12240227)
    (clo := (-0.91942719)) (chi := (-0.91942718)) (C := (-0.89851246)) (h := 0.10148755)
    (by norm_num) (by norm_num) oscBlock40 vbpBr40.1 vbpBr41.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i41 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00011757):ℝ) ≤ ∫ v in (vBP 1.326)..(vBP 1.345), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.72537505) (m := (0:ℤ)) (ylo := 0.58378239) (yhi := 0.5837824)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.326) (q1 := 1.345) (t0 := 6.375) (t1 := 6.5)
    (A := 0.56433374) (B := 0.59278808) (X := 3.72537505) (rho := 0.12774748)
    (clo := (-0.83438384)) (chi := (-0.83438382)) (C := (-0.83438383)) (h := 0.12774749)
    (by norm_num) (by norm_num) oscBlock41 vbpBr41.1 vbpBr42.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i42 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    (0.00056606:ℝ) ≤ ∫ v in (vBP 1.345)..(vBP 1.362), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.89771424) (m := (0:ℤ)) (ylo := 0.75612158) (yhi := 0.75612159)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.345) (q1 := 1.362) (t0 := 6.375) (t1 := 6.5)
    (A := 0.59278796) (B := 0.6179085) (X := 3.89771424) (rho := 0.11869102)
    (clo := (-0.7275025)) (chi := (-0.72750247)) (C := (-0.72750249)) (h := 0.11869104)
    (by norm_num) (by norm_num) oscBlock42 vbpBr42.1 vbpBr43.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i43 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    (0.00060456:ℝ) ≤ ∫ v in (vBP 1.362)..(vBP 1.376), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.04425793) (m := (0:ℤ)) (ylo := 0.90266527) (yhi := 0.90266528)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.362) (q1 := 1.376) (t0 := 6.375) (t1 := 6.5)
    (A := 0.61790831) (B := 0.6383616) (X := 4.04425793) (rho := 0.10509248)
    (clo := (-0.61952009)) (chi := (-0.61951997)) (C := (-0.61952003)) (h := 0.10509254)
    (by norm_num) (by norm_num) oscBlock43 vbpBr43.1 vbpBr44.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i44 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    (0.00055942:ℝ) ≤ ∫ v in (vBP 1.376)..(vBP 1.39), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.17525166) (m := (0:ℤ)) (ylo := 1.033659) (yhi := 1.03365901)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.376) (q1 := 1.39) (t0 := 6.375) (t1 := 6.5)
    (A := 0.63836133) (B := 0.65860767) (X := 4.17525166) (rho := 0.1056982)
    (clo := (-0.51167893)) (chi := (-0.51167853)) (C := (-0.51167873)) (h := 0.1056984)
    (by norm_num) (by norm_num) oscBlock44 vbpBr44.1 vbpBr45.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i45 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    (0.00041699:ℝ) ≤ ∫ v in (vBP 1.39)..(vBP 1.404), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.30492603) (m := (0:ℤ)) (ylo := 1.16333337) (yhi := 1.16333338)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.39) (q1 := 1.404) (t0 := 6.375) (t1 := 6.5)
    (A := 0.65860729) (B := 0.67865086) (X := 4.30492603) (rho := 0.10630457)
    (clo := (-0.39628252)) (chi := (-0.39628125)) (C := (-0.39628189)) (h := 0.10630521)
    (by norm_num) (by norm_num) oscBlock45 vbpBr45.1 vbpBr46.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i46 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    (0.00021901:ℝ) ≤ ∫ v in (vBP 1.404)..(vBP 1.418), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.43330729) (m := (0:ℤ)) (ylo := 1.29171463) (yhi := 1.29171464)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.404) (q1 := 1.418) (t0 := 6.375) (t1 := 6.5)
    (A := 0.67865033) (B := 0.69849519) (X := 4.43330729) (rho := 0.10691146)
    (clo := (-0.27547652)) (chi := (-0.27547293)) (C := (-0.27547473)) (h := 0.10691326)
    (by norm_num) (by norm_num) oscBlock46 vbpBr46.1 vbpBr47.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i47 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    (0.00000676:ℝ) ≤ ∫ v in (vBP 1.418)..(vBP 1.432), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.56042104) (m := (0:ℤ)) (ylo := 1.41882838) (yhi := 1.41882839)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.418) (q1 := 1.432) (t0 := 6.375) (t1 := 6.5)
    (A := 0.69849446) (B := 0.7181446) (X := 4.56042104) (rho := 0.10751887)
    (clo := (-0.15139267)) (chi := (-0.15138354)) (C := (-0.15138811)) (h := 0.10752344)
    (by norm_num) (by norm_num) oscBlock47 vbpBr47.1 vbpBr48.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i48 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00018371):ℝ) ≤ ∫ v in (vBP 1.432)..(vBP 1.446), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.68629202) (m := (0:ℤ)) (ylo := 1.54469936) (yhi := 1.54469937)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.432) (q1 := 1.446) (t0 := 6.375) (t1 := 6.5)
    (A := 0.7181436) (B := 0.73760286) (X := 4.68629202) (rho := 0.10812658)
    (clo := (-0.02611494)) (chi := (-0.02609361)) (C := (-0.02610428)) (h := 0.10813725)
    (by norm_num) (by norm_num) oscBlock48 vbpBr48.1 vbpBr49.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i49 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00049173):ℝ) ≤ ∫ v in (vBP 1.446)..(vBP 1.462), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.81984251) (m := (0:ℤ)) (ylo := 0.10745352) (yhi := 0.10745353)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.446) (q1 := 1.462) (t0 := 6.375) (t1 := 6.5)
    (A := 0.73760153) (B := 0.75961158) (X := 4.81984251) (rho := 0.11763277)
    (clo := 0.10724685) (chi := 0.10724687) (C := 0.10724686) (h := 0.11763278)
    (by norm_num) (by norm_num) oscBlock49 vbpBr49.1 vbpBr50.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i50 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00076415):ℝ) ≤ ∫ v in (vBP 1.462)..(vBP 1.478), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.96074364) (m := (0:ℤ)) (ylo := 0.24835465) (yhi := 0.24835466)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.462) (q1 := 1.478) (t0 := 6.375) (t1 := 6.5)
    (A := 0.75960973) (B := 0.78138081) (X := 4.96074364) (rho := 0.11823163)
    (clo := 0.24580942) (chi := 0.24580944) (C := 0.24580943) (h := 0.11823164)
    (by norm_num) (by norm_num) oscBlock50 vbpBr50.1 vbpBr51.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i51 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00104709):ℝ) ≤ ∫ v in (vBP 1.478)..(vBP 1.495), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.10446886) (m := (0:ℤ)) (ylo := 0.39207987) (yhi := 0.39207988)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.478) (q1 := 1.495) (t0 := 6.375) (t1 := 6.5)
    (A := 0.7813783) (B := 0.80425401) (X := 5.10446886) (rho := 0.12318222)
    (clo := 0.38211128) (chi := 0.3821113) (C := 0.38211129) (h := 0.12318223)
    (by norm_num) (by norm_num) oscBlock51 vbpBr51.1 vbpBr52.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i52 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00122313):ℝ) ≤ ∫ v in (vBP 1.495)..(vBP 1.512), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.250872) (m := (0:ℤ)) (ylo := 0.53848301) (yhi := 0.53848302)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.495) (q1 := 1.512) (t0 := 6.375) (t1 := 6.5)
    (A := 0.80425056) (B := 0.82686872) (X := 5.250872) (rho := 0.12377469)
    (clo := 0.51283426) (chi := 0.51283428) (C := 0.51283427) (h := 0.1237747)
    (by norm_num) (by norm_num) oscBlock52 vbpBr52.1 vbpBr53.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i53 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00152512):ℝ) ≤ ∫ v in (vBP 1.512)..(vBP 1.531), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.40412612) (m := (0:ℤ)) (ylo := 0.69173713) (yhi := 0.69173714)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.512) (q1 := 1.531) (t0 := 6.375) (t1 := 6.5)
    (A := 0.82686405) (B := 0.85184522) (X := 5.40412612) (rho := 0.13286782)
    (clo := 0.63787597) (chi := 0.63787599) (C := 0.63787598) (h := 0.13286783)
    (by norm_num) (by norm_num) oscBlock53 vbpBr53.1 vbpBr54.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i54 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00160554):ℝ) ≤ ∫ v in (vBP 1.531)..(vBP 1.55), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.56390635) (m := (0:ℤ)) (ylo := 0.85151736) (yhi := 0.85151737)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.531) (q1 := 1.55) (t0 := 6.375) (t1 := 6.5)
    (A := 0.85183877) (B := 0.87651393) (X := 5.56390635) (rho := 0.13343421)
    (clo := 0.75228097) (chi := 0.75228099) (C := 0.75228098) (h := 0.13343422)
    (by norm_num) (by norm_num) oscBlock54 vbpBr54.1 vbpBr55.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i55 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00172575):ℝ) ≤ ∫ v in (vBP 1.55)..(vBP 1.57), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.7258697) (m := (0:ℤ)) (ylo := 1.01348071) (yhi := 1.01348072)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.55) (q1 := 1.57) (t0 := 6.375) (t1 := 6.5)
    (A := 0.87650515) (B := 0.90215678) (X := 5.7258697) (rho := 0.13814938)
    (clo := 0.84867796) (chi := 0.848678) (C := 0.84867798) (h := 0.1381494)
    (by norm_num) (by norm_num) oscBlock55 vbpBr55.1 vbpBr56.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i56 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00159903):ℝ) ≤ ∫ v in (vBP 1.57)..(vBP 1.59), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.88988189) (m := (0:ℤ)) (ylo := 1.1774929) (yhi := 1.17749291)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.57) (q1 := 1.59) (t0 := 6.375) (t1 := 6.5)
    (A := 0.90214481) (B := 0.92747548) (X := 5.88988189) (rho := 0.13870874)
    (clo := 0.92364808) (chi := 0.92364825) (C := 0.89246967) (h := 0.10753033)
    (by norm_num) (by norm_num) oscBlock56 vbpBr56.1 vbpBr57.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i57 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00146404):ℝ) ≤ ∫ v in (vBP 1.59)..(vBP 1.61), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.05183111) (m := (0:ℤ)) (ylo := 1.33944212) (yhi := 1.33944213)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.59) (q1 := 1.61) (t0 := 6.375) (t1 := 6.5)
    (A := 0.92745939) (B := 0.95247825) (X := 6.05183111) (rho := 0.13927752)
    (clo := 0.97335676) (chi := 0.9733574) (C := 0.91703962) (h := 0.08296038)
    (by norm_num) (by norm_num) oscBlock57 vbpBr57.1 vbpBr58.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i58 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00149216):ℝ) ≤ ∫ v in (vBP 1.61)..(vBP 1.632), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.21974031) (m := (0:ℤ)) (ylo := 1.50735132) (yhi := 1.50735133)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.61) (q1 := 1.632) (t0 := 6.375) (t1 := 6.5)
    (A := 0.95245689) (B := 0.97962584) (X := 6.21974031) (rho := 0.14782766)
    (clo := 0.997988) (chi := 0.9979903) (C := 0.92508017) (h := 0.07491983)
    (by norm_num) (by norm_num) oscBlock58 vbpBr58.1 vbpBr59.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i59 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00149999):ℝ) ≤ ∫ v in (vBP 1.632)..(vBP 1.656), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.40115753) (m := (1:ℤ)) (ylo := 0.11797222) (yhi := 0.11797223)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.632) (q1 := 1.656) (t0 := 6.375) (t1 := 6.5)
    (A := 0.97959707) (B := 1.00882827) (X := 6.40115753) (rho := 0.15622623)
    (clo := 0.99304934) (chi := 0.99304935) (C := 0.91841155) (h := 0.08158845)
    (by norm_num) (by norm_num) oscBlock59 vbpBr59.1 vbpBr60.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i60 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00135601):ℝ) ≤ ∫ v in (vBP 1.656)..(vBP 1.68), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.58775403) (m := (1:ℤ)) (ylo := 0.30456872) (yhi := 0.30456873)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.656) (q1 := 1.68) (t0 := 6.375) (t1 := 6.5)
    (A := 1.00878907) (B := 1.03761196) (X := 6.58775403) (rho := 0.15672372)
    (clo := 0.95397637) (chi := 0.95397638) (C := 0.89862632) (h := 0.10137368)
    (by norm_num) (by norm_num) oscBlock60 vbpBr60.1 vbpBr61.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i61 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00122808):ℝ) ≤ ∫ v in (vBP 1.68)..(vBP 1.704), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.7716851) (m := (1:ℤ)) (ylo := 0.48849979) (yhi := 0.4884998)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.68) (q1 := 1.704) (t0 := 6.375) (t1 := 6.5)
    (A := 1.03755935) (B := 1.06598913) (X := 6.7716851) (rho := 0.15724426)
    (clo := 0.88303789) (chi := 0.88303791) (C := 0.86289681) (h := 0.13710319)
    (by norm_num) (by norm_num) oscBlock61 vbpBr61.1 vbpBr62.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i62 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00130309):ℝ) ≤ ∫ v in (vBP 1.704)..(vBP 1.734), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.97556541) (m := (1:ℤ)) (ylo := 0.6923801) (yhi := 0.69238011)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.704) (q1 := 1.734) (t0 := 6.375) (t1 := 6.5)
    (A := 1.06591948) (B := 1.10090679) (X := 6.97556541) (rho := 0.18032874)
    (clo := 0.7697288) (chi := 0.76972882) (C := 0.76972881) (h := 0.18032875)
    (by norm_num) (by norm_num) oscBlock62 vbpBr62.1 vbpBr63.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i63 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00102841):ℝ) ≤ ∫ v in (vBP 1.734)..(vBP 1.766), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.20569646) (m := (1:ℤ)) (ylo := 0.92251115) (yhi := 0.92251116)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.734) (q1 := 1.766) (t0 := 6.375) (t1 := 6.5)
    (A := 1.10080961) (B := 1.13749718) (X := 7.20569646) (rho := 0.18803522)
    (clo := 0.60382036) (chi := 0.6038205) (C := 0.60382043) (h := 0.18803529)
    (by norm_num) (by norm_num) oscBlock63 vbpBr63.1 vbpBr64.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i64 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00063585):ℝ) ≤ ∫ v in (vBP 1.766)..(vBP 1.796), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.43176751) (m := (1:ℤ)) (ylo := 1.1485822) (yhi := 1.14858221)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.766) (q1 := 1.796) (t0 := 6.375) (t1 := 6.5)
    (A := 1.1373613) (B := 1.17120873) (X := 7.43176751) (rho := 0.18108924)
    (clo := 0.40978112) (chi := 0.40978224) (C := 0.40978168) (h := 0.1810898)
    (by norm_num) (by norm_num) oscBlock64 vbpBr64.1 vbpBr65.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i65 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00040859):ℝ) ≤ ∫ v in (vBP 1.796)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.65396301) (m := (1:ℤ)) (ylo := 1.3707777) (yhi := 1.37077771)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.796) (q1 := 1.828) (t0 := 6.375) (t1 := 6.5)
    (A := 1.1710258) (B := 1.20655947) (X := 7.65396301) (rho := 0.18867355)
    (clo := 0.19868748) (chi := 0.19869396) (C := 0.19869072) (h := 0.18867679)
    (by norm_num) (by norm_num) oscBlock65 vbpBr65.1 vbpBr66.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i66 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00020314):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.86), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 7.87936293) (m := (1:ℤ)) (ylo := 0.02538129) (yhi := 0.0253813)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.828) (q1 := 1.86) (t0 := 6.375) (t1 := 6.5)
    (A := 1.20631244) (B := 1.24130524) (X := 7.87936293) (rho := 0.18912114)
    (clo := (-0.02537858)) (chi := (-0.02537856)) (C := (-0.02537857)) (h := 0.18912115)
    (by norm_num) (by norm_num) oscBlock66 vbpBr66.1 vbpBr67.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i67 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00031421):ℝ) ≤ ∫ v in (vBP 1.86)..(vBP 1.89), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.09400098) (m := (1:ℤ)) (ylo := 0.24001934) (yhi := 0.24001935)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.86) (q1 := 1.89) (t0 := 6.375) (t1 := 6.5)
    (A := 1.24097685) (B := 1.27334993) (X := 8.09400098) (rho := 0.18277358)
    (clo := (-0.23772143)) (chi := (-0.23772141)) (C := (-0.23772142)) (h := 0.18277359)
    (by norm_num) (by norm_num) oscBlock67 vbpBr67.1 vbpBr68.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i68 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00045718):ℝ) ≤ ∫ v in (vBP 1.89)..(vBP 1.922), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.30516037) (m := (1:ℤ)) (ylo := 0.45117873) (yhi := 0.45117874)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.89) (q1 := 1.922) (t0 := 6.375) (t1 := 6.5)
    (A := 1.27292668) (B := 1.30698664) (X := 8.30516037) (rho := 0.1902528)
    (clo := (-0.43602663)) (chi := (-0.43602661)) (C := (-0.43602662)) (h := 0.19025281)
    (by norm_num) (by norm_num) oscBlock68 vbpBr68.1 vbpBr69.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i69 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00087064):ℝ) ≤ ∫ v in (vBP 1.922)..(vBP 1.969), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.56937124) (m := (1:ℤ)) (ylo := 0.7153896) (yhi := 0.71538961)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.922) (q1 := 1.969) (t0 := 6.375) (t1 := 6.5)
    (A := 1.30643896) (B := 1.35541448) (X := 8.56937124) (rho := 0.24082289)
    (clo := (-0.65591156)) (chi := (-0.65591155)) (C := (-0.65591156)) (h := 0.2408229)
    (by norm_num) (by norm_num) oscBlock69 vbpBr69.1 vbpBr70.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i70 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00087888):ℝ) ≤ ∫ v in (vBP 1.969)..(vBP 2.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.87678525) (m := (1:ℤ)) (ylo := 1.02280361) (yhi := 1.02280362)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.969) (q1 := 2.016) (t0 := 6.375) (t1 := 6.5)
    (A := 1.35463226) (B := 1.4027369) (X := 8.87678525) (rho := 0.24100461)
    (clo := (-0.85357203)) (chi := (-0.85357198)) (C := (-0.80628369)) (h := 0.19371632)
    (by norm_num) (by norm_num) oscBlock70 vbpBr70.1 vbpBr71.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i71 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00078633):ℝ) ≤ ∫ v in (vBP 2.016)..(vBP 2.062), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 9.17387516) (m := (1:ℤ)) (ylo := 1.31989352) (yhi := 1.31989353)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.016) (q1 := 2.062) (t0 := 6.375) (t1 := 6.5)
    (A := 1.40164597) (B := 1.44803958) (X := 9.17387516) (rho := 0.23838212)
    (clo := (-0.9686892)) (chi := (-0.96868866)) (C := (-0.86515327)) (h := 0.13484673)
    (by norm_num) (by norm_num) oscBlock71 vbpBr71.1 vbpBr72.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB7i72 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.00051116):ℝ) ≤ ∫ v in (vBP 2.062)..(vBP 2.094), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 9.41763369) (m := (1:ℤ)) (ylo := 1.56365205) (yhi := 1.56365206)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.062) (q1 := 2.094) (t0 := 6.375) (t1 := 6.5)
    (A := 1.44655973) (B := 1.47899217) (X := 9.41763369) (rho := 0.19581543)
    (clo := (-0.99997785)) (chi := (-0.99997442)) (C := (-0.9020795)) (h := 0.09792051)
    (by norm_num) (by norm_num) oscBlock72 vbpBr72.1 vbpBr73.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

/-- Lower bound for the oscillatory integral `∫₀^∞ err(v) cos(tv) dv` on the band
`6.375 ≤ t ≤ 6.5`. -/
theorem oscBandLower7 {t : ℝ} (ht0 : (6.375:ℝ) ≤ t) (ht1 : t ≤ 6.5) :
    ((-0.13931074):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosB7i0 ht0 ht1)
    (cosB7i1 ht0 ht1))
    (cosB7i2 ht0 ht1))
    (cosB7i3 ht0 ht1))
    (cosB7i4 ht0 ht1))
    (cosB7i5 ht0 ht1))
    (cosB7i6 ht0 ht1))
    (cosB7i7 ht0 ht1))
    (cosB7i8 ht0 ht1))
    (cosB7i9 ht0 ht1))
    (cosB7i10 ht0 ht1))
    (cosB7i11 ht0 ht1))
    (cosB7i12 ht0 ht1))
    (cosB7i13 ht0 ht1))
    (cosB7i14 ht0 ht1))
    (cosB7i15 ht0 ht1))
    (cosB7i16 ht0 ht1))
    (cosB7i17 ht0 ht1))
    (cosB7i18 ht0 ht1))
    (cosB7i19 ht0 ht1))
    (cosB7i20 ht0 ht1))
    (cosB7i21 ht0 ht1))
    (cosB7i22 ht0 ht1))
    (cosB7i23 ht0 ht1))
    (cosB7i24 ht0 ht1))
    (cosB7i25 ht0 ht1))
    (cosB7i26 ht0 ht1))
    (cosB7i27 ht0 ht1))
    (cosB7i28 ht0 ht1))
    (cosB7i29 ht0 ht1))
    (cosB7i30 ht0 ht1))
    (cosB7i31 ht0 ht1))
    (cosB7i32 ht0 ht1))
    (cosB7i33 ht0 ht1))
    (cosB7i34 ht0 ht1))
    (cosB7i35 ht0 ht1))
    (cosB7i36 ht0 ht1))
    (cosB7i37 ht0 ht1))
    (cosB7i38 ht0 ht1))
    (cosB7i39 ht0 ht1))
    (cosB7i40 ht0 ht1))
    (cosB7i41 ht0 ht1))
    (cosB7i42 ht0 ht1))
    (cosB7i43 ht0 ht1))
    (cosB7i44 ht0 ht1))
    (cosB7i45 ht0 ht1))
    (cosB7i46 ht0 ht1))
    (cosB7i47 ht0 ht1))
    (cosB7i48 ht0 ht1))
    (cosB7i49 ht0 ht1))
    (cosB7i50 ht0 ht1))
    (cosB7i51 ht0 ht1))
    (cosB7i52 ht0 ht1))
    (cosB7i53 ht0 ht1))
    (cosB7i54 ht0 ht1))
    (cosB7i55 ht0 ht1))
    (cosB7i56 ht0 ht1))
    (cosB7i57 ht0 ht1))
    (cosB7i58 ht0 ht1))
    (cosB7i59 ht0 ht1))
    (cosB7i60 ht0 ht1))
    (cosB7i61 ht0 ht1))
    (cosB7i62 ht0 ht1))
    (cosB7i63 ht0 ht1))
    (cosB7i64 ht0 ht1))
    (cosB7i65 ht0 ht1))
    (cosB7i66 ht0 ht1))
    (cosB7i67 ht0 ht1))
    (cosB7i68 ht0 ht1))
    (cosB7i69 ht0 ht1))
    (cosB7i70 ht0 ht1))
    (cosB7i71 ht0 ht1))
    (cosB7i72 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 2.094) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 2.094) (S := 0.013709)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_cut
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
