/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscTail

/-!
# Oscillatory lower bound on the band `6.0625 ≤ t ≤ 6.125`

On each of the 73 blocks the factor `cos(tv)` is bracketed by a rational constant
`C` up to a rational error `h`; the signed contribution `min(C·P₀, C·P₁) - h·S` is
then summed, and the unresolved tail beyond `q = 2.094` is estimated in absolute
value.  The result is the bound `∫₀^∞ err(v) cos(tv) dv ≥ -0.12631229`.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosB12i0 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00641868):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.0038), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.0232309) (m := (0:ℤ)) (ylo := 0.0232309) (yhi := 0.0232309)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1) (q1 := 1.0038) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.0) (B := 0.0075856) (X := 0.0232309) (rho := 0.02323091)
    (clo := 0.99973017) (chi := 0.99973018) (C := 0.98824963) (h := 0.01175037)
    (by norm_num) (by norm_num) oscBlock0 vbpBr0.1 vbpBr1.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i1 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00625872):ℝ) ≤ ∫ v in (vBP 1.0038)..(vBP 1.0078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.07058347) (m := (0:ℤ)) (ylo := 0.07058347) (yhi := 0.07058347)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0038) (q1 := 1.0078) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.00758559) (B := 0.01553948) (X := 0.07058347) (rho := 0.02459585)
    (clo := 0.99751002) (chi := 0.99751003) (C := 0.98645708) (h := 0.01354292)
    (by norm_num) (by norm_num) oscBlock1 vbpBr1.1 vbpBr2.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i2 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.0057677):ℝ) ≤ ∫ v in (vBP 1.0078)..(vBP 1.0118), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.11895593) (m := (0:ℤ)) (ylo := 0.11895593) (yhi := 0.11895593)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0078) (q1 := 1.0118) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.01553947) (B := 0.02346185) (X := 0.11895593) (rho := 0.02474791)
    (clo := 0.99293308) (chi := 0.99293309) (C := 0.98409258) (h := 0.01590742)
    (by norm_num) (by norm_num) oscBlock2 vbpBr2.1 vbpBr3.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i3 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00554846):ℝ) ≤ ∫ v in (vBP 1.0118)..(vBP 1.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.16834297) (m := (0:ℤ)) (ylo := 0.16834297) (yhi := 0.16834297)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0118) (q1 := 1.016) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.02346184) (B := 0.0317467) (X := 0.16834297) (rho := 0.02610558)
    (clo := 0.98586375) (chi := 0.98586376) (C := 0.97987908) (h := 0.02012092)
    (by norm_num) (by norm_num) oscBlock3 vbpBr3.1 vbpBr4.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i4 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00539232):ℝ) ≤ ∫ v in (vBP 1.016)..(vBP 1.0205), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.22052497) (m := (0:ℤ)) (ylo := 0.22052497) (yhi := 0.22052497)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.016) (q1 := 1.0205) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.03174669) (B := 0.04058541) (X := 0.22052497) (rho := 0.02806068)
    (clo := 0.97578275) (chi := 0.97578276) (C := 0.97386103) (h := 0.02613897)
    (by norm_num) (by norm_num) oscBlock4 vbpBr4.1 vbpBr5.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i5 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00480654):ℝ) ≤ ∫ v in (vBP 1.0205)..(vBP 1.025), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.27426676) (m := (0:ℤ)) (ylo := 0.27426676) (yhi := 0.27426676)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0205) (q1 := 1.025) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.0405854) (B := 0.04938523) (X := 0.27426676) (rho := 0.02821779)
    (clo := 0.96262404) (chi := 0.96262405) (C := 0.96262404) (h := 0.0282178)
    (by norm_num) (by norm_num) oscBlock5 vbpBr5.1 vbpBr6.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i6 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00468136):ℝ) ≤ ∫ v in (vBP 1.025)..(vBP 1.03), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.33074662) (m := (0:ℤ)) (ylo := 0.33074662) (yhi := 0.33074662)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.025) (q1 := 1.03) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.04938522) (B := 0.05911761) (X := 0.33074662) (rho := 0.03134875)
    (clo := 0.94580014) (chi := 0.94580015) (C := 0.94580014) (h := 0.03134876)
    (by norm_num) (by norm_num) oscBlock6 vbpBr6.1 vbpBr7.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i7 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00437651):ℝ) ≤ ∫ v in (vBP 1.03)..(vBP 1.0355), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.3928672) (m := (0:ℤ)) (ylo := 0.3928672) (yhi := 0.3928672)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.03) (q1 := 1.0355) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.0591176) (B := 0.06976881) (X := 0.3928672) (rho := 0.03446677)
    (clo := 0.92381518) (chi := 0.92381519) (C := 0.92381518) (h := 0.03446678)
    (by norm_num) (by norm_num) oscBlock7 vbpBr7.1 vbpBr8.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i8 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.0039128):ℝ) ≤ ∫ v in (vBP 1.0355)..(vBP 1.0415), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.46054133) (m := (0:ℤ)) (ylo := 0.46054133) (yhi := 0.46054133)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0355) (q1 := 1.0415) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.0697688) (B := 0.08132397) (X := 0.46054133) (rho := 0.037568)
    (clo := 0.89581204) (chi := 0.89581205) (C := 0.89581204) (h := 0.03756801)
    (by norm_num) (by norm_num) oscBlock8 vbpBr8.1 vbpBr9.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i9 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00331715):ℝ) ≤ ∫ v in (vBP 1.0415)..(vBP 1.048), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.53367524) (m := (0:ℤ)) (ylo := 0.53367524) (yhi := 0.53367524)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0415) (q1 := 1.048) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.08132396) (B := 0.09376718) (X := 0.53367524) (rho := 0.04064875)
    (clo := 0.86094329) (chi := 0.8609433) (C := 0.86094329) (h := 0.04064876)
    (by norm_num) (by norm_num) oscBlock9 vbpBr9.1 vbpBr10.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i10 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00264237):ℝ) ≤ ∫ v in (vBP 1.048)..(vBP 1.055), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.61216895) (m := (0:ℤ)) (ylo := 0.61216895) (yhi := 0.61216895)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.048) (q1 := 1.055) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.09376717) (B := 0.10708154) (X := 0.61216895) (rho := 0.0437055)
    (clo := 0.81840356) (chi := 0.81840358) (C := 0.81840357) (h := 0.04370551)
    (by norm_num) (by norm_num) oscBlock10 vbpBr10.1 vbpBr11.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i11 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00217923):ℝ) ≤ ∫ v in (vBP 1.055)..(vBP 1.064), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.70455768) (m := (0:ℤ)) (ylo := 0.70455768) (yhi := 0.70455768)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.055) (q1 := 1.064) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.10708153) (B := 0.12407079) (X := 0.70455768) (rho := 0.05537592)
    (clo := 0.76189811) (chi := 0.76189813) (C := 0.76189812) (h := 0.05537593)
    (by norm_num) (by norm_num) oscBlock11 vbpBr11.1 vbpBr12.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i12 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00140315):ℝ) ≤ ∫ v in (vBP 1.064)..(vBP 1.078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.83612283) (m := (0:ℤ)) (ylo := 0.83612283) (yhi := 0.83612283)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.064) (q1 := 1.078) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.12407078) (B := 0.15021495) (X := 0.83612283) (rho := 0.08394375)
    (clo := 0.6703449) (chi := 0.67034496) (C := 0.67034493) (h := 0.08394378)
    (by norm_num) (by norm_num) oscBlock12 vbpBr12.1 vbpBr13.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i13 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    (0.00016145:ℝ) ≤ ∫ v in (vBP 1.078)..(vBP 1.09), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.98317744) (m := (0:ℤ)) (ylo := 0.98317744) (yhi := 0.98317744)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.078) (q1 := 1.09) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.15021494) (B := 0.1723554) (X := 0.98317744) (rho := 0.07249939)
    (clo := 0.55438088) (chi := 0.55438112) (C := 0.554381) (h := 0.07249951)
    (by norm_num) (by norm_num) oscBlock13 vbpBr13.1 vbpBr14.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i14 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    (0.00064433:ℝ) ≤ ∫ v in (vBP 1.09)..(vBP 1.1), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.10622712) (m := (0:ℤ)) (ylo := 1.10622712) (yhi := 1.10622712)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.09) (q1 := 1.1) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.17235539) (B := 0.19062036) (X := 1.10622712) (rho := 0.06132259)
    (clo := 0.4480377) (chi := 0.44803846) (C := 0.44803808) (h := 0.06132297)
    (by norm_num) (by norm_num) oscBlock14 vbpBr14.1 vbpBr15.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i15 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    (0.00068727:ℝ) ≤ ∫ v in (vBP 1.1)..(vBP 1.109), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.21150253) (m := (0:ℤ)) (ylo := 1.21150253) (yhi := 1.21150253)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.1) (q1 := 1.109) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.19062035) (B := 0.20691742) (X := 1.21150253) (rho := 0.05586668)
    (clo := 0.35161319) (chi := 0.35161507) (C := 0.35161413) (h := 0.05586762)
    (by norm_num) (by norm_num) oscBlock15 vbpBr15.1 vbpBr16.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i16 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    (0.00054332:ℝ) ≤ ∫ v in (vBP 1.109)..(vBP 1.117), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.30492836) (m := (0:ℤ)) (ylo := 1.30492836) (yhi := 1.30492836)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.109) (q1 := 1.117) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.20691741) (B := 0.22129305) (X := 1.30492836) (rho := 0.05049158)
    (clo := 0.26274678) (chi := 0.26275074) (C := 0.26274876) (h := 0.05049356)
    (by norm_num) (by norm_num) oscBlock16 vbpBr16.1 vbpBr17.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i17 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    (0.00034903:ℝ) ≤ ∫ v in (vBP 1.117)..(vBP 1.124), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.38676877) (m := (0:ℤ)) (ylo := 1.38676877) (yhi := 1.38676877)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.117) (q1 := 1.124) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.22129304) (B := 0.23378751) (X := 1.38676877) (rho := 0.04517974)
    (clo := 0.18299049) (chi := 0.18299775) (C := 0.18299412) (h := 0.04518337)
    (by norm_num) (by norm_num) oscBlock17 vbpBr17.1 vbpBr18.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i18 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    (0.00016328:ℝ) ≤ ∫ v in (vBP 1.124)..(vBP 1.131), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.46266933) (m := (0:ℤ)) (ylo := 1.46266933) (yhi := 1.46266933)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.124) (q1 := 1.131) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.2337875) (B := 0.2462044) (X := 1.46266933) (rho := 0.04533263)
    (clo := 0.10791622) (chi := 0.10792858) (C := 0.1079224) (h := 0.04533881)
    (by norm_num) (by norm_num) oscBlock18 vbpBr18.1 vbpBr19.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i19 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00006093):ℝ) ≤ ∫ v in (vBP 1.131)..(vBP 1.138), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.53810013) (m := (0:ℤ)) (ylo := 1.53810013) (yhi := 1.53810013)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.131) (q1 := 1.138) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.24620439) (B := 0.25854468) (X := 1.53810013) (rho := 0.04548604)
    (clo := 0.03269001) (chi := 0.03271044) (C := 0.03270022) (h := 0.04549626)
    (by norm_num) (by norm_num) oscBlock19 vbpBr19.1 vbpBr20.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i20 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.0003273):ℝ) ≤ ∫ v in (vBP 1.138)..(vBP 1.145), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.61306695) (m := (0:ℤ)) (ylo := 0.04227062) (yhi := 0.04227063)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.138) (q1 := 1.145) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.25854467) (B := 0.27080928) (X := 1.61306695) (rho := 0.0456399)
    (clo := (-0.04225805)) (chi := (-0.04225803)) (C := (-0.04225804)) (h := 0.04563991)
    (by norm_num) (by norm_num) oscBlock20 vbpBr20.1 vbpBr21.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i21 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00062167):ℝ) ≤ ∫ v in (vBP 1.145)..(vBP 1.152), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.68757543) (m := (0:ℤ)) (ylo := 0.1167791) (yhi := 0.11677911)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.145) (q1 := 1.152) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.27080927) (B := 0.28299913) (X := 1.68757543) (rho := 0.04579425)
    (clo := (-0.11651387)) (chi := (-0.11651385)) (C := (-0.11651386)) (h := 0.04579426)
    (by norm_num) (by norm_num) oscBlock21 vbpBr21.1 vbpBr22.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i22 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00091935):ℝ) ≤ ∫ v in (vBP 1.152)..(vBP 1.159), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.76163116) (m := (0:ℤ)) (ylo := 0.19083483) (yhi := 0.19083484)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.152) (q1 := 1.159) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.28299912) (B := 0.29511513) (X := 1.76163116) (rho := 0.04594902)
    (clo := (-0.18967865)) (chi := (-0.18967863)) (C := (-0.18967864)) (h := 0.04594903)
    (by norm_num) (by norm_num) oscBlock22 vbpBr22.1 vbpBr23.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i23 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00120991):ℝ) ≤ ∫ v in (vBP 1.159)..(vBP 1.166), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.83523963) (m := (0:ℤ)) (ylo := 0.2644433) (yhi := 0.26444331)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.159) (q1 := 1.166) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.29511512) (B := 0.30715818) (X := 1.83523963) (rho := 0.04610423)
    (clo := (-0.26137198)) (chi := (-0.26137196)) (C := (-0.26137197)) (h := 0.04610424)
    (by norm_num) (by norm_num) oscBlock23 vbpBr23.1 vbpBr24.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i24 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.0014846):ℝ) ≤ ∫ v in (vBP 1.166)..(vBP 1.173), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.90840619) (m := (0:ℤ)) (ylo := 0.33760986) (yhi := 0.33760987)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.166) (q1 := 1.173) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.30715817) (B := 0.31912914) (X := 1.90840619) (rho := 0.0462598)
    (clo := (-0.33123284)) (chi := (-0.33123282)) (C := (-0.33123283)) (h := 0.04625981)
    (by norm_num) (by norm_num) oscBlock24 vbpBr24.1 vbpBr25.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i25 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00173585):ℝ) ≤ ∫ v in (vBP 1.173)..(vBP 1.18), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.98113612) (m := (0:ℤ)) (ylo := 0.41033979) (yhi := 0.4103398)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.173) (q1 := 1.18) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.31912913) (B := 0.33102888) (X := 1.98113612) (rho := 0.04641578)
    (clo := (-0.39892095)) (chi := (-0.39892093)) (C := (-0.39892094)) (h := 0.04641579)
    (by norm_num) (by norm_num) oscBlock25 vbpBr25.1 vbpBr26.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i26 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00195736):ℝ) ≤ ∫ v in (vBP 1.18)..(vBP 1.187), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.05343462) (m := (0:ℤ)) (ylo := 0.48263829) (yhi := 0.4826383)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.18) (q1 := 1.187) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.33102887) (B := 0.34285824) (X := 2.05343462) (rho := 0.04657211)
    (clo := (-0.46411773)) (chi := (-0.46411771)) (C := (-0.46411772)) (h := 0.04657212)
    (by norm_num) (by norm_num) oscBlock26 vbpBr26.1 vbpBr27.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i27 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00214418):ℝ) ≤ ∫ v in (vBP 1.187)..(vBP 1.194), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.12530675) (m := (0:ℤ)) (ylo := 0.55451042) (yhi := 0.55451043)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.187) (q1 := 1.194) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.34285823) (B := 0.35461804) (X := 2.12530675) (rho := 0.04672875)
    (clo := (-0.52652716)) (chi := (-0.52652714)) (C := (-0.52652715)) (h := 0.04672876)
    (by norm_num) (by norm_num) oscBlock27 vbpBr27.1 vbpBr28.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i28 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00231617):ℝ) ≤ ∫ v in (vBP 1.194)..(vBP 1.201), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.19675746) (m := (0:ℤ)) (ylo := 0.62596113) (yhi := 0.62596114)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.194) (q1 := 1.201) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.35461802) (B := 0.36630909) (X := 2.19675746) (rho := 0.04688573)
    (clo := (-0.58587646)) (chi := (-0.58587644)) (C := (-0.58587645)) (h := 0.04688574)
    (by norm_num) (by norm_num) oscBlock28 vbpBr28.1 vbpBr29.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i29 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00242556):ℝ) ≤ ∫ v in (vBP 1.201)..(vBP 1.208), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.26779176) (m := (0:ℤ)) (ylo := 0.69699543) (yhi := 0.69699544)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.201) (q1 := 1.208) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.36630908) (B := 0.3779322) (X := 2.26779176) (rho := 0.04704298)
    (clo := (-0.64191677)) (chi := (-0.64191676)) (C := (-0.64191677)) (h := 0.04704299)
    (by norm_num) (by norm_num) oscBlock29 vbpBr29.1 vbpBr30.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i30 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00249283):ℝ) ≤ ∫ v in (vBP 1.208)..(vBP 1.215), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.33841444) (m := (0:ℤ)) (ylo := 0.76761811) (yhi := 0.76761812)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.208) (q1 := 1.215) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.37793219) (B := 0.38948816) (X := 2.33841444) (rho := 0.04720055)
    (clo := (-0.69442329)) (chi := (-0.69442328)) (C := (-0.69442329)) (h := 0.04720056)
    (by norm_num) (by norm_num) oscBlock30 vbpBr30.1 vbpBr31.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i31 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00289593):ℝ) ≤ ∫ v in (vBP 1.215)..(vBP 1.223), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.41364047) (m := (0:ℤ)) (ylo := 0.84284414) (yhi := 0.84284415)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.215) (q1 := 1.223) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.38948815) (B := 0.40261372) (X := 2.41364047) (rho := 0.05236858)
    (clo := (-0.74653848)) (chi := (-0.74653846)) (C := (-0.74653847)) (h := 0.05236859)
    (by norm_num) (by norm_num) oscBlock31 vbpBr31.1 vbpBr32.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i32 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00286645):ℝ) ≤ ∫ v in (vBP 1.223)..(vBP 1.231), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.49336226) (m := (0:ℤ)) (ylo := 0.92256593) (yhi := 0.92256594)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.223) (q1 := 1.231) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.40261371) (B := 0.4156537) (X := 2.49336226) (rho := 0.05251666)
    (clo := (-0.79715351)) (chi := (-0.79715349)) (C := (-0.7971535)) (h := 0.05251667)
    (by norm_num) (by norm_num) oscBlock32 vbpBr32.1 vbpBr33.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i33 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.0027796):ℝ) ≤ ∫ v in (vBP 1.231)..(vBP 1.239), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.57256595) (m := (0:ℤ)) (ylo := 1.00176962) (yhi := 1.00176963)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.231) (q1 := 1.239) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.41565369) (B := 0.42860921) (X := 2.57256595) (rho := 0.05266547)
    (clo := (-0.84242583)) (chi := (-0.84242579)) (C := (-0.84242581)) (h := 0.05266549)
    (by norm_num) (by norm_num) oscBlock33 vbpBr33.1 vbpBr34.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i34 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00297463):ℝ) ≤ ∫ v in (vBP 1.239)..(vBP 1.248), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.65616807) (m := (0:ℤ)) (ylo := 1.08537174) (yhi := 1.08537175)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.239) (q1 := 1.248) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.4286092) (B := 0.44308455) (X := 2.65616807) (rho := 0.05772481)
    (clo := (-0.88447699)) (chi := (-0.88447692)) (C := (-0.88447696)) (h := 0.05772485)
    (by norm_num) (by norm_num) oscBlock34 vbpBr34.1 vbpBr35.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i35 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00303489):ℝ) ≤ ∫ v in (vBP 1.248)..(vBP 1.258), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.74892933) (m := (0:ℤ)) (ylo := 1.178133) (yhi := 1.17813301)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.248) (q1 := 1.258) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.44308453) (B := 0.45904632) (X := 2.74892933) (rho := 0.06272939)
    (clo := (-0.92389337)) (chi := (-0.92389321)) (C := (-0.92389329)) (h := 0.06272947)
    (by norm_num) (by norm_num) oscBlock35 vbpBr35.1 vbpBr36.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i36 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00264809):ℝ) ≤ ∫ v in (vBP 1.258)..(vBP 1.268), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.84580939) (m := (0:ℤ)) (ylo := 1.27501306) (yhi := 1.27501307)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.258) (q1 := 1.268) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.45904631) (B := 0.47488172) (X := 2.84580939) (rho := 0.06284116)
    (clo := (-0.95657449)) (chi := (-0.95657411)) (C := (-0.94686648)) (h := 0.05313353)
    (by norm_num) (by norm_num) oscBlock36 vbpBr36.1 vbpBr37.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i37 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00261048):ℝ) ≤ ∫ v in (vBP 1.268)..(vBP 1.28), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.95150317) (m := (0:ℤ)) (ylo := 1.38070684) (yhi := 1.38070685)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.268) (q1 := 1.28) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.4748817) (B := 0.49372017) (X := 2.95150317) (rho := 0.07253288)
    (clo := (-0.9819882)) (chi := (-0.98198732)) (C := (-0.95472722)) (h := 0.04527278)
    (by norm_num) (by norm_num) oscBlock37 vbpBr37.1 vbpBr38.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i38 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.0022862):ℝ) ≤ ∫ v in (vBP 1.28)..(vBP 1.294), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.07523568) (m := (0:ℤ)) (ylo := 1.50443935) (yhi := 1.50443936)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.28) (q1 := 1.294) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.49372014) (B := 0.51547641) (X := 3.07523568) (rho := 0.08205735)
    (clo := (-0.9978014)) (chi := (-0.99779915)) (C := (-0.9578709)) (h := 0.0421291)
    (by norm_num) (by norm_num) oscBlock38 vbpBr38.1 vbpBr39.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i39 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00152769):ℝ) ≤ ∫ v in (vBP 1.294)..(vBP 1.308), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.20709577) (m := (0:ℤ)) (ylo := 0.06550311) (yhi := 0.06550312)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.294) (q1 := 1.308) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.51547638) (B := 0.53699853) (X := 3.20709577) (rho := 0.08202024)
    (clo := (-0.99785544)) (chi := (-0.99785543)) (C := (-0.9579176)) (h := 0.04208241)
    (by norm_num) (by norm_num) oscBlock39 vbpBr39.1 vbpBr40.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i40 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00099584):ℝ) ≤ ∫ v in (vBP 1.308)..(vBP 1.326), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.35604896) (m := (0:ℤ)) (ylo := 0.2144563) (yhi := 0.21445631)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.308) (q1 := 1.326) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.53699848) (B := 0.56433382) (X := 3.35604896) (rho := 0.1004957)
    (clo := (-0.97709225)) (chi := (-0.97709224)) (C := (-0.93829827)) (h := 0.06170173)
    (by norm_num) (by norm_num) oscBlock40 vbpBr40.1 vbpBr41.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i41 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00004409):ℝ) ≤ ∫ v in (vBP 1.326)..(vBP 1.345), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.52605014) (m := (0:ℤ)) (ylo := 0.38445748) (yhi := 0.38445749)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.326) (q1 := 1.345) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.56433374) (B := 0.59278808) (X := 3.52605014) (rho := 0.10477686)
    (clo := (-0.92700205)) (chi := (-0.92700204)) (C := (-0.91111259)) (h := 0.08888741)
    (by norm_num) (by norm_num) oscBlock41 vbpBr41.1 vbpBr42.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i42 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    (0.00075095:ℝ) ≤ ∫ v in (vBP 1.345)..(vBP 1.362), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.68923328) (m := (0:ℤ)) (ylo := 0.54764062) (yhi := 0.54764063)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.345) (q1 := 1.362) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.59278796) (B := 0.6179085) (X := 3.68923328) (rho := 0.09545629)
    (clo := (-0.85375537)) (chi := (-0.85375536)) (C := (-0.85375537)) (h := 0.0954563)
    (by norm_num) (by norm_num) oscBlock42 vbpBr42.1 vbpBr43.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i43 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    (0.00085171:ℝ) ≤ ∫ v in (vBP 1.362)..(vBP 1.376), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.82801696) (m := (0:ℤ)) (ylo := 0.6864243) (yhi := 0.68642431)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.362) (q1 := 1.376) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.61790831) (B := 0.6383616) (X := 3.82801696) (rho := 0.08194785)
    (clo := (-0.77351716)) (chi := (-0.77351713)) (C := (-0.77351715)) (h := 0.08194787)
    (by norm_num) (by norm_num) oscBlock43 vbpBr43.1 vbpBr44.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i44 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    (0.00088374:ℝ) ≤ ∫ v in (vBP 1.376)..(vBP 1.39), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.95201877) (m := (0:ℤ)) (ylo := 0.81042611) (yhi := 0.81042612)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.376) (q1 := 1.39) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.63836133) (B := 0.65860767) (X := 3.95201877) (rho := 0.08195322)
    (clo := (-0.68918978)) (chi := (-0.68918973)) (C := (-0.68918976)) (h := 0.08195325)
    (by norm_num) (by norm_num) oscBlock44 vbpBr44.1 vbpBr45.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i45 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    (0.00080051:ℝ) ≤ ∫ v in (vBP 1.39)..(vBP 1.404), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.0747716) (m := (0:ℤ)) (ylo := 0.93317894) (yhi := 0.93317895)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.39) (q1 := 1.404) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.65860729) (B := 0.67865086) (X := 4.0747716) (rho := 0.08196493)
    (clo := (-0.59528281)) (chi := (-0.59528265)) (C := (-0.59528273)) (h := 0.08196501)
    (by norm_num) (by norm_num) oscBlock45 vbpBr45.1 vbpBr46.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i46 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    (0.00063702:ℝ) ≤ ∫ v in (vBP 1.404)..(vBP 1.418), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.19630033) (m := (0:ℤ)) (ylo := 1.05470767) (yhi := 1.05470768)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.404) (q1 := 1.418) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.67865033) (B := 0.69849519) (X := 4.19630033) (rho := 0.08198272)
    (clo := (-0.49348248)) (chi := (-0.49348199)) (C := (-0.49348224)) (h := 0.08198297)
    (by norm_num) (by norm_num) oscBlock46 vbpBr46.1 vbpBr47.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i47 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    (0.00043095:ℝ) ≤ ∫ v in (vBP 1.418)..(vBP 1.432), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.31662916) (m := (0:ℤ)) (ylo := 1.1750365) (yhi := 1.17503651)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.418) (q1 := 1.432) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.69849446) (B := 0.7181446) (X := 4.31662916) (rho := 0.08200652)
    (clo := (-0.38551077)) (chi := (-0.38550937)) (C := (-0.38551007)) (h := 0.08200722)
    (by norm_num) (by norm_num) oscBlock47 vbpBr47.1 vbpBr48.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i48 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    (0.00021816:ℝ) ≤ ∫ v in (vBP 1.432)..(vBP 1.446), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.43578154) (m := (0:ℤ)) (ylo := 1.29418888) (yhi := 1.29418889)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.432) (q1 := 1.446) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.7181436) (B := 0.73760286) (X := 4.43578154) (rho := 0.08203599)
    (clo := (-0.27309722)) (chi := (-0.27309357)) (C := (-0.2730954)) (h := 0.08203782)
    (by norm_num) (by norm_num) oscBlock48 vbpBr48.1 vbpBr49.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i49 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    (0.00000106:ℝ) ≤ ∫ v in (vBP 1.446)..(vBP 1.462), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.5621651) (m := (0:ℤ)) (ylo := 1.42057244) (yhi := 1.42057245)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.446) (q1 := 1.462) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.73760153) (B := 0.75961158) (X := 4.5621651) (rho := 0.09045584)
    (clo := (-0.14966859)) (chi := (-0.14965935)) (C := (-0.14966397)) (h := 0.09046046)
    (by norm_num) (by norm_num) oscBlock49 vbpBr49.1 vbpBr50.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i50 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00019646):ℝ) ≤ ∫ v in (vBP 1.462)..(vBP 1.478), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.69554572) (m := (0:ℤ)) (ylo := 1.55395306) (yhi := 1.55395307)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.462) (q1 := 1.478) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.75960973) (B := 0.78138081) (X := 4.69554572) (rho := 0.09041175)
    (clo := (-0.01686469)) (chi := (-0.01684205)) (C := (-0.01685337)) (h := 0.09042307)
    (by norm_num) (by norm_num) oscBlock50 vbpBr50.1 vbpBr51.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i51 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00044219):ℝ) ≤ ∫ v in (vBP 1.478)..(vBP 1.495), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.83158087) (m := (0:ℤ)) (ylo := 0.11919188) (yhi := 0.11919189)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.478) (q1 := 1.495) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.7813783) (B := 0.80425401) (X := 4.83158087) (rho := 0.09447495)
    (clo := 0.11890985) (chi := 0.11890987) (C := 0.11890986) (h := 0.09447496)
    (by norm_num) (by norm_num) oscBlock51 vbpBr51.1 vbpBr52.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i52 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00067119):ℝ) ≤ ∫ v in (vBP 1.495)..(vBP 1.512), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.97016996) (m := (0:ℤ)) (ylo := 0.25778097) (yhi := 0.25778098)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.495) (q1 := 1.512) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.80425056) (B := 0.82686872) (X := 4.97016996) (rho := 0.09440096)
    (clo := 0.25493547) (chi := 0.25493549) (C := 0.25493548) (h := 0.09440097)
    (by norm_num) (by norm_num) oscBlock52 vbpBr52.1 vbpBr53.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i53 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00097822):ℝ) ≤ ∫ v in (vBP 1.512)..(vBP 1.531), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.11520763) (m := (0:ℤ)) (ylo := 0.40281864) (yhi := 0.40281865)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.512) (q1 := 1.531) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.82686405) (B := 0.85184522) (X := 5.11520763) (rho := 0.10234435)
    (clo := 0.39201293) (chi := 0.39201295) (C := 0.39201294) (h := 0.10234436)
    (by norm_num) (by norm_num) oscBlock53 vbpBr53.1 vbpBr54.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i54 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.001139):ℝ) ≤ ∫ v in (vBP 1.531)..(vBP 1.55), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.26646018) (m := (0:ℤ)) (ylo := 0.55407119) (yhi := 0.5540712)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.531) (q1 := 1.55) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.85183877) (B := 0.87651393) (X := 5.26646018) (rho := 0.10218765)
    (clo := 0.52615367) (chi := 0.52615369) (C := 0.52615368) (h := 0.10218766)
    (by norm_num) (by norm_num) oscBlock54 vbpBr54.1 vbpBr55.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i55 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00132171):ℝ) ≤ ∫ v in (vBP 1.55)..(vBP 1.57), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.41976137) (m := (0:ℤ)) (ylo := 0.70737238) (yhi := 0.70737239)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.55) (q1 := 1.57) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.87650515) (B := 0.90215678) (X := 5.41976137) (rho := 0.10594892)
    (clo := 0.64983883) (chi := 0.64983885) (C := 0.64983884) (h := 0.10594893)
    (by norm_num) (by norm_num) oscBlock55 vbpBr55.1 vbpBr56.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i56 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00138368):ℝ) ≤ ∫ v in (vBP 1.57)..(vBP 1.59), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.57502011) (m := (0:ℤ)) (ylo := 0.86263112) (yhi := 0.86263113)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.57) (q1 := 1.59) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.90214481) (B := 0.92747548) (X := 5.57502011) (rho := 0.10576722)
    (clo := 0.75955657) (chi := 0.7595566) (C := 0.75955658) (h := 0.10576724)
    (by norm_num) (by norm_num) oscBlock56 vbpBr56.1 vbpBr57.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i57 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00139901):ℝ) ≤ ∫ v in (vBP 1.59)..(vBP 1.61), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.72832591) (m := (0:ℤ)) (ylo := 1.01593692) (yhi := 1.01593693)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.59) (q1 := 1.61) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.92745939) (B := 0.95247825) (X := 5.72832591) (rho := 0.10560338)
    (clo := 0.84997451) (chi := 0.84997456) (C := 0.84997453) (h := 0.10560341)
    (by norm_num) (by norm_num) oscBlock57 vbpBr57.1 vbpBr58.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i58 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00149216):ℝ) ≤ ∫ v in (vBP 1.61)..(vBP 1.632), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.88723908) (m := (0:ℤ)) (ylo := 1.17485009) (yhi := 1.1748501)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.61) (q1 := 1.632) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.95245689) (B := 0.97962584) (X := 5.88723908) (rho := 0.1129692)
    (clo := 0.92263203) (chi := 0.92263219) (C := 0.90483141) (h := 0.09516859)
    (by norm_num) (by norm_num) oscBlock58 vbpBr58.1 vbpBr59.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i59 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00149999):ℝ) ≤ ∫ v in (vBP 1.632)..(vBP 1.656), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.05894019) (m := (0:ℤ)) (ylo := 1.3465512) (yhi := 1.34655121)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.632) (q1 := 1.656) (t0 := 6.0625) (t1 := 6.125)
    (A := 0.97959707) (B := 1.00882827) (X := 6.05894019) (rho := 0.12013297)
    (clo := 0.97496223) (chi := 0.97496291) (C := 0.92741463) (h := 0.07258537)
    (by norm_num) (by norm_num) oscBlock59 vbpBr59.1 vbpBr60.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i60 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00135601):ℝ) ≤ ∫ v in (vBP 1.656)..(vBP 1.68), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.23557849) (m := (0:ℤ)) (ylo := 1.5231895) (yhi := 1.52318951)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.656) (q1 := 1.68) (t0 := 6.0625) (t1 := 6.125)
    (A := 1.00878907) (B := 1.03761196) (X := 6.23557849) (rho := 0.11979477)
    (clo := 0.99886697) (chi := 0.99886954) (C := 0.9395361) (h := 0.0604639)
    (by norm_num) (by norm_num) oscBlock60 vbpBr60.1 vbpBr61.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i61 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00122808):ℝ) ≤ ∫ v in (vBP 1.68)..(vBP 1.704), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.40969349) (m := (1:ℤ)) (ylo := 0.12650818) (yhi := 0.12650819)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.68) (q1 := 1.704) (t0 := 6.0625) (t1 := 6.125)
    (A := 1.03755935) (B := 1.06598913) (X := 6.40969349) (rho := 0.11948995)
    (clo := 0.9920085) (chi := 0.99200851) (C := 0.93625927) (h := 0.06374073)
    (by norm_num) (by norm_num) oscBlock61 vbpBr61.1 vbpBr62.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i62 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00137159):ℝ) ≤ ∫ v in (vBP 1.704)..(vBP 1.734), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.60259546) (m := (1:ℤ)) (ylo := 0.31941015) (yhi := 0.31941016)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.704) (q1 := 1.734) (t0 := 6.0625) (t1 := 6.125)
    (A := 1.06591948) (B := 1.10090679) (X := 6.60259546) (rho := 0.14045864)
    (clo := 0.94942079) (chi := 0.94942081) (C := 0.90448107) (h := 0.09551893)
    (by norm_num) (by norm_num) oscBlock62 vbpBr62.1 vbpBr63.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i63 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00129873):ℝ) ≤ ∫ v in (vBP 1.734)..(vBP 1.766), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.82041424) (m := (1:ℤ)) (ylo := 0.53722893) (yhi := 0.53722894)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.734) (q1 := 1.766) (t0 := 6.0625) (t1 := 6.125)
    (A := 1.10080961) (B := 1.13749718) (X := 6.82041424) (rho := 0.146756)
    (clo := 0.85913008) (chi := 0.8591301) (C := 0.85618704) (h := 0.14381296)
    (by norm_num) (by norm_num) oscBlock63 vbpBr63.1 vbpBr64.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i64 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00093626):ℝ) ≤ ∫ v in (vBP 1.766)..(vBP 1.796), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.03445317) (m := (1:ℤ)) (ylo := 0.75126786) (yhi := 0.75126787)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.766) (q1 := 1.796) (t0 := 6.0625) (t1 := 6.125)
    (A := 1.1373613) (B := 1.17120873) (X := 7.03445317) (rho := 0.13920031)
    (clo := 0.73082405) (chi := 0.73082408) (C := 0.73082406) (h := 0.13920033)
    (by norm_num) (by norm_num) oscBlock64 vbpBr64.1 vbpBr65.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i65 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00075696):ℝ) ≤ ∫ v in (vBP 1.796)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.24476033) (m := (1:ℤ)) (ylo := 0.96157502) (yhi := 0.96157503)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.796) (q1 := 1.828) (t0 := 6.0625) (t1 := 6.125)
    (A := 1.1710258) (B := 1.20655947) (X := 7.24476033) (rho := 0.14541644)
    (clo := 0.57222902) (chi := 0.57222922) (C := 0.57222912) (h := 0.14541654)
    (by norm_num) (by norm_num) oscBlock65 vbpBr65.1 vbpBr66.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i66 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00051229):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.86), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.45813188) (m := (1:ℤ)) (ylo := 1.17494657) (yhi := 1.17494658)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.828) (q1 := 1.86) (t0 := 6.0625) (t1 := 6.125)
    (A := 1.20631244) (B := 1.24130524) (X := 7.45813188) (rho := 0.14486273)
    (clo := 0.38559234) (chi := 0.38559374) (C := 0.38559304) (h := 0.14486343)
    (by norm_num) (by norm_num) oscBlock66 vbpBr66.1 vbpBr67.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i67 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00026487):ℝ) ≤ ∫ v in (vBP 1.86)..(vBP 1.89), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.66134523) (m := (1:ℤ)) (ylo := 1.37815992) (yhi := 1.37815993)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.86) (q1 := 1.89) (t0 := 6.0625) (t1 := 6.125)
    (A := 1.24097685) (B := 1.27334993) (X := 7.66134523) (rho := 0.1379231)
    (clo := 0.19144709) (chi := 0.19145392) (C := 0.1914505) (h := 0.13792652)
    (by norm_num) (by norm_num) oscBlock67 vbpBr67.1 vbpBr68.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i68 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.0001168):ℝ) ≤ ∫ v in (vBP 1.89)..(vBP 1.922), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 7.86120558) (m := (1:ℤ)) (ylo := 0.00722394) (yhi := 0.00722395)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.89) (q1 := 1.922) (t0 := 6.0625) (t1 := 6.125)
    (A := 1.27292668) (B := 1.30698664) (X := 7.86120558) (rho := 0.1440876)
    (clo := (-0.00722389)) (chi := (-0.00722387)) (C := (-0.00722388)) (h := 0.14408761)
    (by norm_num) (by norm_num) oscBlock68 vbpBr68.1 vbpBr69.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i69 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00043437):ℝ) ≤ ∫ v in (vBP 1.922)..(vBP 1.969), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.11109994) (m := (1:ℤ)) (ylo := 0.2571183) (yhi := 0.25711831)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.922) (q1 := 1.969) (t0 := 6.0625) (t1 := 6.125)
    (A := 1.30643896) (B := 1.35541448) (X := 8.11109994) (rho := 0.19081376)
    (clo := (-0.25429466)) (chi := (-0.25429464)) (C := (-0.25429465)) (h := 0.19081377)
    (by norm_num) (by norm_num) oscBlock69 vbpBr69.1 vbpBr70.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i70 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00062466):ℝ) ≤ ∫ v in (vBP 1.969)..(vBP 2.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.40211079) (m := (1:ℤ)) (ylo := 0.54812915) (yhi := 0.54812916)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.969) (q1 := 2.016) (t0 := 6.0625) (t1 := 6.125)
    (A := 1.35463226) (B := 1.4027369) (X := 8.40211079) (rho := 0.18965273)
    (clo := (-0.52109138)) (chi := (-0.52109136)) (C := (-0.52109137)) (h := 0.18965274)
    (by norm_num) (by norm_num) oscBlock70 vbpBr70.1 vbpBr71.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i71 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.0007261):ℝ) ≤ ∫ v in (vBP 2.016)..(vBP 2.062), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.68336056) (m := (1:ℤ)) (ylo := 0.82937892) (yhi := 0.82937893)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.016) (q1 := 2.062) (t0 := 6.0625) (t1 := 6.125)
    (A := 1.40164597) (B := 1.44803958) (X := 8.68336056) (rho := 0.18588188)
    (clo := (-0.73751209)) (chi := (-0.73751207)) (C := (-0.73751208)) (h := 0.18588189)
    (by norm_num) (by norm_num) oscBlock71 vbpBr71.1 vbpBr72.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB12i72 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.00051115):ℝ) ≤ ∫ v in (vBP 2.062)..(vBP 2.094), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.9142977) (m := (1:ℤ)) (ylo := 1.06031606) (yhi := 1.06031607)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.062) (q1 := 2.094) (t0 := 6.0625) (t1 := 6.125)
    (A := 1.44655973) (B := 1.47899217) (X := 8.9142977) (rho := 0.14452935)
    (clo := (-0.87251001)) (chi := (-0.87250995)) (C := (-0.8639903)) (h := 0.1360097)
    (by norm_num) (by norm_num) oscBlock72 vbpBr72.1 vbpBr73.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

