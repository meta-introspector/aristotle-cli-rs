/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscTail

/-!
# Oscillatory lower bound on the band `6.625 ≤ t ≤ 6.75`

On each of the 73 blocks the factor `cos(tv)` is bracketed by a rational constant
`C` up to a rational error `h`; the signed contribution `min(C·P₀, C·P₁) - h·S` is
then summed, and the unresolved tail beyond `q = 2.094` is estimated in absolute
value.  The result is the bound `∫₀^∞ err(v) cos(tv) dv ≥ -0.14656823`.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosB5i0 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00641868):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.0038), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.0256014) (m := (0:ℤ)) (ylo := 0.0256014) (yhi := 0.0256014)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1) (q1 := 1.0038) (t0 := 6.625) (t1 := 6.75)
    (A := 0.0) (B := 0.0075856) (X := 0.0256014) (rho := 0.02560141)
    (clo := 0.9996723) (chi := 0.99967231) (C := 0.98703544) (h := 0.01296456)
    (by norm_num) (by norm_num) oscBlock0 vbpBr0.1 vbpBr1.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i1 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00625872):ℝ) ≤ ∫ v in (vBP 1.0038)..(vBP 1.0078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.07757301) (m := (0:ℤ)) (ylo := 0.07757301) (yhi := 0.07757301)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0038) (q1 := 1.0078) (t0 := 6.625) (t1 := 6.75)
    (A := 0.00758559) (B := 0.01553948) (X := 0.07757301) (rho := 0.02731849)
    (clo := 0.99699272) (chi := 0.99699273) (C := 0.98483711) (h := 0.01516289)
    (by norm_num) (by norm_num) oscBlock1 vbpBr1.1 vbpBr2.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i2 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.0057677):ℝ) ≤ ∫ v in (vBP 1.0078)..(vBP 1.0118), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.13065823) (m := (0:ℤ)) (ylo := 0.13065823) (yhi := 0.13065823)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0078) (q1 := 1.0118) (t0 := 6.625) (t1 := 6.75)
    (A := 0.01553947) (B := 0.02346185) (X := 0.13065823) (rho := 0.02770926)
    (clo := 0.99147634) (chi := 0.99147635) (C := 0.98188354) (h := 0.01811646)
    (by norm_num) (by norm_num) oscBlock2 vbpBr2.1 vbpBr3.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i3 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00554846):ℝ) ≤ ∫ v in (vBP 1.0118)..(vBP 1.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.18486245) (m := (0:ℤ)) (ylo := 0.18486245) (yhi := 0.18486245)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0118) (q1 := 1.016) (t0 := 6.625) (t1 := 6.75)
    (A := 0.02346184) (B := 0.0317467) (X := 0.18486245) (rho := 0.02942778)
    (clo := 0.98296154) (chi := 0.98296155) (C := 0.97676688) (h := 0.02323312)
    (by norm_num) (by norm_num) oscBlock3 vbpBr3.1 vbpBr4.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i4 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00539232):ℝ) ≤ ∫ v in (vBP 1.016)..(vBP 1.0205), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.24213666) (m := (0:ℤ)) (ylo := 0.24213666) (yhi := 0.24213666)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.016) (q1 := 1.0205) (t0 := 6.625) (t1 := 6.75)
    (A := 0.03174669) (B := 0.04058541) (X := 0.24213666) (rho := 0.03181486)
    (clo := 0.97082786) (chi := 0.97082787) (C := 0.9695065) (h := 0.0304935)
    (by norm_num) (by norm_num) oscBlock4 vbpBr4.1 vbpBr5.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i5 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00478908):ℝ) ≤ ∫ v in (vBP 1.0205)..(vBP 1.025), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.30111428) (m := (0:ℤ)) (ylo := 0.30111428) (yhi := 0.30111428)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0205) (q1 := 1.025) (t0 := 6.625) (t1 := 6.75)
    (A := 0.0405854) (B := 0.04938523) (X := 0.30111428) (rho := 0.03223603)
    (clo := 0.9550066) (chi := 0.95500661) (C := 0.9550066) (h := 0.03223604)
    (by norm_num) (by norm_num) oscBlock5 vbpBr5.1 vbpBr6.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i6 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00465061):ℝ) ≤ ∫ v in (vBP 1.025)..(vBP 1.03), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.36311047) (m := (0:ℤ)) (ylo := 0.36311047) (yhi := 0.36311047)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.025) (q1 := 1.03) (t0 := 6.625) (t1 := 6.75)
    (A := 0.04938522) (B := 0.05911761) (X := 0.36311047) (rho := 0.03593341)
    (clo := 0.93479655) (chi := 0.93479656) (C := 0.93479655) (h := 0.03593342)
    (by norm_num) (by norm_num) oscBlock6 vbpBr6.1 vbpBr7.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i7 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00432986):ℝ) ≤ ∫ v in (vBP 1.03)..(vBP 1.0355), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.43129678) (m := (0:ℤ)) (ylo := 0.43129678) (yhi := 0.43129678)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.03) (q1 := 1.0355) (t0 := 6.625) (t1 := 6.75)
    (A := 0.0591176) (B := 0.06976881) (X := 0.43129678) (rho := 0.0396427)
    (clo := 0.90842439) (chi := 0.9084244) (C := 0.90842439) (h := 0.03964271)
    (by norm_num) (by norm_num) oscBlock7 vbpBr7.1 vbpBr8.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i8 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00384939):ℝ) ≤ ∫ v in (vBP 1.0355)..(vBP 1.0415), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.50557754) (m := (0:ℤ)) (ylo := 0.50557754) (yhi := 0.50557754)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0355) (q1 := 1.0415) (t0 := 6.625) (t1 := 6.75)
    (A := 0.0697688) (B := 0.08132397) (X := 0.50557754) (rho := 0.04335926)
    (clo := 0.87489491) (chi := 0.87489492) (C := 0.87489491) (h := 0.04335927)
    (by norm_num) (by norm_num) oscBlock8 vbpBr8.1 vbpBr9.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i9 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00323889):ℝ) ≤ ∫ v in (vBP 1.0415)..(vBP 1.048), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.58584985) (m := (0:ℤ)) (ylo := 0.58584985) (yhi := 0.58584985)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0415) (q1 := 1.048) (t0 := 6.625) (t1 := 6.75)
    (A := 0.08132396) (B := 0.09376718) (X := 0.58584985) (rho := 0.04707863)
    (clo := 0.83324249) (chi := 0.8332425) (C := 0.83324249) (h := 0.04707864)
    (by norm_num) (by norm_num) oscBlock9 vbpBr9.1 vbpBr10.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i10 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00255429):ℝ) ≤ ∫ v in (vBP 1.048)..(vBP 1.055), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.67200394) (m := (0:ℤ)) (ylo := 0.67200394) (yhi := 0.67200394)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.048) (q1 := 1.055) (t0 := 6.625) (t1 := 6.75)
    (A := 0.09376717) (B := 0.10708154) (X := 0.67200394) (rho := 0.05079646)
    (clo := 0.78257567) (chi := 0.78257568) (C := 0.78257567) (h := 0.05079647)
    (by norm_num) (by norm_num) oscBlock10 vbpBr10.1 vbpBr11.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i11 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00207861):ℝ) ≤ ∫ v in (vBP 1.055)..(vBP 1.064), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.77344648) (m := (0:ℤ)) (ylo := 0.77344648) (yhi := 0.77344648)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.055) (q1 := 1.064) (t0 := 6.625) (t1 := 6.75)
    (A := 0.10708153) (B := 0.12407079) (X := 0.77344648) (rho := 0.06403136)
    (clo := 0.71550719) (chi := 0.71550722) (C := 0.7155072) (h := 0.06403138)
    (by norm_num) (by norm_num) oscBlock11 vbpBr11.1 vbpBr12.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i12 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00130855):ℝ) ≤ ∫ v in (vBP 1.064)..(vBP 1.078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.91795991) (m := (0:ℤ)) (ylo := 0.91795991) (yhi := 0.91795991)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.064) (q1 := 1.078) (t0 := 6.625) (t1 := 6.75)
    (A := 0.12407078) (B := 0.15021495) (X := 0.91795991) (rho := 0.09599101)
    (clo := 0.60744199) (chi := 0.60744212) (C := 0.60744205) (h := 0.09599108)
    (by norm_num) (by norm_num) oscBlock12 vbpBr12.1 vbpBr13.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i13 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    (0.00009672:ℝ) ≤ ∫ v in (vBP 1.078)..(vBP 1.09), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.07928646) (m := (0:ℤ)) (ylo := 1.07928646) (yhi := 1.07928646)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.078) (q1 := 1.09) (t0 := 6.625) (t1 := 6.75)
    (A := 0.15021494) (B := 0.1723554) (X := 1.07928646) (rho := 0.0841125)
    (clo := 0.47195755) (chi := 0.47195815) (C := 0.47195785) (h := 0.0841128)
    (by norm_num) (by norm_num) oscBlock13 vbpBr13.1 vbpBr14.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i14 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    (0.00043831:ℝ) ≤ ∫ v in (vBP 1.09)..(vBP 1.1), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.21427094) (m := (0:ℤ)) (ylo := 1.21427094) (yhi := 1.21427094)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.09) (q1 := 1.1) (t0 := 6.625) (t1 := 6.75)
    (A := 0.17235539) (B := 0.19062036) (X := 1.21427094) (rho := 0.0724165)
    (clo := 0.34902021) (chi := 0.34902214) (C := 0.34902117) (h := 0.07241747)
    (by norm_num) (by norm_num) oscBlock14 vbpBr14.1 vbpBr15.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i15 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    (0.00037805:ℝ) ≤ ∫ v in (vBP 1.1)..(vBP 1.109), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.3297762) (m := (0:ℤ)) (ylo := 1.3297762) (yhi := 1.3297762)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.1) (q1 := 1.109) (t0 := 6.625) (t1 := 6.75)
    (A := 0.19062035) (B := 0.20691742) (X := 1.3297762) (rho := 0.0669164)
    (clo := 0.23869332) (chi := 0.2386981) (C := 0.23869571) (h := 0.06691879)
    (by norm_num) (by norm_num) oscBlock15 vbpBr15.1 vbpBr16.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i16 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    (0.00017291:ℝ) ≤ ∫ v in (vBP 1.109)..(vBP 1.117), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.43227796) (m := (0:ℤ)) (ylo := 1.43227796) (yhi := 1.43227796)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.109) (q1 := 1.117) (t0 := 6.625) (t1 := 6.75)
    (A := 0.20691741) (B := 0.22129305) (X := 1.43227796) (rho := 0.06145014)
    (clo := 0.13807567) (chi := 0.13808569) (C := 0.13808068) (h := 0.06145515)
    (by norm_num) (by norm_num) oscBlock16 vbpBr16.1 vbpBr17.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i17 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00004558):ℝ) ≤ ∫ v in (vBP 1.117)..(vBP 1.124), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.52206604) (m := (0:ℤ)) (ylo := 1.52206604) (yhi := 1.52206604)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.117) (q1 := 1.124) (t0 := 6.625) (t1 := 6.75)
    (A := 0.22129304) (B := 0.23378751) (X := 1.52206604) (rho := 0.05599967)
    (clo := 0.04871068) (chi := 0.04872908) (C := 0.04871988) (h := 0.05600887)
    (by norm_num) (by norm_num) oscBlock17 vbpBr17.1 vbpBr18.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i18 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00030971):ℝ) ≤ ∫ v in (vBP 1.124)..(vBP 1.131), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.60536094) (m := (0:ℤ)) (ylo := 0.03456461) (yhi := 0.03456462)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.124) (q1 := 1.131) (t0 := 6.625) (t1 := 6.75)
    (A := 0.2337875) (B := 0.2462044) (X := 1.60536094) (rho := 0.05651877)
    (clo := (-0.03455774)) (chi := (-0.03455772)) (C := (-0.03455773)) (h := 0.05651878)
    (by norm_num) (by norm_num) oscBlock18 vbpBr18.1 vbpBr19.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i19 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00062725):ℝ) ≤ ∫ v in (vBP 1.131)..(vBP 1.138), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.68814033) (m := (0:ℤ)) (ylo := 0.117344) (yhi := 0.11734401)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.131) (q1 := 1.138) (t0 := 6.625) (t1 := 6.75)
    (A := 0.24620439) (B := 0.25854468) (X := 1.68814033) (rho := 0.05703627)
    (clo := (-0.1170749)) (chi := (-0.11707488)) (C := (-0.11707489)) (h := 0.05703628)
    (by norm_num) (by norm_num) oscBlock19 vbpBr19.1 vbpBr20.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i20 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00095266):ℝ) ≤ ∫ v in (vBP 1.138)..(vBP 1.145), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.77041053) (m := (0:ℤ)) (ylo := 0.1996142) (yhi := 0.19961421)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.138) (q1 := 1.145) (t0 := 6.625) (t1 := 6.75)
    (A := 0.25854467) (B := 0.27080928) (X := 1.77041053) (rho := 0.05755212)
    (clo := (-0.19829122)) (chi := (-0.1982912)) (C := (-0.19829121)) (h := 0.05755213)
    (by norm_num) (by norm_num) oscBlock20 vbpBr20.1 vbpBr21.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i21 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00128599):ℝ) ≤ ∫ v in (vBP 1.145)..(vBP 1.152), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.85217777) (m := (0:ℤ)) (ylo := 0.28138144) (yhi := 0.28138145)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.145) (q1 := 1.152) (t0 := 6.625) (t1 := 6.75)
    (A := 0.27080927) (B := 0.28299913) (X := 1.85217777) (rho := 0.05806637)
    (clo := (-0.27768304)) (chi := (-0.27768302)) (C := (-0.27768303)) (h := 0.05806638)
    (by norm_num) (by norm_num) oscBlock21 vbpBr21.1 vbpBr22.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i22 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.0016127):ℝ) ≤ ∫ v in (vBP 1.152)..(vBP 1.159), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.93344814) (m := (0:ℤ)) (ylo := 0.36265181) (yhi := 0.36265182)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.152) (q1 := 1.159) (t0 := 6.625) (t1 := 6.75)
    (A := 0.28299912) (B := 0.29511513) (X := 1.93344814) (rho := 0.05857899)
    (clo := (-0.35475483)) (chi := (-0.35475481)) (C := (-0.35475482)) (h := 0.058579)
    (by norm_num) (by norm_num) oscBlock22 vbpBr22.1 vbpBr23.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i23 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00192079):ℝ) ≤ ∫ v in (vBP 1.159)..(vBP 1.166), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.01422769) (m := (0:ℤ)) (ylo := 0.44343136) (yhi := 0.44343137)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.159) (q1 := 1.166) (t0 := 6.625) (t1 := 6.75)
    (A := 0.29511512) (B := 0.30715818) (X := 2.01422769) (rho := 0.05909004)
    (clo := (-0.42904149)) (chi := (-0.42904148)) (C := (-0.42904149)) (h := 0.05909005)
    (by norm_num) (by norm_num) oscBlock23 vbpBr23.1 vbpBr24.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i24 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00220122):ℝ) ≤ ∫ v in (vBP 1.166)..(vBP 1.173), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.09452228) (m := (0:ℤ)) (ylo := 0.52372595) (yhi := 0.52372596)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.166) (q1 := 1.173) (t0 := 6.625) (t1 := 6.75)
    (A := 0.30715817) (B := 0.31912914) (X := 2.09452228) (rho := 0.05959942)
    (clo := (-0.50011015)) (chi := (-0.50011013)) (C := (-0.50011014)) (h := 0.05959943)
    (by norm_num) (by norm_num) oscBlock24 vbpBr24.1 vbpBr25.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i25 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00244655):ℝ) ≤ ∫ v in (vBP 1.173)..(vBP 1.18), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.17433771) (m := (0:ℤ)) (ylo := 0.60354138) (yhi := 0.60354139)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.173) (q1 := 1.18) (t0 := 6.625) (t1 := 6.75)
    (A := 0.31912913) (B := 0.33102888) (X := 2.17433771) (rho := 0.06010724)
    (clo := (-0.56756177)) (chi := (-0.56756175)) (C := (-0.56756176)) (h := 0.06010725)
    (by norm_num) (by norm_num) oscBlock25 vbpBr25.1 vbpBr26.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i26 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00265092):ℝ) ≤ ∫ v in (vBP 1.18)..(vBP 1.187), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.25367969) (m := (0:ℤ)) (ylo := 0.68288336) (yhi := 0.68288337)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.18) (q1 := 1.187) (t0 := 6.625) (t1 := 6.75)
    (A := 0.33102887) (B := 0.34285824) (X := 2.25367969) (rho := 0.06061344)
    (clo := (-0.63103244)) (chi := (-0.63103242)) (C := (-0.63103243)) (h := 0.06061345)
    (by norm_num) (by norm_num) oscBlock26 vbpBr26.1 vbpBr27.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i27 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00281017):ℝ) ≤ ∫ v in (vBP 1.187)..(vBP 1.194), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.33255377) (m := (0:ℤ)) (ylo := 0.76175744) (yhi := 0.76175745)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.187) (q1 := 1.194) (t0 := 6.625) (t1 := 6.75)
    (A := 0.34285823) (B := 0.35461804) (X := 2.33255377) (rho := 0.06111801)
    (clo := (-0.69019425)) (chi := (-0.69019423)) (C := (-0.69019424)) (h := 0.06111802)
    (by norm_num) (by norm_num) oscBlock27 vbpBr27.1 vbpBr28.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i28 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00295167):ℝ) ≤ ∫ v in (vBP 1.194)..(vBP 1.201), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.41096537) (m := (0:ℤ)) (ylo := 0.84016904) (yhi := 0.84016905)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.194) (q1 := 1.201) (t0 := 6.625) (t1 := 6.75)
    (A := 0.35461802) (B := 0.36630909) (X := 2.41096537) (rho := 0.061621)
    (clo := (-0.74475595)) (chi := (-0.74475593)) (C := (-0.74475594)) (h := 0.06162101)
    (by norm_num) (by norm_num) oscBlock28 vbpBr28.1 vbpBr29.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i29 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.0030157):ℝ) ≤ ∫ v in (vBP 1.201)..(vBP 1.208), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.48892) (m := (0:ℤ)) (ylo := 0.91812367) (yhi := 0.91812368)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.201) (q1 := 1.208) (t0 := 6.625) (t1 := 6.75)
    (A := 0.36630908) (B := 0.3779322) (X := 2.48892) (rho := 0.06212236)
    (clo := (-0.79446352)) (chi := (-0.7944635)) (C := (-0.79446351)) (h := 0.06212237)
    (by norm_num) (by norm_num) oscBlock29 vbpBr29.1 vbpBr30.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i30 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00303097):ℝ) ≤ ∫ v in (vBP 1.208)..(vBP 1.215), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.56642291) (m := (0:ℤ)) (ylo := 0.99562658) (yhi := 0.99562659)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.208) (q1 := 1.215) (t0 := 6.625) (t1 := 6.75)
    (A := 0.37793219) (B := 0.38948816) (X := 2.56642291) (rho := 0.06262218)
    (clo := (-0.83910001)) (chi := (-0.83909997)) (C := (-0.83909999)) (h := 0.0626222)
    (by norm_num) (by norm_num) oscBlock30 vbpBr30.1 vbpBr31.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i31 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00344272):ℝ) ≤ ∫ v in (vBP 1.215)..(vBP 1.223), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.6490008) (m := (0:ℤ)) (ylo := 1.07820447) (yhi := 1.07820448)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.215) (q1 := 1.223) (t0 := 6.625) (t1 := 6.75)
    (A := 0.38948815) (B := 0.40261372) (X := 2.6490008) (rho := 0.06864182)
    (clo := (-0.88111017)) (chi := (-0.8811101)) (C := (-0.88111014)) (h := 0.06864186)
    (by norm_num) (by norm_num) oscBlock31 vbpBr31.1 vbpBr32.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i32 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00333391):ℝ) ≤ ∫ v in (vBP 1.223)..(vBP 1.231), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.73648915) (m := (0:ℤ)) (ylo := 1.16569282) (yhi := 1.16569283)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.223) (q1 := 1.231) (t0 := 6.625) (t1 := 6.75)
    (A := 0.40261371) (B := 0.4156537) (X := 2.73648915) (rho := 0.06917334)
    (clo := (-0.91906175)) (chi := (-0.9190616)) (C := (-0.91906168)) (h := 0.06917342)
    (by norm_num) (by norm_num) oscBlock32 vbpBr32.1 vbpBr33.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i33 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00310539):ℝ) ≤ ∫ v in (vBP 1.231)..(vBP 1.239), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.82340893) (m := (0:ℤ)) (ylo := 1.2526126) (yhi := 1.25261261)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.231) (q1 := 1.239) (t0 := 6.625) (t1 := 6.75)
    (A := 0.41565369) (B := 0.42860921) (X := 2.82340893) (rho := 0.06970325)
    (clo := (-0.94980549)) (chi := (-0.94980518)) (C := (-0.94005097)) (h := 0.05994904)
    (by norm_num) (by norm_num) oscBlock33 vbpBr33.1 vbpBr34.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i34 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00315711):ℝ) ≤ ∫ v in (vBP 1.239)..(vBP 1.248), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.91517833) (m := (0:ℤ)) (ylo := 1.344382) (yhi := 1.34438201)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.239) (q1 := 1.248) (t0 := 6.625) (t1 := 6.75)
    (A := 0.4286092) (B := 0.44308455) (X := 2.91517833) (rho := 0.0756424)
    (clo := (-0.97447824)) (chi := (-0.97447757)) (C := (-0.94941759)) (h := 0.05058242)
    (by norm_num) (by norm_num) oscBlock34 vbpBr34.1 vbpBr35.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i35 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00307603):ℝ) ≤ ∫ v in (vBP 1.248)..(vBP 1.258), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.01699883) (m := (0:ℤ)) (ylo := 1.4462025) (yhi := 1.44620251)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.248) (q1 := 1.258) (t0 := 6.625) (t1 := 6.75)
    (A := 0.44308453) (B := 0.45904632) (X := 3.01699883) (rho := 0.08156384)
    (clo := (-0.99224966)) (chi := (-0.9922482)) (C := (-0.95534218)) (h := 0.04465782)
    (by norm_num) (by norm_num) oscBlock35 vbpBr35.1 vbpBr36.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i36 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00264809):ℝ) ≤ ∫ v in (vBP 1.258)..(vBP 1.268), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.1233167) (m := (0:ℤ)) (ylo := 1.55252037) (yhi := 1.55252038)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.258) (q1 := 1.268) (t0 := 6.625) (t1 := 6.75)
    (A := 0.45904631) (B := 0.47488172) (X := 3.1233167) (rho := 0.08213492)
    (clo := (-0.99983612)) (chi := (-0.99983295)) (C := (-0.95884902)) (h := 0.04115099)
    (by norm_num) (by norm_num) oscBlock36 vbpBr36.1 vbpBr37.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i37 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00261049):ℝ) ≤ ∫ v in (vBP 1.268)..(vBP 1.28), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.2393512) (m := (0:ℤ)) (ylo := 0.09775854) (yhi := 0.09775855)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.268) (q1 := 1.28) (t0 := 6.625) (t1 := 6.75)
    (A := 0.4748817) (B := 0.49372017) (X := 3.2393512) (rho := 0.09325996)
    (clo := (-0.99522544)) (chi := (-0.99522543)) (C := (-0.95098274)) (h := 0.04901727)
    (by norm_num) (by norm_num) oscBlock37 vbpBr37.1 vbpBr38.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i38 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00228621):ℝ) ≤ ∫ v in (vBP 1.28)..(vBP 1.294), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.37518084) (m := (0:ℤ)) (ylo := 0.23358818) (yhi := 0.23358819)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.28) (q1 := 1.294) (t0 := 6.625) (t1 := 6.75)
    (A := 0.49372014) (B := 0.51547641) (X := 3.37518084) (rho := 0.10428493)
    (clo := (-0.97284211)) (chi := (-0.9728421)) (C := (-0.93427859)) (h := 0.06572142)
    (by norm_num) (by norm_num) oscBlock38 vbpBr38.1 vbpBr39.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i39 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00152768):ℝ) ≤ ∫ v in (vBP 1.294)..(vBP 1.308), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.51988554) (m := (0:ℤ)) (ylo := 0.37829288) (yhi := 0.37829289)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.294) (q1 := 1.308) (t0 := 6.625) (t1 := 6.75)
    (A := 0.51547638) (B := 0.53699853) (X := 3.51988554) (rho := 0.10485454)
    (clo := (-0.92929649)) (chi := (-0.92929648)) (C := (-0.91222097)) (h := 0.08777903)
    (by norm_num) (by norm_num) oscBlock39 vbpBr39.1 vbpBr40.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i40 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00098514):ℝ) ≤ ∫ v in (vBP 1.308)..(vBP 1.326), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.6834341) (m := (0:ℤ)) (ylo := 0.54184144) (yhi := 0.54184145)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.308) (q1 := 1.326) (t0 := 6.625) (t1 := 6.75)
    (A := 0.53699848) (B := 0.56433382) (X := 3.6834341) (rho := 0.12581919)
    (clo := (-0.85676048)) (chi := (-0.85676047)) (C := (-0.85676048)) (h := 0.1258192)
    (by norm_num) (by norm_num) oscBlock40 vbpBr40.1 vbpBr41.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i41 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00013355):ℝ) ≤ ∫ v in (vBP 1.326)..(vBP 1.345), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.87001528) (m := (0:ℤ)) (ylo := 0.72842262) (yhi := 0.72842263)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.326) (q1 := 1.345) (t0 := 6.625) (t1 := 6.75)
    (A := 0.56433374) (B := 0.59278808) (X := 3.87001528) (rho := 0.13130427)
    (clo := (-0.7462254)) (chi := (-0.74622537)) (C := (-0.74622539)) (h := 0.13130429)
    (by norm_num) (by norm_num) oscBlock41 vbpBr41.1 vbpBr42.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i42 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    (0.00043685:ℝ) ≤ ∫ v in (vBP 1.345)..(vBP 1.362), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.0490513) (m := (0:ℤ)) (ylo := 0.90745864) (yhi := 0.90745865)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.345) (q1 := 1.362) (t0 := 6.625) (t1 := 6.75)
    (A := 0.59278796) (B := 0.6179085) (X := 4.0490513) (rho := 0.12183108)
    (clo := (-0.61575029)) (chi := (-0.61575017)) (C := (-0.61575023)) (h := 0.12183114)
    (by norm_num) (by norm_num) oscBlock42 vbpBr42.1 vbpBr43.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i43 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    (0.00042881:ℝ) ≤ ∫ v in (vBP 1.362)..(vBP 1.376), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.20129167) (m := (0:ℤ)) (ylo := 1.05969901) (yhi := 1.05969902)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.362) (q1 := 1.376) (t0 := 6.625) (t1 := 6.75)
    (A := 0.61790831) (B := 0.6383616) (X := 4.20129167) (rho := 0.10764914)
    (clo := (-0.48913512)) (chi := (-0.48913461)) (C := (-0.48913487)) (h := 0.1076494)
    (by norm_num) (by norm_num) oscBlock43 vbpBr43.1 vbpBr44.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i44 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    (0.00033026:ℝ) ≤ ∫ v in (vBP 1.376)..(vBP 1.39), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.33737279) (m := (0:ℤ)) (ylo := 1.19578013) (yhi := 1.19578014)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.376) (q1 := 1.39) (t0 := 6.625) (t1 := 6.75)
    (A := 0.63836133) (B := 0.65860767) (X := 4.33737279) (rho := 0.108229)
    (clo := (-0.36628923)) (chi := (-0.36628757)) (C := (-0.3662884)) (h := 0.10822983)
    (by norm_num) (by norm_num) oscBlock44 vbpBr44.1 vbpBr45.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i45 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    (0.00014969:ℝ) ≤ ∫ v in (vBP 1.39)..(vBP 1.404), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.4720833) (m := (0:ℤ)) (ylo := 1.33049064) (yhi := 1.33049065)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.39) (q1 := 1.404) (t0 := 6.625) (t1 := 6.75)
    (A := 0.65860729) (B := 0.67865086) (X := 4.4720833) (rho := 0.10881002)
    (clo := (-0.23800427)) (chi := (-0.23799946)) (C := (-0.23800187)) (h := 0.10881243)
    (by norm_num) (by norm_num) oscBlock45 vbpBr45.1 vbpBr46.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i46 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00006697):ℝ) ≤ ∫ v in (vBP 1.404)..(vBP 1.418), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.60545048) (m := (0:ℤ)) (ylo := 1.46385782) (yhi := 1.46385783)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.404) (q1 := 1.418) (t0 := 6.625) (t1 := 6.75)
    (A := 0.67865033) (B := 0.69849519) (X := 4.60545048) (rho := 0.10939206)
    (clo := (-0.10674706)) (chi := (-0.10673459)) (C := (-0.10674083)) (h := 0.1093983)
    (by norm_num) (by norm_num) oscBlock46 vbpBr46.1 vbpBr47.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i47 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00029139):ℝ) ≤ ∫ v in (vBP 1.418)..(vBP 1.432), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.73750092) (m := (0:ℤ)) (ylo := 0.02511193) (yhi := 0.02511194)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.418) (q1 := 1.432) (t0 := 6.625) (t1 := 6.75)
    (A := 0.69849446) (B := 0.7181446) (X := 4.73750092) (rho := 0.10997514)
    (clo := 0.02510929) (chi := 0.02510931) (C := 0.0251093) (h := 0.10997515)
    (by norm_num) (by norm_num) oscBlock47 vbpBr47.1 vbpBr48.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i48 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00054212):ℝ) ≤ ∫ v in (vBP 1.432)..(vBP 1.446), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.86826032) (m := (0:ℤ)) (ylo := 0.15587133) (yhi := 0.15587134)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.432) (q1 := 1.446) (t0 := 6.625) (t1 := 6.75)
    (A := 0.7181436) (B := 0.73760286) (X := 4.86826032) (rho := 0.11055899)
    (clo := 0.15524092) (chi := 0.15524094) (C := 0.15524093) (h := 0.110559)
    (by norm_num) (by norm_num) oscBlock48 vbpBr48.1 vbpBr49.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i49 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00089815):ℝ) ≤ ∫ v in (vBP 1.446)..(vBP 1.462), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.00699415) (m := (0:ℤ)) (ylo := 0.29460516) (yhi := 0.29460517)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.446) (q1 := 1.462) (t0 := 6.625) (t1 := 6.75)
    (A := 0.73760153) (B := 0.75961158) (X := 5.00699415) (rho := 0.12038403)
    (clo := 0.29036204) (chi := 0.29036206) (C := 0.29036205) (h := 0.12038404)
    (by norm_num) (by norm_num) oscBlock49 vbpBr49.1 vbpBr50.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i50 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00114982):ℝ) ≤ ∫ v in (vBP 1.462)..(vBP 1.478), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.15336746) (m := (0:ℤ)) (ylo := 0.44097847) (yhi := 0.44097848)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.462) (q1 := 1.478) (t0 := 6.625) (t1 := 6.75)
    (A := 0.75960973) (B := 0.78138081) (X := 5.15336746) (rho := 0.12095302)
    (clo := 0.42682453) (chi := 0.42682455) (C := 0.42682454) (h := 0.12095303)
    (by norm_num) (by norm_num) oscBlock50 vbpBr50.1 vbpBr51.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i51 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00141459):ℝ) ≤ ∫ v in (vBP 1.478)..(vBP 1.495), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.3026729) (m := (0:ℤ)) (ylo := 0.59028391) (yhi := 0.59028392)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.478) (q1 := 1.495) (t0 := 6.625) (t1 := 6.75)
    (A := 0.7813783) (B := 0.80425401) (X := 5.3026729) (rho := 0.12604168)
    (clo := 0.55659691) (chi := 0.55659693) (C := 0.55659692) (h := 0.12604169)
    (by norm_num) (by norm_num) oscBlock51 vbpBr51.1 vbpBr52.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i52 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00154213):ℝ) ≤ ∫ v in (vBP 1.495)..(vBP 1.512), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.45476191) (m := (0:ℤ)) (ylo := 0.74237292) (yhi := 0.74237293)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.495) (q1 := 1.512) (t0 := 6.625) (t1 := 6.75)
    (A := 0.80425056) (B := 0.82686872) (X := 5.45476191) (rho := 0.12660196)
    (clo := 0.67603833) (chi := 0.67603835) (C := 0.67603834) (h := 0.12660197)
    (by norm_num) (by norm_num) oscBlock52 vbpBr52.1 vbpBr53.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i53 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00182105):ℝ) ≤ ∫ v in (vBP 1.512)..(vBP 1.531), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.61396478) (m := (0:ℤ)) (ylo := 0.90157579) (yhi := 0.9015758)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.512) (q1 := 1.531) (t0 := 6.625) (t1 := 6.75)
    (A := 0.82686405) (B := 0.85184522) (X := 5.61396478) (rho := 0.13599047)
    (clo := 0.78430546) (chi := 0.78430548) (C := 0.78430547) (h := 0.13599048)
    (by norm_num) (by norm_num) oscBlock53 vbpBr53.1 vbpBr54.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i54 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.0018127):ℝ) ≤ ∫ v in (vBP 1.531)..(vBP 1.55), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.77995043) (m := (0:ℤ)) (ylo := 1.06756144) (yhi := 1.06756145)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.531) (q1 := 1.55) (t0 := 6.625) (t1 := 6.75)
    (A := 0.85183877) (B := 0.87651393) (X := 5.77995043) (rho := 0.1365186)
    (clo := 0.87602708) (chi := 0.87602715) (C := 0.86975424) (h := 0.13024576)
    (by norm_num) (by norm_num) oscBlock54 vbpBr54.1 vbpBr55.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i55 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00174878):ℝ) ≤ ∫ v in (vBP 1.55)..(vBP 1.57), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.94820244) (m := (0:ℤ)) (ylo := 1.23581345) (yhi := 1.23581346)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.55) (q1 := 1.57) (t0 := 6.625) (t1 := 6.75)
    (A := 0.87650515) (B := 0.90215678) (X := 5.94820244) (rho := 0.14135584)
    (clo := 0.94441593) (chi := 0.9444162) (C := 0.90153004) (h := 0.09846996)
    (by norm_num) (by norm_num) oscBlock55 vbpBr55.1 vbpBr56.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i56 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00159903):ℝ) ≤ ∫ v in (vBP 1.57)..(vBP 1.59), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.11858442) (m := (0:ℤ)) (ylo := 1.40619543) (yhi := 1.40619544)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.57) (q1 := 1.59) (t0 := 6.625) (t1 := 6.75)
    (A := 0.90214481) (B := 0.92747548) (X := 6.11858442) (rho := 0.14187508)
    (clo := 0.98648381) (chi := 0.98648489) (C := 0.92230436) (h := 0.07769564)
    (by norm_num) (by norm_num) oscBlock56 vbpBr56.1 vbpBr57.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i57 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00146404):ℝ) ≤ ∫ v in (vBP 1.59)..(vBP 1.61), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.28682332) (m := (1:ℤ)) (ylo := 0.00363801) (yhi := 0.00363802)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.59) (q1 := 1.61) (t0 := 6.625) (t1 := 6.75)
    (A := 0.92745939) (B := 0.95247825) (X := 6.28682332) (rho := 0.14240488)
    (clo := 0.99999338) (chi := 0.99999339) (C := 0.92879425) (h := 0.07120575)
    (by norm_num) (by norm_num) oscBlock57 vbpBr57.1 vbpBr58.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i58 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00149216):ℝ) ≤ ∫ v in (vBP 1.61)..(vBP 1.632), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.46125065) (m := (1:ℤ)) (ylo := 0.17806534) (yhi := 0.17806535)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.61) (q1 := 1.632) (t0 := 6.625) (t1 := 6.75)
    (A := 0.95245689) (B := 0.97962584) (X := 6.46125065) (rho := 0.15122378)
    (clo := 0.98418821) (chi := 0.98418822) (C := 0.91648221) (h := 0.08351779)
    (by norm_num) (by norm_num) oscBlock58 vbpBr58.1 vbpBr59.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i59 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00149999):ℝ) ≤ ∫ v in (vBP 1.632)..(vBP 1.656), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.6497107) (m := (1:ℤ)) (ylo := 0.36652539) (yhi := 0.3665254)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.632) (q1 := 1.656) (t0 := 6.625) (t1 := 6.75)
    (A := 0.97959707) (B := 1.00882827) (X := 6.6497107) (rho := 0.15988013)
    (clo := 0.93357818) (chi := 0.93357819) (C := 0.88684902) (h := 0.11315098)
    (by norm_num) (by norm_num) oscBlock59 vbpBr59.1 vbpBr60.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i60 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00135601):ℝ) ≤ ∫ v in (vBP 1.656)..(vBP 1.68), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.84355415) (m := (1:ℤ)) (ylo := 0.56036884) (yhi := 0.56036885)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.656) (q1 := 1.68) (t0 := 6.625) (t1 := 6.75)
    (A := 1.00878907) (B := 1.03761196) (X := 6.84355415) (rho := 0.16032659)
    (clo := 0.84705912) (chi := 0.84705914) (C := 0.84336626) (h := 0.15663374)
    (by norm_num) (by norm_num) oscBlock60 vbpBr60.1 vbpBr61.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i61 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00109484):ℝ) ≤ ∫ v in (vBP 1.68)..(vBP 1.704), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.03462866) (m := (1:ℤ)) (ylo := 0.75144335) (yhi := 0.75144336)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.68) (q1 := 1.704) (t0 := 6.625) (t1 := 6.75)
    (A := 1.03755935) (B := 1.06598913) (X := 7.03462866) (rho := 0.16079798)
    (clo := 0.73070425) (chi := 0.73070428) (C := 0.73070426) (h := 0.160798)
    (by norm_num) (by norm_num) oscBlock61 vbpBr61.1 vbpBr62.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i62 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00103634):ℝ) ≤ ∫ v in (vBP 1.704)..(vBP 1.734), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.24641869) (m := (1:ℤ)) (ylo := 0.96323338) (yhi := 0.96323339)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.704) (q1 := 1.734) (t0 := 6.625) (t1 := 6.75)
    (A := 1.06591948) (B := 1.10090679) (X := 7.24641869) (rho := 0.18470215)
    (clo := 0.57086822) (chi := 0.57086843) (C := 0.57086832) (h := 0.18470226)
    (by norm_num) (by norm_num) oscBlock62 vbpBr62.1 vbpBr63.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i63 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00071799):ℝ) ≤ ∫ v in (vBP 1.734)..(vBP 1.766), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.48548481) (m := (1:ℤ)) (ylo := 1.2022995) (yhi := 1.20229951)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.734) (q1 := 1.766) (t0 := 6.625) (t1 := 6.75)
    (A := 1.10080961) (B := 1.13749718) (X := 7.48548481) (rho := 0.19262116)
    (clo := 0.36021354) (chi := 0.3602153) (C := 0.36021442) (h := 0.19262204)
    (by norm_num) (by norm_num) oscBlock63 vbpBr63.1 vbpBr64.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i64 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00034283):ℝ) ≤ ∫ v in (vBP 1.766)..(vBP 1.796), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.72033877) (m := (1:ℤ)) (ylo := 1.43715346) (yhi := 1.43715347)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.766) (q1 := 1.796) (t0 := 6.625) (t1 := 6.75)
    (A := 1.1373613) (B := 1.17120873) (X := 7.72033877) (rho := 0.18532017)
    (clo := 0.13324523) (chi := 0.1332556) (C := 0.13325041) (h := 0.18532536)
    (by norm_num) (by norm_num) oscBlock64 vbpBr64.1 vbpBr65.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i65 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00028446):ℝ) ≤ ∫ v in (vBP 1.796)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 7.95116117) (m := (1:ℤ)) (ylo := 0.09717953) (yhi := 0.09717954)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.796) (q1 := 1.828) (t0 := 6.625) (t1 := 6.75)
    (A := 1.1710258) (B := 1.20655947) (X := 7.95116117) (rho := 0.19311526)
    (clo := (-0.09702666)) (chi := (-0.09702664)) (C := (-0.09702665)) (h := 0.19311527)
    (by norm_num) (by norm_num) oscBlock65 vbpBr65.1 vbpBr66.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i66 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.0004496):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.86), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.18531514) (m := (1:ℤ)) (ylo := 0.3313335) (yhi := 0.33133351)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.828) (q1 := 1.86) (t0 := 6.625) (t1 := 6.75)
    (A := 1.20631244) (B := 1.24130524) (X := 8.18531514) (rho := 0.19349524)
    (clo := (-0.3253043)) (chi := (-0.32530428)) (C := (-0.32530429)) (h := 0.19349525)
    (by norm_num) (by norm_num) oscBlock66 vbpBr66.1 vbpBr67.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i67 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00052051):ℝ) ≤ ∫ v in (vBP 1.86)..(vBP 1.89), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.40829182) (m := (1:ℤ)) (ylo := 0.55431018) (yhi := 0.55431019)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.86) (q1 := 1.89) (t0 := 6.625) (t1 := 6.75)
    (A := 1.24097685) (B := 1.27334993) (X := 8.40829182) (rho := 0.18682021)
    (clo := (-0.52635691)) (chi := (-0.52635689)) (C := (-0.5263569)) (h := 0.18682022)
    (by norm_num) (by norm_num) oscBlock67 vbpBr67.1 vbpBr68.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i68 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00064712):ℝ) ≤ ∫ v in (vBP 1.89)..(vBP 1.922), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.62764953) (m := (1:ℤ)) (ylo := 0.77366789) (yhi := 0.7736679)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.89) (q1 := 1.922) (t0 := 6.625) (t1 := 6.75)
    (A := 1.27292668) (B := 1.30698664) (X := 8.62764953) (rho := 0.1945103)
    (clo := (-0.69876378)) (chi := (-0.69876376)) (C := (-0.69876377)) (h := 0.19451031)
    (by norm_num) (by norm_num) oscBlock68 vbpBr68.1 vbpBr69.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i69 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00096848):ℝ) ≤ ∫ v in (vBP 1.922)..(vBP 1.969), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.90210292) (m := (1:ℤ)) (ylo := 1.04812128) (yhi := 1.04812129)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.922) (q1 := 1.969) (t0 := 6.625) (t1 := 6.75)
    (A := 1.30643896) (B := 1.35541448) (X := 8.90210292) (rho := 0.24694483)
    (clo := (-0.86648695)) (chi := (-0.86648689)) (C := (-0.80977103)) (h := 0.19022897)
    (by norm_num) (by norm_num) oscBlock69 vbpBr69.1 vbpBr70.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i70 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00087888):ℝ) ≤ ∫ v in (vBP 1.969)..(vBP 2.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 9.22145639) (m := (1:ℤ)) (ylo := 1.36747475) (yhi := 1.36747476)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.969) (q1 := 2.016) (t0 := 6.625) (t1 := 6.75)
    (A := 1.35463226) (B := 1.4027369) (X := 9.22145639) (rho := 0.24701769)
    (clo := (-0.97940206)) (chi := (-0.97940126)) (C := (-0.86619179)) (h := 0.13380822)
    (by norm_num) (by norm_num) oscBlock70 vbpBr70.1 vbpBr71.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i71 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00078633):ℝ) ≤ ∫ v in (vBP 2.016)..(vBP 2.062), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 9.53008585) (m := (1:ℤ)) (ylo := 0.10530788) (yhi := 0.10530789)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.016) (q1 := 2.062) (t0 := 6.625) (t1 := 6.75)
    (A := 1.40164597) (B := 1.44803958) (X := 9.53008585) (rho := 0.24418132)
    (clo := (-0.99446025)) (chi := (-0.99446024)) (C := (-0.87513946)) (h := 0.12486054)
    (by norm_num) (by norm_num) oscBlock71 vbpBr71.1 vbpBr72.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB5i72 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.00051116):ℝ) ≤ ∫ v in (vBP 2.062)..(vBP 2.094), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 9.78332767) (m := (1:ℤ)) (ylo := 0.3585497) (yhi := 0.35854971)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.062) (q1 := 2.094) (t0 := 6.625) (t1 := 6.75)
    (A := 1.44655973) (B := 1.47899217) (X := 9.78332767) (rho := 0.19986948)
    (clo := (-0.93640675)) (chi := (-0.93640673)) (C := (-0.86826863)) (h := 0.13173138)
    (by norm_num) (by norm_num) oscBlock72 vbpBr72.1 vbpBr73.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

