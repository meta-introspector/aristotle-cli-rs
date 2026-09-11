/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscTail

/-!
# Oscillatory lower bound on the band `6.1875 ≤ t ≤ 6.25`

On each of the 73 blocks the factor `cos(tv)` is bracketed by a rational constant
`C` up to a rational error `h`; the signed contribution `min(C·P₀, C·P₁) - h·S` is
then summed, and the unresolved tail beyond `q = 2.094` is estimated in absolute
value.  The result is the bound `∫₀^∞ err(v) cos(tv) dv ≥ -0.13054338`.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosB10i0 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00641868):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.0038), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.023705) (m := (0:ℤ)) (ylo := 0.023705) (yhi := 0.023705)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1) (q1 := 1.0038) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.0) (B := 0.0075856) (X := 0.023705) (rho := 0.02370501)
    (clo := 0.99971904) (chi := 0.99971905) (C := 0.98800701) (h := 0.01199299)
    (by norm_num) (by norm_num) oscBlock0 vbpBr0.1 vbpBr1.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i1 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00625872):ℝ) ≤ ∫ v in (vBP 1.0038)..(vBP 1.0078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.07202879) (m := (0:ℤ)) (ylo := 0.07202879) (yhi := 0.07202879)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0038) (q1 := 1.0078) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.00758559) (B := 0.01553948) (X := 0.07202879) (rho := 0.02509297)
    (clo := 0.99740704) (chi := 0.99740705) (C := 0.98615703) (h := 0.01384297)
    (by norm_num) (by norm_num) oscBlock1 vbpBr1.1 vbpBr2.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i2 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.0057677):ℝ) ≤ ∫ v in (vBP 1.0078)..(vBP 1.0118), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.12139351) (m := (0:ℤ)) (ylo := 0.12139351) (yhi := 0.12139351)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0078) (q1 := 1.0118) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.01553947) (B := 0.02346185) (X := 0.12139351) (rho := 0.02524306)
    (clo := 0.99264085) (chi := 0.99264086) (C := 0.98369889) (h := 0.01630111)
    (by norm_num) (by norm_num) oscBlock2 vbpBr2.1 vbpBr3.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i3 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00554846):ℝ) ≤ ∫ v in (vBP 1.0118)..(vBP 1.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.1717935) (m := (0:ℤ)) (ylo := 0.1717935) (yhi := 0.1717935)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0118) (q1 := 1.016) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.02346184) (B := 0.0317467) (X := 0.1717935) (rho := 0.02662338)
    (clo := 0.98527975) (chi := 0.98527976) (C := 0.97932818) (h := 0.02067182)
    (by norm_num) (by norm_num) oscBlock3 vbpBr3.1 vbpBr4.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i4 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00539232):ℝ) ≤ ∫ v in (vBP 1.016)..(vBP 1.0205), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.22504572) (m := (0:ℤ)) (ylo := 0.22504572) (yhi := 0.22504572)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.016) (q1 := 1.0205) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.03174669) (B := 0.04058541) (X := 0.22504572) (rho := 0.0286131)
    (clo := 0.9747839) (chi := 0.97478391) (C := 0.9730854) (h := 0.0269146)
    (by norm_num) (by norm_num) oscBlock4 vbpBr4.1 vbpBr5.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i5 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00480175):ℝ) ≤ ∫ v in (vBP 1.0205)..(vBP 1.025), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.27988992) (m := (0:ℤ)) (ylo := 0.27988992) (yhi := 0.27988992)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0205) (q1 := 1.025) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.0405854) (B := 0.04938523) (X := 0.27988992) (rho := 0.02876778)
    (clo := 0.96108585) (chi := 0.96108586) (C := 0.96108585) (h := 0.02876779)
    (by norm_num) (by norm_num) oscBlock5 vbpBr5.1 vbpBr6.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i6 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00467362):ℝ) ≤ ∫ v in (vBP 1.025)..(vBP 1.03), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.33752805) (m := (0:ℤ)) (ylo := 0.33752805) (yhi := 0.33752805)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.025) (q1 := 1.03) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.04938522) (B := 0.05911761) (X := 0.33752805) (rho := 0.03195702)
    (clo := 0.94357614) (chi := 0.94357615) (C := 0.94357614) (h := 0.03195703)
    (by norm_num) (by norm_num) oscBlock6 vbpBr6.1 vbpBr7.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i7 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00436533):ℝ) ≤ ∫ v in (vBP 1.03)..(vBP 1.0355), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.4009226) (m := (0:ℤ)) (ylo := 0.4009226) (yhi := 0.4009226)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.03) (q1 := 1.0355) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.0591176) (B := 0.06976881) (X := 0.4009226) (rho := 0.03513247)
    (clo := 0.92070132) (chi := 0.92070133) (C := 0.92070132) (h := 0.03513248)
    (by norm_num) (by norm_num) oscBlock7 vbpBr7.1 vbpBr8.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i8 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00389807):ℝ) ≤ ∫ v in (vBP 1.0355)..(vBP 1.0415), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.46998463) (m := (0:ℤ)) (ylo := 0.46998463) (yhi := 0.46998463)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0355) (q1 := 1.0415) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.0697688) (B := 0.08132397) (X := 0.46998463) (rho := 0.0382902)
    (clo := 0.89157524) (chi := 0.89157525) (C := 0.89157524) (h := 0.03829021)
    (by norm_num) (by norm_num) oscBlock8 vbpBr8.1 vbpBr9.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i9 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00329934):ℝ) ≤ ∫ v in (vBP 1.0415)..(vBP 1.048), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.54461843) (m := (0:ℤ)) (ylo := 0.54461843) (yhi := 0.54461843)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0415) (q1 := 1.048) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.08132396) (B := 0.09376718) (X := 0.54461843) (rho := 0.04142645)
    (clo := 0.85532504) (chi := 0.85532505) (C := 0.85532504) (h := 0.04142646)
    (by norm_num) (by norm_num) oscBlock9 vbpBr9.1 vbpBr10.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i10 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00262261):ℝ) ≤ ∫ v in (vBP 1.048)..(vBP 1.055), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.62472199) (m := (0:ℤ)) (ylo := 0.62472199) (yhi := 0.62472199)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.048) (q1 := 1.055) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.09376717) (B := 0.10708154) (X := 0.62472199) (rho := 0.04453765)
    (clo := 0.81112575) (chi := 0.81112576) (C := 0.81112575) (h := 0.04453766)
    (by norm_num) (by norm_num) oscBlock10 vbpBr10.1 vbpBr11.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i11 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.0021569):ℝ) ≤ ∫ v in (vBP 1.055)..(vBP 1.064), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.7190047) (m := (0:ℤ)) (ylo := 0.7190047) (yhi := 0.7190047)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.055) (q1 := 1.064) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.10708153) (B := 0.12407079) (X := 0.7190047) (rho := 0.05643775)
    (clo := 0.75246164) (chi := 0.75246166) (C := 0.75246165) (h := 0.05643776)
    (by norm_num) (by norm_num) oscBlock11 vbpBr11.1 vbpBr12.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i12 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00138234):ℝ) ≤ ∫ v in (vBP 1.064)..(vBP 1.078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.85326569) (m := (0:ℤ)) (ylo := 0.85326569) (yhi := 0.85326569)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.064) (q1 := 1.078) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.12407078) (B := 0.15021495) (X := 0.85326569) (rho := 0.08557776)
    (clo := 0.65752618) (chi := 0.65752624) (C := 0.65752621) (h := 0.08557779)
    (by norm_num) (by norm_num) oscBlock12 vbpBr12.1 vbpBr13.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i13 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    (0.00014999:ℝ) ≤ ∫ v in (vBP 1.078)..(vBP 1.09), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.00333809) (m := (0:ℤ)) (ylo := 1.00333809) (yhi := 1.00333809)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.078) (q1 := 1.09) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.15021494) (B := 0.1723554) (X := 1.00333809) (rho := 0.07388317)
    (clo := 0.53749039) (chi := 0.53749068) (C := 0.53749053) (h := 0.07388332)
    (by norm_num) (by norm_num) oscBlock13 vbpBr13.1 vbpBr14.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i14 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    (0.00060484:ℝ) ≤ ∫ v in (vBP 1.09)..(vBP 1.1), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.12891311) (m := (0:ℤ)) (ylo := 1.12891311) (yhi := 1.12891311)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.09) (q1 := 1.1) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.17235539) (B := 0.19062036) (X := 1.12891311) (rho := 0.06246415)
    (clo := 0.42764254) (chi := 0.42764347) (C := 0.427643) (h := 0.06246462)
    (by norm_num) (by norm_num) oscBlock14 vbpBr14.1 vbpBr15.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i15 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    (0.00062716:ℝ) ≤ ∫ v in (vBP 1.1)..(vBP 1.109), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.23634864) (m := (0:ℤ)) (ylo := 1.23634864) (yhi := 1.23634864)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.1) (q1 := 1.109) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.19062035) (B := 0.20691742) (X := 1.23634864) (rho := 0.05688524)
    (clo := 0.32824748) (chi := 0.32824979) (C := 0.32824863) (h := 0.0568864)
    (by norm_num) (by norm_num) oscBlock15 vbpBr15.1 vbpBr16.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i16 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    (0.00047078:ℝ) ≤ ∫ v in (vBP 1.109)..(vBP 1.117), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.33169151) (m := (0:ℤ)) (ylo := 1.33169151) (yhi := 1.33169151)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.109) (q1 := 1.117) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.20691741) (B := 0.22129305) (X := 1.33169151) (rho := 0.05139006)
    (clo := 0.23683294) (chi := 0.23683778) (C := 0.23683536) (h := 0.05139248)
    (by norm_num) (by norm_num) oscBlock16 vbpBr16.1 vbpBr17.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i17 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    (0.00027131:ℝ) ≤ ∫ v in (vBP 1.117)..(vBP 1.124), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.41521131) (m := (0:ℤ)) (ylo := 1.41521131) (yhi := 1.41521131)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.117) (q1 := 1.124) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.22129304) (B := 0.23378751) (X := 1.41521131) (rho := 0.04596064)
    (clo := 0.15495794) (chi := 0.15496683) (C := 0.15496238) (h := 0.04596509)
    (by norm_num) (by norm_num) oscBlock17 vbpBr17.1 vbpBr18.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i18 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    (0.00007278:ℝ) ≤ ∫ v in (vBP 1.124)..(vBP 1.131), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.49266882) (m := (0:ℤ)) (ylo := 1.49266882) (yhi := 1.49266882)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.124) (q1 := 1.131) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.2337875) (B := 0.2462044) (X := 1.49266882) (rho := 0.04610869)
    (clo := 0.07804779) (chi := 0.07806293) (C := 0.07805536) (h := 0.04611626)
    (by norm_num) (by norm_num) oscBlock18 vbpBr18.1 vbpBr19.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i19 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00016304):ℝ) ≤ ∫ v in (vBP 1.131)..(vBP 1.138), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.56964695) (m := (0:ℤ)) (ylo := 1.56964695) (yhi := 1.56964695)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.131) (q1 := 1.138) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.24620439) (B := 0.25854468) (X := 1.56964695) (rho := 0.04625731)
    (clo := 0.00114891) (chi := 0.00117394) (C := 0.00116142) (h := 0.04626983)
    (by norm_num) (by norm_num) oscBlock19 vbpBr19.1 vbpBr20.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i20 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00045313):ℝ) ≤ ∫ v in (vBP 1.138)..(vBP 1.145), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.64615157) (m := (0:ℤ)) (ylo := 0.07535524) (yhi := 0.07535525)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.138) (q1 := 1.145) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.25854467) (B := 0.27080928) (X := 1.64615157) (rho := 0.04640644)
    (clo := (-0.07528396)) (chi := (-0.07528394)) (C := (-0.07528395)) (h := 0.04640645)
    (by norm_num) (by norm_num) oscBlock20 vbpBr20.1 vbpBr21.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i21 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00075597):ℝ) ≤ ∫ v in (vBP 1.145)..(vBP 1.152), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.72218846) (m := (0:ℤ)) (ylo := 0.15139213) (yhi := 0.15139214)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.145) (q1 := 1.152) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.27080927) (B := 0.28299913) (X := 1.72218846) (rho := 0.04655612)
    (clo := (-0.1508145)) (chi := (-0.15081448)) (C := (-0.15081449)) (h := 0.04655613)
    (by norm_num) (by norm_num) oscBlock21 vbpBr21.1 vbpBr22.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i22 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.0010602):ℝ) ≤ ∫ v in (vBP 1.152)..(vBP 1.159), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.7977633) (m := (0:ℤ)) (ylo := 0.22696697) (yhi := 0.22696698)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.152) (q1 := 1.159) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.28299912) (B := 0.29511513) (X := 1.7977633) (rho := 0.04670627)
    (clo := (-0.22502333)) (chi := (-0.22502332)) (C := (-0.22502333)) (h := 0.04670628)
    (by norm_num) (by norm_num) oscBlock22 vbpBr22.1 vbpBr23.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i23 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00135509):ℝ) ≤ ∫ v in (vBP 1.159)..(vBP 1.166), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.87288171) (m := (0:ℤ)) (ylo := 0.30208538) (yhi := 0.30208539)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.159) (q1 := 1.166) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.29511512) (B := 0.30715818) (X := 1.87288171) (rho := 0.04685692)
    (clo := (-0.29751182)) (chi := (-0.2975118)) (C := (-0.29751181)) (h := 0.04685693)
    (by norm_num) (by norm_num) oscBlock23 vbpBr23.1 vbpBr24.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i24 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00163176):ℝ) ≤ ∫ v in (vBP 1.166)..(vBP 1.173), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.94754915) (m := (0:ℤ)) (ylo := 0.37675282) (yhi := 0.37675283)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.166) (q1 := 1.173) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.30715817) (B := 0.31912914) (X := 1.94754915) (rho := 0.04700799)
    (clo := (-0.36790299)) (chi := (-0.36790297)) (C := (-0.36790298)) (h := 0.047008)
    (by norm_num) (by norm_num) oscBlock24 vbpBr24.1 vbpBr25.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i25 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00188266):ℝ) ≤ ∫ v in (vBP 1.173)..(vBP 1.18), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.02177099) (m := (0:ℤ)) (ylo := 0.45097466) (yhi := 0.45097467)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.173) (q1 := 1.18) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.31912913) (B := 0.33102888) (X := 2.02177099) (rho := 0.04715952)
    (clo := (-0.43584297)) (chi := (-0.43584295)) (C := (-0.43584296)) (h := 0.04715953)
    (by norm_num) (by norm_num) oscBlock25 vbpBr25.1 vbpBr26.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i26 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00210156):ℝ) ≤ ∫ v in (vBP 1.18)..(vBP 1.187), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.09555256) (m := (0:ℤ)) (ylo := 0.52475623) (yhi := 0.52475624)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.18) (q1 := 1.187) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.33102887) (B := 0.34285824) (X := 2.09555256) (rho := 0.04731145)
    (clo := (-0.50100206)) (chi := (-0.50100204)) (C := (-0.50100205)) (h := 0.04731146)
    (by norm_num) (by norm_num) oscBlock26 vbpBr26.1 vbpBr27.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i27 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00228363):ℝ) ≤ ∫ v in (vBP 1.187)..(vBP 1.194), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.16889902) (m := (0:ℤ)) (ylo := 0.59810269) (yhi := 0.5981027)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.187) (q1 := 1.194) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.34285823) (B := 0.35461804) (X := 2.16889902) (rho := 0.04746374)
    (clo := (-0.56307555)) (chi := (-0.56307554)) (C := (-0.56307555)) (h := 0.04746375)
    (by norm_num) (by norm_num) oscBlock27 vbpBr27.1 vbpBr28.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i28 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00245028):ℝ) ≤ ∫ v in (vBP 1.194)..(vBP 1.201), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.2418154) (m := (0:ℤ)) (ylo := 0.67101907) (yhi := 0.67101908)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.194) (q1 := 1.201) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.35461802) (B := 0.36630909) (X := 2.2418154) (rho := 0.04761642)
    (clo := (-0.62178445)) (chi := (-0.62178443)) (C := (-0.62178444)) (h := 0.04761643)
    (by norm_num) (by norm_num) oscBlock28 vbpBr28.1 vbpBr29.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i29 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00255119):ℝ) ≤ ∫ v in (vBP 1.201)..(vBP 1.208), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.31430684) (m := (0:ℤ)) (ylo := 0.74351051) (yhi := 0.74351052)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.201) (q1 := 1.208) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.36630908) (B := 0.3779322) (X := 2.31430684) (rho := 0.04776942)
    (clo := (-0.67687617)) (chi := (-0.67687615)) (C := (-0.67687616)) (h := 0.04776943)
    (by norm_num) (by norm_num) oscBlock29 vbpBr29.1 vbpBr30.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i30 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00260854):ℝ) ≤ ∫ v in (vBP 1.208)..(vBP 1.215), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.38637821) (m := (0:ℤ)) (ylo := 0.81558188) (yhi := 0.81558189)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.208) (q1 := 1.215) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.37793219) (B := 0.38948816) (X := 2.38637821) (rho := 0.0479228)
    (clo := (-0.72812458)) (chi := (-0.72812456)) (C := (-0.72812457)) (h := 0.04792281)
    (by norm_num) (by norm_num) oscBlock30 vbpBr30.1 vbpBr31.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i31 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00301494):ℝ) ≤ ∫ v in (vBP 1.215)..(vBP 1.223), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.46314683) (m := (0:ℤ)) (ylo := 0.8923505) (yhi := 0.89235051)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.215) (q1 := 1.223) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.38948815) (B := 0.40261372) (X := 2.46314683) (rho := 0.05318893)
    (clo := (-0.77854905)) (chi := (-0.77854903)) (C := (-0.77854904)) (h := 0.05318894)
    (by norm_num) (by norm_num) oscBlock31 vbpBr31.1 vbpBr32.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i32 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00296981):ℝ) ≤ ∫ v in (vBP 1.223)..(vBP 1.231), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.54450397) (m := (0:ℤ)) (ylo := 0.97370764) (yhi := 0.97370765)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.223) (q1 := 1.231) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.40261371) (B := 0.4156537) (X := 2.54450397) (rho := 0.05333166)
    (clo := (-0.826976)) (chi := (-0.82697596)) (C := (-0.82697598)) (h := 0.05333168)
    (by norm_num) (by norm_num) oscBlock32 vbpBr32.1 vbpBr33.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i33 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00286673):ℝ) ≤ ∫ v in (vBP 1.231)..(vBP 1.239), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.62533238) (m := (0:ℤ)) (ylo := 1.05453605) (yhi := 1.05453606)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.231) (q1 := 1.239) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.41565369) (B := 0.42860921) (X := 2.62533238) (rho := 0.05347519)
    (clo := (-0.86967136)) (chi := (-0.8696713)) (C := (-0.86967133)) (h := 0.05347522)
    (by norm_num) (by norm_num) oscBlock33 vbpBr33.1 vbpBr34.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i34 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00305356):ℝ) ≤ ∫ v in (vBP 1.239)..(vBP 1.248), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.71064893) (m := (0:ℤ)) (ylo := 1.1398526) (yhi := 1.13985261)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.239) (q1 := 1.248) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.4286092) (B := 0.44308455) (X := 2.71064893) (rho := 0.05862952)
    (clo := (-0.90857205)) (chi := (-0.90857193)) (C := (-0.90857199)) (h := 0.05862958)
    (by norm_num) (by norm_num) oscBlock34 vbpBr34.1 vbpBr35.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i35 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00307603):ℝ) ≤ ∫ v in (vBP 1.248)..(vBP 1.258), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.80531251) (m := (0:ℤ)) (ylo := 1.23451618) (yhi := 1.23451619)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.248) (q1 := 1.258) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.44308453) (B := 0.45904632) (X := 2.80531251) (rho := 0.063727)
    (clo := (-0.94398892)) (chi := (-0.94398866)) (C := (-0.94013083)) (h := 0.05986917)
    (by norm_num) (by norm_num) oscBlock35 vbpBr35.1 vbpBr36.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i36 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00264809):ℝ) ≤ ∫ v in (vBP 1.258)..(vBP 1.268), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.90417989) (m := (0:ℤ)) (ylo := 1.33338356) (yhi := 1.33338357)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.258) (q1 := 1.268) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.45904631) (B := 0.47488172) (X := 2.90417989) (rho := 0.06383087)
    (clo := (-0.97195031)) (chi := (-0.9719497)) (C := (-0.95405942)) (h := 0.04594059)
    (by norm_num) (by norm_num) oscBlock36 vbpBr36.1 vbpBr37.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i37 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00261049):ℝ) ≤ ∫ v in (vBP 1.268)..(vBP 1.28), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.01204079) (m := (0:ℤ)) (ylo := 1.44124446) (yhi := 1.44124447)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.268) (q1 := 1.28) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.4748817) (B := 0.49372017) (X := 3.01204079) (rho := 0.07371029)
    (clo := (-0.99162127)) (chi := (-0.99161986)) (C := (-0.95895479)) (h := 0.04104522)
    (by norm_num) (by norm_num) oscBlock37 vbpBr37.1 vbpBr38.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i38 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.0022862):ℝ) ≤ ∫ v in (vBP 1.28)..(vBP 1.294), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.13831046) (m := (0:ℤ)) (ylo := 1.56751413) (yhi := 1.56751414)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.28) (q1 := 1.294) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.49372014) (B := 0.51547641) (X := 3.13831046) (rho := 0.08341711)
    (clo := (-0.99999808)) (chi := (-0.99999455)) (C := (-0.95828872)) (h := 0.04171128)
    (by norm_num) (by norm_num) oscBlock38 vbpBr38.1 vbpBr39.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i39 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00152769):ℝ) ≤ ∫ v in (vBP 1.294)..(vBP 1.308), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.27287545) (m := (0:ℤ)) (ylo := 0.13128279) (yhi := 0.1312828)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.294) (q1 := 1.308) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.51547638) (B := 0.53699853) (X := 3.27287545) (rho := 0.08336537)
    (clo := (-0.99139479)) (chi := (-0.99139478)) (C := (-0.95401471)) (h := 0.0459853)
    (by norm_num) (by norm_num) oscBlock39 vbpBr39.1 vbpBr40.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i40 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00099679):ℝ) ≤ ∫ v in (vBP 1.308)..(vBP 1.326), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.42488223) (m := (0:ℤ)) (ylo := 0.28328957) (yhi := 0.28328958)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.308) (q1 := 1.326) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.53699848) (B := 0.56433382) (X := 3.42488223) (rho := 0.10220415)
    (clo := (-0.96014115)) (chi := (-0.96014114)) (C := (-0.9289685)) (h := 0.07103151)
    (by norm_num) (by norm_num) oscBlock40 vbpBr40.1 vbpBr41.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i41 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00007195):ℝ) ≤ ∫ v in (vBP 1.326)..(vBP 1.345), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.59837025) (m := (0:ℤ)) (ylo := 0.45677759) (yhi := 0.4567776)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.326) (q1 := 1.345) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.56433374) (B := 0.59278808) (X := 3.59837025) (rho := 0.10655526)
    (clo := (-0.89747843)) (chi := (-0.89747842)) (C := (-0.89546158)) (h := 0.10453842)
    (by norm_num) (by norm_num) oscBlock41 vbpBr41.1 vbpBr42.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i42 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    (0.00070183:ℝ) ≤ ∫ v in (vBP 1.345)..(vBP 1.362), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.76490181) (m := (0:ℤ)) (ylo := 0.62330915) (yhi := 0.62330916)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.345) (q1 := 1.362) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.59278796) (B := 0.6179085) (X := 3.76490181) (rho := 0.09702633)
    (clo := (-0.81195128)) (chi := (-0.81195126)) (C := (-0.81195127)) (h := 0.09702634)
    (by norm_num) (by norm_num) oscBlock42 vbpBr42.1 vbpBr43.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i43 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    (0.00078098:ℝ) ≤ ∫ v in (vBP 1.362)..(vBP 1.376), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.90653383) (m := (0:ℤ)) (ylo := 0.76494117) (yhi := 0.76494118)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.362) (q1 := 1.376) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.61790831) (B := 0.6383616) (X := 3.90653383) (rho := 0.08322618)
    (clo := (-0.72142312)) (chi := (-0.72142309)) (C := (-0.72142311)) (h := 0.0832262)
    (by norm_num) (by norm_num) oscBlock43 vbpBr43.1 vbpBr44.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i44 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    (0.00078725:ℝ) ≤ ∫ v in (vBP 1.376)..(vBP 1.39), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.03307933) (m := (0:ℤ)) (ylo := 0.89148667) (yhi := 0.89148668)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.376) (q1 := 1.39) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.63836133) (B := 0.65860767) (X := 4.03307933) (rho := 0.08321862)
    (clo := (-0.62825617)) (chi := (-0.62825607)) (C := (-0.62825612)) (h := 0.08321867)
    (by norm_num) (by norm_num) oscBlock44 vbpBr44.1 vbpBr45.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i45 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    (0.00068337:ℝ) ≤ ∫ v in (vBP 1.39)..(vBP 1.404), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.15835024) (m := (0:ℤ)) (ylo := 1.01675758) (yhi := 1.01675759)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.39) (q1 := 1.404) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.65860729) (B := 0.67865086) (X := 4.15835024) (rho := 0.08321765)
    (clo := (-0.52612642)) (chi := (-0.52612607)) (C := (-0.52612625)) (h := 0.08321783)
    (by norm_num) (by norm_num) oscBlock45 vbpBr45.1 vbpBr46.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i46 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    (0.00050695:ℝ) ≤ ∫ v in (vBP 1.404)..(vBP 1.418), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.28237192) (m := (0:ℤ)) (ylo := 1.14077926) (yhi := 1.14077927)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.404) (q1 := 1.418) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.67865033) (B := 0.69849519) (X := 4.28237192) (rho := 0.08322303)
    (clo := (-0.41688734)) (chi := (-0.41688629)) (C := (-0.41688682)) (h := 0.08322356)
    (by norm_num) (by norm_num) oscBlock46 vbpBr46.1 vbpBr47.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i47 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    (0.00029728:ℝ) ≤ ∫ v in (vBP 1.418)..(vBP 1.432), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.40516911) (m := (0:ℤ)) (ylo := 1.26357645) (yhi := 1.26357646)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.418) (q1 := 1.432) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.69849446) (B := 0.7181446) (X := 4.40516911) (rho := 0.08323465)
    (clo := (-0.30241269)) (chi := (-0.30240981)) (C := (-0.30241125)) (h := 0.08323609)
    (by norm_num) (by norm_num) oscBlock47 vbpBr47.1 vbpBr48.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i48 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    (0.00009071:ℝ) ≤ ∫ v in (vBP 1.432)..(vBP 1.446), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.5267657) (m := (0:ℤ)) (ylo := 1.38517304) (yhi := 1.38517305)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.432) (q1 := 1.446) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.7181436) (B := 0.73760286) (X := 4.5267657) (rho := 0.08325219)
    (clo := (-0.18456622)) (chi := (-0.18455903)) (C := (-0.18456263)) (h := 0.08325579)
    (by norm_num) (by norm_num) oscBlock48 vbpBr48.1 vbpBr49.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i49 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00012558):ℝ) ≤ ∫ v in (vBP 1.446)..(vBP 1.462), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.65574092) (m := (0:ℤ)) (ylo := 1.51414826) (yhi := 1.51414827)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.446) (q1 := 1.462) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.73760153) (B := 0.75961158) (X := 4.65574092) (rho := 0.09183147)
    (clo := (-0.05663494)) (chi := (-0.05661746)) (C := (-0.0566262)) (h := 0.09184021)
    (by norm_num) (by norm_num) oscBlock49 vbpBr49.1 vbpBr50.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i50 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00035927):ℝ) ≤ ∫ v in (vBP 1.462)..(vBP 1.478), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.79185763) (m := (0:ℤ)) (ylo := 0.07946864) (yhi := 0.07946865)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.462) (q1 := 1.478) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.75960973) (B := 0.78138081) (X := 4.79185763) (rho := 0.09177244)
    (clo := 0.07938502) (chi := 0.07938504) (C := 0.07938503) (h := 0.09177245)
    (by norm_num) (by norm_num) oscBlock50 vbpBr50.1 vbpBr51.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i51 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00064751):ℝ) ≤ ∫ v in (vBP 1.478)..(vBP 1.495), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.93068289) (m := (0:ℤ)) (ylo := 0.2182939) (yhi := 0.21829391)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.478) (q1 := 1.495) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.7813783) (B := 0.80425401) (X := 4.93068289) (rho := 0.09590468)
    (clo := 0.21656432) (chi := 0.21656434) (C := 0.21656433) (h := 0.09590469)
    (by norm_num) (by norm_num) oscBlock51 vbpBr51.1 vbpBr52.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i52 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00086043):ℝ) ≤ ∫ v in (vBP 1.495)..(vBP 1.512), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.07211492) (m := (0:ℤ)) (ylo := 0.35972593) (yhi := 0.35972594)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.495) (q1 := 1.512) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.80425056) (B := 0.82686872) (X := 5.07211492) (rho := 0.09581459)
    (clo := 0.35201771) (chi := 0.35201773) (C := 0.35201772) (h := 0.0958146)
    (by norm_num) (by norm_num) oscBlock52 vbpBr52.1 vbpBr53.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i53 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00116769):ℝ) ≤ ∫ v in (vBP 1.512)..(vBP 1.531), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.22012696) (m := (0:ℤ)) (ylo := 0.50773797) (yhi := 0.50773798)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.512) (q1 := 1.531) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.82686405) (B := 0.85184522) (X := 5.22012696) (rho := 0.10390567)
    (clo := 0.48620182) (chi := 0.48620184) (C := 0.48620183) (h := 0.10390568)
    (by norm_num) (by norm_num) oscBlock53 vbpBr53.1 vbpBr54.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i54 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00130243):ℝ) ≤ ∫ v in (vBP 1.531)..(vBP 1.55), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.37448222) (m := (0:ℤ)) (ylo := 0.66209323) (yhi := 0.66209324)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.531) (q1 := 1.55) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.85183877) (B := 0.87651393) (X := 5.37448222) (rho := 0.10372985)
    (clo := 0.61476914) (chi := 0.61476916) (C := 0.61476915) (h := 0.10372986)
    (by norm_num) (by norm_num) oscBlock54 vbpBr54.1 vbpBr55.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i55 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00146496):ℝ) ≤ ∫ v in (vBP 1.55)..(vBP 1.57), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.53092774) (m := (0:ℤ)) (ylo := 0.81853875) (yhi := 0.81853876)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.55) (q1 := 1.57) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.87650515) (B := 0.90215678) (X := 5.53092774) (rho := 0.10755214)
    (clo := 0.73014815) (chi := 0.73014817) (C := 0.73014816) (h := 0.10755215)
    (by norm_num) (by norm_num) oscBlock55 vbpBr55.1 vbpBr56.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i56 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00149696):ℝ) ≤ ∫ v in (vBP 1.57)..(vBP 1.59), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.68937138) (m := (0:ℤ)) (ylo := 0.97698239) (yhi := 0.9769824)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.57) (q1 := 1.59) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.90214481) (B := 0.92747548) (X := 5.68937138) (rho := 0.10735038)
    (clo := 0.82881271) (chi := 0.82881274) (C := 0.82881272) (h := 0.1073504)
    (by norm_num) (by norm_num) oscBlock56 vbpBr56.1 vbpBr57.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i57 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00146404):ℝ) ≤ ∫ v in (vBP 1.59)..(vBP 1.61), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.84582201) (m := (0:ℤ)) (ylo := 1.13343302) (yhi := 1.13343303)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.59) (q1 := 1.61) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.92745939) (B := 0.95247825) (X := 5.84582201) (rho := 0.10716706)
    (clo := 0.90587158) (chi := 0.9058717) (C := 0.89935226) (h := 0.10064774)
    (by norm_num) (by norm_num) oscBlock57 vbpBr57.1 vbpBr58.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i58 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00149216):ℝ) ≤ ∫ v in (vBP 1.61)..(vBP 1.632), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.00799425) (m := (0:ℤ)) (ylo := 1.29560526) (yhi := 1.29560527)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.61) (q1 := 1.632) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.95245689) (B := 0.97962584) (X := 6.00799425) (rho := 0.11466726)
    (clo := 0.96237329) (chi := 0.96237373) (C := 0.92385301) (h := 0.07614699)
    (by norm_num) (by norm_num) oscBlock58 vbpBr58.1 vbpBr59.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i59 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00149999):ℝ) ≤ ∫ v in (vBP 1.632)..(vBP 1.656), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.18321677) (m := (0:ℤ)) (ylo := 1.47082778) (yhi := 1.47082779)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.632) (q1 := 1.656) (t0 := 6.1875) (t1 := 6.25)
    (A := 0.97959707) (B := 1.00882827) (X := 6.18321677) (rho := 0.12195992)
    (clo := 0.99500728) (chi := 0.99500903) (C := 0.93652368) (h := 0.06347632)
    (by norm_num) (by norm_num) oscBlock59 vbpBr59.1 vbpBr60.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i60 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00135601):ℝ) ≤ ∫ v in (vBP 1.656)..(vBP 1.68), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.36347856) (m := (1:ℤ)) (ylo := 0.08029325) (yhi := 0.08029326)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.656) (q1 := 1.68) (t0 := 6.1875) (t1 := 6.25)
    (A := 1.00878907) (B := 1.03761196) (X := 6.36347856) (rho := 0.1215962)
    (clo := 0.99677822) (chi := 0.99677823) (C := 0.93759101) (h := 0.06240899)
    (by norm_num) (by norm_num) oscBlock60 vbpBr60.1 vbpBr61.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i61 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00122808):ℝ) ≤ ∫ v in (vBP 1.68)..(vBP 1.704), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.54116527) (m := (1:ℤ)) (ylo := 0.25797996) (yhi := 0.25797997)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.68) (q1 := 1.704) (t0 := 6.1875) (t1 := 6.25)
    (A := 1.03755935) (B := 1.06598913) (X := 6.54116527) (rho := 0.12126681)
    (clo := 0.96690731) (chi := 0.96690732) (C := 0.92282025) (h := 0.07717975)
    (by norm_num) (by norm_num) oscBlock61 vbpBr61.1 vbpBr62.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i62 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00137159):ℝ) ≤ ∫ v in (vBP 1.704)..(vBP 1.734), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.73802211) (m := (1:ℤ)) (ylo := 0.4548368) (yhi := 0.45483681)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.704) (q1 := 1.734) (t0 := 6.1875) (t1 := 6.25)
    (A := 1.06591948) (B := 1.10090679) (X := 6.73802211) (rho := 0.14264534)
    (clo := 0.89833273) (chi := 0.89833274) (C := 0.87784369) (h := 0.12215631)
    (by norm_num) (by norm_num) oscBlock62 vbpBr62.1 vbpBr63.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i63 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00120578):ℝ) ≤ ∫ v in (vBP 1.734)..(vBP 1.766), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.96030841) (m := (1:ℤ)) (ylo := 0.6771231) (yhi := 0.67712311)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.734) (q1 := 1.766) (t0 := 6.1875) (t1 := 6.25)
    (A := 1.10080961) (B := 1.13749718) (X := 6.96030841) (rho := 0.14904897)
    (clo := 0.77937846) (chi := 0.77937848) (C := 0.77937847) (h := 0.14904898)
    (by norm_num) (by norm_num) oscBlock63 vbpBr63.1 vbpBr64.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i64 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00082475):ℝ) ≤ ∫ v in (vBP 1.766)..(vBP 1.796), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.1787388) (m := (1:ℤ)) (ylo := 0.89555349) (yhi := 0.8955535)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.766) (q1 := 1.796) (t0 := 6.1875) (t1 := 6.25)
    (A := 1.1373613) (B := 1.17120873) (X := 7.1787388) (rho := 0.14131577)
    (clo := 0.62508687) (chi := 0.62508698) (C := 0.62508692) (h := 0.14131583)
    (by norm_num) (by norm_num) oscBlock64 vbpBr64.1 vbpBr65.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i65 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00062459):ℝ) ≤ ∫ v in (vBP 1.796)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.39335941) (m := (1:ℤ)) (ylo := 1.1101741) (yhi := 1.11017411)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.796) (q1 := 1.828) (t0 := 6.1875) (t1 := 6.25)
    (A := 1.1710258) (B := 1.20655947) (X := 7.39335941) (rho := 0.14763729)
    (clo := 0.44450555) (chi := 0.44450635) (C := 0.44450595) (h := 0.14763769)
    (by norm_num) (by norm_num) oscBlock65 vbpBr65.1 vbpBr66.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i66 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00037427):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.86), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.61110798) (m := (1:ℤ)) (ylo := 1.32792267) (yhi := 1.32792268)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.828) (q1 := 1.86) (t0 := 6.1875) (t1 := 6.25)
    (A := 1.20631244) (B := 1.24130524) (X := 7.61110798) (rho := 0.14704978)
    (clo := 0.24049286) (chi := 0.24049757) (C := 0.24049521) (h := 0.14705214)
    (by norm_num) (by norm_num) oscBlock66 vbpBr66.1 vbpBr67.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i67 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00014109):ℝ) ≤ ∫ v in (vBP 1.86)..(vBP 1.89), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.81849066) (m := (1:ℤ)) (ylo := 1.53530535) (yhi := 1.53530536)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.86) (q1 := 1.89) (t0 := 6.1875) (t1 := 6.25)
    (A := 1.24097685) (B := 1.27334993) (X := 7.81849066) (rho := 0.13994642)
    (clo := 0.03548316) (chi := 0.03550323) (C := 0.03549319) (h := 0.13995646)
    (by norm_num) (by norm_num) oscBlock67 vbpBr67.1 vbpBr68.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i68 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00023243):ℝ) ≤ ∫ v in (vBP 1.89)..(vBP 1.922), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.02245016) (m := (1:ℤ)) (ylo := 0.16846852) (yhi := 0.16846853)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.89) (q1 := 1.922) (t0 := 6.1875) (t1 := 6.25)
    (A := 1.27292668) (B := 1.30698664) (X := 8.02245016) (rho := 0.14621635)
    (clo := (-0.16767276)) (chi := (-0.16767274)) (C := (-0.16767275)) (h := 0.14621636)
    (by norm_num) (by norm_num) oscBlock68 vbpBr68.1 vbpBr69.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i69 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00058819):ℝ) ≤ ∫ v in (vBP 1.922)..(vBP 1.969), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.27746578) (m := (1:ℤ)) (ylo := 0.42348414) (yhi := 0.42348415)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.922) (q1 := 1.969) (t0 := 6.1875) (t1 := 6.25)
    (A := 1.30643896) (B := 1.35541448) (X := 8.27746578) (rho := 0.19387473)
    (clo := (-0.41093932)) (chi := (-0.4109393)) (C := (-0.41093931)) (h := 0.19387474)
    (by norm_num) (by norm_num) oscBlock69 vbpBr69.1 vbpBr70.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i70 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00074915):ℝ) ≤ ∫ v in (vBP 1.969)..(vBP 2.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.57444636) (m := (1:ℤ)) (ylo := 0.72046472) (yhi := 0.72046473)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.969) (q1 := 2.016) (t0 := 6.1875) (t1 := 6.25)
    (A := 1.35463226) (B := 1.4027369) (X := 8.57444636) (rho := 0.19265927)
    (clo := (-0.65973399)) (chi := (-0.65973397)) (C := (-0.65973398)) (h := 0.19265928)
    (by norm_num) (by norm_num) oscBlock70 vbpBr70.1 vbpBr71.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i71 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00078633):ℝ) ≤ ∫ v in (vBP 2.016)..(vBP 2.062), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.8614659) (m := (1:ℤ)) (ylo := 1.00748426) (yhi := 1.00748427)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.016) (q1 := 2.062) (t0 := 6.1875) (t1 := 6.25)
    (A := 1.40164597) (B := 1.44803958) (X := 8.8614659) (rho := 0.18878148)
    (clo := (-0.84549118)) (chi := (-0.84549114)) (C := (-0.82835483)) (h := 0.17164517)
    (by norm_num) (by norm_num) oscBlock71 vbpBr71.1 vbpBr72.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB10i72 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.00051116):ℝ) ≤ ∫ v in (vBP 2.062)..(vBP 2.094), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 9.09714469) (m := (1:ℤ)) (ylo := 1.24316305) (yhi := 1.24316306)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.062) (q1 := 2.094) (t0 := 6.1875) (t1 := 6.25)
    (A := 1.44655973) (B := 1.47899217) (X := 9.09714469) (rho := 0.14655638)
    (clo := (-0.94680689)) (chi := (-0.94680661)) (C := (-0.90012512)) (h := 0.09987489)
    (by norm_num) (by norm_num) oscBlock72 vbpBr72.1 vbpBr73.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

