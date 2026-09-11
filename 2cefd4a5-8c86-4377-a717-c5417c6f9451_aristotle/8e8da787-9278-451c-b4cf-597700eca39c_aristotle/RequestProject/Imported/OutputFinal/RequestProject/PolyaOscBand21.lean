/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscTail

/-!
# Oscillatory lower bound on the band `5.65625 ≤ t ≤ 5.6875`

On each of the 73 blocks the factor `cos(tv)` is bracketed by a rational constant
`C` up to a rational error `h`; the signed contribution `min(C·P₀, C·P₁) - h·S` is
then summed, and the unresolved tail beyond `q = 2.094` is estimated in absolute
value.  The result is the bound `∫₀^∞ err(v) cos(tv) dv ≥ -0.11133317`.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosB21i0 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00641868):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.0038), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.02157155) (m := (0:ℤ)) (ylo := 0.02157155) (yhi := 0.02157155)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1) (q1 := 1.0038) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.0) (B := 0.0075856) (X := 0.02157155) (rho := 0.02157156)
    (clo := 0.99976734) (chi := 0.99976735) (C := 0.98909789) (h := 0.01090211)
    (by norm_num) (by norm_num) oscBlock0 vbpBr0.1 vbpBr1.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i1 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00625872):ℝ) ≤ ∫ v in (vBP 1.0038)..(vBP 1.0078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.06564339) (m := (0:ℤ)) (ylo := 0.06564339) (yhi := 0.06564339)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0038) (q1 := 1.0078) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.00758559) (B := 0.01553948) (X := 0.06564339) (rho := 0.02273741)
    (clo := 0.99784624) (chi := 0.99784625) (C := 0.98755441) (h := 0.01244559)
    (by norm_num) (by norm_num) oscBlock1 vbpBr1.1 vbpBr2.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i2 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.0057677):ℝ) ≤ ∫ v in (vBP 1.0078)..(vBP 1.0118), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.11066719) (m := (0:ℤ)) (ylo := 0.11066719) (yhi := 0.11066719)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0078) (q1 := 1.0118) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.01553947) (B := 0.02346185) (X := 0.11066719) (rho := 0.02277209)
    (clo := 0.99388263) (chi := 0.99388264) (C := 0.98555527) (h := 0.01444473)
    (by norm_num) (by norm_num) oscBlock2 vbpBr2.1 vbpBr3.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i3 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00554846):ℝ) ≤ ∫ v in (vBP 1.0118)..(vBP 1.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.15663269) (m := (0:ℤ)) (ylo := 0.15663269) (yhi := 0.15663269)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0118) (q1 := 1.016) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.02346184) (B := 0.0317467) (X := 0.15663269) (rho := 0.02392668)
    (clo := 0.98775815) (chi := 0.98775816) (C := 0.98191573) (h := 0.01808427)
    (by norm_num) (by norm_num) oscBlock3 vbpBr3.1 vbpBr4.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i4 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00539232):ℝ) ≤ ∫ v in (vBP 1.016)..(vBP 1.0205), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.20519836) (m := (0:ℤ)) (ylo := 0.20519836) (yhi := 0.20519836)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.016) (q1 := 1.0205) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.03174669) (B := 0.04058541) (X := 0.20519836) (rho := 0.02563117)
    (clo := 0.97902058) (chi := 0.97902059) (C := 0.9766947) (h := 0.0233053)
    (by norm_num) (by norm_num) oscBlock4 vbpBr4.1 vbpBr5.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i5 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.0048183):ℝ) ≤ ∫ v in (vBP 1.0205)..(vBP 1.025), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.25521983) (m := (0:ℤ)) (ylo := 0.25521983) (yhi := 0.25521983)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0205) (q1 := 1.025) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.0405854) (B := 0.04938523) (X := 0.25521983) (rho := 0.02565868)
    (clo := 0.96760782) (chi := 0.96760783) (C := 0.96760782) (h := 0.02565869)
    (by norm_num) (by norm_num) oscBlock5 vbpBr5.1 vbpBr6.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i6 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00470199):ℝ) ≤ ∫ v in (vBP 1.025)..(vBP 1.03), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.30778327) (m := (0:ℤ)) (ylo := 0.30778327) (yhi := 0.30778327)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.025) (q1 := 1.03) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.04938522) (B := 0.05911761) (X := 0.30778327) (rho := 0.02844814)
    (clo := 0.95300746) (chi := 0.95300747) (C := 0.95300746) (h := 0.02844815)
    (by norm_num) (by norm_num) oscBlock6 vbpBr6.1 vbpBr7.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i7 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00440775):ℝ) ≤ ∫ v in (vBP 1.03)..(vBP 1.0355), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.36559701) (m := (0:ℤ)) (ylo := 0.36559701) (yhi := 0.36559701)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.03) (q1 := 1.0355) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.0591176) (B := 0.06976881) (X := 0.36559701) (rho := 0.03121311)
    (clo := 0.93391049) (chi := 0.9339105) (C := 0.93391049) (h := 0.03121312)
    (by norm_num) (by norm_num) oscBlock7 vbpBr7.1 vbpBr8.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i8 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00395525):ℝ) ≤ ∫ v in (vBP 1.0355)..(vBP 1.0415), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.42857992) (m := (0:ℤ)) (ylo := 0.42857992) (yhi := 0.42857992)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0355) (q1 := 1.0415) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.0697688) (B := 0.08132397) (X := 0.42857992) (rho := 0.03395017)
    (clo := 0.90955682) (chi := 0.90955683) (C := 0.90955682) (h := 0.03395018)
    (by norm_num) (by norm_num) oscBlock8 vbpBr8.1 vbpBr9.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i9 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00336958):ℝ) ≤ ∫ v in (vBP 1.0415)..(vBP 1.048), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.49664474) (m := (0:ℤ)) (ylo := 0.49664474) (yhi := 0.49664474)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0415) (q1 := 1.048) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.08132396) (B := 0.09376718) (X := 0.49664474) (rho := 0.03665611)
    (clo := 0.87918621) (chi := 0.87918622) (C := 0.87918621) (h := 0.03665612)
    (by norm_num) (by norm_num) oscBlock9 vbpBr9.1 vbpBr10.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i10 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00270147):ℝ) ≤ ∫ v in (vBP 1.048)..(vBP 1.055), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.5696984) (m := (0:ℤ)) (ylo := 0.5696984) (yhi := 0.5696984)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.048) (q1 := 1.055) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.09376717) (B := 0.10708154) (X := 0.5696984) (rho := 0.03932787)
    (clo := 0.84206368) (chi := 0.8420637) (C := 0.84206369) (h := 0.03932788)
    (by norm_num) (by norm_num) oscBlock10 vbpBr10.1 vbpBr11.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i11 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00224684):ℝ) ≤ ∫ v in (vBP 1.055)..(vBP 1.064), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.65566626) (m := (0:ℤ)) (ylo := 0.65566626) (yhi := 0.65566626)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.055) (q1 := 1.064) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.10708153) (B := 0.12407079) (X := 0.65566626) (rho := 0.04998637)
    (clo := 0.79264189) (chi := 0.7926419) (C := 0.79264189) (h := 0.04998638)
    (by norm_num) (by norm_num) oscBlock11 vbpBr11.1 vbpBr12.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i12 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.0014669):ℝ) ≤ ∫ v in (vBP 1.064)..(vBP 1.078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.77806143) (m := (0:ℤ)) (ylo := 0.77806143) (yhi := 0.77806143)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.064) (q1 := 1.078) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.12407078) (B := 0.15021495) (X := 0.77806143) (rho := 0.0762861)
    (clo := 0.71227555) (chi := 0.71227559) (C := 0.71227557) (h := 0.07628612)
    (by norm_num) (by norm_num) oscBlock12 vbpBr12.1 vbpBr13.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i13 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    (0.00020385:ℝ) ≤ ∫ v in (vBP 1.078)..(vBP 1.09), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.91496229) (m := (0:ℤ)) (ylo := 0.91496229) (yhi := 0.91496229)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.078) (q1 := 1.09) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.15021494) (B := 0.1723554) (X := 0.91496229) (rho := 0.06530906)
    (clo := 0.60982046) (chi := 0.60982058) (C := 0.60982052) (h := 0.06530912)
    (by norm_num) (by norm_num) oscBlock13 vbpBr13.1 vbpBr14.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i14 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    (0.00078196:ℝ) ≤ ∫ v in (vBP 1.09)..(vBP 1.1), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.02951923) (m := (0:ℤ)) (ylo := 1.02951923) (yhi := 1.02951923)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.09) (q1 := 1.1) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.17235539) (B := 0.19062036) (X := 1.02951923) (rho := 0.05463408)
    (clo := 0.51523094) (chi := 0.51523132) (C := 0.51523113) (h := 0.05463427)
    (by norm_num) (by norm_num) oscBlock14 vbpBr14.1 vbpBr15.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i15 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    (0.00089581:ℝ) ≤ ∫ v in (vBP 1.1)..(vBP 1.109), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.12751959) (m := (0:ℤ)) (ylo := 1.12751959) (yhi := 1.12751959)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.1) (q1 := 1.109) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.19062035) (B := 0.20691742) (X := 1.12751959) (rho := 0.04932325)
    (clo := 0.42890179) (chi := 0.42890272) (C := 0.42890225) (h := 0.04932372)
    (by norm_num) (by norm_num) oscBlock15 vbpBr15.1 vbpBr16.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i16 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    (0.00079521:ℝ) ≤ ∫ v in (vBP 1.109)..(vBP 1.117), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.21449041) (m := (0:ℤ)) (ylo := 1.21449041) (yhi := 1.21449041)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.109) (q1 := 1.117) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.20691741) (B := 0.22129305) (X := 1.21449041) (rho := 0.04411383)
    (clo := 0.34881453) (chi := 0.34881646) (C := 0.34881549) (h := 0.0441148)
    (by norm_num) (by norm_num) oscBlock16 vbpBr16.1 vbpBr17.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i17 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    (0.00061951:ℝ) ≤ ∫ v in (vBP 1.117)..(vBP 1.124), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.29067761) (m := (0:ℤ)) (ylo := 1.29067761) (yhi := 1.29067761)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.117) (q1 := 1.124) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.22129304) (B := 0.23378751) (X := 1.29067761) (rho := 0.03898887)
    (clo := 0.27646969) (chi := 0.27647324) (C := 0.27647146) (h := 0.03899065)
    (by norm_num) (by norm_num) oscBlock17 vbpBr17.1 vbpBr18.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i18 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    (0.00047918:ℝ) ≤ ∫ v in (vBP 1.124)..(vBP 1.131), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.36132403) (m := (0:ℤ)) (ylo := 1.36132403) (yhi := 1.36132403)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.124) (q1 := 1.131) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.2337875) (B := 0.2462044) (X := 1.36132403) (rho := 0.0389635)
    (clo := 0.20794367) (chi := 0.20794971) (C := 0.20794669) (h := 0.03896652)
    (by norm_num) (by norm_num) oscBlock18 vbpBr18.1 vbpBr19.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i19 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    (0.00029684:ℝ) ≤ ∫ v in (vBP 1.131)..(vBP 1.138), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.43153322) (m := (0:ℤ)) (ylo := 1.43153322) (yhi := 1.43153322)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.131) (q1 := 1.138) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.24620439) (B := 0.25854468) (X := 1.43153322) (rho := 0.03893966)
    (clo := 0.13881324) (chi := 0.13882321) (C := 0.13881822) (h := 0.03894465)
    (by norm_num) (by norm_num) oscBlock19 vbpBr19.1 vbpBr20.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i20 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    (0.00008731:ℝ) ≤ ∫ v in (vBP 1.138)..(vBP 1.145), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.50131053) (m := (0:ℤ)) (ylo := 1.50131053) (yhi := 1.50131053)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.138) (q1 := 1.145) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.25854467) (B := 0.27080928) (X := 1.50131053) (rho := 0.03891726)
    (clo := 0.06942962) (chi := 0.06944566) (C := 0.06943764) (h := 0.03892528)
    (by norm_num) (by norm_num) oscBlock20 vbpBr20.1 vbpBr21.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i21 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00014852):ℝ) ≤ ∫ v in (vBP 1.145)..(vBP 1.152), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.57066124) (m := (0:ℤ)) (ylo := 1.57066124) (yhi := 1.57066124)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.145) (q1 := 1.152) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.27080927) (B := 0.28299913) (X := 1.57066124) (rho := 0.03889632)
    (clo := 0.00013462) (chi := 0.00015981) (C := 0.00014721) (h := 0.03890892)
    (by norm_num) (by norm_num) oscBlock21 vbpBr21.1 vbpBr22.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i22 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00041989):ℝ) ≤ ∫ v in (vBP 1.152)..(vBP 1.159), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.63959053) (m := (0:ℤ)) (ylo := 0.0687942) (yhi := 0.06879421)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.152) (q1 := 1.159) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.28299912) (B := 0.29511513) (X := 1.63959053) (rho := 0.03887678)
    (clo := (-0.06873996)) (chi := (-0.06873994)) (C := (-0.06873995)) (h := 0.03887679)
    (by norm_num) (by norm_num) oscBlock22 vbpBr22.1 vbpBr23.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i23 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00069152):ℝ) ≤ ∫ v in (vBP 1.159)..(vBP 1.166), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.70810352) (m := (0:ℤ)) (ylo := 0.13730719) (yhi := 0.1373072)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.159) (q1 := 1.166) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.29511512) (B := 0.30715818) (X := 1.70810352) (rho := 0.03885864)
    (clo := (-0.13687616)) (chi := (-0.13687614)) (C := (-0.13687615)) (h := 0.03885865)
    (by norm_num) (by norm_num) oscBlock23 vbpBr23.1 vbpBr24.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i24 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00095492):ℝ) ≤ ∫ v in (vBP 1.166)..(vBP 1.173), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.77620519) (m := (0:ℤ)) (ylo := 0.20540886) (yhi := 0.20540887)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.166) (q1 := 1.173) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.30715817) (B := 0.31912914) (X := 1.77620519) (rho := 0.03884181)
    (clo := (-0.20396746)) (chi := (-0.20396744)) (C := (-0.20396745)) (h := 0.03884182)
    (by norm_num) (by norm_num) oscBlock24 vbpBr24.1 vbpBr25.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i25 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00120267):ℝ) ≤ ∫ v in (vBP 1.173)..(vBP 1.18), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.84390044) (m := (0:ℤ)) (ylo := 0.27310411) (yhi := 0.27310412)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.173) (q1 := 1.18) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.31912913) (B := 0.33102888) (X := 1.84390044) (rho := 0.03882632)
    (clo := (-0.26972181)) (chi := (-0.26972179)) (C := (-0.2697218)) (h := 0.03882633)
    (by norm_num) (by norm_num) oscBlock25 vbpBr25.1 vbpBr26.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i26 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00142838):ℝ) ≤ ∫ v in (vBP 1.18)..(vBP 1.187), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.91119414) (m := (0:ℤ)) (ylo := 0.34039781) (yhi := 0.34039782)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.18) (q1 := 1.187) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.33102887) (B := 0.34285824) (X := 1.91119414) (rho := 0.03881211)
    (clo := (-0.33386212)) (chi := (-0.3338621)) (C := (-0.33386211)) (h := 0.03881212)
    (by norm_num) (by norm_num) oscBlock26 vbpBr26.1 vbpBr27.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i27 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00162678):ℝ) ≤ ∫ v in (vBP 1.187)..(vBP 1.194), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.97809098) (m := (0:ℤ)) (ylo := 0.40729465) (yhi := 0.40729466)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.187) (q1 := 1.194) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.34285823) (B := 0.35461804) (X := 1.97809098) (rho := 0.03879913)
    (clo := (-0.39612675)) (chi := (-0.39612673)) (C := (-0.39612674)) (h := 0.03879914)
    (by norm_num) (by norm_num) oscBlock27 vbpBr27.1 vbpBr28.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i28 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00181211):ℝ) ≤ ∫ v in (vBP 1.194)..(vBP 1.201), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.04459556) (m := (0:ℤ)) (ylo := 0.47379923) (yhi := 0.47379924)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.194) (q1 := 1.201) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.35461802) (B := 0.36630909) (X := 2.04459556) (rho := 0.0387874)
    (clo := (-0.4562703)) (chi := (-0.45627028)) (C := (-0.45627029)) (h := 0.03878741)
    (by norm_num) (by norm_num) oscBlock28 vbpBr28.1 vbpBr29.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i29 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00194634):ℝ) ≤ ∫ v in (vBP 1.201)..(vBP 1.208), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.11071256) (m := (0:ℤ)) (ylo := 0.53991623) (yhi := 0.53991624)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.201) (q1 := 1.208) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.36630908) (B := 0.3779322) (X := 2.11071256) (rho := 0.03877684)
    (clo := (-0.51406415)) (chi := (-0.51406413)) (C := (-0.51406414)) (h := 0.03877685)
    (by norm_num) (by norm_num) oscBlock29 vbpBr29.1 vbpBr30.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i30 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.0020439):ℝ) ≤ ∫ v in (vBP 1.208)..(vBP 1.215), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.17644642) (m := (0:ℤ)) (ylo := 0.60565009) (yhi := 0.6056501)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.208) (q1 := 1.215) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.37793219) (B := 0.38948816) (X := 2.17644642) (rho := 0.0387675)
    (clo := (-0.56929667)) (chi := (-0.56929665)) (C := (-0.56929666)) (h := 0.03876751)
    (by norm_num) (by norm_num) oscBlock30 vbpBr30.1 vbpBr31.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i31 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00242439):ℝ) ≤ ∫ v in (vBP 1.215)..(vBP 1.223), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.24645394) (m := (0:ℤ)) (ylo := 0.67565761) (yhi := 0.67565762)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.215) (q1 := 1.223) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.38948815) (B := 0.40261372) (X := 2.24645394) (rho := 0.04341161)
    (clo := (-0.6254106)) (chi := (-0.62541058)) (C := (-0.62541059)) (h := 0.04341162)
    (by norm_num) (by norm_num) oscBlock31 vbpBr31.1 vbpBr32.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i32 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00244556):ℝ) ≤ ∫ v in (vBP 1.223)..(vBP 1.231), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.3206571) (m := (0:ℤ)) (ylo := 0.74986077) (yhi := 0.74986078)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.223) (q1 := 1.231) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.40261371) (B := 0.4156537) (X := 2.3206571) (rho := 0.04337333)
    (clo := (-0.68153689)) (chi := (-0.68153688)) (C := (-0.68153689)) (h := 0.04337334)
    (by norm_num) (by norm_num) oscBlock32 vbpBr32.1 vbpBr33.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i33 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00241264):ℝ) ≤ ∫ v in (vBP 1.231)..(vBP 1.239), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.39437803) (m := (0:ℤ)) (ylo := 0.8235817) (yhi := 0.82358171)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.231) (q1 := 1.239) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.41565369) (B := 0.42860921) (X := 2.39437803) (rho := 0.04333686)
    (clo := (-0.73358466)) (chi := (-0.73358464)) (C := (-0.73358465)) (h := 0.04333687)
    (by norm_num) (by norm_num) oscBlock33 vbpBr33.1 vbpBr34.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i34 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00262687):ℝ) ≤ ∫ v in (vBP 1.239)..(vBP 1.248), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.47218208) (m := (0:ℤ)) (ylo := 0.90138575) (yhi := 0.90138576)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.239) (q1 := 1.248) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.4286092) (B := 0.44308455) (X := 2.47218208) (rho := 0.04786131)
    (clo := (-0.78418757)) (chi := (-0.78418755)) (C := (-0.78418756)) (h := 0.04786132)
    (by norm_num) (by norm_num) oscBlock34 vbpBr34.1 vbpBr35.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i35 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.0027287):ℝ) ≤ ∫ v in (vBP 1.248)..(vBP 1.258), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.5585114) (m := (0:ℤ)) (ylo := 0.98771507) (yhi := 0.98771508)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.248) (q1 := 1.258) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.44308453) (B := 0.45904632) (X := 2.5585114) (rho := 0.05231455)
    (clo := (-0.83477011)) (chi := (-0.83477007)) (C := (-0.83477009)) (h := 0.05231457)
    (by norm_num) (by norm_num) oscBlock35 vbpBr35.1 vbpBr36.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i36 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.0024711):ℝ) ≤ ∫ v in (vBP 1.258)..(vBP 1.268), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.64868523) (m := (0:ℤ)) (ylo := 1.0778889) (yhi := 1.07788891)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.258) (q1 := 1.268) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.45904631) (B := 0.47488172) (X := 2.64868523) (rho := 0.05220456)
    (clo := (-0.88096089)) (chi := (-0.88096082)) (C := (-0.88096086)) (h := 0.0522046)
    (by norm_num) (by norm_num) oscBlock36 vbpBr36.1 vbpBr37.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i37 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00256914):ℝ) ≤ ∫ v in (vBP 1.268)..(vBP 1.28), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.74704154) (m := (0:ℤ)) (ylo := 1.17624521) (yhi := 1.17624522)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.268) (q1 := 1.28) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.4748817) (B := 0.49372017) (X := 2.74704154) (rho := 0.06099194)
    (clo := (-0.92316936)) (chi := (-0.9231692)) (C := (-0.92316928)) (h := 0.06099202)
    (by norm_num) (by norm_num) oscBlock37 vbpBr37.1 vbpBr38.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i38 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00228621):ℝ) ≤ ∫ v in (vBP 1.28)..(vBP 1.294), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.86218831) (m := (0:ℤ)) (ylo := 1.29139198) (yhi := 1.29139199)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.28) (q1 := 1.294) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.49372014) (B := 0.51547641) (X := 2.86218831) (rho := 0.06958378)
    (clo := (-0.9612203)) (chi := (-0.96121987)) (C := (-0.94581805)) (h := 0.05418196)
    (by norm_num) (by norm_num) oscBlock38 vbpBr38.1 vbpBr39.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i39 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00152768):ℝ) ≤ ∫ v in (vBP 1.294)..(vBP 1.308), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.9849212) (m := (0:ℤ)) (ylo := 1.41412487) (yhi := 1.41412488)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.294) (q1 := 1.308) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.51547638) (B := 0.53699853) (X := 2.9849212) (rho := 0.06925795)
    (clo := (-0.98775324)) (chi := (-0.98775209)) (C := (-0.95924707)) (h := 0.04075293)
    (by norm_num) (by norm_num) oscBlock39 vbpBr39.1 vbpBr40.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i40 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00099395):ℝ) ≤ ∫ v in (vBP 1.308)..(vBP 1.326), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.12352312) (m := (0:ℤ)) (ylo := 1.55272679) (yhi := 1.5527268)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.308) (q1 := 1.326) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.53699848) (B := 0.56433382) (X := 3.12352312) (rho := 0.08612549)
    (clo := (-0.99983988)) (chi := (-0.9998367)) (C := (-0.95685561)) (h := 0.0431444)
    (by norm_num) (by norm_num) oscBlock40 vbpBr40.1 vbpBr41.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i41 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    (0.00002552:ℝ) ≤ ∫ v in (vBP 1.326)..(vBP 1.345), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.28174746) (m := (0:ℤ)) (ylo := 0.1401548) (yhi := 0.14015481)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.326) (q1 := 1.345) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.56433374) (B := 0.59278808) (X := 3.28174746) (rho := 0.08973476)
    (clo := (-0.99019439)) (chi := (-0.99019438)) (C := (-0.95022981)) (h := 0.04977019)
    (by norm_num) (by norm_num) oscBlock41 vbpBr41.1 vbpBr42.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i42 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    (0.00091127:ℝ) ≤ ∫ v in (vBP 1.345)..(vBP 1.362), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.43365574) (m := (0:ℤ)) (ylo := 0.29206308) (yhi := 0.29206309)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.345) (q1 := 1.362) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.59278796) (B := 0.6179085) (X := 3.43365574) (rho := 0.08069886)
    (clo := (-0.9576519)) (chi := (-0.95765189)) (C := (-0.93847652)) (h := 0.06152349)
    (by norm_num) (by norm_num) oscBlock42 vbpBr42.1 vbpBr43.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i43 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    (0.00106156:ℝ) ≤ ∫ v in (vBP 1.362)..(vBP 1.376), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.56286273) (m := (0:ℤ)) (ylo := 0.42127007) (yhi := 0.42127008)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.362) (q1 := 1.376) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.61790831) (B := 0.6383616) (X := 3.56286273) (rho := 0.06781888)
    (clo := (-0.91257032)) (chi := (-0.91257031)) (C := (-0.91257032)) (h := 0.06781889)
    (by norm_num) (by norm_num) oscBlock43 vbpBr43.1 vbpBr44.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i44 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    (0.00117669:ℝ) ≤ ∫ v in (vBP 1.376)..(vBP 1.39), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.67828119) (m := (0:ℤ)) (ylo := 0.53668853) (yhi := 0.53668854)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.376) (q1 := 1.39) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.63836133) (B := 0.65860767) (X := 3.67828119) (rho := 0.06754994)
    (clo := (-0.85940653)) (chi := (-0.85940651)) (C := (-0.85940652)) (h := 0.06754995)
    (by norm_num) (by norm_num) oscBlock44 vbpBr44.1 vbpBr45.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i45 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    (0.00116442:ℝ) ≤ ∫ v in (vBP 1.39)..(vBP 1.404), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.79253712) (m := (0:ℤ)) (ylo := 0.65094446) (yhi := 0.65094447)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.39) (q1 := 1.404) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.65860729) (B := 0.67865086) (X := 3.79253712) (rho := 0.06728966)
    (clo := (-0.79551188)) (chi := (-0.79551186)) (C := (-0.79551187)) (h := 0.06728967)
    (by norm_num) (by norm_num) oscBlock45 vbpBr45.1 vbpBr46.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i46 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    (0.00105024:ℝ) ≤ ∫ v in (vBP 1.404)..(vBP 1.418), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.90565366) (m := (0:ℤ)) (ylo := 0.764061) (yhi := 0.76406101)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.404) (q1 := 1.418) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.67865033) (B := 0.69849519) (X := 3.90565366) (rho := 0.06703775)
    (clo := (-0.72203236)) (chi := (-0.72203232)) (C := (-0.72203234)) (h := 0.06703777)
    (by norm_num) (by norm_num) oscBlock46 vbpBr46.1 vbpBr47.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i47 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    (0.00086532:ℝ) ≤ ∫ v in (vBP 1.418)..(vBP 1.432), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.01765335) (m := (0:ℤ)) (ylo := 0.87606069) (yhi := 0.8760607)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.418) (q1 := 1.432) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.69849446) (B := 0.7181446) (X := 4.01765335) (rho := 0.06679408)
    (clo := (-0.64018245)) (chi := (-0.64018236)) (C := (-0.64018241)) (h := 0.06679413)
    (by norm_num) (by norm_num) oscBlock47 vbpBr47.1 vbpBr48.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i48 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    (0.00064232:ℝ) ≤ ∫ v in (vBP 1.432)..(vBP 1.446), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.128558) (m := (0:ℤ)) (ylo := 0.98696534) (yhi := 0.98696535)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.432) (q1 := 1.446) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.7181436) (B := 0.73760286) (X := 4.128558) (rho := 0.06655828)
    (clo := (-0.55122463)) (chi := (-0.55122437)) (C := (-0.5512245)) (h := 0.06655841)
    (by norm_num) (by norm_num) oscBlock48 vbpBr48.1 vbpBr49.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i49 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    (0.00043523:ℝ) ≤ ∫ v in (vBP 1.446)..(vBP 1.462), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.24617475) (m := (0:ℤ)) (ylo := 1.10458209) (yhi := 1.1045821)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.446) (q1 := 1.462) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.73760153) (B := 0.75961158) (X := 4.24617475) (rho := 0.07411612)
    (clo := (-0.44950852)) (chi := (-0.44950776)) (C := (-0.44950814)) (h := 0.0741165)
    (by norm_num) (by norm_num) oscBlock49 vbpBr49.1 vbpBr50.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i50 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00028724):ℝ) ≤ ∫ v in (vBP 1.462)..(vBP 1.478), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.37032294) (m := (0:ℤ)) (ylo := 1.22873028) (yhi := 1.22873029)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.462) (q1 := 1.478) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.75960973) (B := 0.78138081) (X := 4.37032294) (rho := 0.07378043)
    (clo := (-0.3354363)) (chi := (-0.33543412)) (C := (-0.33543521)) (h := 0.07378152)
    (by norm_num) (by norm_num) oscBlock50 vbpBr50.1 vbpBr51.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i51 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00038575):ℝ) ≤ ∫ v in (vBP 1.478)..(vBP 1.495), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.49693284) (m := (0:ℤ)) (ylo := 1.35534018) (yhi := 1.35534019)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.478) (q1 := 1.495) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.7813783) (B := 0.80425401) (X := 4.49693284) (rho := 0.07726185)
    (clo := (-0.21379874)) (chi := (-0.21379296)) (C := (-0.21379585)) (h := 0.07726474)
    (by norm_num) (by norm_num) oscBlock51 vbpBr51.1 vbpBr52.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i52 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.0002326):ℝ) ≤ ∫ v in (vBP 1.495)..(vBP 1.512), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.62592903) (m := (0:ℤ)) (ylo := 1.48433637) (yhi := 1.48433638)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.495) (q1 := 1.512) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.80425056) (B := 0.82686872) (X := 4.62592903) (rho := 0.07688682)
    (clo := (-0.08636635)) (chi := (-0.08635203)) (C := (-0.08635919)) (h := 0.07689398)
    (by norm_num) (by norm_num) oscBlock52 vbpBr52.1 vbpBr53.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i53 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00026211):ℝ) ≤ ∫ v in (vBP 1.512)..(vBP 1.531), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.76090973) (m := (0:ℤ)) (ylo := 0.04852074) (yhi := 0.04852075)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.512) (q1 := 1.531) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.82686405) (B := 0.85184522) (X := 4.76090973) (rho := 0.08395997)
    (clo := 0.0485017) (chi := 0.04850172) (C := 0.04850171) (h := 0.08395998)
    (by norm_num) (by norm_num) oscBlock53 vbpBr53.1 vbpBr54.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i54 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00049243):ℝ) ≤ ∫ v in (vBP 1.531)..(vBP 1.55), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.901693) (m := (0:ℤ)) (ylo := 0.18930401) (yhi := 0.18930402)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.531) (q1 := 1.55) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.85183877) (B := 0.87651393) (X := 4.901693) (rho := 0.08347998)
    (clo := 0.18817538) (chi := 0.1881754) (C := 0.18817539) (h := 0.08347999)
    (by norm_num) (by norm_num) oscBlock54 vbpBr54.1 vbpBr55.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i55 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00072149):ℝ) ≤ ∫ v in (vBP 1.55)..(vBP 1.57), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.04437447) (m := (0:ℤ)) (ylo := 0.33198548) (yhi := 0.33198549)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.55) (q1 := 1.57) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.87650515) (B := 0.90215678) (X := 5.04437447) (rho := 0.08664223)
    (clo := 0.32592073) (chi := 0.32592075) (C := 0.32592074) (h := 0.08664224)
    (by norm_num) (by norm_num) oscBlock55 vbpBr55.1 vbpBr56.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i56 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00087116):ℝ) ≤ ∫ v in (vBP 1.57)..(vBP 1.59), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.18888668) (m := (0:ℤ)) (ylo := 0.47649769) (yhi := 0.4764977)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.57) (q1 := 1.59) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.90214481) (B := 0.92747548) (X := 5.18888668) (rho := 0.08613012)
    (clo := 0.45866981) (chi := 0.45866983) (C := 0.45866982) (h := 0.08613013)
    (by norm_num) (by norm_num) oscBlock56 vbpBr56.1 vbpBr57.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i57 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00097508):ℝ) ≤ ∫ v in (vBP 1.59)..(vBP 1.61), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.33158111) (m := (0:ℤ)) (ylo := 0.61919212) (yhi := 0.61919213)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.59) (q1 := 1.61) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.92745939) (B := 0.95247825) (X := 5.33158111) (rho := 0.08563895)
    (clo := 0.58037745) (chi := 0.58037747) (C := 0.58037746) (h := 0.08563896)
    (by norm_num) (by norm_num) oscBlock57 vbpBr57.1 vbpBr58.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i58 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00117312):ℝ) ≤ ∫ v in (vBP 1.61)..(vBP 1.632), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.47947812) (m := (0:ℤ)) (ylo := 0.76708913) (yhi := 0.76708914)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.61) (q1 := 1.632) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.95245689) (B := 0.97962584) (X := 5.47947812) (rho := 0.09214386)
    (clo := 0.69404254) (chi := 0.69404256) (C := 0.69404255) (h := 0.09214387)
    (by norm_num) (by norm_num) oscBlock58 vbpBr58.1 vbpBr59.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i59 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00134728):ℝ) ≤ ∫ v in (vBP 1.632)..(vBP 1.656), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.63927835) (m := (0:ℤ)) (ylo := 0.92688936) (yhi := 0.92688937)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.632) (q1 := 1.656) (t0 := 5.65625) (t1 := 5.6875)
    (A := 0.97959707) (B := 1.00882827) (X := 5.63927835) (rho := 0.09843244)
    (clo := 0.79975641) (chi := 0.79975644) (C := 0.79975642) (h := 0.09843246)
    (by norm_num) (by norm_num) oscBlock59 vbpBr59.1 vbpBr60.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i60 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00133561):ℝ) ≤ ∫ v in (vBP 1.656)..(vBP 1.68), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.80369059) (m := (0:ℤ)) (ylo := 1.0913016) (yhi := 1.09130161)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.656) (q1 := 1.68) (t0 := 5.65625) (t1 := 5.6875)
    (A := 1.00878907) (B := 1.03761196) (X := 5.80369059) (rho := 0.09772744)
    (clo := 0.88722813) (chi := 0.88722821) (C := 0.88722817) (h := 0.09772748)
    (by norm_num) (by norm_num) oscBlock60 vbpBr60.1 vbpBr61.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i61 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00122808):ℝ) ≤ ∫ v in (vBP 1.68)..(vBP 1.704), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.96575412) (m := (0:ℤ)) (ylo := 1.25336513) (yhi := 1.25336514)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.68) (q1 := 1.704) (t0 := 5.65625) (t1 := 5.6875)
    (A := 1.03755935) (B := 1.06598913) (X := 5.96575412) (rho := 0.09705907)
    (clo := 0.95004034) (chi := 0.95004065) (C := 0.92649063) (h := 0.07350937)
    (by norm_num) (by norm_num) oscBlock61 vbpBr61.1 vbpBr62.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i62 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00137159):ℝ) ≤ ∫ v in (vBP 1.704)..(vBP 1.734), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.14525721) (m := (0:ℤ)) (ylo := 1.43286822) (yhi := 1.43286823)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.704) (q1 := 1.734) (t0 := 5.65625) (t1 := 5.6875)
    (A := 1.06591948) (B := 1.10090679) (X := 6.14525721) (rho := 0.11615017)
    (clo := 0.99050297) (chi := 0.99050429) (C := 0.9371764) (h := 0.0628236)
    (by norm_num) (by norm_num) oscBlock62 vbpBr62.1 vbpBr63.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i63 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00129873):ℝ) ≤ ∫ v in (vBP 1.734)..(vBP 1.766), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.34798478) (m := (1:ℤ)) (ylo := 0.06479947) (yhi := 0.06479948)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.734) (q1 := 1.766) (t0 := 5.65625) (t1 := 5.6875)
    (A := 1.10080961) (B := 1.13749718) (X := 6.34798478) (rho := 0.12153044)
    (clo := 0.99790124) (chi := 0.99790125) (C := 0.9381854) (h := 0.0618146)
    (by norm_num) (by norm_num) oscBlock63 vbpBr63.1 vbpBr64.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i64 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00107612):ℝ) ≤ ∫ v in (vBP 1.766)..(vBP 1.796), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.54722475) (m := (1:ℤ)) (ylo := 0.26403944) (yhi := 0.26403945)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.766) (q1 := 1.796) (t0 := 5.65625) (t1 := 5.6875)
    (A := 1.1373613) (B := 1.17120873) (X := 6.54722475) (rho := 0.11402491)
    (clo := 0.96534363) (chi := 0.96534364) (C := 0.92565936) (h := 0.07434064)
    (by norm_num) (by norm_num) oscBlock64 vbpBr64.1 vbpBr65.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i65 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00105478):ℝ) ≤ ∫ v in (vBP 1.796)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.74296083) (m := (1:ℤ)) (ylo := 0.45977552) (yhi := 0.45977553)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.796) (q1 := 1.828) (t0 := 5.65625) (t1 := 5.6875)
    (A := 1.1710258) (B := 1.20655947) (X := 6.74296083) (rho := 0.11934617)
    (clo := 0.89615212) (chi := 0.89615214) (C := 0.88840297) (h := 0.11159703)
    (by norm_num) (by norm_num) oscBlock65 vbpBr65.1 vbpBr66.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i66 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.0008782):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.86), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.94156414) (m := (1:ℤ)) (ylo := 0.65837883) (yhi := 0.65837884)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.828) (q1 := 1.86) (t0 := 5.65625) (t1 := 5.6875)
    (A := 1.20631244) (B := 1.24130524) (X := 6.94156414) (rho := 0.11835942)
    (clo := 0.79098515) (chi := 0.79098517) (C := 0.79098516) (h := 0.11835943)
    (by norm_num) (by norm_num) oscBlock66 vbpBr66.1 vbpBr67.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i67 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00062183):ℝ) ≤ ∫ v in (vBP 1.86)..(vBP 1.89), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.13072651) (m := (1:ℤ)) (ylo := 0.8475412) (yhi := 0.84754121)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.86) (q1 := 1.89) (t0 := 5.65625) (t1 := 5.6875)
    (A := 1.24097685) (B := 1.27334993) (X := 7.13072651) (rho := 0.11145122)
    (clo := 0.66182838) (chi := 0.66182845) (C := 0.66182841) (h := 0.11145126)
    (by norm_num) (by norm_num) oscBlock67 vbpBr67.1 vbpBr68.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i68 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.0004871):ℝ) ≤ ∫ v in (vBP 1.89)..(vBP 1.922), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.31673902) (m := (1:ℤ)) (ylo := 1.03355371) (yhi := 1.03355372)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.89) (q1 := 1.922) (t0 := 5.65625) (t1 := 5.6875)
    (A := 1.27292668) (B := 1.30698664) (X := 7.31673902) (rho := 0.11674751)
    (clo := 0.51176899) (chi := 0.51176939) (C := 0.51176919) (h := 0.11674771)
    (by norm_num) (by norm_num) oscBlock68 vbpBr68.1 vbpBr69.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i69 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00045678):ℝ) ≤ ∫ v in (vBP 1.922)..(vBP 1.969), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.54923261) (m := (1:ℤ)) (ylo := 1.2660473) (yhi := 1.26604731)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.922) (q1 := 1.969) (t0 := 5.65625) (t1 := 5.6875)
    (A := 1.30643896) (B := 1.35541448) (X := 7.54923261) (rho := 0.15968726)
    (clo := 0.30005373) (chi := 0.30005666) (C := 0.30005519) (h := 0.15968873)
    (by norm_num) (by norm_num) oscBlock69 vbpBr69.1 vbpBr70.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i70 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00016768):ℝ) ≤ ∫ v in (vBP 1.969)..(vBP 2.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.82010241) (m := (1:ℤ)) (ylo := 1.5369171) (yhi := 1.53691711)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.969) (q1 := 2.016) (t0 := 5.65625) (t1 := 5.6875)
    (A := 1.35463226) (B := 1.4027369) (X := 7.82010241) (rho := 0.15796371)
    (clo := 0.03387237) (chi := 0.03389266) (C := 0.03388251) (h := 0.15797386)
    (by norm_num) (by norm_num) oscBlock70 vbpBr70.1 vbpBr71.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i71 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00029863):ℝ) ≤ ∫ v in (vBP 2.016)..(vBP 2.062), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.08189256) (m := (1:ℤ)) (ylo := 0.22791092) (yhi := 0.22791093)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.016) (q1 := 2.062) (t0 := 5.65625) (t1 := 5.6875)
    (A := 1.40164597) (B := 1.44803958) (X := 8.08189256) (rho := 0.15383256)
    (clo := (-0.22594298)) (chi := (-0.22594296)) (C := (-0.22594297)) (h := 0.15383257)
    (by norm_num) (by norm_num) oscBlock71 vbpBr71.1 vbpBr72.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB21i72 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.00027779):ℝ) ≤ ∫ v in (vBP 2.062)..(vBP 2.094), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.29693571) (m := (1:ℤ)) (ylo := 0.44295407) (yhi := 0.44295408)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.062) (q1 := 2.094) (t0 := 5.65625) (t1 := 5.6875)
    (A := 1.44655973) (B := 1.47899217) (X := 8.29693571) (rho := 0.11483226)
    (clo := (-0.42861032)) (chi := (-0.4286103)) (C := (-0.42861031)) (h := 0.11483227)
    (by norm_num) (by norm_num) oscBlock72 vbpBr72.1 vbpBr73.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