/-- Lower bound for the oscillatory integral `∫₀^∞ err(v) cos(tv) dv` on the band
`6.625 ≤ t ≤ 6.75`. -/
theorem oscBandLower5 {t : ℝ} (ht0 : (6.625:ℝ) ≤ t) (ht1 : t ≤ 6.75) :
    ((-0.14656823):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosB5i0 ht0 ht1)
    (cosB5i1 ht0 ht1))
    (cosB5i2 ht0 ht1))
    (cosB5i3 ht0 ht1))
    (cosB5i4 ht0 ht1))
    (cosB5i5 ht0 ht1))
    (cosB5i6 ht0 ht1))
    (cosB5i7 ht0 ht1))
    (cosB5i8 ht0 ht1))
    (cosB5i9 ht0 ht1))
    (cosB5i10 ht0 ht1))
    (cosB5i11 ht0 ht1))
    (cosB5i12 ht0 ht1))
    (cosB5i13 ht0 ht1))
    (cosB5i14 ht0 ht1))
    (cosB5i15 ht0 ht1))
    (cosB5i16 ht0 ht1))
    (cosB5i17 ht0 ht1))
    (cosB5i18 ht0 ht1))
    (cosB5i19 ht0 ht1))
    (cosB5i20 ht0 ht1))
    (cosB5i21 ht0 ht1))
    (cosB5i22 ht0 ht1))
    (cosB5i23 ht0 ht1))
    (cosB5i24 ht0 ht1))
    (cosB5i25 ht0 ht1))
    (cosB5i26 ht0 ht1))
    (cosB5i27 ht0 ht1))
    (cosB5i28 ht0 ht1))
    (cosB5i29 ht0 ht1))
    (cosB5i30 ht0 ht1))
    (cosB5i31 ht0 ht1))
    (cosB5i32 ht0 ht1))
    (cosB5i33 ht0 ht1))
    (cosB5i34 ht0 ht1))
    (cosB5i35 ht0 ht1))
    (cosB5i36 ht0 ht1))
    (cosB5i37 ht0 ht1))
    (cosB5i38 ht0 ht1))
    (cosB5i39 ht0 ht1))
    (cosB5i40 ht0 ht1))
    (cosB5i41 ht0 ht1))
    (cosB5i42 ht0 ht1))
    (cosB5i43 ht0 ht1))
    (cosB5i44 ht0 ht1))
    (cosB5i45 ht0 ht1))
    (cosB5i46 ht0 ht1))
    (cosB5i47 ht0 ht1))
    (cosB5i48 ht0 ht1))
    (cosB5i49 ht0 ht1))
    (cosB5i50 ht0 ht1))
    (cosB5i51 ht0 ht1))
    (cosB5i52 ht0 ht1))
    (cosB5i53 ht0 ht1))
    (cosB5i54 ht0 ht1))
    (cosB5i55 ht0 ht1))
    (cosB5i56 ht0 ht1))
    (cosB5i57 ht0 ht1))
    (cosB5i58 ht0 ht1))
    (cosB5i59 ht0 ht1))
    (cosB5i60 ht0 ht1))
    (cosB5i61 ht0 ht1))
    (cosB5i62 ht0 ht1))
    (cosB5i63 ht0 ht1))
    (cosB5i64 ht0 ht1))
    (cosB5i65 ht0 ht1))
    (cosB5i66 ht0 ht1))
    (cosB5i67 ht0 ht1))
    (cosB5i68 ht0 ht1))
    (cosB5i69 ht0 ht1))
    (cosB5i70 ht0 ht1))
    (cosB5i71 ht0 ht1))
    (cosB5i72 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 2.094) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 2.094) (S := 0.013709)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_cut
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
