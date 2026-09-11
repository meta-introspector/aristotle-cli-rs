/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscTail

/-!
# Oscillatory lower bound on the band `6.0 ≤ t ≤ 6.0625`

On each of the 73 blocks the factor `cos(tv)` is bracketed by a rational constant
`C` up to a rational error `h`; the signed contribution `min(C·P₀, C·P₁) - h·S` is
then summed, and the unresolved tail beyond `q = 2.094` is estimated in absolute
value.  The result is the bound `∫₀^∞ err(v) cos(tv) dv ≥ -0.12423878`.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosB13i0 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00641868):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.0038), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.02299385) (m := (0:ℤ)) (ylo := 0.02299385) (yhi := 0.02299385)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1) (q1 := 1.0038) (t0 := 6) (t1 := 6.0625)
    (A := 0.0) (B := 0.0075856) (X := 0.02299385) (rho := 0.02299386)
    (clo := 0.99973565) (chi := 0.99973566) (C := 0.98837089) (h := 0.01162911)
    (by norm_num) (by norm_num) oscBlock0 vbpBr0.1 vbpBr1.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i1 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00625872):ℝ) ≤ ∫ v in (vBP 1.0038)..(vBP 1.0078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.06986081) (m := (0:ℤ)) (ylo := 0.06986081) (yhi := 0.06986081)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0038) (q1 := 1.0078) (t0 := 6) (t1 := 6.0625)
    (A := 0.00758559) (B := 0.01553948) (X := 0.06986081) (rho := 0.02434729)
    (clo := 0.99756072) (chi := 0.99756073) (C := 0.98660671) (h := 0.01339329)
    (by norm_num) (by norm_num) oscBlock1 vbpBr1.1 vbpBr2.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i2 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.0057677):ℝ) ≤ ∫ v in (vBP 1.0078)..(vBP 1.0118), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.11773714) (m := (0:ℤ)) (ylo := 0.11773714) (yhi := 0.11773714)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0078) (q1 := 1.0118) (t0 := 6) (t1 := 6.0625)
    (A := 0.01553947) (B := 0.02346185) (X := 0.11773714) (rho := 0.02450034)
    (clo := 0.99307698) (chi := 0.99307699) (C := 0.98428832) (h := 0.01571168)
    (by norm_num) (by norm_num) oscBlock2 vbpBr2.1 vbpBr3.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i3 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00554846):ℝ) ≤ ∫ v in (vBP 1.0118)..(vBP 1.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.1666177) (m := (0:ℤ)) (ylo := 0.1666177) (yhi := 0.1666177)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0118) (q1 := 1.016) (t0 := 6) (t1 := 6.0625)
    (A := 0.02346184) (B := 0.0317467) (X := 0.1666177) (rho := 0.02584668)
    (clo := 0.98615135) (chi := 0.98615136) (C := 0.98015233) (h := 0.01984767)
    (by norm_num) (by norm_num) oscBlock3 vbpBr3.1 vbpBr4.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i4 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00539232):ℝ) ≤ ∫ v in (vBP 1.016)..(vBP 1.0205), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.21826459) (m := (0:ℤ)) (ylo := 0.21826459) (yhi := 0.21826459)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.016) (q1 := 1.0205) (t0 := 6) (t1 := 6.0625)
    (A := 0.03174669) (B := 0.04058541) (X := 0.21826459) (rho := 0.02778447)
    (clo := 0.97627469) (chi := 0.9762747) (C := 0.97424511) (h := 0.02575489)
    (by norm_num) (by norm_num) oscBlock4 vbpBr4.1 vbpBr5.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i5 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00480888):ℝ) ≤ ∫ v in (vBP 1.0205)..(vBP 1.025), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.27145517) (m := (0:ℤ)) (ylo := 0.27145517) (yhi := 0.27145517)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0205) (q1 := 1.025) (t0 := 6) (t1 := 6.0625)
    (A := 0.0405854) (B := 0.04938523) (X := 0.27145517) (rho := 0.02794279)
    (clo := 0.96338173) (chi := 0.96338174) (C := 0.96338173) (h := 0.0279428)
    (by norm_num) (by norm_num) oscBlock5 vbpBr5.1 vbpBr6.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i6 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00468515):ℝ) ≤ ∫ v in (vBP 1.025)..(vBP 1.03), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.32735591) (m := (0:ℤ)) (ylo := 0.32735591) (yhi := 0.32735591)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.025) (q1 := 1.03) (t0 := 6) (t1 := 6.0625)
    (A := 0.04938522) (B := 0.05911761) (X := 0.32735591) (rho := 0.03104461)
    (clo := 0.94689583) (chi := 0.94689584) (C := 0.94689583) (h := 0.03104462)
    (by norm_num) (by norm_num) oscBlock6 vbpBr6.1 vbpBr7.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i7 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.004382):ℝ) ≤ ∫ v in (vBP 1.03)..(vBP 1.0355), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.3888395) (m := (0:ℤ)) (ylo := 0.3888395) (yhi := 0.3888395)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.03) (q1 := 1.0355) (t0 := 6) (t1 := 6.0625)
    (A := 0.0591176) (B := 0.06976881) (X := 0.3888395) (rho := 0.03413392)
    (clo := 0.92534964) (chi := 0.92534965) (C := 0.92534964) (h := 0.03413393)
    (by norm_num) (by norm_num) oscBlock7 vbpBr7.1 vbpBr8.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i8 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00392004):ℝ) ≤ ∫ v in (vBP 1.0355)..(vBP 1.0415), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.45581968) (m := (0:ℤ)) (ylo := 0.45581968) (yhi := 0.45581968)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0355) (q1 := 1.0415) (t0 := 6) (t1 := 6.0625)
    (A := 0.0697688) (B := 0.08132397) (X := 0.45581968) (rho := 0.0372069)
    (clo := 0.8979005) (chi := 0.89790051) (C := 0.8979005) (h := 0.03720691)
    (by norm_num) (by norm_num) oscBlock8 vbpBr8.1 vbpBr9.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i9 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00332591):ℝ) ≤ ∫ v in (vBP 1.0415)..(vBP 1.048), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.52820364) (m := (0:ℤ)) (ylo := 0.52820364) (yhi := 0.52820364)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0415) (q1 := 1.048) (t0 := 6) (t1 := 6.0625)
    (A := 0.08132396) (B := 0.09376718) (X := 0.52820364) (rho := 0.0402599)
    (clo := 0.86371379) (chi := 0.8637138) (C := 0.86371379) (h := 0.04025991)
    (by norm_num) (by norm_num) oscBlock9 vbpBr9.1 vbpBr10.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i10 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.0026521):ℝ) ≤ ∫ v in (vBP 1.048)..(vBP 1.055), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.60589242) (m := (0:ℤ)) (ylo := 0.60589242) (yhi := 0.60589242)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.048) (q1 := 1.055) (t0 := 6) (t1 := 6.0625)
    (A := 0.09376717) (B := 0.10708154) (X := 0.60589242) (rho := 0.04328942)
    (clo := 0.82199419) (chi := 0.8219942) (C := 0.82199419) (h := 0.04328943)
    (by norm_num) (by norm_num) oscBlock10 vbpBr10.1 vbpBr11.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i11 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00219024):ℝ) ≤ ∫ v in (vBP 1.055)..(vBP 1.064), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.69733417) (m := (0:ℤ)) (ylo := 0.69733417) (yhi := 0.69733417)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.055) (q1 := 1.064) (t0 := 6) (t1 := 6.0625)
    (A := 0.10708153) (B := 0.12407079) (X := 0.69733417) (rho := 0.05484501)
    (clo := 0.76655684) (chi := 0.76655685) (C := 0.76655684) (h := 0.05484502)
    (by norm_num) (by norm_num) oscBlock11 vbpBr11.1 vbpBr12.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i12 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00141341):ℝ) ≤ ∫ v in (vBP 1.064)..(vBP 1.078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.8275514) (m := (0:ℤ)) (ylo := 0.8275514) (yhi := 0.8275514)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.064) (q1 := 1.078) (t0 := 6) (t1 := 6.0625)
    (A := 0.12407078) (B := 0.15021495) (X := 0.8275514) (rho := 0.08312674)
    (clo := 0.67668063) (chi := 0.67668068) (C := 0.67668065) (h := 0.08312677)
    (by norm_num) (by norm_num) oscBlock12 vbpBr12.1 vbpBr13.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i13 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    (0.00016713:ℝ) ≤ ∫ v in (vBP 1.078)..(vBP 1.09), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.97309712) (m := (0:ℤ)) (ylo := 0.97309712) (yhi := 0.97309712)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.078) (q1 := 1.09) (t0 := 6) (t1 := 6.0625)
    (A := 0.15021494) (B := 0.1723554) (X := 0.97309712) (rho := 0.0718075)
    (clo := 0.56274205) (chi := 0.56274227) (C := 0.56274216) (h := 0.07180761)
    (by norm_num) (by norm_num) oscBlock13 vbpBr13.1 vbpBr14.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i14 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    (0.00066391:ℝ) ≤ ∫ v in (vBP 1.09)..(vBP 1.1), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.09488413) (m := (0:ℤ)) (ylo := 1.09488413) (yhi := 1.09488413)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.09) (q1 := 1.1) (t0 := 6) (t1 := 6.0625)
    (A := 0.17235539) (B := 0.19062036) (X := 1.09488413) (rho := 0.06075181)
    (clo := 0.45814946) (chi := 0.45815015) (C := 0.4581498) (h := 0.06075216)
    (by norm_num) (by norm_num) oscBlock14 vbpBr14.1 vbpBr15.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i15 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    (0.00071714:ℝ) ≤ ∫ v in (vBP 1.1)..(vBP 1.109), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.19907947) (m := (0:ℤ)) (ylo := 1.19907947) (yhi := 1.19907947)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.1) (q1 := 1.109) (t0 := 6) (t1 := 6.0625)
    (A := 0.19062035) (B := 0.20691742) (X := 1.19907947) (rho := 0.05535739)
    (clo := 0.36321555) (chi := 0.36321725) (C := 0.3632164) (h := 0.05535824)
    (by norm_num) (by norm_num) oscBlock15 vbpBr15.1 vbpBr16.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i16 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    (0.00057941:ℝ) ≤ ∫ v in (vBP 1.109)..(vBP 1.117), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.29154678) (m := (0:ℤ)) (ylo := 1.29154678) (yhi := 1.29154678)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.109) (q1 := 1.117) (t0 := 6) (t1 := 6.0625)
    (A := 0.20691741) (B := 0.22129305) (X := 1.29154678) (rho := 0.05004234)
    (clo := 0.27563429) (chi := 0.27563786) (C := 0.27563607) (h := 0.05004413)
    (by norm_num) (by norm_num) oscBlock16 vbpBr16.1 vbpBr17.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i17 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    (0.00038775:ℝ) ≤ ∫ v in (vBP 1.117)..(vBP 1.124), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.3725475) (m := (0:ℤ)) (ylo := 1.3725475) (yhi := 1.3725475)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.117) (q1 := 1.124) (t0 := 6) (t1 := 6.0625)
    (A := 0.22129304) (B := 0.23378751) (X := 1.3725475) (rho := 0.04478928)
    (clo := 0.19695266) (chi := 0.19695921) (C := 0.19695593) (h := 0.04479256)
    (by norm_num) (by norm_num) oscBlock17 vbpBr17.1 vbpBr18.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i18 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    (0.00020843:ℝ) ≤ ∫ v in (vBP 1.124)..(vBP 1.131), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.44766958) (m := (0:ℤ)) (ylo := 1.44766958) (yhi := 1.44766958)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.124) (q1 := 1.131) (t0 := 6) (t1 := 6.0625)
    (A := 0.2337875) (B := 0.2462044) (X := 1.44766958) (rho := 0.0449446)
    (clo := 0.1228157) (chi := 0.12282685) (C := 0.12282127) (h := 0.04495018)
    (by norm_num) (by norm_num) oscBlock18 vbpBr18.1 vbpBr19.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i19 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00000991):ℝ) ≤ ∫ v in (vBP 1.131)..(vBP 1.138), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.52232673) (m := (0:ℤ)) (ylo := 1.52232673) (yhi := 1.52232673)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.131) (q1 := 1.138) (t0 := 6) (t1 := 6.0625)
    (A := 0.24620439) (B := 0.25854468) (X := 1.52232673) (rho := 0.04510041)
    (clo := 0.0484503) (chi := 0.04846873) (C := 0.04845951) (h := 0.04510963)
    (by norm_num) (by norm_num) oscBlock19 vbpBr19.1 vbpBr20.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i20 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00026431):ℝ) ≤ ∫ v in (vBP 1.138)..(vBP 1.145), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.59652464) (m := (0:ℤ)) (ylo := 0.02572831) (yhi := 0.02572832)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.138) (q1 := 1.145) (t0 := 6) (t1 := 6.0625)
    (A := 0.25854467) (B := 0.27080928) (X := 1.59652464) (rho := 0.04525663)
    (clo := (-0.02572549)) (chi := (-0.02572547)) (C := (-0.02572548)) (h := 0.04525664)
    (by norm_num) (by norm_num) oscBlock20 vbpBr20.1 vbpBr21.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i21 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00055432):ℝ) ≤ ∫ v in (vBP 1.145)..(vBP 1.152), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.67026892) (m := (0:ℤ)) (ylo := 0.09947259) (yhi := 0.0994726)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.145) (q1 := 1.152) (t0 := 6) (t1 := 6.0625)
    (A := 0.27080927) (B := 0.28299913) (X := 1.67026892) (rho := 0.04541332)
    (clo := (-0.09930864)) (chi := (-0.09930862)) (C := (-0.09930863)) (h := 0.04541333)
    (by norm_num) (by norm_num) oscBlock21 vbpBr21.1 vbpBr22.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i22 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00084854):ℝ) ≤ ∫ v in (vBP 1.152)..(vBP 1.159), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.74356509) (m := (0:ℤ)) (ylo := 0.17276876) (yhi := 0.17276877)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.152) (q1 := 1.159) (t0 := 6) (t1 := 6.0625)
    (A := 0.28299912) (B := 0.29511513) (X := 1.74356509) (rho := 0.04557039)
    (clo := (-0.17191056)) (chi := (-0.17191054)) (C := (-0.17191055)) (h := 0.0455704)
    (by norm_num) (by norm_num) oscBlock22 vbpBr22.1 vbpBr23.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i23 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00113677):ℝ) ≤ ∫ v in (vBP 1.159)..(vBP 1.166), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.81641859) (m := (0:ℤ)) (ylo := 0.24562226) (yhi := 0.24562227)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.159) (q1 := 1.166) (t0 := 6) (t1 := 6.0625)
    (A := 0.29511512) (B := 0.30715818) (X := 1.81641859) (rho := 0.04572789)
    (clo := (-0.24315997)) (chi := (-0.24315995)) (C := (-0.24315996)) (h := 0.0457279)
    (by norm_num) (by norm_num) oscBlock23 vbpBr23.1 vbpBr24.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i24 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00141026):ℝ) ≤ ∫ v in (vBP 1.166)..(vBP 1.173), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.88883471) (m := (0:ℤ)) (ylo := 0.31803838) (yhi := 0.31803839)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.166) (q1 := 1.173) (t0 := 6) (t1 := 6.0625)
    (A := 0.30715817) (B := 0.31912914) (X := 1.88883471) (rho := 0.04588571)
    (clo := (-0.31270393)) (chi := (-0.31270391)) (C := (-0.31270392)) (h := 0.04588572)
    (by norm_num) (by norm_num) oscBlock24 vbpBr24.1 vbpBr25.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i25 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00166146):ℝ) ≤ ∫ v in (vBP 1.173)..(vBP 1.18), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.96081868) (m := (0:ℤ)) (ylo := 0.39002235) (yhi := 0.39002236)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.173) (q1 := 1.18) (t0 := 6) (t1 := 6.0625)
    (A := 0.31912913) (B := 0.33102888) (X := 1.96081868) (rho := 0.04604392)
    (clo := (-0.3802091)) (chi := (-0.38020908)) (C := (-0.38020909)) (h := 0.04604393)
    (by norm_num) (by norm_num) oscBlock25 vbpBr25.1 vbpBr26.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i26 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00188406):ℝ) ≤ ∫ v in (vBP 1.18)..(vBP 1.187), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.03237565) (m := (0:ℤ)) (ylo := 0.46157932) (yhi := 0.46157933)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.18) (q1 := 1.187) (t0 := 6) (t1 := 6.0625)
    (A := 0.33102887) (B := 0.34285824) (X := 2.03237565) (rho := 0.04620244)
    (clo := (-0.44536272)) (chi := (-0.4453627)) (C := (-0.44536271)) (h := 0.04620245)
    (by norm_num) (by norm_num) oscBlock26 vbpBr26.1 vbpBr27.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i27 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00207303):ℝ) ≤ ∫ v in (vBP 1.187)..(vBP 1.194), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.10351062) (m := (0:ℤ)) (ylo := 0.53271429) (yhi := 0.5327143)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.187) (q1 := 1.194) (t0 := 6) (t1 := 6.0625)
    (A := 0.34285823) (B := 0.35461804) (X := 2.10351062) (rho := 0.04636126)
    (clo := (-0.5078734)) (chi := (-0.50787338)) (C := (-0.50787339)) (h := 0.04636127)
    (by norm_num) (by norm_num) oscBlock27 vbpBr27.1 vbpBr28.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i28 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00224746):ℝ) ≤ ∫ v in (vBP 1.194)..(vBP 1.201), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.17422848) (m := (0:ℤ)) (ylo := 0.60343215) (yhi := 0.60343216)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.194) (q1 := 1.201) (t0 := 6) (t1 := 6.0625)
    (A := 0.35461802) (B := 0.36630909) (X := 2.17422848) (rho := 0.04652038)
    (clo := (-0.56747183)) (chi := (-0.56747181)) (C := (-0.56747182)) (h := 0.04652039)
    (by norm_num) (by norm_num) oscBlock28 vbpBr28.1 vbpBr29.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i29 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00236089):ℝ) ≤ ∫ v in (vBP 1.201)..(vBP 1.208), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.24453422) (m := (0:ℤ)) (ylo := 0.67373789) (yhi := 0.6737379)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.201) (q1 := 1.208) (t0 := 6) (t1 := 6.0625)
    (A := 0.36630908) (B := 0.3779322) (X := 2.24453422) (rho := 0.04667976)
    (clo := (-0.62391149)) (chi := (-0.62391148)) (C := (-0.62391149)) (h := 0.04667977)
    (by norm_num) (by norm_num) oscBlock29 vbpBr29.1 vbpBr30.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i30 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00243295):ℝ) ≤ ∫ v in (vBP 1.208)..(vBP 1.215), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.31443255) (m := (0:ℤ)) (ylo := 0.74363622) (yhi := 0.74363623)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.208) (q1 := 1.215) (t0 := 6) (t1 := 6.0625)
    (A := 0.37793219) (B := 0.38948816) (X := 2.31443255) (rho := 0.04683943)
    (clo := (-0.6769687)) (chi := (-0.67696868)) (C := (-0.67696869)) (h := 0.04683944)
    (by norm_num) (by norm_num) oscBlock30 vbpBr30.1 vbpBr31.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i31 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00283392):ℝ) ≤ ∫ v in (vBP 1.215)..(vBP 1.223), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.38888728) (m := (0:ℤ)) (ylo := 0.81809095) (yhi := 0.81809096)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.215) (q1 := 1.223) (t0 := 6) (t1 := 6.0625)
    (A := 0.38948815) (B := 0.40261372) (X := 2.38888728) (rho := 0.0519584)
    (clo := (-0.72984212)) (chi := (-0.7298421)) (C := (-0.72984211)) (h := 0.05195841)
    (by norm_num) (by norm_num) oscBlock31 vbpBr31.1 vbpBr32.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i32 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00281212):ℝ) ≤ ∫ v in (vBP 1.223)..(vBP 1.231), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.4677914) (m := (0:ℤ)) (ylo := 0.89699507) (yhi := 0.89699508)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.223) (q1 := 1.231) (t0 := 6) (t1 := 6.0625)
    (A := 0.40261371) (B := 0.4156537) (X := 2.4677914) (rho := 0.05210916)
    (clo := (-0.7814555)) (chi := (-0.78145548)) (C := (-0.78145549)) (h := 0.05210917)
    (by norm_num) (by norm_num) oscBlock32 vbpBr32.1 vbpBr33.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i33 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.0027333):ℝ) ≤ ∫ v in (vBP 1.231)..(vBP 1.239), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.54618273) (m := (0:ℤ)) (ylo := 0.9753864) (yhi := 0.97538641)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.231) (q1 := 1.239) (t0 := 6) (t1 := 6.0625)
    (A := 0.41565369) (B := 0.42860921) (X := 2.54618273) (rho := 0.05226061)
    (clo := (-0.82791869)) (chi := (-0.82791866)) (C := (-0.82791868)) (h := 0.05226063)
    (by norm_num) (by norm_num) oscBlock33 vbpBr33.1 vbpBr34.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i34 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00293204):ℝ) ≤ ∫ v in (vBP 1.239)..(vBP 1.248), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.62892764) (m := (0:ℤ)) (ylo := 1.05813131) (yhi := 1.05813132)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.239) (q1 := 1.248) (t0 := 6) (t1 := 6.0625)
    (A := 0.4286092) (B := 0.44308455) (X := 2.62892764) (rho := 0.05727246)
    (clo := (-0.87144047)) (chi := (-0.8714404)) (C := (-0.87144044)) (h := 0.0572725)
    (by norm_num) (by norm_num) oscBlock34 vbpBr34.1 vbpBr35.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i35 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00299904):ℝ) ≤ ∫ v in (vBP 1.248)..(vBP 1.258), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.72073774) (m := (0:ℤ)) (ylo := 1.14994141) (yhi := 1.14994142)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.248) (q1 := 1.258) (t0 := 6) (t1 := 6.0625)
    (A := 0.44308453) (B := 0.45904632) (X := 2.72073774) (rho := 0.06223058)
    (clo := (-0.91274013)) (chi := (-0.91274)) (C := (-0.91274007)) (h := 0.06223065)
    (by norm_num) (by norm_num) oscBlock35 vbpBr35.1 vbpBr36.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i36 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00264809):ℝ) ≤ ∫ v in (vBP 1.258)..(vBP 1.268), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.81662414) (m := (0:ℤ)) (ylo := 1.24582781) (yhi := 1.24582782)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.258) (q1 := 1.268) (t0 := 6) (t1 := 6.0625)
    (A := 0.45904631) (B := 0.47488172) (X := 2.81662414) (rho := 0.0623463)
    (clo := (-0.94766107)) (chi := (-0.94766077)) (C := (-0.94265724)) (h := 0.05734277)
    (by norm_num) (by norm_num) oscBlock36 vbpBr36.1 vbpBr37.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i37 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00261048):ℝ) ≤ ∫ v in (vBP 1.268)..(vBP 1.28), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.92123436) (m := (0:ℤ)) (ylo := 1.35043803) (yhi := 1.35043804)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.268) (q1 := 1.28) (t0 := 6) (t1 := 6.0625)
    (A := 0.4748817) (B := 0.49372017) (X := 2.92123436) (rho := 0.07194418)
    (clo := (-0.97581988)) (chi := (-0.97581918)) (C := (-0.9519375)) (h := 0.0480625)
    (by norm_num) (by norm_num) oscBlock37 vbpBr37.1 vbpBr38.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i38 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.0022862):ℝ) ≤ ∫ v in (vBP 1.28)..(vBP 1.294), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.04369828) (m := (0:ℤ)) (ylo := 1.47290195) (yhi := 1.47290196)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.28) (q1 := 1.294) (t0 := 6) (t1 := 6.0625)
    (A := 0.49372014) (B := 0.51547641) (X := 3.04369828) (rho := 0.08137746)
    (clo := (-0.99521393)) (chi := (-0.99521214)) (C := (-0.95691734)) (h := 0.04308266)
    (by norm_num) (by norm_num) oscBlock38 vbpBr38.1 vbpBr39.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i39 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00152768):ℝ) ≤ ∫ v in (vBP 1.294)..(vBP 1.308), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.17420593) (m := (0:ℤ)) (ylo := 0.03261327) (yhi := 0.03261328)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.294) (q1 := 1.308) (t0 := 6) (t1 := 6.0625)
    (A := 0.51547638) (B := 0.53699853) (X := 3.17420593) (rho := 0.08134767)
    (clo := (-0.99946824)) (chi := (-0.99946823)) (C := (-0.95906028)) (h := 0.04093972)
    (by norm_num) (by norm_num) oscBlock39 vbpBr39.1 vbpBr40.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i40 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00099545):ℝ) ≤ ∫ v in (vBP 1.308)..(vBP 1.326), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.32163233) (m := (0:ℤ)) (ylo := 0.18003967) (yhi := 0.18003968)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.308) (q1 := 1.326) (t0 := 6) (t1 := 6.0625)
    (A := 0.53699848) (B := 0.56433382) (X := 3.32163233) (rho := 0.09964147)
    (clo := (-0.98383659)) (chi := (-0.98383658)) (C := (-0.94209756)) (h := 0.05790245)
    (by norm_num) (by norm_num) oscBlock40 vbpBr40.1 vbpBr41.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i41 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00003178):ℝ) ≤ ∫ v in (vBP 1.326)..(vBP 1.345), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.48989008) (m := (0:ℤ)) (ylo := 0.34829742) (yhi := 0.34829743)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.326) (q1 := 1.345) (t0 := 6) (t1 := 6.0625)
    (A := 0.56433374) (B := 0.59278808) (X := 3.48989008) (rho := 0.10388766)
    (clo := (-0.93995517)) (chi := (-0.93995515)) (C := (-0.91803375)) (h := 0.08196626)
    (by norm_num) (by norm_num) oscBlock41 vbpBr41.1 vbpBr42.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i42 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    (0.0007735:ℝ) ≤ ∫ v in (vBP 1.345)..(vBP 1.362), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.65139902) (m := (0:ℤ)) (ylo := 0.50980636) (yhi := 0.50980637)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.345) (q1 := 1.362) (t0 := 6) (t1 := 6.0625)
    (A := 0.59278796) (B := 0.6179085) (X := 3.65139902) (rho := 0.09467128)
    (clo := (-0.87283903)) (chi := (-0.87283901)) (C := (-0.87283902)) (h := 0.09467129)
    (by norm_num) (by norm_num) oscBlock42 vbpBr42.1 vbpBr43.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i43 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    (0.00088475:ℝ) ≤ ∫ v in (vBP 1.362)..(vBP 1.376), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.78875853) (m := (0:ℤ)) (ylo := 0.64716587) (yhi := 0.64716588)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.362) (q1 := 1.376) (t0 := 6) (t1 := 6.0625)
    (A := 0.61790831) (B := 0.6383616) (X := 3.78875853) (rho := 0.08130868)
    (clo := (-0.79779578)) (chi := (-0.79779576)) (C := (-0.79779577)) (h := 0.08130869)
    (by norm_num) (by norm_num) oscBlock43 vbpBr43.1 vbpBr44.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i44 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    (0.0009294:ℝ) ≤ ∫ v in (vBP 1.376)..(vBP 1.39), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.91148848) (m := (0:ℤ)) (ylo := 0.76989582) (yhi := 0.76989583)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.376) (q1 := 1.39) (t0 := 6) (t1 := 6.0625)
    (A := 0.63836133) (B := 0.65860767) (X := 3.91148848) (rho := 0.08132052)
    (clo := (-0.71798321)) (chi := (-0.71798318)) (C := (-0.7179832)) (h := 0.08132054)
    (by norm_num) (by norm_num) oscBlock44 vbpBr44.1 vbpBr45.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i45 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    (0.00085655:ℝ) ≤ ∫ v in (vBP 1.39)..(vBP 1.404), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.03298228) (m := (0:ℤ)) (ylo := 0.89138962) (yhi := 0.89138963)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.39) (q1 := 1.404) (t0 := 6) (t1 := 6.0625)
    (A := 0.65860729) (B := 0.67865086) (X := 4.03298228) (rho := 0.08133856)
    (clo := (-0.62833168)) (chi := (-0.62833157)) (C := (-0.62833163)) (h := 0.08133862)
    (by norm_num) (by norm_num) oscBlock45 vbpBr45.1 vbpBr46.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i46 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    (0.00069983:ℝ) ≤ ∫ v in (vBP 1.404)..(vBP 1.418), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.15326453) (m := (0:ℤ)) (ylo := 1.01167187) (yhi := 1.01167188)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.404) (q1 := 1.418) (t0 := 6) (t1 := 6.0625)
    (A := 0.67865033) (B := 0.69849519) (X := 4.15326453) (rho := 0.08136257)
    (clo := (-0.5304445)) (chi := (-0.53044417)) (C := (-0.53044434)) (h := 0.08136274)
    (by norm_num) (by norm_num) oscBlock46 vbpBr46.1 vbpBr47.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i47 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    (0.00049607:ℝ) ≤ ∫ v in (vBP 1.418)..(vBP 1.432), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.27235919) (m := (0:ℤ)) (ylo := 1.13076653) (yhi := 1.13076654)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.418) (q1 := 1.432) (t0 := 6) (t1 := 6.0625)
    (A := 0.69849446) (B := 0.7181446) (X := 4.27235919) (rho := 0.08139245)
    (clo := (-0.42596736)) (chi := (-0.4259664)) (C := (-0.42596688)) (h := 0.08139293)
    (by norm_num) (by norm_num) oscBlock47 vbpBr47.1 vbpBr48.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i48 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    (0.00028075:ℝ) ≤ ∫ v in (vBP 1.432)..(vBP 1.446), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.39028946) (m := (0:ℤ)) (ylo := 1.2486968) (yhi := 1.24869681)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.432) (q1 := 1.446) (t0 := 6) (t1 := 6.0625)
    (A := 0.7181436) (B := 0.73760286) (X := 4.39028946) (rho := 0.08142788)
    (clo := (-0.31656133)) (chi := (-0.31655877)) (C := (-0.31656005)) (h := 0.08142916)
    (by norm_num) (by norm_num) oscBlock48 vbpBr48.1 vbpBr49.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i49 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    (0.0000638:ℝ) ≤ ∫ v in (vBP 1.446)..(vBP 1.462), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.51537719) (m := (0:ℤ)) (ylo := 1.37378453) (yhi := 1.37378454)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.446) (q1 := 1.462) (t0 := 6) (t1 := 6.0625)
    (A := 0.73760153) (B := 0.75961158) (X := 4.51537719) (rho := 0.08976803)
    (clo := (-0.19574632)) (chi := (-0.1957397)) (C := (-0.19574301)) (h := 0.08977134)
    (by norm_num) (by norm_num) oscBlock49 vbpBr49.1 vbpBr50.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i50 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00021401):ℝ) ≤ ∫ v in (vBP 1.462)..(vBP 1.478), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.64738977) (m := (0:ℤ)) (ylo := 1.50579711) (yhi := 1.50579712)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.462) (q1 := 1.478) (t0 := 6) (t1 := 6.0625)
    (A := 0.75960973) (B := 0.78138081) (X := 4.64738977) (rho := 0.08973141)
    (clo := (-0.0649697)) (chi := (-0.06495316)) (C := (-0.06496143)) (h := 0.08973968)
    (by norm_num) (by norm_num) oscBlock50 vbpBr50.1 vbpBr51.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i51 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00033849):ℝ) ≤ ∫ v in (vBP 1.478)..(vBP 1.495), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.78202986) (m := (0:ℤ)) (ylo := 0.06964087) (yhi := 0.06964088)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.478) (q1 := 1.495) (t0 := 6) (t1 := 6.0625)
    (A := 0.7813783) (B := 0.80425401) (X := 4.78202986) (rho := 0.09376008)
    (clo := 0.06958459) (chi := 0.06958461) (C := 0.0695846) (h := 0.09376009)
    (by norm_num) (by norm_num) oscBlock51 vbpBr51.1 vbpBr52.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i52 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00057454):ℝ) ≤ ∫ v in (vBP 1.495)..(vBP 1.512), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.91919748) (m := (0:ℤ)) (ylo := 0.20680849) (yhi := 0.2068085)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.495) (q1 := 1.512) (t0 := 6) (t1 := 6.0625)
    (A := 0.80425056) (B := 0.82686872) (X := 4.91919748) (rho := 0.09369414)
    (clo := 0.20533744) (chi := 0.20533746) (C := 0.20533745) (h := 0.09369415)
    (by norm_num) (by norm_num) oscBlock52 vbpBr52.1 vbpBr53.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i53 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00088015):ℝ) ≤ ∫ v in (vBP 1.512)..(vBP 1.531), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.06274797) (m := (0:ℤ)) (ylo := 0.35035898) (yhi := 0.35035899)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.512) (q1 := 1.531) (t0 := 6) (t1 := 6.0625)
    (A := 0.82686405) (B := 0.85184522) (X := 5.06274797) (rho := 0.10156369)
    (clo := 0.343235) (chi := 0.34323502) (C := 0.34323501) (h := 0.1015637)
    (by norm_num) (by norm_num) oscBlock53 vbpBr53.1 vbpBr54.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i54 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00105299):ℝ) ≤ ∫ v in (vBP 1.531)..(vBP 1.55), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.21244916) (m := (0:ℤ)) (ylo := 0.50006017) (yhi := 0.50006018)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.531) (q1 := 1.55) (t0 := 6) (t1 := 6.0625)
    (A := 0.85183877) (B := 0.87651393) (X := 5.21244916) (rho := 0.10141656)
    (clo := 0.47947834) (chi := 0.47947836) (C := 0.47947835) (h := 0.10141657)
    (by norm_num) (by norm_num) oscBlock54 vbpBr54.1 vbpBr55.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i55 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00124471):ℝ) ≤ ∫ v in (vBP 1.55)..(vBP 1.57), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.36417818) (m := (0:ℤ)) (ylo := 0.65178919) (yhi := 0.6517892)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.55) (q1 := 1.57) (t0 := 6) (t1 := 6.0625)
    (A := 0.87650515) (B := 0.90215678) (X := 5.36417818) (rho := 0.1051473)
    (clo := 0.60660978) (chi := 0.60660979) (C := 0.60660978) (h := 0.10514731)
    (by norm_num) (by norm_num) oscBlock55 vbpBr55.1 vbpBr56.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i56 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.001321):ℝ) ≤ ∫ v in (vBP 1.57)..(vBP 1.59), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.51784447) (m := (0:ℤ)) (ylo := 0.80545548) (yhi := 0.80545549)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.57) (q1 := 1.59) (t0 := 6) (t1 := 6.0625)
    (A := 0.90214481) (B := 0.92747548) (X := 5.51784447) (rho := 0.10497563)
    (clo := 0.72114626) (chi := 0.72114628) (C := 0.72114627) (h := 0.10497564)
    (by norm_num) (by norm_num) oscBlock56 vbpBr56.1 vbpBr57.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i57 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00135043):ℝ) ≤ ∫ v in (vBP 1.59)..(vBP 1.61), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.66957786) (m := (0:ℤ)) (ylo := 0.95718887) (yhi := 0.95718888)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.59) (q1 := 1.61) (t0 := 6) (t1 := 6.0625)
    (A := 0.92745939) (B := 0.95247825) (X := 5.66957786) (rho := 0.10482154)
    (clo := 0.81757609) (chi := 0.81757612) (C := 0.8175761) (h := 0.10482156)
    (by norm_num) (by norm_num) oscBlock57 vbpBr57.1 vbpBr58.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i58 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00149216):ℝ) ≤ ∫ v in (vBP 1.61)..(vBP 1.632), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.82686149) (m := (0:ℤ)) (ylo := 1.1144725) (yhi := 1.11447251)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.61) (q1 := 1.632) (t0 := 6) (t1 := 6.0625)
    (A := 0.95245689) (B := 0.97962584) (X := 5.82686149) (rho := 0.11212017)
    (clo := 0.89767846) (chi := 0.89767856) (C := 0.89277914) (h := 0.10722086)
    (by norm_num) (by norm_num) oscBlock58 vbpBr58.1 vbpBr59.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i59 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00149999):ℝ) ≤ ∫ v in (vBP 1.632)..(vBP 1.656), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.9968019) (m := (0:ℤ)) (ylo := 1.28441291) (yhi := 1.28441292)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.632) (q1 := 1.656) (t0 := 6) (t1 := 6.0625)
    (A := 0.97959707) (B := 1.00882827) (X := 5.9968019) (rho := 0.1192195)
    (clo := 0.95927177) (chi := 0.95927217) (C := 0.92002613) (h := 0.07997387)
    (by norm_num) (by norm_num) oscBlock59 vbpBr59.1 vbpBr60.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i60 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00135601):ℝ) ≤ ∫ v in (vBP 1.656)..(vBP 1.68), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.17162846) (m := (0:ℤ)) (ylo := 1.45923947) (yhi := 1.45923948)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.656) (q1 := 1.68) (t0 := 6) (t1 := 6.0625)
    (A := 1.00878907) (B := 1.03761196) (X := 6.17162846) (rho := 0.11889406)
    (clo := 0.99378396) (chi := 0.99378557) (C := 0.93744495) (h := 0.06255505)
    (by norm_num) (by norm_num) oscBlock60 vbpBr60.1 vbpBr61.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i61 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00122808):ℝ) ≤ ∫ v in (vBP 1.68)..(vBP 1.704), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.3439576) (m := (1:ℤ)) (ylo := 0.06077229) (yhi := 0.0607723)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.68) (q1 := 1.704) (t0 := 6) (t1 := 6.0625)
    (A := 1.03755935) (B := 1.06598913) (X := 6.3439576) (rho := 0.11860152)
    (clo := 0.99815393) (chi := 0.99815394) (C := 0.9397762) (h := 0.0602238)
    (by norm_num) (by norm_num) oscBlock61 vbpBr61.1 vbpBr62.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i62 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00137159):ℝ) ≤ ∫ v in (vBP 1.704)..(vBP 1.734), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.53488214) (m := (1:ℤ)) (ylo := 0.25169683) (yhi := 0.25169684)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.704) (q1 := 1.734) (t0 := 6) (t1 := 6.0625)
    (A := 1.06591948) (B := 1.10090679) (X := 6.53488214) (rho := 0.13936528)
    (clo := 0.96849122) (chi := 0.96849123) (C := 0.91456297) (h := 0.08543703)
    (by norm_num) (by norm_num) oscBlock62 vbpBr62.1 vbpBr63.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i63 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00129873):ℝ) ≤ ∫ v in (vBP 1.734)..(vBP 1.766), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.75046715) (m := (1:ℤ)) (ylo := 0.46728184) (yhi := 0.46728185)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.734) (q1 := 1.766) (t0 := 6) (t1 := 6.0625)
    (A := 1.10080961) (B := 1.13749718) (X := 6.75046715) (rho := 0.14560951)
    (clo := 0.892796) (chi := 0.89279602) (C := 0.87359324) (h := 0.12640676)
    (by norm_num) (by norm_num) oscBlock63 vbpBr63.1 vbpBr64.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i64 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00098602):ℝ) ≤ ∫ v in (vBP 1.766)..(vBP 1.796), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.96231036) (m := (1:ℤ)) (ylo := 0.67912505) (yhi := 0.67912506)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.766) (q1 := 1.796) (t0 := 6) (t1 := 6.0625)
    (A := 1.1373613) (B := 1.17120873) (X := 6.96231036) (rho := 0.13814258)
    (clo := 0.77812257) (chi := 0.77812259) (C := 0.77812258) (h := 0.13814259)
    (by norm_num) (by norm_num) oscBlock64 vbpBr64.1 vbpBr65.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i65 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00081834):ℝ) ≤ ∫ v in (vBP 1.796)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.17046079) (m := (1:ℤ)) (ylo := 0.88727548) (yhi := 0.88727549)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.796) (q1 := 1.828) (t0 := 6) (t1 := 6.0625)
    (A := 1.1710258) (B := 1.20655947) (X := 7.17046079) (rho := 0.14430601)
    (clo := 0.63152682) (chi := 0.63152692) (C := 0.63152687) (h := 0.14430606)
    (by norm_num) (by norm_num) oscBlock65 vbpBr65.1 vbpBr66.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i66 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00057823):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.86), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.38164382) (m := (1:ℤ)) (ylo := 1.09845851) (yhi := 1.09845852)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.828) (q1 := 1.86) (t0 := 6) (t1 := 6.0625)
    (A := 1.20631244) (B := 1.24130524) (X := 7.38164382) (rho := 0.1437692)
    (clo := 0.45496935) (chi := 0.45497007) (C := 0.45496971) (h := 0.14376956)
    (by norm_num) (by norm_num) oscBlock66 vbpBr66.1 vbpBr67.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i67 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00032553):ℝ) ≤ ∫ v in (vBP 1.86)..(vBP 1.89), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.58277252) (m := (1:ℤ)) (ylo := 1.29958721) (yhi := 1.29958722)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.86) (q1 := 1.89) (t0 := 6) (t1 := 6.0625)
    (A := 1.24097685) (B := 1.27334993) (X := 7.58277252) (rho := 0.13691144)
    (clo := 0.26789649) (chi := 0.2679003) (C := 0.26789839) (h := 0.13691335)
    (by norm_num) (by norm_num) oscBlock67 vbpBr67.1 vbpBr68.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i68 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00016769):ℝ) ≤ ∫ v in (vBP 1.89)..(vBP 1.922), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.78058329) (m := (1:ℤ)) (ylo := 1.49739798) (yhi := 1.49739799)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.89) (q1 := 1.922) (t0 := 6) (t1 := 6.0625)
    (A := 1.27292668) (B := 1.30698664) (X := 7.78058329) (rho := 0.14302323)
    (clo := 0.07333218) (chi := 0.07334782) (C := 0.07334) (h := 0.14303105)
    (by norm_num) (by norm_num) oscBlock68 vbpBr68.1 vbpBr69.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i69 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00035465):ℝ) ≤ ∫ v in (vBP 1.922)..(vBP 1.969), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.02791702) (m := (1:ℤ)) (ylo := 0.17393538) (yhi := 0.17393539)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.922) (q1 := 1.969) (t0 := 6) (t1 := 6.0625)
    (A := 1.30643896) (B := 1.35541448) (X := 8.02791702) (rho := 0.18928328)
    (clo := (-0.17305969)) (chi := (-0.17305967)) (C := (-0.17305968)) (h := 0.18928329)
    (by norm_num) (by norm_num) oscBlock69 vbpBr69.1 vbpBr70.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i70 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00055708):ℝ) ≤ ∫ v in (vBP 1.969)..(vBP 2.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.315943) (m := (1:ℤ)) (ylo := 0.46196136) (yhi := 0.46196137)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.969) (q1 := 2.016) (t0 := 6) (t1 := 6.0625)
    (A := 1.35463226) (B := 1.4027369) (X := 8.315943) (rho := 0.18814946)
    (clo := (-0.44570475)) (chi := (-0.44570473)) (C := (-0.44570474)) (h := 0.18814947)
    (by norm_num) (by norm_num) oscBlock70 vbpBr70.1 vbpBr71.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i71 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00067543):ℝ) ≤ ∫ v in (vBP 2.016)..(vBP 2.062), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.59430788) (m := (1:ℤ)) (ylo := 0.74032624) (yhi := 0.74032625)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.016) (q1 := 2.062) (t0 := 6) (t1 := 6.0625)
    (A := 1.40164597) (B := 1.44803958) (X := 8.59430788) (rho := 0.18443208)
    (clo := (-0.67452881)) (chi := (-0.67452879)) (C := (-0.6745288)) (h := 0.18443209)
    (by norm_num) (by norm_num) oscBlock71 vbpBr71.1 vbpBr72.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB13i72 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.00049468):ℝ) ≤ ∫ v in (vBP 2.062)..(vBP 2.094), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.8228742) (m := (1:ℤ)) (ylo := 0.96889256) (yhi := 0.96889257)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.062) (q1 := 2.094) (t0 := 6) (t1 := 6.0625)
    (A := 1.44655973) (B := 1.47899217) (X := 8.8228742) (rho := 0.14351584)
    (clo := (-0.8242592)) (chi := (-0.82425917)) (C := (-0.82425919)) (h := 0.14351586)
    (by norm_num) (by norm_num) oscBlock72 vbpBr72.1 vbpBr73.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

