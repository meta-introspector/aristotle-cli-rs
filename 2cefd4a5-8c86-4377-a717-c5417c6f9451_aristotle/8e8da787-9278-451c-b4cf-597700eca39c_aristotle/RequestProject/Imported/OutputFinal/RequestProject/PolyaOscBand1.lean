/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscTail

/-!
# Oscillatory lower bound on the band `7.25 ≤ t ≤ 7.5`

On each of the 73 blocks the factor `cos(tv)` is bracketed by a rational constant
`C` up to a rational error `h`; the signed contribution `min(C·P₀, C·P₁) - h·S` is
then summed, and the unresolved tail beyond `q = 2.094` is estimated in absolute
value.  The result is the bound `∫₀^∞ err(v) cos(tv) dv ≥ -0.16454888`.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosB1i0 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00641868):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.0038), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.028446) (m := (0:ℤ)) (ylo := 0.028446) (yhi := 0.028446)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1) (q1 := 1.0038) (t0 := 7.25) (t1 := 7.5)
    (A := 0.0) (B := 0.0075856) (X := 0.028446) (rho := 0.02844601)
    (clo := 0.99959543) (chi := 0.99959544) (C := 0.98557471) (h := 0.01442529)
    (by norm_num) (by norm_num) oscBlock0 vbpBr0.1 vbpBr1.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i1 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00625872):ℝ) ≤ ∫ v in (vBP 1.0038)..(vBP 1.0078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.08577081) (m := (0:ℤ)) (ylo := 0.08577081) (yhi := 0.08577081)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0038) (q1 := 1.0078) (t0 := 7.25) (t1 := 7.5)
    (A := 0.00758559) (B := 0.01553948) (X := 0.08577081) (rho := 0.0307753)
    (clo := 0.99632393) (chi := 0.99632394) (C := 0.98277431) (h := 0.01722569)
    (by norm_num) (by norm_num) oscBlock1 vbpBr1.1 vbpBr2.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i2 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.0057677):ℝ) ≤ ∫ v in (vBP 1.0078)..(vBP 1.0118), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.14431251) (m := (0:ℤ)) (ylo := 0.14431251) (yhi := 0.14431251)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0078) (q1 := 1.0118) (t0 := 7.25) (t1 := 7.5)
    (A := 0.01553947) (B := 0.02346185) (X := 0.14431251) (rho := 0.03165137)
    (clo := 0.989605) (chi := 0.98960501) (C := 0.97897681) (h := 0.02102319)
    (by norm_num) (by norm_num) oscBlock2 vbpBr2.1 vbpBr3.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i3 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00554846):ℝ) ≤ ∫ v in (vBP 1.0118)..(vBP 1.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.20409929) (m := (0:ℤ)) (ylo := 0.20409929) (yhi := 0.20409929)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0118) (q1 := 1.016) (t0 := 7.25) (t1 := 7.5)
    (A := 0.02346184) (B := 0.0317467) (X := 0.20409929) (rho := 0.03400097)
    (clo := 0.97924394) (chi := 0.97924395) (C := 0.97262148) (h := 0.02737852)
    (by norm_num) (by norm_num) oscBlock3 vbpBr3.1 vbpBr4.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i4 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00539232):ℝ) ≤ ∫ v in (vBP 1.016)..(vBP 1.0205), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.26727703) (m := (0:ℤ)) (ylo := 0.26727703) (yhi := 0.26727703)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.016) (q1 := 1.0205) (t0 := 7.25) (t1 := 7.5)
    (A := 0.03174669) (B := 0.04058541) (X := 0.26727703) (rho := 0.03711355)
    (clo := 0.96449362) (chi := 0.96449363) (C := 0.96369003) (h := 0.03630997)
    (by norm_num) (by norm_num) oscBlock4 vbpBr4.1 vbpBr5.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i5 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00477025):ℝ) ≤ ∫ v in (vBP 1.0205)..(vBP 1.025), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.33231668) (m := (0:ℤ)) (ylo := 0.33231668) (yhi := 0.33231668)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0205) (q1 := 1.025) (t0 := 7.25) (t1 := 7.5)
    (A := 0.0405854) (B := 0.04938523) (X := 0.33231668) (rho := 0.03807255)
    (clo := 0.9452891) (chi := 0.94528911) (C := 0.9452891) (h := 0.03807256)
    (by norm_num) (by norm_num) oscBlock5 vbpBr5.1 vbpBr6.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i6 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00461574):ℝ) ≤ ∫ v in (vBP 1.025)..(vBP 1.03), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.40071246) (m := (0:ℤ)) (ylo := 0.40071246) (yhi := 0.40071246)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.025) (q1 := 1.03) (t0 := 7.25) (t1 := 7.5)
    (A := 0.04938522) (B := 0.05911761) (X := 0.40071246) (rho := 0.04266963)
    (clo := 0.92078331) (chi := 0.92078332) (C := 0.92078331) (h := 0.04266964)
    (by norm_num) (by norm_num) oscBlock6 vbpBr6.1 vbpBr7.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i7 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00427564):ℝ) ≤ ∫ v in (vBP 1.03)..(vBP 1.0355), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.47593433) (m := (0:ℤ)) (ylo := 0.47593433) (yhi := 0.47593433)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.03) (q1 := 1.0355) (t0 := 7.25) (t1 := 7.5)
    (A := 0.0591176) (B := 0.06976881) (X := 0.47593433) (rho := 0.04733175)
    (clo := 0.88886502) (chi := 0.88886503) (C := 0.88886502) (h := 0.04733176)
    (by norm_num) (by norm_num) oscBlock7 vbpBr7.1 vbpBr8.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i8 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00377469):ℝ) ≤ ∫ v in (vBP 1.0355)..(vBP 1.0415), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.55787678) (m := (0:ℤ)) (ylo := 0.55787678) (yhi := 0.55787678)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0355) (q1 := 1.0415) (t0 := 7.25) (t1 := 7.5)
    (A := 0.0697688) (B := 0.08132397) (X := 0.55787678) (rho := 0.052053)
    (clo := 0.84838102) (chi := 0.84838103) (C := 0.84838102) (h := 0.05205301)
    (by norm_num) (by norm_num) oscBlock8 vbpBr8.1 vbpBr9.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i9 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00314598):ℝ) ≤ ∫ v in (vBP 1.0415)..(vBP 1.048), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.64642628) (m := (0:ℤ)) (ylo := 0.64642628) (yhi := 0.64642628)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0415) (q1 := 1.048) (t0 := 7.25) (t1 := 7.5)
    (A := 0.08132396) (B := 0.09376718) (X := 0.64642628) (rho := 0.05682758)
    (clo := 0.79824147) (chi := 0.79824149) (C := 0.79824148) (h := 0.05682759)
    (by norm_num) (by norm_num) oscBlock9 vbpBr9.1 vbpBr10.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i10 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00244934):ℝ) ≤ ∫ v in (vBP 1.048)..(vBP 1.055), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.74146176) (m := (0:ℤ)) (ylo := 0.74146176) (yhi := 0.74146176)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.048) (q1 := 1.055) (t0 := 7.25) (t1 := 7.5)
    (A := 0.09376717) (B := 0.10708154) (X := 0.74146176) (rho := 0.0616498)
    (clo := 0.73748212) (chi := 0.73748214) (C := 0.73748213) (h := 0.06164981)
    (by norm_num) (by norm_num) oscBlock10 vbpBr10.1 vbpBr11.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i11 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.0019585):ℝ) ≤ ∫ v in (vBP 1.055)..(vBP 1.064), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.853436) (m := (0:ℤ)) (ylo := 0.853436) (yhi := 0.853436)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.055) (q1 := 1.064) (t0 := 7.25) (t1 := 7.5)
    (A := 0.10708153) (B := 0.12407079) (X := 0.853436) (rho := 0.07709493)
    (clo := 0.65739785) (chi := 0.65739792) (C := 0.65739788) (h := 0.07709497)
    (by norm_num) (by norm_num) oscBlock11 vbpBr11.1 vbpBr12.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i12 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00119578):ℝ) ≤ ∫ v in (vBP 1.064)..(vBP 1.078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.01306264) (m := (0:ℤ)) (ylo := 1.01306264) (yhi := 1.01306264)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.064) (q1 := 1.078) (t0 := 7.25) (t1 := 7.5)
    (A := 0.12407078) (B := 0.15021495) (X := 1.01306264) (rho := 0.1135495)
    (clo := 0.52926468) (chi := 0.52926501) (C := 0.52926484) (h := 0.11354967)
    (by norm_num) (by norm_num) oscBlock12 vbpBr12.1 vbpBr13.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i13 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    (0.00001106:ℝ) ≤ ∫ v in (vBP 1.078)..(vBP 1.09), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.1908619) (m := (0:ℤ)) (ylo := 1.1908619) (yhi := 1.1908619)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.078) (q1 := 1.09) (t0 := 7.25) (t1 := 7.5)
    (A := 0.15021494) (B := 0.1723554) (X := 1.1908619) (rho := 0.10180361)
    (clo := 0.37085955) (chi := 0.37086114) (C := 0.37086034) (h := 0.10180441)
    (by norm_num) (by norm_num) oscBlock13 vbpBr13.1 vbpBr14.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i14 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    (0.00017805:ℝ) ≤ ∫ v in (vBP 1.09)..(vBP 1.1), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.33961463) (m := (0:ℤ)) (ylo := 1.33961463) (yhi := 1.33961463)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.09) (q1 := 1.1) (t0 := 7.25) (t1 := 7.5)
    (A := 0.17235539) (B := 0.19062036) (X := 1.33961463) (rho := 0.09003808)
    (clo := 0.22912787) (chi := 0.22913301) (C := 0.22913044) (h := 0.09004065)
    (by norm_num) (by norm_num) oscBlock14 vbpBr14.1 vbpBr15.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i15 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.0000064):ℝ) ≤ ∫ v in (vBP 1.1)..(vBP 1.109), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.46693909) (m := (0:ℤ)) (ylo := 1.46693909) (yhi := 1.46693909)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.1) (q1 := 1.109) (t0 := 7.25) (t1 := 7.5)
    (A := 0.19062035) (B := 0.20691742) (X := 1.46693909) (rho := 0.08494157)
    (clo := 0.10367042) (chi := 0.10368315) (C := 0.10367678) (h := 0.08494794)
    (by norm_num) (by norm_num) oscBlock15 vbpBr15.1 vbpBr16.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i16 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00028671):ℝ) ≤ ∫ v in (vBP 1.109)..(vBP 1.117), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.57992454) (m := (0:ℤ)) (ylo := 0.00912821) (yhi := 0.00912822)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.109) (q1 := 1.117) (t0 := 7.25) (t1 := 7.5)
    (A := 0.20691741) (B := 0.22129305) (X := 1.57992454) (rho := 0.07977334)
    (clo := (-0.0091281)) (chi := (-0.00912808)) (C := (-0.00912809)) (h := 0.07977335)
    (by norm_num) (by norm_num) oscBlock16 vbpBr16.1 vbpBr17.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i17 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00057442):ℝ) ≤ ∫ v in (vBP 1.117)..(vBP 1.124), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.67889043) (m := (0:ℤ)) (ylo := 0.1080941) (yhi := 0.10809411)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.117) (q1 := 1.124) (t0 := 7.25) (t1 := 7.5)
    (A := 0.22129304) (B := 0.23378751) (X := 1.67889043) (rho := 0.07451591)
    (clo := (-0.10788374)) (chi := (-0.10788372)) (C := (-0.10788373)) (h := 0.07451592)
    (by norm_num) (by norm_num) oscBlock17 vbpBr17.1 vbpBr18.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i18 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00093311):ℝ) ≤ ∫ v in (vBP 1.124)..(vBP 1.131), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.77074618) (m := (0:ℤ)) (ylo := 0.19994985) (yhi := 0.19994986)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.124) (q1 := 1.131) (t0 := 7.25) (t1 := 7.5)
    (A := 0.2337875) (B := 0.2462044) (X := 1.77074618) (rho := 0.07578683)
    (clo := (-0.1986202)) (chi := (-0.19862018)) (C := (-0.19862019)) (h := 0.07578684)
    (by norm_num) (by norm_num) oscBlock18 vbpBr18.1 vbpBr19.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i19 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00131201):ℝ) ≤ ∫ v in (vBP 1.131)..(vBP 1.138), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.86203346) (m := (0:ℤ)) (ylo := 0.29123713) (yhi := 0.29123714)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.131) (q1 := 1.138) (t0 := 7.25) (t1 := 7.5)
    (A := 0.24620439) (B := 0.25854468) (X := 1.86203346) (rho := 0.07705165)
    (clo := (-0.28713749)) (chi := (-0.28713747)) (C := (-0.28713748)) (h := 0.07705166)
    (by norm_num) (by norm_num) oscBlock19 vbpBr19.1 vbpBr20.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i20 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00167954):ℝ) ≤ ∫ v in (vBP 1.138)..(vBP 1.145), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.95275922) (m := (0:ℤ)) (ylo := 0.38196289) (yhi := 0.3819629)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.138) (q1 := 1.145) (t0 := 7.25) (t1 := 7.5)
    (A := 0.25854467) (B := 0.27080928) (X := 1.95275922) (rho := 0.07831039)
    (clo := (-0.37274263)) (chi := (-0.37274262)) (C := (-0.37274263)) (h := 0.0783104)
    (by norm_num) (by norm_num) oscBlock20 vbpBr20.1 vbpBr21.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i21 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00204667):ℝ) ≤ ∫ v in (vBP 1.145)..(vBP 1.152), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.04293034) (m := (0:ℤ)) (ylo := 0.47213401) (yhi := 0.47213402)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.145) (q1 := 1.152) (t0 := 7.25) (t1 := 7.5)
    (A := 0.27080927) (B := 0.28299913) (X := 2.04293034) (rho := 0.07956315)
    (clo := (-0.45478788)) (chi := (-0.45478786)) (C := (-0.45478787)) (h := 0.07956316)
    (by norm_num) (by norm_num) oscBlock21 vbpBr21.1 vbpBr22.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i22 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00239362):ℝ) ≤ ∫ v in (vBP 1.152)..(vBP 1.159), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.13255354) (m := (0:ℤ)) (ylo := 0.56175721) (yhi := 0.56175722)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.152) (q1 := 1.159) (t0 := 7.25) (t1 := 7.5)
    (A := 0.28299912) (B := 0.29511513) (X := 2.13255354) (rho := 0.08080994)
    (clo := (-0.5326742)) (chi := (-0.53267418)) (C := (-0.53267419)) (h := 0.08080995)
    (by norm_num) (by norm_num) oscBlock22 vbpBr22.1 vbpBr23.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i23 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00270689):ℝ) ≤ ∫ v in (vBP 1.159)..(vBP 1.166), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.22163548) (m := (0:ℤ)) (ylo := 0.65083915) (yhi := 0.65083916)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.159) (q1 := 1.166) (t0 := 7.25) (t1 := 7.5)
    (A := 0.29511512) (B := 0.30715818) (X := 2.22163548) (rho := 0.08205088)
    (clo := (-0.60585424)) (chi := (-0.60585422)) (C := (-0.60585423)) (h := 0.08205089)
    (by norm_num) (by norm_num) oscBlock23 vbpBr23.1 vbpBr24.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i24 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00297759):ℝ) ≤ ∫ v in (vBP 1.166)..(vBP 1.173), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.31018264) (m := (0:ℤ)) (ylo := 0.73938631) (yhi := 0.73938632)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.166) (q1 := 1.173) (t0 := 7.25) (t1 := 7.5)
    (A := 0.30715817) (B := 0.31912914) (X := 2.31018264) (rho := 0.08328592)
    (clo := (-0.67383461)) (chi := (-0.67383459)) (C := (-0.6738346)) (h := 0.08328593)
    (by norm_num) (by norm_num) oscBlock24 vbpBr24.1 vbpBr25.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i25 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00319892):ℝ) ≤ ∫ v in (vBP 1.173)..(vBP 1.18), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.39820139) (m := (0:ℤ)) (ylo := 0.82740506) (yhi := 0.82740507)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.173) (q1 := 1.18) (t0 := 7.25) (t1 := 7.5)
    (A := 0.31912913) (B := 0.33102888) (X := 2.39820139) (rho := 0.08451522)
    (clo := (-0.73617764)) (chi := (-0.73617762)) (C := (-0.73617763)) (h := 0.08451523)
    (by norm_num) (by norm_num) oscBlock25 vbpBr25.1 vbpBr26.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i26 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.0033661):ℝ) ≤ ∫ v in (vBP 1.18)..(vBP 1.187), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.48569805) (m := (0:ℤ)) (ylo := 0.91490172) (yhi := 0.91490173)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.18) (q1 := 1.187) (t0 := 7.25) (t1 := 7.5)
    (A := 0.33102887) (B := 0.34285824) (X := 2.48569805) (rho := 0.08573876)
    (clo := (-0.79250267)) (chi := (-0.79250265)) (C := (-0.79250266)) (h := 0.08573877)
    (by norm_num) (by norm_num) oscBlock26 vbpBr26.1 vbpBr27.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i27 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00347644):ℝ) ≤ ∫ v in (vBP 1.187)..(vBP 1.194), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.57267873) (m := (0:ℤ)) (ylo := 1.0018824) (yhi := 1.00188241)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.187) (q1 := 1.194) (t0 := 7.25) (t1 := 7.5)
    (A := 0.34285823) (B := 0.35461804) (X := 2.57267873) (rho := 0.08695658)
    (clo := (-0.84248659)) (chi := (-0.84248655)) (C := (-0.84248657)) (h := 0.0869566)
    (by norm_num) (by norm_num) oscBlock27 vbpBr27.1 vbpBr28.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i28 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00356535):ℝ) ≤ ∫ v in (vBP 1.194)..(vBP 1.201), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.65914941) (m := (0:ℤ)) (ylo := 1.08835308) (yhi := 1.08835309)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.194) (q1 := 1.201) (t0 := 7.25) (t1 := 7.5)
    (A := 0.35461802) (B := 0.36630909) (X := 2.65914941) (rho := 0.08816878)
    (clo := (-0.88586411)) (chi := (-0.88586403)) (C := (-0.88586407)) (h := 0.08816882)
    (by norm_num) (by norm_num) oscBlock28 vbpBr28.1 vbpBr29.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i29 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00352061):ℝ) ≤ ∫ v in (vBP 1.201)..(vBP 1.208), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.74511616) (m := (0:ℤ)) (ylo := 1.17431983) (yhi := 1.17431984)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.201) (q1 := 1.208) (t0 := 7.25) (t1 := 7.5)
    (A := 0.36630908) (B := 0.3779322) (X := 2.74511616) (rho := 0.08937535)
    (clo := (-0.92242754)) (chi := (-0.92242738)) (C := (-0.91652602)) (h := 0.08347399)
    (by norm_num) (by norm_num) oscBlock29 vbpBr29.1 vbpBr30.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i30 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00336132):ℝ) ≤ ∫ v in (vBP 1.208)..(vBP 1.215), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.83058478) (m := (0:ℤ)) (ylo := 1.25978845) (yhi := 1.25978846)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.208) (q1 := 1.215) (t0 := 7.25) (t1 := 7.5)
    (A := 0.37793219) (B := 0.38948816) (X := 2.83058478) (rho := 0.09057643)
    (clo := (-0.95202595)) (chi := (-0.95202562)) (C := (-0.9307246)) (h := 0.06927541)
    (by norm_num) (by norm_num) oscBlock30 vbpBr30.1 vbpBr31.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i31 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00362486):ℝ) ≤ ∫ v in (vBP 1.215)..(vBP 1.223), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.92169599) (m := (0:ℤ)) (ylo := 1.35089966) (yhi := 1.35089967)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.215) (q1 := 1.223) (t0 := 7.25) (t1 := 7.5)
    (A := 0.38948815) (B := 0.40261372) (X := 2.92169599) (rho := 0.09790692)
    (clo := (-0.97592068)) (chi := (-0.97591998)) (C := (-0.93900653)) (h := 0.06099347)
    (by norm_num) (by norm_num) oscBlock31 vbpBr31.1 vbpBr32.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i32 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.0033736):ℝ) ≤ ∫ v in (vBP 1.223)..(vBP 1.231), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.01817607) (m := (0:ℤ)) (ylo := 1.44737974) (yhi := 1.44737975)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.223) (q1 := 1.231) (t0 := 7.25) (t1 := 7.5)
    (A := 0.40261371) (B := 0.4156537) (X := 3.01817607) (rho := 0.09922669)
    (clo := (-0.99239528)) (chi := (-0.99239381)) (C := (-0.94658356)) (h := 0.05341644)
    (by norm_num) (by norm_num) oscBlock32 vbpBr32.1 vbpBr33.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i33 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00310539):ℝ) ≤ ∫ v in (vBP 1.231)..(vBP 1.239), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.11402916) (m := (0:ℤ)) (ylo := 1.54323283) (yhi := 1.54323284)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.231) (q1 := 1.239) (t0 := 7.25) (t1 := 7.5)
    (A := 0.41565369) (B := 0.42860921) (X := 3.11402916) (rho := 0.10053993)
    (clo := (-0.99962307)) (chi := (-0.9996201)) (C := (-0.94954009)) (h := 0.05045992)
    (by norm_num) (by norm_num) oscBlock33 vbpBr33.1 vbpBr34.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i34 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.0031571):ℝ) ≤ ∫ v in (vBP 1.239)..(vBP 1.248), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.21527541) (m := (0:ℤ)) (ylo := 0.07368275) (yhi := 0.07368276)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.239) (q1 := 1.248) (t0 := 7.25) (t1 := 7.5)
    (A := 0.4286092) (B := 0.44308455) (X := 3.21527541) (rho := 0.10785873)
    (clo := (-0.99728666)) (chi := (-0.99728665)) (C := (-0.94471396)) (h := 0.05528604)
    (by norm_num) (by norm_num) oscBlock34 vbpBr34.1 vbpBr35.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i35 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00307604):ℝ) ≤ ∫ v in (vBP 1.248)..(vBP 1.258), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.32760512) (m := (0:ℤ)) (ylo := 0.18601246) (yhi := 0.18601247)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.248) (q1 := 1.258) (t0 := 7.25) (t1 := 7.5)
    (A := 0.44308453) (B := 0.45904632) (X := 3.32760512) (rho := 0.11524229)
    (clo := (-0.98274951)) (chi := (-0.9827495)) (C := (-0.93375361)) (h := 0.0662464)
    (by norm_num) (by norm_num) oscBlock35 vbpBr35.1 vbpBr36.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i36 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00264808):ℝ) ≤ ∫ v in (vBP 1.258)..(vBP 1.268), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.44484932) (m := (0:ℤ)) (ylo := 0.30325666) (yhi := 0.30325667)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.258) (q1 := 1.268) (t0 := 7.25) (t1 := 7.5)
    (A := 0.45904631) (B := 0.47488172) (X := 3.44484932) (rho := 0.11676359)
    (clo := (-0.95436902)) (chi := (-0.95436901)) (C := (-0.91880271)) (h := 0.08119729)
    (by norm_num) (by norm_num) oscBlock36 vbpBr36.1 vbpBr37.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i37 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00261048):ℝ) ≤ ∫ v in (vBP 1.268)..(vBP 1.28), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.5728968) (m := (0:ℤ)) (ylo := 0.43130414) (yhi := 0.43130415)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.268) (q1 := 1.28) (t0 := 7.25) (t1 := 7.5)
    (A := 0.4748817) (B := 0.49372017) (X := 3.5728968) (rho := 0.13000449)
    (clo := (-0.90842132)) (chi := (-0.90842131)) (C := (-0.88920841)) (h := 0.11079159)
    (by norm_num) (by norm_num) oscBlock37 vbpBr37.1 vbpBr38.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i38 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00223846):ℝ) ≤ ∫ v in (vBP 1.28)..(vBP 1.294), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.72277204) (m := (0:ℤ)) (ylo := 0.58117938) (yhi := 0.58117939)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.28) (q1 := 1.294) (t0 := 7.25) (t1 := 7.5)
    (A := 0.49372014) (B := 0.51547641) (X := 3.72277204) (rho := 0.14330104)
    (clo := (-0.83581575)) (chi := (-0.83581573)) (C := (-0.83581574)) (h := 0.14330105)
    (by norm_num) (by norm_num) oscBlock38 vbpBr38.1 vbpBr39.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i39 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.0013491):ℝ) ≤ ∫ v in (vBP 1.294)..(vBP 1.308), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.88234636) (m := (0:ℤ)) (ylo := 0.7407537) (yhi := 0.74075371)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.294) (q1 := 1.308) (t0 := 7.25) (t1 := 7.5)
    (A := 0.51547638) (B := 0.53699853) (X := 3.88234636) (rho := 0.14514262)
    (clo := (-0.73796016)) (chi := (-0.73796013)) (C := (-0.73796015)) (h := 0.14514264)
    (by norm_num) (by norm_num) oscBlock39 vbpBr39.1 vbpBr40.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i40 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00078364):ℝ) ≤ ∫ v in (vBP 1.308)..(vBP 1.326), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.06287131) (m := (0:ℤ)) (ylo := 0.92127865) (yhi := 0.92127866)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.308) (q1 := 1.326) (t0 := 7.25) (t1 := 7.5)
    (A := 0.53699848) (B := 0.56433382) (X := 4.06287131) (rho := 0.16963235)
    (clo := (-0.60480249)) (chi := (-0.60480235)) (C := (-0.60480242)) (h := 0.16963242)
    (by norm_num) (by norm_num) oscBlock40 vbpBr40.1 vbpBr41.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i41 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00024623):ℝ) ≤ ∫ v in (vBP 1.326)..(vBP 1.345), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.2686651) (m := (0:ℤ)) (ylo := 1.12707244) (yhi := 1.12707245)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.326) (q1 := 1.345) (t0 := 7.25) (t1 := 7.5)
    (A := 0.56433374) (B := 0.59278808) (X := 4.2686651) (rho := 0.17724551)
    (clo := (-0.4293066)) (chi := (-0.42930567)) (C := (-0.42930614)) (h := 0.17724598)
    (by norm_num) (by norm_num) oscBlock41 vbpBr41.1 vbpBr42.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i42 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00006429):ℝ) ≤ ∫ v in (vBP 1.345)..(vBP 1.362), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.46601323) (m := (0:ℤ)) (ylo := 1.32442057) (yhi := 1.32442058)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.345) (q1 := 1.362) (t0 := 7.25) (t1 := 7.5)
    (A := 0.59278796) (B := 0.6179085) (X := 4.46601323) (rho := 0.16830053)
    (clo := (-0.24389529)) (chi := (-0.24389069)) (C := (-0.24389299)) (h := 0.16830283)
    (by norm_num) (by norm_num) oscBlock42 vbpBr42.1 vbpBr43.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i43 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00019982):ℝ) ≤ ∫ v in (vBP 1.362)..(vBP 1.376), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.63377362) (m := (0:ℤ)) (ylo := 1.49218096) (yhi := 1.49218097)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.362) (q1 := 1.376) (t0 := 7.25) (t1 := 7.5)
    (A := 0.61790831) (B := 0.6383616) (X := 4.63377362) (rho := 0.15393839)
    (clo := (-0.07854925)) (chi := (-0.07853415)) (C := (-0.0785417)) (h := 0.15394594)
    (by norm_num) (by norm_num) oscBlock43 vbpBr43.1 vbpBr44.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i44 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00048962):ℝ) ≤ ∫ v in (vBP 1.376)..(vBP 1.39), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.78383858) (m := (0:ℤ)) (ylo := 0.07144959) (yhi := 0.0714496)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.376) (q1 := 1.39) (t0 := 7.25) (t1 := 7.5)
    (A := 0.63836133) (B := 0.65860767) (X := 4.78383858) (rho := 0.15571896)
    (clo := 0.07138881) (chi := 0.07138883) (C := 0.07138882) (h := 0.15571897)
    (by norm_num) (by norm_num) oscBlock44 vbpBr44.1 vbpBr45.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i45 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00084174):ℝ) ≤ ∫ v in (vBP 1.39)..(vBP 1.404), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.93239215) (m := (0:ℤ)) (ylo := 0.22000316) (yhi := 0.22000317)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.39) (q1 := 1.404) (t0 := 7.25) (t1 := 7.5)
    (A := 0.65860729) (B := 0.67865086) (X := 4.93239215) (rho := 0.15748931)
    (clo := 0.2182327) (chi := 0.21823272) (C := 0.21823271) (h := 0.15748932)
    (by norm_num) (by norm_num) oscBlock45 vbpBr45.1 vbpBr46.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i46 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00115737):ℝ) ≤ ∫ v in (vBP 1.404)..(vBP 1.418), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.0794644) (m := (0:ℤ)) (ylo := 0.36707541) (yhi := 0.36707542)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.404) (q1 := 1.418) (t0 := 7.25) (t1 := 7.5)
    (A := 0.67865033) (B := 0.69849519) (X := 5.0794644) (rho := 0.15924953)
    (clo := 0.35888721) (chi := 0.35888723) (C := 0.35888722) (h := 0.15924954)
    (by norm_num) (by norm_num) oscBlock46 vbpBr46.1 vbpBr47.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i47 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00140537):ℝ) ≤ ∫ v in (vBP 1.418)..(vBP 1.432), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.22508466) (m := (0:ℤ)) (ylo := 0.51269567) (yhi := 0.51269568)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.418) (q1 := 1.432) (t0 := 7.25) (t1 := 7.5)
    (A := 0.69849446) (B := 0.7181446) (X := 5.22508466) (rho := 0.16099985)
    (clo := 0.4905281) (chi := 0.49052812) (C := 0.49052811) (h := 0.16099986)
    (by norm_num) (by norm_num) oscBlock47 vbpBr47.1 vbpBr48.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i48 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00157739):ℝ) ≤ ∫ v in (vBP 1.432)..(vBP 1.446), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.36928127) (m := (0:ℤ)) (ylo := 0.65689228) (yhi := 0.65689229)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.432) (q1 := 1.446) (t0 := 7.25) (t1 := 7.5)
    (A := 0.7181436) (B := 0.73760286) (X := 5.36928127) (rho := 0.16274019)
    (clo := 0.61065882) (chi := 0.61065883) (C := 0.61065882) (h := 0.1627402)
    (by norm_num) (by norm_num) oscBlock48 vbpBr48.1 vbpBr49.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i49 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00196578):ℝ) ≤ ∫ v in (vBP 1.446)..(vBP 1.462), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.52234897) (m := (0:ℤ)) (ylo := 0.80995998) (yhi := 0.80995999)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.446) (q1 := 1.462) (t0 := 7.25) (t1 := 7.5)
    (A := 0.73760153) (B := 0.75961158) (X := 5.52234897) (rho := 0.17473789)
    (clo := 0.72425958) (chi := 0.72425959) (C := 0.72425958) (h := 0.1747379)
    (by norm_num) (by norm_num) oscBlock49 vbpBr49.1 vbpBr50.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i50 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00209905):ℝ) ≤ ∫ v in (vBP 1.462)..(vBP 1.478), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.6837633) (m := (0:ℤ)) (ylo := 0.97137431) (yhi := 0.97137432)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.462) (q1 := 1.478) (t0 := 7.25) (t1 := 7.5)
    (A := 0.75960973) (B := 0.78138081) (X := 5.6837633) (rho := 0.17659278)
    (clo := 0.82566183) (chi := 0.82566186) (C := 0.82453452) (h := 0.17546548)
    (by norm_num) (by norm_num) oscBlock50 vbpBr50.1 vbpBr51.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i51 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00207223):ℝ) ≤ ∫ v in (vBP 1.478)..(vBP 1.495), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.84844887) (m := (0:ℤ)) (ylo := 1.13605988) (yhi := 1.13605989)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.478) (q1 := 1.495) (t0 := 7.25) (t1 := 7.5)
    (A := 0.7813783) (B := 0.80425401) (X := 5.84844887) (rho := 0.18345621)
    (clo := 0.90698107) (chi := 0.90698119) (C := 0.86176243) (h := 0.13823757)
    (by norm_num) (by norm_num) oscBlock51 vbpBr51.1 vbpBr52.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i52 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00192131):ℝ) ≤ ∫ v in (vBP 1.495)..(vBP 1.512), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.01616598) (m := (0:ℤ)) (ylo := 1.30377699) (yhi := 1.303777)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.495) (q1 := 1.512) (t0 := 7.25) (t1 := 7.5)
    (A := 0.80425056) (B := 0.82686872) (X := 6.01616598) (rho := 0.18534943)
    (clo := 0.96456164) (chi := 0.96456212) (C := 0.8896061) (h := 0.1103939)
    (by norm_num) (by norm_num) oscBlock52 vbpBr52.1 vbpBr53.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i53 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00197876):ℝ) ≤ ∫ v in (vBP 1.512)..(vBP 1.531), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.19180175) (m := (0:ℤ)) (ylo := 1.47941276) (yhi := 1.47941277)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.512) (q1 := 1.531) (t0 := 7.25) (t1 := 7.5)
    (A := 0.82686405) (B := 0.85184522) (X := 6.19180175) (rho := 0.19703741)
    (clo := 0.9958274) (chi := 0.99582927) (C := 0.89939499) (h := 0.10060501)
    (by norm_num) (by norm_num) oscBlock53 vbpBr53.1 vbpBr54.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i54 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.0018127):ℝ) ≤ ∫ v in (vBP 1.531)..(vBP 1.55), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.37484277) (m := (1:ℤ)) (ylo := 0.09165746) (yhi := 0.09165747)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.531) (q1 := 1.55) (t0 := 7.25) (t1 := 7.5)
    (A := 0.85183877) (B := 0.87651393) (X := 6.37484277) (rho := 0.19901171)
    (clo := 0.99580239) (chi := 0.9958024) (C := 0.89839534) (h := 0.10160466)
    (by norm_num) (by norm_num) oscBlock54 vbpBr54.1 vbpBr55.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i55 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00174878):ℝ) ≤ ∫ v in (vBP 1.55)..(vBP 1.57), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.56041909) (m := (1:ℤ)) (ylo := 0.27723378) (yhi := 0.27723379)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.55) (q1 := 1.57) (t0 := 7.25) (t1 := 7.5)
    (A := 0.87650515) (B := 0.90215678) (X := 6.56041909) (rho := 0.20575677)
    (clo := 0.96181621) (chi := 0.96181623) (C := 0.87802972) (h := 0.12197028)
    (by norm_num) (by norm_num) oscBlock55 vbpBr55.1 vbpBr56.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i56 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00159903):ℝ) ≤ ∫ v in (vBP 1.57)..(vBP 1.59), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.74830798) (m := (1:ℤ)) (ylo := 0.46512267) (yhi := 0.46512268)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.57) (q1 := 1.59) (t0 := 7.25) (t1 := 7.5)
    (A := 0.90214481) (B := 0.92747548) (X := 6.74830798) (rho := 0.20775813)
    (clo := 0.89376654) (chi := 0.89376656) (C := 0.8430042) (h := 0.1569958)
    (by norm_num) (by norm_num) oscBlock56 vbpBr56.1 vbpBr57.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i57 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00146404):ℝ) ≤ ∫ v in (vBP 1.59)..(vBP 1.61), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.93383372) (m := (1:ℤ)) (ylo := 0.65064841) (yhi := 0.65064842)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.59) (q1 := 1.61) (t0 := 7.25) (t1 := 7.5)
    (A := 0.92745939) (B := 0.95247825) (X := 6.93383372) (rho := 0.20975316)
    (clo := 0.79569121) (chi := 0.79569123) (C := 0.79296902) (h := 0.20703098)
    (by norm_num) (by norm_num) oscBlock57 vbpBr57.1 vbpBr58.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i58 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00132223):ℝ) ≤ ∫ v in (vBP 1.61)..(vBP 1.632), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.12625312) (m := (1:ℤ)) (ylo := 0.84306781) (yhi := 0.84306782)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.61) (q1 := 1.632) (t0 := 7.25) (t1 := 7.5)
    (A := 0.95245689) (B := 0.97962584) (X := 7.12625312) (rho := 0.22094069)
    (clo := 0.66517525) (chi := 0.66517532) (C := 0.66517528) (h := 0.22094073)
    (by norm_num) (by norm_num) oscBlock58 vbpBr58.1 vbpBr59.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i59 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00109321):ℝ) ≤ ∫ v in (vBP 1.632)..(vBP 1.656), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.33414539) (m := (1:ℤ)) (ylo := 1.05096008) (yhi := 1.05096009)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.632) (q1 := 1.656) (t0 := 7.25) (t1 := 7.5)
    (A := 0.97959707) (B := 1.00882827) (X := 7.33414539) (rho := 0.23206665)
    (clo := 0.49673801) (chi := 0.49673848) (C := 0.49673824) (h := 0.23206689)
    (by norm_num) (by norm_num) oscBlock59 vbpBr59.1 vbpBr60.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i60 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00072616):ℝ) ≤ ∫ v in (vBP 1.656)..(vBP 1.68), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.54790522) (m := (1:ℤ)) (ylo := 1.26471991) (yhi := 1.26471992)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.656) (q1 := 1.68) (t0 := 7.25) (t1 := 7.5)
    (A := 1.00878907) (B := 1.03761196) (X := 7.54790522) (rho := 0.23418449)
    (clo := 0.30131969) (chi := 0.30132259) (C := 0.30132114) (h := 0.23418594)
    (by norm_num) (by norm_num) oscBlock60 vbpBr60.1 vbpBr61.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i61 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00040717):ℝ) ≤ ∫ v in (vBP 1.68)..(vBP 1.704), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.75861188) (m := (1:ℤ)) (ylo := 1.47542657) (yhi := 1.47542658)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.68) (q1 := 1.704) (t0 := 7.25) (t1 := 7.5)
    (A := 1.03755935) (B := 1.06598913) (X := 7.75861188) (rho := 0.23630661)
    (clo := 0.09522502) (chi := 0.09523851) (C := 0.09523176) (h := 0.23631336)
    (by norm_num) (by norm_num) oscBlock61 vbpBr61.1 vbpBr62.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i62 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00048927):ℝ) ≤ ∫ v in (vBP 1.704)..(vBP 1.734), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 7.99235857) (m := (1:ℤ)) (ylo := 0.13837693) (yhi := 0.13837694)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.704) (q1 := 1.734) (t0 := 7.25) (t1 := 7.5)
    (A := 1.06591948) (B := 1.10090679) (X := 7.99235857) (rho := 0.26444236)
    (clo := (-0.13793576)) (chi := (-0.13793574)) (C := (-0.13793575)) (h := 0.26444237)
    (by norm_num) (by norm_num) oscBlock62 vbpBr62.1 vbpBr63.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i63 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00071579):ℝ) ≤ ∫ v in (vBP 1.734)..(vBP 1.766), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.25604926) (m := (1:ℤ)) (ylo := 0.40206762) (yhi := 0.40206763)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.734) (q1 := 1.766) (t0 := 7.25) (t1 := 7.5)
    (A := 1.10080961) (B := 1.13749718) (X := 8.25604926) (rho := 0.2751796)
    (clo := (-0.39132193)) (chi := (-0.39132191)) (C := (-0.39132192)) (h := 0.27517961)
    (by norm_num) (by norm_num) oscBlock63 vbpBr63.1 vbpBr64.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i64 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00077935):ℝ) ≤ ∫ v in (vBP 1.766)..(vBP 1.796), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.51496745) (m := (1:ℤ)) (ylo := 0.66098581) (yhi := 0.66098582)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.766) (q1 := 1.796) (t0 := 7.25) (t1 := 7.5)
    (A := 1.1373613) (B := 1.17120873) (X := 8.51496745) (rho := 0.26909804)
    (clo := (-0.61389535)) (chi := (-0.61389533)) (C := (-0.61389534)) (h := 0.26909805)
    (by norm_num) (by norm_num) oscBlock64 vbpBr64.1 vbpBr65.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i65 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00088648):ℝ) ≤ ∫ v in (vBP 1.796)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.76956653) (m := (1:ℤ)) (ylo := 0.91558489) (yhi := 0.9155849)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.796) (q1 := 1.828) (t0 := 7.25) (t1 := 7.5)
    (A := 1.1710258) (B := 1.20655947) (X := 8.76956653) (rho := 0.2796295)
    (clo := (-0.79291913)) (chi := (-0.79291911)) (C := (-0.75664481)) (h := 0.2433552)
    (by norm_num) (by norm_num) oscBlock65 vbpBr65.1 vbpBr66.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i66 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00083609):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.86), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 9.02777724) (m := (1:ℤ)) (ylo := 1.1737956) (yhi := 1.17379561)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.828) (q1 := 1.86) (t0 := 7.25) (t1 := 7.5)
    (A := 1.20631244) (B := 1.24130524) (X := 9.02777724) (rho := 0.28201207)
    (clo := (-0.92222498)) (chi := (-0.92222482)) (C := (-0.82010638)) (h := 0.17989363)
    (by norm_num) (by norm_num) oscBlock66 vbpBr66.1 vbpBr67.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i67 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00071796):ℝ) ≤ ∫ v in (vBP 1.86)..(vBP 1.89), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 9.27360331) (m := (1:ℤ)) (ylo := 1.41962167) (yhi := 1.41962168)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.86) (q1 := 1.89) (t0 := 7.25) (t1 := 7.5)
    (A := 1.24097685) (B := 1.27334993) (X := 9.27360331) (rho := 0.27652117)
    (clo := (-0.98859603)) (chi := (-0.98859484)) (C := (-0.85603684)) (h := 0.14396317)
    (by norm_num) (by norm_num) oscBlock67 vbpBr67.1 vbpBr68.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i68 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00071976):ℝ) ≤ ∫ v in (vBP 1.89)..(vBP 1.922), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 9.51555911) (m := (1:ℤ)) (ylo := 0.09078114) (yhi := 0.09078115)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.89) (q1 := 1.922) (t0 := 7.25) (t1 := 7.5)
    (A := 1.27292668) (B := 1.30698664) (X := 9.51555911) (rho := 0.2868407)
    (clo := (-0.99588223)) (chi := (-0.99588222)) (C := (-0.85452076)) (h := 0.14547924)
    (by norm_num) (by norm_num) oscBlock68 vbpBr68.1 vbpBr69.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i69 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00096914):ℝ) ≤ ∫ v in (vBP 1.922)..(vBP 1.969), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 9.81864553) (m := (1:ℤ)) (ylo := 0.39386756) (yhi := 0.39386757)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.922) (q1 := 1.969) (t0 := 7.25) (t1 := 7.5)
    (A := 1.30643896) (B := 1.35541448) (X := 9.81864553) (rho := 0.34696308)
    (clo := (-0.92343175)) (chi := (-0.92343174)) (C := (-0.78823433)) (h := 0.21176567)
    (by norm_num) (by norm_num) oscBlock69 vbpBr69.1 vbpBr70.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i70 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00087888):ℝ) ≤ ∫ v in (vBP 1.969)..(vBP 2.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 10.17080531) (m := (1:ℤ)) (ylo := 0.74602734) (yhi := 0.74602735)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.969) (q1 := 2.016) (t0 := 7.25) (t1 := 7.5)
    (A := 1.35463226) (B := 1.4027369) (X := 10.17080531) (rho := 0.34972145)
    (clo := (-0.73439103)) (chi := (-0.734391)) (C := (-0.69233478)) (h := 0.30766523)
    (by norm_num) (by norm_num) oscBlock70 vbpBr70.1 vbpBr71.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i71 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.0006408):ℝ) ≤ ∫ v in (vBP 2.016)..(vBP 2.062), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 10.51111506) (m := (1:ℤ)) (ylo := 1.08633709) (yhi := 1.0863371)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.016) (q1 := 2.062) (t0 := 7.25) (t1 := 7.5)
    (A := 1.40164597) (B := 1.44803958) (X := 10.51111506) (rho := 0.3491818)
    (clo := (-0.46573052)) (chi := (-0.46572987)) (C := (-0.4657302)) (h := 0.34918213)
    (by norm_num) (by norm_num) oscBlock71 vbpBr71.1 vbpBr72.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB1i72 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.00025894):ℝ) ≤ ∫ v in (vBP 2.062)..(vBP 2.094), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 10.78999965) (m := (1:ℤ)) (ylo := 1.36522168) (yhi := 1.36522169)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.062) (q1 := 2.094) (t0 := 7.25) (t1 := 7.5)
    (A := 1.44655973) (B := 1.47899217) (X := 10.78999965) (rho := 0.30244163)
    (clo := (-0.20413586)) (chi := (-0.20412964)) (C := (-0.20413275)) (h := 0.30244474)
    (by norm_num) (by norm_num) oscBlock72 vbpBr72.1 vbpBr73.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

