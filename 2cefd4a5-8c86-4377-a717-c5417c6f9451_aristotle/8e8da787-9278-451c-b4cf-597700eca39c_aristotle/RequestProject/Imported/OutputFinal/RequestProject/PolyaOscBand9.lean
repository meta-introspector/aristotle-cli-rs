/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscTail

/-!
# Oscillatory lower bound on the band `6.25 ≤ t ≤ 6.3125`

On each of the 73 blocks the factor `cos(tv)` is bracketed by a rational constant
`C` up to a rational error `h`; the signed contribution `min(C·P₀, C·P₁) - h·S` is
then summed, and the unresolved tail beyond `q = 2.094` is estimated in absolute
value.  The result is the bound `∫₀^∞ err(v) cos(tv) dv ≥ -0.1325913`.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosB9i0 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00641868):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.0038), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.02394205) (m := (0:ℤ)) (ylo := 0.02394205) (yhi := 0.02394205)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1) (q1 := 1.0038) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.0) (B := 0.0075856) (X := 0.02394205) (rho := 0.02394206)
    (clo := 0.9997134) (chi := 0.99971341) (C := 0.98788567) (h := 0.01211433)
    (by norm_num) (by norm_num) oscBlock0 vbpBr0.1 vbpBr1.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i1 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00625872):ℝ) ≤ ∫ v in (vBP 1.0038)..(vBP 1.0078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.07275145) (m := (0:ℤ)) (ylo := 0.07275145) (yhi := 0.07275145)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0038) (q1 := 1.0078) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.00758559) (B := 0.01553948) (X := 0.07275145) (rho := 0.02534153)
    (clo := 0.99735478) (chi := 0.99735479) (C := 0.98600662) (h := 0.01399338)
    (by norm_num) (by norm_num) oscBlock1 vbpBr1.1 vbpBr2.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i2 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.0057677):ℝ) ≤ ∫ v in (vBP 1.0078)..(vBP 1.0118), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.1226123) (m := (0:ℤ)) (ylo := 0.1226123) (yhi := 0.1226123)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0078) (q1 := 1.0118) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.01553947) (B := 0.02346185) (X := 0.1226123) (rho := 0.02549064)
    (clo := 0.99249252) (chi := 0.99249253) (C := 0.98350094) (h := 0.01649906)
    (by norm_num) (by norm_num) oscBlock2 vbpBr2.1 vbpBr3.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i3 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00554846):ℝ) ≤ ∫ v in (vBP 1.0118)..(vBP 1.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.17351877) (m := (0:ℤ)) (ylo := 0.17351877) (yhi := 0.17351877)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0118) (q1 := 1.016) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.02346184) (B := 0.0317467) (X := 0.17351877) (rho := 0.02688229)
    (clo := 0.98498335) (chi := 0.98498336) (C := 0.97905053) (h := 0.02094947)
    (by norm_num) (by norm_num) oscBlock3 vbpBr3.1 vbpBr4.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i4 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00539232):ℝ) ≤ ∫ v in (vBP 1.016)..(vBP 1.0205), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.2273061) (m := (0:ℤ)) (ylo := 0.2273061) (yhi := 0.2273061)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.016) (q1 := 1.0205) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.03174669) (B := 0.04058541) (X := 0.2273061) (rho := 0.02888931)
    (clo := 0.974277) (chi := 0.97427701) (C := 0.97269384) (h := 0.02730616)
    (by norm_num) (by norm_num) oscBlock4 vbpBr4.1 vbpBr5.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i5 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00479929):ℝ) ≤ ∫ v in (vBP 1.0205)..(vBP 1.025), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.2827015) (m := (0:ℤ)) (ylo := 0.2827015) (yhi := 0.2827015)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0205) (q1 := 1.025) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.0405854) (B := 0.04938523) (X := 0.2827015) (rho := 0.02904277)
    (clo := 0.96030535) (chi := 0.96030536) (C := 0.96030535) (h := 0.02904278)
    (by norm_num) (by norm_num) oscBlock5 vbpBr5.1 vbpBr6.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i6 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00466967):ℝ) ≤ ∫ v in (vBP 1.025)..(vBP 1.03), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.34091876) (m := (0:ℤ)) (ylo := 0.34091876) (yhi := 0.34091876)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.025) (q1 := 1.03) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.04938522) (B := 0.05911761) (X := 0.34091876) (rho := 0.03226116)
    (clo := 0.94244787) (chi := 0.94244788) (C := 0.94244787) (h := 0.03226117)
    (by norm_num) (by norm_num) oscBlock6 vbpBr6.1 vbpBr7.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i7 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00435963):ℝ) ≤ ∫ v in (vBP 1.03)..(vBP 1.0355), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.4049503) (m := (0:ℤ)) (ylo := 0.4049503) (yhi := 0.4049503)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.03) (q1 := 1.0355) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.0591176) (B := 0.06976881) (X := 0.4049503) (rho := 0.03546532)
    (clo := 0.91912197) (chi := 0.91912198) (C := 0.91912197) (h := 0.03546533)
    (by norm_num) (by norm_num) oscBlock7 vbpBr7.1 vbpBr8.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i8 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00389057):ℝ) ≤ ∫ v in (vBP 1.0355)..(vBP 1.0415), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.47470628) (m := (0:ℤ)) (ylo := 0.47470628) (yhi := 0.47470628)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0355) (q1 := 1.0415) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.0697688) (B := 0.08132397) (X := 0.47470628) (rho := 0.0386513)
    (clo := 0.88942701) (chi := 0.88942702) (C := 0.88942701) (h := 0.03865131)
    (by norm_num) (by norm_num) oscBlock8 vbpBr8.1 vbpBr9.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i9 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.0032903):ℝ) ≤ ∫ v in (vBP 1.0415)..(vBP 1.048), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.55009003) (m := (0:ℤ)) (ylo := 0.55009003) (yhi := 0.55009003)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0415) (q1 := 1.048) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.08132396) (B := 0.09376718) (X := 0.55009003) (rho := 0.0418153)
    (clo := 0.85247746) (chi := 0.85247747) (C := 0.85247746) (h := 0.04181531)
    (by norm_num) (by norm_num) oscBlock9 vbpBr9.1 vbpBr10.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i10 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00261259):ℝ) ≤ ∫ v in (vBP 1.048)..(vBP 1.055), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.63099851) (m := (0:ℤ)) (ylo := 0.63099851) (yhi := 0.63099851)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.048) (q1 := 1.055) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.09376717) (B := 0.10708154) (X := 0.63099851) (rho := 0.04495372)
    (clo := 0.80743883) (chi := 0.80743885) (C := 0.80743884) (h := 0.04495373)
    (by norm_num) (by norm_num) oscBlock10 vbpBr10.1 vbpBr11.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i11 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00214558):ℝ) ≤ ∫ v in (vBP 1.055)..(vBP 1.064), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.72622821) (m := (0:ℤ)) (ylo := 0.72622821) (yhi := 0.72622821)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.055) (q1 := 1.064) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.10708153) (B := 0.12407079) (X := 0.72622821) (rho := 0.05696866)
    (clo := 0.74768438) (chi := 0.7476844) (C := 0.74768439) (h := 0.05696867)
    (by norm_num) (by norm_num) oscBlock11 vbpBr11.1 vbpBr12.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i12 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.0013718):ℝ) ≤ ∫ v in (vBP 1.064)..(vBP 1.078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.86183712) (m := (0:ℤ)) (ylo := 0.86183712) (yhi := 0.86183712)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.064) (q1 := 1.078) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.12407078) (B := 0.15021495) (X := 0.86183712) (rho := 0.08639476)
    (clo := 0.65104411) (chi := 0.65104419) (C := 0.65104415) (h := 0.0863948)
    (by norm_num) (by norm_num) oscBlock12 vbpBr12.1 vbpBr13.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i13 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    (0.00014422:ℝ) ≤ ∫ v in (vBP 1.078)..(vBP 1.09), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.01341841) (m := (0:ℤ)) (ylo := 1.01341841) (yhi := 1.01341841)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.078) (q1 := 1.09) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.15021494) (B := 0.1723554) (X := 1.01341841) (rho := 0.07457506)
    (clo := 0.52896279) (chi := 0.52896312) (C := 0.52896295) (h := 0.07457523)
    (by norm_num) (by norm_num) oscBlock13 vbpBr13.1 vbpBr14.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i14 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    (0.00058495:ℝ) ≤ ∫ v in (vBP 1.09)..(vBP 1.1), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.1402561) (m := (0:ℤ)) (ylo := 1.1402561) (yhi := 1.1402561)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.09) (q1 := 1.1) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.17235539) (B := 0.19062036) (X := 1.1402561) (rho := 0.06303493)
    (clo := 0.41736177) (chi := 0.41736281) (C := 0.41736229) (h := 0.06303545)
    (by norm_num) (by norm_num) oscBlock14 vbpBr14.1 vbpBr15.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i15 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    (0.00059691:ℝ) ≤ ∫ v in (vBP 1.1)..(vBP 1.109), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.2487717) (m := (0:ℤ)) (ylo := 1.2487717) (yhi := 1.2487717)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.1) (q1 := 1.109) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.19062035) (B := 0.20691742) (X := 1.2487717) (rho := 0.05739453)
    (clo := 0.31648773) (chi := 0.31649028) (C := 0.316489) (h := 0.05739581)
    (by norm_num) (by norm_num) oscBlock15 vbpBr15.1 vbpBr16.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i16 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    (0.00043433:ℝ) ≤ ∫ v in (vBP 1.109)..(vBP 1.117), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.34507309) (m := (0:ℤ)) (ylo := 1.34507309) (yhi := 1.34507309)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.109) (q1 := 1.117) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.20691741) (B := 0.22129305) (X := 1.34507309) (rho := 0.0518393)
    (clo := 0.22381123) (chi := 0.22381659) (C := 0.22381391) (h := 0.05184198)
    (by norm_num) (by norm_num) oscBlock16 vbpBr16.1 vbpBr17.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i17 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    (0.00023231:ℝ) ≤ ∫ v in (vBP 1.117)..(vBP 1.124), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.42943257) (m := (0:ℤ)) (ylo := 1.42943257) (yhi := 1.42943257)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.117) (q1 := 1.124) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.22129304) (B := 0.23378751) (X := 1.42943257) (rho := 0.04635109)
    (clo := 0.14089324) (chi := 0.14090307) (C := 0.14089815) (h := 0.04635601)
    (by norm_num) (by norm_num) oscBlock17 vbpBr17.1 vbpBr18.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i18 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    (0.00002745:ℝ) ≤ ∫ v in (vBP 1.124)..(vBP 1.131), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.50766857) (m := (0:ℤ)) (ylo := 1.50766857) (yhi := 1.50766857)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.124) (q1 := 1.131) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.2337875) (B := 0.2462044) (X := 1.50766857) (rho := 0.04649671)
    (clo := 0.06308555) (chi := 0.06310228) (C := 0.06309391) (h := 0.04650508)
    (by norm_num) (by norm_num) oscBlock18 vbpBr18.1 vbpBr19.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i19 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00022072):ℝ) ≤ ∫ v in (vBP 1.131)..(vBP 1.138), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.58542036) (m := (0:ℤ)) (ylo := 0.01462403) (yhi := 0.01462404)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.131) (q1 := 1.138) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.24620439) (B := 0.25854468) (X := 1.58542036) (rho := 0.04664294)
    (clo := (-0.01462352)) (chi := (-0.0146235)) (C := (-0.01462351)) (h := 0.04664295)
    (by norm_num) (by norm_num) oscBlock19 vbpBr19.1 vbpBr20.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i20 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00051594):ℝ) ≤ ∫ v in (vBP 1.138)..(vBP 1.145), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.66269388) (m := (0:ℤ)) (ylo := 0.09189755) (yhi := 0.09189756)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.138) (q1 := 1.145) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.25854467) (B := 0.27080928) (X := 1.66269388) (rho := 0.04678971)
    (clo := (-0.09176827)) (chi := (-0.09176825)) (C := (-0.09176826)) (h := 0.04678972)
    (by norm_num) (by norm_num) oscBlock20 vbpBr20.1 vbpBr21.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i21 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00082287):ℝ) ≤ ∫ v in (vBP 1.145)..(vBP 1.152), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.73949497) (m := (0:ℤ)) (ylo := 0.16869864) (yhi := 0.16869865)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.145) (q1 := 1.152) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.27080927) (B := 0.28299913) (X := 1.73949497) (rho := 0.04693705)
    (clo := (-0.16789962)) (chi := (-0.1678996)) (C := (-0.16789961)) (h := 0.04693706)
    (by norm_num) (by norm_num) oscBlock21 vbpBr21.1 vbpBr22.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i22 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00113021):ℝ) ≤ ∫ v in (vBP 1.152)..(vBP 1.159), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.81582937) (m := (0:ℤ)) (ylo := 0.24503304) (yhi := 0.24503305)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.152) (q1 := 1.159) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.28299912) (B := 0.29511513) (X := 1.81582937) (rho := 0.04708489)
    (clo := (-0.24258839)) (chi := (-0.24258837)) (C := (-0.24258838)) (h := 0.0470849)
    (by norm_num) (by norm_num) oscBlock22 vbpBr22.1 vbpBr23.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i23 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00142706):ℝ) ≤ ∫ v in (vBP 1.159)..(vBP 1.166), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.89170275) (m := (0:ℤ)) (ylo := 0.32090642) (yhi := 0.32090643)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.159) (q1 := 1.166) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.29511512) (B := 0.30715818) (X := 1.89170275) (rho := 0.04723327)
    (clo := (-0.31542685)) (chi := (-0.31542683)) (C := (-0.31542684)) (h := 0.04723328)
    (by norm_num) (by norm_num) oscBlock23 vbpBr23.1 vbpBr24.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i24 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00170452):ℝ) ≤ ∫ v in (vBP 1.166)..(vBP 1.173), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.96712062) (m := (0:ℤ)) (ylo := 0.39632429) (yhi := 0.3963243)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.166) (q1 := 1.173) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.30715817) (B := 0.31912914) (X := 1.96712062) (rho := 0.04738208)
    (clo := (-0.38603018)) (chi := (-0.38603016)) (C := (-0.38603017)) (h := 0.04738209)
    (by norm_num) (by norm_num) oscBlock24 vbpBr24.1 vbpBr25.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i25 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00195503):ℝ) ≤ ∫ v in (vBP 1.173)..(vBP 1.18), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.04208843) (m := (0:ℤ)) (ylo := 0.4712921) (yhi := 0.47129211)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.173) (q1 := 1.18) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.31912913) (B := 0.33102888) (X := 2.04208843) (rho := 0.04753139)
    (clo := (-0.45403792)) (chi := (-0.4540379)) (C := (-0.45403791)) (h := 0.0475314)
    (by norm_num) (by norm_num) oscBlock25 vbpBr25.1 vbpBr26.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i26 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.0021724):ℝ) ≤ ∫ v in (vBP 1.18)..(vBP 1.187), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.11661153) (m := (0:ℤ)) (ylo := 0.5458152) (yhi := 0.54581521)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.18) (q1 := 1.187) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.33102887) (B := 0.34285824) (X := 2.11661153) (rho := 0.04768112)
    (clo := (-0.51911503)) (chi := (-0.51911501)) (C := (-0.51911502)) (h := 0.04768113)
    (by norm_num) (by norm_num) oscBlock26 vbpBr26.1 vbpBr27.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i27 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00235187):ℝ) ≤ ∫ v in (vBP 1.187)..(vBP 1.194), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.19069515) (m := (0:ℤ)) (ylo := 0.61989882) (yhi := 0.61989883)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.187) (q1 := 1.194) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.34285823) (B := 0.35461804) (X := 2.19069515) (rho := 0.04783123)
    (clo := (-0.58095282)) (chi := (-0.5809528)) (C := (-0.58095281)) (h := 0.04783124)
    (by norm_num) (by norm_num) oscBlock27 vbpBr27.1 vbpBr28.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i28 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00251562):ℝ) ≤ ∫ v in (vBP 1.194)..(vBP 1.201), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.26434437) (m := (0:ℤ)) (ylo := 0.69354804) (yhi := 0.69354805)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.194) (q1 := 1.201) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.35461802) (B := 0.36630909) (X := 2.26434437) (rho := 0.04798177)
    (clo := (-0.63926959)) (chi := (-0.63926958)) (C := (-0.63926959)) (h := 0.04798178)
    (by norm_num) (by norm_num) oscBlock28 vbpBr28.1 vbpBr29.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i29 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00261209):ℝ) ≤ ∫ v in (vBP 1.201)..(vBP 1.208), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.33756438) (m := (0:ℤ)) (ylo := 0.76676805) (yhi := 0.76676806)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.201) (q1 := 1.208) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.36630908) (B := 0.3779322) (X := 2.33756438) (rho := 0.04813265)
    (clo := (-0.69381137)) (chi := (-0.69381135)) (C := (-0.69381136)) (h := 0.04813266)
    (by norm_num) (by norm_num) oscBlock29 vbpBr29.1 vbpBr30.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i30 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.0026643):ℝ) ≤ ∫ v in (vBP 1.208)..(vBP 1.215), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.41036009) (m := (0:ℤ)) (ylo := 0.83956376) (yhi := 0.83956377)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.208) (q1 := 1.215) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.37793219) (B := 0.38948816) (X := 2.41036009) (rho := 0.04828393)
    (clo := (-0.74435189)) (chi := (-0.74435187)) (C := (-0.74435188)) (h := 0.04828394)
    (by norm_num) (by norm_num) oscBlock30 vbpBr30.1 vbpBr31.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i31 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00307187):ℝ) ≤ ∫ v in (vBP 1.215)..(vBP 1.223), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.48790002) (m := (0:ℤ)) (ylo := 0.91710369) (yhi := 0.9171037)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.215) (q1 := 1.223) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.38948815) (B := 0.40261372) (X := 2.48790002) (rho := 0.0535991)
    (clo := (-0.79384366)) (chi := (-0.79384364)) (C := (-0.79384365)) (h := 0.05359911)
    (by norm_num) (by norm_num) oscBlock31 vbpBr31.1 vbpBr32.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i32 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00301877):ℝ) ≤ ∫ v in (vBP 1.223)..(vBP 1.231), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.57007483) (m := (0:ℤ)) (ylo := 0.9992785) (yhi := 0.99927851)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.223) (q1 := 1.231) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.40261371) (B := 0.4156537) (X := 2.57007483) (rho := 0.05373916)
    (clo := (-0.84108097)) (chi := (-0.84108093)) (C := (-0.84108095)) (h := 0.05373918)
    (by norm_num) (by norm_num) oscBlock32 vbpBr32.1 vbpBr33.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i33 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00290748):ℝ) ≤ ∫ v in (vBP 1.231)..(vBP 1.239), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.6517156) (m := (0:ℤ)) (ylo := 1.08091927) (yhi := 1.08091928)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.231) (q1 := 1.239) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.41565369) (B := 0.42860921) (X := 2.6517156) (rho := 0.05388005)
    (clo := (-0.88239078)) (chi := (-0.88239071)) (C := (-0.88239075)) (h := 0.05388009)
    (by norm_num) (by norm_num) oscBlock33 vbpBr33.1 vbpBr34.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i34 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00308984):ℝ) ≤ ∫ v in (vBP 1.239)..(vBP 1.248), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.73788936) (m := (0:ℤ)) (ylo := 1.16709303) (yhi := 1.16709304)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.239) (q1 := 1.248) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.4286092) (B := 0.44308455) (X := 2.73788936) (rho := 0.05908188)
    (clo := (-0.91961269)) (chi := (-0.91961254)) (C := (-0.91961262)) (h := 0.05908196)
    (by norm_num) (by norm_num) oscBlock34 vbpBr34.1 vbpBr35.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i35 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00307604):ℝ) ≤ ∫ v in (vBP 1.248)..(vBP 1.258), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.8335041) (m := (0:ℤ)) (ylo := 1.26270777) (yhi := 1.26270778)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.248) (q1 := 1.258) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.44308453) (B := 0.45904632) (X := 2.8335041) (rho := 0.06422581)
    (clo := (-0.95291526)) (chi := (-0.95291492)) (C := (-0.94434456)) (h := 0.05565545)
    (by norm_num) (by norm_num) oscBlock35 vbpBr35.1 vbpBr36.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i36 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00264808):ℝ) ≤ ∫ v in (vBP 1.258)..(vBP 1.268), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.93336514) (m := (0:ℤ)) (ylo := 1.36256881) (yhi := 1.36256882)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.258) (q1 := 1.268) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.45904631) (B := 0.47488172) (X := 2.93336514) (rho := 0.06432572)
    (clo := (-0.97839962)) (chi := (-0.97839886)) (C := (-0.95703657)) (h := 0.04296343)
    (by norm_num) (by norm_num) oscBlock36 vbpBr36.1 vbpBr37.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i37 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00261048):ℝ) ≤ ∫ v in (vBP 1.268)..(vBP 1.28), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.04230959) (m := (0:ℤ)) (ylo := 1.47151326) (yhi := 1.47151327)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.268) (q1 := 1.28) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.4748817) (B := 0.49372017) (X := 3.04230959) (rho := 0.07429899)
    (clo := (-0.99507722)) (chi := (-0.99507545)) (C := (-0.96038823)) (h := 0.03961177)
    (by norm_num) (by norm_num) oscBlock37 vbpBr37.1 vbpBr38.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i38 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.0022862):ℝ) ≤ ∫ v in (vBP 1.28)..(vBP 1.294), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.16984785) (m := (0:ℤ)) (ylo := 0.02825519) (yhi := 0.0282552)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.28) (q1 := 1.294) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.49372014) (B := 0.51547641) (X := 3.16984785) (rho := 0.084097)
    (clo := (-0.99960085)) (chi := (-0.99960084)) (C := (-0.95775192)) (h := 0.04224808)
    (by norm_num) (by norm_num) oscBlock38 vbpBr38.1 vbpBr39.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i39 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00152769):ℝ) ≤ ∫ v in (vBP 1.294)..(vBP 1.308), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.30576529) (m := (0:ℤ)) (ylo := 0.16417263) (yhi := 0.16417264)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.294) (q1 := 1.308) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.51547638) (B := 0.53699853) (X := 3.30576529) (rho := 0.08403794)
    (clo := (-0.98655392)) (chi := (-0.98655391)) (C := (-0.95125799)) (h := 0.04874202)
    (by norm_num) (by norm_num) oscBlock39 vbpBr39.1 vbpBr40.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i40 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00099735):ℝ) ≤ ∫ v in (vBP 1.308)..(vBP 1.326), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.45929886) (m := (0:ℤ)) (ylo := 0.3177062) (yhi := 0.31770621)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.308) (q1 := 1.326) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.53699848) (B := 0.56433382) (X := 3.45929886) (rho := 0.10305838)
    (clo := (-0.94995448)) (chi := (-0.94995446)) (C := (-0.92344804)) (h := 0.07655196)
    (by norm_num) (by norm_num) oscBlock40 vbpBr40.1 vbpBr41.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i41 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00007844):ℝ) ≤ ∫ v in (vBP 1.326)..(vBP 1.345), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.63453031) (m := (0:ℤ)) (ylo := 0.49293765) (yhi := 0.49293766)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.326) (q1 := 1.345) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.56433374) (B := 0.59278808) (X := 3.63453031) (rho := 0.10744445)
    (clo := (-0.88094652)) (chi := (-0.88094651)) (C := (-0.88094652)) (h := 0.10744446)
    (by norm_num) (by norm_num) oscBlock41 vbpBr41.1 vbpBr42.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i42 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    (0.00067534:ℝ) ≤ ∫ v in (vBP 1.345)..(vBP 1.362), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.80273607) (m := (0:ℤ)) (ylo := 0.66114341) (yhi := 0.66114342)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.345) (q1 := 1.362) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.59278796) (B := 0.6179085) (X := 3.80273607) (rho := 0.09781134)
    (clo := (-0.78929068)) (chi := (-0.78929066)) (C := (-0.78929067)) (h := 0.09781135)
    (by norm_num) (by norm_num) oscBlock42 vbpBr42.1 vbpBr43.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i43 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    (0.00074341:ℝ) ≤ ∫ v in (vBP 1.362)..(vBP 1.376), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.94579226) (m := (0:ℤ)) (ylo := 0.8041996) (yhi := 0.80419961)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.362) (q1 := 1.376) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.61790831) (B := 0.6383616) (X := 3.94579226) (rho := 0.08386535)
    (clo := (-0.693688)) (chi := (-0.69368795)) (C := (-0.69368798)) (h := 0.08386538)
    (by norm_num) (by norm_num) oscBlock43 vbpBr43.1 vbpBr44.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i44 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    (0.00073659:ℝ) ≤ ∫ v in (vBP 1.376)..(vBP 1.39), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.07360961) (m := (0:ℤ)) (ylo := 0.93201695) (yhi := 0.93201696)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.376) (q1 := 1.39) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.63836133) (B := 0.65860767) (X := 4.07360961) (rho := 0.08385132)
    (clo := (-0.59621608)) (chi := (-0.59621593)) (C := (-0.59621601)) (h := 0.0838514)
    (by norm_num) (by norm_num) oscBlock44 vbpBr44.1 vbpBr45.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i45 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    (0.00062248:ℝ) ≤ ∫ v in (vBP 1.39)..(vBP 1.404), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.20013955) (m := (0:ℤ)) (ylo := 1.05854689) (yhi := 1.0585469)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.39) (q1 := 1.404) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.65860729) (B := 0.67865086) (X := 4.20013955) (rho := 0.08384401)
    (clo := (-0.49013968)) (chi := (-0.49013918)) (C := (-0.49013943)) (h := 0.08384426)
    (by norm_num) (by norm_num) oscBlock45 vbpBr45.1 vbpBr46.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i46 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    (0.00043993:ℝ) ≤ ∫ v in (vBP 1.404)..(vBP 1.418), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.32540772) (m := (0:ℤ)) (ylo := 1.18381506) (yhi := 1.18381507)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.404) (q1 := 1.418) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.67865033) (B := 0.69849519) (X := 4.32540772) (rho := 0.08384318)
    (clo := (-0.37739611)) (chi := (-0.3773946)) (C := (-0.37739536)) (h := 0.08384394)
    (by norm_num) (by norm_num) oscBlock46 vbpBr46.1 vbpBr47.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i47 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    (0.00022897:ℝ) ≤ ∫ v in (vBP 1.418)..(vBP 1.432), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.44943908) (m := (0:ℤ)) (ylo := 1.30784642) (yhi := 1.30784643)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.418) (q1 := 1.432) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.69849446) (B := 0.7181446) (X := 4.44943908) (rho := 0.08384872)
    (clo := (-0.25993418)) (chi := (-0.25993012)) (C := (-0.25993215)) (h := 0.08385075)
    (by norm_num) (by norm_num) oscBlock47 vbpBr47.1 vbpBr48.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i48 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    (0.00002611:ℝ) ≤ ∫ v in (vBP 1.432)..(vBP 1.446), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.57225777) (m := (0:ℤ)) (ylo := 1.43066511) (yhi := 1.43066512)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.432) (q1 := 1.446) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.7181436) (B := 0.73760286) (X := 4.57225777) (rho := 0.08386029)
    (clo := (-0.1396828)) (chi := (-0.13967288)) (C := (-0.13967784)) (h := 0.08386525)
    (by norm_num) (by norm_num) oscBlock48 vbpBr48.1 vbpBr49.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i49 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00018922):ℝ) ≤ ∫ v in (vBP 1.446)..(vBP 1.462), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.70252883) (m := (0:ℤ)) (ylo := 1.56093617) (yhi := 1.56093618)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.446) (q1 := 1.462) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.73760153) (B := 0.75961158) (X := 4.70252883) (rho := 0.09251928)
    (clo := (-0.00988324)) (chi := (-0.00985955)) (C := (-0.0098714)) (h := 0.09253113)
    (by norm_num) (by norm_num) oscBlock49 vbpBr49.1 vbpBr50.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i50 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00046123):ℝ) ≤ ∫ v in (vBP 1.462)..(vBP 1.478), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.84001358) (m := (0:ℤ)) (ylo := 0.12762459) (yhi := 0.1276246)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.462) (q1 := 1.478) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.75960973) (B := 0.78138081) (X := 4.84001358) (rho := 0.09245279)
    (clo := 0.12727841) (chi := 0.12727843) (C := 0.12727842) (h := 0.0924528)
    (by norm_num) (by norm_num) oscBlock50 vbpBr50.1 vbpBr51.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i51 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00074865):ℝ) ≤ ∫ v in (vBP 1.478)..(vBP 1.495), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.9802339) (m := (0:ℤ)) (ylo := 0.26784491) (yhi := 0.26784492)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.478) (q1 := 1.495) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.7813783) (B := 0.80425401) (X := 4.9802339) (rho := 0.09661955)
    (clo := 0.2646538) (chi := 0.26465382) (C := 0.26465381) (h := 0.09661956)
    (by norm_num) (by norm_num) oscBlock51 vbpBr51.1 vbpBr52.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i52 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00095254):ℝ) ≤ ∫ v in (vBP 1.495)..(vBP 1.512), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.12308739) (m := (0:ℤ)) (ylo := 0.4106984) (yhi := 0.41069841)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.495) (q1 := 1.512) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.80425056) (B := 0.82686872) (X := 5.12308739) (rho := 0.09652141)
    (clo := 0.39924974) (chi := 0.39924976) (C := 0.39924975) (h := 0.09652142)
    (by norm_num) (by norm_num) oscBlock52 vbpBr52.1 vbpBr53.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i53 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00125858):ℝ) ≤ ∫ v in (vBP 1.512)..(vBP 1.531), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.27258663) (m := (0:ℤ)) (ylo := 0.56019764) (yhi := 0.56019765)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.512) (q1 := 1.531) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.82686405) (B := 0.85184522) (X := 5.27258663) (rho := 0.10468633)
    (clo := 0.53135363) (chi := 0.53135365) (C := 0.53135364) (h := 0.10468634)
    (by norm_num) (by norm_num) oscBlock53 vbpBr53.1 vbpBr54.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i54 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00137938):ℝ) ≤ ∫ v in (vBP 1.531)..(vBP 1.55), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.42849324) (m := (0:ℤ)) (ylo := 0.71610425) (yhi := 0.71610426)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.531) (q1 := 1.55) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.85183877) (B := 0.87651393) (X := 5.42849324) (rho := 0.10450095)
    (clo := 0.65645082) (chi := 0.65645084) (C := 0.65645083) (h := 0.10450096)
    (by norm_num) (by norm_num) oscBlock54 vbpBr54.1 vbpBr55.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i55 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00153077):ℝ) ≤ ∫ v in (vBP 1.55)..(vBP 1.57), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.58651093) (m := (0:ℤ)) (ylo := 0.87412194) (yhi := 0.87412195)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.55) (q1 := 1.57) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.87650515) (B := 0.90215678) (X := 5.58651093) (rho := 0.10835376)
    (clo := 0.76698037) (chi := 0.76698039) (C := 0.76698038) (h := 0.10835377)
    (by norm_num) (by norm_num) oscBlock55 vbpBr55.1 vbpBr56.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i56 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00154719):ℝ) ≤ ∫ v in (vBP 1.57)..(vBP 1.59), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.74654701) (m := (0:ℤ)) (ylo := 1.03415802) (yhi := 1.03415803)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.57) (q1 := 1.59) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.90214481) (B := 0.92747548) (X := 5.74654701) (rho := 0.10814197)
    (clo := 0.85943219) (chi := 0.85943225) (C := 0.85943222) (h := 0.108142)
    (by norm_num) (by norm_num) oscBlock56 vbpBr56.1 vbpBr57.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i57 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00146404):ℝ) ≤ ∫ v in (vBP 1.59)..(vBP 1.61), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.90457007) (m := (0:ℤ)) (ylo := 1.19218108) (yhi := 1.19218109)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.59) (q1 := 1.61) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.92745939) (B := 0.95247825) (X := 5.90457007) (rho := 0.1079489)
    (clo := 0.92917737) (chi := 0.92917756) (C := 0.91061423) (h := 0.08938577)
    (by norm_num) (by norm_num) oscBlock57 vbpBr57.1 vbpBr58.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i58 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00149216):ℝ) ≤ ∫ v in (vBP 1.61)..(vBP 1.632), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.06837183) (m := (0:ℤ)) (ylo := 1.35598284) (yhi := 1.35598285)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.61) (q1 := 1.632) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.95245689) (B := 0.97962584) (X := 6.06837183) (rho := 0.11551629)
    (clo := 0.97701616) (chi := 0.97701688) (C := 0.93074993) (h := 0.06925007)
    (by norm_num) (by norm_num) oscBlock58 vbpBr58.1 vbpBr59.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i59 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00149999):ℝ) ≤ ∫ v in (vBP 1.632)..(vBP 1.656), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.24535507) (m := (0:ℤ)) (ylo := 1.53296608) (yhi := 1.53296609)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.632) (q1 := 1.656) (t0 := 6.25) (t1 := 6.3125)
    (A := 0.97959707) (B := 1.00882827) (X := 6.24535507) (rho := 0.1228734)
    (clo := 0.99928448) (chi := 0.99928724) (C := 0.93820554) (h := 0.06179446)
    (by norm_num) (by norm_num) oscBlock59 vbpBr59.1 vbpBr60.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i60 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00135601):ℝ) ≤ ∫ v in (vBP 1.656)..(vBP 1.68), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.42742859) (m := (1:ℤ)) (ylo := 0.14424328) (yhi := 0.14424329)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.656) (q1 := 1.68) (t0 := 6.25) (t1 := 6.3125)
    (A := 1.00878907) (B := 1.03761196) (X := 6.42742859) (rho := 0.12249692)
    (clo := 0.98961496) (chi := 0.98961497) (C := 0.93355902) (h := 0.06644098)
    (by norm_num) (by norm_num) oscBlock60 vbpBr60.1 vbpBr61.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i61 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00122808):ℝ) ≤ ∫ v in (vBP 1.68)..(vBP 1.704), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.60690116) (m := (1:ℤ)) (ylo := 0.32371585) (yhi := 0.32371586)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.68) (q1 := 1.704) (t0 := 6.25) (t1 := 6.3125)
    (A := 1.03755935) (B := 1.06598913) (X := 6.60690116) (rho := 0.12215524)
    (clo := 0.94805998) (chi := 0.94805999) (C := 0.91295237) (h := 0.08704763)
    (by norm_num) (by norm_num) oscBlock61 vbpBr61.1 vbpBr62.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i62 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00137159):ℝ) ≤ ∫ v in (vBP 1.704)..(vBP 1.734), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.80573543) (m := (1:ℤ)) (ylo := 0.52255012) (yhi := 0.52255013)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.704) (q1 := 1.734) (t0 := 6.25) (t1 := 6.3125)
    (A := 1.06591948) (B := 1.10090679) (X := 6.80573543) (rho := 0.1437387)
    (clo := 0.86654925) (chi := 0.86654926) (C := 0.86140527) (h := 0.13859473)
    (by norm_num) (by norm_num) oscBlock62 vbpBr62.1 vbpBr63.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i63 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00114792):ℝ) ≤ ∫ v in (vBP 1.734)..(vBP 1.766), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.0302555) (m := (1:ℤ)) (ylo := 0.74707019) (yhi := 0.7470702)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.734) (q1 := 1.766) (t0 := 6.25) (t1 := 6.3125)
    (A := 1.10080961) (B := 1.13749718) (X := 7.0302555) (rho := 0.15019546)
    (clo := 0.73368279) (chi := 0.73368282) (C := 0.7336828) (h := 0.15019548)
    (by norm_num) (by norm_num) oscBlock63 vbpBr63.1 vbpBr64.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i64 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00076359):ℝ) ≤ ∫ v in (vBP 1.766)..(vBP 1.796), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.25088161) (m := (1:ℤ)) (ylo := 0.9676963) (yhi := 0.96769631)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.766) (q1 := 1.796) (t0 := 6.25) (t1 := 6.3125)
    (A := 1.1373613) (B := 1.17120873) (X := 7.25088161) (rho := 0.14237351)
    (clo := 0.5671983) (chi := 0.56719852) (C := 0.56719841) (h := 0.14237362)
    (by norm_num) (by norm_num) oscBlock64 vbpBr64.1 vbpBr65.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i65 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00055433):ℝ) ≤ ∫ v in (vBP 1.796)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.46765895) (m := (1:ℤ)) (ylo := 1.18447364) (yhi := 1.18447365)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.796) (q1 := 1.828) (t0 := 6.25) (t1 := 6.3125)
    (A := 1.1710258) (B := 1.20655947) (X := 7.46765895) (rho := 0.14874772)
    (clo := 0.37678464) (chi := 0.37678616) (C := 0.3767854) (h := 0.14874848)
    (by norm_num) (by norm_num) oscBlock65 vbpBr65.1 vbpBr66.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i66 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00030303):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.86), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.68759603) (m := (1:ℤ)) (ylo := 1.40441072) (yhi := 1.40441073)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.828) (q1 := 1.86) (t0 := 6.25) (t1 := 6.3125)
    (A := 1.20631244) (B := 1.24130524) (X := 7.68759603) (rho := 0.1481433)
    (clo := 0.16561882) (chi := 0.16562707) (C := 0.16562294) (h := 0.14814743)
    (by norm_num) (by norm_num) oscBlock66 vbpBr66.1 vbpBr67.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i67 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00014365):ℝ) ≤ ∫ v in (vBP 1.86)..(vBP 1.89), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 7.89706337) (m := (1:ℤ)) (ylo := 0.04308173) (yhi := 0.04308174)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.86) (q1 := 1.89) (t0 := 6.25) (t1 := 6.3125)
    (A := 1.24097685) (B := 1.27334993) (X := 7.89706337) (rho := 0.14095808)
    (clo := (-0.04306842)) (chi := (-0.0430684)) (C := (-0.04306841)) (h := 0.14095809)
    (by norm_num) (by norm_num) oscBlock67 vbpBr67.1 vbpBr68.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i68 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00028926):ℝ) ≤ ∫ v in (vBP 1.89)..(vBP 1.922), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.10307245) (m := (1:ℤ)) (ylo := 0.24909081) (yhi := 0.24909082)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.89) (q1 := 1.922) (t0 := 6.25) (t1 := 6.3125)
    (A := 1.27292668) (B := 1.30698664) (X := 8.10307245) (rho := 0.14728072)
    (clo := (-0.24652295)) (chi := (-0.24652293)) (C := (-0.24652294)) (h := 0.14728073)
    (by norm_num) (by norm_num) oscBlock68 vbpBr68.1 vbpBr69.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i69 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00066126):ℝ) ≤ ∫ v in (vBP 1.922)..(vBP 1.969), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.3606487) (m := (1:ℤ)) (ylo := 0.50666706) (yhi := 0.50666707)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.922) (q1 := 1.969) (t0 := 6.25) (t1 := 6.3125)
    (A := 1.30643896) (B := 1.35541448) (X := 8.3606487) (rho := 0.19540522)
    (clo := (-0.48526575)) (chi := (-0.48526573)) (C := (-0.48526574)) (h := 0.19540523)
    (by norm_num) (by norm_num) oscBlock69 vbpBr69.1 vbpBr70.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i70 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00080516):ℝ) ≤ ∫ v in (vBP 1.969)..(vBP 2.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.66061415) (m := (1:ℤ)) (ylo := 0.80663251) (yhi := 0.80663252)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.969) (q1 := 2.016) (t0 := 6.25) (t1 := 6.3125)
    (A := 1.35463226) (B := 1.4027369) (X := 8.66061415) (rho := 0.19416254)
    (clo := (-0.72196121)) (chi := (-0.72196119)) (C := (-0.7219612)) (h := 0.19416255)
    (by norm_num) (by norm_num) oscBlock70 vbpBr70.1 vbpBr71.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i71 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00078633):ℝ) ≤ ∫ v in (vBP 2.016)..(vBP 2.062), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.95051858) (m := (1:ℤ)) (ylo := 1.09653694) (yhi := 1.09653695)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.016) (q1 := 2.062) (t0 := 6.25) (t1 := 6.3125)
    (A := 1.40164597) (B := 1.44803958) (X := 8.95051858) (rho := 0.19023128)
    (clo := (-0.88963127)) (chi := (-0.88963118)) (C := (-0.84969995)) (h := 0.15030005)
    (by norm_num) (by norm_num) oscBlock71 vbpBr71.1 vbpBr72.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB9i72 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.00051116):ℝ) ≤ ∫ v in (vBP 2.062)..(vBP 2.094), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 9.18856819) (m := (1:ℤ)) (ylo := 1.33458655) (yhi := 1.33458656)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.062) (q1 := 2.094) (t0 := 6.25) (t1 := 6.3125)
    (A := 1.44655973) (B := 1.47899217) (X := 9.18856819) (rho := 0.1475699)
    (clo := (-0.97223254)) (chi := (-0.97223193)) (C := (-0.91233102)) (h := 0.08766899)
    (by norm_num) (by norm_num) oscBlock72 vbpBr72.1 vbpBr73.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

