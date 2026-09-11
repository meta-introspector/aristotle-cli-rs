/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscTail

/-!
# Oscillatory lower bound on the band `5.75 ≤ t ≤ 5.78125`

On each of the 73 blocks the factor `cos(tv)` is bracketed by a rational constant
`C` up to a rational error `h`; the signed contribution `min(C·P₀, C·P₁) - h·S` is
then summed, and the unresolved tail beyond `q = 2.094` is estimated in absolute
value.  The result is the bound `∫₀^∞ err(v) cos(tv) dv ≥ -0.11435119`.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosB18i0 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00641868):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.0038), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.02192712) (m := (0:ℤ)) (ylo := 0.02192712) (yhi := 0.02192712)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1) (q1 := 1.0038) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.0) (B := 0.0075856) (X := 0.02192712) (rho := 0.02192714)
    (clo := 0.99975961) (chi := 0.99975962) (C := 0.98891623) (h := 0.01108377)
    (by norm_num) (by norm_num) oscBlock0 vbpBr0.1 vbpBr1.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i1 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00625872):ℝ) ≤ ∫ v in (vBP 1.0038)..(vBP 1.0078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.06672738) (m := (0:ℤ)) (ylo := 0.06672738) (yhi := 0.06672738)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0038) (q1 := 1.0078) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.00758559) (B := 0.01553948) (X := 0.06672738) (rho := 0.02311025)
    (clo := 0.99777455) (chi := 0.99777456) (C := 0.98733215) (h := 0.01266785)
    (by norm_num) (by norm_num) oscBlock1 vbpBr1.1 vbpBr2.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i2 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.0057677):ℝ) ≤ ∫ v in (vBP 1.0078)..(vBP 1.0118), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.11249538) (m := (0:ℤ)) (ylo := 0.11249538) (yhi := 0.11249538)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0078) (q1 := 1.0118) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.01553947) (B := 0.02346185) (X := 0.11249538) (rho := 0.02314345)
    (clo := 0.99367906) (chi := 0.99367907) (C := 0.9852678) (h := 0.0147322)
    (by norm_num) (by norm_num) oscBlock2 vbpBr2.1 vbpBr3.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i3 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00554846):ℝ) ≤ ∫ v in (vBP 1.0118)..(vBP 1.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.15922059) (m := (0:ℤ)) (ylo := 0.15922059) (yhi := 0.15922059)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0118) (q1 := 1.016) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.02346184) (B := 0.0317467) (X := 0.15922059) (rho := 0.02431503)
    (clo := 0.98735115) (chi := 0.98735116) (C := 0.98151806) (h := 0.01848194)
    (by norm_num) (by norm_num) oscBlock3 vbpBr3.1 vbpBr4.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i4 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00539232):ℝ) ≤ ∫ v in (vBP 1.016)..(vBP 1.0205), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.20858893) (m := (0:ℤ)) (ylo := 0.20858893) (yhi := 0.20858893)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.016) (q1 := 1.0205) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.03174669) (B := 0.04058541) (X := 0.20858893) (rho := 0.02604548)
    (clo := 0.97832409) (chi := 0.9783241) (C := 0.9761393) (h := 0.0238607)
    (by norm_num) (by norm_num) oscBlock4 vbpBr4.1 vbpBr5.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i5 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.0048151):ℝ) ≤ ∫ v in (vBP 1.0205)..(vBP 1.025), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.2594372) (m := (0:ℤ)) (ylo := 0.2594372) (yhi := 0.2594372)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0205) (q1 := 1.025) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.0405854) (B := 0.04938523) (X := 0.2594372) (rho := 0.02607117)
    (clo := 0.96653451) (chi := 0.96653452) (C := 0.96653451) (h := 0.02607118)
    (by norm_num) (by norm_num) oscBlock5 vbpBr5.1 vbpBr6.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i6 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00469674):ℝ) ≤ ∫ v in (vBP 1.025)..(vBP 1.03), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.31286934) (m := (0:ℤ)) (ylo := 0.31286934) (yhi := 0.31286934)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.025) (q1 := 1.03) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.04938522) (B := 0.05911761) (X := 0.31286934) (rho := 0.02890435)
    (clo := 0.95145433) (chi := 0.95145434) (C := 0.95145433) (h := 0.02890436)
    (by norm_num) (by norm_num) oscBlock6 vbpBr6.1 vbpBr7.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i7 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00440009):ℝ) ≤ ∫ v in (vBP 1.03)..(vBP 1.0355), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.37163856) (m := (0:ℤ)) (ylo := 0.37163856) (yhi := 0.37163856)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.03) (q1 := 1.0355) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.0591176) (B := 0.06976881) (X := 0.37163856) (rho := 0.03171238)
    (clo := 0.93173356) (chi := 0.93173357) (C := 0.93173356) (h := 0.03171239)
    (by norm_num) (by norm_num) oscBlock7 vbpBr7.1 vbpBr8.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i8 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00394509):ℝ) ≤ ∫ v in (vBP 1.0355)..(vBP 1.0415), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.4356624) (m := (0:ℤ)) (ylo := 0.4356624) (yhi := 0.4356624)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0355) (q1 := 1.0415) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.0697688) (B := 0.08132397) (X := 0.4356624) (rho := 0.03449182)
    (clo := 0.9065907) (chi := 0.90659071) (C := 0.9065907) (h := 0.03449183)
    (by norm_num) (by norm_num) oscBlock8 vbpBr8.1 vbpBr9.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i9 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00335723):ℝ) ≤ ∫ v in (vBP 1.0415)..(vBP 1.048), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.50485213) (m := (0:ℤ)) (ylo := 0.50485213) (yhi := 0.50485213)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0415) (q1 := 1.048) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.08132396) (B := 0.09376718) (X := 0.50485213) (rho := 0.03723938)
    (clo := 0.875246) (chi := 0.87524601) (C := 0.875246) (h := 0.03723939)
    (by norm_num) (by norm_num) oscBlock9 vbpBr9.1 vbpBr10.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i10 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.0026877):ℝ) ≤ ∫ v in (vBP 1.048)..(vBP 1.055), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.57911319) (m := (0:ℤ)) (ylo := 0.57911319) (yhi := 0.57911319)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.048) (q1 := 1.055) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.09376717) (B := 0.10708154) (X := 0.57911319) (rho := 0.03995198)
    (clo := 0.83694831) (chi := 0.83694832) (C := 0.83694831) (h := 0.03995199)
    (by norm_num) (by norm_num) oscBlock10 vbpBr10.1 vbpBr11.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i11 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00223122):ℝ) ≤ ∫ v in (vBP 1.055)..(vBP 1.064), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.66650152) (m := (0:ℤ)) (ylo := 0.66650152) (yhi := 0.66650152)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.055) (q1 := 1.064) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.10708153) (B := 0.12407079) (X := 0.66650152) (rho := 0.05078274)
    (clo := 0.78598937) (chi := 0.78598938) (C := 0.78598937) (h := 0.05078275)
    (by norm_num) (by norm_num) oscBlock11 vbpBr11.1 vbpBr12.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i12 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00145229):ℝ) ≤ ∫ v in (vBP 1.064)..(vBP 1.078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.79091858) (m := (0:ℤ)) (ylo := 0.79091858) (yhi := 0.79091858)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.064) (q1 := 1.078) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.12407078) (B := 0.15021495) (X := 0.79091858) (rho := 0.07751161)
    (clo := 0.7031925) (chi := 0.70319253) (C := 0.70319251) (h := 0.07751163)
    (by norm_num) (by norm_num) oscBlock12 vbpBr12.1 vbpBr13.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i13 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    (0.00019559:ℝ) ≤ ∫ v in (vBP 1.078)..(vBP 1.09), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.93008278) (m := (0:ℤ)) (ylo := 0.93008278) (yhi := 0.93008278)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.078) (q1 := 1.09) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.15021494) (B := 0.1723554) (X := 0.93008278) (rho := 0.06634689)
    (clo := 0.59776762) (chi := 0.59776776) (C := 0.59776769) (h := 0.06634696)
    (by norm_num) (by norm_num) oscBlock13 vbpBr13.1 vbpBr14.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i14 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    (0.0007535:ℝ) ≤ ∫ v in (vBP 1.09)..(vBP 1.1), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.04653372) (m := (0:ℤ)) (ylo := 1.04653372) (yhi := 1.04653372)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.09) (q1 := 1.1) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.17235539) (B := 0.19062036) (X := 1.04653372) (rho := 0.05549025)
    (clo := 0.50057478) (chi := 0.50057522) (C := 0.500575) (h := 0.05549047)
    (by norm_num) (by norm_num) oscBlock14 vbpBr14.1 vbpBr15.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i15 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    (0.00085223:ℝ) ≤ ∫ v in (vBP 1.1)..(vBP 1.109), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.14615417) (m := (0:ℤ)) (ylo := 1.14615417) (yhi := 1.14615417)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.1) (q1 := 1.109) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.19062035) (B := 0.20691742) (X := 1.14615417) (rho := 0.05008718)
    (clo := 0.41199473) (chi := 0.41199582) (C := 0.41199527) (h := 0.05008773)
    (by norm_num) (by norm_num) oscBlock15 vbpBr15.1 vbpBr16.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i16 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    (0.00074229:ℝ) ≤ ∫ v in (vBP 1.109)..(vBP 1.117), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.23456277) (m := (0:ℤ)) (ylo := 1.23456277) (yhi := 1.23456277)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.109) (q1 := 1.117) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.20691741) (B := 0.22129305) (X := 1.23456277) (rho := 0.04478768)
    (clo := 0.32993387) (chi := 0.32993615) (C := 0.32993501) (h := 0.04478882)
    (by norm_num) (by norm_num) oscBlock16 vbpBr16.1 vbpBr17.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i17 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    (0.00056246:ℝ) ≤ ∫ v in (vBP 1.117)..(vBP 1.124), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.31200951) (m := (0:ℤ)) (ylo := 1.31200951) (yhi := 1.31200951)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.117) (q1 := 1.124) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.22129304) (B := 0.23378751) (X := 1.31200951) (rho := 0.03957455)
    (clo := 0.2559079) (chi := 0.25591207) (C := 0.25590998) (h := 0.03957664)
    (by norm_num) (by norm_num) oscBlock17 vbpBr17.1 vbpBr18.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i18 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    (0.00041231:ℝ) ≤ ∫ v in (vBP 1.124)..(vBP 1.131), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.38382365) (m := (0:ℤ)) (ylo := 1.38382365) (yhi := 1.38382365)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.124) (q1 := 1.131) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.2337875) (B := 0.2462044) (X := 1.38382365) (rho := 0.03954555)
    (clo := 0.18588508) (chi := 0.18589219) (C := 0.18588863) (h := 0.03954911)
    (by norm_num) (by norm_num) oscBlock18 vbpBr18.1 vbpBr19.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i19 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    (0.00022085:ℝ) ≤ ∫ v in (vBP 1.131)..(vBP 1.138), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.45519333) (m := (0:ℤ)) (ylo := 1.45519333) (yhi := 1.45519333)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.131) (q1 := 1.138) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.24620439) (B := 0.25854468) (X := 1.45519333) (rho := 0.03951811)
    (clo := 0.11534549) (chi := 0.11535723) (C := 0.11535136) (h := 0.03952398)
    (by norm_num) (by norm_num) oscBlock19 vbpBr19.1 vbpBr20.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i20 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    (0.00000231:ℝ) ≤ ∫ v in (vBP 1.138)..(vBP 1.145), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.526124) (m := (0:ℤ)) (ylo := 1.526124) (yhi := 1.526124)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.138) (q1 := 1.145) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.25854467) (B := 0.27080928) (X := 1.526124) (rho := 0.03949216)
    (clo := 0.04465714) (chi := 0.04467603) (C := 0.04466658) (h := 0.03950161)
    (by norm_num) (by norm_num) oscBlock20 vbpBr20.1 vbpBr21.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i21 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00025008):ℝ) ≤ ∫ v in (vBP 1.145)..(vBP 1.152), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.59662101) (m := (0:ℤ)) (ylo := 0.02582468) (yhi := 0.02582469)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.145) (q1 := 1.152) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.27080927) (B := 0.28299913) (X := 1.59662101) (rho := 0.03946772)
    (clo := (-0.02582182)) (chi := (-0.0258218)) (C := (-0.02582181)) (h := 0.03946773)
    (by norm_num) (by norm_num) oscBlock21 vbpBr21.1 vbpBr22.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i22 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00052748):ℝ) ≤ ∫ v in (vBP 1.152)..(vBP 1.159), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.66668964) (m := (0:ℤ)) (ylo := 0.09589331) (yhi := 0.09589332)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.152) (q1 := 1.159) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.28299912) (B := 0.29511513) (X := 1.66668964) (rho := 0.03944472)
    (clo := (-0.09574643)) (chi := (-0.09574641)) (C := (-0.09574642)) (h := 0.03944473)
    (by norm_num) (by norm_num) oscBlock22 vbpBr22.1 vbpBr23.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i23 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00080355):ℝ) ≤ ∫ v in (vBP 1.159)..(vBP 1.166), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.73633508) (m := (0:ℤ)) (ylo := 0.16553875) (yhi := 0.16553876)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.159) (q1 := 1.166) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.29511512) (B := 0.30715818) (X := 1.73633508) (rho := 0.03942316)
    (clo := (-0.16478375)) (chi := (-0.16478374)) (C := (-0.16478375)) (h := 0.03942317)
    (by norm_num) (by norm_num) oscBlock23 vbpBr23.1 vbpBr24.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i24 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00106979):ℝ) ≤ ∫ v in (vBP 1.166)..(vBP 1.173), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.8055624) (m := (0:ℤ)) (ylo := 0.23476607) (yhi := 0.23476608)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.166) (q1 := 1.173) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.30715817) (B := 0.31912914) (X := 1.8055624) (rho := 0.03940295)
    (clo := (-0.23261549)) (chi := (-0.23261547)) (C := (-0.23261548)) (h := 0.03940296)
    (by norm_num) (by norm_num) oscBlock24 vbpBr24.1 vbpBr25.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i25 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00131873):ℝ) ≤ ∫ v in (vBP 1.173)..(vBP 1.18), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.8743766) (m := (0:ℤ)) (ylo := 0.30358027) (yhi := 0.30358028)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.173) (q1 := 1.18) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.31912913) (B := 0.33102888) (X := 1.8743766) (rho := 0.03938412)
    (clo := (-0.29893868)) (chi := (-0.29893866)) (C := (-0.29893867)) (h := 0.03938413)
    (by norm_num) (by norm_num) oscBlock25 vbpBr25.1 vbpBr26.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i26 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00154397):ℝ) ≤ ∫ v in (vBP 1.18)..(vBP 1.187), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.9427826) (m := (0:ℤ)) (ylo := 0.37198627) (yhi := 0.37198628)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.18) (q1 := 1.187) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.33102887) (B := 0.34285824) (X := 1.9427826) (rho := 0.03936661)
    (clo := (-0.36346659)) (chi := (-0.36346657)) (C := (-0.36346658)) (h := 0.03936662)
    (by norm_num) (by norm_num) oscBlock26 vbpBr26.1 vbpBr27.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i27 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00174031):ℝ) ≤ ∫ v in (vBP 1.187)..(vBP 1.194), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.01078518) (m := (0:ℤ)) (ylo := 0.43998885) (yhi := 0.43998886)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.187) (q1 := 1.194) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.34285823) (B := 0.35461804) (X := 2.01078518) (rho := 0.03935038)
    (clo := (-0.42592939)) (chi := (-0.42592937)) (C := (-0.42592938)) (h := 0.03935039)
    (by norm_num) (by norm_num) oscBlock27 vbpBr27.1 vbpBr28.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i28 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00192322):ℝ) ≤ ∫ v in (vBP 1.194)..(vBP 1.201), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.07838902) (m := (0:ℤ)) (ylo := 0.50759269) (yhi := 0.5075927)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.194) (q1 := 1.201) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.35461802) (B := 0.36630909) (X := 2.07838902) (rho := 0.03933542)
    (clo := (-0.48607488)) (chi := (-0.48607486)) (C := (-0.48607487)) (h := 0.03933543)
    (by norm_num) (by norm_num) oscBlock28 vbpBr28.1 vbpBr29.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i29 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00205248):ℝ) ≤ ∫ v in (vBP 1.201)..(vBP 1.208), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.14559887) (m := (0:ℤ)) (ylo := 0.57480254) (yhi := 0.57480255)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.201) (q1 := 1.208) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.36630908) (B := 0.3779322) (X := 2.14559887) (rho := 0.03932168)
    (clo := (-0.54366909)) (chi := (-0.54366907)) (C := (-0.54366908)) (h := 0.03932169)
    (by norm_num) (by norm_num) oscBlock29 vbpBr29.1 vbpBr30.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i30 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00214387):ℝ) ≤ ∫ v in (vBP 1.208)..(vBP 1.215), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.21241925) (m := (0:ℤ)) (ylo := 0.64162292) (yhi := 0.64162293)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.208) (q1 := 1.215) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.37793219) (B := 0.38948816) (X := 2.21241925) (rho := 0.03930918)
    (clo := (-0.5984964)) (chi := (-0.59849639)) (C := (-0.5984964)) (h := 0.03930919)
    (by norm_num) (by norm_num) oscBlock30 vbpBr30.1 vbpBr31.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i31 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00253006):ℝ) ≤ ∫ v in (vBP 1.215)..(vBP 1.223), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.28358371) (m := (0:ℤ)) (ylo := 0.71278738) (yhi := 0.71278739)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.215) (q1 := 1.223) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.38948815) (B := 0.40261372) (X := 2.28358371) (rho := 0.04402687)
    (clo := (-0.65394509)) (chi := (-0.65394507)) (C := (-0.65394508)) (h := 0.04402688)
    (by norm_num) (by norm_num) oscBlock31 vbpBr31.1 vbpBr32.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i32 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.0025406):ℝ) ≤ ∫ v in (vBP 1.223)..(vBP 1.231), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.35901339) (m := (0:ℤ)) (ylo := 0.78821706) (yhi := 0.78821707)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.223) (q1 := 1.231) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.40261371) (B := 0.4156537) (X := 2.35901339) (rho := 0.04398458)
    (clo := (-0.70909724)) (chi := (-0.70909723)) (C := (-0.70909724)) (h := 0.04398459)
    (by norm_num) (by norm_num) oscBlock32 vbpBr32.1 vbpBr33.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i33 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00249624):ℝ) ≤ ∫ v in (vBP 1.231)..(vBP 1.239), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.43395285) (m := (0:ℤ)) (ylo := 0.86315652) (yhi := 0.86315653)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.231) (q1 := 1.239) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.41565369) (B := 0.42860921) (X := 2.43395285) (rho := 0.04394415)
    (clo := (-0.75989823)) (chi := (-0.75989821)) (C := (-0.75989822)) (h := 0.04394416)
    (by norm_num) (by norm_num) oscBlock33 vbpBr33.1 vbpBr34.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i34 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00270697):ℝ) ≤ ∫ v in (vBP 1.239)..(vBP 1.248), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.51304272) (m := (0:ℤ)) (ylo := 0.94224639) (yhi := 0.9422464)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.239) (q1 := 1.248) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.4286092) (B := 0.44308455) (X := 2.51304272) (rho := 0.04853984)
    (clo := (-0.80888098)) (chi := (-0.80888095)) (C := (-0.80888097)) (h := 0.04853986)
    (by norm_num) (by norm_num) oscBlock34 vbpBr34.1 vbpBr35.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i35 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00280031):ℝ) ≤ ∫ v in (vBP 1.248)..(vBP 1.258), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.60079879) (m := (0:ℤ)) (ylo := 1.03000246) (yhi := 1.03000247)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.248) (q1 := 1.258) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.44308453) (B := 0.45904632) (X := 2.60079879) (rho := 0.05306276)
    (clo := (-0.8573003)) (chi := (-0.85730025)) (C := (-0.85730028)) (h := 0.05306279)
    (by norm_num) (by norm_num) oscBlock35 vbpBr35.1 vbpBr36.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i36 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00252567):ℝ) ≤ ∫ v in (vBP 1.258)..(vBP 1.268), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.69246311) (m := (0:ℤ)) (ylo := 1.12166678) (yhi := 1.12166679)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.258) (q1 := 1.268) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.45904631) (B := 0.47488172) (X := 2.69246311) (rho := 0.05294685)
    (clo := (-0.90082548)) (chi := (-0.90082537)) (C := (-0.90082543)) (h := 0.05294691)
    (by norm_num) (by norm_num) oscBlock36 vbpBr36.1 vbpBr37.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i37 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00261048):ℝ) ≤ ∫ v in (vBP 1.268)..(vBP 1.28), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.79244475) (m := (0:ℤ)) (ylo := 1.22164842) (yhi := 1.22164843)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.268) (q1 := 1.28) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.4748817) (B := 0.49372017) (X := 2.79244475) (rho := 0.06187499)
    (clo := (-0.93966479)) (chi := (-0.93966455)) (C := (-0.93889478)) (h := 0.06110522)
    (by norm_num) (by norm_num) oscBlock37 vbpBr37.1 vbpBr38.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i38 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00228621):ℝ) ≤ ∫ v in (vBP 1.28)..(vBP 1.294), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.9094944) (m := (0:ℤ)) (ylo := 1.33869807) (yhi := 1.33869808)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.28) (q1 := 1.294) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.49372014) (B := 0.51547641) (X := 2.9094944) (rho := 0.07060361)
    (clo := (-0.97318652)) (chi := (-0.97318588)) (C := (-0.95129114)) (h := 0.04870887)
    (by norm_num) (by norm_num) oscBlock38 vbpBr38.1 vbpBr39.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i39 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00152768):ℝ) ≤ ∫ v in (vBP 1.294)..(vBP 1.308), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.03425596) (m := (0:ℤ)) (ylo := 1.46345963) (yhi := 1.46345964)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.294) (q1 := 1.308) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.51547638) (B := 0.53699853) (X := 3.03425596) (rho := 0.0702668)
    (clo := (-0.99424658)) (chi := (-0.99424492)) (C := (-0.96198906)) (h := 0.03801094)
    (by norm_num) (by norm_num) oscBlock39 vbpBr39.1 vbpBr40.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i40 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00099403):ℝ) ≤ ∫ v in (vBP 1.308)..(vBP 1.326), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.17514807) (m := (0:ℤ)) (ylo := 0.03355541) (yhi := 0.03355542)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.308) (q1 := 1.326) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.53699848) (B := 0.56433382) (X := 3.17514807) (rho := 0.08740683)
    (clo := (-0.99943708)) (chi := (-0.99943706)) (C := (-0.95601512)) (h := 0.04398489)
    (by norm_num) (by norm_num) oscBlock40 vbpBr40.1 vbpBr41.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i41 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    (0.0000163:ℝ) ≤ ∫ v in (vBP 1.326)..(vBP 1.345), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.33598754) (m := (0:ℤ)) (ylo := 0.19439488) (yhi := 0.19439489)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.326) (q1 := 1.345) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.56433374) (B := 0.59278808) (X := 3.33598754) (rho := 0.09106856)
    (clo := (-0.98116475)) (chi := (-0.98116474)) (C := (-0.94504809)) (h := 0.05495191)
    (by norm_num) (by norm_num) oscBlock41 vbpBr41.1 vbpBr42.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i42 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    (0.00088196:ℝ) ≤ ∫ v in (vBP 1.345)..(vBP 1.362), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.49040714) (m := (0:ℤ)) (ylo := 0.34881448) (yhi := 0.34881449)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.345) (q1 := 1.362) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.59278796) (B := 0.6179085) (X := 3.49040714) (rho := 0.08187639)
    (clo := (-0.93977857)) (chi := (-0.93977856)) (C := (-0.92895109)) (h := 0.07104892)
    (by norm_num) (by norm_num) oscBlock42 vbpBr42.1 vbpBr43.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i43 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    (0.00102609:ℝ) ≤ ∫ v in (vBP 1.362)..(vBP 1.376), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.62175039) (m := (0:ℤ)) (ylo := 0.48015773) (yhi := 0.48015774)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.362) (q1 := 1.376) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.61790831) (B := 0.6383616) (X := 3.62175039) (rho := 0.06877762)
    (clo := (-0.88692208)) (chi := (-0.88692207)) (C := (-0.88692208)) (h := 0.06877763)
    (by norm_num) (by norm_num) oscBlock43 vbpBr43.1 vbpBr44.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i44 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    (0.00112441:ℝ) ≤ ∫ v in (vBP 1.376)..(vBP 1.39), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.73907661) (m := (0:ℤ)) (ylo := 0.59748395) (yhi := 0.59748396)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.376) (q1 := 1.39) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.63836133) (B := 0.65860767) (X := 3.73907661) (rho := 0.06849899)
    (clo := (-0.82675368)) (chi := (-0.82675366)) (C := (-0.82675367)) (h := 0.068499)
    (by norm_num) (by norm_num) oscBlock44 vbpBr44.1 vbpBr45.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i45 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    (0.00109698:ℝ) ≤ ∫ v in (vBP 1.39)..(vBP 1.404), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.8552211) (m := (0:ℤ)) (ylo := 0.71362844) (yhi := 0.71362845)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.39) (q1 := 1.404) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.65860729) (B := 0.67865086) (X := 3.8552211) (rho := 0.0682292)
    (clo := (-0.75599176)) (chi := (-0.75599174)) (C := (-0.75599175)) (h := 0.06822921)
    (by norm_num) (by norm_num) oscBlock45 vbpBr45.1 vbpBr46.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i46 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    (0.00097149:ℝ) ≤ ∫ v in (vBP 1.404)..(vBP 1.418), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.97020735) (m := (0:ℤ)) (ylo := 0.82861469) (yhi := 0.8286147)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.404) (q1 := 1.418) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.67865033) (B := 0.69849519) (X := 3.97020735) (rho := 0.06796797)
    (clo := (-0.67589742)) (chi := (-0.67589736)) (C := (-0.67589739)) (h := 0.067968)
    (by norm_num) (by norm_num) oscBlock46 vbpBr46.1 vbpBr47.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i47 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    (0.00078073:ℝ) ≤ ∫ v in (vBP 1.418)..(vBP 1.432), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.0840583) (m := (0:ℤ)) (ylo := 0.94246564) (yhi := 0.94246565)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.418) (q1 := 1.432) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.69849446) (B := 0.7181446) (X := 4.0840583) (rho := 0.06771518)
    (clo := (-0.58779524)) (chi := (-0.58779507)) (C := (-0.58779516)) (h := 0.06771527)
    (by norm_num) (by norm_num) oscBlock47 vbpBr47.1 vbpBr48.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i48 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    (0.00055834:ℝ) ≤ ∫ v in (vBP 1.432)..(vBP 1.446), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.19679611) (m := (0:ℤ)) (ylo := 1.05520345) (yhi := 1.05520346)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.432) (q1 := 1.446) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.7181436) (B := 0.73760286) (X := 4.19679611) (rho := 0.06747043)
    (clo := (-0.49305121)) (chi := (-0.49305072)) (C := (-0.49305097)) (h := 0.06747068)
    (by norm_num) (by norm_num) oscBlock48 vbpBr48.1 vbpBr49.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i49 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    (0.00034827:ℝ) ≤ ∫ v in (vBP 1.446)..(vBP 1.462), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.31635662) (m := (0:ℤ)) (ylo := 1.17476396) (yhi := 1.17476397)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.446) (q1 := 1.462) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.73760153) (B := 0.75961158) (X := 4.31635662) (rho := 0.07514784)
    (clo := (-0.38576222)) (chi := (-0.38576083)) (C := (-0.38576153)) (h := 0.07514854)
    (by norm_num) (by norm_num) oscBlock49 vbpBr49.1 vbpBr50.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i50 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00026221):ℝ) ≤ ∫ v in (vBP 1.462)..(vBP 1.478), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.44255687) (m := (0:ℤ)) (ylo := 1.30096421) (yhi := 1.30096422)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.462) (q1 := 1.478) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.75960973) (B := 0.78138081) (X := 4.44255687) (rho := 0.07480095)
    (clo := (-0.26657342)) (chi := (-0.26656957)) (C := (-0.2665715)) (h := 0.07480288)
    (by norm_num) (by norm_num) oscBlock50 vbpBr50.1 vbpBr51.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i51 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.0003108):ℝ) ≤ ∫ v in (vBP 1.478)..(vBP 1.495), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.57125936) (m := (0:ℤ)) (ylo := 1.4296667) (yhi := 1.42966671)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.478) (q1 := 1.495) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.7813783) (B := 0.80425401) (X := 4.57125936) (rho := 0.07833415)
    (clo := (-0.14067129)) (chi := (-0.14066143)) (C := (-0.14066636)) (h := 0.07833908)
    (by norm_num) (by norm_num) oscBlock51 vbpBr51.1 vbpBr52.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i52 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00015963):ℝ) ≤ ∫ v in (vBP 1.495)..(vBP 1.512), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.70238775) (m := (0:ℤ)) (ylo := 1.56079509) (yhi := 1.5607951)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.495) (q1 := 1.512) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.80425056) (B := 0.82686872) (X := 4.70238775) (rho := 0.07794705)
    (clo := (-0.01002429)) (chi := (-0.01000062)) (C := (-0.01001246)) (h := 0.07795889)
    (by norm_num) (by norm_num) oscBlock52 vbpBr52.1 vbpBr53.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i53 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.0004195):ℝ) ≤ ∫ v in (vBP 1.512)..(vBP 1.531), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.83959923) (m := (0:ℤ)) (ylo := 0.12721024) (yhi := 0.12721025)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.512) (q1 := 1.531) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.82686405) (B := 0.85184522) (X := 4.83959923) (rho := 0.08513096)
    (clo := 0.12686742) (chi := 0.12686744) (C := 0.12686743) (h := 0.08513097)
    (by norm_num) (by norm_num) oscBlock53 vbpBr53.1 vbpBr54.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i54 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00063749):ℝ) ≤ ∫ v in (vBP 1.531)..(vBP 1.55), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.98270954) (m := (0:ℤ)) (ylo := 0.27032055) (yhi := 0.27032056)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.531) (q1 := 1.55) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.85183877) (B := 0.87651393) (X := 4.98270954) (rho := 0.08463663)
    (clo := 0.26704035) (chi := 0.26704037) (C := 0.26704036) (h := 0.08463664)
    (by norm_num) (by norm_num) oscBlock54 vbpBr54.1 vbpBr55.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i55 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00085929):ℝ) ≤ ∫ v in (vBP 1.55)..(vBP 1.57), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.12774924) (m := (0:ℤ)) (ylo := 0.41536025) (yhi := 0.41536026)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.55) (q1 := 1.57) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.87650515) (B := 0.90215678) (X := 5.12774924) (rho := 0.08784465)
    (clo := 0.40351957) (chi := 0.40351959) (C := 0.40351958) (h := 0.08784466)
    (by norm_num) (by norm_num) oscBlock55 vbpBr55.1 vbpBr56.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i56 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00099207):ℝ) ≤ ∫ v in (vBP 1.57)..(vBP 1.59), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.27465013) (m := (0:ℤ)) (ylo := 0.56226114) (yhi := 0.56226115)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.57) (q1 := 1.59) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.90214481) (B := 0.92747548) (X := 5.27465013) (rho := 0.0873175)
    (clo := 0.5331006) (chi := 0.53310061) (C := 0.5331006) (h := 0.08731751)
    (by norm_num) (by norm_num) oscBlock56 vbpBr56.1 vbpBr57.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i57 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00107843):ℝ) ≤ ∫ v in (vBP 1.59)..(vBP 1.61), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.41970318) (m := (0:ℤ)) (ylo := 0.70731419) (yhi := 0.7073142)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.59) (q1 := 1.61) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.92745939) (B := 0.95247825) (X := 5.41970318) (rho := 0.08681171)
    (clo := 0.6497946) (chi := 0.64979462) (C := 0.64979461) (h := 0.08681172)
    (by norm_num) (by norm_num) oscBlock57 vbpBr57.1 vbpBr58.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i58 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00126794):ℝ) ≤ ∫ v in (vBP 1.61)..(vBP 1.632), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.5700445) (m := (0:ℤ)) (ylo := 0.85765551) (yhi := 0.85765552)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.61) (q1 := 1.632) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.95245689) (B := 0.97962584) (X := 5.5700445) (rho := 0.0934174)
    (clo := 0.75631084) (chi := 0.75631086) (C := 0.75631085) (h := 0.09341741)
    (by norm_num) (by norm_num) oscBlock58 vbpBr58.1 vbpBr59.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i59 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00142794):ℝ) ≤ ∫ v in (vBP 1.632)..(vBP 1.656), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.73248579) (m := (0:ℤ)) (ylo := 1.0200968) (yhi := 1.02009681)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.632) (q1 := 1.656) (t0 := 5.75) (t1 := 5.78125)
    (A := 0.97959707) (B := 1.00882827) (X := 5.73248579) (rho := 0.09980266)
    (clo := 0.85215867) (chi := 0.85215872) (C := 0.85215869) (h := 0.09980269)
    (by norm_num) (by norm_num) oscBlock59 vbpBr59.1 vbpBr60.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i60 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00135601):ℝ) ≤ ∫ v in (vBP 1.656)..(vBP 1.68), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.89961564) (m := (0:ℤ)) (ylo := 1.18722665) (yhi := 1.18722666)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.656) (q1 := 1.68) (t0 := 5.75) (t1 := 5.78125)
    (A := 1.00878907) (B := 1.03761196) (X := 5.89961564) (rho := 0.09907851)
    (clo := 0.92733465) (chi := 0.92733483) (C := 0.91412807) (h := 0.08587193)
    (by norm_num) (by norm_num) oscBlock60 vbpBr60.1 vbpBr61.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i61 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00122808):ℝ) ≤ ∫ v in (vBP 1.68)..(vBP 1.704), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.06435796) (m := (0:ℤ)) (ylo := 1.35196897) (yhi := 1.35196898)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.68) (q1 := 1.704) (t0 := 5.75) (t1 := 5.78125)
    (A := 1.03755935) (B := 1.06598913) (X := 6.06435796) (rho := 0.09839171)
    (clo := 0.97615267) (chi := 0.97615337) (C := 0.93888048) (h := 0.06111952)
    (by norm_num) (by norm_num) oscBlock61 vbpBr61.1 vbpBr62.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i62 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00137159):ℝ) ≤ ∫ v in (vBP 1.704)..(vBP 1.734), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.24682719) (m := (0:ℤ)) (ylo := 1.5344382) (yhi := 1.53443821)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.704) (q1 := 1.734) (t0 := 5.75) (t1 := 5.78125)
    (A := 1.06591948) (B := 1.10090679) (X := 6.24682719) (rho := 0.1177902)
    (clo := 0.99933907) (chi := 0.99934186) (C := 0.94077443) (h := 0.05922557)
    (by norm_num) (by norm_num) oscBlock62 vbpBr62.1 vbpBr63.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i63 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00129873):ℝ) ≤ ∫ v in (vBP 1.734)..(vBP 1.766), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.45290541) (m := (1:ℤ)) (ylo := 0.1697201) (yhi := 0.16972011)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.734) (q1 := 1.766) (t0 := 5.75) (t1 := 5.78125)
    (A := 1.10080961) (B := 1.13749718) (X := 6.45290541) (rho := 0.12325017)
    (clo := 0.98563208) (chi := 0.98563209) (C := 0.93119095) (h := 0.06880905)
    (by norm_num) (by norm_num) oscBlock63 vbpBr63.1 vbpBr64.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i64 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00107612):ℝ) ≤ ∫ v in (vBP 1.766)..(vBP 1.796), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.65543897) (m := (1:ℤ)) (ylo := 0.37225366) (yhi := 0.37225367)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.766) (q1 := 1.796) (t0 := 5.75) (t1 := 5.78125)
    (A := 1.1373613) (B := 1.17120873) (X := 6.65543897) (rho := 0.11561151)
    (clo := 0.93151001) (chi := 0.93151003) (C := 0.90794925) (h := 0.09205075)
    (by norm_num) (by norm_num) oscBlock64 vbpBr64.1 vbpBr65.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i65 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00101497):ℝ) ≤ ∫ v in (vBP 1.796)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.85441014) (m := (1:ℤ)) (ylo := 0.57122483) (yhi := 0.57122484)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.796) (q1 := 1.828) (t0 := 5.75) (t1 := 5.78125)
    (A := 1.1710258) (B := 1.20655947) (X := 6.85441014) (rho := 0.12101181)
    (clo := 0.84123938) (chi := 0.84123939) (C := 0.84123938) (h := 0.12101182)
    (by norm_num) (by norm_num) oscBlock65 vbpBr65.1 vbpBr66.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i66 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00080711):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.86), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.05629622) (m := (1:ℤ)) (ylo := 0.77311091) (yhi := 0.77311092)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.828) (q1 := 1.86) (t0 := 5.75) (t1 := 5.78125)
    (A := 1.20631244) (B := 1.24130524) (X := 7.05629622) (rho := 0.11999971)
    (clo := 0.71574157) (chi := 0.71574161) (C := 0.71574159) (h := 0.11999973)
    (by norm_num) (by norm_num) oscBlock66 vbpBr66.1 vbpBr67.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i67 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00054847):ℝ) ≤ ∫ v in (vBP 1.86)..(vBP 1.89), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.24858558) (m := (1:ℤ)) (ylo := 0.96540027) (yhi := 0.96540028)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.86) (q1 := 1.89) (t0 := 5.75) (t1 := 5.78125)
    (A := 1.24097685) (B := 1.27334993) (X := 7.24858558) (rho := 0.11296871)
    (clo := 0.56908777) (chi := 0.56908799) (C := 0.56908788) (h := 0.11296882)
    (by norm_num) (by norm_num) oscBlock67 vbpBr67.1 vbpBr68.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i68 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00040512):ℝ) ≤ ∫ v in (vBP 1.89)..(vBP 1.922), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.43767246) (m := (1:ℤ)) (ylo := 1.15448715) (yhi := 1.15448716)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.89) (q1 := 1.922) (t0 := 5.75) (t1 := 5.78125)
    (A := 1.27292668) (B := 1.30698664) (X := 7.43767246) (rho := 0.11834407)
    (clo := 0.40438761) (chi := 0.40438879) (C := 0.4043882) (h := 0.11834466)
    (by norm_num) (by norm_num) oscBlock68 vbpBr68.1 vbpBr69.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i69 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.0003388):ℝ) ≤ ∫ v in (vBP 1.922)..(vBP 1.969), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.67400699) (m := (1:ℤ)) (ylo := 1.39082168) (yhi := 1.39082169)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.922) (q1 := 1.969) (t0 := 5.75) (t1 := 5.78125)
    (A := 1.30643896) (B := 1.35541448) (X := 7.67400699) (rho := 0.16198299)
    (clo := 0.17900451) (chi := 0.17901199) (C := 0.17900825) (h := 0.16198673)
    (by norm_num) (by norm_num) oscBlock69 vbpBr69.1 vbpBr70.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i70 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00022451):ℝ) ≤ ∫ v in (vBP 1.969)..(vBP 2.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 7.94935409) (m := (1:ℤ)) (ylo := 0.09537245) (yhi := 0.09537246)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.969) (q1 := 2.016) (t0 := 5.75) (t1 := 5.78125)
    (A := 1.35463226) (B := 1.4027369) (X := 7.94935409) (rho := 0.16021862)
    (clo := (-0.09522795)) (chi := (-0.09522793)) (C := (-0.09522794)) (h := 0.16021863)
    (by norm_num) (by norm_num) oscBlock70 vbpBr70.1 vbpBr71.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i71 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00040078):ℝ) ≤ ∫ v in (vBP 2.016)..(vBP 2.062), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.21547157) (m := (1:ℤ)) (ylo := 0.36148993) (yhi := 0.36148994)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.016) (q1 := 2.062) (t0 := 5.75) (t1 := 5.78125)
    (A := 1.40164597) (B := 1.44803958) (X := 8.21547157) (rho := 0.15600726)
    (clo := (-0.35366828)) (chi := (-0.35366826)) (C := (-0.35366827)) (h := 0.15600727)
    (by norm_num) (by norm_num) oscBlock71 vbpBr71.1 vbpBr72.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB18i72 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.00033964):ℝ) ≤ ∫ v in (vBP 2.062)..(vBP 2.094), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.43407096) (m := (1:ℤ)) (ylo := 0.58008932) (yhi := 0.58008933)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.062) (q1 := 2.094) (t0 := 5.75) (t1 := 5.78125)
    (A := 1.44655973) (B := 1.47899217) (X := 8.43407096) (rho := 0.11635253)
    (clo := (-0.54809866)) (chi := (-0.54809864)) (C := (-0.54809865)) (h := 0.11635254)
    (by norm_num) (by norm_num) oscBlock72 vbpBr72.1 vbpBr73.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

