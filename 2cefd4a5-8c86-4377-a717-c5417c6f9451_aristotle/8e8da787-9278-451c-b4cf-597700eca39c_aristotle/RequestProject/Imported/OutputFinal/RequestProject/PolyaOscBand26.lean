/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscTail

/-!
# Oscillatory lower bound on the band `5.5 ≤ t ≤ 5.53125`

On each of the 73 blocks the factor `cos(tv)` is bracketed by a rational constant
`C` up to a rational error `h`; the signed contribution `min(C·P₀, C·P₁) - h·S` is
then summed, and the unresolved tail beyond `q = 2.094` is estimated in absolute
value.  The result is the bound `∫₀^∞ err(v) cos(tv) dv ≥ -0.10647839`.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosB26i0 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00641868):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.0038), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.02097892) (m := (0:ℤ)) (ylo := 0.02097892) (yhi := 0.02097892)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1) (q1 := 1.0038) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.0) (B := 0.0075856) (X := 0.02097892) (rho := 0.02097894)
    (clo := 0.99977995) (chi := 0.99977996) (C := 0.9894005) (h := 0.0105995)
    (by norm_num) (by norm_num) oscBlock0 vbpBr0.1 vbpBr1.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i1 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00625872):ℝ) ≤ ∫ v in (vBP 1.0038)..(vBP 1.0078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.06383674) (m := (0:ℤ)) (ylo := 0.06383674) (yhi := 0.06383674)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0038) (q1 := 1.0078) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.00758559) (B := 0.01553948) (X := 0.06383674) (rho := 0.02211602)
    (clo := 0.99796312) (chi := 0.99796313) (C := 0.98792355) (h := 0.01207645)
    (by norm_num) (by norm_num) oscBlock1 vbpBr1.1 vbpBr2.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i2 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.0057677):ℝ) ≤ ∫ v in (vBP 1.0078)..(vBP 1.0118), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.10762022) (m := (0:ℤ)) (ylo := 0.10762022) (yhi := 0.10762022)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0078) (q1 := 1.0118) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.01553947) (B := 0.02346185) (X := 0.10762022) (rho := 0.02215315)
    (clo := 0.99421453) (chi := 0.99421454) (C := 0.98603069) (h := 0.01396931)
    (by norm_num) (by norm_num) oscBlock2 vbpBr2.1 vbpBr3.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i3 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00554846):ℝ) ≤ ∫ v in (vBP 1.0118)..(vBP 1.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.15231952) (m := (0:ℤ)) (ylo := 0.15231952) (yhi := 0.15231952)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0118) (q1 := 1.016) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.02346184) (B := 0.0317467) (X := 0.15231952) (rho := 0.02327942)
    (clo := 0.98842179) (chi := 0.9884218) (C := 0.98257118) (h := 0.01742882)
    (by norm_num) (by norm_num) oscBlock3 vbpBr3.1 vbpBr4.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i4 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00539232):ℝ) ≤ ∫ v in (vBP 1.016)..(vBP 1.0205), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.19954742) (m := (0:ℤ)) (ylo := 0.19954742) (yhi := 0.19954742)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.016) (q1 := 1.0205) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.03174669) (B := 0.04058541) (X := 0.19954742) (rho := 0.02494064)
    (clo := 0.98015639) (chi := 0.9801564) (C := 0.97760787) (h := 0.02239213)
    (by norm_num) (by norm_num) oscBlock4 vbpBr4.1 vbpBr5.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i5 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00482346):ℝ) ≤ ∫ v in (vBP 1.0205)..(vBP 1.025), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.24819087) (m := (0:ℤ)) (ylo := 0.24819087) (yhi := 0.24819087)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0205) (q1 := 1.025) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.0405854) (B := 0.04938523) (X := 0.24819087) (rho := 0.02497119)
    (clo := 0.96935842) (chi := 0.96935843) (C := 0.96935842) (h := 0.0249712)
    (by norm_num) (by norm_num) oscBlock5 vbpBr5.1 vbpBr6.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i6 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00471049):ℝ) ≤ ∫ v in (vBP 1.025)..(vBP 1.03), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.29930649) (m := (0:ℤ)) (ylo := 0.29930649) (yhi := 0.29930649)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.025) (q1 := 1.03) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.04938522) (B := 0.05911761) (X := 0.29930649) (rho := 0.0276878)
    (clo := 0.9555412) (chi := 0.95554121) (C := 0.9555412) (h := 0.02768781)
    (by norm_num) (by norm_num) oscBlock6 vbpBr6.1 vbpBr7.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i7 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00442018):ℝ) ≤ ∫ v in (vBP 1.03)..(vBP 1.0355), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.35552776) (m := (0:ℤ)) (ylo := 0.35552776) (yhi := 0.35552776)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.03) (q1 := 1.0355) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.0591176) (B := 0.06976881) (X := 0.35552776) (rho := 0.03038098)
    (clo := 0.93746291) (chi := 0.93746292) (C := 0.93746291) (h := 0.03038099)
    (by norm_num) (by norm_num) oscBlock7 vbpBr7.1 vbpBr8.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i8 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00397177):ℝ) ≤ ∫ v in (vBP 1.0355)..(vBP 1.0415), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.4167758) (m := (0:ℤ)) (ylo := 0.4167758) (yhi := 0.4167758)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0355) (q1 := 1.0415) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.0697688) (B := 0.08132397) (X := 0.4167758) (rho := 0.03304742)
    (clo := 0.91439889) (chi := 0.9143989) (C := 0.91439889) (h := 0.03304743)
    (by norm_num) (by norm_num) oscBlock8 vbpBr8.1 vbpBr9.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i9 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00338968):ℝ) ≤ ∫ v in (vBP 1.0415)..(vBP 1.048), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.48296574) (m := (0:ℤ)) (ylo := 0.48296574) (yhi := 0.48296574)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0415) (q1 := 1.048) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.08132396) (B := 0.09376718) (X := 0.48296574) (rho := 0.03568398)
    (clo := 0.8856215) (chi := 0.88562151) (C := 0.8856215) (h := 0.03568399)
    (by norm_num) (by norm_num) oscBlock9 vbpBr9.1 vbpBr10.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i10 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.0027239):ℝ) ≤ ∫ v in (vBP 1.048)..(vBP 1.055), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.5540071) (m := (0:ℤ)) (ylo := 0.5540071) (yhi := 0.5540071)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.048) (q1 := 1.055) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.09376717) (B := 0.10708154) (X := 0.5540071) (rho := 0.03828768)
    (clo := 0.85042322) (chi := 0.85042323) (C := 0.85042322) (h := 0.03828769)
    (by norm_num) (by norm_num) oscBlock10 vbpBr10.1 vbpBr11.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i11 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00227231):ℝ) ≤ ∫ v in (vBP 1.055)..(vBP 1.064), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.63760748) (m := (0:ℤ)) (ylo := 0.63760748) (yhi := 0.63760748)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.055) (q1 := 1.064) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.10708153) (B := 0.12407079) (X := 0.63760748) (rho := 0.04865909)
    (clo := 0.80352226) (chi := 0.80352227) (C := 0.80352226) (h := 0.0486591)
    (by norm_num) (by norm_num) oscBlock11 vbpBr11.1 vbpBr12.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i12 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00149078):ℝ) ≤ ∫ v in (vBP 1.064)..(vBP 1.078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.75663286) (m := (0:ℤ)) (ylo := 0.75663286) (yhi := 0.75663286)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.064) (q1 := 1.078) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.12407078) (B := 0.15021495) (X := 0.75663286) (rho := 0.07424359)
    (clo := 0.72715159) (chi := 0.72715161) (C := 0.7271516) (h := 0.0742436)
    (by norm_num) (by norm_num) oscBlock12 vbpBr12.1 vbpBr13.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i13 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    (0.00021746:ℝ) ≤ ∫ v in (vBP 1.078)..(vBP 1.09), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.88976148) (m := (0:ℤ)) (ylo := 0.88976148) (yhi := 0.88976148)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.078) (q1 := 1.09) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.15021494) (B := 0.1723554) (X := 0.88976148) (rho := 0.06357933)
    (clo := 0.62959735) (chi := 0.62959745) (C := 0.6295974) (h := 0.06357938)
    (by norm_num) (by norm_num) oscBlock13 vbpBr13.1 vbpBr14.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i14 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    (0.00082881:ℝ) ≤ ∫ v in (vBP 1.09)..(vBP 1.1), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.00116175) (m := (0:ℤ)) (ylo := 1.00116175) (yhi := 1.00116175)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.09) (q1 := 1.1) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.17235539) (B := 0.19062036) (X := 1.00116175) (rho := 0.05320713)
    (clo := 0.53932436) (chi := 0.53932464) (C := 0.5393245) (h := 0.05320727)
    (by norm_num) (by norm_num) oscBlock14 vbpBr14.1 vbpBr15.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i15 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    (0.00096763:ℝ) ≤ ∫ v in (vBP 1.1)..(vBP 1.109), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.09646195) (m := (0:ℤ)) (ylo := 1.09646195) (yhi := 1.09646195)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.1) (q1 := 1.109) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.19062035) (B := 0.20691742) (X := 1.09646195) (rho := 0.04805004)
    (clo := 0.4567464) (chi := 0.4567471) (C := 0.45674675) (h := 0.04805039)
    (by norm_num) (by norm_num) oscBlock15 vbpBr15.1 vbpBr16.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i16 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    (0.00088255:ℝ) ≤ ∫ v in (vBP 1.109)..(vBP 1.117), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.18103646) (m := (0:ℤ)) (ylo := 1.18103646) (yhi := 1.18103646)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.109) (q1 := 1.117) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.20691741) (B := 0.22129305) (X := 1.18103646) (rho := 0.04299073)
    (clo := 0.37996628) (chi := 0.37996775) (C := 0.37996701) (h := 0.04299147)
    (by norm_num) (by norm_num) oscBlock16 vbpBr16.1 vbpBr17.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i17 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    (0.00071384:ℝ) ≤ ∫ v in (vBP 1.117)..(vBP 1.124), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.25512444) (m := (0:ℤ)) (ylo := 1.25512444) (yhi := 1.25512444)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.117) (q1 := 1.124) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.22129304) (B := 0.23378751) (X := 1.25512444) (rho := 0.03801274)
    (clo := 0.31045519) (chi := 0.31045788) (C := 0.31045653) (h := 0.03801409)
    (by norm_num) (by norm_num) oscBlock17 vbpBr17.1 vbpBr18.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i18 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    (0.00058992:ℝ) ≤ ∫ v in (vBP 1.124)..(vBP 1.131), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.32382466) (m := (0:ℤ)) (ylo := 1.32382466) (yhi := 1.32382466)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.124) (q1 := 1.131) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.2337875) (B := 0.2462044) (X := 1.32382466) (rho := 0.03799343)
    (clo := 0.24446857) (chi := 0.24447314) (C := 0.24447085) (h := 0.03799572)
    (by norm_num) (by norm_num) oscBlock18 vbpBr18.1 vbpBr19.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i19 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    (0.00042292:ℝ) ≤ ∫ v in (vBP 1.131)..(vBP 1.138), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.3920997) (m := (0:ℤ)) (ylo := 1.3920997) (yhi := 1.3920997)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.131) (q1 := 1.138) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.24620439) (B := 0.25854468) (X := 1.3920997) (rho := 0.03797557)
    (clo := 0.17774699) (chi := 0.17775453) (C := 0.17775076) (h := 0.03797934)
    (by norm_num) (by norm_num) oscBlock19 vbpBr19.1 vbpBr20.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i20 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    (0.00022863:ℝ) ≤ ∫ v in (vBP 1.138)..(vBP 1.145), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.45995475) (m := (0:ℤ)) (ylo := 1.45995475) (yhi := 1.45995475)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.138) (q1 := 1.145) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.25854467) (B := 0.27080928) (X := 1.45995475) (rho := 0.03795909)
    (clo := 0.11061455) (chi := 0.11062669) (C := 0.11062062) (h := 0.03796516)
    (by norm_num) (by norm_num) oscBlock20 vbpBr20.1 vbpBr21.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i21 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    (0.00000511:ℝ) ≤ ∫ v in (vBP 1.145)..(vBP 1.152), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.52739496) (m := (0:ℤ)) (ylo := 1.52739496) (yhi := 1.52739496)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.145) (q1 := 1.152) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.27080927) (B := 0.28299913) (X := 1.52739496) (rho := 0.03794399)
    (clo := 0.04338741) (chi := 0.04340646) (C := 0.04339693) (h := 0.03795352)
    (by norm_num) (by norm_num) oscBlock21 vbpBr21.1 vbpBr22.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i22 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00024018):ℝ) ≤ ∫ v in (vBP 1.152)..(vBP 1.159), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.59442536) (m := (0:ℤ)) (ylo := 0.02362903) (yhi := 0.02362904)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.152) (q1 := 1.159) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.28299912) (B := 0.29511513) (X := 1.59442536) (rho := 0.03793022)
    (clo := (-0.02362685)) (chi := (-0.02362683)) (C := (-0.02362684)) (h := 0.03793023)
    (by norm_num) (by norm_num) oscBlock22 vbpBr22.1 vbpBr23.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i23 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00050388):ℝ) ≤ ∫ v in (vBP 1.159)..(vBP 1.166), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.66105092) (m := (0:ℤ)) (ylo := 0.09025459) (yhi := 0.0902546)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.159) (q1 := 1.166) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.29511512) (B := 0.30715818) (X := 1.66105092) (rho := 0.03791778)
    (clo := (-0.09013212)) (chi := (-0.0901321)) (C := (-0.09013211)) (h := 0.03791779)
    (by norm_num) (by norm_num) oscBlock23 vbpBr23.1 vbpBr24.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i24 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00076198):ℝ) ≤ ∫ v in (vBP 1.166)..(vBP 1.173), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.72727649) (m := (0:ℤ)) (ylo := 0.15648016) (yhi := 0.15648017)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.166) (q1 := 1.173) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.30715817) (B := 0.31912914) (X := 1.72727649) (rho := 0.03790658)
    (clo := (-0.15584236)) (chi := (-0.15584234)) (C := (-0.15584235)) (h := 0.03790659)
    (by norm_num) (by norm_num) oscBlock24 vbpBr24.1 vbpBr25.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i25 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00100713):ℝ) ≤ ∫ v in (vBP 1.173)..(vBP 1.18), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.79310685) (m := (0:ℤ)) (ylo := 0.22231052) (yhi := 0.22231053)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.173) (q1 := 1.18) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.31912913) (B := 0.33102888) (X := 1.79310685) (rho := 0.03789665)
    (clo := (-0.22048388)) (chi := (-0.22048386)) (C := (-0.22048387)) (h := 0.03789666)
    (by norm_num) (by norm_num) oscBlock25 vbpBr25.1 vbpBr26.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i26 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00123294):ℝ) ≤ ∫ v in (vBP 1.18)..(vBP 1.187), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.85854671) (m := (0:ℤ)) (ylo := 0.28775038) (yhi := 0.28775039)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.18) (q1 := 1.187) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.33102887) (B := 0.34285824) (X := 1.85854671) (rho := 0.03788794)
    (clo := (-0.28379583)) (chi := (-0.28379581)) (C := (-0.28379582)) (h := 0.03788795)
    (by norm_num) (by norm_num) oscBlock26 vbpBr26.1 vbpBr27.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i27 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00143409):ℝ) ≤ ∫ v in (vBP 1.187)..(vBP 1.194), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.92360064) (m := (0:ℤ)) (ylo := 0.35280431) (yhi := 0.35280432)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.187) (q1 := 1.194) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.34285823) (B := 0.35461804) (X := 1.92360064) (rho := 0.0378804)
    (clo := (-0.34553076)) (chi := (-0.34553074)) (C := (-0.34553075)) (h := 0.03788041)
    (by norm_num) (by norm_num) oscBlock27 vbpBr27.1 vbpBr28.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i28 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00162277):ℝ) ≤ ∫ v in (vBP 1.194)..(vBP 1.201), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.98827313) (m := (0:ℤ)) (ylo := 0.4174768) (yhi := 0.41747681)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.194) (q1 := 1.201) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.35461802) (B := 0.36630909) (X := 1.98827313) (rho := 0.03787404)
    (clo := (-0.40545527)) (chi := (-0.40545525)) (C := (-0.40545526)) (h := 0.03787405)
    (by norm_num) (by norm_num) oscBlock28 vbpBr28.1 vbpBr29.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i29 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.0017646):ℝ) ≤ ∫ v in (vBP 1.201)..(vBP 1.208), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.05256871) (m := (0:ℤ)) (ylo := 0.48177238) (yhi := 0.48177239)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.201) (q1 := 1.208) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.36630908) (B := 0.3779322) (X := 2.05256871) (rho := 0.03786879)
    (clo := (-0.46335056)) (chi := (-0.46335054)) (C := (-0.46335055)) (h := 0.0378688)
    (by norm_num) (by norm_num) oscBlock29 vbpBr29.1 vbpBr30.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i30 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00187184):ℝ) ≤ ∫ v in (vBP 1.208)..(vBP 1.215), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.11649171) (m := (0:ℤ)) (ylo := 0.54569538) (yhi := 0.54569539)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.208) (q1 := 1.215) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.37793219) (B := 0.38948816) (X := 2.11649171) (rho := 0.03786468)
    (clo := (-0.51901262)) (chi := (-0.5190126)) (C := (-0.51901261)) (h := 0.03786469)
    (by norm_num) (by norm_num) oscBlock30 vbpBr30.1 vbpBr31.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i31 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00224141):ℝ) ≤ ∫ v in (vBP 1.215)..(vBP 1.223), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.18457098) (m := (0:ℤ)) (ylo := 0.61377465) (yhi := 0.61377466)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.215) (q1 := 1.223) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.38948815) (B := 0.40261372) (X := 2.18457098) (rho := 0.04238617)
    (clo := (-0.57595727)) (chi := (-0.57595725)) (C := (-0.57595726)) (h := 0.04238618)
    (by norm_num) (by norm_num) oscBlock31 vbpBr31.1 vbpBr32.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i32 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00227972):ℝ) ≤ ∫ v in (vBP 1.223)..(vBP 1.231), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.25672996) (m := (0:ℤ)) (ylo := 0.68593363) (yhi := 0.68593364)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.223) (q1 := 1.231) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.40261371) (B := 0.4156537) (X := 2.25672996) (rho := 0.04235458)
    (clo := (-0.63339577)) (chi := (-0.63339575)) (C := (-0.63339576)) (h := 0.04235459)
    (by norm_num) (by norm_num) oscBlock32 vbpBr32.1 vbpBr33.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i33 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00226545):ℝ) ≤ ∫ v in (vBP 1.231)..(vBP 1.239), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.32841999) (m := (0:ℤ)) (ylo := 0.75762366) (yhi := 0.75762367)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.231) (q1 := 1.239) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.41565369) (B := 0.42860921) (X := 2.32841999) (rho := 0.04232471)
    (clo := (-0.68719706)) (chi := (-0.68719704)) (C := (-0.68719705)) (h := 0.04232472)
    (by norm_num) (by norm_num) oscBlock33 vbpBr33.1 vbpBr34.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i34 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00248425):ℝ) ≤ ∫ v in (vBP 1.239)..(vBP 1.248), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.404081) (m := (0:ℤ)) (ylo := 0.83328467) (yhi := 0.83328468)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.239) (q1 := 1.248) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.4286092) (B := 0.44308455) (X := 2.404081) (rho := 0.04673042)
    (clo := (-0.74014415)) (chi := (-0.74014413)) (C := (-0.74014414)) (h := 0.04673043)
    (by norm_num) (by norm_num) oscBlock34 vbpBr34.1 vbpBr35.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i35 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00259922):ℝ) ≤ ∫ v in (vBP 1.248)..(vBP 1.258), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.48803243) (m := (0:ℤ)) (ylo := 0.9172361) (yhi := 0.91723611)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.248) (q1 := 1.258) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.44308453) (B := 0.45904632) (X := 2.48803243) (rho := 0.05106754)
    (clo := (-0.79392418)) (chi := (-0.79392415)) (C := (-0.79392417)) (h := 0.05106756)
    (by norm_num) (by norm_num) oscBlock35 vbpBr35.1 vbpBr36.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i36 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00237027):ℝ) ≤ ∫ v in (vBP 1.258)..(vBP 1.268), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.5757221) (m := (0:ℤ)) (ylo := 1.00492577) (yhi := 1.00492578)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.258) (q1 := 1.268) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.45904631) (B := 0.47488172) (X := 2.5757221) (rho := 0.05096742)
    (clo := (-0.84412221)) (chi := (-0.84412217)) (C := (-0.84412219)) (h := 0.05096744)
    (by norm_num) (by norm_num) oscBlock36 vbpBr36.1 vbpBr37.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i37 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00248254):ℝ) ≤ ∫ v in (vBP 1.268)..(vBP 1.28), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.67136952) (m := (0:ℤ)) (ylo := 1.10057319) (yhi := 1.1005732)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.268) (q1 := 1.28) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.4748817) (B := 0.49372017) (X := 2.67136952) (rho := 0.05952019)
    (clo := (-0.89146729)) (chi := (-0.8914672)) (C := (-0.89146725)) (h := 0.05952024)
    (by norm_num) (by norm_num) oscBlock37 vbpBr37.1 vbpBr38.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i38 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00228621):ℝ) ≤ ∫ v in (vBP 1.28)..(vBP 1.294), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.78334483) (m := (0:ℤ)) (ylo := 1.2125485) (yhi := 1.21254851)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.28) (q1 := 1.294) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.49372014) (B := 0.51547641) (X := 2.78334483) (rho := 0.06788408)
    (clo := (-0.93651285)) (chi := (-0.93651263)) (C := (-0.93431428)) (h := 0.06568573)
    (by norm_num) (by norm_num) oscBlock38 vbpBr38.1 vbpBr39.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i39 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00152769):ℝ) ≤ ∫ v in (vBP 1.294)..(vBP 1.308), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.9026966) (m := (0:ℤ)) (ylo := 1.33190027) (yhi := 1.33190028)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.294) (q1 := 1.308) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.51547638) (B := 0.53699853) (X := 2.9026966) (rho := 0.06757653)
    (clo := (-0.97160038)) (chi := (-0.97159978)) (C := (-0.95201163)) (h := 0.04798838)
    (by norm_num) (by norm_num) oscBlock39 vbpBr39.1 vbpBr40.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i40 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.0009941):ℝ) ≤ ∫ v in (vBP 1.308)..(vBP 1.326), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.03748154) (m := (0:ℤ)) (ylo := 1.46668521) (yhi := 1.46668522)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.308) (q1 := 1.326) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.53699848) (B := 0.56433382) (X := 3.03748154) (rho := 0.08398992)
    (clo := (-0.99458701)) (chi := (-0.9945853)) (C := (-0.95529769)) (h := 0.04470231)
    (by norm_num) (by norm_num) oscBlock40 vbpBr40.1 vbpBr41.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i41 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    (0.00003512:ℝ) ≤ ∫ v in (vBP 1.326)..(vBP 1.345), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.19134731) (m := (0:ℤ)) (ylo := 0.04975465) (yhi := 0.04975466)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.326) (q1 := 1.345) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.56433374) (B := 0.59278808) (X := 3.19134731) (rho := 0.08751176)
    (clo := (-0.9987625)) (chi := (-0.99876249)) (C := (-0.95562537)) (h := 0.04437464)
    (by norm_num) (by norm_num) oscBlock41 vbpBr41.1 vbpBr42.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i42 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    (0.00094955:ℝ) ≤ ∫ v in (vBP 1.345)..(vBP 1.362), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.33907008) (m := (0:ℤ)) (ylo := 0.19747742) (yhi := 0.19747743)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.345) (q1 := 1.362) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.59278796) (B := 0.6179085) (X := 3.33907008) (rho := 0.07873632)
    (clo := (-0.98056462)) (chi := (-0.98056461)) (C := (-0.95091415)) (h := 0.04908586)
    (by norm_num) (by norm_num) oscBlock42 vbpBr42.1 vbpBr43.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i43 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    (0.00111616:ℝ) ≤ ∫ v in (vBP 1.362)..(vBP 1.376), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.46471665) (m := (0:ℤ)) (ylo := 0.32312399) (yhi := 0.323124)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.362) (q1 := 1.376) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.61790831) (B := 0.6383616) (X := 3.46471665) (rho := 0.06622096)
    (clo := (-0.94824809)) (chi := (-0.94824808)) (C := (-0.94101356)) (h := 0.05898644)
    (by norm_num) (by norm_num) oscBlock43 vbpBr43.1 vbpBr44.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i44 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    (0.0012529:ℝ) ≤ ∫ v in (vBP 1.376)..(vBP 1.39), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.57695549) (m := (0:ℤ)) (ylo := 0.43536283) (yhi := 0.43536284)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.376) (q1 := 1.39) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.63836133) (B := 0.65860767) (X := 3.57695549) (rho := 0.06596819)
    (clo := (-0.90671709)) (chi := (-0.90671707)) (C := (-0.90671708)) (h := 0.0659682)
    (by norm_num) (by norm_num) oscBlock44 vbpBr44.1 vbpBr45.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i45 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    (0.00126522:ℝ) ≤ ∫ v in (vBP 1.39)..(vBP 1.404), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.68806383) (m := (0:ℤ)) (ylo := 0.54647117) (yhi := 0.54647118)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.39) (q1 := 1.404) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.65860729) (B := 0.67865086) (X := 3.68806383) (rho := 0.06572375)
    (clo := (-0.85436369)) (chi := (-0.85436367)) (C := (-0.85436368)) (h := 0.06572376)
    (by norm_num) (by norm_num) oscBlock45 vbpBr45.1 vbpBr46.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i46 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    (0.00117024:ℝ) ≤ ∫ v in (vBP 1.404)..(vBP 1.418), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.79806416) (m := (0:ℤ)) (ylo := 0.6564715) (yhi := 0.65647151)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.404) (q1 := 1.418) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.67865033) (B := 0.69849519) (X := 3.79806416) (rho := 0.06548737)
    (clo := (-0.7921507)) (chi := (-0.79215068)) (C := (-0.79215069)) (h := 0.06548738)
    (by norm_num) (by norm_num) oscBlock46 vbpBr46.1 vbpBr47.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i47 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    (0.00099624:ℝ) ≤ ∫ v in (vBP 1.418)..(vBP 1.432), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.90697842) (m := (0:ℤ)) (ylo := 0.76538576) (yhi := 0.76538577)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.418) (q1 := 1.432) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.69849446) (B := 0.7181446) (X := 3.90697842) (rho := 0.06525891)
    (clo := (-0.72111517)) (chi := (-0.72111514)) (C := (-0.72111516)) (h := 0.06525893)
    (by norm_num) (by norm_num) oscBlock47 vbpBr47.1 vbpBr48.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i48 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    (0.00077404:ℝ) ≤ ∫ v in (vBP 1.432)..(vBP 1.446), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.0148278) (m := (0:ℤ)) (ylo := 0.87323514) (yhi := 0.87323515)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.432) (q1 := 1.446) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.7181436) (B := 0.73760286) (X := 4.0148278) (rho := 0.06503802)
    (clo := (-0.64235054)) (chi := (-0.64235045)) (C := (-0.6423505)) (h := 0.06503807)
    (by norm_num) (by norm_num) oscBlock48 vbpBr48.1 vbpBr49.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i49 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    (0.00057343:ℝ) ≤ ∫ v in (vBP 1.446)..(vBP 1.462), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.12920498) (m := (0:ℤ)) (ylo := 0.98761232) (yhi := 0.98761233)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.446) (q1 := 1.462) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.73760153) (B := 0.75961158) (X := 4.12920498) (rho := 0.07239658)
    (clo := (-0.5506847)) (chi := (-0.55068444)) (C := (-0.55068457)) (h := 0.07239671)
    (by norm_num) (by norm_num) oscBlock49 vbpBr49.1 vbpBr50.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i50 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00032735):ℝ) ≤ ∫ v in (vBP 1.462)..(vBP 1.478), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.24993306) (m := (0:ℤ)) (ylo := 1.1083404) (yhi := 1.10834041)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.462) (q1 := 1.478) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.75960973) (B := 0.78138081) (X := 4.24993306) (rho := 0.07207956)
    (clo := (-0.44614817)) (chi := (-0.44614738)) (C := (-0.44614778)) (h := 0.07207996)
    (by norm_num) (by norm_num) oscBlock50 vbpBr50.1 vbpBr51.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i51 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.0005077):ℝ) ≤ ∫ v in (vBP 1.478)..(vBP 1.495), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.37305532) (m := (0:ℤ)) (ylo := 1.23146266) (yhi := 1.23146267)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.478) (q1 := 1.495) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.7813783) (B := 0.80425401) (X := 4.37305532) (rho := 0.07547469)
    (clo := (-0.33286102)) (chi := (-0.33285879)) (C := (-0.33285991)) (h := 0.07547581)
    (by norm_num) (by norm_num) oscBlock51 vbpBr51.1 vbpBr52.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i52 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00035291):ℝ) ≤ ∫ v in (vBP 1.495)..(vBP 1.512), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.49849784) (m := (0:ℤ)) (ylo := 1.35690518) (yhi := 1.35690519)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.495) (q1 := 1.512) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.80425056) (B := 0.82686872) (X := 4.49849784) (rho := 0.07511978)
    (clo := (-0.21226973)) (chi := (-0.21226388)) (C := (-0.21226681)) (h := 0.07512271)
    (by norm_num) (by norm_num) oscBlock52 vbpBr52.1 vbpBr53.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i53 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00024635):ℝ) ≤ ∫ v in (vBP 1.512)..(vBP 1.531), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.62976057) (m := (0:ℤ)) (ylo := 1.48816791) (yhi := 1.48816792)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.512) (q1 := 1.531) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.82686405) (B := 0.85184522) (X := 4.62976057) (rho := 0.08200831)
    (clo := (-0.08254887)) (chi := (-0.08253417)) (C := (-0.08254152)) (h := 0.08201566)
    (by norm_num) (by norm_num) oscBlock53 vbpBr53.1 vbpBr54.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i54 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00024617):ℝ) ≤ ∫ v in (vBP 1.531)..(vBP 1.55), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.76666545) (m := (0:ℤ)) (ylo := 0.05427646) (yhi := 0.05427647)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.531) (q1 := 1.55) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.85183877) (B := 0.87651393) (X := 4.76666545) (rho := 0.08155224)
    (clo := 0.05424981) (chi := 0.05424983) (C := 0.05424982) (h := 0.08155225)
    (by norm_num) (by norm_num) oscBlock54 vbpBr54.1 vbpBr55.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i55 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00048349):ℝ) ≤ ∫ v in (vBP 1.55)..(vBP 1.57), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.9054165) (m := (0:ℤ)) (ylo := 0.19302751) (yhi := 0.19302752)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.55) (q1 := 1.57) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.87650515) (B := 0.90215678) (X := 4.9054165) (rho := 0.0846382)
    (clo := 0.19183105) (chi := 0.19183107) (C := 0.19183106) (h := 0.08463821)
    (by norm_num) (by norm_num) oscBlock55 vbpBr55.1 vbpBr56.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i56 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.0006581):ℝ) ≤ ∫ v in (vBP 1.57)..(vBP 1.59), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.0459476) (m := (0:ℤ)) (ylo := 0.33355861) (yhi := 0.33355862)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.57) (q1 := 1.59) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.90214481) (B := 0.92747548) (X := 5.0459476) (rho := 0.08415116)
    (clo := 0.32740756) (chi := 0.32740758) (C := 0.32740757) (h := 0.08415117)
    (by norm_num) (by norm_num) oscBlock56 vbpBr56.1 vbpBr57.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i57 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00078859):ℝ) ≤ ∫ v in (vBP 1.59)..(vBP 1.61), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.18471098) (m := (0:ℤ)) (ylo := 0.47232199) (yhi := 0.472322)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.59) (q1 := 1.61) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.92745939) (B := 0.95247825) (X := 5.18471098) (rho := 0.08368435)
    (clo := 0.45495527) (chi := 0.45495529) (C := 0.45495528) (h := 0.08368436)
    (by norm_num) (by norm_num) oscBlock57 vbpBr57.1 vbpBr58.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i58 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00099664):ℝ) ≤ ∫ v in (vBP 1.61)..(vBP 1.632), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.32853416) (m := (0:ℤ)) (ylo := 0.61614517) (yhi := 0.61614518)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.61) (q1 := 1.632) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.95245689) (B := 0.97962584) (X := 5.32853416) (rho := 0.09002128)
    (clo := 0.57789348) (chi := 0.5778935) (C := 0.57789349) (h := 0.09002129)
    (by norm_num) (by norm_num) oscBlock58 vbpBr58.1 vbpBr59.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i59 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00119008):ℝ) ≤ ∫ v in (vBP 1.632)..(vBP 1.656), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.48393262) (m := (0:ℤ)) (ylo := 0.77154363) (yhi := 0.77154364)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.632) (q1 := 1.656) (t0 := 5.5) (t1 := 5.53125)
    (A := 0.97959707) (B := 1.00882827) (X := 5.48393262) (rho := 0.09614876)
    (clo := 0.69724259) (chi := 0.69724261) (C := 0.6972426) (h := 0.09614877)
    (by norm_num) (by norm_num) oscBlock59 vbpBr59.1 vbpBr60.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i60 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00121763):ℝ) ≤ ∫ v in (vBP 1.656)..(vBP 1.68), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.64381551) (m := (0:ℤ)) (ylo := 0.93142652) (yhi := 0.93142653)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.656) (q1 := 1.68) (t0 := 5.5) (t1 := 5.53125)
    (A := 1.00878907) (B := 1.03761196) (X := 5.64381551) (rho := 0.09547565)
    (clo := 0.80247194) (chi := 0.80247197) (C := 0.80247195) (h := 0.09547567)
    (by norm_num) (by norm_num) oscBlock60 vbpBr60.1 vbpBr61.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i61 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00120477):ℝ) ≤ ∫ v in (vBP 1.68)..(vBP 1.704), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.8014144) (m := (0:ℤ)) (ylo := 1.08902541) (yhi := 1.08902542)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.68) (q1 := 1.704) (t0 := 5.5) (t1 := 5.53125)
    (A := 1.03755935) (B := 1.06598913) (X := 5.8014144) (rho := 0.09483799)
    (clo := 0.88617575) (chi := 0.88617583) (C := 0.88617579) (h := 0.09483803)
    (by norm_num) (by norm_num) oscBlock61 vbpBr61.1 vbpBr62.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i62 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00137159):ℝ) ≤ ∫ v in (vBP 1.704)..(vBP 1.734), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.97597391) (m := (0:ℤ)) (ylo := 1.26358492) (yhi := 1.26358493)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.704) (q1 := 1.734) (t0 := 5.5) (t1 := 5.53125)
    (A := 1.06591948) (B := 1.10090679) (X := 5.97597391) (rho := 0.11341679)
    (clo := 0.95318054) (chi := 0.95318088) (C := 0.91988187) (h := 0.08011813)
    (by norm_num) (by norm_num) oscBlock62 vbpBr62.1 vbpBr63.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i63 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00129873):ℝ) ≤ ∫ v in (vBP 1.734)..(vBP 1.766), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.17311706) (m := (0:ℤ)) (ylo := 1.46072807) (yhi := 1.46072808)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.734) (q1 := 1.766) (t0 := 5.5) (t1 := 5.53125)
    (A := 1.10080961) (B := 1.13749718) (X := 6.17311706) (rho := 0.11866423)
    (clo := 0.99394858) (chi := 0.99395021) (C := 0.93764217) (h := 0.06235783)
    (by norm_num) (by norm_num) oscBlock63 vbpBr63.1 vbpBr64.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i64 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00107612):ℝ) ≤ ∫ v in (vBP 1.766)..(vBP 1.796), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.36686771) (m := (1:ℤ)) (ylo := 0.0836824) (yhi := 0.08368241)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.766) (q1 := 1.796) (t0 := 5.5) (t1 := 5.53125)
    (A := 1.1373613) (B := 1.17120873) (X := 6.36686771) (rho := 0.11138058)
    (clo := 0.99650066) (chi := 0.99650068) (C := 0.94256004) (h := 0.05743996)
    (by norm_num) (by norm_num) oscBlock64 vbpBr64.1 vbpBr65.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i65 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00105478):ℝ) ≤ ∫ v in (vBP 1.796)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.55721198) (m := (1:ℤ)) (ylo := 0.27402667) (yhi := 0.27402668)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.796) (q1 := 1.828) (t0 := 5.5) (t1 := 5.53125)
    (A := 1.1710258) (B := 1.20655947) (X := 6.55721198) (rho := 0.1165701)
    (clo := 0.96268904) (chi := 0.96268905) (C := 0.92305947) (h := 0.07694053)
    (by norm_num) (by norm_num) oscBlock65 vbpBr65.1 vbpBr66.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i66 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00096574):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.86), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.75034401) (m := (1:ℤ)) (ylo := 0.4671587) (yhi := 0.46715871)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.828) (q1 := 1.86) (t0 := 5.5) (t1 := 5.53125)
    (A := 1.20631244) (B := 1.24130524) (X := 6.75034401) (rho := 0.11562561)
    (clo := 0.89285146) (chi := 0.89285148) (C := 0.88861292) (h := 0.11138708)
    (by norm_num) (by norm_num) oscBlock66 vbpBr66.1 vbpBr67.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i67 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00072722):ℝ) ≤ ∫ v in (vBP 1.86)..(vBP 1.89), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.93429473) (m := (1:ℤ)) (ylo := 0.65110942) (yhi := 0.65110943)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.86) (q1 := 1.89) (t0 := 5.5) (t1 := 5.53125)
    (A := 1.24097685) (B := 1.27334993) (X := 6.93429473) (rho := 0.10892208)
    (clo := 0.79541189) (chi := 0.79541191) (C := 0.7954119) (h := 0.10892209)
    (by norm_num) (by norm_num) oscBlock67 vbpBr67.1 vbpBr68.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i68 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.0006103):ℝ) ≤ ∫ v in (vBP 1.89)..(vBP 1.922), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.11518329) (m := (1:ℤ)) (ylo := 0.83199798) (yhi := 0.83199799)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.89) (q1 := 1.922) (t0 := 5.5) (t1 := 5.53125)
    (A := 1.27292668) (B := 1.30698664) (X := 7.11518329) (rho := 0.11408657)
    (clo := 0.67340003) (chi := 0.67340009) (C := 0.67340006) (h := 0.1140866)
    (by norm_num) (by norm_num) oscBlock68 vbpBr68.1 vbpBr69.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i69 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00064223):ℝ) ≤ ∫ v in (vBP 1.922)..(vBP 1.969), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.34127531) (m := (1:ℤ)) (ylo := 1.05809) (yhi := 1.05809001)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.922) (q1 := 1.969) (t0 := 5.5) (t1 := 5.53125)
    (A := 1.30643896) (B := 1.35541448) (X := 7.34127531) (rho := 0.15586105)
    (clo := 0.49053737) (chi := 0.49053787) (C := 0.49053762) (h := 0.1558613)
    (by norm_num) (by norm_num) oscBlock69 vbpBr69.1 vbpBr70.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i70 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00034552):ℝ) ≤ ∫ v in (vBP 1.969)..(vBP 2.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.60468295) (m := (1:ℤ)) (ylo := 1.32149764) (yhi := 1.32149765)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.969) (q1 := 2.016) (t0 := 5.5) (t1 := 5.53125)
    (A := 1.35463226) (B := 1.4027369) (X := 7.60468295) (rho := 0.15420554)
    (clo := 0.24672431) (chi := 0.24672881) (C := 0.24672656) (h := 0.15420779)
    (by norm_num) (by norm_num) oscBlock70 vbpBr70.1 vbpBr71.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i71 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00012227):ℝ) ≤ ∫ v in (vBP 2.016)..(vBP 2.062), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 7.85926088) (m := (1:ℤ)) (ylo := 0.00527924) (yhi := 0.00527925)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.016) (q1 := 2.062) (t0 := 5.5) (t1 := 5.53125)
    (A := 1.40164597) (B := 1.44803958) (X := 7.85926088) (rho := 0.15020806)
    (clo := (-0.00527923)) (chi := (-0.00527921)) (C := (-0.00527922)) (h := 0.15020807)
    (by norm_num) (by norm_num) oscBlock71 vbpBr71.1 vbpBr72.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB26i72 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.00016616):ℝ) ≤ ∫ v in (vBP 2.062)..(vBP 2.094), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.06837697) (m := (1:ℤ)) (ylo := 0.21439533) (yhi := 0.21439534)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.062) (q1 := 2.094) (t0 := 5.5) (t1 := 5.53125)
    (A := 1.44655973) (B := 1.47899217) (X := 8.06837697) (rho := 0.11229848)
    (clo := (-0.21275666)) (chi := (-0.21275664)) (C := (-0.21275665)) (h := 0.11229849)
    (by norm_num) (by norm_num) oscBlock72 vbpBr72.1 vbpBr73.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

