/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscTail

/-!
# Oscillatory lower bound on the band `6.875 ≤ t ≤ 7.0`

On each of the 73 blocks the factor `cos(tv)` is bracketed by a rational constant
`C` up to a rational error `h`; the signed contribution `min(C·P₀, C·P₁) - h·S` is
then summed, and the unresolved tail beyond `q = 2.094` is estimated in absolute
value.  The result is the bound `∫₀^∞ err(v) cos(tv) dv ≥ -0.15294708`.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosB3i0 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00641868):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.0038), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.0265496) (m := (0:ℤ)) (ylo := 0.0265496) (yhi := 0.0265496)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1) (q1 := 1.0038) (t0 := 6.875) (t1 := 7)
    (A := 0.0) (B := 0.0075856) (X := 0.0265496) (rho := 0.02654961)
    (clo := 0.99964758) (chi := 0.99964759) (C := 0.98654898) (h := 0.01345102)
    (by norm_num) (by norm_num) oscBlock0 vbpBr0.1 vbpBr1.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i1 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00625872):ℝ) ≤ ∫ v in (vBP 1.0038)..(vBP 1.0078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.08046364) (m := (0:ℤ)) (ylo := 0.08046364) (yhi := 0.08046364)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0038) (q1 := 1.0078) (t0 := 6.875) (t1 := 7)
    (A := 0.00758559) (B := 0.01553948) (X := 0.08046364) (rho := 0.02831273)
    (clo := 0.99676454) (chi := 0.99676455) (C := 0.9842259) (h := 0.0157741)
    (by norm_num) (by norm_num) oscBlock1 vbpBr1.1 vbpBr2.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i2 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.0057677):ℝ) ≤ ∫ v in (vBP 1.0078)..(vBP 1.0118), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.1355334) (m := (0:ℤ)) (ylo := 0.1355334) (yhi := 0.1355334)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0078) (q1 := 1.0118) (t0 := 6.875) (t1 := 7)
    (A := 0.01553947) (B := 0.02346185) (X := 0.1355334) (rho := 0.02869956)
    (clo := 0.99082939) (chi := 0.9908294) (C := 0.98106491) (h := 0.01893509)
    (by norm_num) (by norm_num) oscBlock2 vbpBr2.1 vbpBr3.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i3 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00554846):ℝ) ≤ ∫ v in (vBP 1.0118)..(vBP 1.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.19176352) (m := (0:ℤ)) (ylo := 0.19176352) (yhi := 0.19176352)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0118) (q1 := 1.016) (t0 := 6.875) (t1 := 7)
    (A := 0.02346184) (B := 0.0317467) (X := 0.19176352) (rho := 0.03046339)
    (clo := 0.98166965) (chi := 0.98166966) (C := 0.97560313) (h := 0.02439687)
    (by norm_num) (by norm_num) oscBlock3 vbpBr3.1 vbpBr4.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i4 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00539232):ℝ) ≤ ∫ v in (vBP 1.016)..(vBP 1.0205), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.25117818) (m := (0:ℤ)) (ylo := 0.25117818) (yhi := 0.25117818)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.016) (q1 := 1.0205) (t0 := 6.875) (t1 := 7)
    (A := 0.03174669) (B := 0.04058541) (X := 0.25117818) (rho := 0.0329197)
    (clo := 0.96862026) (chi := 0.96862027) (C := 0.96785028) (h := 0.03214972)
    (by norm_num) (by norm_num) oscBlock4 vbpBr4.1 vbpBr5.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i5 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00477794):ℝ) ≤ ∫ v in (vBP 1.0205)..(vBP 1.025), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.31236061) (m := (0:ℤ)) (ylo := 0.31236061) (yhi := 0.31236061)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0205) (q1 := 1.025) (t0 := 6.875) (t1 := 7)
    (A := 0.0405854) (B := 0.04938523) (X := 0.31236061) (rho := 0.03333601)
    (clo := 0.95161079) (chi := 0.9516108) (C := 0.95161079) (h := 0.03333602)
    (by norm_num) (by norm_num) oscBlock5 vbpBr5.1 vbpBr6.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i6 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00463295):ℝ) ≤ ∫ v in (vBP 1.025)..(vBP 1.03), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.37667332) (m := (0:ℤ)) (ylo := 0.37667332) (yhi := 0.37667332)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.025) (q1 := 1.03) (t0 := 6.875) (t1 := 7)
    (A := 0.04938522) (B := 0.05911761) (X := 0.37667332) (rho := 0.03714996)
    (clo := 0.92989342) (chi := 0.92989343) (C := 0.92989342) (h := 0.03714997)
    (by norm_num) (by norm_num) oscBlock6 vbpBr6.1 vbpBr7.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i7 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00430464):ℝ) ≤ ∫ v in (vBP 1.03)..(vBP 1.0355), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.44740758) (m := (0:ℤ)) (ylo := 0.44740758) (yhi := 0.44740758)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.03) (q1 := 1.0355) (t0 := 6.875) (t1 := 7)
    (A := 0.0591176) (B := 0.06976881) (X := 0.44740758) (rho := 0.0409741)
    (clo := 0.90157168) (chi := 0.90157169) (C := 0.90157168) (h := 0.04097411)
    (by norm_num) (by norm_num) oscBlock7 vbpBr7.1 vbpBr8.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i8 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00381645):ℝ) ≤ ∫ v in (vBP 1.0355)..(vBP 1.0415), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.52446414) (m := (0:ℤ)) (ylo := 0.52446414) (yhi := 0.52446414)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0355) (q1 := 1.0415) (t0 := 6.875) (t1 := 7)
    (A := 0.0697688) (B := 0.08132397) (X := 0.52446414) (rho := 0.04480366)
    (clo := 0.86559239) (chi := 0.8655924) (C := 0.86559239) (h := 0.04480367)
    (by norm_num) (by norm_num) oscBlock8 vbpBr8.1 vbpBr9.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i9 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00319936):ℝ) ≤ ∫ v in (vBP 1.0415)..(vBP 1.048), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.60773624) (m := (0:ℤ)) (ylo := 0.60773624) (yhi := 0.60773624)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0415) (q1 := 1.048) (t0 := 6.875) (t1 := 7)
    (A := 0.08132396) (B := 0.09376718) (X := 0.60773624) (rho := 0.04863403)
    (clo := 0.82094275) (chi := 0.82094276) (C := 0.82094275) (h := 0.04863404)
    (by norm_num) (by norm_num) oscBlock9 vbpBr9.1 vbpBr10.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i10 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00251074):ℝ) ≤ ∫ v in (vBP 1.048)..(vBP 1.055), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.69711003) (m := (0:ℤ)) (ylo := 0.69711003) (yhi := 0.69711003)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.048) (q1 := 1.055) (t0 := 6.875) (t1 := 7)
    (A := 0.09376717) (B := 0.10708154) (X := 0.69711003) (rho := 0.05246076)
    (clo := 0.76670076) (chi := 0.76670077) (C := 0.76670076) (h := 0.05246077)
    (by norm_num) (by norm_num) oscBlock10 vbpBr10.1 vbpBr11.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i11 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00202966):ℝ) ≤ ∫ v in (vBP 1.055)..(vBP 1.064), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.80234052) (m := (0:ℤ)) (ylo := 0.80234052) (yhi := 0.80234052)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.055) (q1 := 1.064) (t0 := 6.875) (t1 := 7)
    (A := 0.10708153) (B := 0.12407079) (X := 0.80234052) (rho := 0.06615502)
    (clo := 0.69502581) (chi := 0.69502585) (C := 0.69502583) (h := 0.06615504)
    (by norm_num) (by norm_num) oscBlock11 vbpBr11.1 vbpBr12.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i12 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00126331):ℝ) ≤ ∫ v in (vBP 1.064)..(vBP 1.078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.95224563) (m := (0:ℤ)) (ylo := 0.95224563) (yhi := 0.95224563)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.064) (q1 := 1.078) (t0 := 6.875) (t1 := 7)
    (A := 0.12407078) (B := 0.15021495) (X := 0.95224563) (rho := 0.09925903)
    (clo := 0.57985499) (chi := 0.57985517) (C := 0.57985508) (h := 0.09925912)
    (by norm_num) (by norm_num) oscBlock12 vbpBr12.1 vbpBr13.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i13 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    (0.00007268:ℝ) ≤ ∫ v in (vBP 1.078)..(vBP 1.09), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.11960775) (m := (0:ℤ)) (ylo := 1.11960775) (yhi := 1.11960775)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.078) (q1 := 1.09) (t0 := 6.875) (t1 := 7)
    (A := 0.15021494) (B := 0.1723554) (X := 1.11960775) (rho := 0.08688006)
    (clo := 0.43603546) (chi := 0.43603633) (C := 0.43603589) (h := 0.0868805)
    (by norm_num) (by norm_num) oscBlock13 vbpBr13.1 vbpBr14.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i14 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    (0.00035563:ℝ) ≤ ∫ v in (vBP 1.09)..(vBP 1.1), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.25964291) (m := (0:ℤ)) (ylo := 1.25964291) (yhi := 1.25964291)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.09) (q1 := 1.1) (t0 := 6.875) (t1 := 7)
    (A := 0.17235539) (B := 0.19062036) (X := 1.25964291) (rho := 0.07469962)
    (clo := 0.30615683) (chi := 0.30615961) (C := 0.30615822) (h := 0.07470101)
    (by norm_num) (by norm_num) oscBlock14 vbpBr14.1 vbpBr15.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i15 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    (0.00025343:ℝ) ≤ ∫ v in (vBP 1.1)..(vBP 1.109), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.37946842) (m := (0:ℤ)) (ylo := 1.37946842) (yhi := 1.37946842)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.1) (q1 := 1.109) (t0 := 6.875) (t1 := 7)
    (A := 0.19062035) (B := 0.20691742) (X := 1.37946842) (rho := 0.06895353)
    (clo := 0.19016264) (chi := 0.19016952) (C := 0.19016608) (h := 0.06895697)
    (by norm_num) (by norm_num) oscBlock15 vbpBr15.1 vbpBr16.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i16 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    (0.00002417:ℝ) ≤ ∫ v in (vBP 1.109)..(vBP 1.117), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.48580427) (m := (0:ℤ)) (ylo := 1.48580427) (yhi := 1.48580427)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.109) (q1 := 1.117) (t0 := 6.875) (t1 := 7)
    (A := 0.20691741) (B := 0.22129305) (X := 1.48580427) (rho := 0.06324709)
    (clo := 0.08488952) (chi := 0.08490398) (C := 0.08489675) (h := 0.06325432)
    (by norm_num) (by norm_num) oscBlock16 vbpBr16.1 vbpBr17.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i17 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00020696):ℝ) ≤ ∫ v in (vBP 1.117)..(vBP 1.124), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.57895111) (m := (0:ℤ)) (ylo := 0.00815478) (yhi := 0.00815479)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.117) (q1 := 1.124) (t0 := 6.875) (t1 := 7)
    (A := 0.22129304) (B := 0.23378751) (X := 1.57895111) (rho := 0.05756147)
    (clo := (-0.0081547)) (chi := (-0.00815468)) (C := (-0.00815469)) (h := 0.05756148)
    (by norm_num) (by norm_num) oscBlock17 vbpBr17.1 vbpBr18.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i18 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00051855):ℝ) ≤ ∫ v in (vBP 1.124)..(vBP 1.131), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.66535993) (m := (0:ℤ)) (ylo := 0.0945636) (yhi := 0.09456361)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.124) (q1 := 1.131) (t0 := 6.875) (t1 := 7)
    (A := 0.2337875) (B := 0.2462044) (X := 1.66535993) (rho := 0.05807088)
    (clo := (-0.09442274)) (chi := (-0.09442272)) (C := (-0.09442273)) (h := 0.05807089)
    (by norm_num) (by norm_num) oscBlock18 vbpBr18.1 vbpBr19.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i19 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00085755):ℝ) ≤ ∫ v in (vBP 1.131)..(vBP 1.138), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.75123397) (m := (0:ℤ)) (ylo := 0.18043764) (yhi := 0.18043765)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.131) (q1 := 1.138) (t0 := 6.875) (t1 := 7)
    (A := 0.24620439) (B := 0.25854468) (X := 1.75123397) (rho := 0.0585788)
    (clo := (-0.17946014)) (chi := (-0.17946012)) (C := (-0.17946013)) (h := 0.05857881)
    (by norm_num) (by norm_num) oscBlock19 vbpBr19.1 vbpBr20.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i20 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00119807):ℝ) ≤ ∫ v in (vBP 1.138)..(vBP 1.145), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.83657978) (m := (0:ℤ)) (ylo := 0.26578345) (yhi := 0.26578346)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.138) (q1 := 1.145) (t0 := 6.875) (t1 := 7)
    (A := 0.25854467) (B := 0.27080928) (X := 1.83657978) (rho := 0.05908519)
    (clo := (-0.2626653)) (chi := (-0.26266528)) (C := (-0.26266529)) (h := 0.0590852)
    (by norm_num) (by norm_num) oscBlock20 vbpBr20.1 vbpBr21.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i21 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00154379):ℝ) ≤ ∫ v in (vBP 1.145)..(vBP 1.152), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.92140382) (m := (0:ℤ)) (ylo := 0.35060749) (yhi := 0.3506075)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.145) (q1 := 1.152) (t0 := 6.875) (t1 := 7)
    (A := 0.27080927) (B := 0.28299913) (X := 1.92140382) (rho := 0.0595901)
    (clo := (-0.34346842)) (chi := (-0.3434684)) (C := (-0.34346841)) (h := 0.05959011)
    (by norm_num) (by norm_num) oscBlock21 vbpBr21.1 vbpBr22.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i22 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00187838):ℝ) ≤ ∫ v in (vBP 1.152)..(vBP 1.159), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.00571243) (m := (0:ℤ)) (ylo := 0.4349161) (yhi := 0.43491611)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.152) (q1 := 1.159) (t0 := 6.875) (t1 := 7)
    (A := 0.28299912) (B := 0.29511513) (X := 2.00571243) (rho := 0.06009349)
    (clo := (-0.42133433)) (chi := (-0.42133431)) (C := (-0.42133432)) (h := 0.0600935)
    (by norm_num) (by norm_num) oscBlock22 vbpBr22.1 vbpBr23.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i23 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00218927):ℝ) ≤ ∫ v in (vBP 1.159)..(vBP 1.166), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.08951185) (m := (0:ℤ)) (ylo := 0.51871552) (yhi := 0.51871553)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.159) (q1 := 1.166) (t0 := 6.875) (t1 := 7)
    (A := 0.29511512) (B := 0.30715818) (X := 2.08951185) (rho := 0.06059542)
    (clo := (-0.49576505)) (chi := (-0.49576503)) (C := (-0.49576504)) (h := 0.06059543)
    (by norm_num) (by norm_num) oscBlock23 vbpBr23.1 vbpBr24.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i24 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00246742):ℝ) ≤ ∫ v in (vBP 1.166)..(vBP 1.173), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.17280819) (m := (0:ℤ)) (ylo := 0.60201186) (yhi := 0.60201187)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.166) (q1 := 1.173) (t0 := 6.875) (t1 := 7)
    (A := 0.30715817) (B := 0.31912914) (X := 2.17280819) (rho := 0.0610958)
    (clo := (-0.5663018)) (chi := (-0.56630178)) (C := (-0.56630179)) (h := 0.06109581)
    (by norm_num) (by norm_num) oscBlock24 vbpBr24.1 vbpBr25.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i25 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00270557):ℝ) ≤ ∫ v in (vBP 1.173)..(vBP 1.18), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.25560746) (m := (0:ℤ)) (ylo := 0.68481113) (yhi := 0.68481114)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.173) (q1 := 1.18) (t0 := 6.875) (t1 := 7)
    (A := 0.31912913) (B := 0.33102888) (X := 2.25560746) (rho := 0.06159471)
    (clo := (-0.63252675)) (chi := (-0.63252673)) (C := (-0.63252674)) (h := 0.06159472)
    (by norm_num) (by norm_num) oscBlock25 vbpBr25.1 vbpBr26.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i26 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00289818):ℝ) ≤ ∫ v in (vBP 1.18)..(vBP 1.187), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.33791558) (m := (0:ℤ)) (ylo := 0.76711925) (yhi := 0.76711926)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.18) (q1 := 1.187) (t0 := 6.875) (t1 := 7)
    (A := 0.33102887) (B := 0.34285824) (X := 2.33791558) (rho := 0.06209211)
    (clo := (-0.69406425)) (chi := (-0.69406423)) (C := (-0.69406424)) (h := 0.06209212)
    (by norm_num) (by norm_num) oscBlock26 vbpBr26.1 vbpBr27.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i27 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00304154):ℝ) ≤ ∫ v in (vBP 1.187)..(vBP 1.194), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.4197383) (m := (0:ℤ)) (ylo := 0.84894197) (yhi := 0.84894198)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.187) (q1 := 1.194) (t0 := 6.875) (t1 := 7)
    (A := 0.34285823) (B := 0.35461804) (X := 2.4197383) (rho := 0.06258799)
    (clo := (-0.75058172)) (chi := (-0.7505817)) (C := (-0.75058171)) (h := 0.062588)
    (by norm_num) (by norm_num) oscBlock27 vbpBr27.1 vbpBr28.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i28 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00316578):ℝ) ≤ ∫ v in (vBP 1.194)..(vBP 1.201), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.50108125) (m := (0:ℤ)) (ylo := 0.93028492) (yhi := 0.93028493)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.194) (q1 := 1.201) (t0 := 6.875) (t1 := 7)
    (A := 0.35461802) (B := 0.36630909) (X := 2.50108125) (rho := 0.06308239)
    (clo := (-0.80179027)) (chi := (-0.80179024)) (C := (-0.80179026)) (h := 0.06308241)
    (by norm_num) (by norm_num) oscBlock28 vbpBr28.1 vbpBr29.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i29 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00320734):ℝ) ≤ ∫ v in (vBP 1.201)..(vBP 1.208), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.58195016) (m := (0:ℤ)) (ylo := 1.01115383) (yhi := 1.01115384)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.201) (q1 := 1.208) (t0 := 6.875) (t1 := 7)
    (A := 0.36630908) (B := 0.3779322) (X := 2.58195016) (rho := 0.06357525)
    (clo := (-0.847445)) (chi := (-0.84744495)) (C := (-0.84744498)) (h := 0.06357528)
    (by norm_num) (by norm_num) oscBlock29 vbpBr29.1 vbpBr30.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i30 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00319799):ℝ) ≤ ∫ v in (vBP 1.208)..(vBP 1.215), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.66235046) (m := (0:ℤ)) (ylo := 1.09155413) (yhi := 1.09155414)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.208) (q1 := 1.215) (t0 := 6.875) (t1 := 7)
    (A := 0.37793219) (B := 0.38948816) (X := 2.66235046) (rho := 0.06406667)
    (clo := (-0.88734468)) (chi := (-0.8873446)) (C := (-0.88734464)) (h := 0.06406671)
    (by norm_num) (by norm_num) oscBlock30 vbpBr30.1 vbpBr31.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i31 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00360248):ℝ) ≤ ∫ v in (vBP 1.215)..(vBP 1.223), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.74801353) (m := (0:ℤ)) (ylo := 1.1772172) (yhi := 1.17721721)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.215) (q1 := 1.223) (t0 := 6.875) (t1 := 7)
    (A := 0.38948815) (B := 0.40261372) (X := 2.74801353) (rho := 0.07028252)
    (clo := (-0.92354255)) (chi := (-0.92354239)) (C := (-0.92354247)) (h := 0.0702826)
    (by norm_num) (by norm_num) oscBlock31 vbpBr31.1 vbpBr32.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i32 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00337361):ℝ) ≤ ∫ v in (vBP 1.223)..(vBP 1.231), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.83877257) (m := (0:ℤ)) (ylo := 1.26797624) (yhi := 1.26797625)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.223) (q1 := 1.231) (t0 := 6.875) (t1 := 7)
    (A := 0.40261371) (B := 0.4156537) (X := 2.83877257) (rho := 0.07080334)
    (clo := (-0.95449964)) (chi := (-0.95449929)) (C := (-0.94184798)) (h := 0.05815203)
    (by norm_num) (by norm_num) oscBlock32 vbpBr32.1 vbpBr33.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i33 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00310538):ℝ) ≤ ∫ v in (vBP 1.231)..(vBP 1.239), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.92894179) (m := (0:ℤ)) (ylo := 1.35814546) (yhi := 1.35814547)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.231) (q1 := 1.239) (t0 := 6.875) (t1 := 7)
    (A := 0.41565369) (B := 0.42860921) (X := 2.92894179) (rho := 0.07132269)
    (clo := (-0.9774756)) (chi := (-0.97747487)) (C := (-0.95307609)) (h := 0.04692391)
    (by norm_num) (by norm_num) oscBlock33 vbpBr33.1 vbpBr34.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i34 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00315711):ℝ) ≤ ∫ v in (vBP 1.239)..(vBP 1.248), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.02414005) (m := (0:ℤ)) (ylo := 1.45334372) (yhi := 1.45334373)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.239) (q1 := 1.248) (t0 := 6.875) (t1 := 7)
    (A := 0.4286092) (B := 0.44308455) (X := 3.02414005) (rho := 0.07745181)
    (clo := (-0.99311188)) (chi := (-0.99311034)) (C := (-0.95782927)) (h := 0.04217074)
    (by norm_num) (by norm_num) oscBlock34 vbpBr34.1 vbpBr35.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i35 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00307603):ℝ) ≤ ∫ v in (vBP 1.248)..(vBP 1.258), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.12976519) (m := (0:ℤ)) (ylo := 1.55896886) (yhi := 1.55896887)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.248) (q1 := 1.258) (t0 := 6.875) (t1 := 7)
    (A := 0.44308453) (B := 0.45904632) (X := 3.12976519) (rho := 0.08355906)
    (clo := (-0.99993332)) (chi := (-0.99993)) (C := (-0.95818547)) (h := 0.04181453)
    (by norm_num) (by norm_num) oscBlock35 vbpBr35.1 vbpBr36.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i36 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00264809):ℝ) ≤ ∫ v in (vBP 1.258)..(vBP 1.268), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.24005771) (m := (0:ℤ)) (ylo := 0.09846505) (yhi := 0.09846506)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.258) (q1 := 1.268) (t0 := 6.875) (t1 := 7)
    (A := 0.45904631) (B := 0.47488172) (X := 3.24005771) (rho := 0.08411434)
    (clo := (-0.99515624)) (chi := (-0.99515623)) (C := (-0.95552095)) (h := 0.04447906)
    (by norm_num) (by norm_num) oscBlock36 vbpBr36.1 vbpBr37.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i37 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00261049):ℝ) ≤ ∫ v in (vBP 1.268)..(vBP 1.28), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.36042643) (m := (0:ℤ)) (ylo := 0.21883377) (yhi := 0.21883378)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.268) (q1 := 1.28) (t0 := 6.875) (t1 := 7)
    (A := 0.4748817) (B := 0.49372017) (X := 3.36042643) (rho := 0.09561477)
    (clo := (-0.9761513)) (chi := (-0.97615128)) (C := (-0.94026826)) (h := 0.05973175)
    (by norm_num) (by norm_num) oscBlock37 vbpBr37.1 vbpBr38.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i38 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.0022862):ℝ) ≤ ∫ v in (vBP 1.28)..(vBP 1.294), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.50133041) (m := (0:ℤ)) (ylo := 0.35973775) (yhi := 0.35973776)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.28) (q1 := 1.294) (t0 := 6.875) (t1 := 7)
    (A := 0.49372014) (B := 0.51547641) (X := 3.50133041) (rho := 0.10700447)
    (clo := (-0.93598918)) (chi := (-0.93598917)) (C := (-0.91449235)) (h := 0.08550765)
    (by norm_num) (by norm_num) oscBlock38 vbpBr38.1 vbpBr39.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i39 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00149768):ℝ) ≤ ∫ v in (vBP 1.294)..(vBP 1.308), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.65144491) (m := (0:ℤ)) (ylo := 0.50985225) (yhi := 0.50985226)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.294) (q1 := 1.308) (t0 := 6.875) (t1 := 7)
    (A := 0.51547638) (B := 0.53699853) (X := 3.65144491) (rho := 0.10754481)
    (clo := (-0.87281663)) (chi := (-0.87281662)) (C := (-0.87281663)) (h := 0.10754482)
    (by norm_num) (by norm_num) oscBlock39 vbpBr39.1 vbpBr40.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i40 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00091082):ℝ) ≤ ∫ v in (vBP 1.308)..(vBP 1.326), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.82110064) (m := (0:ℤ)) (ylo := 0.67950798) (yhi := 0.67950799)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.308) (q1 := 1.326) (t0 := 6.875) (t1 := 7)
    (A := 0.53699848) (B := 0.56433382) (X := 3.82110064) (rho := 0.12923611)
    (clo := (-0.77788201)) (chi := (-0.77788199)) (C := (-0.777882)) (h := 0.12923612)
    (by norm_num) (by norm_num) oscBlock40 vbpBr40.1 vbpBr41.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i41 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00015131):ℝ) ≤ ∫ v in (vBP 1.326)..(vBP 1.345), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.01465551) (m := (0:ℤ)) (ylo := 0.87306285) (yhi := 0.87306286)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.326) (q1 := 1.345) (t0 := 6.875) (t1 := 7)
    (A := 0.56433374) (B := 0.59278808) (X := 4.01465551) (rho := 0.13486106)
    (clo := (-0.64248258)) (chi := (-0.64248249)) (C := (-0.64248254)) (h := 0.13486111)
    (by norm_num) (by norm_num) oscBlock41 vbpBr41.1 vbpBr42.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i42 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    (0.00029216:ℝ) ≤ ∫ v in (vBP 1.345)..(vBP 1.362), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.20038836) (m := (0:ℤ)) (ylo := 1.0587957) (yhi := 1.05879571)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.345) (q1 := 1.362) (t0 := 6.875) (t1 := 7)
    (A := 0.59278796) (B := 0.6179085) (X := 4.20038836) (rho := 0.12497115)
    (clo := (-0.48992279)) (chi := (-0.48992229)) (C := (-0.48992254)) (h := 0.1249714)
    (by norm_num) (by norm_num) oscBlock42 vbpBr42.1 vbpBr43.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i43 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    (0.0002373:ℝ) ≤ ∫ v in (vBP 1.362)..(vBP 1.376), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.35832541) (m := (0:ℤ)) (ylo := 1.21673275) (yhi := 1.21673276)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.362) (q1 := 1.376) (t0 := 6.875) (t1 := 7)
    (A := 0.61790831) (B := 0.6383616) (X := 4.35832541) (rho := 0.1102058)
    (clo := (-0.34671412)) (chi := (-0.34671214)) (C := (-0.34671313)) (h := 0.11020679)
    (by norm_num) (by norm_num) oscBlock43 vbpBr43.1 vbpBr44.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i44 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    (0.00008631:ℝ) ≤ ∫ v in (vBP 1.376)..(vBP 1.39), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.49949391) (m := (0:ℤ)) (ylo := 1.35790125) (yhi := 1.35790126)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.376) (q1 := 1.39) (t0 := 6.875) (t1 := 7)
    (A := 0.63836133) (B := 0.65860767) (X := 4.49949391) (rho := 0.11075979)
    (clo := (-0.21129629)) (chi := (-0.2112904)) (C := (-0.21129335)) (h := 0.11076274)
    (by norm_num) (by norm_num) oscBlock44 vbpBr44.1 vbpBr45.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i45 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00012857):ℝ) ≤ ∫ v in (vBP 1.39)..(vBP 1.404), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.63924056) (m := (0:ℤ)) (ylo := 1.4976479) (yhi := 1.49764791)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.39) (q1 := 1.404) (t0 := 6.875) (t1 := 7)
    (A := 0.65860729) (B := 0.67865086) (X := 4.63924056) (rho := 0.11131547)
    (clo := (-0.0730986)) (chi := (-0.07308293)) (C := (-0.07309077)) (h := 0.11132331)
    (by norm_num) (by norm_num) oscBlock45 vbpBr45.1 vbpBr46.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i46 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00039544):ℝ) ≤ ∫ v in (vBP 1.404)..(vBP 1.418), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.77759367) (m := (0:ℤ)) (ylo := 0.06520468) (yhi := 0.06520469)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.404) (q1 := 1.418) (t0 := 6.875) (t1 := 7)
    (A := 0.67865033) (B := 0.69849519) (X := 4.77759367) (rho := 0.11187267)
    (clo := 0.06515848) (chi := 0.0651585) (C := 0.06515849) (h := 0.11187268)
    (by norm_num) (by norm_num) oscBlock46 vbpBr46.1 vbpBr47.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i47 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00067569):ℝ) ≤ ∫ v in (vBP 1.418)..(vBP 1.432), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.9145808) (m := (0:ℤ)) (ylo := 0.20219181) (yhi := 0.20219182)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.418) (q1 := 1.432) (t0 := 6.875) (t1 := 7)
    (A := 0.69849446) (B := 0.7181446) (X := 4.9145808) (rho := 0.11243141)
    (clo := 0.20081697) (chi := 0.20081699) (C := 0.20081698) (h := 0.11243142)
    (by norm_num) (by norm_num) oscBlock47 vbpBr47.1 vbpBr48.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i48 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00090646):ℝ) ≤ ∫ v in (vBP 1.432)..(vBP 1.446), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.05022863) (m := (0:ℤ)) (ylo := 0.33783964) (yhi := 0.33783965)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.432) (q1 := 1.446) (t0 := 6.875) (t1 := 7)
    (A := 0.7181436) (B := 0.73760286) (X := 5.05022863) (rho := 0.1129914)
    (clo := 0.33144962) (chi := 0.33144964) (C := 0.33144963) (h := 0.11299141)
    (by norm_num) (by norm_num) oscBlock48 vbpBr48.1 vbpBr49.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i49 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.0012824):ℝ) ≤ ∫ v in (vBP 1.446)..(vBP 1.462), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.19414578) (m := (0:ℤ)) (ylo := 0.48175679) (yhi := 0.4817568)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.446) (q1 := 1.462) (t0 := 6.875) (t1 := 7)
    (A := 0.73760153) (B := 0.75961158) (X := 5.19414578) (rho := 0.12313529)
    (clo := 0.46333672) (chi := 0.46333674) (C := 0.46333673) (h := 0.1231353)
    (by norm_num) (by norm_num) oscBlock49 vbpBr49.1 vbpBr50.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i50 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00150235):ℝ) ≤ ∫ v in (vBP 1.462)..(vBP 1.478), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.34599128) (m := (0:ℤ)) (ylo := 0.63360229) (yhi := 0.6336023)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.462) (q1 := 1.478) (t0 := 6.875) (t1 := 7)
    (A := 0.75960973) (B := 0.78138081) (X := 5.34599128) (rho := 0.1236744)
    (clo := 0.59205167) (chi := 0.59205169) (C := 0.59205168) (h := 0.12367441)
    (by norm_num) (by norm_num) oscBlock50 vbpBr50.1 vbpBr51.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i51 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00173693):ℝ) ≤ ∫ v in (vBP 1.478)..(vBP 1.495), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.50087694) (m := (0:ℤ)) (ylo := 0.78848795) (yhi := 0.78848796)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.478) (q1 := 1.495) (t0 := 6.875) (t1 := 7)
    (A := 0.7813783) (B := 0.80425401) (X := 5.50087694) (rho := 0.12890114)
    (clo := 0.70928821) (chi := 0.70928823) (C := 0.70928822) (h := 0.12890115)
    (by norm_num) (by norm_num) oscBlock51 vbpBr51.1 vbpBr52.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i52 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00180731):ℝ) ≤ ∫ v in (vBP 1.495)..(vBP 1.512), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.65865182) (m := (0:ℤ)) (ylo := 0.94626283) (yhi := 0.94626284)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.495) (q1 := 1.512) (t0 := 6.875) (t1 := 7)
    (A := 0.80425056) (B := 0.82686872) (X := 5.65865182) (rho := 0.12942923)
    (clo := 0.81123598) (chi := 0.81123601) (C := 0.81123599) (h := 0.12942925)
    (by norm_num) (by norm_num) oscBlock52 vbpBr52.1 vbpBr53.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i53 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00197876):ℝ) ≤ ∫ v in (vBP 1.512)..(vBP 1.531), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.82380344) (m := (0:ℤ)) (ylo := 1.11141445) (yhi := 1.11141446)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.512) (q1 := 1.531) (t0 := 6.875) (t1 := 7)
    (A := 0.82686405) (B := 0.85184522) (X := 5.82380344) (rho := 0.13911311)
    (clo := 0.89632674) (chi := 0.89632683) (C := 0.87860681) (h := 0.12139319)
    (by norm_num) (by norm_num) oscBlock53 vbpBr53.1 vbpBr54.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i54 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.0018127):ℝ) ≤ ∫ v in (vBP 1.531)..(vBP 1.55), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.99599452) (m := (0:ℤ)) (ylo := 1.28360553) (yhi := 1.28360554)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.531) (q1 := 1.55) (t0 := 6.875) (t1 := 7)
    (A := 0.85183877) (B := 0.87651393) (X := 5.99599452) (rho := 0.139603)
    (clo := 0.95904338) (chi := 0.95904379) (C := 0.90972019) (h := 0.09027981)
    (by norm_num) (by norm_num) oscBlock54 vbpBr54.1 vbpBr55.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i55 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00174878):ℝ) ≤ ∫ v in (vBP 1.55)..(vBP 1.57), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.17053518) (m := (0:ℤ)) (ylo := 1.45814619) (yhi := 1.4581462)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.55) (q1 := 1.57) (t0 := 6.875) (t1 := 7)
    (A := 0.87650515) (B := 0.90215678) (X := 6.17053518) (rho := 0.14456229)
    (clo := 0.99366165) (chi := 0.99366325) (C := 0.92454968) (h := 0.07545032)
    (by norm_num) (by norm_num) oscBlock55 vbpBr55.1 vbpBr56.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i56 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00159903):ℝ) ≤ ∫ v in (vBP 1.57)..(vBP 1.59), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.34728696) (m := (1:ℤ)) (ylo := 0.06410165) (yhi := 0.06410166)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.57) (q1 := 1.59) (t0 := 6.875) (t1 := 7)
    (A := 0.90214481) (B := 0.92747548) (X := 6.34728696) (rho := 0.14504141)
    (clo := 0.99794619) (chi := 0.9979462) (C := 0.92645239) (h := 0.07354761)
    (by norm_num) (by norm_num) oscBlock56 vbpBr56.1 vbpBr57.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i57 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00146404):ℝ) ≤ ∫ v in (vBP 1.59)..(vBP 1.61), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.52181552) (m := (1:ℤ)) (ylo := 0.23863021) (yhi := 0.23863022)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.59) (q1 := 1.61) (t0 := 6.875) (t1 := 7)
    (A := 0.92745939) (B := 0.95247825) (X := 6.52181552) (rho := 0.14553224)
    (clo := 0.97166266) (chi := 0.97166267) (C := 0.91306521) (h := 0.08693479)
    (by norm_num) (by norm_num) oscBlock57 vbpBr57.1 vbpBr58.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i58 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00149216):ℝ) ≤ ∫ v in (vBP 1.61)..(vBP 1.632), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.70276099) (m := (1:ℤ)) (ylo := 0.41957568) (yhi := 0.41957569)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.61) (q1 := 1.632) (t0 := 6.875) (t1 := 7)
    (A := 0.95245689) (B := 0.97962584) (X := 6.70276099) (rho := 0.1546199)
    (clo := 0.91326187) (chi := 0.91326188) (C := 0.87932098) (h := 0.12067902)
    (by norm_num) (by norm_num) oscBlock58 vbpBr58.1 vbpBr59.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i59 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00147039):ℝ) ≤ ∫ v in (vBP 1.632)..(vBP 1.656), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.89826387) (m := (1:ℤ)) (ylo := 0.61507856) (yhi := 0.61507857)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.632) (q1 := 1.656) (t0 := 6.875) (t1 := 7)
    (A := 0.97959707) (B := 1.00882827) (X := 6.89826387) (rho := 0.16353403)
    (clo := 0.81672811) (chi := 0.81672813) (C := 0.81672812) (h := 0.16353404)
    (by norm_num) (by norm_num) oscBlock59 vbpBr59.1 vbpBr60.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i60 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00115119):ℝ) ≤ ∫ v in (vBP 1.656)..(vBP 1.68), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.09935428) (m := (1:ℤ)) (ylo := 0.81616897) (yhi := 0.81616898)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.656) (q1 := 1.68) (t0 := 6.875) (t1 := 7)
    (A := 1.00878907) (B := 1.03761196) (X := 7.09935428) (rho := 0.16392945)
    (clo := 0.68501722) (chi := 0.68501728) (C := 0.68501725) (h := 0.16392948)
    (by norm_num) (by norm_num) oscBlock60 vbpBr60.1 vbpBr61.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i61 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00085044):ℝ) ≤ ∫ v in (vBP 1.68)..(vBP 1.704), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.29757222) (m := (1:ℤ)) (ylo := 1.01438691) (yhi := 1.01438692)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.68) (q1 := 1.704) (t0 := 6.875) (t1 := 7)
    (A := 1.03755935) (B := 1.06598913) (X := 7.29757222) (rho := 0.1643517)
    (clo := 0.52814062) (chi := 0.52814096) (C := 0.52814079) (h := 0.16435187)
    (by norm_num) (by norm_num) oscBlock61 vbpBr61.1 vbpBr62.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i62 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00071249):ℝ) ≤ ∫ v in (vBP 1.704)..(vBP 1.734), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.51727197) (m := (1:ℤ)) (ylo := 1.23408666) (yhi := 1.23408667)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.704) (q1 := 1.734) (t0 := 6.875) (t1 := 7)
    (A := 1.06591948) (B := 1.10090679) (X := 7.51727197) (rho := 0.18907557)
    (clo := 0.33038328) (chi := 0.33038555) (C := 0.33038441) (h := 0.18907671)
    (by norm_num) (by norm_num) oscBlock62 vbpBr62.1 vbpBr63.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i63 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.0003712):ℝ) ≤ ∫ v in (vBP 1.734)..(vBP 1.766), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.76527316) (m := (1:ℤ)) (ylo := 1.48208785) (yhi := 1.48208786)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.734) (q1 := 1.766) (t0 := 6.875) (t1 := 7)
    (A := 1.10080961) (B := 1.13749718) (X := 7.76527316) (rho := 0.19720711)
    (clo := 0.08859193) (chi := 0.08860604) (C := 0.08859898) (h := 0.19721417)
    (by norm_num) (by norm_num) oscBlock63 vbpBr63.1 vbpBr64.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i64 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00032709):ℝ) ≤ ∫ v in (vBP 1.766)..(vBP 1.796), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.00891002) (m := (1:ℤ)) (ylo := 0.15492838) (yhi := 0.15492839)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.766) (q1 := 1.796) (t0 := 6.875) (t1 := 7)
    (A := 1.1373613) (B := 1.17120873) (X := 8.00891002) (rho := 0.1895511)
    (clo := (-0.15430935)) (chi := (-0.15430933)) (C := (-0.15430934)) (h := 0.18955111)
    (by norm_num) (by norm_num) oscBlock64 vbpBr64.1 vbpBr65.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i65 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.0005282):ℝ) ≤ ∫ v in (vBP 1.796)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.24835933) (m := (1:ℤ)) (ylo := 0.39437769) (yhi := 0.3943777)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.796) (q1 := 1.828) (t0 := 6.875) (t1 := 7)
    (A := 1.1710258) (B := 1.20655947) (X := 8.24835933) (rho := 0.19755697)
    (clo := (-0.38423374)) (chi := (-0.38423372)) (C := (-0.38423373)) (h := 0.19755698)
    (by norm_num) (by norm_num) oscBlock65 vbpBr65.1 vbpBr66.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i66 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00067166):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.86), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.49126735) (m := (1:ℤ)) (ylo := 0.63728571) (yhi := 0.63728572)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.828) (q1 := 1.86) (t0 := 6.875) (t1 := 7)
    (A := 1.20631244) (B := 1.24130524) (X := 8.49126735) (rho := 0.19786934)
    (clo := (-0.59501614)) (chi := (-0.59501612)) (C := (-0.59501613)) (h := 0.19786935)
    (by norm_num) (by norm_num) oscBlock66 vbpBr66.1 vbpBr67.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i67 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00069053):ℝ) ≤ ∫ v in (vBP 1.86)..(vBP 1.89), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.72258267) (m := (1:ℤ)) (ylo := 0.86860103) (yhi := 0.86860104)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.86) (q1 := 1.89) (t0 := 6.875) (t1 := 7)
    (A := 1.24097685) (B := 1.27334993) (X := 8.72258267) (rho := 0.19086685)
    (clo := (-0.76342611)) (chi := (-0.76342609)) (C := (-0.7634261)) (h := 0.19086686)
    (by norm_num) (by norm_num) oscBlock67 vbpBr67.1 vbpBr68.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i68 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00072035):ℝ) ≤ ∫ v in (vBP 1.89)..(vBP 1.922), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.9501387) (m := (1:ℤ)) (ylo := 1.09615706) (yhi := 1.09615707)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.89) (q1 := 1.922) (t0 := 6.875) (t1 := 7)
    (A := 1.27292668) (B := 1.30698664) (X := 8.9501387) (rho := 0.19876779)
    (clo := (-0.88945772)) (chi := (-0.88945764)) (C := (-0.84534493)) (h := 0.15465508)
    (by norm_num) (by norm_num) oscBlock68 vbpBr68.1 vbpBr69.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i69 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00096678):ℝ) ≤ ∫ v in (vBP 1.922)..(vBP 1.969), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 9.2348346) (m := (1:ℤ)) (ylo := 1.38085296) (yhi := 1.38085297)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.922) (q1 := 1.969) (t0 := 6.875) (t1 := 7)
    (A := 1.30643896) (B := 1.35541448) (X := 9.2348346) (rho := 0.25306677)
    (clo := (-0.9820158)) (chi := (-0.98201491)) (C := (-0.86447407)) (h := 0.13552593)
    (by norm_num) (by norm_num) oscBlock69 vbpBr69.1 vbpBr70.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i70 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00087888):ℝ) ≤ ∫ v in (vBP 1.969)..(vBP 2.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 9.56612754) (m := (1:ℤ)) (ylo := 0.14134957) (yhi := 0.14134958)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.969) (q1 := 2.016) (t0 := 6.875) (t1 := 7)
    (A := 1.35463226) (B := 1.4027369) (X := 9.56612754) (rho := 0.25303077)
    (clo := (-0.99002678)) (chi := (-0.99002676)) (C := (-0.868498)) (h := 0.13150201)
    (by norm_num) (by norm_num) oscBlock70 vbpBr70.1 vbpBr71.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i71 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00078633):ℝ) ≤ ∫ v in (vBP 2.016)..(vBP 2.062), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 9.88629655) (m := (1:ℤ)) (ylo := 0.46151858) (yhi := 0.46151859)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.016) (q1 := 2.062) (t0 := 6.875) (t1 := 7)
    (A := 1.40164597) (B := 1.44803958) (X := 9.88629655) (rho := 0.24998052)
    (clo := (-0.8953773)) (chi := (-0.89537728)) (C := (-0.82269838)) (h := 0.17730162)
    (by norm_num) (by norm_num) oscBlock71 vbpBr71.1 vbpBr72.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB3i72 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.00048709):ℝ) ≤ ∫ v in (vBP 2.062)..(vBP 2.094), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 10.14902166) (m := (1:ℤ)) (ylo := 0.72424369) (yhi := 0.7242437)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.062) (q1 := 2.094) (t0 := 6.875) (t1 := 7)
    (A := 1.44655973) (B := 1.47899217) (X := 10.14902166) (rho := 0.20392354)
    (clo := (-0.74900076)) (chi := (-0.74900073)) (C := (-0.74900075)) (h := 0.20392356)
    (by norm_num) (by norm_num) oscBlock72 vbpBr72.1 vbpBr73.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

