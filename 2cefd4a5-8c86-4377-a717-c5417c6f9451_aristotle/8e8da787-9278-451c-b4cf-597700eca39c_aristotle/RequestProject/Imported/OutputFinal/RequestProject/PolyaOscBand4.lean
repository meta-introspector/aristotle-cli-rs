/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscTail

/-!
# Oscillatory lower bound on the band `6.75 ≤ t ≤ 6.875`

On each of the 73 blocks the factor `cos(tv)` is bracketed by a rational constant
`C` up to a rational error `h`; the signed contribution `min(C·P₀, C·P₁) - h·S` is
then summed, and the unresolved tail beyond `q = 2.094` is estimated in absolute
value.  The result is the bound `∫₀^∞ err(v) cos(tv) dv ≥ -0.14984615`.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosB4i0 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00641868):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.0038), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.0260755) (m := (0:ℤ)) (ylo := 0.0260755) (yhi := 0.0260755)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1) (q1 := 1.0038) (t0 := 6.75) (t1 := 6.875)
    (A := 0.0) (B := 0.0075856) (X := 0.0260755) (rho := 0.02607551)
    (clo := 0.99966005) (chi := 0.99966006) (C := 0.98679227) (h := 0.01320773)
    (by norm_num) (by norm_num) oscBlock0 vbpBr0.1 vbpBr1.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i1 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00625872):ℝ) ≤ ∫ v in (vBP 1.0038)..(vBP 1.0078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.07901832) (m := (0:ℤ)) (ylo := 0.07901832) (yhi := 0.07901832)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0038) (q1 := 1.0078) (t0 := 6.75) (t1 := 6.875)
    (A := 0.00758559) (B := 0.01553948) (X := 0.07901832) (rho := 0.02781561)
    (clo := 0.99687967) (chi := 0.99687968) (C := 0.98453203) (h := 0.01546797)
    (by norm_num) (by norm_num) oscBlock1 vbpBr1.1 vbpBr2.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i2 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.0057677):ℝ) ≤ ∫ v in (vBP 1.0078)..(vBP 1.0118), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.13309582) (m := (0:ℤ)) (ylo := 0.13309582) (yhi := 0.13309582)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0078) (q1 := 1.0118) (t0 := 6.75) (t1 := 6.875)
    (A := 0.01553947) (B := 0.02346185) (X := 0.13309582) (rho := 0.02820441)
    (clo := 0.99115581) (chi := 0.99115582) (C := 0.9814757) (h := 0.0185243)
    (by norm_num) (by norm_num) oscBlock2 vbpBr2.1 vbpBr3.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i3 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00554846):ℝ) ≤ ∫ v in (vBP 1.0118)..(vBP 1.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.18831299) (m := (0:ℤ)) (ylo := 0.18831299) (yhi := 0.18831299)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0118) (q1 := 1.016) (t0 := 6.75) (t1 := 6.875)
    (A := 0.02346184) (B := 0.0317467) (X := 0.18831299) (rho := 0.02994559)
    (clo := 0.98232144) (chi := 0.98232145) (C := 0.97618792) (h := 0.02381208)
    (by norm_num) (by norm_num) oscBlock3 vbpBr3.1 vbpBr4.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i4 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00539232):ℝ) ≤ ∫ v in (vBP 1.016)..(vBP 1.0205), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.24665742) (m := (0:ℤ)) (ylo := 0.24665742) (yhi := 0.24665742)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.016) (q1 := 1.0205) (t0 := 6.75) (t1 := 6.875)
    (A := 0.03174669) (B := 0.04058541) (X := 0.24665742) (rho := 0.03236728)
    (clo := 0.96973397) (chi := 0.96973398) (C := 0.96868334) (h := 0.03131666)
    (by norm_num) (by norm_num) oscBlock4 vbpBr4.1 vbpBr5.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i5 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00478358):ℝ) ≤ ∫ v in (vBP 1.0205)..(vBP 1.025), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.30673745) (m := (0:ℤ)) (ylo := 0.30673745) (yhi := 0.30673745)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0205) (q1 := 1.025) (t0 := 6.75) (t1 := 6.875)
    (A := 0.0405854) (B := 0.04938523) (X := 0.30673745) (rho := 0.03278602)
    (clo := 0.95332376) (chi := 0.95332377) (C := 0.95332376) (h := 0.03278603)
    (by norm_num) (by norm_num) oscBlock5 vbpBr5.1 vbpBr6.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i6 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00464188):ℝ) ≤ ∫ v in (vBP 1.025)..(vBP 1.03), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.3698919) (m := (0:ℤ)) (ylo := 0.3698919) (yhi := 0.3698919)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.025) (q1 := 1.03) (t0 := 6.75) (t1 := 6.875)
    (A := 0.04938522) (B := 0.05911761) (X := 0.3698919) (rho := 0.03654168)
    (clo := 0.93236643) (chi := 0.93236644) (C := 0.93236643) (h := 0.03654169)
    (by norm_num) (by norm_num) oscBlock6 vbpBr6.1 vbpBr7.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i7 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00431738):ℝ) ≤ ∫ v in (vBP 1.03)..(vBP 1.0355), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.43935218) (m := (0:ℤ)) (ylo := 0.43935218) (yhi := 0.43935218)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.03) (q1 := 1.0355) (t0 := 6.75) (t1 := 6.875)
    (A := 0.0591176) (B := 0.06976881) (X := 0.43935218) (rho := 0.0403084)
    (clo := 0.9050274) (chi := 0.90502741) (C := 0.9050274) (h := 0.04030841)
    (by norm_num) (by norm_num) oscBlock7 vbpBr7.1 vbpBr8.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i8 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00383308):ℝ) ≤ ∫ v in (vBP 1.0355)..(vBP 1.0415), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.51502084) (m := (0:ℤ)) (ylo := 0.51502084) (yhi := 0.51502084)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0355) (q1 := 1.0415) (t0 := 6.75) (t1 := 6.875)
    (A := 0.0697688) (B := 0.08132397) (X := 0.51502084) (rho := 0.04408146)
    (clo := 0.87028245) (chi := 0.87028246) (C := 0.87028245) (h := 0.04408147)
    (by norm_num) (by norm_num) oscBlock8 vbpBr8.1 vbpBr9.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i9 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00321931):ℝ) ≤ ∫ v in (vBP 1.0415)..(vBP 1.048), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.59679304) (m := (0:ℤ)) (ylo := 0.59679304) (yhi := 0.59679304)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0415) (q1 := 1.048) (t0 := 6.75) (t1 := 6.875)
    (A := 0.08132396) (B := 0.09376718) (X := 0.59679304) (rho := 0.04785633)
    (clo := 0.82714215) (chi := 0.82714216) (C := 0.82714215) (h := 0.04785634)
    (by norm_num) (by norm_num) oscBlock9 vbpBr9.1 vbpBr10.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i10 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.0025327):ℝ) ≤ ∫ v in (vBP 1.048)..(vBP 1.055), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.68455699) (m := (0:ℤ)) (ylo := 0.68455699) (yhi := 0.68455699)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.048) (q1 := 1.055) (t0 := 6.75) (t1 := 6.875)
    (A := 0.09376717) (B := 0.10708154) (X := 0.68455699) (rho := 0.05162861)
    (clo := 0.77469925) (chi := 0.77469926) (C := 0.77469925) (h := 0.05162862)
    (by norm_num) (by norm_num) oscBlock10 vbpBr10.1 vbpBr11.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i11 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00205433):ℝ) ≤ ∫ v in (vBP 1.055)..(vBP 1.064), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.7878935) (m := (0:ℤ)) (ylo := 0.7878935) (yhi := 0.7878935)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.055) (q1 := 1.064) (t0 := 6.75) (t1 := 6.875)
    (A := 0.10708153) (B := 0.12407079) (X := 0.7878935) (rho := 0.06509319)
    (clo := 0.70534011) (chi := 0.70534014) (C := 0.70534012) (h := 0.06509321)
    (by norm_num) (by norm_num) oscBlock11 vbpBr11.1 vbpBr12.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i12 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00128609):ℝ) ≤ ∫ v in (vBP 1.064)..(vBP 1.078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.93510277) (m := (0:ℤ)) (ylo := 0.93510277) (yhi := 0.93510277)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.064) (q1 := 1.078) (t0 := 6.75) (t1 := 6.875)
    (A := 0.12407078) (B := 0.15021495) (X := 0.93510277) (rho := 0.09762502)
    (clo := 0.59373573) (chi := 0.59373588) (C := 0.5937358) (h := 0.0976251)
    (by norm_num) (by norm_num) oscBlock12 vbpBr12.1 vbpBr13.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i13 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    (0.00008475:ℝ) ≤ ∫ v in (vBP 1.078)..(vBP 1.09), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.09944711) (m := (0:ℤ)) (ylo := 1.09944711) (yhi := 1.09944711)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.078) (q1 := 1.09) (t0 := 6.75) (t1 := 6.875)
    (A := 0.15021494) (B := 0.1723554) (X := 1.09944711) (rho := 0.08549628)
    (clo := 0.45408878) (chi := 0.4540895) (C := 0.45408914) (h := 0.08549664)
    (by norm_num) (by norm_num) oscBlock13 vbpBr13.1 vbpBr14.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i14 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    (0.00039712:ℝ) ≤ ∫ v in (vBP 1.09)..(vBP 1.1), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.23695692) (m := (0:ℤ)) (ylo := 1.23695692) (yhi := 1.23695692)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.09) (q1 := 1.1) (t0 := 6.75) (t1 := 6.875)
    (A := 0.17235539) (B := 0.19062036) (X := 1.23695692) (rho := 0.07355806)
    (clo := 0.32767284) (chi := 0.32767516) (C := 0.327674) (h := 0.07355922)
    (by norm_num) (by norm_num) oscBlock14 vbpBr14.1 vbpBr15.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i15 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    (0.0003159:ℝ) ≤ ∫ v in (vBP 1.1)..(vBP 1.109), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.35462231) (m := (0:ℤ)) (ylo := 1.35462231) (yhi := 1.35462231)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.1) (q1 := 1.109) (t0 := 6.75) (t1 := 6.875)
    (A := 0.19062035) (B := 0.20691742) (X := 1.35462231) (rho := 0.06793496)
    (clo := 0.21449418) (chi := 0.21449993) (C := 0.21449705) (h := 0.06793784)
    (by norm_num) (by norm_num) oscBlock15 vbpBr15.1 vbpBr16.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i16 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    (0.00009865:ℝ) ≤ ∫ v in (vBP 1.109)..(vBP 1.117), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.45904111) (m := (0:ℤ)) (ylo := 1.45904111) (yhi := 1.45904111)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.109) (q1 := 1.117) (t0 := 6.75) (t1 := 6.875)
    (A := 0.20691741) (B := 0.22129305) (X := 1.45904111) (rho := 0.06234862)
    (clo := 0.11152254) (chi := 0.1115346) (C := 0.11152857) (h := 0.06235465)
    (by norm_num) (by norm_num) oscBlock16 vbpBr16.1 vbpBr17.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i17 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00012436):ℝ) ≤ ∫ v in (vBP 1.117)..(vBP 1.124), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.55050857) (m := (0:ℤ)) (ylo := 1.55050857) (yhi := 1.55050857)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.117) (q1 := 1.124) (t0 := 6.75) (t1 := 6.875)
    (A := 0.22129304) (B := 0.23378751) (X := 1.55050857) (rho := 0.05678057)
    (clo := 0.02028596) (chi := 0.0203081) (C := 0.02029703) (h := 0.05679164)
    (by norm_num) (by norm_num) oscBlock17 vbpBr17.1 vbpBr18.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i18 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00041423):ℝ) ≤ ∫ v in (vBP 1.124)..(vBP 1.131), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.63536043) (m := (0:ℤ)) (ylo := 0.0645641) (yhi := 0.06456411)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.124) (q1 := 1.131) (t0 := 6.75) (t1 := 6.875)
    (A := 0.2337875) (B := 0.2462044) (X := 1.63536043) (rho := 0.05729483)
    (clo := (-0.06451927)) (chi := (-0.06451925)) (C := (-0.06451926)) (h := 0.05729484)
    (by norm_num) (by norm_num) oscBlock18 vbpBr18.1 vbpBr19.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i19 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00074267):ℝ) ≤ ∫ v in (vBP 1.131)..(vBP 1.138), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.71968715) (m := (0:ℤ)) (ylo := 0.14889082) (yhi := 0.14889083)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.131) (q1 := 1.138) (t0 := 6.75) (t1 := 6.875)
    (A := 0.24620439) (B := 0.25854468) (X := 1.71968715) (rho := 0.05780754)
    (clo := (-0.14834133)) (chi := (-0.14834131)) (C := (-0.14834132)) (h := 0.05780755)
    (by norm_num) (by norm_num) oscBlock19 vbpBr19.1 vbpBr20.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i20 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00107583):ℝ) ≤ ∫ v in (vBP 1.138)..(vBP 1.145), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.80349516) (m := (0:ℤ)) (ylo := 0.23269883) (yhi := 0.23269884)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.138) (q1 := 1.145) (t0 := 6.75) (t1 := 6.875)
    (A := 0.25854467) (B := 0.27080928) (X := 1.80349516) (rho := 0.05831865)
    (clo := (-0.23060446)) (chi := (-0.23060445)) (C := (-0.23060446)) (h := 0.05831866)
    (by norm_num) (by norm_num) oscBlock20 vbpBr20.1 vbpBr21.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i21 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.0014156):ℝ) ≤ ∫ v in (vBP 1.145)..(vBP 1.152), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.88679079) (m := (0:ℤ)) (ylo := 0.31599446) (yhi := 0.31599447)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.145) (q1 := 1.152) (t0 := 6.75) (t1 := 6.875)
    (A := 0.27080927) (B := 0.28299913) (X := 1.88679079) (rho := 0.05882824)
    (clo := (-0.31076186)) (chi := (-0.31076184)) (C := (-0.31076185)) (h := 0.05882825)
    (by norm_num) (by norm_num) oscBlock21 vbpBr21.1 vbpBr22.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i22 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00174653):ℝ) ≤ ∫ v in (vBP 1.152)..(vBP 1.159), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.96958028) (m := (0:ℤ)) (ylo := 0.39878395) (yhi := 0.39878396)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.152) (q1 := 1.159) (t0 := 6.75) (t1 := 6.875)
    (A := 0.28299912) (B := 0.29511513) (X := 1.96958028) (rho := 0.05933624)
    (clo := (-0.38829801)) (chi := (-0.38829799)) (C := (-0.388298)) (h := 0.05933625)
    (by norm_num) (by norm_num) oscBlock22 vbpBr22.1 vbpBr23.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i23 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00205632):ℝ) ≤ ∫ v in (vBP 1.159)..(vBP 1.166), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.05186977) (m := (0:ℤ)) (ylo := 0.48107344) (yhi := 0.48107345)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.159) (q1 := 1.166) (t0 := 6.75) (t1 := 6.875)
    (A := 0.29511512) (B := 0.30715818) (X := 2.05186977) (rho := 0.05984273)
    (clo := (-0.46273106)) (chi := (-0.46273104)) (C := (-0.46273105)) (h := 0.05984274)
    (by norm_num) (by norm_num) oscBlock23 vbpBr23.1 vbpBr24.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i24 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00233593):ℝ) ≤ ∫ v in (vBP 1.166)..(vBP 1.173), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.13366524) (m := (0:ℤ)) (ylo := 0.56286891) (yhi := 0.56286892)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.166) (q1 := 1.173) (t0 := 6.75) (t1 := 6.875)
    (A := 0.30715817) (B := 0.31912914) (X := 2.13366524) (rho := 0.06034761)
    (clo := (-0.53361472)) (chi := (-0.5336147)) (C := (-0.53361471)) (h := 0.06034762)
    (by norm_num) (by norm_num) oscBlock24 vbpBr24.1 vbpBr25.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i25 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00257799):ℝ) ≤ ∫ v in (vBP 1.173)..(vBP 1.18), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.21497258) (m := (0:ℤ)) (ylo := 0.64417625) (yhi := 0.64417626)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.173) (q1 := 1.18) (t0 := 6.75) (t1 := 6.875)
    (A := 0.31912913) (B := 0.33102888) (X := 2.21497258) (rho := 0.06085098)
    (clo := (-0.60053999)) (chi := (-0.60053997)) (C := (-0.60053998)) (h := 0.06085099)
    (by norm_num) (by norm_num) oscBlock25 vbpBr25.1 vbpBr26.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i26 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00277681):ℝ) ≤ ∫ v in (vBP 1.18)..(vBP 1.187), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.29579763) (m := (0:ℤ)) (ylo := 0.7250013) (yhi := 0.72500131)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.18) (q1 := 1.187) (t0 := 6.75) (t1 := 6.875)
    (A := 0.33102887) (B := 0.34285824) (X := 2.29579763) (rho := 0.06135278)
    (clo := (-0.66313643)) (chi := (-0.66313641)) (C := (-0.66313642)) (h := 0.06135279)
    (by norm_num) (by norm_num) oscBlock26 vbpBr26.1 vbpBr27.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i27 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00292841):ℝ) ≤ ∫ v in (vBP 1.187)..(vBP 1.194), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.37614603) (m := (0:ℤ)) (ylo := 0.8053497) (yhi := 0.80534971)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.187) (q1 := 1.194) (t0 := 6.75) (t1 := 6.875)
    (A := 0.34285823) (B := 0.35461804) (X := 2.37614603) (rho := 0.061853)
    (clo := (-0.72107299)) (chi := (-0.72107297)) (C := (-0.72107298)) (h := 0.06185301)
    (by norm_num) (by norm_num) oscBlock27 vbpBr27.1 vbpBr28.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i28 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.0030616):ℝ) ≤ ∫ v in (vBP 1.194)..(vBP 1.201), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.45602331) (m := (0:ℤ)) (ylo := 0.88522698) (yhi := 0.88522699)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.194) (q1 := 1.201) (t0 := 6.75) (t1 := 6.875)
    (A := 0.35461802) (B := 0.36630909) (X := 2.45602331) (rho := 0.06235169)
    (clo := (-0.77405873)) (chi := (-0.77405871)) (C := (-0.77405872)) (h := 0.0623517)
    (by norm_num) (by norm_num) oscBlock28 vbpBr28.1 vbpBr29.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i29 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00311465):ℝ) ≤ ∫ v in (vBP 1.201)..(vBP 1.208), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.53543508) (m := (0:ℤ)) (ylo := 0.96463875) (yhi := 0.96463876)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.201) (q1 := 1.208) (t0 := 6.75) (t1 := 6.875)
    (A := 0.36630908) (B := 0.3779322) (X := 2.53543508) (rho := 0.06284881)
    (clo := (-0.82184319)) (chi := (-0.82184316)) (C := (-0.82184318)) (h := 0.06284883)
    (by norm_num) (by norm_num) oscBlock29 vbpBr29.1 vbpBr30.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i30 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00311782):ℝ) ≤ ∫ v in (vBP 1.208)..(vBP 1.215), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.61438669) (m := (0:ℤ)) (ylo := 1.04359036) (yhi := 1.04359037)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.208) (q1 := 1.215) (t0 := 6.75) (t1 := 6.875)
    (A := 0.37793219) (B := 0.38948816) (X := 2.61438669) (rho := 0.06334442)
    (clo := (-0.86421623)) (chi := (-0.86421617)) (C := (-0.8642162)) (h := 0.06334445)
    (by norm_num) (by norm_num) oscBlock30 vbpBr30.1 vbpBr31.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i31 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00352661):ℝ) ≤ ∫ v in (vBP 1.215)..(vBP 1.223), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.69850716) (m := (0:ℤ)) (ylo := 1.12771083) (yhi := 1.12771084)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.215) (q1 := 1.223) (t0 := 6.75) (t1 := 6.875)
    (A := 0.38948815) (B := 0.40261372) (X := 2.69850716) (rho := 0.06946217)
    (clo := (-0.90343323)) (chi := (-0.90343312)) (C := (-0.90343318)) (h := 0.06946223)
    (by norm_num) (by norm_num) oscBlock31 vbpBr31.1 vbpBr32.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i32 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00337361):ℝ) ≤ ∫ v in (vBP 1.223)..(vBP 1.231), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.78763086) (m := (0:ℤ)) (ylo := 1.21683453) (yhi := 1.21683454)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.223) (q1 := 1.231) (t0 := 6.75) (t1 := 6.875)
    (A := 0.40261371) (B := 0.4156537) (X := 2.78763086) (rho := 0.06998834)
    (clo := (-0.93800708)) (chi := (-0.93800685)) (C := (-0.93400926)) (h := 0.06599075)
    (by norm_num) (by norm_num) oscBlock32 vbpBr32.1 vbpBr33.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i33 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00310538):ℝ) ≤ ∫ v in (vBP 1.231)..(vBP 1.239), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.87617536) (m := (0:ℤ)) (ylo := 1.30537903) (yhi := 1.30537904)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.231) (q1 := 1.239) (t0 := 6.75) (t1 := 6.875)
    (A := 0.41565369) (B := 0.42860921) (X := 2.87617536) (rho := 0.07051297)
    (clo := (-0.9649836)) (chi := (-0.96498311)) (C := (-0.94723507)) (h := 0.05276493)
    (by norm_num) (by norm_num) oscBlock33 vbpBr33.1 vbpBr34.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i34 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00315711):ℝ) ≤ ∫ v in (vBP 1.239)..(vBP 1.248), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.96965919) (m := (0:ℤ)) (ylo := 1.39886286) (yhi := 1.39886287)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.239) (q1 := 1.248) (t0 := 6.75) (t1 := 6.875)
    (A := 0.4286092) (B := 0.44308455) (X := 2.96965919) (rho := 0.07654711)
    (clo := (-0.98525682)) (chi := (-0.9852558)) (C := (-0.95435435)) (h := 0.04564566)
    (by norm_num) (by norm_num) oscBlock34 vbpBr34.1 vbpBr35.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i35 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00307604):ℝ) ≤ ∫ v in (vBP 1.248)..(vBP 1.258), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.07338201) (m := (0:ℤ)) (ylo := 1.50258568) (yhi := 1.50258569)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.248) (q1 := 1.258) (t0 := 6.75) (t1 := 6.875)
    (A := 0.44308453) (B := 0.45904632) (X := 3.07338201) (rho := 0.08256145)
    (clo := (-0.99767674)) (chi := (-0.99767452)) (C := (-0.95755654)) (h := 0.04244347)
    (by norm_num) (by norm_num) oscBlock35 vbpBr35.1 vbpBr36.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i36 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00264809):ℝ) ≤ ∫ v in (vBP 1.258)..(vBP 1.268), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.1816872) (m := (0:ℤ)) (ylo := 0.04009454) (yhi := 0.04009455)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.258) (q1 := 1.268) (t0 := 6.75) (t1 := 6.875)
    (A := 0.45904631) (B := 0.47488172) (X := 3.1816872) (rho := 0.08312463)
    (clo := (-0.99919633)) (chi := (-0.99919632)) (C := (-0.95803585)) (h := 0.04196416)
    (by norm_num) (by norm_num) oscBlock36 vbpBr36.1 vbpBr37.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i37 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00261048):ℝ) ≤ ∫ v in (vBP 1.268)..(vBP 1.28), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.29988882) (m := (0:ℤ)) (ylo := 0.15829616) (yhi := 0.15829617)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.268) (q1 := 1.28) (t0 := 6.75) (t1 := 6.875)
    (A := 0.4748817) (B := 0.49372017) (X := 3.29988882) (rho := 0.09443736)
    (clo := (-0.98749731)) (chi := (-0.9874973)) (C := (-0.94652997)) (h := 0.05347003)
    (by norm_num) (by norm_num) oscBlock37 vbpBr37.1 vbpBr38.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i38 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.0022862):ℝ) ≤ ∫ v in (vBP 1.28)..(vBP 1.294), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.43825563) (m := (0:ℤ)) (ylo := 0.29666297) (yhi := 0.29666298)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.28) (q1 := 1.294) (t0 := 6.75) (t1 := 6.875)
    (A := 0.49372014) (B := 0.51547641) (X := 3.43825563) (rho := 0.1056447)
    (clo := (-0.95631733)) (chi := (-0.95631732)) (C := (-0.92533631)) (h := 0.07466369)
    (by norm_num) (by norm_num) oscBlock38 vbpBr38.1 vbpBr39.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i39 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00152769):ℝ) ≤ ∫ v in (vBP 1.294)..(vBP 1.308), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.58566522) (m := (0:ℤ)) (ylo := 0.44407256) (yhi := 0.44407257)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.294) (q1 := 1.308) (t0 := 6.75) (t1 := 6.875)
    (A := 0.51547638) (B := 0.53699853) (X := 3.58566522) (rho := 0.10619968)
    (clo := (-0.90300951)) (chi := (-0.90300949)) (C := (-0.89840491)) (h := 0.1015951)
    (by norm_num) (by norm_num) oscBlock39 vbpBr39.1 vbpBr40.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i40 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.0009499):ℝ) ≤ ∫ v in (vBP 1.308)..(vBP 1.326), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.75226737) (m := (0:ℤ)) (ylo := 0.61067471) (yhi := 0.61067472)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.308) (q1 := 1.326) (t0 := 6.75) (t1 := 6.875)
    (A := 0.53699848) (B := 0.56433382) (X := 3.75226737) (rho := 0.12752765)
    (clo := (-0.81926132)) (chi := (-0.8192613)) (C := (-0.81926131)) (h := 0.12752766)
    (by norm_num) (by norm_num) oscBlock40 vbpBr40.1 vbpBr41.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i41 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00014223):ℝ) ≤ ∫ v in (vBP 1.326)..(vBP 1.345), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.94233539) (m := (0:ℤ)) (ylo := 0.80074273) (yhi := 0.80074274)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.326) (q1 := 1.345) (t0 := 6.75) (t1 := 6.875)
    (A := 0.56433374) (B := 0.59278808) (X := 3.94233539) (rho := 0.13308267)
    (clo := (-0.69617375)) (chi := (-0.6961737)) (C := (-0.69617373)) (h := 0.1330827)
    (by norm_num) (by norm_num) oscBlock41 vbpBr41.1 vbpBr42.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i42 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    (0.00036625:ℝ) ≤ ∫ v in (vBP 1.345)..(vBP 1.362), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.12471983) (m := (0:ℤ)) (ylo := 0.98312717) (yhi := 0.98312718)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.345) (q1 := 1.362) (t0 := 6.75) (t1 := 6.875)
    (A := 0.59278796) (B := 0.6179085) (X := 4.12471983) (rho := 0.12340112)
    (clo := (-0.55442296)) (chi := (-0.55442271)) (C := (-0.55442284)) (h := 0.12340125)
    (by norm_num) (by norm_num) oscBlock42 vbpBr42.1 vbpBr43.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i43 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    (0.00033475:ℝ) ≤ ∫ v in (vBP 1.362)..(vBP 1.376), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.27980854) (m := (0:ℤ)) (ylo := 1.13821588) (yhi := 1.13821589)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.362) (q1 := 1.376) (t0 := 6.75) (t1 := 6.875)
    (A := 0.61790831) (B := 0.6383616) (X := 4.27980854) (rho := 0.10892747)
    (clo := (-0.41921595)) (chi := (-0.41921493)) (C := (-0.41921544)) (h := 0.10892798)
    (by norm_num) (by norm_num) oscBlock43 vbpBr43.1 vbpBr44.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i44 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    (0.00020975:ℝ) ≤ ∫ v in (vBP 1.376)..(vBP 1.39), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.41843335) (m := (0:ℤ)) (ylo := 1.27684069) (yhi := 1.2768407)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.376) (q1 := 1.39) (t0 := 6.75) (t1 := 6.875)
    (A := 0.63836133) (B := 0.65860767) (X := 4.41843335) (rho := 0.10949439)
    (clo := (-0.28974358)) (chi := (-0.28974039)) (C := (-0.28974199)) (h := 0.10949599)
    (by norm_num) (by norm_num) oscBlock44 vbpBr44.1 vbpBr45.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i45 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    (0.00001146:ℝ) ≤ ∫ v in (vBP 1.39)..(vBP 1.404), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.55566193) (m := (0:ℤ)) (ylo := 1.41406927) (yhi := 1.41406928)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.39) (q1 := 1.404) (t0 := 6.75) (t1 := 6.875)
    (A := 0.65860729) (B := 0.67865086) (X := 4.55566193) (rho := 0.11006274)
    (clo := (-0.1560949)) (chi := (-0.15608607)) (C := (-0.15609049)) (h := 0.11006716)
    (by norm_num) (by norm_num) oscBlock45 vbpBr45.1 vbpBr46.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i46 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00021245):ℝ) ≤ ∫ v in (vBP 1.404)..(vBP 1.418), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.69152207) (m := (0:ℤ)) (ylo := 1.54992941) (yhi := 1.54992942)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.404) (q1 := 1.418) (t0 := 6.75) (t1 := 6.875)
    (A := 0.67865033) (B := 0.69849519) (X := 4.69152207) (rho := 0.11063237)
    (clo := (-0.02088706)) (chi := (-0.02086499)) (C := (-0.02087603)) (h := 0.11064341)
    (by norm_num) (by norm_num) oscBlock46 vbpBr46.1 vbpBr47.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i47 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.0004845):ℝ) ≤ ∫ v in (vBP 1.418)..(vBP 1.432), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.82604086) (m := (0:ℤ)) (ylo := 0.11365187) (yhi := 0.11365188)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.418) (q1 := 1.432) (t0 := 6.75) (t1 := 6.875)
    (A := 0.69849446) (B := 0.7181446) (X := 4.82604086) (rho := 0.11120327)
    (clo := 0.11340735) (chi := 0.11340737) (C := 0.11340736) (h := 0.11120328)
    (by norm_num) (by norm_num) oscBlock47 vbpBr47.1 vbpBr48.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i48 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00072635):ℝ) ≤ ∫ v in (vBP 1.432)..(vBP 1.446), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.95924448) (m := (0:ℤ)) (ylo := 0.24685549) (yhi := 0.2468555)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.432) (q1 := 1.446) (t0 := 6.75) (t1 := 6.875)
    (A := 0.7181436) (B := 0.73760286) (X := 4.95924448) (rho := 0.1117752)
    (clo := 0.24435598) (chi := 0.244356) (C := 0.24435599) (h := 0.11177521)
    (by norm_num) (by norm_num) oscBlock48 vbpBr48.1 vbpBr49.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i49 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.0010939):ℝ) ≤ ∫ v in (vBP 1.446)..(vBP 1.462), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.10056997) (m := (0:ℤ)) (ylo := 0.38818098) (yhi := 0.38818099)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.446) (q1 := 1.462) (t0 := 6.75) (t1 := 6.875)
    (A := 0.73760153) (B := 0.75961158) (X := 5.10056997) (rho := 0.12175966)
    (clo := 0.37850535) (chi := 0.37850537) (C := 0.37850536) (h := 0.12175967)
    (by norm_num) (by norm_num) oscBlock49 vbpBr49.1 vbpBr50.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i50 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00133106):ℝ) ≤ ∫ v in (vBP 1.462)..(vBP 1.478), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.24967937) (m := (0:ℤ)) (ylo := 0.53729038) (yhi := 0.53729039)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.462) (q1 := 1.478) (t0 := 6.75) (t1 := 6.875)
    (A := 0.75960973) (B := 0.78138081) (X := 5.24967937) (rho := 0.12231371)
    (clo := 0.51181004) (chi := 0.51181006) (C := 0.51181005) (h := 0.12231372)
    (by norm_num) (by norm_num) oscBlock50 vbpBr50.1 vbpBr51.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i51 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00158222):ℝ) ≤ ∫ v in (vBP 1.478)..(vBP 1.495), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.40177492) (m := (0:ℤ)) (ylo := 0.68938593) (yhi := 0.68938594)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.478) (q1 := 1.495) (t0 := 6.75) (t1 := 6.875)
    (A := 0.7813783) (B := 0.80425401) (X := 5.40177492) (rho := 0.12747141)
    (clo := 0.63606346) (chi := 0.63606348) (C := 0.63606347) (h := 0.12747142)
    (by norm_num) (by norm_num) oscBlock51 vbpBr51.1 vbpBr52.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i52 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00168218):ℝ) ≤ ∫ v in (vBP 1.495)..(vBP 1.512), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.55670686) (m := (0:ℤ)) (ylo := 0.84431787) (yhi := 0.84431788)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.495) (q1 := 1.512) (t0 := 6.75) (t1 := 6.875)
    (A := 0.80425056) (B := 0.82686872) (X := 5.55670686) (rho := 0.1280156)
    (clo := 0.74751818) (chi := 0.7475182) (C := 0.74751819) (h := 0.12801561)
    (by norm_num) (by norm_num) oscBlock52 vbpBr52.1 vbpBr53.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i53 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00194417):ℝ) ≤ ∫ v in (vBP 1.512)..(vBP 1.531), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.71888411) (m := (0:ℤ)) (ylo := 1.00649512) (yhi := 1.00649513)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.512) (q1 := 1.531) (t0 := 6.75) (t1 := 6.875)
    (A := 0.82686405) (B := 0.85184522) (X := 5.71888411) (rho := 0.13755179)
    (clo := 0.84496253) (chi := 0.84496258) (C := 0.84496255) (h := 0.13755182)
    (by norm_num) (by norm_num) oscBlock53 vbpBr53.1 vbpBr54.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i54 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.0018127):ℝ) ≤ ∫ v in (vBP 1.531)..(vBP 1.55), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.88797248) (m := (0:ℤ)) (ylo := 1.17558349) (yhi := 1.1755835)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.531) (q1 := 1.55) (t0 := 6.75) (t1 := 6.875)
    (A := 0.85183877) (B := 0.87651393) (X := 5.88797248) (rho := 0.1380608)
    (clo := 0.92291464) (chi := 0.9229148) (C := 0.89242692) (h := 0.10757308)
    (by norm_num) (by norm_num) oscBlock54 vbpBr54.1 vbpBr55.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i55 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00174878):ℝ) ≤ ∫ v in (vBP 1.55)..(vBP 1.57), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.05936881) (m := (0:ℤ)) (ylo := 1.34697982) (yhi := 1.34697983)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.55) (q1 := 1.57) (t0 := 6.75) (t1 := 6.875)
    (A := 0.87650515) (B := 0.90215678) (X := 6.05936881) (rho := 0.14295906)
    (clo := 0.97505746) (chi := 0.97505813) (C := 0.9160492) (h := 0.0839508)
    (by norm_num) (by norm_num) oscBlock55 vbpBr55.1 vbpBr56.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i56 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00159903):ℝ) ≤ ∫ v in (vBP 1.57)..(vBP 1.59), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.23293569) (m := (0:ℤ)) (ylo := 1.5205467) (yhi := 1.52054671)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.57) (q1 := 1.59) (t0 := 6.75) (t1 := 6.875)
    (A := 0.90214481) (B := 0.92747548) (X := 6.23293569) (rho := 0.14345824)
    (clo := 0.99873771) (chi := 0.99874024) (C := 0.92763973) (h := 0.07236027)
    (by norm_num) (by norm_num) oscBlock56 vbpBr56.1 vbpBr57.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i57 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00146404):ℝ) ≤ ∫ v in (vBP 1.59)..(vBP 1.61), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.40431942) (m := (1:ℤ)) (ylo := 0.12113411) (yhi := 0.12113412)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.59) (q1 := 1.61) (t0 := 6.75) (t1 := 6.875)
    (A := 0.92745939) (B := 0.95247825) (X := 6.40431942) (rho := 0.14396856)
    (clo := 0.99267222) (chi := 0.99267224) (C := 0.92435183) (h := 0.07564817)
    (by norm_num) (by norm_num) oscBlock57 vbpBr57.1 vbpBr58.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i58 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00149216):ℝ) ≤ ∫ v in (vBP 1.61)..(vBP 1.632), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.58200582) (m := (1:ℤ)) (ylo := 0.29882051) (yhi := 0.29882052)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.61) (q1 := 1.632) (t0 := 6.75) (t1 := 6.875)
    (A := 0.95245689) (B := 0.97962584) (X := 6.58200582) (rho := 0.15292184)
    (clo := 0.95568438) (chi := 0.95568439) (C := 0.90138127) (h := 0.09861873)
    (by norm_num) (by norm_num) oscBlock58 vbpBr58.1 vbpBr59.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i59 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00149999):ℝ) ≤ ∫ v in (vBP 1.632)..(vBP 1.656), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.77398728) (m := (1:ℤ)) (ylo := 0.49080197) (yhi := 0.49080198)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.632) (q1 := 1.656) (t0 := 6.75) (t1 := 6.875)
    (A := 0.97959707) (B := 1.00882827) (X := 6.77398728) (rho := 0.16170708)
    (clo := 0.88195514) (chi := 0.88195515) (C := 0.86012403) (h := 0.13987597)
    (by norm_num) (by norm_num) oscBlock59 vbpBr59.1 vbpBr60.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i60 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00126716):ℝ) ≤ ∫ v in (vBP 1.656)..(vBP 1.68), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.97145422) (m := (1:ℤ)) (ylo := 0.68826891) (yhi := 0.68826892)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.656) (q1 := 1.68) (t0 := 6.75) (t1 := 6.875)
    (A := 1.00878907) (B := 1.03761196) (X := 6.97145422) (rho := 0.16212802)
    (clo := 0.77234675) (chi := 0.77234677) (C := 0.77234676) (h := 0.16212803)
    (by norm_num) (by norm_num) oscBlock60 vbpBr60.1 vbpBr61.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i61 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00097937):ℝ) ≤ ∫ v in (vBP 1.68)..(vBP 1.704), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.16610044) (m := (1:ℤ)) (ylo := 0.88291513) (yhi := 0.88291514)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.68) (q1 := 1.704) (t0 := 6.75) (t1 := 6.875)
    (A := 1.03755935) (B := 1.06598913) (X := 7.16610044) (rho := 0.16257484)
    (clo := 0.63490162) (chi := 0.63490172) (C := 0.63490167) (h := 0.16257489)
    (by norm_num) (by norm_num) oscBlock61 vbpBr61.1 vbpBr62.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i62 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00088013):ℝ) ≤ ∫ v in (vBP 1.704)..(vBP 1.734), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.38184533) (m := (1:ℤ)) (ylo := 1.09866002) (yhi := 1.09866003)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.704) (q1 := 1.734) (t0 := 6.75) (t1 := 6.875)
    (A := 1.06591948) (B := 1.10090679) (X := 7.38184533) (rho := 0.18688886)
    (clo := 0.45478989) (chi := 0.45479062) (C := 0.45479025) (h := 0.18688923)
    (by norm_num) (by norm_num) oscBlock62 vbpBr62.1 vbpBr63.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i63 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00054747):ℝ) ≤ ∫ v in (vBP 1.734)..(vBP 1.766), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.62537899) (m := (1:ℤ)) (ylo := 1.34219368) (yhi := 1.34219369)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.734) (q1 := 1.766) (t0 := 6.75) (t1 := 6.875)
    (A := 1.10080961) (B := 1.13749718) (X := 7.62537899) (rho := 0.19491414)
    (clo := 0.22661666) (chi := 0.22662191) (C := 0.22661928) (h := 0.19491677)
    (by norm_num) (by norm_num) oscBlock63 vbpBr63.1 vbpBr64.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i64 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.0002102):ℝ) ≤ ∫ v in (vBP 1.766)..(vBP 1.796), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 7.86462439) (m := (1:ℤ)) (ylo := 0.01064275) (yhi := 0.01064276)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.766) (q1 := 1.796) (t0 := 6.75) (t1 := 6.875)
    (A := 1.1373613) (B := 1.17120873) (X := 7.86462439) (rho := 0.18743564)
    (clo := (-0.01064256)) (chi := (-0.01064254)) (C := (-0.01064255)) (h := 0.18743565)
    (by norm_num) (by norm_num) oscBlock64 vbpBr64.1 vbpBr65.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i65 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00040856):ℝ) ≤ ∫ v in (vBP 1.796)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.09976025) (m := (1:ℤ)) (ylo := 0.24577861) (yhi := 0.24577862)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.796) (q1 := 1.828) (t0 := 6.75) (t1 := 6.875)
    (A := 1.1710258) (B := 1.20655947) (X := 8.09976025) (rho := 0.19533612)
    (clo := (-0.24331162)) (chi := (-0.2433116)) (C := (-0.24331161)) (h := 0.19533613)
    (by norm_num) (by norm_num) oscBlock65 vbpBr65.1 vbpBr66.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i66 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00056502):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.86), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.33829124) (m := (1:ℤ)) (ylo := 0.4843096) (yhi := 0.48430961)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.828) (q1 := 1.86) (t0 := 6.75) (t1 := 6.875)
    (A := 1.20631244) (B := 1.24130524) (X := 8.33829124) (rho := 0.19568229)
    (clo := (-0.46559748)) (chi := (-0.46559746)) (C := (-0.46559747)) (h := 0.1956823)
    (by norm_num) (by norm_num) oscBlock66 vbpBr66.1 vbpBr67.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i67 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00061118):ℝ) ≤ ∫ v in (vBP 1.86)..(vBP 1.89), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.56543725) (m := (1:ℤ)) (ylo := 0.71145561) (yhi := 0.71145562)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.86) (q1 := 1.89) (t0 := 6.75) (t1 := 6.875)
    (A := 1.24097685) (B := 1.27334993) (X := 8.56543725) (rho := 0.18884353)
    (clo := (-0.65293697)) (chi := (-0.65293695)) (C := (-0.65293696)) (h := 0.18884354)
    (by norm_num) (by norm_num) oscBlock67 vbpBr67.1 vbpBr68.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i68 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00072303):ℝ) ≤ ∫ v in (vBP 1.89)..(vBP 1.922), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.78889412) (m := (1:ℤ)) (ylo := 0.93491248) (yhi := 0.93491249)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.89) (q1 := 1.922) (t0 := 6.75) (t1 := 6.875)
    (A := 1.27292668) (B := 1.30698664) (X := 8.78889412) (rho := 0.19663904)
    (clo := (-0.80454713)) (chi := (-0.8045471)) (C := (-0.80395403)) (h := 0.19604597)
    (by norm_num) (by norm_num) oscBlock68 vbpBr68.1 vbpBr69.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i69 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00096743):ℝ) ≤ ∫ v in (vBP 1.922)..(vBP 1.969), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 9.06846876) (m := (1:ℤ)) (ylo := 1.21448712) (yhi := 1.21448713)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.922) (q1 := 1.969) (t0 := 6.75) (t1 := 6.875)
    (A := 1.30643896) (B := 1.35541448) (X := 9.06846876) (rho := 0.2500058)
    (clo := (-0.93719084)) (chi := (-0.93719061)) (C := (-0.84359241)) (h := 0.1564076)
    (by norm_num) (by norm_num) oscBlock69 vbpBr69.1 vbpBr70.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i70 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00087888):ℝ) ≤ ∫ v in (vBP 1.969)..(vBP 2.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 9.39379197) (m := (1:ℤ)) (ylo := 1.53981033) (yhi := 1.53981034)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.969) (q1 := 2.016) (t0 := 6.75) (t1 := 6.875)
    (A := 1.35463226) (B := 1.4027369) (X := 9.39379197) (rho := 0.25002423)
    (clo := (-0.99952282)) (chi := (-0.99951992)) (C := (-0.87474785)) (h := 0.12525216)
    (by norm_num) (by norm_num) oscBlock70 vbpBr70.1 vbpBr71.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i71 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00078634):ℝ) ≤ ∫ v in (vBP 2.016)..(vBP 2.062), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 9.7081912) (m := (1:ℤ)) (ylo := 0.28341323) (yhi := 0.28341324)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.016) (q1 := 2.062) (t0 := 6.75) (t1 := 6.875)
    (A := 1.40164597) (B := 1.44803958) (X := 9.7081912) (rho := 0.24708092)
    (clo := (-0.96010658)) (chi := (-0.96010657)) (C := (-0.85651283)) (h := 0.14348718)
    (by norm_num) (by norm_num) oscBlock71 vbpBr71.1 vbpBr72.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB4i72 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.00051116):ℝ) ≤ ∫ v in (vBP 2.062)..(vBP 2.094), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 9.96617467) (m := (1:ℤ)) (ylo := 0.5413967) (yhi := 0.54139671)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.062) (q1 := 2.094) (t0 := 6.75) (t1 := 6.875)
    (A := 1.44655973) (B := 1.47899217) (X := 9.96617467) (rho := 0.20189651)
    (clo := (-0.85698976)) (chi := (-0.85698974)) (C := (-0.82754662)) (h := 0.17245339)
    (by norm_num) (by norm_num) oscBlock72 vbpBr72.1 vbpBr73.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

