/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscTail

/-!
# Oscillatory lower bound on the band `5.875 ≤ t ≤ 5.9375`

On each of the 73 blocks the factor `cos(tv)` is bracketed by a rational constant
`C` up to a rational error `h`; the signed contribution `min(C·P₀, C·P₁) - h·S` is
then summed, and the unresolved tail beyond `q = 2.094` is estimated in absolute
value.  The result is the bound `∫₀^∞ err(v) cos(tv) dv ≥ -0.11995113`.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosB15i0 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00641868):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.0038), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.02251975) (m := (0:ℤ)) (ylo := 0.02251975) (yhi := 0.02251975)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1) (q1 := 1.0038) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.0) (B := 0.0075856) (X := 0.02251975) (rho := 0.02251976)
    (clo := 0.99974644) (chi := 0.99974645) (C := 0.98861334) (h := 0.01138666)
    (by norm_num) (by norm_num) oscBlock0 vbpBr0.1 vbpBr1.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i1 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00625872):ℝ) ≤ ∫ v in (vBP 1.0038)..(vBP 1.0078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.0684155) (m := (0:ℤ)) (ylo := 0.0684155) (yhi := 0.0684155)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0038) (q1 := 1.0078) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.00758559) (B := 0.01553948) (X := 0.0684155) (rho := 0.02385018)
    (clo := 0.99766057) (chi := 0.99766058) (C := 0.98690519) (h := 0.01309481)
    (by norm_num) (by norm_num) oscBlock1 vbpBr1.1 vbpBr2.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i2 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.0057677):ℝ) ≤ ∫ v in (vBP 1.0078)..(vBP 1.0118), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.11529956) (m := (0:ℤ)) (ylo := 0.11529956) (yhi := 0.11529956)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0078) (q1 := 1.0118) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.01553947) (B := 0.02346185) (X := 0.11529956) (rho := 0.02400519)
    (clo := 0.99336036) (chi := 0.99336037) (C := 0.98467758) (h := 0.01532242)
    (by norm_num) (by norm_num) oscBlock2 vbpBr2.1 vbpBr3.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i3 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00554846):ℝ) ≤ ∫ v in (vBP 1.0118)..(vBP 1.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.16316717) (m := (0:ℤ)) (ylo := 0.16316717) (yhi := 0.16316717)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0118) (q1 := 1.016) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.02346184) (B := 0.0317467) (X := 0.16316717) (rho := 0.02532888)
    (clo := 0.98671774) (chi := 0.98671775) (C := 0.98069443) (h := 0.01930557)
    (by norm_num) (by norm_num) oscBlock3 vbpBr3.1 vbpBr4.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i4 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00539232):ℝ) ≤ ∫ v in (vBP 1.016)..(vBP 1.0205), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.21374383) (m := (0:ℤ)) (ylo := 0.21374383) (yhi := 0.21374383)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.016) (q1 := 1.0205) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.03174669) (B := 0.04058541) (X := 0.21374383) (rho := 0.02723205)
    (clo := 0.97724362) (chi := 0.97724363) (C := 0.97500578) (h := 0.02499422)
    (by norm_num) (by norm_num) oscBlock4 vbpBr4.1 vbpBr5.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i5 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00481345):ℝ) ≤ ∫ v in (vBP 1.0205)..(vBP 1.025), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.26583201) (m := (0:ℤ)) (ylo := 0.26583201) (yhi := 0.26583201)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0205) (q1 := 1.025) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.0405854) (B := 0.04938523) (X := 0.26583201) (rho := 0.0273928)
    (clo := 0.96487425) (chi := 0.96487426) (C := 0.96487425) (h := 0.02739281)
    (by norm_num) (by norm_num) oscBlock5 vbpBr5.1 vbpBr6.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i6 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00469258):ℝ) ≤ ∫ v in (vBP 1.025)..(vBP 1.03), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.32057448) (m := (0:ℤ)) (ylo := 0.32057448) (yhi := 0.32057448)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.025) (q1 := 1.03) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.04938522) (B := 0.05911761) (X := 0.32057448) (rho := 0.03043634)
    (clo := 0.94905454) (chi := 0.94905455) (C := 0.94905454) (h := 0.03043635)
    (by norm_num) (by norm_num) oscBlock6 vbpBr6.1 vbpBr7.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i7 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00439277):ℝ) ≤ ∫ v in (vBP 1.03)..(vBP 1.0355), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.3807841) (m := (0:ℤ)) (ylo := 0.3807841) (yhi := 0.3807841)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.03) (q1 := 1.0355) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.0591176) (B := 0.06976881) (X := 0.3807841) (rho := 0.03346822)
    (clo := 0.92837351) (chi := 0.92837352) (C := 0.92837351) (h := 0.03346823)
    (by norm_num) (by norm_num) oscBlock7 vbpBr7.1 vbpBr8.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i8 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00393427):ℝ) ≤ ∫ v in (vBP 1.0355)..(vBP 1.0415), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.44637638) (m := (0:ℤ)) (ylo := 0.44637638) (yhi := 0.44637638)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0355) (q1 := 1.0415) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.0697688) (B := 0.08132397) (X := 0.44637638) (rho := 0.0364847)
    (clo := 0.90201733) (chi := 0.90201734) (C := 0.90201733) (h := 0.03648471)
    (by norm_num) (by norm_num) oscBlock8 vbpBr8.1 vbpBr9.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i9 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00334315):ℝ) ≤ ∫ v in (vBP 1.0415)..(vBP 1.048), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.51726044) (m := (0:ℤ)) (ylo := 0.51726044) (yhi := 0.51726044)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0415) (q1 := 1.048) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.08132396) (B := 0.09376718) (X := 0.51726044) (rho := 0.0394822)
    (clo := 0.86917715) (chi := 0.86917716) (C := 0.86917715) (h := 0.03948221)
    (by norm_num) (by norm_num) oscBlock9 vbpBr9.1 vbpBr10.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i10 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00267126):ℝ) ≤ ∫ v in (vBP 1.048)..(vBP 1.055), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.59333938) (m := (0:ℤ)) (ylo := 0.59333938) (yhi := 0.59333938)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.048) (q1 := 1.055) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.09376717) (B := 0.10708154) (X := 0.59333938) (rho := 0.04245727)
    (clo := 0.82907814) (chi := 0.82907816) (C := 0.82907815) (h := 0.04245728)
    (by norm_num) (by norm_num) oscBlock10 vbpBr10.1 vbpBr11.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i11 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00221193):ℝ) ≤ ∫ v in (vBP 1.055)..(vBP 1.064), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.68288715) (m := (0:ℤ)) (ylo := 0.68288715) (yhi := 0.68288715)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.055) (q1 := 1.064) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.10708153) (B := 0.12407079) (X := 0.68288715) (rho := 0.05378318)
    (clo := 0.77575406) (chi := 0.77575407) (C := 0.77575406) (h := 0.05378319)
    (by norm_num) (by norm_num) oscBlock11 vbpBr11.1 vbpBr12.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i12 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00143367):ℝ) ≤ ∫ v in (vBP 1.064)..(vBP 1.078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.81040854) (m := (0:ℤ)) (ylo := 0.81040854) (yhi := 0.81040854)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.064) (q1 := 1.078) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.12407078) (B := 0.15021495) (X := 0.81040854) (rho := 0.08149273)
    (clo := 0.68920247) (chi := 0.68920251) (C := 0.68920249) (h := 0.08149275)
    (by norm_num) (by norm_num) oscBlock12 vbpBr12.1 vbpBr13.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i13 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    (0.0001784:ℝ) ≤ ∫ v in (vBP 1.078)..(vBP 1.09), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.95293648) (m := (0:ℤ)) (ylo := 0.95293648) (yhi := 0.95293648)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.078) (q1 := 1.09) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.15021494) (B := 0.1723554) (X := 0.95293648) (rho := 0.07042372)
    (clo := 0.579292) (chi := 0.57929218) (C := 0.57929209) (h := 0.07042381)
    (by norm_num) (by norm_num) oscBlock13 vbpBr13.1 vbpBr14.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i14 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    (0.00070277:ℝ) ≤ ∫ v in (vBP 1.09)..(vBP 1.1), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.07219815) (m := (0:ℤ)) (ylo := 1.07219815) (yhi := 1.07219815)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.09) (q1 := 1.1) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.17235539) (B := 0.19062036) (X := 1.07219815) (rho := 0.05961025)
    (clo := 0.47819484) (chi := 0.47819541) (C := 0.47819512) (h := 0.05961054)
    (by norm_num) (by norm_num) oscBlock14 vbpBr14.1 vbpBr15.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i15 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    (0.00077644:ℝ) ≤ ∫ v in (vBP 1.1)..(vBP 1.109), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.17423336) (m := (0:ℤ)) (ylo := 1.17423336) (yhi := 1.17423336)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.1) (q1 := 1.109) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.19062035) (B := 0.20691742) (X := 1.17423336) (rho := 0.05433883)
    (clo := 0.38625031) (chi := 0.3862517) (C := 0.386251) (h := 0.05433953)
    (by norm_num) (by norm_num) oscBlock15 vbpBr15.1 vbpBr16.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i16 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    (0.00065118:ℝ) ≤ ∫ v in (vBP 1.109)..(vBP 1.117), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.26478363) (m := (0:ℤ)) (ylo := 1.26478363) (yhi := 1.26478363)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.109) (q1 := 1.117) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.20691741) (B := 0.22129305) (X := 1.26478363) (rho := 0.04914387)
    (clo := 0.30125894) (chi := 0.30126184) (C := 0.30126039) (h := 0.04914532)
    (by norm_num) (by norm_num) oscBlock16 vbpBr16.1 vbpBr17.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i17 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    (0.00046485:ℝ) ≤ ∫ v in (vBP 1.117)..(vBP 1.124), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.34410497) (m := (0:ℤ)) (ylo := 1.34410497) (yhi := 1.34410497)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.117) (q1 := 1.124) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.22129304) (B := 0.23378751) (X := 1.34410497) (rho := 0.04400838)
    (clo := 0.22475469) (chi := 0.22476) (C := 0.22475734) (h := 0.04401104)
    (by norm_num) (by norm_num) oscBlock17 vbpBr17.1 vbpBr18.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i18 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    (0.00029847:ℝ) ≤ ∫ v in (vBP 1.124)..(vBP 1.131), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.41767009) (m := (0:ℤ)) (ylo := 1.41767009) (yhi := 1.41767009)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.124) (q1 := 1.131) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.2337875) (B := 0.2462044) (X := 1.41767009) (rho := 0.04416855)
    (clo := 0.15252839) (chi := 0.15253743) (C := 0.15253291) (h := 0.04417307)
    (by norm_num) (by norm_num) oscBlock18 vbpBr18.1 vbpBr19.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i19 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    (0.000092:ℝ) ≤ ∫ v in (vBP 1.131)..(vBP 1.138), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.49077991) (m := (0:ℤ)) (ylo := 1.49077991) (yhi := 1.49077991)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.131) (q1 := 1.138) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.24620439) (B := 0.25854468) (X := 1.49077991) (rho := 0.04432914)
    (clo := 0.0799308) (chi := 0.07994576) (C := 0.07993828) (h := 0.04433662)
    (by norm_num) (by norm_num) oscBlock19 vbpBr19.1 vbpBr20.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i20 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00014107):ℝ) ≤ ∫ v in (vBP 1.138)..(vBP 1.145), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.56344001) (m := (0:ℤ)) (ylo := 1.56344001) (yhi := 1.56344001)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.138) (q1 := 1.145) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.25854467) (B := 0.27080928) (X := 1.56344001) (rho := 0.0444901)
    (clo := 0.00735581) (chi := 0.00737986) (C := 0.00736783) (h := 0.04450213)
    (by norm_num) (by norm_num) oscBlock20 vbpBr20.1 vbpBr21.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i21 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00041928):ℝ) ≤ ∫ v in (vBP 1.145)..(vBP 1.152), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.63565589) (m := (0:ℤ)) (ylo := 0.06485956) (yhi := 0.06485957)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.145) (q1 := 1.152) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.27080927) (B := 0.28299913) (X := 1.63565589) (rho := 0.04465145)
    (clo := (-0.06481411)) (chi := (-0.06481409)) (C := (-0.0648141)) (h := 0.04465146)
    (by norm_num) (by norm_num) oscBlock21 vbpBr21.1 vbpBr22.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i22 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.0007063):ℝ) ≤ ∫ v in (vBP 1.152)..(vBP 1.159), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.70743295) (m := (0:ℤ)) (ylo := 0.13663662) (yhi := 0.13663663)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.152) (q1 := 1.159) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.28299912) (B := 0.29511513) (X := 1.70743295) (rho := 0.04481314)
    (clo := (-0.13621187)) (chi := (-0.13621185)) (C := (-0.13621186)) (h := 0.04481315)
    (by norm_num) (by norm_num) oscBlock22 vbpBr22.1 vbpBr23.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i23 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00098949):ℝ) ≤ ∫ v in (vBP 1.159)..(vBP 1.166), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.77877651) (m := (0:ℤ)) (ylo := 0.20798018) (yhi := 0.20798019)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.159) (q1 := 1.166) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.29511512) (B := 0.30715818) (X := 1.77877651) (rho := 0.0449752)
    (clo := (-0.20648404)) (chi := (-0.20648402)) (C := (-0.20648403)) (h := 0.04497521)
    (by norm_num) (by norm_num) oscBlock23 vbpBr23.1 vbpBr24.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i24 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00126019):ℝ) ≤ ∫ v in (vBP 1.166)..(vBP 1.173), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.84969175) (m := (0:ℤ)) (ylo := 0.27889542) (yhi := 0.27889543)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.166) (q1 := 1.173) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.30715817) (B := 0.31912914) (X := 1.84969175) (rho := 0.04513752)
    (clo := (-0.27529393)) (chi := (-0.27529391)) (C := (-0.27529392)) (h := 0.04513753)
    (by norm_num) (by norm_num) oscBlock24 vbpBr24.1 vbpBr25.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i25 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00151089):ℝ) ≤ ∫ v in (vBP 1.173)..(vBP 1.18), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.9201838) (m := (0:ℤ)) (ylo := 0.34938747) (yhi := 0.34938748)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.173) (q1 := 1.18) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.31912913) (B := 0.33102888) (X := 1.9201838) (rho := 0.04530018)
    (clo := (-0.34232236)) (chi := (-0.34232234)) (C := (-0.34232235)) (h := 0.04530019)
    (by norm_num) (by norm_num) oscBlock25 vbpBr25.1 vbpBr26.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i26 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00173522):ℝ) ≤ ∫ v in (vBP 1.18)..(vBP 1.187), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.9902577) (m := (0:ℤ)) (ylo := 0.41946137) (yhi := 0.41946138)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.18) (q1 := 1.187) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.33102887) (B := 0.34285824) (X := 1.9902577) (rho := 0.04546311)
    (clo := (-0.40726859)) (chi := (-0.40726857)) (C := (-0.40726858)) (h := 0.04546312)
    (by norm_num) (by norm_num) oscBlock26 vbpBr26.1 vbpBr27.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i27 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00192807):ℝ) ≤ ∫ v in (vBP 1.187)..(vBP 1.194), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.05991835) (m := (0:ℤ)) (ylo := 0.48912202) (yhi := 0.48912203)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.187) (q1 := 1.194) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.34285823) (B := 0.35461804) (X := 2.05991835) (rho := 0.04562627)
    (clo := (-0.46985105)) (chi := (-0.46985103)) (C := (-0.46985104)) (h := 0.04562628)
    (by norm_num) (by norm_num) oscBlock27 vbpBr27.1 vbpBr28.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i28 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00210692):ℝ) ≤ ∫ v in (vBP 1.194)..(vBP 1.201), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.12917054) (m := (0:ℤ)) (ylo := 0.55837421) (yhi := 0.55837422)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.194) (q1 := 1.201) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.35461802) (B := 0.36630909) (X := 2.12917054) (rho := 0.04578969)
    (clo := (-0.52980805)) (chi := (-0.52980803)) (C := (-0.52980804)) (h := 0.0457897)
    (by norm_num) (by norm_num) oscBlock28 vbpBr28.1 vbpBr29.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i29 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00222802):ℝ) ≤ ∫ v in (vBP 1.201)..(vBP 1.208), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.19801914) (m := (0:ℤ)) (ylo := 0.62722281) (yhi := 0.62722282)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.201) (q1 := 1.208) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.36630908) (B := 0.3779322) (X := 2.19801914) (rho := 0.04595331)
    (clo := (-0.58689846)) (chi := (-0.58689844)) (C := (-0.58689845)) (h := 0.04595332)
    (by norm_num) (by norm_num) oscBlock29 vbpBr29.1 vbpBr30.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i30 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00230929):ℝ) ≤ ∫ v in (vBP 1.208)..(vBP 1.215), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.26646878) (m := (0:ℤ)) (ylo := 0.69567245) (yhi := 0.69567246)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.208) (q1 := 1.215) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.37793219) (B := 0.38948816) (X := 2.26646878) (rho := 0.04611718)
    (clo := (-0.64090179)) (chi := (-0.64090177)) (C := (-0.64090178)) (h := 0.04611719)
    (by norm_num) (by norm_num) oscBlock30 vbpBr30.1 vbpBr31.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i31 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00270508):ℝ) ≤ ∫ v in (vBP 1.215)..(vBP 1.223), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.33938092) (m := (0:ℤ)) (ylo := 0.76858459) (yhi := 0.7685846)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.215) (q1 := 1.223) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.38948815) (B := 0.40261372) (X := 2.33938092) (rho := 0.05113806)
    (clo := (-0.69511842)) (chi := (-0.6951184)) (C := (-0.69511841)) (h := 0.05113807)
    (by norm_num) (by norm_num) oscBlock31 vbpBr31.1 vbpBr32.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i32 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00269832):ℝ) ≤ ∫ v in (vBP 1.223)..(vBP 1.231), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.41664969) (m := (0:ℤ)) (ylo := 0.84585336) (yhi := 0.84585337)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.223) (q1 := 1.231) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.40261371) (B := 0.4156537) (X := 2.41664969) (rho := 0.05129416)
    (clo := (-0.74853726)) (chi := (-0.74853724)) (C := (-0.74853725)) (h := 0.05129417)
    (by norm_num) (by norm_num) oscBlock32 vbpBr32.1 vbpBr33.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i33 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00263535):ℝ) ≤ ∫ v in (vBP 1.231)..(vBP 1.239), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.4934163) (m := (0:ℤ)) (ylo := 0.92261997) (yhi := 0.92261998)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.231) (q1 := 1.239) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.41565369) (B := 0.42860921) (X := 2.4934163) (rho := 0.05145089)
    (clo := (-0.79718614)) (chi := (-0.79718611)) (C := (-0.79718613)) (h := 0.05145091)
    (by norm_num) (by norm_num) oscBlock33 vbpBr33.1 vbpBr34.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i34 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00284078):ℝ) ≤ ∫ v in (vBP 1.239)..(vBP 1.248), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.57444678) (m := (0:ℤ)) (ylo := 1.00365045) (yhi := 1.00365046)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.239) (q1 := 1.248) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.4286092) (B := 0.44308455) (X := 2.57444678) (rho := 0.05636775)
    (clo := (-0.84343776)) (chi := (-0.84343772)) (C := (-0.84343774)) (h := 0.05636777)
    (by norm_num) (by norm_num) oscBlock34 vbpBr34.1 vbpBr35.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i35 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.0029207):ℝ) ≤ ∫ v in (vBP 1.248)..(vBP 1.258), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.66435456) (m := (0:ℤ)) (ylo := 1.09355823) (yhi := 1.09355824)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.248) (q1 := 1.258) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.44308453) (B := 0.45904632) (X := 2.66435456) (rho := 0.06123297)
    (clo := (-0.888267)) (chi := (-0.88826692)) (C := (-0.88826696)) (h := 0.06123301)
    (by norm_num) (by norm_num) oscBlock35 vbpBr35.1 vbpBr36.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i36 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00261837):ℝ) ≤ ∫ v in (vBP 1.258)..(vBP 1.268), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.75825364) (m := (0:ℤ)) (ylo := 1.18745731) (yhi := 1.18745732)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.258) (q1 := 1.268) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.45904631) (B := 0.47488172) (X := 2.75825364) (rho := 0.06135659)
    (clo := (-0.92742112)) (chi := (-0.92742094)) (C := (-0.92742103)) (h := 0.06135668)
    (by norm_num) (by norm_num) oscBlock36 vbpBr36.1 vbpBr37.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i37 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00261049):ℝ) ≤ ∫ v in (vBP 1.268)..(vBP 1.28), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.86069674) (m := (0:ℤ)) (ylo := 1.28990041) (yhi := 1.28990042)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.268) (q1 := 1.28) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.4748817) (B := 0.49372017) (X := 2.86069674) (rho := 0.07076678)
    (clo := (-0.96080788)) (chi := (-0.96080745)) (C := (-0.94502034)) (h := 0.05497967)
    (by norm_num) (by norm_num) oscBlock37 vbpBr37.1 vbpBr38.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i38 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.0022862):ℝ) ≤ ∫ v in (vBP 1.28)..(vBP 1.294), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.9806235) (m := (0:ℤ)) (ylo := 1.40982717) (yhi := 1.40982718)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.28) (q1 := 1.294) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.49372014) (B := 0.51547641) (X := 2.9806235) (rho := 0.0800177)
    (clo := (-0.9870735)) (chi := (-0.9870724)) (C := (-0.95352735)) (h := 0.04647265)
    (by norm_num) (by norm_num) oscBlock38 vbpBr38.1 vbpBr39.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i39 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00152769):ℝ) ≤ ∫ v in (vBP 1.294)..(vBP 1.308), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.10842625) (m := (0:ℤ)) (ylo := 1.53762992) (yhi := 1.53762993)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.294) (q1 := 1.308) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.51547638) (B := 0.53699853) (X := 3.10842625) (rho := 0.08000253)
    (clo := (-0.99945285)) (chi := (-0.99945)) (C := (-0.95972374)) (h := 0.04027627)
    (by norm_num) (by norm_num) oscBlock39 vbpBr39.1 vbpBr40.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i40 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00099485):ℝ) ≤ ∫ v in (vBP 1.308)..(vBP 1.326), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.25279906) (m := (0:ℤ)) (ylo := 0.1112064) (yhi := 0.11120641)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.308) (q1 := 1.326) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.53699848) (B := 0.56433382) (X := 3.25279906) (rho := 0.09793301)
    (clo := (-0.99382294)) (chi := (-0.99382293)) (C := (-0.94794496)) (h := 0.05205504)
    (by norm_num) (by norm_num) oscBlock40 vbpBr40.1 vbpBr41.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i41 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00001044):ℝ) ≤ ∫ v in (vBP 1.326)..(vBP 1.345), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.41756997) (m := (0:ℤ)) (ylo := 0.27597731) (yhi := 0.27597732)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.326) (q1 := 1.345) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.56433374) (B := 0.59278808) (X := 3.41756997) (rho := 0.10210927)
    (clo := (-0.96215936)) (chi := (-0.96215934)) (C := (-0.93002504)) (h := 0.06997497)
    (by norm_num) (by norm_num) oscBlock41 vbpBr41.1 vbpBr42.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i42 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    (0.00081461:ℝ) ≤ ∫ v in (vBP 1.345)..(vBP 1.362), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.57573049) (m := (0:ℤ)) (ylo := 0.43413783) (yhi := 0.43413784)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.345) (q1 := 1.362) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.59278796) (B := 0.6179085) (X := 3.57573049) (rho := 0.09310124)
    (clo := (-0.90723304)) (chi := (-0.90723302)) (C := (-0.90706589)) (h := 0.09293411)
    (by norm_num) (by norm_num) oscBlock42 vbpBr42.1 vbpBr43.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i43 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    (0.00094597:ℝ) ≤ ∫ v in (vBP 1.362)..(vBP 1.376), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.71024166) (m := (0:ℤ)) (ylo := 0.568649) (yhi := 0.56864901)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.362) (q1 := 1.376) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.61790831) (B := 0.6383616) (X := 3.71024166) (rho := 0.08003035)
    (clo := (-0.84262926)) (chi := (-0.84262924)) (C := (-0.84262925)) (h := 0.08003036)
    (by norm_num) (by norm_num) oscBlock43 vbpBr43.1 vbpBr44.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i44 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    (0.00101523:ℝ) ≤ ∫ v in (vBP 1.376)..(vBP 1.39), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.83042792) (m := (0:ℤ)) (ylo := 0.68883526) (yhi := 0.68883527)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.376) (q1 := 1.39) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.63836133) (B := 0.65860767) (X := 3.83042792) (rho := 0.08005513)
    (clo := (-0.7719869)) (chi := (-0.77198688)) (C := (-0.77198689)) (h := 0.08005514)
    (by norm_num) (by norm_num) oscBlock44 vbpBr44.1 vbpBr45.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i45 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    (0.0009631:ℝ) ≤ ∫ v in (vBP 1.39)..(vBP 1.404), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.94940365) (m := (0:ℤ)) (ylo := 0.80781099) (yhi := 0.807811)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.39) (q1 := 1.404) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.65860729) (B := 0.67865086) (X := 3.94940365) (rho := 0.08008584)
    (clo := (-0.69108229)) (chi := (-0.69108224)) (C := (-0.69108227)) (h := 0.08008587)
    (by norm_num) (by norm_num) oscBlock45 vbpBr45.1 vbpBr46.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i46 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    (0.00082045:ℝ) ≤ ∫ v in (vBP 1.404)..(vBP 1.418), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.06719293) (m := (0:ℤ)) (ylo := 0.92560027) (yhi := 0.92560028)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.404) (q1 := 1.418) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.67865033) (B := 0.69849519) (X := 4.06719293) (rho := 0.08012227)
    (clo := (-0.60135523)) (chi := (-0.60135508)) (C := (-0.60135516)) (h := 0.08012235)
    (by norm_num) (by norm_num) oscBlock46 vbpBr46.1 vbpBr47.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i47 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    (0.00062223:ℝ) ≤ ∫ v in (vBP 1.418)..(vBP 1.432), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.18381925) (m := (0:ℤ)) (ylo := 1.04222659) (yhi := 1.0422266)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.418) (q1 := 1.432) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.69849446) (B := 0.7181446) (X := 4.18381925) (rho := 0.08016432)
    (clo := (-0.5042992)) (chi := (-0.50429877)) (C := (-0.50429899)) (h := 0.08016454)
    (by norm_num) (by norm_num) oscBlock47 vbpBr47.1 vbpBr48.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i48 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    (0.00040304:ℝ) ≤ ∫ v in (vBP 1.432)..(vBP 1.446), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.29930531) (m := (0:ℤ)) (ylo := 1.15771265) (yhi := 1.15771266)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.432) (q1 := 1.446) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.7181436) (B := 0.73760286) (X := 4.29930531) (rho := 0.08021168)
    (clo := (-0.40143672)) (chi := (-0.40143551)) (C := (-0.40143612)) (h := 0.08021229)
    (by norm_num) (by norm_num) oscBlock48 vbpBr48.1 vbpBr49.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i49 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    (0.00018743:ℝ) ≤ ∫ v in (vBP 1.446)..(vBP 1.462), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.42180137) (m := (0:ℤ)) (ylo := 1.28020871) (yhi := 1.28020872)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.446) (q1 := 1.462) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.73760153) (B := 0.75961158) (X := 4.42180137) (rho := 0.0883924)
    (clo := (-0.28651848)) (chi := (-0.2865152)) (C := (-0.28651684)) (h := 0.08839404)
    (by norm_num) (by norm_num) oscBlock49 vbpBr49.1 vbpBr50.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i50 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00024889):ℝ) ≤ ∫ v in (vBP 1.462)..(vBP 1.478), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.55107786) (m := (0:ℤ)) (ylo := 1.4094852) (yhi := 1.40948521)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.462) (q1 := 1.478) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.75960973) (B := 0.78138081) (X := 4.55107786) (rho := 0.08837071)
    (clo := (-0.16062086)) (chi := (-0.16061231)) (C := (-0.16061659)) (h := 0.08837499)
    (by norm_num) (by norm_num) oscBlock50 vbpBr50.1 vbpBr51.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i51 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00022246):ℝ) ≤ ∫ v in (vBP 1.478)..(vBP 1.495), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.68292784) (m := (0:ℤ)) (ylo := 1.54133518) (yhi := 1.54133519)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.478) (q1 := 1.495) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.7813783) (B := 0.80425401) (X := 4.68292784) (rho := 0.09233035)
    (clo := (-0.02947737)) (chi := (-0.0294565)) (C := (-0.02946694)) (h := 0.09234079)
    (by norm_num) (by norm_num) oscBlock51 vbpBr51.1 vbpBr52.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i52 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00037841):ℝ) ≤ ∫ v in (vBP 1.495)..(vBP 1.512), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.81725253) (m := (0:ℤ)) (ylo := 0.10486354) (yhi := 0.10486355)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.495) (q1 := 1.512) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.80425056) (B := 0.82686872) (X := 4.81725253) (rho := 0.09228051)
    (clo := 0.10467145) (chi := 0.10467147) (C := 0.10467146) (h := 0.09228052)
    (by norm_num) (by norm_num) oscBlock52 vbpBr52.1 vbpBr53.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i53 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00067869):ℝ) ≤ ∫ v in (vBP 1.512)..(vBP 1.531), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.95782864) (m := (0:ℤ)) (ylo := 0.24543965) (yhi := 0.24543966)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.512) (q1 := 1.531) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.82686405) (B := 0.85184522) (X := 4.95782864) (rho := 0.10000236)
    (clo := 0.24298282) (chi := 0.24298284) (C := 0.24298283) (h := 0.10000237)
    (by norm_num) (by norm_num) oscBlock53 vbpBr53.1 vbpBr54.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i54 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00087363):ℝ) ≤ ∫ v in (vBP 1.531)..(vBP 1.55), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.10442711) (m := (0:ℤ)) (ylo := 0.39203812) (yhi := 0.39203813)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.531) (q1 := 1.55) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.85183877) (B := 0.87651393) (X := 5.10442711) (rho := 0.09987436)
    (clo := 0.38207269) (chi := 0.38207271) (C := 0.3820727) (h := 0.09987437)
    (by norm_num) (by norm_num) oscBlock54 vbpBr54.1 vbpBr55.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i55 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00108113):ℝ) ≤ ∫ v in (vBP 1.55)..(vBP 1.57), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.25301181) (m := (0:ℤ)) (ylo := 0.54062282) (yhi := 0.54062283)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.55) (q1 := 1.57) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.87650515) (B := 0.90215678) (X := 5.25301181) (rho := 0.10354408)
    (clo := 0.51467009) (chi := 0.5146701) (C := 0.51467009) (h := 0.10354409)
    (by norm_num) (by norm_num) oscBlock55 vbpBr55.1 vbpBr56.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i56 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00118454):ℝ) ≤ ∫ v in (vBP 1.57)..(vBP 1.59), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.40349321) (m := (0:ℤ)) (ylo := 0.69110422) (yhi := 0.69110423)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.57) (q1 := 1.59) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.90214481) (B := 0.92747548) (X := 5.40349321) (rho := 0.10339247)
    (clo := 0.63738841) (chi := 0.63738843) (C := 0.63738842) (h := 0.10339248)
    (by norm_num) (by norm_num) oscBlock56 vbpBr56.1 vbpBr57.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i57 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00124107):ℝ) ≤ ∫ v in (vBP 1.59)..(vBP 1.61), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.55208176) (m := (0:ℤ)) (ylo := 0.83969277) (yhi := 0.83969278)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.59) (q1 := 1.61) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.92745939) (B := 0.95247825) (X := 5.55208176) (rho := 0.10325786)
    (clo := 0.74443802) (chi := 0.74443804) (C := 0.74443803) (h := 0.10325787)
    (by norm_num) (by norm_num) oscBlock57 vbpBr57.1 vbpBr58.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i58 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00141529):ℝ) ≤ ∫ v in (vBP 1.61)..(vBP 1.632), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.70610632) (m := (0:ℤ)) (ylo := 0.99371733) (yhi := 0.99371734)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.61) (q1 := 1.632) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.95245689) (B := 0.97962584) (X := 5.70610632) (rho := 0.11042211)
    (clo := 0.83805985) (chi := 0.83805989) (C := 0.83805987) (h := 0.11042213)
    (by norm_num) (by norm_num) oscBlock58 vbpBr58.1 vbpBr59.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i59 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00149999):ℝ) ≤ ∫ v in (vBP 1.632)..(vBP 1.656), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.87252531) (m := (0:ℤ)) (ylo := 1.16013632) (yhi := 1.16013633)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.632) (q1 := 1.656) (t0 := 5.875) (t1 := 5.9375)
    (A := 0.97959707) (B := 1.00882827) (X := 5.87252531) (rho := 0.11739255)
    (clo := 0.91685753) (chi := 0.91685767) (C := 0.89973249) (h := 0.10026751)
    (by norm_num) (by norm_num) oscBlock59 vbpBr59.1 vbpBr60.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i60 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00135601):ℝ) ≤ ∫ v in (vBP 1.656)..(vBP 1.68), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.04372839) (m := (0:ℤ)) (ylo := 1.3313394) (yhi := 1.33133941)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.656) (q1 := 1.68) (t0 := 5.875) (t1 := 5.9375)
    (A := 1.00878907) (B := 1.03761196) (X := 6.04372839) (rho := 0.11709263)
    (clo := 0.97146691) (chi := 0.97146751) (C := 0.92718714) (h := 0.07281286)
    (by norm_num) (by norm_num) oscBlock60 vbpBr60.1 vbpBr61.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i61 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00122808):ℝ) ≤ ∫ v in (vBP 1.68)..(vBP 1.704), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.21248582) (m := (0:ℤ)) (ylo := 1.50009683) (yhi := 1.50009684)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.68) (q1 := 1.704) (t0 := 5.875) (t1 := 5.9375)
    (A := 1.03755935) (B := 1.06598913) (X := 6.21248582) (rho := 0.11682465)
    (clo := 0.9975018) (chi := 0.99750397) (C := 0.94033857) (h := 0.05966143)
    (by norm_num) (by norm_num) oscBlock61 vbpBr61.1 vbpBr62.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i62 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00137159):ℝ) ≤ ∫ v in (vBP 1.704)..(vBP 1.734), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.3994555) (m := (1:ℤ)) (ylo := 0.11627019) (yhi := 0.1162702)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.704) (q1 := 1.734) (t0 := 5.875) (t1 := 5.9375)
    (A := 1.06591948) (B := 1.10090679) (X := 6.3994555) (rho := 0.13717858)
    (clo := 0.99324823) (chi := 0.99324824) (C := 0.92803482) (h := 0.07196518)
    (by norm_num) (by norm_num) oscBlock62 vbpBr62.1 vbpBr63.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i63 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00129873):ℝ) ≤ ∫ v in (vBP 1.734)..(vBP 1.766), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.61057298) (m := (1:ℤ)) (ylo := 0.32738767) (yhi := 0.32738768)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.734) (q1 := 1.766) (t0 := 5.875) (t1 := 5.9375)
    (A := 1.10080961) (B := 1.13749718) (X := 6.61057298) (rho := 0.14331654)
    (clo := 0.94688561) (chi := 0.94688563) (C := 0.90178453) (h := 0.09821547)
    (by norm_num) (by norm_num) oscBlock63 vbpBr63.1 vbpBr64.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i64 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00107223):ℝ) ≤ ∫ v in (vBP 1.766)..(vBP 1.796), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.81802473) (m := (1:ℤ)) (ylo := 0.53483942) (yhi := 0.53483943)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.766) (q1 := 1.796) (t0 := 5.875) (t1 := 5.9375)
    (A := 1.1373613) (B := 1.17120873) (X := 6.81802473) (rho := 0.13602711)
    (clo := 0.86035048) (chi := 0.86035049) (C := 0.86035048) (h := 0.13602712)
    (by norm_num) (by norm_num) oscBlock64 vbpBr64.1 vbpBr65.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i65 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00092974):ℝ) ≤ ∫ v in (vBP 1.796)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.02186171) (m := (1:ℤ)) (ylo := 0.7386764) (yhi := 0.73867641)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.796) (q1 := 1.828) (t0 := 5.875) (t1 := 5.9375)
    (A := 1.1710258) (B := 1.20655947) (X := 7.02186171) (rho := 0.14208515)
    (clo := 0.73936039) (chi := 0.73936042) (C := 0.7393604) (h := 0.14208517)
    (by norm_num) (by norm_num) oscBlock65 vbpBr65.1 vbpBr66.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i66 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00070203):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.86), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.22866772) (m := (1:ℤ)) (ylo := 0.94548241) (yhi := 0.94548242)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.828) (q1 := 1.86) (t0 := 5.875) (t1 := 5.9375)
    (A := 1.20631244) (B := 1.24130524) (X := 7.22866772) (rho := 0.14158215)
    (clo := 0.5853518) (chi := 0.58535198) (C := 0.58535189) (h := 0.14158224)
    (by norm_num) (by norm_num) oscBlock66 vbpBr66.1 vbpBr67.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i67 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00044249):ℝ) ≤ ∫ v in (vBP 1.86)..(vBP 1.89), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.4256271) (m := (1:ℤ)) (ylo := 1.14244179) (yhi := 1.1424418)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.86) (q1 := 1.89) (t0 := 5.875) (t1 := 5.9375)
    (A := 1.24097685) (B := 1.27334993) (X := 7.4256271) (rho := 0.13488812)
    (clo := 0.41537454) (chi := 0.41537561) (C := 0.41537507) (h := 0.13488866)
    (by norm_num) (by norm_num) oscBlock67 vbpBr67.1 vbpBr68.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i68 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00028938):ℝ) ≤ ∫ v in (vBP 1.89)..(vBP 1.922), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.61933871) (m := (1:ℤ)) (ylo := 1.3361534) (yhi := 1.33615341)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.89) (q1 := 1.922) (t0 := 5.875) (t1 := 5.9375)
    (A := 1.27292668) (B := 1.30698664) (X := 7.61933871) (rho := 0.14089448)
    (clo := 0.23249563) (chi := 0.23250065) (C := 0.23249814) (h := 0.14089699)
    (by norm_num) (by norm_num) oscBlock68 vbpBr68.1 vbpBr69.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i69 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00019231):ℝ) ≤ ∫ v in (vBP 1.922)..(vBP 1.969), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 7.86155118) (m := (1:ℤ)) (ylo := 0.00756954) (yhi := 0.00756955)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.922) (q1 := 1.969) (t0 := 5.875) (t1 := 5.9375)
    (A := 1.30643896) (B := 1.35541448) (X := 7.86155118) (rho := 0.18622231)
    (clo := (-0.00756948)) (chi := (-0.00756946)) (C := (-0.00756947)) (h := 0.18622232)
    (by norm_num) (by norm_num) oscBlock69 vbpBr69.1 vbpBr70.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i70 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00041372):ℝ) ≤ ∫ v in (vBP 1.969)..(vBP 2.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.14360743) (m := (1:ℤ)) (ylo := 0.28962579) (yhi := 0.2896258)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.969) (q1 := 2.016) (t0 := 5.875) (t1 := 5.9375)
    (A := 1.35463226) (B := 1.4027369) (X := 8.14360743) (rho := 0.18514292)
    (clo := (-0.28559364)) (chi := (-0.28559362)) (C := (-0.28559363)) (h := 0.18514293)
    (by norm_num) (by norm_num) oscBlock70 vbpBr70.1 vbpBr71.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i71 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.00056192):ℝ) ≤ ∫ v in (vBP 2.016)..(vBP 2.062), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.41620254) (m := (1:ℤ)) (ylo := 0.5622209) (yhi := 0.56222091)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.016) (q1 := 2.062) (t0 := 5.875) (t1 := 5.9375)
    (A := 1.40164597) (B := 1.44803958) (X := 8.41620254) (rho := 0.18153248)
    (clo := (-0.53306657)) (chi := (-0.53306655)) (C := (-0.53306656)) (h := 0.18153249)
    (by norm_num) (by norm_num) oscBlock71 vbpBr71.1 vbpBr72.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB15i72 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.000434):ℝ) ≤ ∫ v in (vBP 2.062)..(vBP 2.094), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.64002721) (m := (1:ℤ)) (ylo := 0.78604557) (yhi := 0.78604558)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.062) (q1 := 2.094) (t0 := 5.875) (t1 := 5.9375)
    (A := 1.44655973) (B := 1.47899217) (X := 8.64002721) (rho := 0.14148881)
    (clo := (-0.70756443)) (chi := (-0.70756441)) (C := (-0.70756442)) (h := 0.14148882)
    (by norm_num) (by norm_num) oscBlock72 vbpBr72.1 vbpBr73.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