/-- Lower bound for the oscillatory integral `∫₀^∞ err(v) cos(tv) dv` on the band
`6.0 ≤ t ≤ 6.0625`. -/
theorem oscBandLower13 {t : ℝ} (ht0 : (6:ℝ) ≤ t) (ht1 : t ≤ 6.0625) :
    ((-0.12423878):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosB13i0 ht0 ht1)
    (cosB13i1 ht0 ht1))
    (cosB13i2 ht0 ht1))
    (cosB13i3 ht0 ht1))
    (cosB13i4 ht0 ht1))
    (cosB13i5 ht0 ht1))
    (cosB13i6 ht0 ht1))
    (cosB13i7 ht0 ht1))
    (cosB13i8 ht0 ht1))
    (cosB13i9 ht0 ht1))
    (cosB13i10 ht0 ht1))
    (cosB13i11 ht0 ht1))
    (cosB13i12 ht0 ht1))
    (cosB13i13 ht0 ht1))
    (cosB13i14 ht0 ht1))
    (cosB13i15 ht0 ht1))
    (cosB13i16 ht0 ht1))
    (cosB13i17 ht0 ht1))
    (cosB13i18 ht0 ht1))
    (cosB13i19 ht0 ht1))
    (cosB13i20 ht0 ht1))
    (cosB13i21 ht0 ht1))
    (cosB13i22 ht0 ht1))
    (cosB13i23 ht0 ht1))
    (cosB13i24 ht0 ht1))
    (cosB13i25 ht0 ht1))
    (cosB13i26 ht0 ht1))
    (cosB13i27 ht0 ht1))
    (cosB13i28 ht0 ht1))
    (cosB13i29 ht0 ht1))
    (cosB13i30 ht0 ht1))
    (cosB13i31 ht0 ht1))
    (cosB13i32 ht0 ht1))
    (cosB13i33 ht0 ht1))
    (cosB13i34 ht0 ht1))
    (cosB13i35 ht0 ht1))
    (cosB13i36 ht0 ht1))
    (cosB13i37 ht0 ht1))
    (cosB13i38 ht0 ht1))
    (cosB13i39 ht0 ht1))
    (cosB13i40 ht0 ht1))
    (cosB13i41 ht0 ht1))
    (cosB13i42 ht0 ht1))
    (cosB13i43 ht0 ht1))
    (cosB13i44 ht0 ht1))
    (cosB13i45 ht0 ht1))
    (cosB13i46 ht0 ht1))
    (cosB13i47 ht0 ht1))
    (cosB13i48 ht0 ht1))
    (cosB13i49 ht0 ht1))
    (cosB13i50 ht0 ht1))
    (cosB13i51 ht0 ht1))
    (cosB13i52 ht0 ht1))
    (cosB13i53 ht0 ht1))
    (cosB13i54 ht0 ht1))
    (cosB13i55 ht0 ht1))
    (cosB13i56 ht0 ht1))
    (cosB13i57 ht0 ht1))
    (cosB13i58 ht0 ht1))
    (cosB13i59 ht0 ht1))
    (cosB13i60 ht0 ht1))
    (cosB13i61 ht0 ht1))
    (cosB13i62 ht0 ht1))
    (cosB13i63 ht0 ht1))
    (cosB13i64 ht0 ht1))
    (cosB13i65 ht0 ht1))
    (cosB13i66 ht0 ht1))
    (cosB13i67 ht0 ht1))
    (cosB13i68 ht0 ht1))
    (cosB13i69 ht0 ht1))
    (cosB13i70 ht0 ht1))
    (cosB13i71 ht0 ht1))
    (cosB13i72 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 2.094) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 2.094) (S := 0.013709)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_cut
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