/-- Lower bound for the oscillatory integral `∫₀^∞ err(v) cos(tv) dv` on the band
`6.0625 ≤ t ≤ 6.125`. -/
theorem oscBandLower12 {t : ℝ} (ht0 : (6.0625:ℝ) ≤ t) (ht1 : t ≤ 6.125) :
    ((-0.12631229):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosB12i0 ht0 ht1)
    (cosB12i1 ht0 ht1))
    (cosB12i2 ht0 ht1))
    (cosB12i3 ht0 ht1))
    (cosB12i4 ht0 ht1))
    (cosB12i5 ht0 ht1))
    (cosB12i6 ht0 ht1))
    (cosB12i7 ht0 ht1))
    (cosB12i8 ht0 ht1))
    (cosB12i9 ht0 ht1))
    (cosB12i10 ht0 ht1))
    (cosB12i11 ht0 ht1))
    (cosB12i12 ht0 ht1))
    (cosB12i13 ht0 ht1))
    (cosB12i14 ht0 ht1))
    (cosB12i15 ht0 ht1))
    (cosB12i16 ht0 ht1))
    (cosB12i17 ht0 ht1))
    (cosB12i18 ht0 ht1))
    (cosB12i19 ht0 ht1))
    (cosB12i20 ht0 ht1))
    (cosB12i21 ht0 ht1))
    (cosB12i22 ht0 ht1))
    (cosB12i23 ht0 ht1))
    (cosB12i24 ht0 ht1))
    (cosB12i25 ht0 ht1))
    (cosB12i26 ht0 ht1))
    (cosB12i27 ht0 ht1))
    (cosB12i28 ht0 ht1))
    (cosB12i29 ht0 ht1))
    (cosB12i30 ht0 ht1))
    (cosB12i31 ht0 ht1))
    (cosB12i32 ht0 ht1))
    (cosB12i33 ht0 ht1))
    (cosB12i34 ht0 ht1))
    (cosB12i35 ht0 ht1))
    (cosB12i36 ht0 ht1))
    (cosB12i37 ht0 ht1))
    (cosB12i38 ht0 ht1))
    (cosB12i39 ht0 ht1))
    (cosB12i40 ht0 ht1))
    (cosB12i41 ht0 ht1))
    (cosB12i42 ht0 ht1))
    (cosB12i43 ht0 ht1))
    (cosB12i44 ht0 ht1))
    (cosB12i45 ht0 ht1))
    (cosB12i46 ht0 ht1))
    (cosB12i47 ht0 ht1))
    (cosB12i48 ht0 ht1))
    (cosB12i49 ht0 ht1))
    (cosB12i50 ht0 ht1))
    (cosB12i51 ht0 ht1))
    (cosB12i52 ht0 ht1))
    (cosB12i53 ht0 ht1))
    (cosB12i54 ht0 ht1))
    (cosB12i55 ht0 ht1))
    (cosB12i56 ht0 ht1))
    (cosB12i57 ht0 ht1))
    (cosB12i58 ht0 ht1))
    (cosB12i59 ht0 ht1))
    (cosB12i60 ht0 ht1))
    (cosB12i61 ht0 ht1))
    (cosB12i62 ht0 ht1))
    (cosB12i63 ht0 ht1))
    (cosB12i64 ht0 ht1))
    (cosB12i65 ht0 ht1))
    (cosB12i66 ht0 ht1))
    (cosB12i67 ht0 ht1))
    (cosB12i68 ht0 ht1))
    (cosB12i69 ht0 ht1))
    (cosB12i70 ht0 ht1))
    (cosB12i71 ht0 ht1))
    (cosB12i72 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 2.094) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 2.094) (S := 0.013709)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_cut
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
