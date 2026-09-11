/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscTail

/-!
# Oscillatory lower bound on the band `7.0 ≤ t ≤ 7.25`

On each of the 73 blocks the factor `cos(tv)` is bracketed by a rational constant
`C` up to a rational error `h`; the signed contribution `min(C·P₀, C·P₁) - h·S` is
then summed, and the unresolved tail beyond `q = 2.094` is estimated in absolute
value.  The result is the bound `∫₀^∞ err(v) cos(tv) dv ≥ -0.16013617`.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosB2i0 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00641868):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.0038), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.0274978) (m := (0:ℤ)) (ylo := 0.0274978) (yhi := 0.0274978)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1) (q1 := 1.0038) (t0 := 7) (t1 := 7.25)
    (A := 0.0) (B := 0.0075856) (X := 0.0274978) (rho := 0.02749781)
    (clo := 0.99962195) (chi := 0.99962196) (C := 0.98606207) (h := 0.01393793)
    (by norm_num) (by norm_num) oscBlock0 vbpBr0.1 vbpBr1.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i1 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00625872):ℝ) ≤ ∫ v in (vBP 1.0038)..(vBP 1.0078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.08288018) (m := (0:ℤ)) (ylo := 0.08288018) (yhi := 0.08288018)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0038) (q1 := 1.0078) (t0 := 7) (t1 := 7.25)
    (A := 0.00758559) (B := 0.01553948) (X := 0.08288018) (rho := 0.02978106)
    (clo := 0.9965674) (chi := 0.99656741) (C := 0.98339317) (h := 0.01660683)
    (by norm_num) (by norm_num) oscBlock1 vbpBr1.1 vbpBr2.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i2 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.0057677):ℝ) ≤ ∫ v in (vBP 1.0078)..(vBP 1.0118), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.13943735) (m := (0:ℤ)) (ylo := 0.13943735) (yhi := 0.13943735)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0078) (q1 := 1.0118) (t0 := 7) (t1 := 7.25)
    (A := 0.01553947) (B := 0.02346185) (X := 0.13943735) (rho := 0.03066108)
    (clo := 0.99029435) (chi := 0.99029436) (C := 0.97981663) (h := 0.02018337)
    (by norm_num) (by norm_num) oscBlock2 vbpBr2.1 vbpBr3.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i3 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00554846):ℝ) ≤ ∫ v in (vBP 1.0118)..(vBP 1.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.19719822) (m := (0:ℤ)) (ylo := 0.19719822) (yhi := 0.19719822)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0118) (q1 := 1.016) (t0 := 7) (t1 := 7.25)
    (A := 0.02346184) (B := 0.0317467) (X := 0.19719822) (rho := 0.03296536)
    (clo := 0.98061935) (chi := 0.98061936) (C := 0.97382699) (h := 0.02617301)
    (by norm_num) (by norm_num) oscBlock3 vbpBr3.1 vbpBr4.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i4 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00539232):ℝ) ≤ ∫ v in (vBP 1.016)..(vBP 1.0205), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.25823552) (m := (0:ℤ)) (ylo := 0.25823552) (yhi := 0.25823552)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.016) (q1 := 1.0205) (t0 := 7) (t1 := 7.25)
    (A := 0.03174669) (B := 0.04058541) (X := 0.25823552) (rho := 0.03600871)
    (clo := 0.96684208) (chi := 0.96684209) (C := 0.96541668) (h := 0.03458332)
    (by norm_num) (by norm_num) oscBlock4 vbpBr4.1 vbpBr5.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i5 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00478242):ℝ) ≤ ∫ v in (vBP 1.0205)..(vBP 1.025), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.32107035) (m := (0:ℤ)) (ylo := 0.32107035) (yhi := 0.32107035)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0205) (q1 := 1.025) (t0 := 7) (t1 := 7.25)
    (A := 0.0405854) (B := 0.04938523) (X := 0.32107035) (rho := 0.03697257)
    (clo := 0.94889817) (chi := 0.94889818) (C := 0.94889817) (h := 0.03697258)
    (by norm_num) (by norm_num) oscBlock5 vbpBr5.1 vbpBr6.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i6 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00463486):ℝ) ≤ ∫ v in (vBP 1.025)..(vBP 1.03), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.3871496) (m := (0:ℤ)) (ylo := 0.3871496) (yhi := 0.3871496)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.025) (q1 := 1.03) (t0 := 7) (t1 := 7.25)
    (A := 0.04938522) (B := 0.05911761) (X := 0.3871496) (rho := 0.04145308)
    (clo := 0.92598899) (chi := 0.925989) (C := 0.92598899) (h := 0.04145309)
    (by norm_num) (by norm_num) oscBlock6 vbpBr6.1 vbpBr7.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i7 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00430275):ℝ) ≤ ∫ v in (vBP 1.03)..(vBP 1.0355), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.45982353) (m := (0:ℤ)) (ylo := 0.45982353) (yhi := 0.45982353)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.03) (q1 := 1.0355) (t0 := 7) (t1 := 7.25)
    (A := 0.0591176) (B := 0.06976881) (X := 0.45982353) (rho := 0.04600035)
    (clo := 0.89613082) (chi := 0.89613083) (C := 0.89613082) (h := 0.04600036)
    (by norm_num) (by norm_num) oscBlock7 vbpBr7.1 vbpBr8.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i8 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00380991):ℝ) ≤ ∫ v in (vBP 1.0355)..(vBP 1.0415), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.53899019) (m := (0:ℤ)) (ylo := 0.53899019) (yhi := 0.53899019)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0355) (q1 := 1.0415) (t0 := 7) (t1 := 7.25)
    (A := 0.0697688) (B := 0.08132397) (X := 0.53899019) (rho := 0.05060861)
    (clo := 0.85822742) (chi := 0.85822743) (C := 0.85822742) (h := 0.05060862)
    (by norm_num) (by norm_num) oscBlock8 vbpBr8.1 vbpBr9.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i9 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00318806):ℝ) ≤ ∫ v in (vBP 1.0415)..(vBP 1.048), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.62453988) (m := (0:ℤ)) (ylo := 0.62453988) (yhi := 0.62453988)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0415) (q1 := 1.048) (t0 := 7) (t1 := 7.25)
    (A := 0.08132396) (B := 0.09376718) (X := 0.62453988) (rho := 0.05527218)
    (clo := 0.81123224) (chi := 0.81123226) (C := 0.81123225) (h := 0.05527219)
    (by norm_num) (by norm_num) oscBlock9 vbpBr9.1 vbpBr10.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i10 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.0024955):ℝ) ≤ ∫ v in (vBP 1.048)..(vBP 1.055), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.71635567) (m := (0:ℤ)) (ylo := 0.71635567) (yhi := 0.71635567)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.048) (q1 := 1.055) (t0 := 7) (t1 := 7.25)
    (A := 0.09376717) (B := 0.10708154) (X := 0.71635567) (rho := 0.0599855)
    (clo := 0.75420374) (chi := 0.75420376) (C := 0.75420375) (h := 0.05998551)
    (by norm_num) (by norm_num) oscBlock10 vbpBr10.1 vbpBr11.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i11 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00201015):ℝ) ≤ ∫ v in (vBP 1.055)..(vBP 1.064), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.82454196) (m := (0:ℤ)) (ylo := 0.82454196) (yhi := 0.82454196)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.055) (q1 := 1.064) (t0 := 7) (t1 := 7.25)
    (A := 0.10708153) (B := 0.12407079) (X := 0.82454196) (rho := 0.07497127)
    (clo := 0.67889334) (chi := 0.67889339) (C := 0.67889336) (h := 0.0749713)
    (by norm_num) (by norm_num) oscBlock11 vbpBr11.1 vbpBr12.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i12 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00124323):ℝ) ≤ ∫ v in (vBP 1.064)..(vBP 1.078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.97877692) (m := (0:ℤ)) (ylo := 0.97877692) (yhi := 0.97877692)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.064) (q1 := 1.078) (t0 := 7) (t1 := 7.25)
    (A := 0.12407078) (B := 0.15021495) (X := 0.97877692) (rho := 0.11028148)
    (clo := 0.55803789) (chi := 0.55803812) (C := 0.558038) (h := 0.1102816)
    (by norm_num) (by norm_num) oscBlock12 vbpBr12.1 vbpBr13.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i13 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    (0.00003574:ℝ) ≤ ∫ v in (vBP 1.078)..(vBP 1.09), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.15054061) (m := (0:ℤ)) (ylo := 1.15054061) (yhi := 1.15054061)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.078) (q1 := 1.09) (t0 := 7) (t1 := 7.25)
    (A := 0.15021494) (B := 0.1723554) (X := 1.15054061) (rho := 0.09903605)
    (clo := 0.40799392) (chi := 0.40799505) (C := 0.40799448) (h := 0.09903662)
    (by norm_num) (by norm_num) oscBlock13 vbpBr13.1 vbpBr14.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i14 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    (0.00026261:ℝ) ≤ ∫ v in (vBP 1.09)..(vBP 1.1), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.29424267) (m := (0:ℤ)) (ylo := 1.29424267) (yhi := 1.29424267)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.09) (q1 := 1.1) (t0 := 7) (t1 := 7.25)
    (A := 0.17235539) (B := 0.19062036) (X := 1.29424267) (rho := 0.08775495)
    (clo := 0.27304184) (chi := 0.27304548) (C := 0.27304366) (h := 0.08775677)
    (by norm_num) (by norm_num) oscBlock14 vbpBr14.1 vbpBr15.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i15 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    (0.00012004:ℝ) ≤ ∫ v in (vBP 1.1)..(vBP 1.109), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.41724687) (m := (0:ℤ)) (ylo := 1.41724687) (yhi := 1.41724687)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.1) (q1 := 1.109) (t0 := 7) (t1 := 7.25)
    (A := 0.19062035) (B := 0.20691742) (X := 1.41724687) (rho := 0.08290444)
    (clo := 0.15294664) (chi := 0.15295566) (C := 0.15295115) (h := 0.08290895)
    (by norm_num) (by norm_num) oscBlock15 vbpBr15.1 vbpBr16.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i16 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00013219):ℝ) ≤ ∫ v in (vBP 1.109)..(vBP 1.117), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.52639824) (m := (0:ℤ)) (ylo := 1.52639824) (yhi := 1.52639824)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.109) (q1 := 1.117) (t0 := 7) (t1 := 7.25)
    (A := 0.20691741) (B := 0.22129305) (X := 1.52639824) (rho := 0.07797639)
    (clo := 0.04438317) (chi := 0.0444021) (C := 0.04439263) (h := 0.07798586)
    (by norm_num) (by norm_num) oscBlock16 vbpBr16.1 vbpBr17.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i17 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00039095):ℝ) ≤ ∫ v in (vBP 1.117)..(vBP 1.124), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.62200536) (m := (0:ℤ)) (ylo := 0.05120903) (yhi := 0.05120904)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.117) (q1 := 1.124) (t0 := 7) (t1 := 7.25)
    (A := 0.22129304) (B := 0.23378751) (X := 1.62200536) (rho := 0.0729541)
    (clo := (-0.05118667)) (chi := (-0.05118665)) (C := (-0.05118666)) (h := 0.07295411)
    (by norm_num) (by norm_num) oscBlock17 vbpBr17.1 vbpBr18.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i18 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00072678):ℝ) ≤ ∫ v in (vBP 1.124)..(vBP 1.131), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.7107472) (m := (0:ℤ)) (ylo := 0.13995087) (yhi := 0.13995088)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.124) (q1 := 1.131) (t0 := 7) (t1 := 7.25)
    (A := 0.2337875) (B := 0.2462044) (X := 1.7107472) (rho := 0.07423471)
    (clo := (-0.13949448)) (chi := (-0.13949446)) (C := (-0.13949447)) (h := 0.07423472)
    (by norm_num) (by norm_num) oscBlock18 vbpBr18.1 vbpBr19.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i19 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00108682):ℝ) ≤ ∫ v in (vBP 1.131)..(vBP 1.138), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.79893983) (m := (0:ℤ)) (ylo := 0.2281435) (yhi := 0.22814351)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.131) (q1 := 1.138) (t0 := 7) (t1 := 7.25)
    (A := 0.24620439) (B := 0.25854468) (X := 1.79893983) (rho := 0.07550911)
    (clo := (-0.22616953)) (chi := (-0.22616952)) (C := (-0.22616953)) (h := 0.07550912)
    (by norm_num) (by norm_num) oscBlock19 vbpBr19.1 vbpBr20.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i20 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00144233):ℝ) ≤ ∫ v in (vBP 1.138)..(vBP 1.145), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.88658998) (m := (0:ℤ)) (ylo := 0.31579365) (yhi := 0.31579366)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.138) (q1 := 1.145) (t0 := 7) (t1 := 7.25)
    (A := 0.25854467) (B := 0.27080928) (X := 1.88658998) (rho := 0.07677731)
    (clo := (-0.31057099)) (chi := (-0.31057097)) (C := (-0.31057098)) (h := 0.07677732)
    (by norm_num) (by norm_num) oscBlock20 vbpBr20.1 vbpBr21.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i21 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.0018007):ℝ) ≤ ∫ v in (vBP 1.145)..(vBP 1.152), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.97370429) (m := (0:ℤ)) (ylo := 0.40290796) (yhi := 0.40290797)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.145) (q1 := 1.152) (t0 := 7) (t1 := 7.25)
    (A := 0.27080927) (B := 0.28299913) (X := 1.97370429) (rho := 0.07803942)
    (clo := (-0.39209511)) (chi := (-0.3920951)) (C := (-0.39209511)) (h := 0.07803943)
    (by norm_num) (by norm_num) oscBlock21 vbpBr21.1 vbpBr22.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i22 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00214387):ℝ) ≤ ∫ v in (vBP 1.152)..(vBP 1.159), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.06028926) (m := (0:ℤ)) (ylo := 0.48949293) (yhi := 0.48949294)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.152) (q1 := 1.159) (t0 := 7) (t1 := 7.25)
    (A := 0.28299912) (B := 0.29511513) (X := 2.06028926) (rho := 0.07929544)
    (clo := (-0.47017844)) (chi := (-0.47017842)) (C := (-0.47017843)) (h := 0.07929545)
    (by norm_num) (by norm_num) oscBlock22 vbpBr22.1 vbpBr23.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i23 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00245876):ℝ) ≤ ∫ v in (vBP 1.159)..(vBP 1.166), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.14635132) (m := (0:ℤ)) (ylo := 0.57555499) (yhi := 0.575555)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.159) (q1 := 1.166) (t0 := 7) (t1 := 7.25)
    (A := 0.29511512) (B := 0.30715818) (X := 2.14635132) (rho := 0.0805455)
    (clo := (-0.54430046)) (chi := (-0.54430045)) (C := (-0.54430046)) (h := 0.08054551)
    (by norm_num) (by norm_num) oscBlock23 vbpBr23.1 vbpBr24.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i24 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00273634):ℝ) ≤ ∫ v in (vBP 1.166)..(vBP 1.173), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.23189672) (m := (0:ℤ)) (ylo := 0.66110039) (yhi := 0.6611004)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.166) (q1 := 1.173) (t0 := 7) (t1 := 7.25)
    (A := 0.30715817) (B := 0.31912914) (X := 2.23189672) (rho := 0.08178955)
    (clo := (-0.61398579)) (chi := (-0.61398578)) (C := (-0.61398579)) (h := 0.08178956)
    (by norm_num) (by norm_num) oscBlock24 vbpBr24.1 vbpBr25.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i25 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.0029695):ℝ) ≤ ∫ v in (vBP 1.173)..(vBP 1.18), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.31693164) (m := (0:ℤ)) (ylo := 0.74613531) (yhi := 0.74613532)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.173) (q1 := 1.18) (t0 := 7) (t1 := 7.25)
    (A := 0.31912913) (B := 0.33102888) (X := 2.31693164) (rho := 0.08302775)
    (clo := (-0.67880594)) (chi := (-0.67880592)) (C := (-0.67880593)) (h := 0.08302776)
    (by norm_num) (by norm_num) oscBlock25 vbpBr25.1 vbpBr26.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i26 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.003153):ℝ) ≤ ∫ v in (vBP 1.18)..(vBP 1.187), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.40146216) (m := (0:ℤ)) (ylo := 0.83066583) (yhi := 0.83066584)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.18) (q1 := 1.187) (t0 := 7) (t1 := 7.25)
    (A := 0.33102887) (B := 0.34285824) (X := 2.40146216) (rho := 0.08426009)
    (clo := (-0.73838058)) (chi := (-0.73838056)) (C := (-0.73838057)) (h := 0.0842601)
    (by norm_num) (by norm_num) oscBlock26 vbpBr26.1 vbpBr27.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i27 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00328352):ℝ) ≤ ∫ v in (vBP 1.187)..(vBP 1.194), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.4854942) (m := (0:ℤ)) (ylo := 0.91469787) (yhi := 0.91469788)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.187) (q1 := 1.194) (t0 := 7) (t1 := 7.25)
    (A := 0.34285823) (B := 0.35461804) (X := 2.4854942) (rho := 0.0854866)
    (clo := (-0.79237834)) (chi := (-0.79237831)) (C := (-0.79237833)) (h := 0.08548662)
    (by norm_num) (by norm_num) oscBlock27 vbpBr27.1 vbpBr28.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i28 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00339402):ℝ) ≤ ∫ v in (vBP 1.194)..(vBP 1.201), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.56903352) (m := (0:ℤ)) (ylo := 0.99823719) (yhi := 0.9982372)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.194) (q1 := 1.201) (t0 := 7) (t1 := 7.25)
    (A := 0.35461802) (B := 0.36630909) (X := 2.56903352) (rho := 0.0867074)
    (clo := (-0.84051726)) (chi := (-0.84051722)) (C := (-0.84051724)) (h := 0.08670742)
    (by norm_num) (by norm_num) oscBlock28 vbpBr28.1 vbpBr29.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i29 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.0034167):ℝ) ≤ ∫ v in (vBP 1.201)..(vBP 1.208), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.652086) (m := (0:ℤ)) (ylo := 1.08128967) (yhi := 1.08128968)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.201) (q1 := 1.208) (t0 := 7) (t1 := 7.25)
    (A := 0.36630908) (B := 0.3779322) (X := 2.652086) (rho := 0.08792246)
    (clo := (-0.882565)) (chi := (-0.88256493)) (C := (-0.88256497)) (h := 0.0879225)
    (by norm_num) (by norm_num) oscBlock29 vbpBr29.1 vbpBr30.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i30 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00336132):ℝ) ≤ ∫ v in (vBP 1.208)..(vBP 1.215), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.73465724) (m := (0:ℤ)) (ylo := 1.16386091) (yhi := 1.16386092)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.208) (q1 := 1.215) (t0 := 7) (t1 := 7.25)
    (A := 0.37793219) (B := 0.38948816) (X := 2.73465724) (rho := 0.08913193)
    (clo := (-0.91833823)) (chi := (-0.91833808)) (C := (-0.91460308)) (h := 0.08539693)
    (by norm_num) (by norm_num) oscBlock30 vbpBr30.1 vbpBr31.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i31 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00362487):ℝ) ≤ ∫ v in (vBP 1.215)..(vBP 1.223), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.82268326) (m := (0:ℤ)) (ylo := 1.25188693) (yhi := 1.25188694)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.215) (q1 := 1.223) (t0 := 7) (t1 := 7.25)
    (A := 0.38948815) (B := 0.40261372) (X := 2.82268326) (rho := 0.09626622)
    (clo := (-0.94957822)) (chi := (-0.94957791)) (C := (-0.92665585)) (h := 0.07334416)
    (by norm_num) (by norm_num) oscBlock31 vbpBr31.1 vbpBr32.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i32 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00337361):ℝ) ≤ ∫ v in (vBP 1.223)..(vBP 1.231), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.91589264) (m := (0:ℤ)) (ylo := 1.34509631) (yhi := 1.34509632)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.223) (q1 := 1.231) (t0 := 7) (t1 := 7.25)
    (A := 0.40261371) (B := 0.4156537) (X := 2.91589264) (rho := 0.09759669)
    (clo := (-0.97463834)) (chi := (-0.97463768)) (C := (-0.9385205)) (h := 0.06147951)
    (by norm_num) (by norm_num) oscBlock32 vbpBr32.1 vbpBr33.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i33 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00310539):ℝ) ≤ ∫ v in (vBP 1.231)..(vBP 1.239), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.0084963) (m := (0:ℤ)) (ylo := 1.43769997) (yhi := 1.43769998)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.231) (q1 := 1.239) (t0 := 7) (t1 := 7.25)
    (A := 0.41565369) (B := 0.42860921) (X := 3.0084963) (rho := 0.09892049)
    (clo := (-0.99115709)) (chi := (-0.99115572)) (C := (-0.94611762)) (h := 0.05388239)
    (by norm_num) (by norm_num) oscBlock33 vbpBr33.1 vbpBr34.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i34 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.0031571):ℝ) ≤ ∫ v in (vBP 1.239)..(vBP 1.248), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.10631369) (m := (0:ℤ)) (ylo := 1.53551736) (yhi := 1.53551737)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.239) (q1 := 1.248) (t0 := 7) (t1 := 7.25)
    (A := 0.4286092) (B := 0.44308455) (X := 3.10631369) (rho := 0.10604931)
    (clo := (-0.99938053)) (chi := (-0.99937771)) (C := (-0.9466642)) (h := 0.0533358)
    (by norm_num) (by norm_num) oscBlock34 vbpBr34.1 vbpBr35.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i35 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00307604):ℝ) ≤ ∫ v in (vBP 1.248)..(vBP 1.258), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.21483876) (m := (0:ℤ)) (ylo := 0.0732461) (yhi := 0.07324611)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.248) (q1 := 1.258) (t0 := 7) (t1 := 7.25)
    (A := 0.44308453) (B := 0.45904632) (X := 3.21483876) (rho := 0.11324707)
    (clo := (-0.99731871)) (chi := (-0.9973187)) (C := (-0.94203582)) (h := 0.05796419)
    (by norm_num) (by norm_num) oscBlock35 vbpBr35.1 vbpBr36.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i36 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00264809):ℝ) ≤ ∫ v in (vBP 1.258)..(vBP 1.268), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.32810832) (m := (0:ℤ)) (ylo := 0.18651566) (yhi := 0.18651567)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.258) (q1 := 1.268) (t0 := 7) (t1 := 7.25)
    (A := 0.45904631) (B := 0.47488172) (X := 3.32810832) (rho := 0.11478416)
    (clo := (-0.98265633)) (chi := (-0.98265631)) (C := (-0.93393608)) (h := 0.06606393)
    (by norm_num) (by norm_num) oscBlock36 vbpBr36.1 vbpBr37.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i37 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00261049):ℝ) ≤ ∫ v in (vBP 1.268)..(vBP 1.28), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.45182156) (m := (0:ℤ)) (ylo := 0.3102289) (yhi := 0.31022891)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.268) (q1 := 1.28) (t0 := 7) (t1 := 7.25)
    (A := 0.4748817) (B := 0.49372017) (X := 3.45182156) (rho := 0.12764968)
    (clo := (-0.95226372)) (chi := (-0.95226371)) (C := (-0.91230702)) (h := 0.08769299)
    (by norm_num) (by norm_num) oscBlock37 vbpBr37.1 vbpBr38.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i38 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00228621):ℝ) ≤ ∫ v in (vBP 1.28)..(vBP 1.294), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.59662247) (m := (0:ℤ)) (ylo := 0.45502981) (yhi := 0.45502982)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.28) (q1 := 1.294) (t0 := 7) (t1 := 7.25)
    (A := 0.49372014) (B := 0.51547641) (X := 3.59662247) (rho := 0.14058151)
    (clo := (-0.89824793)) (chi := (-0.89824792)) (C := (-0.87883321)) (h := 0.1211668)
    (by norm_num) (by norm_num) oscBlock38 vbpBr38.1 vbpBr39.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i39 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00147049):ℝ) ≤ ∫ v in (vBP 1.294)..(vBP 1.308), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.750787) (m := (0:ℤ)) (ylo := 0.60919434) (yhi := 0.60919435)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.294) (q1 := 1.308) (t0 := 7) (t1 := 7.25)
    (A := 0.51547638) (B := 0.53699853) (X := 3.750787) (rho := 0.14245236)
    (clo := (-0.8201093)) (chi := (-0.82010928)) (C := (-0.82010929)) (h := 0.14245237)
    (by norm_num) (by norm_num) oscBlock39 vbpBr39.1 vbpBr40.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i40 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00088239):ℝ) ≤ ∫ v in (vBP 1.308)..(vBP 1.326), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.92520477) (m := (0:ℤ)) (ylo := 0.78361211) (yhi := 0.78361212)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.308) (q1 := 1.326) (t0 := 7) (t1 := 7.25)
    (A := 0.53699848) (B := 0.56433382) (X := 3.92520477) (rho := 0.16621543)
    (clo := (-0.70836861)) (chi := (-0.70836857)) (C := (-0.70836859)) (h := 0.16621545)
    (by norm_num) (by norm_num) oscBlock40 vbpBr40.1 vbpBr41.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i41 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00022597):ℝ) ≤ ∫ v in (vBP 1.326)..(vBP 1.345), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.12402488) (m := (0:ℤ)) (ylo := 0.98243222) (yhi := 0.98243223)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.326) (q1 := 1.345) (t0 := 7) (t1 := 7.25)
    (A := 0.56433374) (B := 0.59278808) (X := 4.12402488) (rho := 0.17368871)
    (clo := (-0.55500118)) (chi := (-0.55500093)) (C := (-0.55500106)) (h := 0.17368884)
    (by norm_num) (by norm_num) oscBlock41 vbpBr41.1 vbpBr42.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i42 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    (0.00009977:ℝ) ≤ ∫ v in (vBP 1.345)..(vBP 1.362), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.31467617) (m := (0:ℤ)) (ylo := 1.17308351) (yhi := 1.17308352)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.345) (q1 := 1.362) (t0 := 7) (t1 := 7.25)
    (A := 0.59278796) (B := 0.6179085) (X := 4.31467617) (rho := 0.16516047)
    (clo := (-0.38731204)) (chi := (-0.38731066)) (C := (-0.38731135)) (h := 0.16516116)
    (by norm_num) (by norm_num) oscBlock42 vbpBr42.1 vbpBr43.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i43 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    (0.00000808:ℝ) ≤ ∫ v in (vBP 1.362)..(vBP 1.376), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.47673988) (m := (0:ℤ)) (ylo := 1.33514722) (yhi := 1.33514723)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.362) (q1 := 1.376) (t0 := 7) (t1 := 7.25)
    (A := 0.61790831) (B := 0.6383616) (X := 4.47673988) (rho := 0.15138173)
    (clo := (-0.2334791)) (chi := (-0.23347412)) (C := (-0.23347661)) (h := 0.15138422)
    (by norm_num) (by norm_num) oscBlock43 vbpBr43.1 vbpBr44.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i44 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00019094):ℝ) ≤ ∫ v in (vBP 1.376)..(vBP 1.39), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.62171745) (m := (0:ℤ)) (ylo := 1.48012479) (yhi := 1.4801248)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.376) (q1 := 1.39) (t0 := 7) (t1 := 7.25)
    (A := 0.63836133) (B := 0.65860767) (X := 4.62171745) (rho := 0.15318816)
    (clo := (-0.09056103)) (chi := (-0.0905471)) (C := (-0.09055407)) (h := 0.15319513)
    (by norm_num) (by norm_num) oscBlock44 vbpBr44.1 vbpBr45.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i45 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00046556):ℝ) ≤ ∫ v in (vBP 1.39)..(vBP 1.404), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.76523488) (m := (0:ℤ)) (ylo := 0.05284589) (yhi := 0.0528459)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.39) (q1 := 1.404) (t0 := 7) (t1 := 7.25)
    (A := 0.65860729) (B := 0.67865086) (X := 4.76523488) (rho := 0.15498387)
    (clo := 0.05282129) (chi := 0.05282131) (C := 0.0528213) (h := 0.15498388)
    (by norm_num) (by norm_num) oscBlock45 vbpBr45.1 vbpBr46.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i46 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00078285):ℝ) ≤ ∫ v in (vBP 1.404)..(vBP 1.418), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.90732121) (m := (0:ℤ)) (ylo := 0.19493222) (yhi := 0.19493223)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.404) (q1 := 1.418) (t0 := 7) (t1 := 7.25)
    (A := 0.67865033) (B := 0.69849519) (X := 4.90732121) (rho := 0.15676892)
    (clo := 0.19370003) (chi := 0.19370005) (C := 0.19370004) (h := 0.15676893)
    (by norm_num) (by norm_num) oscBlock46 vbpBr46.1 vbpBr47.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i47 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00105241):ℝ) ≤ ∫ v in (vBP 1.418)..(vBP 1.432), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.04800478) (m := (0:ℤ)) (ylo := 0.33561579) (yhi := 0.3356158)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.418) (q1 := 1.432) (t0 := 7) (t1 := 7.25)
    (A := 0.69849446) (B := 0.7181446) (X := 5.04800478) (rho := 0.15854358)
    (clo := 0.32935066) (chi := 0.32935068) (C := 0.32935067) (h := 0.15854359)
    (by norm_num) (by norm_num) oscBlock47 vbpBr47.1 vbpBr48.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i48 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00125959):ℝ) ≤ ∫ v in (vBP 1.432)..(vBP 1.446), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.18731296) (m := (0:ℤ)) (ylo := 0.47492397) (yhi := 0.47492398)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.432) (q1 := 1.446) (t0 := 7) (t1 := 7.25)
    (A := 0.7181436) (B := 0.73760286) (X := 5.18731296) (rho := 0.16030778)
    (clo := 0.45727083) (chi := 0.45727085) (C := 0.45727084) (h := 0.16030779)
    (by norm_num) (by norm_num) oscBlock48 vbpBr48.1 vbpBr49.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i49 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00165158):ℝ) ≤ ∫ v in (vBP 1.446)..(vBP 1.462), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.33519733) (m := (0:ℤ)) (ylo := 0.62280834) (yhi := 0.62280835)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.446) (q1 := 1.462) (t0 := 7) (t1 := 7.25)
    (A := 0.73760153) (B := 0.75961158) (X := 5.33519733) (rho := 0.17198664)
    (clo := 0.58331851) (chi := 0.58331853) (C := 0.58331852) (h := 0.17198665)
    (by norm_num) (by norm_num) oscBlock49 vbpBr49.1 vbpBr50.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i50 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00183932):ℝ) ≤ ∫ v in (vBP 1.462)..(vBP 1.478), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.49113949) (m := (0:ℤ)) (ylo := 0.7787505) (yhi := 0.77875051)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.462) (q1 := 1.478) (t0 := 7) (t1 := 7.25)
    (A := 0.75960973) (B := 0.78138081) (X := 5.49113949) (rho := 0.1738714)
    (clo := 0.70239058) (chi := 0.7023906) (C := 0.70239059) (h := 0.17387141)
    (by norm_num) (by norm_num) oscBlock50 vbpBr50.1 vbpBr51.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i51 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00204506):ℝ) ≤ ∫ v in (vBP 1.478)..(vBP 1.495), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.65024483) (m := (0:ℤ)) (ylo := 0.93785584) (yhi := 0.93785585)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.478) (q1 := 1.495) (t0 := 7) (t1 := 7.25)
    (A := 0.7813783) (B := 0.80425401) (X := 5.65024483) (rho := 0.18059675)
    (clo := 0.80629164) (chi := 0.80629167) (C := 0.80629165) (h := 0.18059677)
    (by norm_num) (by norm_num) oscBlock51 vbpBr51.1 vbpBr52.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i52 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00192131):ℝ) ≤ ∫ v in (vBP 1.495)..(vBP 1.512), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.81227607) (m := (0:ℤ)) (ylo := 1.09988708) (yhi := 1.09988709)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.495) (q1 := 1.512) (t0 := 7) (t1 := 7.25)
    (A := 0.80425056) (B := 0.82686872) (X := 5.81227607) (rho := 0.18252216)
    (clo := 0.89115613) (chi := 0.89115621) (C := 0.85431698) (h := 0.14568302)
    (by norm_num) (by norm_num) oscBlock52 vbpBr52.1 vbpBr53.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i53 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00197876):ℝ) ≤ ∫ v in (vBP 1.512)..(vBP 1.531), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.98196309) (m := (0:ℤ)) (ylo := 1.2695741) (yhi := 1.26957411)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.512) (q1 := 1.531) (t0 := 7) (t1 := 7.25)
    (A := 0.82686405) (B := 0.85184522) (X := 5.98196309) (rho := 0.19391476)
    (clo := 0.95497457) (chi := 0.95497493) (C := 0.8805299) (h := 0.1194701)
    (by norm_num) (by norm_num) oscBlock53 vbpBr53.1 vbpBr54.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i54 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.0018127):ℝ) ≤ ∫ v in (vBP 1.531)..(vBP 1.55), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.15879869) (m := (0:ℤ)) (ylo := 1.4464097) (yhi := 1.44640971)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.531) (q1 := 1.55) (t0 := 7) (t1 := 7.25)
    (A := 0.85183877) (B := 0.87651393) (X := 6.15879869) (rho := 0.19592732)
    (clo := 0.99227393) (chi := 0.99227539) (C := 0.8981733) (h := 0.1018267)
    (by norm_num) (by norm_num) oscBlock54 vbpBr54.1 vbpBr55.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i55 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00174878):ℝ) ≤ ∫ v in (vBP 1.55)..(vBP 1.57), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.33808635) (m := (1:ℤ)) (ylo := 0.05490104) (yhi := 0.05490105)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.55) (q1 := 1.57) (t0 := 7) (t1 := 7.25)
    (A := 0.87650515) (B := 0.90215678) (X := 6.33808635) (rho := 0.20255032)
    (clo := 0.99849331) (chi := 0.99849332) (C := 0.89797149) (h := 0.10202851)
    (by norm_num) (by norm_num) oscBlock55 vbpBr55.1 vbpBr56.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i56 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00159903):ℝ) ≤ ∫ v in (vBP 1.57)..(vBP 1.59), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.51960545) (m := (1:ℤ)) (ylo := 0.23642014) (yhi := 0.23642015)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.57) (q1 := 1.59) (t0 := 7) (t1 := 7.25)
    (A := 0.90214481) (B := 0.92747548) (X := 6.51960545) (rho := 0.20459179)
    (clo := 0.97218268) (chi := 0.9721827) (C := 0.88379544) (h := 0.11620456)
    (by norm_num) (by norm_num) oscBlock56 vbpBr56.1 vbpBr57.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i57 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00146404):ℝ) ≤ ∫ v in (vBP 1.59)..(vBP 1.61), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.69884152) (m := (1:ℤ)) (ylo := 0.41565621) (yhi := 0.41565622)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.59) (q1 := 1.61) (t0 := 7) (t1 := 7.25)
    (A := 0.92745939) (B := 0.95247825) (X := 6.69884152) (rho := 0.20662581)
    (clo := 0.91485154) (chi := 0.91485155) (C := 0.85411286) (h := 0.14588714)
    (by norm_num) (by norm_num) oscBlock57 vbpBr57.1 vbpBr58.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i58 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00149216):ℝ) ≤ ∫ v in (vBP 1.61)..(vBP 1.632), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.88474278) (m := (1:ℤ)) (ylo := 0.60155747) (yhi := 0.60155748)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.61) (q1 := 1.632) (t0 := 7) (t1 := 7.25)
    (A := 0.95245689) (B := 0.97962584) (X := 6.88474278) (rho := 0.21754457)
    (clo := 0.82445519) (chi := 0.82445521) (C := 0.80345531) (h := 0.19654469)
    (by norm_num) (by norm_num) oscBlock58 vbpBr58.1 vbpBr59.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i59 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00138508):ℝ) ≤ ∫ v in (vBP 1.632)..(vBP 1.656), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.08559222) (m := (1:ℤ)) (ylo := 0.80240691) (yhi := 0.80240692)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.632) (q1 := 1.656) (t0 := 7) (t1 := 7.25)
    (A := 0.97959707) (B := 1.00882827) (X := 7.08559222) (rho := 0.22841275)
    (clo := 0.69497807) (chi := 0.69497812) (C := 0.69497809) (h := 0.22841278)
    (by norm_num) (by norm_num) oscBlock59 vbpBr59.1 vbpBr60.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i60 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00103512):ℝ) ≤ ∫ v in (vBP 1.656)..(vBP 1.68), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.2921051) (m := (1:ℤ)) (ylo := 1.00891979) (yhi := 1.0089198)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.656) (q1 := 1.68) (t0 := 7) (t1 := 7.25)
    (A := 1.00878907) (B := 1.03761196) (X := 7.2921051) (rho := 0.23058162)
    (clo := 0.53277515) (chi := 0.53277547) (C := 0.53277531) (h := 0.23058178)
    (by norm_num) (by norm_num) oscBlock60 vbpBr60.1 vbpBr61.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i61 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00071653):ℝ) ≤ ∫ v in (vBP 1.68)..(vBP 1.704), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.49566832) (m := (1:ℤ)) (ylo := 1.21248301) (yhi := 1.21248302)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.68) (q1 := 1.704) (t0 := 7) (t1 := 7.25)
    (A := 1.03755935) (B := 1.06598913) (X := 7.49566832) (rho := 0.23275289)
    (clo := 0.35069514) (chi := 0.35069705) (C := 0.35069609) (h := 0.23275385)
    (by norm_num) (by norm_num) oscBlock61 vbpBr61.1 vbpBr62.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i62 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.0005379):ℝ) ≤ ∫ v in (vBP 1.704)..(vBP 1.734), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.72150529) (m := (1:ℤ)) (ylo := 1.43831998) (yhi := 1.43831999)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.704) (q1 := 1.734) (t0 := 7) (t1 := 7.25)
    (A := 1.06591948) (B := 1.10090679) (X := 7.72150529) (rho := 0.26006895)
    (clo := 0.13208902) (chi := 0.13209948) (C := 0.13209425) (h := 0.26007418)
    (by norm_num) (by norm_num) oscBlock62 vbpBr62.1 vbpBr63.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i63 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00046314):ℝ) ≤ ∫ v in (vBP 1.734)..(vBP 1.766), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 7.97626091) (m := (1:ℤ)) (ylo := 0.12227927) (yhi := 0.12227928)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.734) (q1 := 1.766) (t0 := 7) (t1 := 7.25)
    (A := 1.10080961) (B := 1.13749718) (X := 7.97626091) (rho := 0.27059366)
    (clo := (-0.12197479)) (chi := (-0.12197477)) (C := (-0.12197478)) (h := 0.27059367)
    (by norm_num) (by norm_num) oscBlock63 vbpBr63.1 vbpBr64.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i64 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00057532):ℝ) ≤ ∫ v in (vBP 1.766)..(vBP 1.796), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.22639619) (m := (1:ℤ)) (ylo := 0.37241455) (yhi := 0.37241456)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.766) (q1 := 1.796) (t0 := 7) (t1 := 7.25)
    (A := 1.1373613) (B := 1.17120873) (X := 8.22639619) (rho := 0.26486711)
    (clo := (-0.36386554)) (chi := (-0.36386552)) (C := (-0.36386553)) (h := 0.26486712)
    (by norm_num) (by norm_num) oscBlock64 vbpBr64.1 vbpBr65.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i65 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00077279):ℝ) ≤ ∫ v in (vBP 1.796)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.47236837) (m := (1:ℤ)) (ylo := 0.61838673) (yhi := 0.61838674)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.796) (q1 := 1.828) (t0 := 7) (t1 := 7.25)
    (A := 1.1710258) (B := 1.20655947) (X := 8.47236837) (rho := 0.27518779)
    (clo := (-0.57972141)) (chi := (-0.57972139)) (C := (-0.5797214)) (h := 0.2751878)
    (by norm_num) (by norm_num) oscBlock65 vbpBr65.1 vbpBr66.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i66 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00084834):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.86), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.72182503) (m := (1:ℤ)) (ylo := 0.86784339) (yhi := 0.8678434)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.828) (q1 := 1.86) (t0 := 7) (t1 := 7.25)
    (A := 1.20631244) (B := 1.24130524) (X := 8.72182503) (rho := 0.27763797)
    (clo := (-0.76293654)) (chi := (-0.76293652)) (C := (-0.74264928)) (h := 0.25735073)
    (by norm_num) (by norm_num) oscBlock66 vbpBr66.1 vbpBr67.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i67 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00072254):ℝ) ≤ ∫ v in (vBP 1.86)..(vBP 1.89), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.95931247) (m := (1:ℤ)) (ylo := 1.10533083) (yhi := 1.10533084)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.86) (q1 := 1.89) (t0 := 7) (t1 := 7.25)
    (A := 1.24097685) (B := 1.27334993) (X := 8.95931247) (rho := 0.27247454)
    (clo := (-0.89361281)) (chi := (-0.89361272)) (C := (-0.81056909)) (h := 0.18943091)
    (by norm_num) (by norm_num) oscBlock67 vbpBr67.1 vbpBr68.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i68 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00072035):ℝ) ≤ ∫ v in (vBP 1.89)..(vBP 1.922), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 9.19306995) (m := (1:ℤ)) (ylo := 1.33908831) (yhi := 1.33908832)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.89) (q1 := 1.922) (t0 := 7) (t1 := 7.25)
    (A := 1.27292668) (B := 1.30698664) (X := 9.19306995) (rho := 0.2825832)
    (clo := (-0.97327621)) (chi := (-0.97327557)) (C := (-0.84534619)) (h := 0.15465382)
    (by norm_num) (by norm_num) oscBlock68 vbpBr68.1 vbpBr69.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i69 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00096789):ℝ) ≤ ∫ v in (vBP 1.922)..(vBP 1.969), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 9.48591385) (m := (1:ℤ)) (ylo := 0.06113588) (yhi := 0.06113589)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.922) (q1 := 1.969) (t0 := 7) (t1 := 7.25)
    (A := 1.30643896) (B := 1.35541448) (X := 9.48591385) (rho := 0.34084114)
    (clo := (-0.99813179)) (chi := (-0.99813178)) (C := (-0.82864532)) (h := 0.17135468)
    (by norm_num) (by norm_num) oscBlock69 vbpBr69.1 vbpBr70.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i70 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00087887):ℝ) ≤ ∫ v in (vBP 1.969)..(vBP 2.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 9.82613417) (m := (1:ℤ)) (ylo := 0.4013562) (yhi := 0.40135621)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.969) (q1 := 2.016) (t0 := 7) (t1 := 7.25)
    (A := 1.35463226) (B := 1.4027369) (X := 9.82613417) (rho := 0.34370837)
    (clo := (-0.92053202)) (chi := (-0.92053201)) (C := (-0.78841182)) (h := 0.21158818)
    (by norm_num) (by norm_num) oscBlock70 vbpBr70.1 vbpBr71.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i71 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.00078634):ℝ) ≤ ∫ v in (vBP 2.016)..(vBP 2.062), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 10.15490437) (m := (1:ℤ)) (ylo := 0.7301264) (yhi := 0.73012641)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.016) (q1 := 2.062) (t0 := 7) (t1 := 7.25)
    (A := 1.40164597) (B := 1.44803958) (X := 10.15490437) (rho := 0.3433826)
    (clo := (-0.74509012)) (chi := (-0.74509009)) (C := (-0.70085375)) (h := 0.29914626)
    (by norm_num) (by norm_num) oscBlock71 vbpBr71.1 vbpBr72.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB2i72 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.0004289):ℝ) ≤ ∫ v in (vBP 2.062)..(vBP 2.094), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 10.42430567) (m := (1:ℤ)) (ylo := 0.9995277) (yhi := 0.99952771)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.062) (q1 := 2.094) (t0 := 7) (t1 := 7.25)
    (A := 1.44655973) (B := 1.47899217) (X := 10.42430567) (rho := 0.29838758)
    (clo := (-0.54069995)) (chi := (-0.54069966)) (C := (-0.54069981)) (h := 0.29838773)
    (by norm_num) (by norm_num) oscBlock72 vbpBr72.1 vbpBr73.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