/-- Lower bound for the oscillatory integral `∫₀^∞ err(v) cos(tv) dv` on the band
`5.75 ≤ t ≤ 5.78125`. -/
theorem oscBandLower18 {t : ℝ} (ht0 : (5.75:ℝ) ≤ t) (ht1 : t ≤ 5.78125) :
    ((-0.11435119):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosB18i0 ht0 ht1)
    (cosB18i1 ht0 ht1))
    (cosB18i2 ht0 ht1))
    (cosB18i3 ht0 ht1))
    (cosB18i4 ht0 ht1))
    (cosB18i5 ht0 ht1))
    (cosB18i6 ht0 ht1))
    (cosB18i7 ht0 ht1))
    (cosB18i8 ht0 ht1))
    (cosB18i9 ht0 ht1))
    (cosB18i10 ht0 ht1))
    (cosB18i11 ht0 ht1))
    (cosB18i12 ht0 ht1))
    (cosB18i13 ht0 ht1))
    (cosB18i14 ht0 ht1))
    (cosB18i15 ht0 ht1))
    (cosB18i16 ht0 ht1))
    (cosB18i17 ht0 ht1))
    (cosB18i18 ht0 ht1))
    (cosB18i19 ht0 ht1))
    (cosB18i20 ht0 ht1))
    (cosB18i21 ht0 ht1))
    (cosB18i22 ht0 ht1))
    (cosB18i23 ht0 ht1))
    (cosB18i24 ht0 ht1))
    (cosB18i25 ht0 ht1))
    (cosB18i26 ht0 ht1))
    (cosB18i27 ht0 ht1))
    (cosB18i28 ht0 ht1))
    (cosB18i29 ht0 ht1))
    (cosB18i30 ht0 ht1))
    (cosB18i31 ht0 ht1))
    (cosB18i32 ht0 ht1))
    (cosB18i33 ht0 ht1))
    (cosB18i34 ht0 ht1))
    (cosB18i35 ht0 ht1))
    (cosB18i36 ht0 ht1))
    (cosB18i37 ht0 ht1))
    (cosB18i38 ht0 ht1))
    (cosB18i39 ht0 ht1))
    (cosB18i40 ht0 ht1))
    (cosB18i41 ht0 ht1))
    (cosB18i42 ht0 ht1))
    (cosB18i43 ht0 ht1))
    (cosB18i44 ht0 ht1))
    (cosB18i45 ht0 ht1))
    (cosB18i46 ht0 ht1))
    (cosB18i47 ht0 ht1))
    (cosB18i48 ht0 ht1))
    (cosB18i49 ht0 ht1))
    (cosB18i50 ht0 ht1))
    (cosB18i51 ht0 ht1))
    (cosB18i52 ht0 ht1))
    (cosB18i53 ht0 ht1))
    (cosB18i54 ht0 ht1))
    (cosB18i55 ht0 ht1))
    (cosB18i56 ht0 ht1))
    (cosB18i57 ht0 ht1))
    (cosB18i58 ht0 ht1))
    (cosB18i59 ht0 ht1))
    (cosB18i60 ht0 ht1))
    (cosB18i61 ht0 ht1))
    (cosB18i62 ht0 ht1))
    (cosB18i63 ht0 ht1))
    (cosB18i64 ht0 ht1))
    (cosB18i65 ht0 ht1))
    (cosB18i66 ht0 ht1))
    (cosB18i67 ht0 ht1))
    (cosB18i68 ht0 ht1))
    (cosB18i69 ht0 ht1))
    (cosB18i70 ht0 ht1))
    (cosB18i71 ht0 ht1))
    (cosB18i72 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 2.094) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 2.094) (S := 0.013709)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_cut
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