/-- Lower bound for the oscillatory integral `∫₀^∞ err(v) cos(tv) dv` on the band
`6.875 ≤ t ≤ 7.0`. -/
theorem oscBandLower3 {t : ℝ} (ht0 : (6.875:ℝ) ≤ t) (ht1 : t ≤ 7) :
    ((-0.15294708):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosB3i0 ht0 ht1)
    (cosB3i1 ht0 ht1))
    (cosB3i2 ht0 ht1))
    (cosB3i3 ht0 ht1))
    (cosB3i4 ht0 ht1))
    (cosB3i5 ht0 ht1))
    (cosB3i6 ht0 ht1))
    (cosB3i7 ht0 ht1))
    (cosB3i8 ht0 ht1))
    (cosB3i9 ht0 ht1))
    (cosB3i10 ht0 ht1))
    (cosB3i11 ht0 ht1))
    (cosB3i12 ht0 ht1))
    (cosB3i13 ht0 ht1))
    (cosB3i14 ht0 ht1))
    (cosB3i15 ht0 ht1))
    (cosB3i16 ht0 ht1))
    (cosB3i17 ht0 ht1))
    (cosB3i18 ht0 ht1))
    (cosB3i19 ht0 ht1))
    (cosB3i20 ht0 ht1))
    (cosB3i21 ht0 ht1))
    (cosB3i22 ht0 ht1))
    (cosB3i23 ht0 ht1))
    (cosB3i24 ht0 ht1))
    (cosB3i25 ht0 ht1))
    (cosB3i26 ht0 ht1))
    (cosB3i27 ht0 ht1))
    (cosB3i28 ht0 ht1))
    (cosB3i29 ht0 ht1))
    (cosB3i30 ht0 ht1))
    (cosB3i31 ht0 ht1))
    (cosB3i32 ht0 ht1))
    (cosB3i33 ht0 ht1))
    (cosB3i34 ht0 ht1))
    (cosB3i35 ht0 ht1))
    (cosB3i36 ht0 ht1))
    (cosB3i37 ht0 ht1))
    (cosB3i38 ht0 ht1))
    (cosB3i39 ht0 ht1))
    (cosB3i40 ht0 ht1))
    (cosB3i41 ht0 ht1))
    (cosB3i42 ht0 ht1))
    (cosB3i43 ht0 ht1))
    (cosB3i44 ht0 ht1))
    (cosB3i45 ht0 ht1))
    (cosB3i46 ht0 ht1))
    (cosB3i47 ht0 ht1))
    (cosB3i48 ht0 ht1))
    (cosB3i49 ht0 ht1))
    (cosB3i50 ht0 ht1))
    (cosB3i51 ht0 ht1))
    (cosB3i52 ht0 ht1))
    (cosB3i53 ht0 ht1))
    (cosB3i54 ht0 ht1))
    (cosB3i55 ht0 ht1))
    (cosB3i56 ht0 ht1))
    (cosB3i57 ht0 ht1))
    (cosB3i58 ht0 ht1))
    (cosB3i59 ht0 ht1))
    (cosB3i60 ht0 ht1))
    (cosB3i61 ht0 ht1))
    (cosB3i62 ht0 ht1))
    (cosB3i63 ht0 ht1))
    (cosB3i64 ht0 ht1))
    (cosB3i65 ht0 ht1))
    (cosB3i66 ht0 ht1))
    (cosB3i67 ht0 ht1))
    (cosB3i68 ht0 ht1))
    (cosB3i69 ht0 ht1))
    (cosB3i70 ht0 ht1))
    (cosB3i71 ht0 ht1))
    (cosB3i72 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 2.094) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 2.094) (S := 0.013709)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_cut
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