/-- Lower bound for the oscillatory integral `∫₀^∞ err(v) cos(tv) dv` on the band
`6.25 ≤ t ≤ 6.3125`. -/
theorem oscBandLower9 {t : ℝ} (ht0 : (6.25:ℝ) ≤ t) (ht1 : t ≤ 6.3125) :
    ((-0.1325913):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosB9i0 ht0 ht1)
    (cosB9i1 ht0 ht1))
    (cosB9i2 ht0 ht1))
    (cosB9i3 ht0 ht1))
    (cosB9i4 ht0 ht1))
    (cosB9i5 ht0 ht1))
    (cosB9i6 ht0 ht1))
    (cosB9i7 ht0 ht1))
    (cosB9i8 ht0 ht1))
    (cosB9i9 ht0 ht1))
    (cosB9i10 ht0 ht1))
    (cosB9i11 ht0 ht1))
    (cosB9i12 ht0 ht1))
    (cosB9i13 ht0 ht1))
    (cosB9i14 ht0 ht1))
    (cosB9i15 ht0 ht1))
    (cosB9i16 ht0 ht1))
    (cosB9i17 ht0 ht1))
    (cosB9i18 ht0 ht1))
    (cosB9i19 ht0 ht1))
    (cosB9i20 ht0 ht1))
    (cosB9i21 ht0 ht1))
    (cosB9i22 ht0 ht1))
    (cosB9i23 ht0 ht1))
    (cosB9i24 ht0 ht1))
    (cosB9i25 ht0 ht1))
    (cosB9i26 ht0 ht1))
    (cosB9i27 ht0 ht1))
    (cosB9i28 ht0 ht1))
    (cosB9i29 ht0 ht1))
    (cosB9i30 ht0 ht1))
    (cosB9i31 ht0 ht1))
    (cosB9i32 ht0 ht1))
    (cosB9i33 ht0 ht1))
    (cosB9i34 ht0 ht1))
    (cosB9i35 ht0 ht1))
    (cosB9i36 ht0 ht1))
    (cosB9i37 ht0 ht1))
    (cosB9i38 ht0 ht1))
    (cosB9i39 ht0 ht1))
    (cosB9i40 ht0 ht1))
    (cosB9i41 ht0 ht1))
    (cosB9i42 ht0 ht1))
    (cosB9i43 ht0 ht1))
    (cosB9i44 ht0 ht1))
    (cosB9i45 ht0 ht1))
    (cosB9i46 ht0 ht1))
    (cosB9i47 ht0 ht1))
    (cosB9i48 ht0 ht1))
    (cosB9i49 ht0 ht1))
    (cosB9i50 ht0 ht1))
    (cosB9i51 ht0 ht1))
    (cosB9i52 ht0 ht1))
    (cosB9i53 ht0 ht1))
    (cosB9i54 ht0 ht1))
    (cosB9i55 ht0 ht1))
    (cosB9i56 ht0 ht1))
    (cosB9i57 ht0 ht1))
    (cosB9i58 ht0 ht1))
    (cosB9i59 ht0 ht1))
    (cosB9i60 ht0 ht1))
    (cosB9i61 ht0 ht1))
    (cosB9i62 ht0 ht1))
    (cosB9i63 ht0 ht1))
    (cosB9i64 ht0 ht1))
    (cosB9i65 ht0 ht1))
    (cosB9i66 ht0 ht1))
    (cosB9i67 ht0 ht1))
    (cosB9i68 ht0 ht1))
    (cosB9i69 ht0 ht1))
    (cosB9i70 ht0 ht1))
    (cosB9i71 ht0 ht1))
    (cosB9i72 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 2.094) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 2.094) (S := 0.013709)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_cut
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
