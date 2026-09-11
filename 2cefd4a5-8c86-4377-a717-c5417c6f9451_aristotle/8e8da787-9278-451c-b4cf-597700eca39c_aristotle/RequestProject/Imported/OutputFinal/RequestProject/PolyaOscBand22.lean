/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscTail

/-!
# Oscillatory lower bound on the band `5.625 ≤ t ≤ 5.65625`

On each of the 73 blocks the factor `cos(tv)` is bracketed by a rational constant
`C` up to a rational error `h`; the signed contribution `min(C·P₀, C·P₁) - h·S` is
then summed, and the unresolved tail beyond `q = 2.094` is estimated in absolute
value.  The result is the bound `∫₀^∞ err(v) cos(tv) dv ≥ -0.11033871`.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosB22i0 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00641868):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.0038), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.02145302) (m := (0:ℤ)) (ylo := 0.02145302) (yhi := 0.02145302)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1) (q1 := 1.0038) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.0) (B := 0.0075856) (X := 0.02145302) (rho := 0.02145304)
    (clo := 0.99976989) (chi := 0.9997699) (C := 0.98915842) (h := 0.01084158)
    (by norm_num) (by norm_num) oscBlock0 vbpBr0.1 vbpBr1.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i1 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00625872):ℝ) ≤ ∫ v in (vBP 1.0038)..(vBP 1.0078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.06528206) (m := (0:ℤ)) (ylo := 0.06528206) (yhi := 0.06528206)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0038) (q1 := 1.0078) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.00758559) (B := 0.01553948) (X := 0.06528206) (rho := 0.02261313)
    (clo := 0.99786988) (chi := 0.99786989) (C := 0.98762837) (h := 0.01237163)
    (by norm_num) (by norm_num) oscBlock1 vbpBr1.1 vbpBr2.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i2 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.0057677):ℝ) ≤ ∫ v in (vBP 1.0078)..(vBP 1.0118), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.1100578) (m := (0:ℤ)) (ylo := 0.1100578) (yhi := 0.1100578)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0078) (q1 := 1.0118) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.01553947) (B := 0.02346185) (X := 0.1100578) (rho := 0.0226483)
    (clo := 0.99394975) (chi := 0.99394976) (C := 0.98565072) (h := 0.01434928)
    (by norm_num) (by norm_num) oscBlock2 vbpBr2.1 vbpBr3.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i3 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00554846):ℝ) ≤ ∫ v in (vBP 1.0118)..(vBP 1.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.15577006) (m := (0:ℤ)) (ylo := 0.15577006) (yhi := 0.15577006)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0118) (q1 := 1.016) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.02346184) (B := 0.0317467) (X := 0.15577006) (rho := 0.02379723)
    (clo := 0.98789235) (chi := 0.98789236) (C := 0.98204756) (h := 0.01795244)
    (by norm_num) (by norm_num) oscBlock3 vbpBr3.1 vbpBr4.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i4 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00539232):ℝ) ≤ ∫ v in (vBP 1.016)..(vBP 1.0205), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.20406817) (m := (0:ℤ)) (ylo := 0.20406817) (yhi := 0.20406817)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.016) (q1 := 1.0205) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.03174669) (B := 0.04058541) (X := 0.20406817) (rho := 0.02549306)
    (clo := 0.97925024) (chi := 0.97925025) (C := 0.97687859) (h := 0.02312141)
    (by norm_num) (by norm_num) oscBlock4 vbpBr4.1 vbpBr5.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i5 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00481935):ℝ) ≤ ∫ v in (vBP 1.0205)..(vBP 1.025), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.25381404) (m := (0:ℤ)) (ylo := 0.25381404) (yhi := 0.25381404)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0205) (q1 := 1.025) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.0405854) (B := 0.04938523) (X := 0.25381404) (rho := 0.02552118)
    (clo := 0.96796176) (chi := 0.96796177) (C := 0.96796176) (h := 0.02552119)
    (by norm_num) (by norm_num) oscBlock5 vbpBr5.1 vbpBr6.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i6 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00470372):ℝ) ≤ ∫ v in (vBP 1.025)..(vBP 1.03), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.30608792) (m := (0:ℤ)) (ylo := 0.30608792) (yhi := 0.30608792)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.025) (q1 := 1.03) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.04938522) (B := 0.05911761) (X := 0.30608792) (rho := 0.02829607)
    (clo := 0.95351969) (chi := 0.9535197) (C := 0.95351969) (h := 0.02829608)
    (by norm_num) (by norm_num) oscBlock6 vbpBr6.1 vbpBr7.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i7 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00441027):ℝ) ≤ ∫ v in (vBP 1.03)..(vBP 1.0355), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.36358316) (m := (0:ℤ)) (ylo := 0.36358316) (yhi := 0.36358316)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.03) (q1 := 1.0355) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.0591176) (B := 0.06976881) (X := 0.36358316) (rho := 0.03104668)
    (clo := 0.93462856) (chi := 0.93462857) (C := 0.93462856) (h := 0.03104669)
    (by norm_num) (by norm_num) oscBlock7 vbpBr7.1 vbpBr8.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i8 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.0039586):ℝ) ≤ ∫ v in (vBP 1.0355)..(vBP 1.0415), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.4262191) (m := (0:ℤ)) (ylo := 0.4262191) (yhi := 0.4262191)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0355) (q1 := 1.0415) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.0697688) (B := 0.08132397) (X := 0.4262191) (rho := 0.03376962)
    (clo := 0.91053539) (chi := 0.9105354) (C := 0.91053539) (h := 0.03376963)
    (by norm_num) (by norm_num) oscBlock8 vbpBr8.1 vbpBr9.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i9 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00337365):ℝ) ≤ ∫ v in (vBP 1.0415)..(vBP 1.048), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.49390894) (m := (0:ℤ)) (ylo := 0.49390894) (yhi := 0.49390894)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0415) (q1 := 1.048) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.08132396) (B := 0.09376718) (X := 0.49390894) (rho := 0.03646168)
    (clo := 0.88048647) (chi := 0.88048648) (C := 0.88048647) (h := 0.03646169)
    (by norm_num) (by norm_num) oscBlock9 vbpBr9.1 vbpBr10.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i10 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00270601):ℝ) ≤ ∫ v in (vBP 1.048)..(vBP 1.055), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.56656014) (m := (0:ℤ)) (ylo := 0.56656014) (yhi := 0.56656014)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.048) (q1 := 1.055) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.09376717) (B := 0.10708154) (X := 0.56656014) (rho := 0.03911983)
    (clo := 0.84375224) (chi := 0.84375226) (C := 0.84375225) (h := 0.03911984)
    (by norm_num) (by norm_num) oscBlock10 vbpBr10.1 vbpBr11.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i11 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00225199):ℝ) ≤ ∫ v in (vBP 1.055)..(vBP 1.064), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.6520545) (m := (0:ℤ)) (ylo := 0.6520545) (yhi := 0.6520545)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.055) (q1 := 1.064) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.10708153) (B := 0.12407079) (X := 0.6520545) (rho := 0.04972091)
    (clo := 0.79483876) (chi := 0.79483877) (C := 0.79483876) (h := 0.04972092)
    (by norm_num) (by norm_num) oscBlock11 vbpBr11.1 vbpBr12.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i12 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00147173):ℝ) ≤ ∫ v in (vBP 1.064)..(vBP 1.078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.77377572) (m := (0:ℤ)) (ylo := 0.77377572) (yhi := 0.77377572)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.064) (q1 := 1.078) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.12407078) (B := 0.15021495) (X := 0.77377572) (rho := 0.0758776)
    (clo := 0.71527714) (chi := 0.71527717) (C := 0.71527715) (h := 0.07587762)
    (by norm_num) (by norm_num) oscBlock12 vbpBr12.1 vbpBr13.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i13 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    (0.00020659:ℝ) ≤ ∫ v in (vBP 1.078)..(vBP 1.09), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.90992213) (m := (0:ℤ)) (ylo := 0.90992213) (yhi := 0.90992213)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.078) (q1 := 1.09) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.15021494) (B := 0.1723554) (X := 0.90992213) (rho := 0.06496311)
    (clo := 0.61380722) (chi := 0.61380734) (C := 0.61380728) (h := 0.06496317)
    (by norm_num) (by norm_num) oscBlock13 vbpBr13.1 vbpBr14.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i14 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    (0.00079139:ℝ) ≤ ∫ v in (vBP 1.09)..(vBP 1.1), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.02384774) (m := (0:ℤ)) (ylo := 1.02384774) (yhi := 1.02384774)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.09) (q1 := 1.1) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.17235539) (B := 0.19062036) (X := 1.02384774) (rho := 0.05434869)
    (clo := 0.52008339) (chi := 0.52008375) (C := 0.52008357) (h := 0.05434887)
    (by norm_num) (by norm_num) oscBlock14 vbpBr14.1 vbpBr15.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i15 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    (0.00091026:ℝ) ≤ ∫ v in (vBP 1.1)..(vBP 1.109), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.12130806) (m := (0:ℤ)) (ylo := 1.12130806) (yhi := 1.12130806)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.1) (q1 := 1.109) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.19062035) (B := 0.20691742) (X := 1.12130806) (rho := 0.04906861)
    (clo := 0.43450468) (chi := 0.43450555) (C := 0.43450511) (h := 0.04906905)
    (by norm_num) (by norm_num) oscBlock15 vbpBr15.1 vbpBr16.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i16 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    (0.00081276:ℝ) ≤ ∫ v in (vBP 1.109)..(vBP 1.117), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.20779962) (m := (0:ℤ)) (ylo := 1.20779962) (yhi := 1.20779962)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.109) (q1 := 1.117) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.20691741) (B := 0.22129305) (X := 1.20779962) (rho := 0.04388921)
    (clo := 0.35507723) (chi := 0.35507906) (C := 0.35507814) (h := 0.04389013)
    (by norm_num) (by norm_num) oscBlock16 vbpBr16.1 vbpBr17.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i17 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    (0.00063846:ℝ) ≤ ∫ v in (vBP 1.117)..(vBP 1.124), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.28356697) (m := (0:ℤ)) (ylo := 1.28356697) (yhi := 1.28356697)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.117) (q1 := 1.124) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.22129304) (B := 0.23378751) (X := 1.28356697) (rho := 0.03879364)
    (clo := 0.28329613) (chi := 0.28329949) (C := 0.28329781) (h := 0.03879532)
    (by norm_num) (by norm_num) oscBlock17 vbpBr17.1 vbpBr18.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i18 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    (0.0005014:ℝ) ≤ ∫ v in (vBP 1.124)..(vBP 1.131), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.35382416) (m := (0:ℤ)) (ylo := 1.35382416) (yhi := 1.35382416)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.124) (q1 := 1.131) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.2337875) (B := 0.2462044) (X := 1.35382416) (rho := 0.03876949)
    (clo := 0.21527369) (chi := 0.2152794) (C := 0.21527654) (h := 0.03877235)
    (by norm_num) (by norm_num) oscBlock18 vbpBr18.1 vbpBr19.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i19 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    (0.00032211:ℝ) ≤ ∫ v in (vBP 1.131)..(vBP 1.138), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.42364652) (m := (0:ℤ)) (ylo := 1.42364652) (yhi := 1.42364652)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.131) (q1 := 1.138) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.24620439) (B := 0.25854468) (X := 1.42364652) (rho := 0.03874684)
    (clo := 0.14661919) (chi := 0.14662863) (C := 0.14662391) (h := 0.03875156)
    (by norm_num) (by norm_num) oscBlock19 vbpBr19.1 vbpBr20.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i20 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    (0.00011561:ℝ) ≤ ∫ v in (vBP 1.138)..(vBP 1.145), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.49303937) (m := (0:ℤ)) (ylo := 1.49303937) (yhi := 1.49303937)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.138) (q1 := 1.145) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.25854467) (B := 0.27080928) (X := 1.49303937) (rho := 0.03872563)
    (clo := 0.07767837) (chi := 0.07769355) (C := 0.07768596) (h := 0.03873322)
    (by norm_num) (by norm_num) oscBlock20 vbpBr20.1 vbpBr21.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i21 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00011779):ℝ) ≤ ∫ v in (vBP 1.145)..(vBP 1.152), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.56200798) (m := (0:ℤ)) (ylo := 1.56200798) (yhi := 1.56200798)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.145) (q1 := 1.152) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.27080927) (B := 0.28299913) (X := 1.56200798) (rho := 0.03870586)
    (clo := 0.00878779) (chi := 0.00881163) (C := 0.00879971) (h := 0.03871778)
    (by norm_num) (by norm_num) oscBlock21 vbpBr21.1 vbpBr22.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i22 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00038398):ℝ) ≤ ∫ v in (vBP 1.152)..(vBP 1.159), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.6305575) (m := (0:ℤ)) (ylo := 0.05976117) (yhi := 0.05976118)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.152) (q1 := 1.159) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.28299912) (B := 0.29511513) (X := 1.6305575) (rho := 0.03868747)
    (clo := (-0.05972562)) (chi := (-0.0597256)) (C := (-0.05972561)) (h := 0.03868748)
    (by norm_num) (by norm_num) oscBlock22 vbpBr22.1 vbpBr23.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i23 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00065407):ℝ) ≤ ∫ v in (vBP 1.159)..(vBP 1.166), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.698693) (m := (0:ℤ)) (ylo := 0.12789667) (yhi := 0.12789668)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.159) (q1 := 1.166) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.29511512) (B := 0.30715818) (X := 1.698693) (rho := 0.03867047)
    (clo := (-0.12754829)) (chi := (-0.12754827)) (C := (-0.12754828)) (h := 0.03867048)
    (by norm_num) (by norm_num) oscBlock23 vbpBr23.1 vbpBr24.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i24 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00091647):ℝ) ≤ ∫ v in (vBP 1.166)..(vBP 1.173), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.76641945) (m := (0:ℤ)) (ylo := 0.19562312) (yhi := 0.19562313)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.166) (q1 := 1.173) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.30715817) (B := 0.31912914) (X := 1.76641945) (rho := 0.03865476)
    (clo := (-0.19437782)) (chi := (-0.1943778)) (C := (-0.19437781)) (h := 0.03865477)
    (by norm_num) (by norm_num) oscBlock24 vbpBr24.1 vbpBr25.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i25 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00116376):ℝ) ≤ ∫ v in (vBP 1.173)..(vBP 1.18), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.83374172) (m := (0:ℤ)) (ylo := 0.26294539) (yhi := 0.2629454)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.173) (q1 := 1.18) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.31912913) (B := 0.33102888) (X := 1.83374172) (rho := 0.03864039)
    (clo := (-0.25992584)) (chi := (-0.25992582)) (C := (-0.25992583)) (h := 0.0386404)
    (by norm_num) (by norm_num) oscBlock25 vbpBr25.1 vbpBr26.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i26 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00138956):ℝ) ≤ ∫ v in (vBP 1.18)..(vBP 1.187), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.90066465) (m := (0:ℤ)) (ylo := 0.32986832) (yhi := 0.32986833)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.18) (q1 := 1.187) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.33102887) (B := 0.34285824) (X := 1.90066465) (rho := 0.03862728)
    (clo := (-0.32391847)) (chi := (-0.32391845)) (C := (-0.32391846)) (h := 0.03862729)
    (by norm_num) (by norm_num) oscBlock26 vbpBr26.1 vbpBr27.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i27 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00158857):ℝ) ≤ ∫ v in (vBP 1.187)..(vBP 1.194), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.96719291) (m := (0:ℤ)) (ylo := 0.39639658) (yhi := 0.39639659)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.187) (q1 := 1.194) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.34285823) (B := 0.35461804) (X := 1.96719291) (rho := 0.03861539)
    (clo := (-0.38609687)) (chi := (-0.38609685)) (C := (-0.38609686)) (h := 0.0386154)
    (by norm_num) (by norm_num) oscBlock27 vbpBr27.1 vbpBr28.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i28 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00177465):ℝ) ≤ ∫ v in (vBP 1.194)..(vBP 1.201), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.03333107) (m := (0:ℤ)) (ylo := 0.46253474) (yhi := 0.46253475)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.194) (q1 := 1.201) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.35461802) (B := 0.36630909) (X := 2.03333107) (rho := 0.03860473)
    (clo := (-0.44621795)) (chi := (-0.44621793)) (C := (-0.44621794)) (h := 0.03860474)
    (by norm_num) (by norm_num) oscBlock28 vbpBr28.1 vbpBr29.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i29 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00191046):ℝ) ≤ ∫ v in (vBP 1.201)..(vBP 1.208), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.09908379) (m := (0:ℤ)) (ylo := 0.52828746) (yhi := 0.52828747)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.201) (q1 := 1.208) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.36630908) (B := 0.3779322) (X := 2.09908379) (rho := 0.03859523)
    (clo := (-0.50405502)) (chi := (-0.504055)) (C := (-0.50405501)) (h := 0.03859524)
    (by norm_num) (by norm_num) oscBlock29 vbpBr29.1 vbpBr30.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i30 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00201002):ℝ) ≤ ∫ v in (vBP 1.208)..(vBP 1.215), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.16445548) (m := (0:ℤ)) (ylo := 0.59365915) (yhi := 0.59365916)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.208) (q1 := 1.215) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.37793219) (B := 0.38948816) (X := 2.16445548) (rho := 0.03858693)
    (clo := (-0.55939784)) (chi := (-0.55939782)) (C := (-0.55939783)) (h := 0.03858694)
    (by norm_num) (by norm_num) oscBlock30 vbpBr30.1 vbpBr31.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i31 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00238847):ℝ) ≤ ∫ v in (vBP 1.215)..(vBP 1.223), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.23407734) (m := (0:ℤ)) (ylo := 0.66328101) (yhi := 0.66328102)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.215) (q1 := 1.223) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.38948815) (B := 0.40261372) (X := 2.23407734) (rho := 0.04320652)
    (clo := (-0.61570553)) (chi := (-0.61570551)) (C := (-0.61570552)) (h := 0.04320653)
    (by norm_num) (by norm_num) oscBlock31 vbpBr31.1 vbpBr32.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i32 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00241312):ℝ) ≤ ∫ v in (vBP 1.223)..(vBP 1.231), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.30787167) (m := (0:ℤ)) (ylo := 0.73707534) (yhi := 0.73707535)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.223) (q1 := 1.231) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.40261371) (B := 0.4156537) (X := 2.30787167) (rho := 0.04316958)
    (clo := (-0.67212527)) (chi := (-0.67212526)) (C := (-0.67212527)) (h := 0.04316959)
    (by norm_num) (by norm_num) oscBlock32 vbpBr32.1 vbpBr33.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i33 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00238398):ℝ) ≤ ∫ v in (vBP 1.231)..(vBP 1.239), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.38118642) (m := (0:ℤ)) (ylo := 0.81039009) (yhi := 0.8103901)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.231) (q1 := 1.239) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.41565369) (B := 0.42860921) (X := 2.38118642) (rho := 0.04313443)
    (clo := (-0.7245561)) (chi := (-0.72455608)) (C := (-0.72455609)) (h := 0.04313444)
    (by norm_num) (by norm_num) oscBlock33 vbpBr33.1 vbpBr34.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i34 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00259924):ℝ) ≤ ∫ v in (vBP 1.239)..(vBP 1.248), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.45856186) (m := (0:ℤ)) (ylo := 0.88776553) (yhi := 0.88776554)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.239) (q1 := 1.248) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.4286092) (B := 0.44308455) (X := 2.45856186) (rho := 0.04763513)
    (clo := (-0.77566342)) (chi := (-0.7756634)) (C := (-0.77566341)) (h := 0.04763514)
    (by norm_num) (by norm_num) oscBlock34 vbpBr34.1 vbpBr35.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i35 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00270381):ℝ) ≤ ∫ v in (vBP 1.248)..(vBP 1.258), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.54441561) (m := (0:ℤ)) (ylo := 0.97361928) (yhi := 0.97361929)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.248) (q1 := 1.258) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.44308453) (B := 0.45904632) (X := 2.54441561) (rho := 0.05206515)
    (clo := (-0.82692631)) (chi := (-0.82692628)) (C := (-0.8269263)) (h := 0.05206517)
    (by norm_num) (by norm_num) oscBlock35 vbpBr35.1 vbpBr36.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i36 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00245191):ℝ) ≤ ∫ v in (vBP 1.258)..(vBP 1.268), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.63409261) (m := (0:ℤ)) (ylo := 1.06329628) (yhi := 1.06329629)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.258) (q1 := 1.268) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.45904631) (B := 0.47488172) (X := 2.63409261) (rho := 0.05195713)
    (clo := (-0.87396226)) (chi := (-0.87396219)) (C := (-0.87396223)) (h := 0.05195717)
    (by norm_num) (by norm_num) oscBlock36 vbpBr36.1 vbpBr37.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i37 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00255291):ℝ) ≤ ∫ v in (vBP 1.268)..(vBP 1.28), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.73190713) (m := (0:ℤ)) (ylo := 1.1611108) (yhi := 1.16111081)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.268) (q1 := 1.28) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.4748817) (B := 0.49372017) (X := 2.73190713) (rho := 0.06069759)
    (clo := (-0.91724627)) (chi := (-0.91724612)) (C := (-0.9172462)) (h := 0.06069767)
    (by norm_num) (by norm_num) oscBlock37 vbpBr37.1 vbpBr38.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i38 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00228621):ℝ) ≤ ∫ v in (vBP 1.28)..(vBP 1.294), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.84641961) (m := (0:ℤ)) (ylo := 1.27562328) (yhi := 1.27562329)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.28) (q1 := 1.294) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.49372014) (B := 0.51547641) (X := 2.84641961) (rho := 0.06924384)
    (clo := (-0.95675219)) (chi := (-0.95675181)) (C := (-0.94375399)) (h := 0.05624602)
    (by norm_num) (by norm_num) oscBlock38 vbpBr38.1 vbpBr39.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i39 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00152769):ℝ) ≤ ∫ v in (vBP 1.294)..(vBP 1.308), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.96847628) (m := (0:ℤ)) (ylo := 1.39767995) (yhi := 1.39767996)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.294) (q1 := 1.308) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.51547638) (B := 0.53699853) (X := 2.96847628) (rho := 0.06892166)
    (clo := (-0.98505374)) (chi := (-0.98505273)) (C := (-0.95806554)) (h := 0.04193447)
    (by norm_num) (by norm_num) oscBlock39 vbpBr39.1 vbpBr40.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i40 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00099395):ℝ) ≤ ∫ v in (vBP 1.308)..(vBP 1.326), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.1063148) (m := (0:ℤ)) (ylo := 1.53551847) (yhi := 1.53551848)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.308) (q1 := 1.326) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.53699848) (B := 0.56433382) (X := 3.1063148) (rho := 0.08569837)
    (clo := (-0.99938057)) (chi := (-0.99937775)) (C := (-0.95683969)) (h := 0.04316031)
    (by norm_num) (by norm_num) oscBlock40 vbpBr40.1 vbpBr41.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i41 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    (0.00002802:ℝ) ≤ ∫ v in (vBP 1.326)..(vBP 1.345), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.26366743) (m := (0:ℤ)) (ylo := 0.12207477) (yhi := 0.12207478)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.326) (q1 := 1.345) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.56433374) (B := 0.59278808) (X := 3.26366743) (rho := 0.08929016)
    (clo := (-0.99255813)) (chi := (-0.99255812)) (C := (-0.95163398)) (h := 0.04836602)
    (by norm_num) (by norm_num) oscBlock41 vbpBr41.1 vbpBr42.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i42 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    (0.00092:ℝ) ≤ ∫ v in (vBP 1.345)..(vBP 1.362), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.41473861) (m := (0:ℤ)) (ylo := 0.27314595) (yhi := 0.27314596)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.345) (q1 := 1.362) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.59278796) (B := 0.6179085) (X := 3.41473861) (rho := 0.08030635)
    (clo := (-0.96292701)) (chi := (-0.962927)) (C := (-0.94131033)) (h := 0.05868968)
    (by norm_num) (by norm_num) oscBlock42 vbpBr42.1 vbpBr43.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i43 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    (0.00107246:ℝ) ≤ ∫ v in (vBP 1.362)..(vBP 1.376), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.54323352) (m := (0:ℤ)) (ylo := 0.40164086) (yhi := 0.40164087)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.362) (q1 := 1.376) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.61790831) (B := 0.6383616) (X := 3.54323352) (rho := 0.06749929)
    (clo := (-0.92042078)) (chi := (-0.92042076)) (C := (-0.92042077)) (h := 0.0674993)
    (by norm_num) (by norm_num) oscBlock43 vbpBr43.1 vbpBr44.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i44 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    (0.00119305:ℝ) ≤ ∫ v in (vBP 1.376)..(vBP 1.39), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.65801605) (m := (0:ℤ)) (ylo := 0.51642339) (yhi := 0.5164234)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.376) (q1 := 1.39) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.63836133) (B := 0.65860767) (X := 3.65801605) (rho := 0.06723359)
    (clo := (-0.86959078)) (chi := (-0.86959076)) (C := (-0.86959077)) (h := 0.0672336)
    (by norm_num) (by norm_num) oscBlock44 vbpBr44.1 vbpBr45.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i45 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    (0.00118576:ℝ) ≤ ∫ v in (vBP 1.39)..(vBP 1.404), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.77164246) (m := (0:ℤ)) (ylo := 0.6300498) (yhi := 0.63004981)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.39) (q1 := 1.404) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.65860729) (B := 0.67865086) (X := 3.77164246) (rho := 0.06697648)
    (clo := (-0.80799818)) (chi := (-0.80799816)) (C := (-0.80799817)) (h := 0.06697649)
    (by norm_num) (by norm_num) oscBlock45 vbpBr45.1 vbpBr46.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i46 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    (0.0010754:ℝ) ≤ ∫ v in (vBP 1.404)..(vBP 1.418), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.88413576) (m := (0:ℤ)) (ylo := 0.7425431) (yhi := 0.74254311)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.404) (q1 := 1.418) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.67865033) (B := 0.69849519) (X := 3.88413576) (rho := 0.06672767)
    (clo := (-0.73675141)) (chi := (-0.73675138)) (C := (-0.7367514)) (h := 0.06672769)
    (by norm_num) (by norm_num) oscBlock46 vbpBr46.1 vbpBr47.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i47 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    (0.00089254:ℝ) ≤ ∫ v in (vBP 1.418)..(vBP 1.432), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.99551836) (m := (0:ℤ)) (ylo := 0.8539257) (yhi := 0.85392571)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.418) (q1 := 1.432) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.69849446) (B := 0.7181446) (X := 3.99551836) (rho := 0.06648704)
    (clo := (-0.65702883)) (chi := (-0.65702875)) (C := (-0.65702879)) (h := 0.06648708)
    (by norm_num) (by norm_num) oscBlock47 vbpBr47.1 vbpBr48.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i48 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    (0.00066952:ℝ) ≤ ∫ v in (vBP 1.432)..(vBP 1.446), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.10581196) (m := (0:ℤ)) (ylo := 0.9642193) (yhi := 0.96421931)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.432) (q1 := 1.446) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.7181436) (B := 0.73760286) (X := 4.10581196) (rho := 0.06625423)
    (clo := (-0.57005867)) (chi := (-0.57005846)) (C := (-0.57005857)) (h := 0.06625434)
    (by norm_num) (by norm_num) oscBlock48 vbpBr48.1 vbpBr49.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i49 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    (0.00046358:ℝ) ≤ ∫ v in (vBP 1.446)..(vBP 1.462), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.2227808) (m := (0:ℤ)) (ylo := 1.08118814) (yhi := 1.08118815)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.446) (q1 := 1.462) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.73760153) (B := 0.75961158) (X := 4.2227808) (rho := 0.07377221)
    (clo := (-0.47028074)) (chi := (-0.47028012)) (C := (-0.47028043)) (h := 0.07377252)
    (by norm_num) (by norm_num) oscBlock49 vbpBr49.1 vbpBr50.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i50 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00029543):ℝ) ≤ ∫ v in (vBP 1.462)..(vBP 1.478), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.34624496) (m := (0:ℤ)) (ylo := 1.2046523) (yhi := 1.20465231)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.462) (q1 := 1.478) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.75960973) (B := 0.78138081) (X := 4.34624496) (rho := 0.07344025)
    (clo := (-0.35801948)) (chi := (-0.35801769)) (C := (-0.35801859)) (h := 0.07344115)
    (by norm_num) (by norm_num) oscBlock50 vbpBr50.1 vbpBr51.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i51 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00041048):ℝ) ≤ ∫ v in (vBP 1.478)..(vBP 1.495), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.47215734) (m := (0:ℤ)) (ylo := 1.33056468) (yhi := 1.33056469)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.478) (q1 := 1.495) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.7813783) (B := 0.80425401) (X := 4.47215734) (rho := 0.07690442)
    (clo := (-0.23793236)) (chi := (-0.23792755)) (C := (-0.23792996)) (h := 0.07690683)
    (by norm_num) (by norm_num) oscBlock51 vbpBr51.1 vbpBr52.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i52 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00025684):ℝ) ≤ ∫ v in (vBP 1.495)..(vBP 1.512), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.60044279) (m := (0:ℤ)) (ylo := 1.45885013) (yhi := 1.45885014)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.495) (q1 := 1.512) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.80425056) (B := 0.82686872) (X := 4.60044279) (rho := 0.07653341)
    (clo := (-0.11172437)) (chi := (-0.11171232)) (C := (-0.11171835)) (h := 0.07653944)
    (by norm_num) (by norm_num) oscBlock52 vbpBr52.1 vbpBr53.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i53 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00020947):ℝ) ≤ ∫ v in (vBP 1.512)..(vBP 1.531), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.7346799) (m := (0:ℤ)) (ylo := 0.02229091) (yhi := 0.02229092)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.512) (q1 := 1.531) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.82686405) (B := 0.85184522) (X := 4.7346799) (rho := 0.08356964)
    (clo := 0.02228906) (chi := 0.02228908) (C := 0.02228907) (h := 0.08356965)
    (by norm_num) (by norm_num) oscBlock53 vbpBr53.1 vbpBr54.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i54 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00044354):ℝ) ≤ ∫ v in (vBP 1.531)..(vBP 1.55), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.87468749) (m := (0:ℤ)) (ylo := 0.1622985) (yhi := 0.16229851)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.531) (q1 := 1.55) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.85183877) (B := 0.87651393) (X := 4.87468749) (rho := 0.08309443)
    (clo := 0.16158692) (chi := 0.16158694) (C := 0.16158693) (h := 0.08309444)
    (by norm_num) (by norm_num) oscBlock54 vbpBr54.1 vbpBr55.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i55 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00067462):ℝ) ≤ ∫ v in (vBP 1.55)..(vBP 1.57), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.01658287) (m := (0:ℤ)) (ylo := 0.30419388) (yhi := 0.30419389)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.55) (q1 := 1.57) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.87650515) (B := 0.90215678) (X := 5.01658287) (rho := 0.08624142)
    (clo := 0.29952416) (chi := 0.29952418) (C := 0.29952417) (h := 0.08624143)
    (by norm_num) (by norm_num) oscBlock55 vbpBr55.1 vbpBr56.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i56 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00082961):ℝ) ≤ ∫ v in (vBP 1.57)..(vBP 1.59), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.16029887) (m := (0:ℤ)) (ylo := 0.44790988) (yhi := 0.44790989)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.57) (q1 := 1.59) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.90214481) (B := 0.92747548) (X := 5.16029887) (rho := 0.08573433)
    (clo := 0.43308254) (chi := 0.43308256) (C := 0.43308255) (h := 0.08573434)
    (by norm_num) (by norm_num) oscBlock56 vbpBr56.1 vbpBr57.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i57 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00093913):ℝ) ≤ ∫ v in (vBP 1.59)..(vBP 1.61), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.30220708) (m := (0:ℤ)) (ylo := 0.58981809) (yhi := 0.5898181)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.59) (q1 := 1.61) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.92745939) (B := 0.95247825) (X := 5.30220708) (rho := 0.08524803)
    (clo := 0.55620985) (chi := 0.55620987) (C := 0.55620986) (h := 0.08524804)
    (by norm_num) (by norm_num) oscBlock57 vbpBr57.1 vbpBr58.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i58 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00113959):ℝ) ≤ ∫ v in (vBP 1.61)..(vBP 1.632), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.44928933) (m := (0:ℤ)) (ylo := 0.73690034) (yhi := 0.73690035)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.61) (q1 := 1.632) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.95245689) (B := 0.97962584) (X := 5.44928933) (rho := 0.09171934)
    (clo := 0.67199567) (chi := 0.67199569) (C := 0.67199568) (h := 0.09171935)
    (by norm_num) (by norm_num) oscBlock58 vbpBr58.1 vbpBr59.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i59 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00131804):ℝ) ≤ ∫ v in (vBP 1.632)..(vBP 1.656), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.60820921) (m := (0:ℤ)) (ylo := 0.89582022) (yhi := 0.89582023)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.632) (q1 := 1.656) (t0 := 5.625) (t1 := 5.65625)
    (A := 0.97959707) (B := 1.00882827) (X := 5.60820921) (rho := 0.09797571)
    (clo := 0.78072188) (chi := 0.7807219) (C := 0.78072189) (h := 0.09797572)
    (by norm_num) (by norm_num) oscBlock59 vbpBr59.1 vbpBr60.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i60 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00131439):ℝ) ≤ ∫ v in (vBP 1.656)..(vBP 1.68), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.77171558) (m := (0:ℤ)) (ylo := 1.05932659) (yhi := 1.0593266)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.656) (q1 := 1.68) (t0 := 5.625) (t1 := 5.65625)
    (A := 1.00878907) (B := 1.03761196) (X := 5.77171558) (rho := 0.09727708)
    (clo := 0.87202607) (chi := 0.87202613) (C := 0.8720261) (h := 0.09727711)
    (by norm_num) (by norm_num) oscBlock60 vbpBr60.1 vbpBr61.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i61 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00122808):ℝ) ≤ ∫ v in (vBP 1.68)..(vBP 1.704), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.93288618) (m := (0:ℤ)) (ylo := 1.22049719) (yhi := 1.2204972)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.68) (q1 := 1.704) (t0 := 5.625) (t1 := 5.65625)
    (A := 1.03755935) (B := 1.06598913) (X := 5.93288618) (rho := 0.09661485)
    (clo := 0.93927009) (chi := 0.93927033) (C := 0.92132762) (h := 0.07867238)
    (by norm_num) (by norm_num) oscBlock61 vbpBr61.1 vbpBr62.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i62 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00137159):ℝ) ≤ ∫ v in (vBP 1.704)..(vBP 1.734), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.11140055) (m := (0:ℤ)) (ylo := 1.39901156) (yhi := 1.39901157)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.704) (q1 := 1.734) (t0 := 5.625) (t1 := 5.65625)
    (A := 1.06591948) (B := 1.10090679) (X := 6.11140055) (rho := 0.11560349)
    (clo := 0.98528123) (chi := 0.98528225) (C := 0.93483887) (h := 0.06516113)
    (by norm_num) (by norm_num) oscBlock62 vbpBr62.1 vbpBr63.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i63 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00129873):ℝ) ≤ ∫ v in (vBP 1.734)..(vBP 1.766), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.31301124) (m := (1:ℤ)) (ylo := 0.02982593) (yhi := 0.02982594)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.734) (q1 := 1.766) (t0 := 5.625) (t1 := 5.65625)
    (A := 1.10080961) (B := 1.13749718) (X := 6.31301124) (rho := 0.1209572)
    (clo := 0.99955523) (chi := 0.99955524) (C := 0.93929901) (h := 0.06070099)
    (by norm_num) (by norm_num) oscBlock63 vbpBr63.1 vbpBr64.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i64 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00107612):ℝ) ≤ ∫ v in (vBP 1.766)..(vBP 1.796), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.51115334) (m := (1:ℤ)) (ylo := 0.22796803) (yhi := 0.22796804)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.766) (q1 := 1.796) (t0 := 5.625) (t1 := 5.65625)
    (A := 1.1373613) (B := 1.17120873) (X := 6.51115334) (rho := 0.11349605)
    (clo := 0.97412762) (chi := 0.97412763) (C := 0.93031578) (h := 0.06968422)
    (by norm_num) (by norm_num) oscBlock64 vbpBr64.1 vbpBr65.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i65 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00105478):ℝ) ≤ ∫ v in (vBP 1.796)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.70581106) (m := (1:ℤ)) (ylo := 0.42262575) (yhi := 0.42262576)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.796) (q1 := 1.828) (t0 := 5.625) (t1 := 5.65625)
    (A := 1.1710258) (B := 1.20655947) (X := 6.70581106) (rho := 0.11879095)
    (clo := 0.91201511) (chi := 0.91201512) (C := 0.89661208) (h := 0.10338792)
    (by norm_num) (by norm_num) oscBlock65 vbpBr65.1 vbpBr66.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i66 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.0008997):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.86), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.90332011) (m := (1:ℤ)) (ylo := 0.6201348) (yhi := 0.62013481)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.828) (q1 := 1.86) (t0 := 5.625) (t1 := 5.65625)
    (A := 1.20631244) (B := 1.24130524) (X := 6.90332011) (rho := 0.11781266)
    (clo := 0.81380011) (chi := 0.81380013) (C := 0.81380012) (h := 0.11781267)
    (by norm_num) (by norm_num) oscBlock66 vbpBr66.1 vbpBr67.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i67 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00064469):ℝ) ≤ ∫ v in (vBP 1.86)..(vBP 1.89), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.09144016) (m := (1:ℤ)) (ylo := 0.80825485) (yhi := 0.80825486)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.86) (q1 := 1.89) (t0 := 5.625) (t1 := 5.65625)
    (A := 1.24097685) (B := 1.27334993) (X := 7.09144016) (rho := 0.1109454)
    (clo := 0.69076136) (chi := 0.69076141) (C := 0.69076138) (h := 0.11094543)
    (by norm_num) (by norm_num) oscBlock67 vbpBr67.1 vbpBr68.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i68 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.0005132):ℝ) ≤ ∫ v in (vBP 1.89)..(vBP 1.922), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.27642787) (m := (1:ℤ)) (ylo := 0.99324256) (yhi := 0.99324257)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.89) (q1 := 1.922) (t0 := 5.625) (t1 := 5.65625)
    (A := 1.27292668) (B := 1.30698664) (X := 7.27642787) (rho := 0.11621532)
    (clo := 0.5459761) (chi := 0.54597638) (C := 0.54597624) (h := 0.11621546)
    (by norm_num) (by norm_num) oscBlock68 vbpBr68.1 vbpBr69.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i69 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00049517):ℝ) ≤ ∫ v in (vBP 1.922)..(vBP 1.969), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.50764115) (m := (1:ℤ)) (ylo := 1.22445584) (yhi := 1.22445585)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.922) (q1 := 1.969) (t0 := 5.625) (t1 := 5.65625)
    (A := 1.30643896) (B := 1.35541448) (X := 7.50764115) (rho := 0.15892202)
    (clo := 0.33945783) (chi := 0.33945994) (C := 0.33945888) (h := 0.15892308)
    (by norm_num) (by norm_num) oscBlock69 vbpBr69.1 vbpBr70.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i70 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00020362):ℝ) ≤ ∫ v in (vBP 1.969)..(vBP 2.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.77701852) (m := (1:ℤ)) (ylo := 1.49383321) (yhi := 1.49383322)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.969) (q1 := 2.016) (t0 := 5.625) (t1 := 5.65625)
    (A := 1.35463226) (B := 1.4027369) (X := 7.77701852) (rho := 0.15721208)
    (clo := 0.07688689) (chi := 0.07690216) (C := 0.07689452) (h := 0.15721972)
    (by norm_num) (by norm_num) oscBlock70 vbpBr70.1 vbpBr71.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i71 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00026379):ℝ) ≤ ∫ v in (vBP 2.016)..(vBP 2.062), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.03736622) (m := (1:ℤ)) (ylo := 0.18338458) (yhi := 0.18338459)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.016) (q1 := 2.062) (t0 := 5.625) (t1 := 5.65625)
    (A := 1.40164597) (B := 1.44803958) (X := 8.03736622) (rho := 0.15310766)
    (clo := (-0.18235845)) (chi := (-0.18235843)) (C := (-0.18235844)) (h := 0.15310767)
    (by norm_num) (by norm_num) oscBlock71 vbpBr71.1 vbpBr72.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB22i72 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.00025619):ℝ) ≤ ∫ v in (vBP 2.062)..(vBP 2.094), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.25122397) (m := (1:ℤ)) (ylo := 0.39724233) (yhi := 0.39724234)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.062) (q1 := 2.094) (t0 := 5.625) (t1 := 5.65625)
    (A := 1.44655973) (B := 1.47899217) (X := 8.25122397) (rho := 0.11432551)
    (clo := (-0.3868769)) (chi := (-0.38687688)) (C := (-0.38687689)) (h := 0.11432552)
    (by norm_num) (by norm_num) oscBlock72 vbpBr72.1 vbpBr73.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