/-- Lower bound for the oscillatory integral `∫₀^∞ err(v) cos(tv) dv` on the band
`6.75 ≤ t ≤ 6.875`. -/
theorem oscBandLower4 {t : ℝ} (ht0 : (6.75:ℝ) ≤ t) (ht1 : t ≤ 6.875) :
    ((-0.14984615):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosB4i0 ht0 ht1)
    (cosB4i1 ht0 ht1))
    (cosB4i2 ht0 ht1))
    (cosB4i3 ht0 ht1))
    (cosB4i4 ht0 ht1))
    (cosB4i5 ht0 ht1))
    (cosB4i6 ht0 ht1))
    (cosB4i7 ht0 ht1))
    (cosB4i8 ht0 ht1))
    (cosB4i9 ht0 ht1))
    (cosB4i10 ht0 ht1))
    (cosB4i11 ht0 ht1))
    (cosB4i12 ht0 ht1))
    (cosB4i13 ht0 ht1))
    (cosB4i14 ht0 ht1))
    (cosB4i15 ht0 ht1))
    (cosB4i16 ht0 ht1))
    (cosB4i17 ht0 ht1))
    (cosB4i18 ht0 ht1))
    (cosB4i19 ht0 ht1))
    (cosB4i20 ht0 ht1))
    (cosB4i21 ht0 ht1))
    (cosB4i22 ht0 ht1))
    (cosB4i23 ht0 ht1))
    (cosB4i24 ht0 ht1))
    (cosB4i25 ht0 ht1))
    (cosB4i26 ht0 ht1))
    (cosB4i27 ht0 ht1))
    (cosB4i28 ht0 ht1))
    (cosB4i29 ht0 ht1))
    (cosB4i30 ht0 ht1))
    (cosB4i31 ht0 ht1))
    (cosB4i32 ht0 ht1))
    (cosB4i33 ht0 ht1))
    (cosB4i34 ht0 ht1))
    (cosB4i35 ht0 ht1))
    (cosB4i36 ht0 ht1))
    (cosB4i37 ht0 ht1))
    (cosB4i38 ht0 ht1))
    (cosB4i39 ht0 ht1))
    (cosB4i40 ht0 ht1))
    (cosB4i41 ht0 ht1))
    (cosB4i42 ht0 ht1))
    (cosB4i43 ht0 ht1))
    (cosB4i44 ht0 ht1))
    (cosB4i45 ht0 ht1))
    (cosB4i46 ht0 ht1))
    (cosB4i47 ht0 ht1))
    (cosB4i48 ht0 ht1))
    (cosB4i49 ht0 ht1))
    (cosB4i50 ht0 ht1))
    (cosB4i51 ht0 ht1))
    (cosB4i52 ht0 ht1))
    (cosB4i53 ht0 ht1))
    (cosB4i54 ht0 ht1))
    (cosB4i55 ht0 ht1))
    (cosB4i56 ht0 ht1))
    (cosB4i57 ht0 ht1))
    (cosB4i58 ht0 ht1))
    (cosB4i59 ht0 ht1))
    (cosB4i60 ht0 ht1))
    (cosB4i61 ht0 ht1))
    (cosB4i62 ht0 ht1))
    (cosB4i63 ht0 ht1))
    (cosB4i64 ht0 ht1))
    (cosB4i65 ht0 ht1))
    (cosB4i66 ht0 ht1))
    (cosB4i67 ht0 ht1))
    (cosB4i68 ht0 ht1))
    (cosB4i69 ht0 ht1))
    (cosB4i70 ht0 ht1))
    (cosB4i71 ht0 ht1))
    (cosB4i72 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 2.094) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 2.094) (S := 0.013709)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_cut
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
