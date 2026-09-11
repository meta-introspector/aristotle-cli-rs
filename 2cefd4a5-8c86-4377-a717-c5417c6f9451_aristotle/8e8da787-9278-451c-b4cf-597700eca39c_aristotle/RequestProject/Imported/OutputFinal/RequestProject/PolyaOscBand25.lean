/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscTail

/-!
# Oscillatory lower bound on the band `5.53125 ≤ t ≤ 5.5625`

On each of the 73 blocks the factor `cos(tv)` is bracketed by a rational constant
`C` up to a rational error `h`; the signed contribution `min(C·P₀, C·P₁) - h·S` is
then summed, and the unresolved tail beyond `q = 2.094` is estimated in absolute
value.  The result is the bound `∫₀^∞ err(v) cos(tv) dv ≥ -0.10746023`.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosB25i0 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00641868):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.0038), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.02109745) (m := (0:ℤ)) (ylo := 0.02109745) (yhi := 0.02109745)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1) (q1 := 1.0038) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.0) (B := 0.0075856) (X := 0.02109745) (rho := 0.02109746)
    (clo := 0.99977745) (chi := 0.99977746) (C := 0.98933999) (h := 0.01066001)
    (by norm_num) (by norm_num) oscBlock0 vbpBr0.1 vbpBr1.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i1 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00625872):ℝ) ≤ ∫ v in (vBP 1.0038)..(vBP 1.0078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.06419807) (m := (0:ℤ)) (ylo := 0.06419807) (yhi := 0.06419807)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0038) (q1 := 1.0078) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.00758559) (B := 0.01553948) (X := 0.06419807) (rho := 0.0222403)
    (clo := 0.99794001) (chi := 0.99794002) (C := 0.98784985) (h := 0.01215015)
    (by norm_num) (by norm_num) oscBlock1 vbpBr1.1 vbpBr2.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i2 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.0057677):ℝ) ≤ ∫ v in (vBP 1.0078)..(vBP 1.0118), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.10822961) (m := (0:ℤ)) (ylo := 0.10822961) (yhi := 0.10822961)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0078) (q1 := 1.0118) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.01553947) (B := 0.02346185) (X := 0.10822961) (rho := 0.02227694)
    (clo := 0.99414889) (chi := 0.9941489) (C := 0.98593597) (h := 0.01406403)
    (by norm_num) (by norm_num) oscBlock2 vbpBr2.1 vbpBr3.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i3 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00554846):ℝ) ≤ ∫ v in (vBP 1.0118)..(vBP 1.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.15318216) (m := (0:ℤ)) (ylo := 0.15318216) (yhi := 0.15318216)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0118) (q1 := 1.016) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.02346184) (B := 0.0317467) (X := 0.15318216) (rho := 0.02340887)
    (clo := 0.98829053) (chi := 0.98829054) (C := 0.98244083) (h := 0.01755917)
    (by norm_num) (by norm_num) oscBlock3 vbpBr3.1 vbpBr4.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i4 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00539232):ℝ) ≤ ∫ v in (vBP 1.016)..(vBP 1.0205), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.20067761) (m := (0:ℤ)) (ylo := 0.20067761) (yhi := 0.20067761)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.016) (q1 := 1.0205) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.03174669) (B := 0.04058541) (X := 0.20067761) (rho := 0.02507875)
    (clo := 0.97993173) (chi := 0.97993174) (C := 0.97742649) (h := 0.02257351)
    (by norm_num) (by norm_num) oscBlock4 vbpBr4.1 vbpBr5.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i5 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00482245):ℝ) ≤ ∫ v in (vBP 1.0205)..(vBP 1.025), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.24959666) (m := (0:ℤ)) (ylo := 0.24959666) (yhi := 0.24959666)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0205) (q1 := 1.025) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.0405854) (B := 0.04938523) (X := 0.24959666) (rho := 0.02510869)
    (clo := 0.96901213) (chi := 0.96901214) (C := 0.96901213) (h := 0.0251087)
    (by norm_num) (by norm_num) oscBlock5 vbpBr5.1 vbpBr6.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i6 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00470882):ℝ) ≤ ∫ v in (vBP 1.025)..(vBP 1.03), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.30100185) (m := (0:ℤ)) (ylo := 0.30100185) (yhi := 0.30100185)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.025) (q1 := 1.03) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.04938522) (B := 0.05911761) (X := 0.30100185) (rho := 0.02783987)
    (clo := 0.95503994) (chi := 0.95503995) (C := 0.95503994) (h := 0.02783988)
    (by norm_num) (by norm_num) oscBlock6 vbpBr6.1 vbpBr7.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i7 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00441773):ℝ) ≤ ∫ v in (vBP 1.03)..(vBP 1.0355), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.35754161) (m := (0:ℤ)) (ylo := 0.35754161) (yhi := 0.35754161)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.03) (q1 := 1.0355) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.0591176) (B := 0.06976881) (X := 0.35754161) (rho := 0.03054741)
    (clo := 0.93676002) (chi := 0.93676003) (C := 0.93676002) (h := 0.03054742)
    (by norm_num) (by norm_num) oscBlock7 vbpBr7.1 vbpBr8.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i8 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00396851):ℝ) ≤ ∫ v in (vBP 1.0355)..(vBP 1.0415), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.41913662) (m := (0:ℤ)) (ylo := 0.41913662) (yhi := 0.41913662)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0355) (q1 := 1.0415) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.0697688) (B := 0.08132397) (X := 0.41913662) (rho := 0.03322797)
    (clo := 0.91344065) (chi := 0.91344066) (C := 0.91344065) (h := 0.03322798)
    (by norm_num) (by norm_num) oscBlock8 vbpBr8.1 vbpBr9.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i9 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00338571):ℝ) ≤ ∫ v in (vBP 1.0415)..(vBP 1.048), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.48570154) (m := (0:ℤ)) (ylo := 0.48570154) (yhi := 0.48570154)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0415) (q1 := 1.048) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.08132396) (B := 0.09376718) (X := 0.48570154) (rho := 0.03587841)
    (clo := 0.88434766) (chi := 0.88434767) (C := 0.88434766) (h := 0.03587842)
    (by norm_num) (by norm_num) oscBlock9 vbpBr9.1 vbpBr10.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i10 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00271947):ℝ) ≤ ∫ v in (vBP 1.048)..(vBP 1.055), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.55714536) (m := (0:ℤ)) (ylo := 0.55714536) (yhi := 0.55714536)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.048) (q1 := 1.055) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.09376717) (B := 0.10708154) (X := 0.55714536) (rho := 0.03849572)
    (clo := 0.848768) (chi := 0.84876801) (C := 0.848768) (h := 0.03849573)
    (by norm_num) (by norm_num) oscBlock10 vbpBr10.1 vbpBr11.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i11 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00226727):ℝ) ≤ ∫ v in (vBP 1.055)..(vBP 1.064), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.64121924) (m := (0:ℤ)) (ylo := 0.64121924) (yhi := 0.64121924)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.055) (q1 := 1.064) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.10708153) (B := 0.12407079) (X := 0.64121924) (rho := 0.04892454)
    (clo := 0.80136703) (chi := 0.80136705) (C := 0.80136704) (h := 0.04892455)
    (by norm_num) (by norm_num) oscBlock11 vbpBr11.1 vbpBr12.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i12 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00148605):ℝ) ≤ ∫ v in (vBP 1.064)..(vBP 1.078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.76091858) (m := (0:ℤ)) (ylo := 0.76091858) (yhi := 0.76091858)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.064) (q1 := 1.078) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.12407078) (B := 0.15021495) (X := 0.76091858) (rho := 0.07465209)
    (clo := 0.72420287) (chi := 0.7242029) (C := 0.72420288) (h := 0.07465211)
    (by norm_num) (by norm_num) oscBlock12 vbpBr12.1 vbpBr13.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i13 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    (0.00021476:ℝ) ≤ ∫ v in (vBP 1.078)..(vBP 1.09), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.89480164) (m := (0:ℤ)) (ylo := 0.89480164) (yhi := 0.89480164)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.078) (q1 := 1.09) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.15021494) (B := 0.1723554) (X := 0.89480164) (rho := 0.06392528)
    (clo := 0.62567356) (chi := 0.62567366) (C := 0.62567361) (h := 0.06392533)
    (by norm_num) (by norm_num) oscBlock13 vbpBr13.1 vbpBr14.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i14 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    (0.0008195:ℝ) ≤ ∫ v in (vBP 1.09)..(vBP 1.1), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.00683325) (m := (0:ℤ)) (ylo := 1.00683325) (yhi := 1.00683325)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.09) (q1 := 1.1) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.17235539) (B := 0.19062036) (X := 1.00683325) (rho := 0.05349252)
    (clo := 0.53453975) (chi := 0.53454005) (C := 0.5345399) (h := 0.05349267)
    (by norm_num) (by norm_num) oscBlock14 vbpBr14.1 vbpBr15.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i15 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    (0.00095335:ℝ) ≤ ∫ v in (vBP 1.1)..(vBP 1.109), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.10267347) (m := (0:ℤ)) (ylo := 1.10267347) (yhi := 1.10267347)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.1) (q1 := 1.109) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.19062035) (B := 0.20691742) (X := 1.10267347) (rho := 0.04830468)
    (clo := 0.45121188) (chi := 0.45121262) (C := 0.45121225) (h := 0.04830505)
    (by norm_num) (by norm_num) oscBlock15 vbpBr15.1 vbpBr16.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i16 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    (0.00086517:ℝ) ≤ ∫ v in (vBP 1.109)..(vBP 1.117), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.18772725) (m := (0:ℤ)) (ylo := 1.18772725) (yhi := 1.18772725)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.109) (q1 := 1.117) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.20691741) (B := 0.22129305) (X := 1.18772725) (rho := 0.04321535)
    (clo := 0.37376884) (chi := 0.37377039) (C := 0.37376961) (h := 0.04321613)
    (by norm_num) (by norm_num) oscBlock16 vbpBr16.1 vbpBr17.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i17 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    (0.00069505:ℝ) ≤ ∫ v in (vBP 1.117)..(vBP 1.124), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.26223507) (m := (0:ℤ)) (ylo := 1.26223507) (yhi := 1.26223507)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.117) (q1 := 1.124) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.22129304) (B := 0.23378751) (X := 1.26223507) (rho := 0.03820796)
    (clo := 0.30368812) (chi := 0.30369096) (C := 0.30368954) (h := 0.03820938)
    (by norm_num) (by norm_num) oscBlock17 vbpBr17.1 vbpBr18.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i18 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    (0.00056784:ℝ) ≤ ∫ v in (vBP 1.124)..(vBP 1.131), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.33132454) (m := (0:ℤ)) (ylo := 1.33132454) (yhi := 1.33132454)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.124) (q1 := 1.131) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.2337875) (B := 0.2462044) (X := 1.33132454) (rho := 0.03818745)
    (clo := 0.23718945) (chi := 0.23719428) (C := 0.23719186) (h := 0.03818987)
    (by norm_num) (by norm_num) oscBlock18 vbpBr18.1 vbpBr19.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i19 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    (0.00039776:ℝ) ≤ ∫ v in (vBP 1.131)..(vBP 1.138), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.3999864) (m := (0:ℤ)) (ylo := 1.3999864) (yhi := 1.3999864)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.131) (q1 := 1.138) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.24620439) (B := 0.25854468) (X := 1.3999864) (rho := 0.03816839)
    (clo := 0.16998042) (chi := 0.1699884) (C := 0.16998441) (h := 0.03817238)
    (by norm_num) (by norm_num) oscBlock19 vbpBr19.1 vbpBr20.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i20 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    (0.00020041:ℝ) ≤ ∫ v in (vBP 1.138)..(vBP 1.145), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.46822591) (m := (0:ℤ)) (ylo := 1.46822591) (yhi := 1.46822591)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.138) (q1 := 1.145) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.25854467) (B := 0.27080928) (X := 1.46822591) (rho := 0.03815072)
    (clo := 0.10239045) (chi := 0.10240329) (C := 0.10239687) (h := 0.03815714)
    (by norm_num) (by norm_num) oscBlock20 vbpBr20.1 vbpBr21.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i21 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.0000256):ℝ) ≤ ∫ v in (vBP 1.145)..(vBP 1.152), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.53604821) (m := (0:ℤ)) (ylo := 1.53604821) (yhi := 1.53604821)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.145) (q1 := 1.152) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.27080927) (B := 0.28299913) (X := 1.53604821) (rho := 0.03813446)
    (clo := 0.03474076) (chi := 0.03476092) (C := 0.03475084) (h := 0.03814454)
    (by norm_num) (by norm_num) oscBlock21 vbpBr21.1 vbpBr22.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i22 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00027615):ℝ) ≤ ∫ v in (vBP 1.152)..(vBP 1.159), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.60345839) (m := (0:ℤ)) (ylo := 0.03266206) (yhi := 0.03266207)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.152) (q1 := 1.159) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.28299912) (B := 0.29511513) (X := 1.60345839) (rho := 0.03811953)
    (clo := (-0.03265627)) (chi := (-0.03265625)) (C := (-0.03265626)) (h := 0.03811954)
    (by norm_num) (by norm_num) oscBlock22 vbpBr22.1 vbpBr23.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i23 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00054148):ℝ) ≤ ∫ v in (vBP 1.159)..(vBP 1.166), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.67046144) (m := (0:ℤ)) (ylo := 0.09966511) (yhi := 0.09966512)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.159) (q1 := 1.166) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.29511512) (B := 0.30715818) (X := 1.67046144) (rho := 0.03810595)
    (clo := (-0.09950021)) (chi := (-0.09950019)) (C := (-0.0995002)) (h := 0.03810596)
    (by norm_num) (by norm_num) oscBlock23 vbpBr23.1 vbpBr24.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i24 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.0008007):ℝ) ≤ ∫ v in (vBP 1.166)..(vBP 1.173), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.73706223) (m := (0:ℤ)) (ylo := 0.1662659) (yhi := 0.16626591)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.166) (q1 := 1.173) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.30715817) (B := 0.31912914) (X := 1.73706223) (rho := 0.03809362)
    (clo := (-0.16550092)) (chi := (-0.1655009)) (C := (-0.16550091)) (h := 0.03809363)
    (by norm_num) (by norm_num) oscBlock24 vbpBr24.1 vbpBr25.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i25 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00104643):ℝ) ≤ ∫ v in (vBP 1.173)..(vBP 1.18), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.80326557) (m := (0:ℤ)) (ylo := 0.23246924) (yhi := 0.23246925)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.173) (q1 := 1.18) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.31912913) (B := 0.33102888) (X := 1.80326557) (rho := 0.03808259)
    (clo := (-0.23038106)) (chi := (-0.23038104)) (C := (-0.23038105)) (h := 0.0380826)
    (by norm_num) (by norm_num) oscBlock25 vbpBr25.1 vbpBr26.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i26 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00127229):ℝ) ≤ ∫ v in (vBP 1.18)..(vBP 1.187), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.86907619) (m := (0:ℤ)) (ylo := 0.29827986) (yhi := 0.29827987)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.18) (q1 := 1.187) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.33102887) (B := 0.34285824) (X := 1.86907619) (rho := 0.03807278)
    (clo := (-0.29387647)) (chi := (-0.29387645)) (C := (-0.29387646)) (h := 0.03807279)
    (by norm_num) (by norm_num) oscBlock26 vbpBr26.1 vbpBr27.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i27 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00147295):ℝ) ≤ ∫ v in (vBP 1.187)..(vBP 1.194), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.93449871) (m := (0:ℤ)) (ylo := 0.36370238) (yhi := 0.36370239)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.187) (q1 := 1.194) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.34285823) (B := 0.35461804) (X := 1.93449871) (rho := 0.03806415)
    (clo := (-0.35573687)) (chi := (-0.35573685)) (C := (-0.35573686)) (h := 0.03806416)
    (by norm_num) (by norm_num) oscBlock27 vbpBr27.1 vbpBr28.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i28 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00166103):ℝ) ≤ ∫ v in (vBP 1.194)..(vBP 1.201), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.99953761) (m := (0:ℤ)) (ylo := 0.42874128) (yhi := 0.42874129)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.194) (q1 := 1.201) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.35461802) (B := 0.36630909) (X := 1.99953761) (rho := 0.03805671)
    (clo := (-0.41572635)) (chi := (-0.41572633)) (C := (-0.41572634)) (h := 0.03805672)
    (by norm_num) (by norm_num) oscBlock28 vbpBr28.1 vbpBr29.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i29 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00180141):ℝ) ≤ ∫ v in (vBP 1.201)..(vBP 1.208), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.06419748) (m := (0:ℤ)) (ylo := 0.49340115) (yhi := 0.49340116)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.201) (q1 := 1.208) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.36630908) (B := 0.3779322) (X := 2.06419748) (rho := 0.0380504)
    (clo := (-0.47362412)) (chi := (-0.4736241)) (C := (-0.47362411)) (h := 0.03805041)
    (by norm_num) (by norm_num) oscBlock29 vbpBr29.1 vbpBr30.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i30 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00190677):ℝ) ≤ ∫ v in (vBP 1.208)..(vBP 1.215), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.12848265) (m := (0:ℤ)) (ylo := 0.55768632) (yhi := 0.55768633)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.208) (q1 := 1.215) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.37793219) (B := 0.38948816) (X := 2.12848265) (rho := 0.03804525)
    (clo := (-0.52922451)) (chi := (-0.5292245)) (C := (-0.52922451)) (h := 0.03804526)
    (by norm_num) (by norm_num) oscBlock30 vbpBr30.1 vbpBr31.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i31 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00227867):ℝ) ≤ ∫ v in (vBP 1.215)..(vBP 1.223), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.19694757) (m := (0:ℤ)) (ylo := 0.62615124) (yhi := 0.62615125)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.215) (q1 := 1.223) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.38948815) (B := 0.40261372) (X := 2.19694757) (rho := 0.04259126)
    (clo := (-0.58603051)) (chi := (-0.58603049)) (C := (-0.5860305)) (h := 0.04259127)
    (by norm_num) (by norm_num) oscBlock31 vbpBr31.1 vbpBr32.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i32 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00231361):ℝ) ≤ ∫ v in (vBP 1.223)..(vBP 1.231), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.26951539) (m := (0:ℤ)) (ylo := 0.69871906) (yhi := 0.69871907)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.223) (q1 := 1.231) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.40261371) (B := 0.4156537) (X := 2.26951539) (rho := 0.04255833)
    (clo := (-0.64323746)) (chi := (-0.64323744)) (C := (-0.64323745)) (h := 0.04255834)
    (by norm_num) (by norm_num) oscBlock32 vbpBr32.1 vbpBr33.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i33 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00229565):ℝ) ≤ ∫ v in (vBP 1.231)..(vBP 1.239), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.3416116) (m := (0:ℤ)) (ylo := 0.77081527) (yhi := 0.77081528)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.231) (q1 := 1.239) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.41565369) (B := 0.42860921) (X := 2.3416116) (rho := 0.04252714)
    (clo := (-0.69672031)) (chi := (-0.69672029)) (C := (-0.6967203)) (h := 0.04252715)
    (by norm_num) (by norm_num) oscBlock33 vbpBr33.1 vbpBr34.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i34 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00251366):ℝ) ≤ ∫ v in (vBP 1.239)..(vBP 1.248), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.41770122) (m := (0:ℤ)) (ylo := 0.84690489) (yhi := 0.8469049)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.239) (q1 := 1.248) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.4286092) (B := 0.44308455) (X := 2.41770122) (rho := 0.0469566)
    (clo := (-0.74923411)) (chi := (-0.74923408)) (C := (-0.7492341)) (h := 0.04695662)
    (by norm_num) (by norm_num) oscBlock34 vbpBr34.1 vbpBr35.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i35 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00262611):ℝ) ≤ ∫ v in (vBP 1.248)..(vBP 1.258), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.50212823) (m := (0:ℤ)) (ylo := 0.9313319) (yhi := 0.93133191)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.248) (q1 := 1.258) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.44308453) (B := 0.45904632) (X := 2.50212823) (rho := 0.05131694)
    (clo := (-0.80241551)) (chi := (-0.80241548)) (C := (-0.8024155)) (h := 0.05131696)
    (by norm_num) (by norm_num) oscBlock35 vbpBr35.1 vbpBr36.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i36 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00239141):ℝ) ≤ ∫ v in (vBP 1.258)..(vBP 1.268), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.59031473) (m := (0:ℤ)) (ylo := 1.0195184) (yhi := 1.01951841)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.258) (q1 := 1.268) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.45904631) (B := 0.47488172) (X := 2.59031473) (rho := 0.05121485)
    (clo := (-0.85185591)) (chi := (-0.85185586)) (C := (-0.85185589)) (h := 0.05121488)
    (by norm_num) (by norm_num) oscBlock36 vbpBr36.1 vbpBr37.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i37 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00250094):ℝ) ≤ ∫ v in (vBP 1.268)..(vBP 1.28), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.68650392) (m := (0:ℤ)) (ylo := 1.11570759) (yhi := 1.1157076)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.268) (q1 := 1.28) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.4748817) (B := 0.49372017) (X := 2.68650392) (rho := 0.05981454)
    (clo := (-0.89822212)) (chi := (-0.89822202)) (C := (-0.89822207)) (h := 0.05981459)
    (by norm_num) (by norm_num) oscBlock37 vbpBr37.1 vbpBr38.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i38 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.0022862):ℝ) ≤ ∫ v in (vBP 1.28)..(vBP 1.294), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.79911352) (m := (0:ℤ)) (ylo := 1.22831719) (yhi := 1.2283172)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.28) (q1 := 1.294) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.49372014) (B := 0.51547641) (X := 2.79911352) (rho := 0.06822402)
    (clo := (-0.94192526)) (chi := (-0.941925)) (C := (-0.93685049)) (h := 0.06314951)
    (by norm_num) (by norm_num) oscBlock38 vbpBr38.1 vbpBr39.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i39 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00152768):ℝ) ≤ ∫ v in (vBP 1.294)..(vBP 1.308), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.91914152) (m := (0:ℤ)) (ylo := 1.34834519) (yhi := 1.3483452)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.294) (q1 := 1.308) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.51547638) (B := 0.53699853) (X := 2.91914152) (rho := 0.06791281)
    (clo := (-0.97536028)) (chi := (-0.97535959)) (C := (-0.95372339)) (h := 0.04627661)
    (by norm_num) (by norm_num) oscBlock39 vbpBr39.1 vbpBr40.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i40 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00099404):ℝ) ≤ ∫ v in (vBP 1.308)..(vBP 1.326), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.05468985) (m := (0:ℤ)) (ylo := 1.48389352) (yhi := 1.48389353)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.308) (q1 := 1.326) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.53699848) (B := 0.56433382) (X := 3.05468985) (rho := 0.08441703)
    (clo := (-0.99622823)) (chi := (-0.9962263)) (C := (-0.95590464)) (h := 0.04409537)
    (by norm_num) (by norm_num) oscBlock40 vbpBr40.1 vbpBr41.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i41 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    (0.00003378:ℝ) ≤ ∫ v in (vBP 1.326)..(vBP 1.345), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.20942734) (m := (0:ℤ)) (ylo := 0.06783468) (yhi := 0.06783469)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.326) (q1 := 1.345) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.56433374) (B := 0.59278808) (X := 3.20942734) (rho := 0.08795636)
    (clo := (-0.99770012)) (chi := (-0.9977001)) (C := (-0.95487187)) (h := 0.04512813)
    (by norm_num) (by norm_num) oscBlock41 vbpBr41.1 vbpBr42.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i42 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    (0.00094297:ℝ) ≤ ∫ v in (vBP 1.345)..(vBP 1.362), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.35798721) (m := (0:ℤ)) (ylo := 0.21639455) (yhi := 0.21639456)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.345) (q1 := 1.362) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.59278796) (B := 0.6179085) (X := 3.35798721) (rho := 0.07912883)
    (clo := (-0.97667793)) (chi := (-0.97667791)) (C := (-0.94877454)) (h := 0.05122546)
    (by norm_num) (by norm_num) oscBlock42 vbpBr42.1 vbpBr43.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i43 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    (0.00110513:ℝ) ≤ ∫ v in (vBP 1.362)..(vBP 1.376), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.48434586) (m := (0:ℤ)) (ylo := 0.3427532) (yhi := 0.34275321)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.362) (q1 := 1.376) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.61790831) (B := 0.6383616) (X := 3.48434586) (rho := 0.06654055)
    (clo := (-0.94183294)) (chi := (-0.94183293)) (C := (-0.93764619)) (h := 0.06235381)
    (by norm_num) (by norm_num) oscBlock43 vbpBr43.1 vbpBr44.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i44 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    (0.00123878:ℝ) ≤ ∫ v in (vBP 1.376)..(vBP 1.39), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.59722063) (m := (0:ℤ)) (ylo := 0.45562797) (yhi := 0.45562798)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.376) (q1 := 1.39) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.63836133) (B := 0.65860767) (X := 3.59722063) (rho := 0.06628454)
    (clo := (-0.89798489)) (chi := (-0.89798487)) (C := (-0.89798488)) (h := 0.06628455)
    (by norm_num) (by norm_num) oscBlock44 vbpBr44.1 vbpBr45.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i45 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    (0.00124626:ℝ) ≤ ∫ v in (vBP 1.39)..(vBP 1.404), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.70895849) (m := (0:ℤ)) (ylo := 0.56736583) (yhi := 0.56736584)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.39) (q1 := 1.404) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.65860729) (B := 0.67865086) (X := 3.70895849) (rho := 0.06603693)
    (clo := (-0.84331954)) (chi := (-0.84331952)) (C := (-0.84331953)) (h := 0.06603694)
    (by norm_num) (by norm_num) oscBlock45 vbpBr45.1 vbpBr46.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i46 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    (0.00114742:ℝ) ≤ ∫ v in (vBP 1.404)..(vBP 1.418), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.81958206) (m := (0:ℤ)) (ylo := 0.6779894) (yhi := 0.67798941)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.404) (q1 := 1.418) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.67865033) (B := 0.69849519) (X := 3.81958206) (rho := 0.06579744)
    (clo := (-0.77883541)) (chi := (-0.77883539)) (C := (-0.7788354)) (h := 0.06579745)
    (by norm_num) (by norm_num) oscBlock46 vbpBr46.1 vbpBr47.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i47 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    (0.00097112:ℝ) ≤ ∫ v in (vBP 1.418)..(vBP 1.432), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.9291134) (m := (0:ℤ)) (ylo := 0.78752074) (yhi := 0.78752075)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.418) (q1 := 1.432) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.69849446) (B := 0.7181446) (X := 3.9291134) (rho := 0.06556594)
    (clo := (-0.70560433)) (chi := (-0.70560429)) (C := (-0.70560431)) (h := 0.06556596)
    (by norm_num) (by norm_num) oscBlock47 vbpBr47.1 vbpBr48.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i48 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    (0.00074858:ℝ) ≤ ∫ v in (vBP 1.432)..(vBP 1.446), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.03757384) (m := (0:ℤ)) (ylo := 0.89598118) (yhi := 0.89598119)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.432) (q1 := 1.446) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.7181436) (B := 0.73760286) (X := 4.03757384) (rho := 0.06534208)
    (clo := (-0.62475309)) (chi := (-0.62475298)) (C := (-0.62475304)) (h := 0.06534214)
    (by norm_num) (by norm_num) oscBlock48 vbpBr48.1 vbpBr49.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i49 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    (0.00054653:ℝ) ≤ ∫ v in (vBP 1.446)..(vBP 1.462), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.15259893) (m := (0:ℤ)) (ylo := 1.01100627) (yhi := 1.01100628)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.446) (q1 := 1.462) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.73760153) (B := 0.75961158) (X := 4.15259893) (rho := 0.07274049)
    (clo := (-0.53100862)) (chi := (-0.53100829)) (C := (-0.53100846)) (h := 0.07274066)
    (by norm_num) (by norm_num) oscBlock49 vbpBr49.1 vbpBr50.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i50 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00031951):ℝ) ≤ ∫ v in (vBP 1.462)..(vBP 1.478), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.27401103) (m := (0:ℤ)) (ylo := 1.13241837) (yhi := 1.13241838)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.462) (q1 := 1.478) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.75960973) (B := 0.78138081) (X := 4.27401103) (rho := 0.07241973)
    (clo := (-0.42447231)) (chi := (-0.42447134)) (C := (-0.42447183)) (h := 0.07242022)
    (by norm_num) (by norm_num) oscBlock50 vbpBr50.1 vbpBr51.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i51 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00048368):ℝ) ≤ ∫ v in (vBP 1.478)..(vBP 1.495), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.39783082) (m := (0:ℤ)) (ylo := 1.25623816) (yhi := 1.25623817)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.478) (q1 := 1.495) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.7813783) (B := 0.80425401) (X := 4.39783082) (rho := 0.07583212)
    (clo := (-0.30939902)) (chi := (-0.3093963)) (C := (-0.30939766)) (h := 0.07583348)
    (by norm_num) (by norm_num) oscBlock51 vbpBr51.1 vbpBr52.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i52 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00032906):ℝ) ≤ ∫ v in (vBP 1.495)..(vBP 1.512), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.52398408) (m := (0:ℤ)) (ylo := 1.38239142) (yhi := 1.38239143)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.495) (q1 := 1.512) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.80425056) (B := 0.82686872) (X := 4.52398408) (rho := 0.07547319)
    (clo := (-0.18729919)) (chi := (-0.18729215)) (C := (-0.18729567)) (h := 0.07547671)
    (by norm_num) (by norm_num) oscBlock52 vbpBr52.1 vbpBr53.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i53 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00022048):ℝ) ≤ ∫ v in (vBP 1.512)..(vBP 1.531), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.6559904) (m := (0:ℤ)) (ylo := 1.51439774) (yhi := 1.51439775)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.512) (q1 := 1.531) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.82686405) (B := 0.85184522) (X := 4.6559904) (rho := 0.08239864)
    (clo := (-0.05638588)) (chi := (-0.05636838)) (C := (-0.05637713)) (h := 0.08240739)
    (by norm_num) (by norm_num) oscBlock53 vbpBr53.1 vbpBr54.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i54 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00029571):ℝ) ≤ ∫ v in (vBP 1.531)..(vBP 1.55), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.79367096) (m := (0:ℤ)) (ylo := 0.08128197) (yhi := 0.08128198)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.531) (q1 := 1.55) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.85183877) (B := 0.87651393) (X := 4.79367096) (rho := 0.08193778)
    (clo := 0.08119249) (chi := 0.08119251) (C := 0.0811925) (h := 0.08193779)
    (by norm_num) (by norm_num) oscBlock54 vbpBr54.1 vbpBr55.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i55 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00053175):ℝ) ≤ ∫ v in (vBP 1.55)..(vBP 1.57), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.93320809) (m := (0:ℤ)) (ylo := 0.2208191) (yhi := 0.22081911)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.55) (q1 := 1.57) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.87650515) (B := 0.90215678) (X := 4.93320809) (rho := 0.085039)
    (clo := 0.2190289) (chi := 0.21902892) (C := 0.21902891) (h := 0.08503901)
    (by norm_num) (by norm_num) oscBlock55 vbpBr55.1 vbpBr56.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i56 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00070171):ℝ) ≤ ∫ v in (vBP 1.57)..(vBP 1.59), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.07453541) (m := (0:ℤ)) (ylo := 0.36214642) (yhi := 0.36214643)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.57) (q1 := 1.59) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.90214481) (B := 0.92747548) (X := 5.07453541) (rho := 0.08454695)
    (clo := 0.35428224) (chi := 0.35428226) (C := 0.35428225) (h := 0.08454696)
    (by norm_num) (by norm_num) oscBlock56 vbpBr56.1 vbpBr57.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i57 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00082717):ℝ) ≤ ∫ v in (vBP 1.59)..(vBP 1.61), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.214085) (m := (0:ℤ)) (ylo := 0.50169601) (yhi := 0.50169602)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.59) (q1 := 1.61) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.92745939) (B := 0.95247825) (X := 5.214085) (rho := 0.08407527)
    (clo := 0.48091323) (chi := 0.48091325) (C := 0.48091324) (h := 0.08407528)
    (by norm_num) (by norm_num) oscBlock57 vbpBr57.1 vbpBr58.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i58 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00103364):ℝ) ≤ ∫ v in (vBP 1.61)..(vBP 1.632), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.35872295) (m := (0:ℤ)) (ylo := 0.64633396) (yhi := 0.64633397)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.61) (q1 := 1.632) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.95245689) (B := 0.97962584) (X := 5.35872295) (rho := 0.0904458)
    (clo := 0.60226387) (chi := 0.60226388) (C := 0.60226387) (h := 0.09044581)
    (by norm_num) (by norm_num) oscBlock58 vbpBr58.1 vbpBr59.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i59 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00122367):ℝ) ≤ ∫ v in (vBP 1.632)..(vBP 1.656), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.51500177) (m := (0:ℤ)) (ylo := 0.80261278) (yhi := 0.80261279)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.632) (q1 := 1.656) (t0 := 5.53125) (t1 := 5.5625)
    (A := 0.97959707) (B := 1.00882827) (X := 5.51500177) (rho := 0.09660549)
    (clo := 0.71917398) (chi := 0.719174) (C := 0.71917399) (h := 0.0966055)
    (by norm_num) (by norm_num) oscBlock59 vbpBr59.1 vbpBr60.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i60 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00124355):ℝ) ≤ ∫ v in (vBP 1.656)..(vBP 1.68), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.67579053) (m := (0:ℤ)) (ylo := 0.96340154) (yhi := 0.96340155)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.656) (q1 := 1.68) (t0 := 5.53125) (t1 := 5.5625)
    (A := 1.00878907) (B := 1.03761196) (X := 5.67579053) (rho := 0.09592601)
    (clo := 0.82113767) (chi := 0.8211377) (C := 0.82113768) (h := 0.09592603)
    (by norm_num) (by norm_num) oscBlock60 vbpBr60.1 vbpBr61.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i61 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00122343):ℝ) ≤ ∫ v in (vBP 1.68)..(vBP 1.704), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.83428234) (m := (0:ℤ)) (ylo := 1.12189335) (yhi := 1.12189336)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.68) (q1 := 1.704) (t0 := 5.53125) (t1 := 5.5625)
    (A := 1.03755935) (B := 1.06598913) (X := 5.83428234) (rho := 0.09528221)
    (clo := 0.90092372) (chi := 0.90092383) (C := 0.90092377) (h := 0.09528227)
    (by norm_num) (by norm_num) oscBlock61 vbpBr61.1 vbpBr62.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i62 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00137159):ℝ) ≤ ∫ v in (vBP 1.704)..(vBP 1.734), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.00983057) (m := (0:ℤ)) (ylo := 1.29744158) (yhi := 1.29744159)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.704) (q1 := 1.734) (t0 := 5.53125) (t1 := 5.5625)
    (A := 1.06591948) (B := 1.10090679) (X := 6.00983057) (rho := 0.11396346)
    (clo := 0.96287065) (chi := 0.9628711) (C := 0.92445359) (h := 0.07554641)
    (by norm_num) (by norm_num) oscBlock62 vbpBr62.1 vbpBr63.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i63 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00129873):ℝ) ≤ ∫ v in (vBP 1.734)..(vBP 1.766), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.2080906) (m := (0:ℤ)) (ylo := 1.49570161) (yhi := 1.49570162)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.734) (q1 := 1.766) (t0 := 5.53125) (t1 := 5.5625)
    (A := 1.10080961) (B := 1.13749718) (X := 6.2080906) (rho := 0.11923747)
    (clo := 0.99718168) (chi := 0.99718379) (C := 0.9389721) (h := 0.0610279)
    (by norm_num) (by norm_num) oscBlock63 vbpBr63.1 vbpBr64.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i64 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00107612):ℝ) ≤ ∫ v in (vBP 1.766)..(vBP 1.796), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.40293912) (m := (1:ℤ)) (ylo := 0.11975381) (yhi := 0.11975382)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.766) (q1 := 1.796) (t0 := 5.53125) (t1 := 5.5625)
    (A := 1.1373613) (B := 1.17120873) (X := 6.40293912) (rho := 0.11190945)
    (clo := 0.99283807) (chi := 0.99283808) (C := 0.94046431) (h := 0.05953569)
    (by norm_num) (by norm_num) oscBlock64 vbpBr64.1 vbpBr65.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i65 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00105478):ℝ) ≤ ∫ v in (vBP 1.796)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.59436175) (m := (1:ℤ)) (ylo := 0.31117644) (yhi := 0.31117645)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.796) (q1 := 1.828) (t0 := 5.53125) (t1 := 5.5625)
    (A := 1.1710258) (B := 1.20655947) (X := 6.59436175) (rho := 0.11712531)
    (clo := 0.95197402) (chi := 0.95197403) (C := 0.91742435) (h := 0.08257565)
    (by norm_num) (by norm_num) oscBlock65 vbpBr65.1 vbpBr66.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i66 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.0009572):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.86), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.78858804) (m := (1:ℤ)) (ylo := 0.50540273) (yhi := 0.50540274)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.828) (q1 := 1.86) (t0 := 5.53125) (t1 := 5.5625)
    (A := 1.20631244) (B := 1.24130524) (X := 6.78858804) (rho := 0.11617237)
    (clo := 0.87497955) (chi := 0.87497956) (C := 0.87497955) (h := 0.11617238)
    (by norm_num) (by norm_num) oscBlock66 vbpBr66.1 vbpBr67.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i67 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00070799):ℝ) ≤ ∫ v in (vBP 1.86)..(vBP 1.89), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.97358109) (m := (1:ℤ)) (ylo := 0.69039578) (yhi := 0.69039579)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.86) (q1 := 1.89) (t0 := 5.53125) (t1 := 5.5625)
    (A := 1.24097685) (B := 1.27334993) (X := 6.97358109) (rho := 0.10942791)
    (clo := 0.77099401) (chi := 0.77099404) (C := 0.77099402) (h := 0.10942793)
    (by norm_num) (by norm_num) oscBlock67 vbpBr67.1 vbpBr68.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i68 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.0005872):ℝ) ≤ ∫ v in (vBP 1.89)..(vBP 1.922), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.15549444) (m := (1:ℤ)) (ylo := 0.87230913) (yhi := 0.87230914)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.89) (q1 := 1.922) (t0 := 5.53125) (t1 := 5.5625)
    (A := 1.27292668) (B := 1.30698664) (X := 7.15549444) (rho := 0.11461876)
    (clo := 0.64305988) (chi := 0.64305997) (C := 0.64305992) (h := 0.11461881)
    (by norm_num) (by norm_num) oscBlock68 vbpBr68.1 vbpBr69.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i69 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00060657):ℝ) ≤ ∫ v in (vBP 1.922)..(vBP 1.969), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.38286677) (m := (1:ℤ)) (ylo := 1.09968146) (yhi := 1.09968147)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.922) (q1 := 1.969) (t0 := 5.53125) (t1 := 5.5625)
    (A := 1.30643896) (B := 1.35541448) (X := 7.38286677) (rho := 0.15662629)
    (clo := 0.45387996) (chi := 0.45388069) (C := 0.45388032) (h := 0.15662666)
    (by norm_num) (by norm_num) oscBlock69 vbpBr69.1 vbpBr70.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i70 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00031046):ℝ) ≤ ∫ v in (vBP 1.969)..(vBP 2.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.64776684) (m := (1:ℤ)) (ylo := 1.36458153) (yhi := 1.36458154)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.969) (q1 := 2.016) (t0 := 5.53125) (t1 := 5.5625)
    (A := 1.35463226) (B := 1.4027369) (X := 7.64776684) (rho := 0.15495717)
    (clo := 0.20475627) (chi := 0.20476246) (C := 0.20475936) (h := 0.15496027)
    (by norm_num) (by norm_num) oscBlock70 vbpBr70.1 vbpBr71.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i71 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00015784):ℝ) ≤ ∫ v in (vBP 2.016)..(vBP 2.062), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 7.90378721) (m := (1:ℤ)) (ylo := 0.04980557) (yhi := 0.04980558)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.016) (q1 := 2.062) (t0 := 5.53125) (t1 := 5.5625)
    (A := 1.40164597) (B := 1.44803958) (X := 7.90378721) (rho := 0.15093296)
    (clo := (-0.049785)) (chi := (-0.04978498)) (C := (-0.04978499)) (h := 0.15093297)
    (by norm_num) (by norm_num) oscBlock71 vbpBr71.1 vbpBr72.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB25i72 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.00018913):ℝ) ≤ ∫ v in (vBP 2.062)..(vBP 2.094), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.11408872) (m := (1:ℤ)) (ylo := 0.26010708) (yhi := 0.26010709)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.062) (q1 := 2.094) (t0 := 5.53125) (t1 := 5.5625)
    (A := 1.44655973) (B := 1.47899217) (X := 8.11408872) (rho := 0.11280523)
    (clo := (-0.25718405)) (chi := (-0.25718403)) (C := (-0.25718404)) (h := 0.11280524)
    (by norm_num) (by norm_num) oscBlock72 vbpBr72.1 vbpBr73.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

