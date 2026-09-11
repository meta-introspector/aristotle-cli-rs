/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscTail

/-!
# Oscillatory lower bound on the band `5.71875 ≤ t ≤ 5.75`

On each of the 73 blocks the factor `cos(tv)` is bracketed by a rational constant
`C` up to a rational error `h`; the signed contribution `min(C·P₀, C·P₁) - h·S` is
then summed, and the unresolved tail beyond `q = 2.094` is estimated in absolute
value.  The result is the bound `∫₀^∞ err(v) cos(tv) dv ≥ -0.11335088`.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosB19i0 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00641868):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.0038), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.0218086) (m := (0:ℤ)) (ylo := 0.0218086) (yhi := 0.0218086)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1) (q1 := 1.0038) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.0) (B := 0.0075856) (X := 0.0218086) (rho := 0.02180861)
    (clo := 0.9997622) (chi := 0.99976221) (C := 0.98897679) (h := 0.01102321)
    (by norm_num) (by norm_num) oscBlock0 vbpBr0.1 vbpBr1.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i1 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00625872):ℝ) ≤ ∫ v in (vBP 1.0038)..(vBP 1.0078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.06636605) (m := (0:ℤ)) (ylo := 0.06636605) (yhi := 0.06636605)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0038) (q1 := 1.0078) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.00758559) (B := 0.01553948) (X := 0.06636605) (rho := 0.02298597)
    (clo := 0.99779858) (chi := 0.99779859) (C := 0.9874063) (h := 0.0125937)
    (by norm_num) (by norm_num) oscBlock1 vbpBr1.1 vbpBr2.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i2 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.0057677):ℝ) ≤ ∫ v in (vBP 1.0078)..(vBP 1.0118), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.11188599) (m := (0:ℤ)) (ylo := 0.11188599) (yhi := 0.11188599)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0078) (q1 := 1.0118) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.01553947) (B := 0.02346185) (X := 0.11188599) (rho := 0.02301966)
    (clo := 0.99374728) (chi := 0.99374729) (C := 0.98536381) (h := 0.01463619)
    (by norm_num) (by norm_num) oscBlock2 vbpBr2.1 vbpBr3.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i3 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00554846):ℝ) ≤ ∫ v in (vBP 1.0118)..(vBP 1.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.15835796) (m := (0:ℤ)) (ylo := 0.15835796) (yhi := 0.15835796)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0118) (q1 := 1.016) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.02346184) (B := 0.0317467) (X := 0.15835796) (rho := 0.02418558)
    (clo := 0.98748755) (chi := 0.98748756) (C := 0.98165098) (h := 0.01834902)
    (by norm_num) (by norm_num) oscBlock3 vbpBr3.1 vbpBr4.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i4 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00539232):ℝ) ≤ ∫ v in (vBP 1.016)..(vBP 1.0205), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.20745874) (m := (0:ℤ)) (ylo := 0.20745874) (yhi := 0.20745874)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.016) (q1 := 1.0205) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.03174669) (B := 0.04058541) (X := 0.20745874) (rho := 0.02590738)
    (clo := 0.9785575) (chi := 0.97855751) (C := 0.97632506) (h := 0.02367494)
    (by norm_num) (by norm_num) oscBlock4 vbpBr4.1 vbpBr5.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i5 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00481617):ℝ) ≤ ∫ v in (vBP 1.0205)..(vBP 1.025), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.25803141) (m := (0:ℤ)) (ylo := 0.25803141) (yhi := 0.25803141)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0205) (q1 := 1.025) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.0405854) (B := 0.04938523) (X := 0.25803141) (rho := 0.02593367)
    (clo := 0.96689419) (chi := 0.9668942) (C := 0.96689419) (h := 0.02593368)
    (by norm_num) (by norm_num) oscBlock5 vbpBr5.1 vbpBr6.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i6 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.0046985):ℝ) ≤ ∫ v in (vBP 1.025)..(vBP 1.03), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.31117399) (m := (0:ℤ)) (ylo := 0.31117399) (yhi := 0.31117399)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.025) (q1 := 1.03) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.04938522) (B := 0.05911761) (X := 0.31117399) (rho := 0.02875228)
    (clo := 0.95197477) (chi := 0.95197478) (C := 0.95197477) (h := 0.02875229)
    (by norm_num) (by norm_num) oscBlock6 vbpBr6.1 vbpBr7.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i7 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00440266):ℝ) ≤ ∫ v in (vBP 1.03)..(vBP 1.0355), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.36962471) (m := (0:ℤ)) (ylo := 0.36962471) (yhi := 0.36962471)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.03) (q1 := 1.0355) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.0591176) (B := 0.06976881) (X := 0.36962471) (rho := 0.03154596)
    (clo := 0.93246299) (chi := 0.932463) (C := 0.93246299) (h := 0.03154597)
    (by norm_num) (by norm_num) oscBlock7 vbpBr7.1 vbpBr8.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i8 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.0039485):ℝ) ≤ ∫ v in (vBP 1.0355)..(vBP 1.0415), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.43330157) (m := (0:ℤ)) (ylo := 0.43330157) (yhi := 0.43330157)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0355) (q1 := 1.0415) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.0697688) (B := 0.08132397) (X := 0.43330157) (rho := 0.03431127)
    (clo := 0.90758447) (chi := 0.90758448) (C := 0.90758447) (h := 0.03431128)
    (by norm_num) (by norm_num) oscBlock8 vbpBr8.1 vbpBr9.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i9 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00336137):ℝ) ≤ ∫ v in (vBP 1.0415)..(vBP 1.048), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.50211634) (m := (0:ℤ)) (ylo := 0.50211634) (yhi := 0.50211634)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0415) (q1 := 1.048) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.08132396) (B := 0.09376718) (X := 0.50211634) (rho := 0.03704496)
    (clo := 0.87656596) (chi := 0.87656598) (C := 0.87656597) (h := 0.03704497)
    (by norm_num) (by norm_num) oscBlock9 vbpBr9.1 vbpBr10.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i10 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00269232):ℝ) ≤ ∫ v in (vBP 1.048)..(vBP 1.055), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.57597492) (m := (0:ℤ)) (ylo := 0.57597492) (yhi := 0.57597492)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.048) (q1 := 1.055) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.09376717) (B := 0.10708154) (X := 0.57597492) (rho := 0.03974394)
    (clo := 0.8386617) (chi := 0.83866171) (C := 0.8386617) (h := 0.03974395)
    (by norm_num) (by norm_num) oscBlock10 vbpBr10.1 vbpBr11.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i11 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00223646):ℝ) ≤ ∫ v in (vBP 1.055)..(vBP 1.064), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.66288977) (m := (0:ℤ)) (ylo := 0.66288977) (yhi := 0.66288977)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.055) (q1 := 1.064) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.10708153) (B := 0.12407079) (X := 0.66288977) (rho := 0.05051729)
    (clo := 0.78821716) (chi := 0.78821718) (C := 0.78821717) (h := 0.0505173)
    (by norm_num) (by norm_num) oscBlock11 vbpBr11.1 vbpBr12.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i12 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00145718):ℝ) ≤ ∫ v in (vBP 1.064)..(vBP 1.078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.78663286) (m := (0:ℤ)) (ylo := 0.78663286) (yhi := 0.78663286)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.064) (q1 := 1.078) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.12407078) (B := 0.15021495) (X := 0.78663286) (rho := 0.07710311)
    (clo := 0.70623317) (chi := 0.70623321) (C := 0.70623319) (h := 0.07710313)
    (by norm_num) (by norm_num) oscBlock12 vbpBr12.1 vbpBr13.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i13 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    (0.00019835:ℝ) ≤ ∫ v in (vBP 1.078)..(vBP 1.09), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.92504261) (m := (0:ℤ)) (ylo := 0.92504261) (yhi := 0.92504261)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.078) (q1 := 1.09) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.15021494) (B := 0.1723554) (X := 0.92504261) (rho := 0.06600095)
    (clo := 0.60180056) (chi := 0.60180069) (C := 0.60180062) (h := 0.06600102)
    (by norm_num) (by norm_num) oscBlock13 vbpBr13.1 vbpBr14.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i14 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    (0.00076301:ℝ) ≤ ∫ v in (vBP 1.09)..(vBP 1.1), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.04086222) (m := (0:ℤ)) (ylo := 1.04086222) (yhi := 1.04086222)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.09) (q1 := 1.1) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.17235539) (B := 0.19062036) (X := 1.04086222) (rho := 0.05520486)
    (clo := 0.50547648) (chi := 0.5054769) (C := 0.50547669) (h := 0.05520507)
    (by norm_num) (by norm_num) oscBlock14 vbpBr14.1 vbpBr15.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i15 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    (0.0008668:ℝ) ≤ ∫ v in (vBP 1.1)..(vBP 1.109), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.13994264) (m := (0:ℤ)) (ylo := 1.13994264) (yhi := 1.13994264)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.1) (q1 := 1.109) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.19062035) (B := 0.20691742) (X := 1.13994264) (rho := 0.04983253)
    (clo := 0.41764661) (chi := 0.41764764) (C := 0.41764712) (h := 0.04983305)
    (by norm_num) (by norm_num) oscBlock15 vbpBr15.1 vbpBr16.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i16 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    (0.00075997:ℝ) ≤ ∫ v in (vBP 1.109)..(vBP 1.117), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.22787198) (m := (0:ℤ)) (ylo := 1.22787198) (yhi := 1.22787198)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.109) (q1 := 1.117) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.20691741) (B := 0.22129305) (X := 1.22787198) (rho := 0.04456306)
    (clo := 0.33624257) (chi := 0.33624473) (C := 0.33624365) (h := 0.04456414)
    (by norm_num) (by norm_num) oscBlock16 vbpBr16.1 vbpBr17.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i17 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    (0.00058152:ℝ) ≤ ∫ v in (vBP 1.117)..(vBP 1.124), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.30489887) (m := (0:ℤ)) (ylo := 1.30489887) (yhi := 1.30489887)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.117) (q1 := 1.124) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.22129304) (B := 0.23378751) (X := 1.30489887) (rho := 0.03937932)
    (clo := 0.26277524) (chi := 0.26277919) (C := 0.26277721) (h := 0.0393813)
    (by norm_num) (by norm_num) oscBlock17 vbpBr17.1 vbpBr18.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i18 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    (0.00043463:ℝ) ≤ ∫ v in (vBP 1.124)..(vBP 1.131), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.37632378) (m := (0:ℤ)) (ylo := 1.37632378) (yhi := 1.37632378)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.124) (q1 := 1.131) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.2337875) (B := 0.2462044) (X := 1.37632378) (rho := 0.03935153)
    (clo := 0.19324895) (chi := 0.19325568) (C := 0.19325231) (h := 0.0393549)
    (by norm_num) (by norm_num) oscBlock18 vbpBr18.1 vbpBr19.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i19 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    (0.00024621:ℝ) ≤ ∫ v in (vBP 1.131)..(vBP 1.138), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.44730663) (m := (0:ℤ)) (ylo := 1.44730663) (yhi := 1.44730663)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.131) (q1 := 1.138) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.24620439) (B := 0.25854468) (X := 1.44730663) (rho := 0.03932529)
    (clo := 0.12317589) (chi := 0.12318702) (C := 0.12318145) (h := 0.03933086)
    (by norm_num) (by norm_num) oscBlock19 vbpBr19.1 vbpBr20.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i20 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    (0.00003065:ℝ) ≤ ∫ v in (vBP 1.138)..(vBP 1.145), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.51785284) (m := (0:ℤ)) (ylo := 1.51785284) (yhi := 1.51785284)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.138) (q1 := 1.145) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.25854467) (B := 0.27080928) (X := 1.51785284) (rho := 0.03930053)
    (clo := 0.05291844) (chi := 0.05293634) (C := 0.05292739) (h := 0.03930948)
    (by norm_num) (by norm_num) oscBlock20 vbpBr20.1 vbpBr21.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i21 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00021621):ℝ) ≤ ∫ v in (vBP 1.145)..(vBP 1.152), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.58796775) (m := (0:ℤ)) (ylo := 0.01717142) (yhi := 0.01717143)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.145) (q1 := 1.152) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.27080927) (B := 0.28299913) (X := 1.58796775) (rho := 0.03927726)
    (clo := (-0.01717059)) (chi := (-0.01717057)) (C := (-0.01717058)) (h := 0.03927727)
    (by norm_num) (by norm_num) oscBlock21 vbpBr21.1 vbpBr22.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i22 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00049164):ℝ) ≤ ∫ v in (vBP 1.152)..(vBP 1.159), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.6576566) (m := (0:ℤ)) (ylo := 0.08686027) (yhi := 0.08686028)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.152) (q1 := 1.159) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.28299912) (B := 0.29511513) (X := 1.6576566) (rho := 0.0392554)
    (clo := (-0.0867511)) (chi := (-0.08675108)) (C := (-0.08675109)) (h := 0.03925541)
    (by norm_num) (by norm_num) oscBlock22 vbpBr22.1 vbpBr23.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i23 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00076626):ℝ) ≤ ∫ v in (vBP 1.159)..(vBP 1.166), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.72692456) (m := (0:ℤ)) (ylo := 0.15612823) (yhi := 0.15612824)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.159) (q1 := 1.166) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.29511512) (B := 0.30715818) (X := 1.72692456) (rho := 0.03923499)
    (clo := (-0.15549472)) (chi := (-0.1554947)) (C := (-0.15549471)) (h := 0.039235)
    (by norm_num) (by norm_num) oscBlock23 vbpBr23.1 vbpBr24.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i24 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00103159):ℝ) ≤ ∫ v in (vBP 1.166)..(vBP 1.173), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.79577666) (m := (0:ℤ)) (ylo := 0.22498033) (yhi := 0.22498034)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.166) (q1 := 1.173) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.30715817) (B := 0.31912914) (X := 1.79577666) (rho := 0.0392159)
    (clo := (-0.2230872)) (chi := (-0.22308718)) (C := (-0.22308719)) (h := 0.03921591)
    (by norm_num) (by norm_num) oscBlock24 vbpBr24.1 vbpBr25.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i25 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00128016):ℝ) ≤ ∫ v in (vBP 1.173)..(vBP 1.18), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.86421788) (m := (0:ℤ)) (ylo := 0.29342155) (yhi := 0.29342156)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.173) (q1 := 1.18) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.31912913) (B := 0.33102888) (X := 1.86421788) (rho := 0.03919819)
    (clo := (-0.28922924)) (chi := (-0.28922922)) (C := (-0.28922923)) (h := 0.0391982)
    (by norm_num) (by norm_num) oscBlock25 vbpBr25.1 vbpBr26.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i26 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00150559):ℝ) ≤ ∫ v in (vBP 1.18)..(vBP 1.187), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.93225311) (m := (0:ℤ)) (ylo := 0.36145678) (yhi := 0.36145679)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.18) (q1 := 1.187) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.33102887) (B := 0.34285824) (X := 1.93225311) (rho := 0.03918178)
    (clo := (-0.35363727)) (chi := (-0.35363725)) (C := (-0.35363726)) (h := 0.03918179)
    (by norm_num) (by norm_num) oscBlock26 vbpBr26.1 vbpBr27.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i27 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00170265):ℝ) ≤ ∫ v in (vBP 1.187)..(vBP 1.194), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.99988711) (m := (0:ℤ)) (ylo := 0.42909078) (yhi := 0.42909079)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.187) (q1 := 1.194) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.34285823) (B := 0.35461804) (X := 1.99988711) (rho := 0.03916663)
    (clo := (-0.41604419)) (chi := (-0.41604418)) (C := (-0.41604419)) (h := 0.03916664)
    (by norm_num) (by norm_num) oscBlock27 vbpBr27.1 vbpBr28.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i28 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.0018864):ℝ) ≤ ∫ v in (vBP 1.194)..(vBP 1.201), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.06712453) (m := (0:ℤ)) (ylo := 0.4963282) (yhi := 0.49632821)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.194) (q1 := 1.201) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.35461802) (B := 0.36630909) (X := 2.06712453) (rho := 0.03915275)
    (clo := (-0.47620002)) (chi := (-0.4762)) (C := (-0.47620001)) (h := 0.03915276)
    (by norm_num) (by norm_num) oscBlock28 vbpBr28.1 vbpBr29.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i29 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00201735):ℝ) ≤ ∫ v in (vBP 1.201)..(vBP 1.208), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.1339701) (m := (0:ℤ)) (ylo := 0.56317377) (yhi := 0.56317378)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.201) (q1 := 1.208) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.36630908) (B := 0.3779322) (X := 2.1339701) (rho := 0.03914006)
    (clo := (-0.53387252)) (chi := (-0.53387251)) (C := (-0.53387252)) (h := 0.03914007)
    (by norm_num) (by norm_num) oscBlock29 vbpBr29.1 vbpBr30.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i30 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00211083):ℝ) ≤ ∫ v in (vBP 1.208)..(vBP 1.215), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.20042831) (m := (0:ℤ)) (ylo := 0.62963198) (yhi := 0.62963199)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.208) (q1 := 1.215) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.37793219) (B := 0.38948816) (X := 2.20042831) (rho := 0.03912862)
    (clo := (-0.58884736)) (chi := (-0.58884734)) (C := (-0.58884735)) (h := 0.03912863)
    (by norm_num) (by norm_num) oscBlock30 vbpBr30.1 vbpBr31.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i31 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00249519):ℝ) ≤ ∫ v in (vBP 1.215)..(vBP 1.223), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.27120712) (m := (0:ℤ)) (ylo := 0.70041079) (yhi := 0.7004108)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.215) (q1 := 1.223) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.38948815) (B := 0.40261372) (X := 2.27120712) (rho := 0.04382178)
    (clo := (-0.64453184)) (chi := (-0.64453182)) (C := (-0.64453183)) (h := 0.04382179)
    (by norm_num) (by norm_num) oscBlock31 vbpBr31.1 vbpBr32.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i32 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00250931):ℝ) ≤ ∫ v in (vBP 1.223)..(vBP 1.231), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.34622796) (m := (0:ℤ)) (ylo := 0.77543163) (yhi := 0.77543164)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.223) (q1 := 1.231) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.40261371) (B := 0.4156537) (X := 2.34622796) (rho := 0.04378083)
    (clo := (-0.70002439)) (chi := (-0.70002437)) (C := (-0.70002438)) (h := 0.04378084)
    (by norm_num) (by norm_num) oscBlock32 vbpBr32.1 vbpBr33.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i33 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00246878):ℝ) ≤ ∫ v in (vBP 1.231)..(vBP 1.239), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.42076124) (m := (0:ℤ)) (ylo := 0.84996491) (yhi := 0.84996492)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.231) (q1 := 1.239) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.41565369) (B := 0.42860921) (X := 2.42076124) (rho := 0.04374172)
    (clo := (-0.75125726)) (chi := (-0.75125724)) (C := (-0.75125725)) (h := 0.04374173)
    (by norm_num) (by norm_num) oscBlock33 vbpBr33.1 vbpBr34.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i34 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00268074):ℝ) ≤ ∫ v in (vBP 1.239)..(vBP 1.248), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.49942251) (m := (0:ℤ)) (ylo := 0.92862618) (yhi := 0.92862619)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.239) (q1 := 1.248) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.4286092) (B := 0.44308455) (X := 2.49942251) (rho := 0.04831366)
    (clo := (-0.80079789)) (chi := (-0.80079786)) (C := (-0.80079788)) (h := 0.04831368)
    (by norm_num) (by norm_num) oscBlock34 vbpBr34.1 vbpBr35.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i35 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00277696):ℝ) ≤ ∫ v in (vBP 1.248)..(vBP 1.258), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.58670299) (m := (0:ℤ)) (ylo := 1.01590666) (yhi := 1.01590667)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.248) (q1 := 1.258) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.44308453) (B := 0.45904632) (X := 2.58670299) (rho := 0.05281336)
    (clo := (-0.84995861)) (chi := (-0.84995857)) (C := (-0.84995859)) (h := 0.05281338)
    (by norm_num) (by norm_num) oscBlock35 vbpBr35.1 vbpBr36.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i36 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00250798):ℝ) ≤ ∫ v in (vBP 1.258)..(vBP 1.268), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.67787048) (m := (0:ℤ)) (ylo := 1.10707415) (yhi := 1.10707416)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.258) (q1 := 1.268) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.45904631) (B := 0.47488172) (X := 2.67787048) (rho := 0.05269942)
    (clo := (-0.89439393)) (chi := (-0.89439384)) (C := (-0.89439389)) (h := 0.05269947)
    (by norm_num) (by norm_num) oscBlock36 vbpBr36.1 vbpBr37.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i37 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00259994):ℝ) ≤ ∫ v in (vBP 1.268)..(vBP 1.28), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.77731034) (m := (0:ℤ)) (ylo := 1.20651401) (yhi := 1.20651402)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.268) (q1 := 1.28) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.4748817) (B := 0.49372017) (X := 2.77731034) (rho := 0.06158064)
    (clo := (-0.9343799)) (chi := (-0.93437969)) (C := (-0.9343798)) (h := 0.06158075)
    (by norm_num) (by norm_num) oscBlock37 vbpBr37.1 vbpBr38.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i38 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.0022862):ℝ) ≤ ∫ v in (vBP 1.28)..(vBP 1.294), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.8937257) (m := (0:ℤ)) (ylo := 1.32292937) (yhi := 1.32292938)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.28) (q1 := 1.294) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.49372014) (B := 0.51547641) (X := 2.8937257) (rho := 0.07026367)
    (clo := (-0.96943849)) (chi := (-0.96943793)) (C := (-0.94958713)) (h := 0.05041287)
    (by norm_num) (by norm_num) oscBlock38 vbpBr38.1 vbpBr39.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i39 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00152768):ℝ) ≤ ∫ v in (vBP 1.294)..(vBP 1.308), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.01781104) (m := (0:ℤ)) (ylo := 1.44701471) (yhi := 1.44701472)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.294) (q1 := 1.308) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.51547638) (B := 0.53699853) (X := 3.01781104) (rho := 0.06993051)
    (clo := (-0.99235028)) (chi := (-0.99234881)) (C := (-0.96120915)) (h := 0.03879085)
    (by norm_num) (by norm_num) oscBlock39 vbpBr39.1 vbpBr40.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i40 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00099399):ℝ) ≤ ∫ v in (vBP 1.308)..(vBP 1.326), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.15793976) (m := (0:ℤ)) (ylo := 0.0163471) (yhi := 0.01634711)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.308) (q1 := 1.326) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.53699848) (B := 0.56433382) (X := 3.15793976) (rho := 0.08697972)
    (clo := (-0.99986639)) (chi := (-0.99986638)) (C := (-0.95644333)) (h := 0.04355667)
    (by norm_num) (by norm_num) oscBlock40 vbpBr40.1 vbpBr41.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i41 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    (0.00001966:ℝ) ≤ ∫ v in (vBP 1.326)..(vBP 1.345), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.31790751) (m := (0:ℤ)) (ylo := 0.17631485) (yhi := 0.17631486)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.326) (q1 := 1.345) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.56433374) (B := 0.59278808) (X := 3.31790751) (rho := 0.09062396)
    (clo := (-0.98449677)) (chi := (-0.98449675)) (C := (-0.9469364)) (h := 0.05306361)
    (by norm_num) (by norm_num) oscBlock41 vbpBr41.1 vbpBr42.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i42 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    (0.00089225:ℝ) ≤ ∫ v in (vBP 1.345)..(vBP 1.362), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.47149001) (m := (0:ℤ)) (ylo := 0.32989735) (yhi := 0.32989736)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.345) (q1 := 1.362) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.59278796) (B := 0.6179085) (X := 3.47149001) (rho := 0.08148388)
    (clo := (-0.94607561)) (chi := (-0.94607559)) (C := (-0.93229586)) (h := 0.06770415)
    (by norm_num) (by norm_num) oscBlock42 vbpBr42.1 vbpBr43.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i43 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    (0.00103836:ℝ) ≤ ∫ v in (vBP 1.362)..(vBP 1.376), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.60212117) (m := (0:ℤ)) (ylo := 0.46052851) (yhi := 0.46052852)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.362) (q1 := 1.376) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.61790831) (B := 0.6383616) (X := 3.60212117) (rho := 0.06845804)
    (clo := (-0.89581775)) (chi := (-0.89581773)) (C := (-0.89581774)) (h := 0.06845805)
    (by norm_num) (by norm_num) oscBlock43 vbpBr43.1 vbpBr44.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i44 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    (0.00114237:ℝ) ≤ ∫ v in (vBP 1.376)..(vBP 1.39), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.71881147) (m := (0:ℤ)) (ylo := 0.57721881) (yhi := 0.57721882)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.376) (q1 := 1.39) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.63836133) (B := 0.65860767) (X := 3.71881147) (rho := 0.06818264)
    (clo := (-0.83798358)) (chi := (-0.83798356)) (C := (-0.83798357)) (h := 0.06818265)
    (by norm_num) (by norm_num) oscBlock44 vbpBr44.1 vbpBr45.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i45 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    (0.00112001:ℝ) ≤ ∫ v in (vBP 1.39)..(vBP 1.404), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.83432644) (m := (0:ℤ)) (ylo := 0.69273378) (yhi := 0.69273379)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.39) (q1 := 1.404) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.65860729) (B := 0.67865086) (X := 3.83432644) (rho := 0.06791602)
    (clo := (-0.76950299)) (chi := (-0.76950297)) (C := (-0.76950298)) (h := 0.06791603)
    (by norm_num) (by norm_num) oscBlock45 vbpBr45.1 vbpBr46.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i46 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    (0.00099828:ℝ) ≤ ∫ v in (vBP 1.404)..(vBP 1.418), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.94868945) (m := (0:ℤ)) (ylo := 0.80709679) (yhi := 0.8070968)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.404) (q1 := 1.418) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.67865033) (B := 0.69849519) (X := 3.94868945) (rho := 0.0676579)
    (clo := (-0.69159832)) (chi := (-0.69159827)) (C := (-0.6915983)) (h := 0.06765793)
    (by norm_num) (by norm_num) oscBlock46 vbpBr46.1 vbpBr47.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i47 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    (0.0008094:ℝ) ≤ ∫ v in (vBP 1.418)..(vBP 1.432), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.06192332) (m := (0:ℤ)) (ylo := 0.92033066) (yhi := 0.92033067)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.418) (q1 := 1.432) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.69849446) (B := 0.7181446) (X := 4.06192332) (rho := 0.06740814)
    (clo := (-0.60555717)) (chi := (-0.60555704)) (C := (-0.60555711)) (h := 0.06740821)
    (by norm_num) (by norm_num) oscBlock47 vbpBr47.1 vbpBr48.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i48 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    (0.00058671:ℝ) ≤ ∫ v in (vBP 1.432)..(vBP 1.446), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.17405007) (m := (0:ℤ)) (ylo := 1.03245741) (yhi := 1.03245742)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.432) (q1 := 1.446) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.7181436) (B := 0.73760286) (X := 4.17405007) (rho := 0.06716638)
    (clo := (-0.51271094)) (chi := (-0.51271054)) (C := (-0.51271074)) (h := 0.06716658)
    (by norm_num) (by norm_num) oscBlock48 vbpBr48.1 vbpBr49.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i49 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    (0.00037755:ℝ) ≤ ∫ v in (vBP 1.446)..(vBP 1.462), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.29296266) (m := (0:ℤ)) (ylo := 1.15137) (yhi := 1.15137001)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.446) (q1 := 1.462) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.73760153) (B := 0.75961158) (X := 4.29296266) (rho := 0.07480393)
    (clo := (-0.40723769)) (chi := (-0.40723655)) (C := (-0.40723712)) (h := 0.0748045)
    (by norm_num) (by norm_num) oscBlock49 vbpBr49.1 vbpBr50.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i50 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00027062):ℝ) ≤ ∫ v in (vBP 1.462)..(vBP 1.478), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.4184789) (m := (0:ℤ)) (ylo := 1.27688624) (yhi := 1.27688625)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.462) (q1 := 1.478) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.75960973) (B := 0.78138081) (X := 4.4184789) (rho := 0.07446077)
    (clo := (-0.28969999)) (chi := (-0.28969679)) (C := (-0.28969839)) (h := 0.07446237)
    (by norm_num) (by norm_num) oscBlock50 vbpBr50.1 vbpBr51.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i51 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00033589):ℝ) ≤ ∫ v in (vBP 1.478)..(vBP 1.495), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.54648385) (m := (0:ℤ)) (ylo := 1.40489119) (yhi := 1.4048912)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.478) (q1 := 1.495) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.7813783) (B := 0.80425401) (X := 4.54648385) (rho := 0.07797672)
    (clo := (-0.16515324)) (chi := (-0.16514497)) (C := (-0.16514911)) (h := 0.07798086)
    (by norm_num) (by norm_num) oscBlock51 vbpBr51.1 vbpBr52.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i52 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00018398):ℝ) ≤ ∫ v in (vBP 1.495)..(vBP 1.512), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.67690151) (m := (0:ℤ)) (ylo := 1.53530885) (yhi := 1.53530886)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.495) (q1 := 1.512) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.80425056) (B := 0.82686872) (X := 4.67690151) (rho := 0.07759364)
    (clo := (-0.03549973)) (chi := (-0.03547966)) (C := (-0.0354897)) (h := 0.07760368)
    (by norm_num) (by norm_num) oscBlock52 vbpBr52.1 vbpBr53.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i53 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00036716):ℝ) ≤ ∫ v in (vBP 1.512)..(vBP 1.531), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.8133694) (m := (0:ℤ)) (ylo := 0.10098041) (yhi := 0.10098042)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.512) (q1 := 1.531) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.82686405) (B := 0.85184522) (X := 4.8133694) (rho := 0.08474063)
    (clo := 0.10080888) (chi := 0.1008089) (C := 0.10080889) (h := 0.08474064)
    (by norm_num) (by norm_num) oscBlock53 vbpBr53.1 vbpBr54.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i54 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00058945):ℝ) ≤ ∫ v in (vBP 1.531)..(vBP 1.55), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.95570403) (m := (0:ℤ)) (ylo := 0.24331504) (yhi := 0.24331505)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.531) (q1 := 1.55) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.85183877) (B := 0.87651393) (X := 4.95570403) (rho := 0.08425108)
    (clo := 0.24092133) (chi := 0.24092135) (C := 0.24092134) (h := 0.08425109)
    (by norm_num) (by norm_num) oscBlock54 vbpBr54.1 vbpBr55.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i55 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00081386):ℝ) ≤ ∫ v in (vBP 1.55)..(vBP 1.57), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.09995765) (m := (0:ℤ)) (ylo := 0.38756866) (yhi := 0.38756867)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.55) (q1 := 1.57) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.87650515) (B := 0.90215678) (X := 5.09995765) (rho := 0.08744384)
    (clo := 0.37793852) (chi := 0.37793854) (C := 0.37793853) (h := 0.08744385)
    (by norm_num) (by norm_num) oscBlock55 vbpBr55.1 vbpBr56.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i56 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00095242):ℝ) ≤ ∫ v in (vBP 1.57)..(vBP 1.59), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.24606232) (m := (0:ℤ)) (ylo := 0.53367333) (yhi := 0.53367334)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.57) (q1 := 1.59) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.90214481) (B := 0.92747548) (X := 5.24606232) (rho := 0.0869217)
    (clo := 0.50869929) (chi := 0.50869931) (C := 0.5086993) (h := 0.08692171)
    (by norm_num) (by norm_num) oscBlock56 vbpBr56.1 vbpBr57.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i57 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00104476):ℝ) ≤ ∫ v in (vBP 1.59)..(vBP 1.61), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.39032916) (m := (0:ℤ)) (ylo := 0.67794017) (yhi := 0.67794018)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.59) (q1 := 1.61) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.92745939) (B := 0.95247825) (X := 5.39032916) (rho := 0.08642079)
    (clo := 0.62719002) (chi := 0.62719004) (C := 0.62719003) (h := 0.0864208)
    (by norm_num) (by norm_num) oscBlock57 vbpBr57.1 vbpBr58.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i58 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00123732):ℝ) ≤ ∫ v in (vBP 1.61)..(vBP 1.632), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.5398557) (m := (0:ℤ)) (ylo := 0.82746671) (yhi := 0.82746672)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.61) (q1 := 1.632) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.95245689) (B := 0.97962584) (X := 5.5398557) (rho := 0.09299289)
    (clo := 0.73621934) (chi := 0.73621936) (C := 0.73621935) (h := 0.0929929)
    (by norm_num) (by norm_num) oscBlock58 vbpBr58.1 vbpBr59.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i59 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00140225):ℝ) ≤ ∫ v in (vBP 1.632)..(vBP 1.656), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.70141664) (m := (0:ℤ)) (ylo := 0.98902765) (yhi := 0.98902766)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.632) (q1 := 1.656) (t0 := 5.71875) (t1 := 5.75)
    (A := 0.97959707) (B := 1.00882827) (X := 5.70141664) (rho := 0.09934592)
    (clo := 0.83549206) (chi := 0.8354921) (C := 0.83549208) (h := 0.09934594)
    (by norm_num) (by norm_num) oscBlock59 vbpBr59.1 vbpBr60.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i60 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00135601):ℝ) ≤ ∫ v in (vBP 1.656)..(vBP 1.68), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.86764063) (m := (0:ℤ)) (ylo := 1.15525164) (yhi := 1.15525165)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.656) (q1 := 1.68) (t0 := 5.71875) (t1 := 5.75)
    (A := 1.00878907) (B := 1.03761196) (X := 5.86764063) (rho := 0.09862815)
    (clo := 0.91489657) (chi := 0.9148967) (C := 0.90813421) (h := 0.09186579)
    (by norm_num) (by norm_num) oscBlock60 vbpBr60.1 vbpBr61.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i61 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00122808):ℝ) ≤ ∫ v in (vBP 1.68)..(vBP 1.704), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.03149001) (m := (0:ℤ)) (ylo := 1.31910102) (yhi := 1.31910103)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.68) (q1 := 1.704) (t0 := 5.71875) (t1 := 5.75)
    (A := 1.03755935) (B := 1.06598913) (X := 6.03149001) (rho := 0.0979475)
    (clo := 0.96849159) (chi := 0.96849213) (C := 0.93527204) (h := 0.06472796)
    (by norm_num) (by norm_num) oscBlock61 vbpBr61.1 vbpBr62.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i62 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00137159):ℝ) ≤ ∫ v in (vBP 1.704)..(vBP 1.734), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.21297053) (m := (0:ℤ)) (ylo := 1.50058154) (yhi := 1.50058155)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.704) (q1 := 1.734) (t0 := 5.71875) (t1 := 5.75)
    (A := 1.06591948) (B := 1.10090679) (X := 6.21297053) (rho := 0.11724352)
    (clo := 0.99753592) (chi := 0.99753811) (C := 0.9401462) (h := 0.0598538)
    (by norm_num) (by norm_num) oscBlock62 vbpBr62.1 vbpBr63.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i63 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00129873):ℝ) ≤ ∫ v in (vBP 1.734)..(vBP 1.766), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.41793187) (m := (1:ℤ)) (ylo := 0.13474656) (yhi := 0.13474657)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.734) (q1 := 1.766) (t0 := 5.71875) (t1 := 5.75)
    (A := 1.10080961) (B := 1.13749718) (X := 6.41793187) (rho := 0.12267693)
    (clo := 0.9909354) (chi := 0.99093541) (C := 0.93412923) (h := 0.06587077)
    (by norm_num) (by norm_num) oscBlock63 vbpBr63.1 vbpBr64.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i64 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00107612):ℝ) ≤ ∫ v in (vBP 1.766)..(vBP 1.796), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.61936756) (m := (1:ℤ)) (ylo := 0.33618225) (yhi := 0.33618226)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.766) (q1 := 1.796) (t0 := 5.71875) (t1 := 5.75)
    (A := 1.1373613) (B := 1.17120873) (X := 6.61936756) (rho := 0.11508265)
    (clo := 0.94402095) (chi := 0.94402097) (C := 0.91446915) (h := 0.08553085)
    (by norm_num) (by norm_num) oscBlock64 vbpBr64.1 vbpBr65.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i65 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00103495):ℝ) ≤ ∫ v in (vBP 1.796)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.81726037) (m := (1:ℤ)) (ylo := 0.53407506) (yhi := 0.53407507)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.796) (q1 := 1.828) (t0 := 5.71875) (t1 := 5.75)
    (A := 1.1710258) (B := 1.20655947) (X := 6.81726037) (rho := 0.12045659)
    (clo := 0.86073982) (chi := 0.86073984) (C := 0.86073983) (h := 0.1204566)
    (by norm_num) (by norm_num) oscBlock65 vbpBr65.1 vbpBr66.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i66 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00083187):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.86), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.01805219) (m := (1:ℤ)) (ylo := 0.73486688) (yhi := 0.73486689)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.828) (q1 := 1.86) (t0 := 5.71875) (t1 := 5.75)
    (A := 1.20631244) (B := 1.24130524) (X := 7.01805219) (rho := 0.11945295)
    (clo := 0.74192) (chi := 0.74192003) (C := 0.74192001) (h := 0.11945297)
    (by norm_num) (by norm_num) oscBlock66 vbpBr66.1 vbpBr67.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i67 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00057368):ℝ) ≤ ∫ v in (vBP 1.86)..(vBP 1.89), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.20929922) (m := (1:ℤ)) (ylo := 0.92611391) (yhi := 0.92611392)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.86) (q1 := 1.89) (t0 := 5.71875) (t1 := 5.75)
    (A := 1.24097685) (B := 1.27334993) (X := 7.20929922) (rho := 0.11246288)
    (clo := 0.60094461) (chi := 0.60094476) (C := 0.60094468) (h := 0.11246296)
    (by norm_num) (by norm_num) oscBlock67 vbpBr67.1 vbpBr68.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i68 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00043302):ℝ) ≤ ∫ v in (vBP 1.89)..(vBP 1.922), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.39736131) (m := (1:ℤ)) (ylo := 1.114176) (yhi := 1.11417601)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.89) (q1 := 1.922) (t0 := 5.71875) (t1 := 5.75)
    (A := 1.27292668) (B := 1.30698664) (X := 7.39736131) (rho := 0.11781188)
    (clo := 0.44091719) (chi := 0.44091802) (C := 0.4409176) (h := 0.1178123)
    (by norm_num) (by norm_num) oscBlock68 vbpBr68.1 vbpBr69.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i69 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00037853):ℝ) ≤ ∫ v in (vBP 1.922)..(vBP 1.969), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.63241553) (m := (1:ℤ)) (ylo := 1.34923022) (yhi := 1.34923023)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.922) (q1 := 1.969) (t0 := 5.71875) (t1 := 5.75)
    (A := 1.30643896) (B := 1.35541448) (X := 7.63241553) (rho := 0.16121774)
    (clo := 0.21975762) (chi := 0.21976315) (C := 0.21976038) (h := 0.16122051)
    (by norm_num) (by norm_num) oscBlock69 vbpBr69.1 vbpBr70.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i70 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00018609):ℝ) ≤ ∫ v in (vBP 1.969)..(vBP 2.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 7.9062702) (m := (1:ℤ)) (ylo := 0.05228856) (yhi := 0.05228857)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.969) (q1 := 2.016) (t0 := 5.71875) (t1 := 5.75)
    (A := 1.35463226) (B := 1.4027369) (X := 7.9062702) (rho := 0.15946698)
    (clo := (-0.05226475)) (chi := (-0.05226473)) (C := (-0.05226474)) (h := 0.15946699)
    (by norm_num) (by norm_num) oscBlock70 vbpBr70.1 vbpBr71.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i71 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00036719):ℝ) ≤ ∫ v in (vBP 2.016)..(vBP 2.062), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.17094523) (m := (1:ℤ)) (ylo := 0.31696359) (yhi := 0.3169636)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.016) (q1 := 2.062) (t0 := 5.71875) (t1 := 5.75)
    (A := 1.40164597) (B := 1.44803958) (X := 8.17094523) (rho := 0.15528236)
    (clo := (-0.31168286)) (chi := (-0.31168284)) (C := (-0.31168285)) (h := 0.15528237)
    (by norm_num) (by norm_num) oscBlock71 vbpBr71.1 vbpBr72.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB19i72 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.00031955):ℝ) ≤ ∫ v in (vBP 2.062)..(vBP 2.094), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.38835921) (m := (1:ℤ)) (ylo := 0.53437757) (yhi := 0.53437758)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.062) (q1 := 2.094) (t0 := 5.71875) (t1 := 5.75)
    (A := 1.44655973) (B := 1.47899217) (X := 8.38835921) (rho := 0.11584578)
    (clo := (-0.5093055)) (chi := (-0.50930548)) (C := (-0.50930549)) (h := 0.11584579)
    (by norm_num) (by norm_num) oscBlock72 vbpBr72.1 vbpBr73.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

