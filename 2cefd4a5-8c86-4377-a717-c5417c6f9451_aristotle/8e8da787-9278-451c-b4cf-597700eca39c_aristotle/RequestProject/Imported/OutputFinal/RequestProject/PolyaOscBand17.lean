/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscTail

/-!
# Oscillatory lower bound on the band `5.78125 ≤ t ≤ 5.8125`

On each of the 73 blocks the factor `cos(tv)` is bracketed by a rational constant
`C` up to a rational error `h`; the signed contribution `min(C·P₀, C·P₁) - h·S` is
then summed, and the unresolved tail beyond `q = 2.094` is estimated in absolute
value.  The result is the bound `∫₀^∞ err(v) cos(tv) dv ≥ -0.11537575`.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosB17i0 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00641868):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.0038), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.02204565) (m := (0:ℤ)) (ylo := 0.02204565) (yhi := 0.02204565)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1) (q1 := 1.0038) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.0) (B := 0.0075856) (X := 0.02204565) (rho := 0.02204566)
    (clo := 0.999757) (chi := 0.99975701) (C := 0.98885567) (h := 0.01114433)
    (by norm_num) (by norm_num) oscBlock0 vbpBr0.1 vbpBr1.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i1 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00625872):ℝ) ≤ ∫ v in (vBP 1.0038)..(vBP 1.0078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.0670887) (m := (0:ℤ)) (ylo := 0.0670887) (yhi := 0.0670887)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0038) (q1 := 1.0078) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.00758559) (B := 0.01553948) (X := 0.0670887) (rho := 0.02323453)
    (clo := 0.99775039) (chi := 0.9977504) (C := 0.98725793) (h := 0.01274207)
    (by norm_num) (by norm_num) oscBlock1 vbpBr1.1 vbpBr2.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i2 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.0057677):ℝ) ≤ ∫ v in (vBP 1.0078)..(vBP 1.0118), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.11310478) (m := (0:ℤ)) (ylo := 0.11310478) (yhi := 0.11310478)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0078) (q1 := 1.0118) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.01553947) (B := 0.02346185) (X := 0.11310478) (rho := 0.02326724)
    (clo := 0.99361047) (chi := 0.99361048) (C := 0.98517161) (h := 0.01482839)
    (by norm_num) (by norm_num) oscBlock2 vbpBr2.1 vbpBr3.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i3 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00554846):ℝ) ≤ ∫ v in (vBP 1.0118)..(vBP 1.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.16008322) (m := (0:ℤ)) (ylo := 0.16008322) (yhi := 0.16008322)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0118) (q1 := 1.016) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.02346184) (B := 0.0317467) (X := 0.16008322) (rho := 0.02444448)
    (clo := 0.98721402) (chi := 0.98721403) (C := 0.98138477) (h := 0.01861523)
    (by norm_num) (by norm_num) oscBlock3 vbpBr3.1 vbpBr4.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i4 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00539232):ℝ) ≤ ∫ v in (vBP 1.016)..(vBP 1.0205), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.20971912) (m := (0:ℤ)) (ylo := 0.20971912) (yhi := 0.20971912)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.016) (q1 := 1.0205) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.03174669) (B := 0.04058541) (X := 0.20971912) (rho := 0.02618359)
    (clo := 0.97808942) (chi := 0.97808943) (C := 0.97595291) (h := 0.02404709)
    (by norm_num) (by norm_num) oscBlock4 vbpBr4.1 vbpBr5.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i5 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00481401):ℝ) ≤ ∫ v in (vBP 1.0205)..(vBP 1.025), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.26084299) (m := (0:ℤ)) (ylo := 0.26084299) (yhi := 0.26084299)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0205) (q1 := 1.025) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.0405854) (B := 0.04938523) (X := 0.26084299) (rho := 0.02620867)
    (clo := 0.96617291) (chi := 0.96617292) (C := 0.96617291) (h := 0.02620868)
    (by norm_num) (by norm_num) oscBlock5 vbpBr5.1 vbpBr6.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i6 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00469496):ℝ) ≤ ∫ v in (vBP 1.025)..(vBP 1.03), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.3145647) (m := (0:ℤ)) (ylo := 0.3145647) (yhi := 0.3145647)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.025) (q1 := 1.03) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.04938522) (B := 0.05911761) (X := 0.3145647) (rho := 0.02905642)
    (clo := 0.95093115) (chi := 0.95093116) (C := 0.95093115) (h := 0.02905643)
    (by norm_num) (by norm_num) oscBlock6 vbpBr6.1 vbpBr7.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i7 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.0043975):ℝ) ≤ ∫ v in (vBP 1.03)..(vBP 1.0355), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.37365241) (m := (0:ℤ)) (ylo := 0.37365241) (yhi := 0.37365241)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.03) (q1 := 1.0355) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.0591176) (B := 0.06976881) (X := 0.37365241) (rho := 0.03187881)
    (clo := 0.93100036) (chi := 0.93100037) (C := 0.93100036) (h := 0.03187882)
    (by norm_num) (by norm_num) oscBlock7 vbpBr7.1 vbpBr8.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i8 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00394166):ℝ) ≤ ∫ v in (vBP 1.0355)..(vBP 1.0415), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.43802322) (m := (0:ℤ)) (ylo := 0.43802322) (yhi := 0.43802322)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0355) (q1 := 1.0415) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.0697688) (B := 0.08132397) (X := 0.43802322) (rho := 0.03467237)
    (clo := 0.90559188) (chi := 0.90559189) (C := 0.90559188) (h := 0.03467238)
    (by norm_num) (by norm_num) oscBlock8 vbpBr8.1 vbpBr9.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i9 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00335307):ℝ) ≤ ∫ v in (vBP 1.0415)..(vBP 1.048), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.50758793) (m := (0:ℤ)) (ylo := 0.50758793) (yhi := 0.50758793)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0415) (q1 := 1.048) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.08132396) (B := 0.09376718) (X := 0.50758793) (rho := 0.03743381)
    (clo := 0.87391948) (chi := 0.87391949) (C := 0.87391948) (h := 0.03743382)
    (by norm_num) (by norm_num) oscBlock9 vbpBr9.1 vbpBr10.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i10 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00268307):ℝ) ≤ ∫ v in (vBP 1.048)..(vBP 1.055), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.58225145) (m := (0:ℤ)) (ylo := 0.58225145) (yhi := 0.58225145)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.048) (q1 := 1.055) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.09376717) (B := 0.10708154) (X := 0.58225145) (rho := 0.04016001)
    (clo := 0.83522668) (chi := 0.83522669) (C := 0.83522668) (h := 0.04016002)
    (by norm_num) (by norm_num) oscBlock10 vbpBr10.1 vbpBr11.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i11 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00222596):ℝ) ≤ ∫ v in (vBP 1.055)..(vBP 1.064), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.67011328) (m := (0:ℤ)) (ylo := 0.67011328) (yhi := 0.67011328)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.055) (q1 := 1.064) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.10708153) (B := 0.12407079) (X := 0.67011328) (rho := 0.0510482)
    (clo := 0.78375131) (chi := 0.78375133) (C := 0.78375132) (h := 0.05104821)
    (by norm_num) (by norm_num) oscBlock11 vbpBr11.1 vbpBr12.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i12 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00144737):ℝ) ≤ ∫ v in (vBP 1.064)..(vBP 1.078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.79520429) (m := (0:ℤ)) (ylo := 0.79520429) (yhi := 0.79520429)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.064) (q1 := 1.078) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.12407078) (B := 0.15021495) (X := 0.79520429) (rho := 0.07792011)
    (clo := 0.70013891) (chi := 0.70013895) (C := 0.70013893) (h := 0.07792013)
    (by norm_num) (by norm_num) oscBlock12 vbpBr12.1 vbpBr13.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i13 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    (0.00019282:ℝ) ≤ ∫ v in (vBP 1.078)..(vBP 1.09), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.93512294) (m := (0:ℤ)) (ylo := 0.93512294) (yhi := 0.93512294)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.078) (q1 := 1.09) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.15021494) (B := 0.1723554) (X := 0.93512294) (rho := 0.06669284)
    (clo := 0.5937195) (chi := 0.59371965) (C := 0.59371957) (h := 0.06669292)
    (by norm_num) (by norm_num) oscBlock13 vbpBr13.1 vbpBr14.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i14 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    (0.00074395:ℝ) ≤ ∫ v in (vBP 1.09)..(vBP 1.1), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.05220522) (m := (0:ℤ)) (ylo := 1.05220522) (yhi := 1.05220522)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.09) (q1 := 1.1) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.17235539) (B := 0.19062036) (X := 1.05220522) (rho := 0.05577564)
    (clo := 0.49565697) (chi := 0.49565744) (C := 0.4956572) (h := 0.05577588)
    (by norm_num) (by norm_num) oscBlock14 vbpBr14.1 vbpBr15.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i15 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    (0.00083763:ℝ) ≤ ∫ v in (vBP 1.1)..(vBP 1.109), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.1523657) (m := (0:ℤ)) (ylo := 1.1523657) (yhi := 1.1523657)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.1) (q1 := 1.109) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.19062035) (B := 0.20691742) (X := 1.1523657) (rho := 0.05034182)
    (clo := 0.40632696) (chi := 0.40632811) (C := 0.40632753) (h := 0.0503424)
    (by norm_num) (by norm_num) oscBlock15 vbpBr15.1 vbpBr16.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i16 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    (0.00072457:ℝ) ≤ ∫ v in (vBP 1.109)..(vBP 1.117), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.24125356) (m := (0:ℤ)) (ylo := 1.24125356) (yhi := 1.24125356)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.109) (q1 := 1.117) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.20691741) (B := 0.22129305) (X := 1.24125356) (rho := 0.0450123)
    (clo := 0.3236104) (chi := 0.3236128) (C := 0.3236116) (h := 0.0450135)
    (by norm_num) (by norm_num) oscBlock16 vbpBr16.1 vbpBr17.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i17 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    (0.00054337:ℝ) ≤ ∫ v in (vBP 1.117)..(vBP 1.124), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.31912014) (m := (0:ℤ)) (ylo := 1.31912014) (yhi := 1.31912014)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.117) (q1 := 1.124) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.22129304) (B := 0.23378751) (X := 1.31912014) (rho := 0.03976977)
    (clo := 0.24902763) (chi := 0.24903203) (C := 0.24902983) (h := 0.03977197)
    (by norm_num) (by norm_num) oscBlock17 vbpBr17.1 vbpBr18.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i18 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    (0.00038996:ℝ) ≤ ∫ v in (vBP 1.124)..(vBP 1.131), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.39132352) (m := (0:ℤ)) (ylo := 1.39132352) (yhi := 1.39132352)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.124) (q1 := 1.131) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.2337875) (B := 0.2462044) (X := 1.39132352) (rho := 0.03973956)
    (clo := 0.17851076) (chi := 0.17851826) (C := 0.17851451) (h := 0.03974331)
    (by norm_num) (by norm_num) oscBlock18 vbpBr18.1 vbpBr19.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i19 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    (0.00019548:ℝ) ≤ ∫ v in (vBP 1.131)..(vBP 1.138), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.46308004) (m := (0:ℤ)) (ylo := 1.46308004) (yhi := 1.46308004)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.131) (q1 := 1.138) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.24620439) (B := 0.25854468) (X := 1.46308004) (rho := 0.03971093)
    (clo := 0.1075079) (chi := 0.1075203) (C := 0.1075141) (h := 0.03971713)
    (by norm_num) (by norm_num) oscBlock19 vbpBr19.1 vbpBr20.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i20 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00002605):ℝ) ≤ ∫ v in (vBP 1.138)..(vBP 1.145), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.53439515) (m := (0:ℤ)) (ylo := 1.53439515) (yhi := 1.53439515)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.138) (q1 := 1.145) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.25854467) (B := 0.27080928) (X := 1.53439515) (rho := 0.0396838)
    (clo := 0.03639278) (chi := 0.03641273) (C := 0.03640275) (h := 0.03969378)
    (by norm_num) (by norm_num) oscBlock20 vbpBr20.1 vbpBr21.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i21 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00028393):ℝ) ≤ ∫ v in (vBP 1.145)..(vBP 1.152), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.60527426) (m := (0:ℤ)) (ylo := 0.03447793) (yhi := 0.03447794)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.145) (q1 := 1.152) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.27080927) (B := 0.28299913) (X := 1.60527426) (rho := 0.03965819)
    (clo := (-0.03447111)) (chi := (-0.03447109)) (C := (-0.0344711)) (h := 0.0396582)
    (by norm_num) (by norm_num) oscBlock21 vbpBr21.1 vbpBr22.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i22 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00056328):ℝ) ≤ ∫ v in (vBP 1.152)..(vBP 1.159), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.67572267) (m := (0:ℤ)) (ylo := 0.10492634) (yhi := 0.10492635)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.152) (q1 := 1.159) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.28299912) (B := 0.29511513) (X := 1.67572267) (rho := 0.03963403)
    (clo := (-0.10473393)) (chi := (-0.10473391)) (C := (-0.10473392)) (h := 0.03963404)
    (by norm_num) (by norm_num) oscBlock22 vbpBr22.1 vbpBr23.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i23 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00084079):ℝ) ≤ ∫ v in (vBP 1.159)..(vBP 1.166), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.7457456) (m := (0:ℤ)) (ylo := 0.17494927) (yhi := 0.17494928)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.159) (q1 := 1.166) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.29511512) (B := 0.30715818) (X := 1.7457456) (rho := 0.03961133)
    (clo := (-0.1740582)) (chi := (-0.17405818)) (C := (-0.17405819)) (h := 0.03961134)
    (by norm_num) (by norm_num) oscBlock23 vbpBr23.1 vbpBr24.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i24 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00110791):ℝ) ≤ ∫ v in (vBP 1.166)..(vBP 1.173), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.81534814) (m := (0:ℤ)) (ylo := 0.24455181) (yhi := 0.24455182)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.166) (q1 := 1.173) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.30715817) (B := 0.31912914) (X := 1.81534814) (rho := 0.03958999)
    (clo := (-0.24212151)) (chi := (-0.24212149)) (C := (-0.2421215)) (h := 0.03959)
    (by norm_num) (by norm_num) oscBlock24 vbpBr24.1 vbpBr25.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i25 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00135718):ℝ) ≤ ∫ v in (vBP 1.173)..(vBP 1.18), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.88453532) (m := (0:ℤ)) (ylo := 0.31373899) (yhi := 0.313739)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.173) (q1 := 1.18) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.31912913) (B := 0.33102888) (X := 1.88453532) (rho := 0.03957006)
    (clo := (-0.30861728)) (chi := (-0.30861726)) (C := (-0.30861727)) (h := 0.03957007)
    (by norm_num) (by norm_num) oscBlock25 vbpBr25.1 vbpBr26.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i26 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.0015822):ℝ) ≤ ∫ v in (vBP 1.18)..(vBP 1.187), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.95331208) (m := (0:ℤ)) (ylo := 0.38251575) (yhi := 0.38251576)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.18) (q1 := 1.187) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.33102887) (B := 0.34285824) (X := 1.95331208) (rho := 0.03955145)
    (clo := (-0.3732556)) (chi := (-0.37325558)) (C := (-0.37325559)) (h := 0.03955146)
    (by norm_num) (by norm_num) oscBlock26 vbpBr26.1 vbpBr27.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i27 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00177778):ℝ) ≤ ∫ v in (vBP 1.187)..(vBP 1.194), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.02168324) (m := (0:ℤ)) (ylo := 0.45088691) (yhi := 0.45088692)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.187) (q1 := 1.194) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.34285823) (B := 0.35461804) (X := 2.02168324) (rho := 0.03953412)
    (clo := (-0.43576399)) (chi := (-0.43576397)) (C := (-0.43576398)) (h := 0.03953413)
    (by norm_num) (by norm_num) oscBlock27 vbpBr27.1 vbpBr28.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i28 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00195981):ℝ) ≤ ∫ v in (vBP 1.194)..(vBP 1.201), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.0896535) (m := (0:ℤ)) (ylo := 0.51885717) (yhi := 0.51885718)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.194) (q1 := 1.201) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.35461802) (B := 0.36630909) (X := 2.0896535) (rho := 0.03951809)
    (clo := (-0.49588806)) (chi := (-0.49588804)) (C := (-0.49588805)) (h := 0.0395181)
    (by norm_num) (by norm_num) oscBlock28 vbpBr28.1 vbpBr29.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i29 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00208735):ℝ) ≤ ∫ v in (vBP 1.201)..(vBP 1.208), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.15722764) (m := (0:ℤ)) (ylo := 0.58643131) (yhi := 0.58643132)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.201) (q1 := 1.208) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.36630908) (B := 0.3779322) (X := 2.15722764) (rho := 0.03950329)
    (clo := (-0.55339213)) (chi := (-0.55339211)) (C := (-0.55339212)) (h := 0.0395033)
    (by norm_num) (by norm_num) oscBlock29 vbpBr29.1 vbpBr30.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i30 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00217662):ℝ) ≤ ∫ v in (vBP 1.208)..(vBP 1.215), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.2244102) (m := (0:ℤ)) (ylo := 0.65361387) (yhi := 0.65361388)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.208) (q1 := 1.215) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.37793219) (B := 0.38948816) (X := 2.2244102) (rho := 0.03948974)
    (clo := (-0.6080594)) (chi := (-0.60805939)) (C := (-0.6080594)) (h := 0.03948975)
    (by norm_num) (by norm_num) oscBlock30 vbpBr30.1 vbpBr31.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i31 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00256456):ℝ) ≤ ∫ v in (vBP 1.215)..(vBP 1.223), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.2959603) (m := (0:ℤ)) (ylo := 0.72516397) (yhi := 0.72516398)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.215) (q1 := 1.223) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.38948815) (B := 0.40261372) (X := 2.2959603) (rho := 0.04423196)
    (clo := (-0.66325818)) (chi := (-0.66325816)) (C := (-0.66325817)) (h := 0.04423197)
    (by norm_num) (by norm_num) oscBlock31 vbpBr31.1 vbpBr32.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i32 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00257151):ℝ) ≤ ∫ v in (vBP 1.223)..(vBP 1.231), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.37179882) (m := (0:ℤ)) (ylo := 0.80100249) (yhi := 0.8010025)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.223) (q1 := 1.231) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.40261371) (B := 0.4156537) (X := 2.37179882) (rho := 0.04418833)
    (clo := (-0.71805419)) (chi := (-0.71805417)) (C := (-0.71805418)) (h := 0.04418834)
    (by norm_num) (by norm_num) oscBlock32 vbpBr32.1 vbpBr33.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i33 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00252329):ℝ) ≤ ∫ v in (vBP 1.231)..(vBP 1.239), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.44714446) (m := (0:ℤ)) (ylo := 0.87634813) (yhi := 0.87634814)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.231) (q1 := 1.239) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.41565369) (B := 0.42860921) (X := 2.44714446) (rho := 0.04414658)
    (clo := (-0.76840697)) (chi := (-0.76840695)) (C := (-0.76840696)) (h := 0.04414659)
    (by norm_num) (by norm_num) oscBlock33 vbpBr33.1 vbpBr34.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i34 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00273273):ℝ) ≤ ∫ v in (vBP 1.239)..(vBP 1.248), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.52666294) (m := (0:ℤ)) (ylo := 0.95586661) (yhi := 0.95586662)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.239) (q1 := 1.248) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.4286092) (B := 0.44308455) (X := 2.52666294) (rho := 0.04876602)
    (clo := (-0.81681402)) (chi := (-0.81681399)) (C := (-0.81681401)) (h := 0.04876604)
    (by norm_num) (by norm_num) oscBlock34 vbpBr34.1 vbpBr35.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i35 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00282314):ℝ) ≤ ∫ v in (vBP 1.248)..(vBP 1.258), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.61489458) (m := (0:ℤ)) (ylo := 1.04409825) (yhi := 1.04409826)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.248) (q1 := 1.258) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.44308453) (B := 0.45904632) (X := 2.61489458) (rho := 0.05331216)
    (clo := (-0.86447165)) (chi := (-0.86447159)) (C := (-0.86447162)) (h := 0.05331219)
    (by norm_num) (by norm_num) oscBlock35 vbpBr35.1 vbpBr36.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i36 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00254285):ℝ) ≤ ∫ v in (vBP 1.258)..(vBP 1.268), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.70705573) (m := (0:ℤ)) (ylo := 1.1362594) (yhi := 1.13625941)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.258) (q1 := 1.268) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.45904631) (B := 0.47488172) (X := 2.70705573) (rho := 0.05319427)
    (clo := (-0.9070652)) (chi := (-0.90706508)) (C := (-0.90706514)) (h := 0.05319433)
    (by norm_num) (by norm_num) oscBlock36 vbpBr36.1 vbpBr37.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i37 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00261049):ℝ) ≤ ∫ v in (vBP 1.268)..(vBP 1.28), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.80757915) (m := (0:ℤ)) (ylo := 1.23678282) (yhi := 1.23678283)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.268) (q1 := 1.28) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.4748817) (B := 0.49372017) (X := 2.80757915) (rho := 0.06216934)
    (clo := (-0.94473444)) (chi := (-0.94473417)) (C := (-0.94128242)) (h := 0.05871759)
    (by norm_num) (by norm_num) oscBlock37 vbpBr37.1 vbpBr38.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i38 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00228621):ℝ) ≤ ∫ v in (vBP 1.28)..(vBP 1.294), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.92526309) (m := (0:ℤ)) (ylo := 1.35446676) (yhi := 1.35446677)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.28) (q1 := 1.294) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.49372014) (B := 0.51547641) (X := 2.92526309) (rho := 0.07094355)
    (clo := (-0.97669258)) (chi := (-0.97669186)) (C := (-0.95287416)) (h := 0.04712585)
    (by norm_num) (by norm_num) oscBlock38 vbpBr38.1 vbpBr39.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i39 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00152769):ℝ) ≤ ∫ v in (vBP 1.294)..(vBP 1.308), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.05070088) (m := (0:ℤ)) (ylo := 1.47990455) (yhi := 1.47990456)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.294) (q1 := 1.308) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.51547638) (B := 0.53699853) (X := 3.05070088) (rho := 0.07060308)
    (clo := (-0.99587403)) (chi := (-0.99587215)) (C := (-0.96263454)) (h := 0.03736547)
    (by norm_num) (by norm_num) oscBlock39 vbpBr39.1 vbpBr40.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i40 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00099409):ℝ) ≤ ∫ v in (vBP 1.308)..(vBP 1.326), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.19235639) (m := (0:ℤ)) (ylo := 0.05076373) (yhi := 0.05076374)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.308) (q1 := 1.326) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.53699848) (B := 0.56433382) (X := 3.19235639) (rho := 0.08783395)
    (clo := (-0.9987118)) (chi := (-0.99871179)) (C := (-0.95543892)) (h := 0.04456108)
    (by norm_num) (by norm_num) oscBlock40 vbpBr40.1 vbpBr41.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i41 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    (0.00001265:ℝ) ≤ ∫ v in (vBP 1.326)..(vBP 1.345), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.35406757) (m := (0:ℤ)) (ylo := 0.21247491) (yhi := 0.21247492)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.326) (q1 := 1.345) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.56433374) (B := 0.59278808) (X := 3.35406757) (rho := 0.09151316)
    (clo := (-0.97751201)) (chi := (-0.97751199)) (C := (-0.94299942)) (h := 0.05700059)
    (by norm_num) (by norm_num) oscBlock41 vbpBr41.1 vbpBr42.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i42 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    (0.00087115:ℝ) ≤ ∫ v in (vBP 1.345)..(vBP 1.362), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.50932427) (m := (0:ℤ)) (ylo := 0.36773161) (yhi := 0.36773162)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.345) (q1 := 1.362) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.59278796) (B := 0.6179085) (X := 3.50932427) (rho := 0.0822689)
    (clo := (-0.93314524)) (chi := (-0.93314522)) (C := (-0.92543816)) (h := 0.07456184)
    (by norm_num) (by norm_num) oscBlock42 vbpBr42.1 vbpBr43.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i43 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    (0.00101336:ℝ) ≤ ∫ v in (vBP 1.362)..(vBP 1.376), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.6413796) (m := (0:ℤ)) (ylo := 0.49978694) (yhi := 0.49978695)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.362) (q1 := 1.376) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.61790831) (B := 0.6383616) (X := 3.6413796) (rho := 0.06909721)
    (clo := (-0.87768469)) (chi := (-0.87768468)) (C := (-0.87768469)) (h := 0.06909722)
    (by norm_num) (by norm_num) oscBlock43 vbpBr43.1 vbpBr44.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i44 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    (0.00110592:ℝ) ≤ ∫ v in (vBP 1.376)..(vBP 1.39), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.75934176) (m := (0:ℤ)) (ylo := 0.6177491) (yhi := 0.61774911)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.376) (q1 := 1.39) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.63836133) (B := 0.65860767) (X := 3.75934176) (rho := 0.06881534)
    (clo := (-0.81518425)) (chi := (-0.81518424)) (C := (-0.81518425)) (h := 0.06881535)
    (by norm_num) (by norm_num) oscBlock44 vbpBr44.1 vbpBr45.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i45 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    (0.00107339:ℝ) ≤ ∫ v in (vBP 1.39)..(vBP 1.404), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.87611575) (m := (0:ℤ)) (ylo := 0.73452309) (yhi := 0.7345231)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.39) (q1 := 1.404) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.65860729) (B := 0.67865086) (X := 3.87611575) (rho := 0.06854238)
    (clo := (-0.7421505)) (chi := (-0.74215047)) (C := (-0.74215049)) (h := 0.0685424)
    (by norm_num) (by norm_num) oscBlock45 vbpBr45.1 vbpBr46.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i46 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    (0.00094418:ℝ) ≤ ∫ v in (vBP 1.404)..(vBP 1.418), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.99172525) (m := (0:ℤ)) (ylo := 0.85013259) (yhi := 0.8501326)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.404) (q1 := 1.418) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.67865033) (B := 0.69849519) (X := 3.99172525) (rho := 0.06827805)
    (clo := (-0.65988359)) (chi := (-0.65988352)) (C := (-0.65988356)) (h := 0.06827809)
    (by norm_num) (by norm_num) oscBlock46 vbpBr46.1 vbpBr47.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i47 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    (0.00075161:ℝ) ≤ ∫ v in (vBP 1.418)..(vBP 1.432), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.10619329) (m := (0:ℤ)) (ylo := 0.96460063) (yhi := 0.96460064)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.418) (q1 := 1.432) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.69849446) (B := 0.7181446) (X := 4.10619329) (rho := 0.06802221)
    (clo := (-0.56974533)) (chi := (-0.56974512)) (C := (-0.56974523)) (h := 0.06802232)
    (by norm_num) (by norm_num) oscBlock47 vbpBr47.1 vbpBr48.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i48 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    (0.00052961:ℝ) ≤ ∫ v in (vBP 1.432)..(vBP 1.446), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.21954215) (m := (0:ℤ)) (ylo := 1.07794949) (yhi := 1.0779495)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.432) (q1 := 1.446) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.7181436) (B := 0.73760286) (X := 4.21954215) (rho := 0.06777448)
    (clo := (-0.47313642)) (chi := (-0.47313582)) (C := (-0.47313612)) (h := 0.06777478)
    (by norm_num) (by norm_num) oscBlock48 vbpBr48.1 vbpBr49.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i49 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    (0.0003187:ℝ) ≤ ∫ v in (vBP 1.446)..(vBP 1.462), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.33975057) (m := (0:ℤ)) (ylo := 1.19815791) (yhi := 1.19815792)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.446) (q1 := 1.462) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.73760153) (B := 0.75961158) (X := 4.33975057) (rho := 0.07549175)
    (clo := (-0.36407571)) (chi := (-0.36407401)) (C := (-0.36407486)) (h := 0.0754926)
    (by norm_num) (by norm_num) oscBlock49 vbpBr49.1 vbpBr50.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i50 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00025373):ℝ) ≤ ∫ v in (vBP 1.462)..(vBP 1.478), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.46663485) (m := (0:ℤ)) (ylo := 1.32504219) (yhi := 1.3250422)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.462) (q1 := 1.478) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.75960973) (B := 0.78138081) (X := 4.46663485) (rho := 0.07514112)
    (clo := (-0.24329241)) (chi := (-0.2432878)) (C := (-0.24329011)) (h := 0.07514343)
    (by norm_num) (by norm_num) oscBlock50 vbpBr50.1 vbpBr51.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i51 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00028561):ℝ) ≤ ∫ v in (vBP 1.478)..(vBP 1.495), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.59603486) (m := (0:ℤ)) (ylo := 1.4544422) (yhi := 1.45444221)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.478) (q1 := 1.495) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.7813783) (B := 0.80425401) (X := 4.59603486) (rho := 0.07869158)
    (clo := (-0.11610326)) (chi := (-0.11609157)) (C := (-0.11609742)) (h := 0.07869743)
    (by norm_num) (by norm_num) oscBlock51 vbpBr51.1 vbpBr52.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i52 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00018019):ℝ) ≤ ∫ v in (vBP 1.495)..(vBP 1.512), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.72787399) (m := (0:ℤ)) (ylo := 0.015485) (yhi := 0.01548501)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.495) (q1 := 1.512) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.80425056) (B := 0.82686872) (X := 4.72787399) (rho := 0.07830046)
    (clo := 0.01548438) (chi := 0.0154844) (C := 0.01548439) (h := 0.07830047)
    (by norm_num) (by norm_num) oscBlock52 vbpBr52.1 vbpBr53.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i53 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00047166):ℝ) ≤ ∫ v in (vBP 1.512)..(vBP 1.531), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.86582906) (m := (0:ℤ)) (ylo := 0.15344007) (yhi := 0.15344008)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.512) (q1 := 1.531) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.82686405) (B := 0.85184522) (X := 4.86582906) (rho := 0.08552129)
    (clo := 0.15283868) (chi := 0.1528387) (C := 0.15283869) (h := 0.0855213)
    (by norm_num) (by norm_num) oscBlock53 vbpBr53.1 vbpBr54.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i54 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00068518):ℝ) ≤ ∫ v in (vBP 1.531)..(vBP 1.55), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.00971505) (m := (0:ℤ)) (ylo := 0.29732606) (yhi := 0.29732607)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.531) (q1 := 1.55) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.85183877) (B := 0.87651393) (X := 5.00971505) (rho := 0.08502218)
    (clo := 0.29296464) (chi := 0.29296466) (C := 0.29296465) (h := 0.08502219)
    (by norm_num) (by norm_num) oscBlock54 vbpBr54.1 vbpBr55.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i55 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00090418):ℝ) ≤ ∫ v in (vBP 1.55)..(vBP 1.57), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.15554084) (m := (0:ℤ)) (ylo := 0.44315185) (yhi := 0.44315186)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.55) (q1 := 1.57) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.87650515) (B := 0.90215678) (X := 5.15554084) (rho := 0.08824546)
    (clo := 0.42878898) (chi := 0.428789) (C := 0.42878899) (h := 0.08824547)
    (by norm_num) (by norm_num) oscBlock55 vbpBr55.1 vbpBr56.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i56 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00103103):ℝ) ≤ ∫ v in (vBP 1.57)..(vBP 1.59), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.30323795) (m := (0:ℤ)) (ylo := 0.59084896) (yhi := 0.59084897)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.57) (q1 := 1.59) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.90214481) (B := 0.92747548) (X := 5.30323795) (rho := 0.08771329)
    (clo := 0.55706625) (chi := 0.55706627) (C := 0.55706626) (h := 0.0877133)
    (by norm_num) (by norm_num) oscBlock56 vbpBr56.1 vbpBr57.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i57 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00111127):ℝ) ≤ ∫ v in (vBP 1.59)..(vBP 1.61), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.44907721) (m := (0:ℤ)) (ylo := 0.73668822) (yhi := 0.73668823)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.59) (q1 := 1.61) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.92745939) (B := 0.95247825) (X := 5.44907721) (rho := 0.08720263)
    (clo := 0.67183857) (chi := 0.67183859) (C := 0.67183858) (h := 0.08720264)
    (by norm_num) (by norm_num) oscBlock57 vbpBr57.1 vbpBr58.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i58 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00129752):ℝ) ≤ ∫ v in (vBP 1.61)..(vBP 1.632), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.60023329) (m := (0:ℤ)) (ylo := 0.8878443) (yhi := 0.88784431)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.61) (q1 := 1.632) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.95245689) (B := 0.97962584) (X := 5.60023329) (rho := 0.09384191)
    (clo := 0.77571311) (chi := 0.77571314) (C := 0.77571312) (h := 0.09384193)
    (by norm_num) (by norm_num) oscBlock58 vbpBr58.1 vbpBr59.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i59 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00145239):ℝ) ≤ ∫ v in (vBP 1.632)..(vBP 1.656), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.76355494) (m := (0:ℤ)) (ylo := 1.05116595) (yhi := 1.05116596)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.632) (q1 := 1.656) (t0 := 5.78125) (t1 := 5.8125)
    (A := 0.97959707) (B := 1.00882827) (X := 5.76355494) (rho := 0.10025939)
    (clo := 0.86800277) (chi := 0.86800283) (C := 0.8680028) (h := 0.10025942)
    (by norm_num) (by norm_num) oscBlock59 vbpBr59.1 vbpBr60.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i60 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00135601):ℝ) ≤ ∫ v in (vBP 1.656)..(vBP 1.68), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.93159066) (m := (0:ℤ)) (ylo := 1.21920167) (yhi := 1.21920168)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.656) (q1 := 1.68) (t0 := 5.78125) (t1 := 5.8125)
    (A := 1.00878907) (B := 1.03761196) (X := 5.93159066) (rho := 0.09952887)
    (clo := 0.93882471) (chi := 0.93882494) (C := 0.91964792) (h := 0.08035208)
    (by norm_num) (by norm_num) oscBlock60 vbpBr60.1 vbpBr61.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i61 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00122808):ℝ) ≤ ∫ v in (vBP 1.68)..(vBP 1.704), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.0972259) (m := (0:ℤ)) (ylo := 1.38483691) (yhi := 1.38483692)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.68) (q1 := 1.704) (t0 := 5.78125) (t1 := 5.8125)
    (A := 1.03755935) (B := 1.06598913) (X := 6.0972259) (rho := 0.09883593)
    (clo := 0.9827593) (chi := 0.98276021) (C := 0.94196168) (h := 0.05803832)
    (by norm_num) (by norm_num) oscBlock61 vbpBr61.1 vbpBr62.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i62 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00137159):ℝ) ≤ ∫ v in (vBP 1.704)..(vBP 1.734), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.28068385) (m := (0:ℤ)) (ylo := 1.56829486) (yhi := 1.56829487)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.704) (q1 := 1.734) (t0 := 5.78125) (t1 := 5.8125)
    (A := 1.06591948) (B := 1.10090679) (X := 6.28068385) (rho := 0.11833688)
    (clo := 0.99999681) (chi := 1.00000036) (C := 0.94082996) (h := 0.05917004)
    (by norm_num) (by norm_num) oscBlock62 vbpBr62.1 vbpBr63.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i63 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00129873):ℝ) ≤ ∫ v in (vBP 1.734)..(vBP 1.766), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.48787895) (m := (1:ℤ)) (ylo := 0.20469364) (yhi := 0.20469365)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.734) (q1 := 1.766) (t0 := 5.78125) (t1 := 5.8125)
    (A := 1.10080961) (B := 1.13749718) (X := 6.48787895) (rho := 0.12382342)
    (clo := 0.9791233) (chi := 0.97912331) (C := 0.92764994) (h := 0.07235006)
    (by norm_num) (by norm_num) oscBlock63 vbpBr63.1 vbpBr64.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i64 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00107612):ℝ) ≤ ∫ v in (vBP 1.766)..(vBP 1.796), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.69151037) (m := (1:ℤ)) (ylo := 0.40832506) (yhi := 0.40832507)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.766) (q1 := 1.796) (t0 := 5.78125) (t1 := 5.8125)
    (A := 1.1373613) (B := 1.17120873) (X := 6.69151037) (rho := 0.11614038)
    (clo := 0.91778717) (chi := 0.91778719) (C := 0.90082339) (h := 0.09917661)
    (by norm_num) (by norm_num) oscBlock64 vbpBr64.1 vbpBr65.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i65 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00099376):ℝ) ≤ ∫ v in (vBP 1.796)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.89155991) (m := (1:ℤ)) (ylo := 0.6083746) (yhi := 0.60837461)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.796) (q1 := 1.828) (t0 := 5.78125) (t1 := 5.8125)
    (A := 1.1710258) (B := 1.20655947) (X := 6.89155991) (rho := 0.12156702)
    (clo := 0.82057806) (chi := 0.82057808) (C := 0.82057807) (h := 0.12156703)
    (by norm_num) (by norm_num) oscBlock65 vbpBr65.1 vbpBr66.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i66 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00078135):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.86), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.09454025) (m := (1:ℤ)) (ylo := 0.81135494) (yhi := 0.81135495)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.828) (q1 := 1.86) (t0 := 5.78125) (t1 := 5.8125)
    (A := 1.20631244) (B := 1.24130524) (X := 7.09454025) (rho := 0.12054647)
    (clo := 0.68851642) (chi := 0.68851647) (C := 0.68851644) (h := 0.1205465)
    (by norm_num) (by norm_num) oscBlock66 vbpBr66.1 vbpBr67.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i67 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00052256):ℝ) ≤ ∫ v in (vBP 1.86)..(vBP 1.89), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.28787194) (m := (1:ℤ)) (ylo := 1.00468663) (yhi := 1.00468664)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.86) (q1 := 1.89) (t0 := 5.78125) (t1 := 5.8125)
    (A := 1.24097685) (B := 1.27334993) (X := 7.28787194) (rho := 0.11347454)
    (clo := 0.53635271) (chi := 0.53635301) (C := 0.53635286) (h := 0.11347469)
    (by norm_num) (by norm_num) oscBlock67 vbpBr67.1 vbpBr68.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i68 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00037671):ℝ) ≤ ∫ v in (vBP 1.89)..(vBP 1.922), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.4779836) (m := (1:ℤ)) (ylo := 1.19479829) (yhi := 1.1947983)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.89) (q1 := 1.922) (t0 := 5.78125) (t1 := 5.8125)
    (A := 1.27292668) (B := 1.30698664) (X := 7.4779836) (rho := 0.11887625)
    (clo := 0.367201) (chi := 0.36720265) (C := 0.36720182) (h := 0.11887708)
    (by norm_num) (by norm_num) oscBlock68 vbpBr68.1 vbpBr69.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i69 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00029877):ℝ) ≤ ∫ v in (vBP 1.922)..(vBP 1.969), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.71559845) (m := (1:ℤ)) (ylo := 1.43241314) (yhi := 1.43241315)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.922) (q1 := 1.969) (t0 := 5.78125) (t1 := 5.8125)
    (A := 1.30643896) (B := 1.35541448) (X := 7.71559845) (rho := 0.16274823)
    (clo := 0.13794177) (chi := 0.13795181) (C := 0.13794679) (h := 0.16275325)
    (by norm_num) (by norm_num) oscBlock69 vbpBr69.1 vbpBr70.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i70 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00026277):ℝ) ≤ ∫ v in (vBP 1.969)..(vBP 2.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 7.99243799) (m := (1:ℤ)) (ylo := 0.13845635) (yhi := 0.13845636)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.969) (q1 := 2.016) (t0 := 5.78125) (t1 := 5.8125)
    (A := 1.35463226) (B := 1.4027369) (X := 7.99243799) (rho := 0.16097025)
    (clo := (-0.13801442)) (chi := (-0.1380144)) (C := (-0.13801441)) (h := 0.16097026)
    (by norm_num) (by norm_num) oscBlock70 vbpBr70.1 vbpBr71.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i71 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00043381):ℝ) ≤ ∫ v in (vBP 2.016)..(vBP 2.062), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.25999791) (m := (1:ℤ)) (ylo := 0.40601627) (yhi := 0.40601628)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.016) (q1 := 2.062) (t0 := 5.78125) (t1 := 5.8125)
    (A := 1.40164597) (B := 1.44803958) (X := 8.25999791) (rho := 0.15673216)
    (clo := (-0.39495263)) (chi := (-0.39495261)) (C := (-0.39495262)) (h := 0.15673217)
    (by norm_num) (by norm_num) oscBlock71 vbpBr71.1 vbpBr72.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB17i72 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.00035914):ℝ) ≤ ∫ v in (vBP 2.062)..(vBP 2.094), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.47978271) (m := (1:ℤ)) (ylo := 0.62580107) (yhi := 0.62580108)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.062) (q1 := 2.094) (t0 := 5.78125) (t1 := 5.8125)
    (A := 1.44655973) (B := 1.47899217) (X := 8.47978271) (rho := 0.11685929)
    (clo := (-0.58574674)) (chi := (-0.58574672)) (C := (-0.58574673)) (h := 0.1168593)
    (by norm_num) (by norm_num) oscBlock72 vbpBr72.1 vbpBr73.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