/-- Lower bound for the oscillatory integral `∫₀^∞ err(v) cos(tv) dv` on the band
`5.5 ≤ t ≤ 5.53125`. -/
theorem oscBandLower26 {t : ℝ} (ht0 : (5.5:ℝ) ≤ t) (ht1 : t ≤ 5.53125) :
    ((-0.10647839):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosB26i0 ht0 ht1)
    (cosB26i1 ht0 ht1))
    (cosB26i2 ht0 ht1))
    (cosB26i3 ht0 ht1))
    (cosB26i4 ht0 ht1))
    (cosB26i5 ht0 ht1))
    (cosB26i6 ht0 ht1))
    (cosB26i7 ht0 ht1))
    (cosB26i8 ht0 ht1))
    (cosB26i9 ht0 ht1))
    (cosB26i10 ht0 ht1))
    (cosB26i11 ht0 ht1))
    (cosB26i12 ht0 ht1))
    (cosB26i13 ht0 ht1))
    (cosB26i14 ht0 ht1))
    (cosB26i15 ht0 ht1))
    (cosB26i16 ht0 ht1))
    (cosB26i17 ht0 ht1))
    (cosB26i18 ht0 ht1))
    (cosB26i19 ht0 ht1))
    (cosB26i20 ht0 ht1))
    (cosB26i21 ht0 ht1))
    (cosB26i22 ht0 ht1))
    (cosB26i23 ht0 ht1))
    (cosB26i24 ht0 ht1))
    (cosB26i25 ht0 ht1))
    (cosB26i26 ht0 ht1))
    (cosB26i27 ht0 ht1))
    (cosB26i28 ht0 ht1))
    (cosB26i29 ht0 ht1))
    (cosB26i30 ht0 ht1))
    (cosB26i31 ht0 ht1))
    (cosB26i32 ht0 ht1))
    (cosB26i33 ht0 ht1))
    (cosB26i34 ht0 ht1))
    (cosB26i35 ht0 ht1))
    (cosB26i36 ht0 ht1))
    (cosB26i37 ht0 ht1))
    (cosB26i38 ht0 ht1))
    (cosB26i39 ht0 ht1))
    (cosB26i40 ht0 ht1))
    (cosB26i41 ht0 ht1))
    (cosB26i42 ht0 ht1))
    (cosB26i43 ht0 ht1))
    (cosB26i44 ht0 ht1))
    (cosB26i45 ht0 ht1))
    (cosB26i46 ht0 ht1))
    (cosB26i47 ht0 ht1))
    (cosB26i48 ht0 ht1))
    (cosB26i49 ht0 ht1))
    (cosB26i50 ht0 ht1))
    (cosB26i51 ht0 ht1))
    (cosB26i52 ht0 ht1))
    (cosB26i53 ht0 ht1))
    (cosB26i54 ht0 ht1))
    (cosB26i55 ht0 ht1))
    (cosB26i56 ht0 ht1))
    (cosB26i57 ht0 ht1))
    (cosB26i58 ht0 ht1))
    (cosB26i59 ht0 ht1))
    (cosB26i60 ht0 ht1))
    (cosB26i61 ht0 ht1))
    (cosB26i62 ht0 ht1))
    (cosB26i63 ht0 ht1))
    (cosB26i64 ht0 ht1))
    (cosB26i65 ht0 ht1))
    (cosB26i66 ht0 ht1))
    (cosB26i67 ht0 ht1))
    (cosB26i68 ht0 ht1))
    (cosB26i69 ht0 ht1))
    (cosB26i70 ht0 ht1))
    (cosB26i71 ht0 ht1))
    (cosB26i72 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 2.094) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 2.094) (S := 0.013709)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_cut
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