/-- Lower bound for the oscillatory integral `∫₀^∞ err(v) cos(tv) dv` on the band
`7.25 ≤ t ≤ 7.5`. -/
theorem oscBandLower1 {t : ℝ} (ht0 : (7.25:ℝ) ≤ t) (ht1 : t ≤ 7.5) :
    ((-0.16454888):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosB1i0 ht0 ht1)
    (cosB1i1 ht0 ht1))
    (cosB1i2 ht0 ht1))
    (cosB1i3 ht0 ht1))
    (cosB1i4 ht0 ht1))
    (cosB1i5 ht0 ht1))
    (cosB1i6 ht0 ht1))
    (cosB1i7 ht0 ht1))
    (cosB1i8 ht0 ht1))
    (cosB1i9 ht0 ht1))
    (cosB1i10 ht0 ht1))
    (cosB1i11 ht0 ht1))
    (cosB1i12 ht0 ht1))
    (cosB1i13 ht0 ht1))
    (cosB1i14 ht0 ht1))
    (cosB1i15 ht0 ht1))
    (cosB1i16 ht0 ht1))
    (cosB1i17 ht0 ht1))
    (cosB1i18 ht0 ht1))
    (cosB1i19 ht0 ht1))
    (cosB1i20 ht0 ht1))
    (cosB1i21 ht0 ht1))
    (cosB1i22 ht0 ht1))
    (cosB1i23 ht0 ht1))
    (cosB1i24 ht0 ht1))
    (cosB1i25 ht0 ht1))
    (cosB1i26 ht0 ht1))
    (cosB1i27 ht0 ht1))
    (cosB1i28 ht0 ht1))
    (cosB1i29 ht0 ht1))
    (cosB1i30 ht0 ht1))
    (cosB1i31 ht0 ht1))
    (cosB1i32 ht0 ht1))
    (cosB1i33 ht0 ht1))
    (cosB1i34 ht0 ht1))
    (cosB1i35 ht0 ht1))
    (cosB1i36 ht0 ht1))
    (cosB1i37 ht0 ht1))
    (cosB1i38 ht0 ht1))
    (cosB1i39 ht0 ht1))
    (cosB1i40 ht0 ht1))
    (cosB1i41 ht0 ht1))
    (cosB1i42 ht0 ht1))
    (cosB1i43 ht0 ht1))
    (cosB1i44 ht0 ht1))
    (cosB1i45 ht0 ht1))
    (cosB1i46 ht0 ht1))
    (cosB1i47 ht0 ht1))
    (cosB1i48 ht0 ht1))
    (cosB1i49 ht0 ht1))
    (cosB1i50 ht0 ht1))
    (cosB1i51 ht0 ht1))
    (cosB1i52 ht0 ht1))
    (cosB1i53 ht0 ht1))
    (cosB1i54 ht0 ht1))
    (cosB1i55 ht0 ht1))
    (cosB1i56 ht0 ht1))
    (cosB1i57 ht0 ht1))
    (cosB1i58 ht0 ht1))
    (cosB1i59 ht0 ht1))
    (cosB1i60 ht0 ht1))
    (cosB1i61 ht0 ht1))
    (cosB1i62 ht0 ht1))
    (cosB1i63 ht0 ht1))
    (cosB1i64 ht0 ht1))
    (cosB1i65 ht0 ht1))
    (cosB1i66 ht0 ht1))
    (cosB1i67 ht0 ht1))
    (cosB1i68 ht0 ht1))
    (cosB1i69 ht0 ht1))
    (cosB1i70 ht0 ht1))
    (cosB1i71 ht0 ht1))
    (cosB1i72 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 2.094) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 2.094) (S := 0.013709)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_cut
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