/-- Lower bound for the oscillatory integral `∫₀^∞ err(v) cos(tv) dv` on the band
`5.65625 ≤ t ≤ 5.6875`. -/
theorem oscBandLower21 {t : ℝ} (ht0 : (5.65625:ℝ) ≤ t) (ht1 : t ≤ 5.6875) :
    ((-0.11133317):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosB21i0 ht0 ht1)
    (cosB21i1 ht0 ht1))
    (cosB21i2 ht0 ht1))
    (cosB21i3 ht0 ht1))
    (cosB21i4 ht0 ht1))
    (cosB21i5 ht0 ht1))
    (cosB21i6 ht0 ht1))
    (cosB21i7 ht0 ht1))
    (cosB21i8 ht0 ht1))
    (cosB21i9 ht0 ht1))
    (cosB21i10 ht0 ht1))
    (cosB21i11 ht0 ht1))
    (cosB21i12 ht0 ht1))
    (cosB21i13 ht0 ht1))
    (cosB21i14 ht0 ht1))
    (cosB21i15 ht0 ht1))
    (cosB21i16 ht0 ht1))
    (cosB21i17 ht0 ht1))
    (cosB21i18 ht0 ht1))
    (cosB21i19 ht0 ht1))
    (cosB21i20 ht0 ht1))
    (cosB21i21 ht0 ht1))
    (cosB21i22 ht0 ht1))
    (cosB21i23 ht0 ht1))
    (cosB21i24 ht0 ht1))
    (cosB21i25 ht0 ht1))
    (cosB21i26 ht0 ht1))
    (cosB21i27 ht0 ht1))
    (cosB21i28 ht0 ht1))
    (cosB21i29 ht0 ht1))
    (cosB21i30 ht0 ht1))
    (cosB21i31 ht0 ht1))
    (cosB21i32 ht0 ht1))
    (cosB21i33 ht0 ht1))
    (cosB21i34 ht0 ht1))
    (cosB21i35 ht0 ht1))
    (cosB21i36 ht0 ht1))
    (cosB21i37 ht0 ht1))
    (cosB21i38 ht0 ht1))
    (cosB21i39 ht0 ht1))
    (cosB21i40 ht0 ht1))
    (cosB21i41 ht0 ht1))
    (cosB21i42 ht0 ht1))
    (cosB21i43 ht0 ht1))
    (cosB21i44 ht0 ht1))
    (cosB21i45 ht0 ht1))
    (cosB21i46 ht0 ht1))
    (cosB21i47 ht0 ht1))
    (cosB21i48 ht0 ht1))
    (cosB21i49 ht0 ht1))
    (cosB21i50 ht0 ht1))
    (cosB21i51 ht0 ht1))
    (cosB21i52 ht0 ht1))
    (cosB21i53 ht0 ht1))
    (cosB21i54 ht0 ht1))
    (cosB21i55 ht0 ht1))
    (cosB21i56 ht0 ht1))
    (cosB21i57 ht0 ht1))
    (cosB21i58 ht0 ht1))
    (cosB21i59 ht0 ht1))
    (cosB21i60 ht0 ht1))
    (cosB21i61 ht0 ht1))
    (cosB21i62 ht0 ht1))
    (cosB21i63 ht0 ht1))
    (cosB21i64 ht0 ht1))
    (cosB21i65 ht0 ht1))
    (cosB21i66 ht0 ht1))
    (cosB21i67 ht0 ht1))
    (cosB21i68 ht0 ht1))
    (cosB21i69 ht0 ht1))
    (cosB21i70 ht0 ht1))
    (cosB21i71 ht0 ht1))
    (cosB21i72 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 2.094) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 2.094) (S := 0.013709)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_cut
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