/-- Lower bound for the oscillatory integral `∫₀^∞ err(v) cos(tv) dv` on the band
`5.78125 ≤ t ≤ 5.8125`. -/
theorem oscBandLower17 {t : ℝ} (ht0 : (5.78125:ℝ) ≤ t) (ht1 : t ≤ 5.8125) :
    ((-0.11537575):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosB17i0 ht0 ht1)
    (cosB17i1 ht0 ht1))
    (cosB17i2 ht0 ht1))
    (cosB17i3 ht0 ht1))
    (cosB17i4 ht0 ht1))
    (cosB17i5 ht0 ht1))
    (cosB17i6 ht0 ht1))
    (cosB17i7 ht0 ht1))
    (cosB17i8 ht0 ht1))
    (cosB17i9 ht0 ht1))
    (cosB17i10 ht0 ht1))
    (cosB17i11 ht0 ht1))
    (cosB17i12 ht0 ht1))
    (cosB17i13 ht0 ht1))
    (cosB17i14 ht0 ht1))
    (cosB17i15 ht0 ht1))
    (cosB17i16 ht0 ht1))
    (cosB17i17 ht0 ht1))
    (cosB17i18 ht0 ht1))
    (cosB17i19 ht0 ht1))
    (cosB17i20 ht0 ht1))
    (cosB17i21 ht0 ht1))
    (cosB17i22 ht0 ht1))
    (cosB17i23 ht0 ht1))
    (cosB17i24 ht0 ht1))
    (cosB17i25 ht0 ht1))
    (cosB17i26 ht0 ht1))
    (cosB17i27 ht0 ht1))
    (cosB17i28 ht0 ht1))
    (cosB17i29 ht0 ht1))
    (cosB17i30 ht0 ht1))
    (cosB17i31 ht0 ht1))
    (cosB17i32 ht0 ht1))
    (cosB17i33 ht0 ht1))
    (cosB17i34 ht0 ht1))
    (cosB17i35 ht0 ht1))
    (cosB17i36 ht0 ht1))
    (cosB17i37 ht0 ht1))
    (cosB17i38 ht0 ht1))
    (cosB17i39 ht0 ht1))
    (cosB17i40 ht0 ht1))
    (cosB17i41 ht0 ht1))
    (cosB17i42 ht0 ht1))
    (cosB17i43 ht0 ht1))
    (cosB17i44 ht0 ht1))
    (cosB17i45 ht0 ht1))
    (cosB17i46 ht0 ht1))
    (cosB17i47 ht0 ht1))
    (cosB17i48 ht0 ht1))
    (cosB17i49 ht0 ht1))
    (cosB17i50 ht0 ht1))
    (cosB17i51 ht0 ht1))
    (cosB17i52 ht0 ht1))
    (cosB17i53 ht0 ht1))
    (cosB17i54 ht0 ht1))
    (cosB17i55 ht0 ht1))
    (cosB17i56 ht0 ht1))
    (cosB17i57 ht0 ht1))
    (cosB17i58 ht0 ht1))
    (cosB17i59 ht0 ht1))
    (cosB17i60 ht0 ht1))
    (cosB17i61 ht0 ht1))
    (cosB17i62 ht0 ht1))
    (cosB17i63 ht0 ht1))
    (cosB17i64 ht0 ht1))
    (cosB17i65 ht0 ht1))
    (cosB17i66 ht0 ht1))
    (cosB17i67 ht0 ht1))
    (cosB17i68 ht0 ht1))
    (cosB17i69 ht0 ht1))
    (cosB17i70 ht0 ht1))
    (cosB17i71 ht0 ht1))
    (cosB17i72 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 2.094) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 2.094) (S := 0.013709)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_cut
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