/-- Lower bound for the oscillatory integral `∫₀^∞ err(v) cos(tv) dv` on the band
`5.53125 ≤ t ≤ 5.5625`. -/
theorem oscBandLower25 {t : ℝ} (ht0 : (5.53125:ℝ) ≤ t) (ht1 : t ≤ 5.5625) :
    ((-0.10746023):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosB25i0 ht0 ht1)
    (cosB25i1 ht0 ht1))
    (cosB25i2 ht0 ht1))
    (cosB25i3 ht0 ht1))
    (cosB25i4 ht0 ht1))
    (cosB25i5 ht0 ht1))
    (cosB25i6 ht0 ht1))
    (cosB25i7 ht0 ht1))
    (cosB25i8 ht0 ht1))
    (cosB25i9 ht0 ht1))
    (cosB25i10 ht0 ht1))
    (cosB25i11 ht0 ht1))
    (cosB25i12 ht0 ht1))
    (cosB25i13 ht0 ht1))
    (cosB25i14 ht0 ht1))
    (cosB25i15 ht0 ht1))
    (cosB25i16 ht0 ht1))
    (cosB25i17 ht0 ht1))
    (cosB25i18 ht0 ht1))
    (cosB25i19 ht0 ht1))
    (cosB25i20 ht0 ht1))
    (cosB25i21 ht0 ht1))
    (cosB25i22 ht0 ht1))
    (cosB25i23 ht0 ht1))
    (cosB25i24 ht0 ht1))
    (cosB25i25 ht0 ht1))
    (cosB25i26 ht0 ht1))
    (cosB25i27 ht0 ht1))
    (cosB25i28 ht0 ht1))
    (cosB25i29 ht0 ht1))
    (cosB25i30 ht0 ht1))
    (cosB25i31 ht0 ht1))
    (cosB25i32 ht0 ht1))
    (cosB25i33 ht0 ht1))
    (cosB25i34 ht0 ht1))
    (cosB25i35 ht0 ht1))
    (cosB25i36 ht0 ht1))
    (cosB25i37 ht0 ht1))
    (cosB25i38 ht0 ht1))
    (cosB25i39 ht0 ht1))
    (cosB25i40 ht0 ht1))
    (cosB25i41 ht0 ht1))
    (cosB25i42 ht0 ht1))
    (cosB25i43 ht0 ht1))
    (cosB25i44 ht0 ht1))
    (cosB25i45 ht0 ht1))
    (cosB25i46 ht0 ht1))
    (cosB25i47 ht0 ht1))
    (cosB25i48 ht0 ht1))
    (cosB25i49 ht0 ht1))
    (cosB25i50 ht0 ht1))
    (cosB25i51 ht0 ht1))
    (cosB25i52 ht0 ht1))
    (cosB25i53 ht0 ht1))
    (cosB25i54 ht0 ht1))
    (cosB25i55 ht0 ht1))
    (cosB25i56 ht0 ht1))
    (cosB25i57 ht0 ht1))
    (cosB25i58 ht0 ht1))
    (cosB25i59 ht0 ht1))
    (cosB25i60 ht0 ht1))
    (cosB25i61 ht0 ht1))
    (cosB25i62 ht0 ht1))
    (cosB25i63 ht0 ht1))
    (cosB25i64 ht0 ht1))
    (cosB25i65 ht0 ht1))
    (cosB25i66 ht0 ht1))
    (cosB25i67 ht0 ht1))
    (cosB25i68 ht0 ht1))
    (cosB25i69 ht0 ht1))
    (cosB25i70 ht0 ht1))
    (cosB25i71 ht0 ht1))
    (cosB25i72 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 2.094) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 2.094) (S := 0.013709)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_cut
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