/-- Lower bound for the oscillatory integral `∫₀^∞ err(v) cos(tv) dv` on the band
`6.1875 ≤ t ≤ 6.25`. -/
theorem oscBandLower10 {t : ℝ} (ht0 : (6.1875:ℝ) ≤ t) (ht1 : t ≤ 6.25) :
    ((-0.13054338):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosB10i0 ht0 ht1)
    (cosB10i1 ht0 ht1))
    (cosB10i2 ht0 ht1))
    (cosB10i3 ht0 ht1))
    (cosB10i4 ht0 ht1))
    (cosB10i5 ht0 ht1))
    (cosB10i6 ht0 ht1))
    (cosB10i7 ht0 ht1))
    (cosB10i8 ht0 ht1))
    (cosB10i9 ht0 ht1))
    (cosB10i10 ht0 ht1))
    (cosB10i11 ht0 ht1))
    (cosB10i12 ht0 ht1))
    (cosB10i13 ht0 ht1))
    (cosB10i14 ht0 ht1))
    (cosB10i15 ht0 ht1))
    (cosB10i16 ht0 ht1))
    (cosB10i17 ht0 ht1))
    (cosB10i18 ht0 ht1))
    (cosB10i19 ht0 ht1))
    (cosB10i20 ht0 ht1))
    (cosB10i21 ht0 ht1))
    (cosB10i22 ht0 ht1))
    (cosB10i23 ht0 ht1))
    (cosB10i24 ht0 ht1))
    (cosB10i25 ht0 ht1))
    (cosB10i26 ht0 ht1))
    (cosB10i27 ht0 ht1))
    (cosB10i28 ht0 ht1))
    (cosB10i29 ht0 ht1))
    (cosB10i30 ht0 ht1))
    (cosB10i31 ht0 ht1))
    (cosB10i32 ht0 ht1))
    (cosB10i33 ht0 ht1))
    (cosB10i34 ht0 ht1))
    (cosB10i35 ht0 ht1))
    (cosB10i36 ht0 ht1))
    (cosB10i37 ht0 ht1))
    (cosB10i38 ht0 ht1))
    (cosB10i39 ht0 ht1))
    (cosB10i40 ht0 ht1))
    (cosB10i41 ht0 ht1))
    (cosB10i42 ht0 ht1))
    (cosB10i43 ht0 ht1))
    (cosB10i44 ht0 ht1))
    (cosB10i45 ht0 ht1))
    (cosB10i46 ht0 ht1))
    (cosB10i47 ht0 ht1))
    (cosB10i48 ht0 ht1))
    (cosB10i49 ht0 ht1))
    (cosB10i50 ht0 ht1))
    (cosB10i51 ht0 ht1))
    (cosB10i52 ht0 ht1))
    (cosB10i53 ht0 ht1))
    (cosB10i54 ht0 ht1))
    (cosB10i55 ht0 ht1))
    (cosB10i56 ht0 ht1))
    (cosB10i57 ht0 ht1))
    (cosB10i58 ht0 ht1))
    (cosB10i59 ht0 ht1))
    (cosB10i60 ht0 ht1))
    (cosB10i61 ht0 ht1))
    (cosB10i62 ht0 ht1))
    (cosB10i63 ht0 ht1))
    (cosB10i64 ht0 ht1))
    (cosB10i65 ht0 ht1))
    (cosB10i66 ht0 ht1))
    (cosB10i67 ht0 ht1))
    (cosB10i68 ht0 ht1))
    (cosB10i69 ht0 ht1))
    (cosB10i70 ht0 ht1))
    (cosB10i71 ht0 ht1))
    (cosB10i72 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 2.094) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 2.094) (S := 0.013709)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_cut
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