/-- Lower bound for the oscillatory integral `∫₀^∞ err(v) cos(tv) dv` on the band
`5.875 ≤ t ≤ 5.9375`. -/
theorem oscBandLower15 {t : ℝ} (ht0 : (5.875:ℝ) ≤ t) (ht1 : t ≤ 5.9375) :
    ((-0.11995113):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosB15i0 ht0 ht1)
    (cosB15i1 ht0 ht1))
    (cosB15i2 ht0 ht1))
    (cosB15i3 ht0 ht1))
    (cosB15i4 ht0 ht1))
    (cosB15i5 ht0 ht1))
    (cosB15i6 ht0 ht1))
    (cosB15i7 ht0 ht1))
    (cosB15i8 ht0 ht1))
    (cosB15i9 ht0 ht1))
    (cosB15i10 ht0 ht1))
    (cosB15i11 ht0 ht1))
    (cosB15i12 ht0 ht1))
    (cosB15i13 ht0 ht1))
    (cosB15i14 ht0 ht1))
    (cosB15i15 ht0 ht1))
    (cosB15i16 ht0 ht1))
    (cosB15i17 ht0 ht1))
    (cosB15i18 ht0 ht1))
    (cosB15i19 ht0 ht1))
    (cosB15i20 ht0 ht1))
    (cosB15i21 ht0 ht1))
    (cosB15i22 ht0 ht1))
    (cosB15i23 ht0 ht1))
    (cosB15i24 ht0 ht1))
    (cosB15i25 ht0 ht1))
    (cosB15i26 ht0 ht1))
    (cosB15i27 ht0 ht1))
    (cosB15i28 ht0 ht1))
    (cosB15i29 ht0 ht1))
    (cosB15i30 ht0 ht1))
    (cosB15i31 ht0 ht1))
    (cosB15i32 ht0 ht1))
    (cosB15i33 ht0 ht1))
    (cosB15i34 ht0 ht1))
    (cosB15i35 ht0 ht1))
    (cosB15i36 ht0 ht1))
    (cosB15i37 ht0 ht1))
    (cosB15i38 ht0 ht1))
    (cosB15i39 ht0 ht1))
    (cosB15i40 ht0 ht1))
    (cosB15i41 ht0 ht1))
    (cosB15i42 ht0 ht1))
    (cosB15i43 ht0 ht1))
    (cosB15i44 ht0 ht1))
    (cosB15i45 ht0 ht1))
    (cosB15i46 ht0 ht1))
    (cosB15i47 ht0 ht1))
    (cosB15i48 ht0 ht1))
    (cosB15i49 ht0 ht1))
    (cosB15i50 ht0 ht1))
    (cosB15i51 ht0 ht1))
    (cosB15i52 ht0 ht1))
    (cosB15i53 ht0 ht1))
    (cosB15i54 ht0 ht1))
    (cosB15i55 ht0 ht1))
    (cosB15i56 ht0 ht1))
    (cosB15i57 ht0 ht1))
    (cosB15i58 ht0 ht1))
    (cosB15i59 ht0 ht1))
    (cosB15i60 ht0 ht1))
    (cosB15i61 ht0 ht1))
    (cosB15i62 ht0 ht1))
    (cosB15i63 ht0 ht1))
    (cosB15i64 ht0 ht1))
    (cosB15i65 ht0 ht1))
    (cosB15i66 ht0 ht1))
    (cosB15i67 ht0 ht1))
    (cosB15i68 ht0 ht1))
    (cosB15i69 ht0 ht1))
    (cosB15i70 ht0 ht1))
    (cosB15i71 ht0 ht1))
    (cosB15i72 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 2.094) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 2.094) (S := 0.013709)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_cut
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
