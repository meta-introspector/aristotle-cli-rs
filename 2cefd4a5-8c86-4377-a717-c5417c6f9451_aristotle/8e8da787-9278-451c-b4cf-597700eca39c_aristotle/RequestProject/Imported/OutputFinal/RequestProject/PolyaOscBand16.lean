/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscTail

/-!
# Oscillatory lower bound on the band `5.8125 ≤ t ≤ 5.875`

On each of the 73 blocks the factor `cos(tv)` is bracketed by a rational constant
`C` up to a rational error `h`; the signed contribution `min(C·P₀, C·P₁) - h·S` is
then summed, and the unresolved tail beyond `q = 2.094` is estimated in absolute
value.  The result is the bound `∫₀^∞ err(v) cos(tv) dv ≥ -0.11793904`.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosB16i0 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00641868):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.0038), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.0222827) (m := (0:ℤ)) (ylo := 0.0222827) (yhi := 0.0222827)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1) (q1 := 1.0038) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.0) (B := 0.0075856) (X := 0.0222827) (rho := 0.02228271)
    (clo := 0.99975175) (chi := 0.99975176) (C := 0.98873452) (h := 0.01126548)
    (by norm_num) (by norm_num) oscBlock0 vbpBr0.1 vbpBr1.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i1 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00625872):ℝ) ≤ ∫ v in (vBP 1.0038)..(vBP 1.0078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.06769284) (m := (0:ℤ)) (ylo := 0.06769284) (yhi := 0.06769284)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0038) (q1 := 1.0078) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.00758559) (B := 0.01553948) (X := 0.06769284) (rho := 0.02360162)
    (clo := 0.99770971) (chi := 0.99770972) (C := 0.98705404) (h := 0.01294596)
    (by norm_num) (by norm_num) oscBlock1 vbpBr1.1 vbpBr2.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i2 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.0057677):ℝ) ≤ ∫ v in (vBP 1.0078)..(vBP 1.0118), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.11408076) (m := (0:ℤ)) (ylo := 0.11408076) (yhi := 0.11408076)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0078) (q1 := 1.0118) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.01553947) (B := 0.02346185) (X := 0.11408076) (rho := 0.02375761)
    (clo := 0.99349984) (chi := 0.99349985) (C := 0.98487111) (h := 0.01512889)
    (by norm_num) (by norm_num) oscBlock2 vbpBr2.1 vbpBr3.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i3 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00554846):ℝ) ≤ ∫ v in (vBP 1.0118)..(vBP 1.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.1614419) (m := (0:ℤ)) (ylo := 0.1614419) (yhi := 0.1614419)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0118) (q1 := 1.016) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.02346184) (B := 0.0317467) (X := 0.1614419) (rho := 0.02506997)
    (clo := 0.98699653) (chi := 0.98699654) (C := 0.98096328) (h := 0.01903672)
    (by norm_num) (by norm_num) oscBlock3 vbpBr3.1 vbpBr4.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i4 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00539232):ℝ) ≤ ∫ v in (vBP 1.016)..(vBP 1.0205), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.21148345) (m := (0:ℤ)) (ylo := 0.21148345) (yhi := 0.21148345)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.016) (q1 := 1.0205) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.03174669) (B := 0.04058541) (X := 0.21148345) (rho := 0.02695584)
    (clo := 0.97772059) (chi := 0.9777206) (C := 0.97538237) (h := 0.02461763)
    (by norm_num) (by norm_num) oscBlock4 vbpBr4.1 vbpBr5.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i5 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00481568):ℝ) ≤ ∫ v in (vBP 1.0205)..(vBP 1.025), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.26302043) (m := (0:ℤ)) (ylo := 0.26302043) (yhi := 0.26302043)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0205) (q1 := 1.025) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.0405854) (B := 0.04938523) (X := 0.26302043) (rho := 0.02711781)
    (clo := 0.96560907) (chi := 0.96560908) (C := 0.96560907) (h := 0.02711782)
    (by norm_num) (by norm_num) oscBlock5 vbpBr5.1 vbpBr6.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i6 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00469621):ℝ) ≤ ∫ v in (vBP 1.025)..(vBP 1.03), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.31718377) (m := (0:ℤ)) (ylo := 0.31718377) (yhi := 0.31718377)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.025) (q1 := 1.03) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.04938522) (B := 0.05911761) (X := 0.31718377) (rho := 0.0301322)
    (clo := 0.95011754) (chi := 0.95011755) (C := 0.95011754) (h := 0.03013221)
    (by norm_num) (by norm_num) oscBlock6 vbpBr6.1 vbpBr7.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i7 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00439805):ℝ) ≤ ∫ v in (vBP 1.03)..(vBP 1.0355), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.3767564) (m := (0:ℤ)) (ylo := 0.3767564) (yhi := 0.3767564)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.03) (q1 := 1.0355) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.0591176) (B := 0.06976881) (X := 0.3767564) (rho := 0.03313537)
    (clo := 0.92986286) (chi := 0.92986287) (C := 0.92986286) (h := 0.03313538)
    (by norm_num) (by norm_num) oscBlock7 vbpBr7.1 vbpBr8.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i8 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00394126):ℝ) ≤ ∫ v in (vBP 1.0355)..(vBP 1.0415), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.44165473) (m := (0:ℤ)) (ylo := 0.44165473) (yhi := 0.44165473)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0355) (q1 := 1.0415) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.0697688) (B := 0.08132397) (X := 0.44165473) (rho := 0.0361236)
    (clo := 0.90404561) (chi := 0.90404562) (C := 0.90404561) (h := 0.03612361)
    (by norm_num) (by norm_num) oscBlock8 vbpBr8.1 vbpBr9.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i9 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00335163):ℝ) ≤ ∫ v in (vBP 1.0415)..(vBP 1.048), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.51178885) (m := (0:ℤ)) (ylo := 0.51178885) (yhi := 0.51178885)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0415) (q1 := 1.048) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.08132396) (B := 0.09376718) (X := 0.51178885) (rho := 0.03909335)
    (clo := 0.87186983) (chi := 0.87186984) (C := 0.87186983) (h := 0.03909336)
    (by norm_num) (by norm_num) oscBlock9 vbpBr9.1 vbpBr10.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i10 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00268069):ℝ) ≤ ∫ v in (vBP 1.048)..(vBP 1.055), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.58706286) (m := (0:ℤ)) (ylo := 0.58706286) (yhi := 0.58706286)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.048) (q1 := 1.055) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.09376717) (B := 0.10708154) (X := 0.58706286) (rho := 0.0420412)
    (clo := 0.8325712) (chi := 0.83257121) (C := 0.8325712) (h := 0.04204121)
    (by norm_num) (by norm_num) oscBlock10 vbpBr10.1 vbpBr11.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i11 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00222262):ℝ) ≤ ∫ v in (vBP 1.055)..(vBP 1.064), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.67566364) (m := (0:ℤ)) (ylo := 0.67566364) (yhi := 0.67566364)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.055) (q1 := 1.064) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.10708153) (B := 0.12407079) (X := 0.67566364) (rho := 0.05325226)
    (clo := 0.78029207) (chi := 0.78029208) (C := 0.78029207) (h := 0.05325227)
    (by norm_num) (by norm_num) oscBlock11 vbpBr11.1 vbpBr12.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i12 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00144365):ℝ) ≤ ∫ v in (vBP 1.064)..(vBP 1.078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.80183712) (m := (0:ℤ)) (ylo := 0.80183712) (yhi := 0.80183712)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.064) (q1 := 1.078) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.12407078) (B := 0.15021495) (X := 0.80183712) (rho := 0.08067573)
    (clo := 0.69538766) (chi := 0.6953877) (C := 0.69538768) (h := 0.08067575)
    (by norm_num) (by norm_num) oscBlock12 vbpBr12.1 vbpBr13.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i13 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    (0.00018399:ℝ) ≤ ∫ v in (vBP 1.078)..(vBP 1.09), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.94285615) (m := (0:ℤ)) (ylo := 0.94285615) (yhi := 0.94285615)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.078) (q1 := 1.09) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.15021494) (B := 0.1723554) (X := 0.94285615) (rho := 0.06973183)
    (clo := 0.58747911) (chi := 0.58747927) (C := 0.58747919) (h := 0.06973191)
    (by norm_num) (by norm_num) oscBlock13 vbpBr13.1 vbpBr14.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i14 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    (0.00072203:ℝ) ≤ ∫ v in (vBP 1.09)..(vBP 1.1), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.06085515) (m := (0:ℤ)) (ylo := 1.06085515) (yhi := 1.06085515)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.09) (q1 := 1.1) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.17235539) (B := 0.19062036) (X := 1.06085515) (rho := 0.05903947)
    (clo := 0.4881259) (chi := 0.48812641) (C := 0.48812615) (h := 0.05903973)
    (by norm_num) (by norm_num) oscBlock14 vbpBr14.1 vbpBr15.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i15 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    (0.00080588:ℝ) ≤ ∫ v in (vBP 1.1)..(vBP 1.109), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.16181031) (m := (0:ℤ)) (ylo := 1.16181031) (yhi := 1.16181031)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.1) (q1 := 1.109) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.19062035) (B := 0.20691742) (X := 1.16181031) (rho := 0.05382954)
    (clo := 0.39767916) (chi := 0.39768041) (C := 0.39767978) (h := 0.05383017)
    (by norm_num) (by norm_num) oscBlock15 vbpBr15.1 vbpBr16.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i16 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    (0.00068684:ℝ) ≤ ∫ v in (vBP 1.109)..(vBP 1.117), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.25140205) (m := (0:ℤ)) (ylo := 1.25140205) (yhi := 1.25140205)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.109) (q1 := 1.117) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.20691741) (B := 0.22129305) (X := 1.25140205) (rho := 0.04869463)
    (clo := 0.31399149) (chi := 0.3139941) (C := 0.31399279) (h := 0.04869594)
    (by norm_num) (by norm_num) oscBlock16 vbpBr16.1 vbpBr17.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i17 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    (0.00050323:ℝ) ≤ ∫ v in (vBP 1.117)..(vBP 1.124), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.3298837) (m := (0:ℤ)) (ylo := 1.3298837) (yhi := 1.3298837)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.117) (q1 := 1.124) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.22129304) (B := 0.23378751) (X := 1.3298837) (rho := 0.04361793)
    (clo := 0.23858893) (chi := 0.23859371) (C := 0.23859132) (h := 0.04362032)
    (by norm_num) (by norm_num) oscBlock17 vbpBr17.1 vbpBr18.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i18 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    (0.00034334:ℝ) ≤ ∫ v in (vBP 1.124)..(vBP 1.131), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.40267034) (m := (0:ℤ)) (ylo := 1.40267034) (yhi := 1.40267034)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.124) (q1 := 1.131) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.2337875) (B := 0.2462044) (X := 1.40267034) (rho := 0.04378052)
    (clo := 0.16733493) (chi := 0.16734306) (C := 0.16733899) (h := 0.04378459)
    (by norm_num) (by norm_num) oscBlock18 vbpBr18.1 vbpBr19.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i19 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    (0.00014287:ℝ) ≤ ∫ v in (vBP 1.131)..(vBP 1.138), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.4750065) (m := (0:ℤ)) (ylo := 1.4750065) (yhi := 1.4750065)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.131) (q1 := 1.138) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.24620439) (B := 0.25854468) (X := 1.4750065) (rho := 0.0439435)
    (clo := 0.09564318) (chi := 0.09565662) (C := 0.0956499) (h := 0.04395022)
    (by norm_num) (by norm_num) oscBlock19 vbpBr19.1 vbpBr20.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i20 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00008432):ℝ) ≤ ∫ v in (vBP 1.138)..(vBP 1.145), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.5468977) (m := (0:ℤ)) (ylo := 1.5468977) (yhi := 1.5468977)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.138) (q1 := 1.145) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.25854467) (B := 0.27080928) (X := 1.5468977) (rho := 0.04410683)
    (clo := 0.02389596) (chi := 0.02391759) (C := 0.02390677) (h := 0.04411765)
    (by norm_num) (by norm_num) oscBlock20 vbpBr20.1 vbpBr21.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i21 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00035164):ℝ) ≤ ∫ v in (vBP 1.145)..(vBP 1.152), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.61834938) (m := (0:ℤ)) (ylo := 0.04755305) (yhi := 0.04755306)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.145) (q1 := 1.152) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.27080927) (B := 0.28299913) (X := 1.61834938) (rho := 0.04427052)
    (clo := (-0.04753515)) (chi := (-0.04753513)) (C := (-0.04753514)) (h := 0.04427053)
    (by norm_num) (by norm_num) oscBlock21 vbpBr21.1 vbpBr22.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i22 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00063491):ℝ) ≤ ∫ v in (vBP 1.152)..(vBP 1.159), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.68936688) (m := (0:ℤ)) (ylo := 0.11857055) (yhi := 0.11857056)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.152) (q1 := 1.159) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.28299912) (B := 0.29511513) (X := 1.68936688) (rho := 0.04443452)
    (clo := (-0.11829293)) (chi := (-0.11829291)) (C := (-0.11829292)) (h := 0.04443453)
    (by norm_num) (by norm_num) oscBlock22 vbpBr22.1 vbpBr23.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i23 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.0009154):ℝ) ≤ ∫ v in (vBP 1.159)..(vBP 1.166), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.75995547) (m := (0:ℤ)) (ylo := 0.18915914) (yhi := 0.18915915)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.159) (q1 := 1.166) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.29511512) (B := 0.30715818) (X := 1.75995547) (rho := 0.04459885)
    (clo := (-0.18803312)) (chi := (-0.1880331)) (C := (-0.18803311)) (h := 0.04459886)
    (by norm_num) (by norm_num) oscBlock23 vbpBr23.1 vbpBr24.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i24 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00118452):ℝ) ≤ ∫ v in (vBP 1.166)..(vBP 1.173), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.83012028) (m := (0:ℤ)) (ylo := 0.25932395) (yhi := 0.25932396)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.166) (q1 := 1.173) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.30715817) (B := 0.31912914) (X := 1.83012028) (rho := 0.04476343)
    (clo := (-0.25642718)) (chi := (-0.25642716)) (C := (-0.25642717)) (h := 0.04476344)
    (by norm_num) (by norm_num) oscBlock24 vbpBr24.1 vbpBr25.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i25 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00143476):ℝ) ≤ ∫ v in (vBP 1.173)..(vBP 1.18), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.89986636) (m := (0:ℤ)) (ylo := 0.32907003) (yhi := 0.32907004)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.173) (q1 := 1.18) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.31912913) (B := 0.33102888) (X := 1.89986636) (rho := 0.04492832)
    (clo := (-0.32316311)) (chi := (-0.32316309)) (C := (-0.3231631)) (h := 0.04492833)
    (by norm_num) (by norm_num) oscBlock25 vbpBr25.1 vbpBr26.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i26 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00165975):ℝ) ≤ ∫ v in (vBP 1.18)..(vBP 1.187), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.96919873) (m := (0:ℤ)) (ylo := 0.3984024) (yhi := 0.39840241)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.18) (q1 := 1.187) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.33102887) (B := 0.34285824) (X := 1.96919873) (rho := 0.04509344)
    (clo := (-0.38794637)) (chi := (-0.38794635)) (C := (-0.38794636)) (h := 0.04509345)
    (by norm_num) (by norm_num) oscBlock26 vbpBr26.1 vbpBr27.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i27 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00185431):ℝ) ≤ ∫ v in (vBP 1.187)..(vBP 1.194), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.03812222) (m := (0:ℤ)) (ylo := 0.46732589) (yhi := 0.4673259)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.187) (q1 := 1.194) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.34285823) (B := 0.35461804) (X := 2.03812222) (rho := 0.04525878)
    (clo := (-0.45050053)) (chi := (-0.45050051)) (C := (-0.45050052)) (h := 0.04525879)
    (by norm_num) (by norm_num) oscBlock27 vbpBr27.1 vbpBr28.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i28 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00203516):ℝ) ≤ ∫ v in (vBP 1.194)..(vBP 1.201), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.10664157) (m := (0:ℤ)) (ylo := 0.53584524) (yhi := 0.53584525)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.194) (q1 := 1.201) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.35461802) (B := 0.36630909) (X := 2.10664157) (rho := 0.04542435)
    (clo := (-0.510568)) (chi := (-0.51056799)) (C := (-0.510568)) (h := 0.04542436)
    (by norm_num) (by norm_num) oscBlock28 vbpBr28.1 vbpBr29.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i29 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.0021599):ℝ) ≤ ∫ v in (vBP 1.201)..(vBP 1.208), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.1747616) (m := (0:ℤ)) (ylo := 0.60396527) (yhi := 0.60396528)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.201) (q1 := 1.208) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.36630908) (B := 0.3779322) (X := 2.1747616) (rho := 0.04559009)
    (clo := (-0.56791072)) (chi := (-0.5679107)) (C := (-0.56791071)) (h := 0.0455901)
    (by norm_num) (by norm_num) oscBlock29 vbpBr29.1 vbpBr30.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i30 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00224558):ℝ) ≤ ∫ v in (vBP 1.208)..(vBP 1.215), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.24248689) (m := (0:ℤ)) (ylo := 0.67169056) (yhi := 0.67169057)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.208) (q1 := 1.215) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.37793219) (B := 0.38948816) (X := 2.24248689) (rho := 0.04575606)
    (clo := (-0.62231021)) (chi := (-0.62231019)) (C := (-0.6223102)) (h := 0.04575607)
    (by norm_num) (by norm_num) oscBlock30 vbpBr30.1 vbpBr31.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i31 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00263832):ℝ) ≤ ∫ v in (vBP 1.215)..(vBP 1.223), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.31462773) (m := (0:ℤ)) (ylo := 0.7438314) (yhi := 0.74383141)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.215) (q1 := 1.223) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.38948815) (B := 0.40261372) (X := 2.31462773) (rho := 0.05072788)
    (clo := (-0.67711234)) (chi := (-0.67711232)) (C := (-0.67711233)) (h := 0.05072789)
    (by norm_num) (by norm_num) oscBlock31 vbpBr31.1 vbpBr32.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i32 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00263892):ℝ) ≤ ∫ v in (vBP 1.223)..(vBP 1.231), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.39107883) (m := (0:ℤ)) (ylo := 0.8202825) (yhi := 0.82028251)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.223) (q1 := 1.231) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.40261371) (B := 0.4156537) (X := 2.39107883) (rho := 0.05088666)
    (clo := (-0.73133854)) (chi := (-0.73133852)) (C := (-0.73133853)) (h := 0.05088667)
    (by norm_num) (by norm_num) oscBlock32 vbpBr32.1 vbpBr33.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i33 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00258377):ℝ) ≤ ∫ v in (vBP 1.231)..(vBP 1.239), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.46703309) (m := (0:ℤ)) (ylo := 0.89623676) (yhi := 0.89623677)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.231) (q1 := 1.239) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.41565369) (B := 0.42860921) (X := 2.46703309) (rho := 0.05104603)
    (clo := (-0.78098212)) (chi := (-0.7809821)) (C := (-0.78098211)) (h := 0.05104604)
    (by norm_num) (by norm_num) oscBlock33 vbpBr33.1 vbpBr34.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i34 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00279217):ℝ) ≤ ∫ v in (vBP 1.239)..(vBP 1.248), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.54720635) (m := (0:ℤ)) (ylo := 0.97641002) (yhi := 0.97641003)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.239) (q1 := 1.248) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.4286092) (B := 0.44308455) (X := 2.54720635) (rho := 0.05591539)
    (clo := (-0.82849235)) (chi := (-0.82849232)) (C := (-0.82849234)) (h := 0.05591541)
    (by norm_num) (by norm_num) oscBlock34 vbpBr34.1 vbpBr35.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i35 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00287825):ℝ) ≤ ∫ v in (vBP 1.248)..(vBP 1.258), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.63616298) (m := (0:ℤ)) (ylo := 1.06536665) (yhi := 1.06536666)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.248) (q1 := 1.258) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.44308453) (B := 0.45904632) (X := 2.63616298) (rho := 0.06073416)
    (clo := (-0.87496657)) (chi := (-0.87496651)) (C := (-0.87496654)) (h := 0.06073419)
    (by norm_num) (by norm_num) oscBlock35 vbpBr35.1 vbpBr36.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i36 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00258711):ℝ) ≤ ∫ v in (vBP 1.258)..(vBP 1.268), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.72906839) (m := (0:ℤ)) (ylo := 1.15827206) (yhi := 1.15827207)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.258) (q1 := 1.268) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.45904631) (B := 0.47488172) (X := 2.72906839) (rho := 0.06086173)
    (clo := (-0.91611184)) (chi := (-0.9161117)) (C := (-0.91611177)) (h := 0.0608618)
    (by norm_num) (by norm_num) oscBlock36 vbpBr36.1 vbpBr37.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i37 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00261048):ℝ) ≤ ∫ v in (vBP 1.268)..(vBP 1.28), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.83042794) (m := (0:ℤ)) (ylo := 1.25963161) (yhi := 1.25963162)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.268) (q1 := 1.28) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.4748817) (B := 0.49372017) (X := 2.83042794) (rho := 0.07017807)
    (clo := (-0.95197794)) (chi := (-0.95197761)) (C := (-0.94089977)) (h := 0.05910023)
    (by norm_num) (by norm_num) oscBlock37 vbpBr37.1 vbpBr38.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i38 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.0022862):ℝ) ≤ ∫ v in (vBP 1.28)..(vBP 1.294), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.94908611) (m := (0:ℤ)) (ylo := 1.37828978) (yhi := 1.37828979)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.28) (q1 := 1.294) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.49372014) (B := 0.51547641) (X := 2.94908611) (rho := 0.07933781)
    (clo := (-0.98152862)) (chi := (-0.98152775)) (C := (-0.95109497)) (h := 0.04890503)
    (by norm_num) (by norm_num) oscBlock38 vbpBr38.1 vbpBr39.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i39 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00152769):ℝ) ≤ ∫ v in (vBP 1.294)..(vBP 1.308), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.07553641) (m := (0:ℤ)) (ylo := 1.50474008) (yhi := 1.50474009)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.294) (q1 := 1.308) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.51547638) (B := 0.53699853) (X := 3.07553641) (rho := 0.07932997)
    (clo := (-0.9978213)) (chi := (-0.99781904)) (C := (-0.95924454)) (h := 0.04075547)
    (by norm_num) (by norm_num) oscBlock39 vbpBr39.1 vbpBr40.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i40 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00099465):ℝ) ≤ ∫ v in (vBP 1.308)..(vBP 1.326), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.21838242) (m := (0:ℤ)) (ylo := 0.07678976) (yhi := 0.07678977)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.308) (q1 := 1.326) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.53699848) (B := 0.56433382) (X := 3.21838242) (rho := 0.09707878)
    (clo := (-0.99705312)) (chi := (-0.99705311)) (C := (-0.94998717)) (h := 0.05001284)
    (by norm_num) (by norm_num) oscBlock40 vbpBr40.1 vbpBr41.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i41 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00000144):ℝ) ≤ ∫ v in (vBP 1.326)..(vBP 1.345), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.38140991) (m := (0:ℤ)) (ylo := 0.23981725) (yhi := 0.23981726)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.326) (q1 := 1.345) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.56433374) (B := 0.59278808) (X := 3.38140991) (rho := 0.10122007)
    (clo := (-0.9713814)) (chi := (-0.97138139)) (C := (-0.93508066)) (h := 0.06491934)
    (by norm_num) (by norm_num) oscBlock41 vbpBr41.1 vbpBr42.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i42 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    (0.0008393:ℝ) ≤ ∫ v in (vBP 1.345)..(vBP 1.362), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.53789622) (m := (0:ℤ)) (ylo := 0.39630356) (yhi := 0.39630357)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.345) (q1 := 1.362) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.59278796) (B := 0.6179085) (X := 3.53789622) (rho := 0.09231622)
    (clo := (-0.92249416)) (chi := (-0.92249415)) (C := (-0.91508897)) (h := 0.08491104)
    (by norm_num) (by norm_num) oscBlock42 vbpBr42.1 vbpBr43.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i43 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    (0.00097405:ℝ) ≤ ∫ v in (vBP 1.362)..(vBP 1.376), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.67098322) (m := (0:ℤ)) (ylo := 0.52939056) (yhi := 0.52939057)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.362) (q1 := 1.376) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.61790831) (B := 0.6383616) (X := 3.67098322) (rho := 0.07939119)
    (clo := (-0.86311501)) (chi := (-0.86311499)) (C := (-0.863115)) (h := 0.0793912)
    (by norm_num) (by norm_num) oscBlock43 vbpBr43.1 vbpBr44.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i44 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    (0.00105524:ℝ) ≤ ∫ v in (vBP 1.376)..(vBP 1.39), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.78989764) (m := (0:ℤ)) (ylo := 0.64830498) (yhi := 0.64830499)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.376) (q1 := 1.39) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.63836133) (B := 0.65860767) (X := 3.78989764) (rho := 0.07942243)
    (clo := (-0.79710847)) (chi := (-0.79710845)) (C := (-0.79710846)) (h := 0.07942244)
    (by norm_num) (by norm_num) oscBlock44 vbpBr44.1 vbpBr45.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i45 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    (0.00101343:ℝ) ≤ ∫ v in (vBP 1.39)..(vBP 1.404), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.90761433) (m := (0:ℤ)) (ylo := 0.76602167) (yhi := 0.76602168)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.39) (q1 := 1.404) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.65860729) (B := 0.67865086) (X := 3.90761433) (rho := 0.07945948)
    (clo := (-0.72067446)) (chi := (-0.72067442)) (C := (-0.72067444)) (h := 0.0794595)
    (by norm_num) (by norm_num) oscBlock45 vbpBr45.1 vbpBr46.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i46 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    (0.00087804:ℝ) ≤ ∫ v in (vBP 1.404)..(vBP 1.418), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.02415714) (m := (0:ℤ)) (ylo := 0.88256448) (yhi := 0.88256449)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.404) (q1 := 1.418) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.67865033) (B := 0.69849519) (X := 4.02415714) (rho := 0.07950211)
    (clo := (-0.63517259)) (chi := (-0.63517249)) (C := (-0.63517254)) (h := 0.07950216)
    (by norm_num) (by norm_num) oscBlock46 vbpBr46.1 vbpBr47.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i47 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    (0.00068303:ℝ) ≤ ∫ v in (vBP 1.418)..(vBP 1.432), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.13954928) (m := (0:ℤ)) (ylo := 0.99795662) (yhi := 0.99795663)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.418) (q1 := 1.432) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.69849446) (B := 0.7181446) (X := 4.13954928) (rho := 0.07955025)
    (clo := (-0.54202089)) (chi := (-0.54202061)) (C := (-0.54202075)) (h := 0.07955039)
    (by norm_num) (by norm_num) oscBlock47 vbpBr47.1 vbpBr48.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i48 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    (0.00046248:ℝ) ≤ ∫ v in (vBP 1.432)..(vBP 1.446), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.25381323) (m := (0:ℤ)) (ylo := 1.11222057) (yhi := 1.11222058)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.432) (q1 := 1.446) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.7181436) (B := 0.73760286) (X := 4.25381323) (rho := 0.07960358)
    (clo := (-0.44267226)) (chi := (-0.44267144)) (C := (-0.44267185)) (h := 0.07960399)
    (by norm_num) (by norm_num) oscBlock48 vbpBr48.1 vbpBr49.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i49 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    (0.00024806:ℝ) ≤ ∫ v in (vBP 1.446)..(vBP 1.462), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.37501346) (m := (0:ℤ)) (ylo := 1.2334208) (yhi := 1.23342081)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.446) (q1 := 1.462) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.73760153) (B := 0.75961158) (X := 4.37501346) (rho := 0.08770458)
    (clo := (-0.33101394)) (chi := (-0.33101167)) (C := (-0.33101281)) (h := 0.08770572)
    (by norm_num) (by norm_num) oscBlock49 vbpBr49.1 vbpBr50.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i50 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00026613):ℝ) ≤ ∫ v in (vBP 1.462)..(vBP 1.478), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.5029219) (m := (0:ℤ)) (ylo := 1.36132924) (yhi := 1.36132925)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.462) (q1 := 1.478) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.75960973) (B := 0.78138081) (X := 4.5029219) (rho := 0.08769037)
    (clo := (-0.20794461)) (chi := (-0.20793857)) (C := (-0.20794159)) (h := 0.08769339)
    (by norm_num) (by norm_num) oscBlock50 vbpBr50.1 vbpBr51.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i51 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00027318):ℝ) ≤ ∫ v in (vBP 1.478)..(vBP 1.495), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.63337683) (m := (0:ℤ)) (ylo := 1.49178417) (yhi := 1.49178418)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.478) (q1 := 1.495) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.7813783) (B := 0.80425401) (X := 4.63337683) (rho := 0.09161548)
    (clo := (-0.07894477)) (chi := (-0.07892971)) (C := (-0.07893724)) (h := 0.09162301)
    (by norm_num) (by norm_num) oscBlock51 vbpBr51.1 vbpBr52.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i52 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00027944):ℝ) ≤ ∫ v in (vBP 1.495)..(vBP 1.512), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.76628005) (m := (0:ℤ)) (ylo := 0.05389106) (yhi := 0.05389107)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.495) (q1 := 1.512) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.80425056) (B := 0.82686872) (X := 4.76628005) (rho := 0.09157369)
    (clo := 0.05386497) (chi := 0.05386499) (C := 0.05386498) (h := 0.0915737)
    (by norm_num) (by norm_num) oscBlock52 vbpBr52.1 vbpBr53.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i53 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00057584):ℝ) ≤ ∫ v in (vBP 1.512)..(vBP 1.531), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.90536897) (m := (0:ℤ)) (ylo := 0.19297998) (yhi := 0.19297999)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.512) (q1 := 1.531) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.82686405) (B := 0.85184522) (X := 4.90536897) (rho := 0.0992217)
    (clo := 0.1917844) (chi := 0.19178442) (C := 0.19178441) (h := 0.09922171)
    (by norm_num) (by norm_num) oscBlock53 vbpBr53.1 vbpBr54.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i54 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00078079):ℝ) ≤ ∫ v in (vBP 1.531)..(vBP 1.55), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.05041609) (m := (0:ℤ)) (ylo := 0.3380271) (yhi := 0.33802711)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.531) (q1 := 1.55) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.85183877) (B := 0.87651393) (X := 5.05041609) (rho := 0.09910326)
    (clo := 0.33162648) (chi := 0.3316265) (C := 0.33162649) (h := 0.09910327)
    (by norm_num) (by norm_num) oscBlock54 vbpBr54.1 vbpBr55.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i55 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00099504):ℝ) ≤ ∫ v in (vBP 1.55)..(vBP 1.57), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.19742863) (m := (0:ℤ)) (ylo := 0.48503964) (yhi := 0.48503965)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.55) (q1 := 1.57) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.87650515) (B := 0.90215678) (X := 5.19742863) (rho := 0.10274246)
    (clo := 0.46624342) (chi := 0.46624344) (C := 0.46624343) (h := 0.10274247)
    (by norm_num) (by norm_num) oscBlock55 vbpBr55.1 vbpBr56.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i56 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.0011112):ℝ) ≤ ∫ v in (vBP 1.57)..(vBP 1.59), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.34631757) (m := (0:ℤ)) (ylo := 0.63392858) (yhi := 0.63392859)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.57) (q1 := 1.59) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.90214481) (B := 0.92747548) (X := 5.34631757) (rho := 0.10260088)
    (clo := 0.5923146) (chi := 0.59231462) (C := 0.59231461) (h := 0.10260089)
    (by norm_num) (by norm_num) oscBlock56 vbpBr56.1 vbpBr57.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i57 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00118065):ℝ) ≤ ∫ v in (vBP 1.59)..(vBP 1.61), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.49333371) (m := (0:ℤ)) (ylo := 0.78094472) (yhi := 0.78094473)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.59) (q1 := 1.61) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.92745939) (B := 0.95247825) (X := 5.49333371) (rho := 0.10247602)
    (clo := 0.70395071) (chi := 0.70395073) (C := 0.70395072) (h := 0.10247603)
    (by norm_num) (by norm_num) oscBlock57 vbpBr57.1 vbpBr58.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i58 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00136262):ℝ) ≤ ∫ v in (vBP 1.61)..(vBP 1.632), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.64572874) (m := (0:ℤ)) (ylo := 0.93333975) (yhi := 0.93333976)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.61) (q1 := 1.632) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.95245689) (B := 0.97962584) (X := 5.64572874) (rho := 0.10957308)
    (clo := 0.80361208) (chi := 0.80361211) (C := 0.80361209) (h := 0.1095731)
    (by norm_num) (by norm_num) oscBlock58 vbpBr58.1 vbpBr59.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i59 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00149999):ℝ) ≤ ∫ v in (vBP 1.632)..(vBP 1.656), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.81038702) (m := (0:ℤ)) (ylo := 1.09799803) (yhi := 1.09799804)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.632) (q1 := 1.656) (t0 := 5.8125) (t1 := 5.875)
    (A := 0.97959707) (B := 1.00882827) (X := 5.81038702) (rho := 0.11647907)
    (clo := 0.89029748) (chi := 0.89029757) (C := 0.8869092) (h := 0.1130908)
    (by norm_num) (by norm_num) oscBlock59 vbpBr59.1 vbpBr60.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i60 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00135601):ℝ) ≤ ∫ v in (vBP 1.656)..(vBP 1.68), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.97977836) (m := (0:ℤ)) (ylo := 1.26738937) (yhi := 1.26738938)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.656) (q1 := 1.68) (t0 := 5.8125) (t1 := 5.875)
    (A := 1.00878907) (B := 1.03761196) (X := 5.97977836) (rho := 0.11619191)
    (clo := 0.95432411) (chi := 0.95432447) (C := 0.9190661) (h := 0.0809339)
    (by norm_num) (by norm_num) oscBlock60 vbpBr60.1 vbpBr61.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i61 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00122808):ℝ) ≤ ∫ v in (vBP 1.68)..(vBP 1.704), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.14674993) (m := (0:ℤ)) (ylo := 1.43436094) (yhi := 1.43436095)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.68) (q1 := 1.704) (t0 := 5.8125) (t1 := 5.875)
    (A := 1.03755935) (B := 1.06598913) (X := 6.14674993) (rho := 0.11593622)
    (clo := 0.9907071) (chi := 0.99070843) (C := 0.93738544) (h := 0.06261456)
    (by norm_num) (by norm_num) oscBlock61 vbpBr61.1 vbpBr62.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i62 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00137159):ℝ) ≤ ∫ v in (vBP 1.704)..(vBP 1.734), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.33174218) (m := (1:ℤ)) (ylo := 0.04855687) (yhi := 0.04855688)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.704) (q1 := 1.734) (t0 := 5.8125) (t1 := 5.875)
    (A := 1.06591948) (B := 1.10090679) (X := 6.33174218) (rho := 0.13608522)
    (clo := 0.99882134) (chi := 0.99882135) (C := 0.93136806) (h := 0.06863194)
    (by norm_num) (by norm_num) oscBlock62 vbpBr62.1 vbpBr63.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i63 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00129873):ℝ) ≤ ∫ v in (vBP 1.734)..(vBP 1.766), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.54062589) (m := (1:ℤ)) (ylo := 0.25744058) (yhi := 0.25744059)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.734) (q1 := 1.766) (t0 := 5.8125) (t1 := 5.875)
    (A := 1.10080961) (B := 1.13749718) (X := 6.54062589) (rho := 0.14217005)
    (clo := 0.96704478) (chi := 0.96704479) (C := 0.91243736) (h := 0.08756264)
    (by norm_num) (by norm_num) oscBlock63 vbpBr63.1 vbpBr64.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i64 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00107612):ℝ) ≤ ∫ v in (vBP 1.766)..(vBP 1.796), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.74588192) (m := (1:ℤ)) (ylo := 0.46269661) (yhi := 0.46269662)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.766) (q1 := 1.796) (t0 := 5.8125) (t1 := 5.875)
    (A := 1.1373613) (B := 1.17120873) (X := 6.74588192) (rho := 0.13496938)
    (clo := 0.89485208) (chi := 0.89485209) (C := 0.87994135) (h := 0.12005865)
    (by norm_num) (by norm_num) oscBlock64 vbpBr64.1 vbpBr65.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i65 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00097913):ℝ) ≤ ∫ v in (vBP 1.796)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.94756217) (m := (1:ℤ)) (ylo := 0.66437686) (yhi := 0.66437687)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.796) (q1 := 1.828) (t0 := 5.8125) (t1 := 5.875)
    (A := 1.1710258) (B := 1.20655947) (X := 6.94756217) (rho := 0.14097473)
    (clo := 0.78730114) (chi := 0.78730116) (C := 0.78730115) (h := 0.14097474)
    (by norm_num) (by norm_num) oscBlock65 vbpBr65.1 vbpBr66.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i66 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00075916):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.86), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.15217967) (m := (1:ℤ)) (ylo := 0.86899436) (yhi := 0.86899437)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.828) (q1 := 1.86) (t0 := 5.8125) (t1 := 5.875)
    (A := 1.20631244) (B := 1.24130524) (X := 7.15217967) (rho := 0.14048863)
    (clo := 0.64559485) (chi := 0.64559493) (C := 0.64559489) (h := 0.14048867)
    (by norm_num) (by norm_num) oscBlock66 vbpBr66.1 vbpBr67.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i67 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00049807):ℝ) ≤ ∫ v in (vBP 1.86)..(vBP 1.89), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.34705438) (m := (1:ℤ)) (ylo := 1.06386907) (yhi := 1.06386908)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.86) (q1 := 1.89) (t0 := 5.8125) (t1 := 5.875)
    (A := 1.24097685) (B := 1.27334993) (X := 7.34705438) (rho := 0.13387646)
    (clo := 0.48549321) (chi := 0.48549374) (C := 0.48549347) (h := 0.13387673)
    (by norm_num) (by norm_num) oscBlock67 vbpBr67.1 vbpBr68.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i68 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00034867):ℝ) ≤ ∫ v in (vBP 1.89)..(vBP 1.922), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.53871641) (m := (1:ℤ)) (ylo := 1.2555311) (yhi := 1.25553111)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.89) (q1 := 1.922) (t0 := 5.8125) (t1 := 5.875)
    (A := 1.27292668) (B := 1.30698664) (X := 7.53871641) (rho := 0.13983011)
    (clo := 0.31006859) (chi := 0.31007129) (C := 0.31006994) (h := 0.13983146)
    (by norm_num) (by norm_num) oscBlock68 vbpBr68.1 vbpBr69.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i69 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00025857):ℝ) ≤ ∫ v in (vBP 1.922)..(vBP 1.969), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.77836826) (m := (1:ℤ)) (ylo := 1.49518295) (yhi := 1.49518296)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.922) (q1 := 1.969) (t0 := 5.8125) (t1 := 5.875)
    (A := 1.30643896) (B := 1.35541448) (X := 7.77836826) (rho := 0.18469182)
    (clo := 0.07554107) (chi := 0.07555648) (C := 0.07554877) (h := 0.18469953)
    (by norm_num) (by norm_num) oscBlock69 vbpBr69.1 vbpBr70.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i70 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00033898):ℝ) ≤ ∫ v in (vBP 1.969)..(vBP 2.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.05743964) (m := (1:ℤ)) (ylo := 0.203458) (yhi := 0.20345801)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.969) (q1 := 2.016) (t0 := 5.8125) (t1 := 5.875)
    (A := 1.35463226) (B := 1.4027369) (X := 8.05743964) (rho := 0.18363965)
    (clo := (-0.20205722)) (chi := (-0.2020572)) (C := (-0.20205721)) (h := 0.18363966)
    (by norm_num) (by norm_num) oscBlock70 vbpBr70.1 vbpBr71.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i71 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00049995):ℝ) ≤ ∫ v in (vBP 2.016)..(vBP 2.062), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.32714986) (m := (1:ℤ)) (ylo := 0.47316822) (yhi := 0.47316823)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.016) (q1 := 2.062) (t0 := 5.8125) (t1 := 5.875)
    (A := 1.40164597) (B := 1.44803958) (X := 8.32714986) (rho := 0.18008268)
    (clo := (-0.45570871)) (chi := (-0.45570869)) (C := (-0.4557087)) (h := 0.18008269)
    (by norm_num) (by norm_num) oscBlock71 vbpBr71.1 vbpBr72.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB16i72 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.00039899):ℝ) ≤ ∫ v in (vBP 2.062)..(vBP 2.094), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.54860371) (m := (1:ℤ)) (ylo := 0.69462207) (yhi := 0.69462208)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.062) (q1 := 2.094) (t0 := 5.8125) (t1 := 5.875)
    (A := 1.44655973) (B := 1.47899217) (X := 8.54860371) (rho := 0.1404753)
    (clo := (-0.64009514)) (chi := (-0.64009512)) (C := (-0.64009513)) (h := 0.14047531)
    (by norm_num) (by norm_num) oscBlock72 vbpBr72.1 vbpBr73.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