/-- Lower bound for the oscillatory integral `∫₀^∞ err(v) cos(tv) dv` on the band
`5.625 ≤ t ≤ 5.65625`. -/
theorem oscBandLower22 {t : ℝ} (ht0 : (5.625:ℝ) ≤ t) (ht1 : t ≤ 5.65625) :
    ((-0.11033871):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosB22i0 ht0 ht1)
    (cosB22i1 ht0 ht1))
    (cosB22i2 ht0 ht1))
    (cosB22i3 ht0 ht1))
    (cosB22i4 ht0 ht1))
    (cosB22i5 ht0 ht1))
    (cosB22i6 ht0 ht1))
    (cosB22i7 ht0 ht1))
    (cosB22i8 ht0 ht1))
    (cosB22i9 ht0 ht1))
    (cosB22i10 ht0 ht1))
    (cosB22i11 ht0 ht1))
    (cosB22i12 ht0 ht1))
    (cosB22i13 ht0 ht1))
    (cosB22i14 ht0 ht1))
    (cosB22i15 ht0 ht1))
    (cosB22i16 ht0 ht1))
    (cosB22i17 ht0 ht1))
    (cosB22i18 ht0 ht1))
    (cosB22i19 ht0 ht1))
    (cosB22i20 ht0 ht1))
    (cosB22i21 ht0 ht1))
    (cosB22i22 ht0 ht1))
    (cosB22i23 ht0 ht1))
    (cosB22i24 ht0 ht1))
    (cosB22i25 ht0 ht1))
    (cosB22i26 ht0 ht1))
    (cosB22i27 ht0 ht1))
    (cosB22i28 ht0 ht1))
    (cosB22i29 ht0 ht1))
    (cosB22i30 ht0 ht1))
    (cosB22i31 ht0 ht1))
    (cosB22i32 ht0 ht1))
    (cosB22i33 ht0 ht1))
    (cosB22i34 ht0 ht1))
    (cosB22i35 ht0 ht1))
    (cosB22i36 ht0 ht1))
    (cosB22i37 ht0 ht1))
    (cosB22i38 ht0 ht1))
    (cosB22i39 ht0 ht1))
    (cosB22i40 ht0 ht1))
    (cosB22i41 ht0 ht1))
    (cosB22i42 ht0 ht1))
    (cosB22i43 ht0 ht1))
    (cosB22i44 ht0 ht1))
    (cosB22i45 ht0 ht1))
    (cosB22i46 ht0 ht1))
    (cosB22i47 ht0 ht1))
    (cosB22i48 ht0 ht1))
    (cosB22i49 ht0 ht1))
    (cosB22i50 ht0 ht1))
    (cosB22i51 ht0 ht1))
    (cosB22i52 ht0 ht1))
    (cosB22i53 ht0 ht1))
    (cosB22i54 ht0 ht1))
    (cosB22i55 ht0 ht1))
    (cosB22i56 ht0 ht1))
    (cosB22i57 ht0 ht1))
    (cosB22i58 ht0 ht1))
    (cosB22i59 ht0 ht1))
    (cosB22i60 ht0 ht1))
    (cosB22i61 ht0 ht1))
    (cosB22i62 ht0 ht1))
    (cosB22i63 ht0 ht1))
    (cosB22i64 ht0 ht1))
    (cosB22i65 ht0 ht1))
    (cosB22i66 ht0 ht1))
    (cosB22i67 ht0 ht1))
    (cosB22i68 ht0 ht1))
    (cosB22i69 ht0 ht1))
    (cosB22i70 ht0 ht1))
    (cosB22i71 ht0 ht1))
    (cosB22i72 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 2.094) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 2.094) (S := 0.013709)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_cut
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