/-- Lower bound for the oscillatory integral `∫₀^∞ err(v) cos(tv) dv` on the band
`5.71875 ≤ t ≤ 5.75`. -/
theorem oscBandLower19 {t : ℝ} (ht0 : (5.71875:ℝ) ≤ t) (ht1 : t ≤ 5.75) :
    ((-0.11335088):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosB19i0 ht0 ht1)
    (cosB19i1 ht0 ht1))
    (cosB19i2 ht0 ht1))
    (cosB19i3 ht0 ht1))
    (cosB19i4 ht0 ht1))
    (cosB19i5 ht0 ht1))
    (cosB19i6 ht0 ht1))
    (cosB19i7 ht0 ht1))
    (cosB19i8 ht0 ht1))
    (cosB19i9 ht0 ht1))
    (cosB19i10 ht0 ht1))
    (cosB19i11 ht0 ht1))
    (cosB19i12 ht0 ht1))
    (cosB19i13 ht0 ht1))
    (cosB19i14 ht0 ht1))
    (cosB19i15 ht0 ht1))
    (cosB19i16 ht0 ht1))
    (cosB19i17 ht0 ht1))
    (cosB19i18 ht0 ht1))
    (cosB19i19 ht0 ht1))
    (cosB19i20 ht0 ht1))
    (cosB19i21 ht0 ht1))
    (cosB19i22 ht0 ht1))
    (cosB19i23 ht0 ht1))
    (cosB19i24 ht0 ht1))
    (cosB19i25 ht0 ht1))
    (cosB19i26 ht0 ht1))
    (cosB19i27 ht0 ht1))
    (cosB19i28 ht0 ht1))
    (cosB19i29 ht0 ht1))
    (cosB19i30 ht0 ht1))
    (cosB19i31 ht0 ht1))
    (cosB19i32 ht0 ht1))
    (cosB19i33 ht0 ht1))
    (cosB19i34 ht0 ht1))
    (cosB19i35 ht0 ht1))
    (cosB19i36 ht0 ht1))
    (cosB19i37 ht0 ht1))
    (cosB19i38 ht0 ht1))
    (cosB19i39 ht0 ht1))
    (cosB19i40 ht0 ht1))
    (cosB19i41 ht0 ht1))
    (cosB19i42 ht0 ht1))
    (cosB19i43 ht0 ht1))
    (cosB19i44 ht0 ht1))
    (cosB19i45 ht0 ht1))
    (cosB19i46 ht0 ht1))
    (cosB19i47 ht0 ht1))
    (cosB19i48 ht0 ht1))
    (cosB19i49 ht0 ht1))
    (cosB19i50 ht0 ht1))
    (cosB19i51 ht0 ht1))
    (cosB19i52 ht0 ht1))
    (cosB19i53 ht0 ht1))
    (cosB19i54 ht0 ht1))
    (cosB19i55 ht0 ht1))
    (cosB19i56 ht0 ht1))
    (cosB19i57 ht0 ht1))
    (cosB19i58 ht0 ht1))
    (cosB19i59 ht0 ht1))
    (cosB19i60 ht0 ht1))
    (cosB19i61 ht0 ht1))
    (cosB19i62 ht0 ht1))
    (cosB19i63 ht0 ht1))
    (cosB19i64 ht0 ht1))
    (cosB19i65 ht0 ht1))
    (cosB19i66 ht0 ht1))
    (cosB19i67 ht0 ht1))
    (cosB19i68 ht0 ht1))
    (cosB19i69 ht0 ht1))
    (cosB19i70 ht0 ht1))
    (cosB19i71 ht0 ht1))
    (cosB19i72 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 2.094) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 2.094) (S := 0.013709)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_cut
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