/-- Lower bound for the oscillatory integral `∫₀^∞ err(v) cos(tv) dv` on the band
`5.8125 ≤ t ≤ 5.875`. -/
theorem oscBandLower16 {t : ℝ} (ht0 : (5.8125:ℝ) ≤ t) (ht1 : t ≤ 5.875) :
    ((-0.11793904):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosB16i0 ht0 ht1)
    (cosB16i1 ht0 ht1))
    (cosB16i2 ht0 ht1))
    (cosB16i3 ht0 ht1))
    (cosB16i4 ht0 ht1))
    (cosB16i5 ht0 ht1))
    (cosB16i6 ht0 ht1))
    (cosB16i7 ht0 ht1))
    (cosB16i8 ht0 ht1))
    (cosB16i9 ht0 ht1))
    (cosB16i10 ht0 ht1))
    (cosB16i11 ht0 ht1))
    (cosB16i12 ht0 ht1))
    (cosB16i13 ht0 ht1))
    (cosB16i14 ht0 ht1))
    (cosB16i15 ht0 ht1))
    (cosB16i16 ht0 ht1))
    (cosB16i17 ht0 ht1))
    (cosB16i18 ht0 ht1))
    (cosB16i19 ht0 ht1))
    (cosB16i20 ht0 ht1))
    (cosB16i21 ht0 ht1))
    (cosB16i22 ht0 ht1))
    (cosB16i23 ht0 ht1))
    (cosB16i24 ht0 ht1))
    (cosB16i25 ht0 ht1))
    (cosB16i26 ht0 ht1))
    (cosB16i27 ht0 ht1))
    (cosB16i28 ht0 ht1))
    (cosB16i29 ht0 ht1))
    (cosB16i30 ht0 ht1))
    (cosB16i31 ht0 ht1))
    (cosB16i32 ht0 ht1))
    (cosB16i33 ht0 ht1))
    (cosB16i34 ht0 ht1))
    (cosB16i35 ht0 ht1))
    (cosB16i36 ht0 ht1))
    (cosB16i37 ht0 ht1))
    (cosB16i38 ht0 ht1))
    (cosB16i39 ht0 ht1))
    (cosB16i40 ht0 ht1))
    (cosB16i41 ht0 ht1))
    (cosB16i42 ht0 ht1))
    (cosB16i43 ht0 ht1))
    (cosB16i44 ht0 ht1))
    (cosB16i45 ht0 ht1))
    (cosB16i46 ht0 ht1))
    (cosB16i47 ht0 ht1))
    (cosB16i48 ht0 ht1))
    (cosB16i49 ht0 ht1))
    (cosB16i50 ht0 ht1))
    (cosB16i51 ht0 ht1))
    (cosB16i52 ht0 ht1))
    (cosB16i53 ht0 ht1))
    (cosB16i54 ht0 ht1))
    (cosB16i55 ht0 ht1))
    (cosB16i56 ht0 ht1))
    (cosB16i57 ht0 ht1))
    (cosB16i58 ht0 ht1))
    (cosB16i59 ht0 ht1))
    (cosB16i60 ht0 ht1))
    (cosB16i61 ht0 ht1))
    (cosB16i62 ht0 ht1))
    (cosB16i63 ht0 ht1))
    (cosB16i64 ht0 ht1))
    (cosB16i65 ht0 ht1))
    (cosB16i66 ht0 ht1))
    (cosB16i67 ht0 ht1))
    (cosB16i68 ht0 ht1))
    (cosB16i69 ht0 ht1))
    (cosB16i70 ht0 ht1))
    (cosB16i71 ht0 ht1))
    (cosB16i72 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 2.094) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 2.094) (S := 0.013709)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_cut
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