/-- Lower bound for the oscillatory integral `∫₀^∞ err(v) cos(tv) dv` on the band
`7.0 ≤ t ≤ 7.25`. -/
theorem oscBandLower2 {t : ℝ} (ht0 : (7:ℝ) ≤ t) (ht1 : t ≤ 7.25) :
    ((-0.16013617):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosB2i0 ht0 ht1)
    (cosB2i1 ht0 ht1))
    (cosB2i2 ht0 ht1))
    (cosB2i3 ht0 ht1))
    (cosB2i4 ht0 ht1))
    (cosB2i5 ht0 ht1))
    (cosB2i6 ht0 ht1))
    (cosB2i7 ht0 ht1))
    (cosB2i8 ht0 ht1))
    (cosB2i9 ht0 ht1))
    (cosB2i10 ht0 ht1))
    (cosB2i11 ht0 ht1))
    (cosB2i12 ht0 ht1))
    (cosB2i13 ht0 ht1))
    (cosB2i14 ht0 ht1))
    (cosB2i15 ht0 ht1))
    (cosB2i16 ht0 ht1))
    (cosB2i17 ht0 ht1))
    (cosB2i18 ht0 ht1))
    (cosB2i19 ht0 ht1))
    (cosB2i20 ht0 ht1))
    (cosB2i21 ht0 ht1))
    (cosB2i22 ht0 ht1))
    (cosB2i23 ht0 ht1))
    (cosB2i24 ht0 ht1))
    (cosB2i25 ht0 ht1))
    (cosB2i26 ht0 ht1))
    (cosB2i27 ht0 ht1))
    (cosB2i28 ht0 ht1))
    (cosB2i29 ht0 ht1))
    (cosB2i30 ht0 ht1))
    (cosB2i31 ht0 ht1))
    (cosB2i32 ht0 ht1))
    (cosB2i33 ht0 ht1))
    (cosB2i34 ht0 ht1))
    (cosB2i35 ht0 ht1))
    (cosB2i36 ht0 ht1))
    (cosB2i37 ht0 ht1))
    (cosB2i38 ht0 ht1))
    (cosB2i39 ht0 ht1))
    (cosB2i40 ht0 ht1))
    (cosB2i41 ht0 ht1))
    (cosB2i42 ht0 ht1))
    (cosB2i43 ht0 ht1))
    (cosB2i44 ht0 ht1))
    (cosB2i45 ht0 ht1))
    (cosB2i46 ht0 ht1))
    (cosB2i47 ht0 ht1))
    (cosB2i48 ht0 ht1))
    (cosB2i49 ht0 ht1))
    (cosB2i50 ht0 ht1))
    (cosB2i51 ht0 ht1))
    (cosB2i52 ht0 ht1))
    (cosB2i53 ht0 ht1))
    (cosB2i54 ht0 ht1))
    (cosB2i55 ht0 ht1))
    (cosB2i56 ht0 ht1))
    (cosB2i57 ht0 ht1))
    (cosB2i58 ht0 ht1))
    (cosB2i59 ht0 ht1))
    (cosB2i60 ht0 ht1))
    (cosB2i61 ht0 ht1))
    (cosB2i62 ht0 ht1))
    (cosB2i63 ht0 ht1))
    (cosB2i64 ht0 ht1))
    (cosB2i65 ht0 ht1))
    (cosB2i66 ht0 ht1))
    (cosB2i67 ht0 ht1))
    (cosB2i68 ht0 ht1))
    (cosB2i69 ht0 ht1))
    (cosB2i70 ht0 ht1))
    (cosB2i71 ht0 ht1))
    (cosB2i72 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 2.094) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 2.094) (S := 0.013709)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_cut
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
