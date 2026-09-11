/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscTail

/-!
# Oscillatory lower bound on the band `7.5 ≤ t ≤ 8.0`

On each of the 73 blocks the factor `cos(tv)` is bracketed by a rational constant
`C` up to a rational error `h`; the signed contribution `min(C·P₀, C·P₁) - h·S` is
then summed, and the unresolved tail beyond `q = 2.094` is estimated in absolute
value.  The result is the bound `∫₀^∞ err(v) cos(tv) dv ≥ -0.17461105`.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosB0i0 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00641868):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.0038), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.0303424) (m := (0:ℤ)) (ylo := 0.0303424) (yhi := 0.0303424)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1) (q1 := 1.0038) (t0 := 7.5) (t1 := 8)
    (A := 0.0) (B := 0.0075856) (X := 0.0303424) (rho := 0.03034241)
    (clo := 0.9995397) (chi := 0.99953971) (C := 0.98459864) (h := 0.01540136)
    (by norm_num) (by norm_num) oscBlock0 vbpBr0.1 vbpBr1.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i1 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00625872):ℝ) ≤ ∫ v in (vBP 1.0038)..(vBP 1.0078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.09060388) (m := (0:ℤ)) (ylo := 0.09060388) (yhi := 0.09060388)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0038) (q1 := 1.0078) (t0 := 7.5) (t1 := 8)
    (A := 0.00758559) (B := 0.01553948) (X := 0.09060388) (rho := 0.03371197)
    (clo := 0.99589827) (chi := 0.99589828) (C := 0.98109315) (h := 0.01890685)
    (by norm_num) (by norm_num) oscBlock1 vbpBr1.1 vbpBr2.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i2 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.0057677):ℝ) ≤ ∫ v in (vBP 1.0078)..(vBP 1.0118), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.15212041) (m := (0:ℤ)) (ylo := 0.15212041) (yhi := 0.15212041)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0078) (q1 := 1.0118) (t0 := 7.5) (t1 := 8)
    (A := 0.01553947) (B := 0.02346185) (X := 0.15212041) (rho := 0.0355744)
    (clo := 0.98845198) (chi := 0.98845199) (C := 0.97643879) (h := 0.02356121)
    (by norm_num) (by norm_num) oscBlock2 vbpBr2.1 vbpBr3.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i3 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00554846):ℝ) ≤ ∫ v in (vBP 1.0118)..(vBP 1.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.2149687) (m := (0:ℤ)) (ylo := 0.2149687) (yhi := 0.2149687)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0118) (q1 := 1.016) (t0 := 7.5) (t1 := 8)
    (A := 0.02346184) (B := 0.0317467) (X := 0.2149687) (rho := 0.03900491)
    (clo := 0.97698307) (chi := 0.97698308) (C := 0.96898908) (h := 0.03101092)
    (by norm_num) (by norm_num) oscBlock3 vbpBr3.1 vbpBr4.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i4 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00539232):ℝ) ≤ ∫ v in (vBP 1.016)..(vBP 1.0205), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.28139172) (m := (0:ℤ)) (ylo := 0.28139172) (yhi := 0.28139172)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.016) (q1 := 1.0205) (t0 := 7.5) (t1 := 8)
    (A := 0.03174669) (B := 0.04058541) (X := 0.28139172) (rho := 0.04329157)
    (clo := 0.96066989) (chi := 0.9606699) (C := 0.95868916) (h := 0.04131084)
    (by norm_num) (by norm_num) oscBlock4 vbpBr4.1 vbpBr5.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i5 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00477727):ℝ) ≤ ∫ v in (vBP 1.0205)..(vBP 1.025), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.34973617) (m := (0:ℤ)) (ylo := 0.34973617) (yhi := 0.34973617)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0205) (q1 := 1.025) (t0 := 7.5) (t1 := 8)
    (A := 0.0405854) (B := 0.04938523) (X := 0.34973617) (rho := 0.04534568)
    (clo := 0.93946314) (chi := 0.93946315) (C := 0.93946314) (h := 0.04534569)
    (by norm_num) (by norm_num) oscBlock5 vbpBr5.1 vbpBr6.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i6 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00461685):ℝ) ≤ ∫ v in (vBP 1.025)..(vBP 1.03), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.42166501) (m := (0:ℤ)) (ylo := 0.42166501) (yhi := 0.42166501)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.025) (q1 := 1.03) (t0 := 7.5) (t1 := 8)
    (A := 0.04938522) (B := 0.05911761) (X := 0.42166501) (rho := 0.05127588)
    (clo := 0.91240874) (chi := 0.91240875) (C := 0.91240874) (h := 0.05127589)
    (by norm_num) (by norm_num) oscBlock6 vbpBr6.1 vbpBr7.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i7 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00426835):ℝ) ≤ ∫ v in (vBP 1.03)..(vBP 1.0355), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.50076624) (m := (0:ℤ)) (ylo := 0.50076624) (yhi := 0.50076624)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.03) (q1 := 1.0355) (t0 := 7.5) (t1 := 8)
    (A := 0.0591176) (B := 0.06976881) (X := 0.50076624) (rho := 0.05738425)
    (clo := 0.87721494) (chi := 0.87721495) (C := 0.87721494) (h := 0.05738426)
    (by norm_num) (by norm_num) oscBlock7 vbpBr7.1 vbpBr8.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i8 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00375739):ℝ) ≤ ∫ v in (vBP 1.0355)..(vBP 1.0415), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.58692888) (m := (0:ℤ)) (ylo := 0.58692888) (yhi := 0.58692888)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0355) (q1 := 1.0415) (t0 := 7.5) (t1 := 8)
    (A := 0.0697688) (B := 0.08132397) (X := 0.58692888) (rho := 0.06366289)
    (clo := 0.8326454) (chi := 0.83264542) (C := 0.83264541) (h := 0.0636629)
    (by norm_num) (by norm_num) oscBlock8 vbpBr8.1 vbpBr9.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i9 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00311871):ℝ) ≤ ∫ v in (vBP 1.0415)..(vBP 1.048), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.68003357) (m := (0:ℤ)) (ylo := 0.68003357) (yhi := 0.68003357)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0415) (q1 := 1.048) (t0 := 7.5) (t1 := 8)
    (A := 0.08132396) (B := 0.09376718) (X := 0.68003357) (rho := 0.07010388)
    (clo := 0.7775516) (chi := 0.77755162) (C := 0.77755161) (h := 0.07010389)
    (by norm_num) (by norm_num) oscBlock9 vbpBr9.1 vbpBr10.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i10 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00241414):ℝ) ≤ ∫ v in (vBP 1.048)..(vBP 1.055), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.77995304) (m := (0:ℤ)) (ylo := 0.77995304) (yhi := 0.77995304)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.048) (q1 := 1.055) (t0 := 7.5) (t1 := 8)
    (A := 0.09376717) (B := 0.10708154) (X := 0.77995304) (rho := 0.07669929)
    (clo := 0.71094656) (chi := 0.71094659) (C := 0.71094657) (h := 0.07669931)
    (by norm_num) (by norm_num) oscBlock10 vbpBr10.1 vbpBr11.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i11 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.0019146):ℝ) ≤ ∫ v in (vBP 1.055)..(vBP 1.064), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.89783889) (m := (0:ℤ)) (ylo := 0.89783889) (yhi := 0.89783889)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.055) (q1 := 1.064) (t0 := 7.5) (t1 := 8)
    (A := 0.10708153) (B := 0.12407079) (X := 0.89783889) (rho := 0.09472744)
    (clo := 0.62330137) (chi := 0.62330147) (C := 0.62330142) (h := 0.09472749)
    (by norm_num) (by norm_num) oscBlock11 vbpBr11.1 vbpBr12.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i12 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00115169):ℝ) ≤ ∫ v in (vBP 1.064)..(vBP 1.078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.06612522) (m := (0:ℤ)) (ylo := 1.06612522) (yhi := 1.06612522)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.064) (q1 := 1.078) (t0 := 7.5) (t1 := 8)
    (A := 0.12407078) (B := 0.15021495) (X := 1.06612522) (rho := 0.13559439)
    (clo := 0.48351957) (chi := 0.4835201) (C := 0.48351983) (h := 0.13559466)
    (by norm_num) (by norm_num) oscBlock12 vbpBr12.1 vbpBr13.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i13 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.0000639):ℝ) ≤ ∫ v in (vBP 1.078)..(vBP 1.09), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.25272762) (m := (0:ℤ)) (ylo := 1.25272762) (yhi := 1.25272762)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.078) (q1 := 1.09) (t0 := 7.5) (t1 := 8)
    (A := 0.15021494) (B := 0.1723554) (X := 1.25272762) (rho := 0.12611559)
    (clo := 0.31273269) (chi := 0.31273532) (C := 0.312734) (h := 0.12611691)
    (by norm_num) (by norm_num) oscBlock13 vbpBr13.1 vbpBr14.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i14 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00001091):ℝ) ≤ ∫ v in (vBP 1.09)..(vBP 1.1), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.40881415) (m := (0:ℤ)) (ylo := 1.40881415) (yhi := 1.40881415)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.09) (q1 := 1.1) (t0 := 7.5) (t1 := 8)
    (A := 0.17235539) (B := 0.19062036) (X := 1.40881415) (rho := 0.11614874)
    (clo := 0.16127462) (chi := 0.16128312) (C := 0.16127887) (h := 0.11615299)
    (by norm_num) (by norm_num) oscBlock14 vbpBr14.1 vbpBr15.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i15 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00027548):ℝ) ≤ ∫ v in (vBP 1.1)..(vBP 1.109), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.54249599) (m := (0:ℤ)) (ylo := 1.54249599) (yhi := 1.54249599)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.1) (q1 := 1.109) (t0 := 7.5) (t1 := 8)
    (A := 0.19062035) (B := 0.20691742) (X := 1.54249599) (rho := 0.11284338)
    (clo := 0.02829618) (chi := 0.0283172) (C := 0.02830669) (h := 0.11285389)
    (by norm_num) (by norm_num) oscBlock15 vbpBr15.1 vbpBr16.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i16 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00064314):ℝ) ≤ ∫ v in (vBP 1.109)..(vBP 1.117), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.66111248) (m := (0:ℤ)) (ylo := 0.09031615) (yhi := 0.09031616)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.109) (q1 := 1.117) (t0 := 7.5) (t1 := 8)
    (A := 0.20691741) (B := 0.22129305) (X := 1.66111248) (rho := 0.10923193)
    (clo := (-0.09019343)) (chi := (-0.09019341)) (C := (-0.09019342)) (h := 0.10923194)
    (by norm_num) (by norm_num) oscBlock16 vbpBr16.1 vbpBr17.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i17 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00093937):ℝ) ≤ ∫ v in (vBP 1.117)..(vBP 1.124), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.76499894) (m := (0:ℤ)) (ylo := 0.19420261) (yhi := 0.19420262)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.117) (q1 := 1.124) (t0 := 7.5) (t1 := 8)
    (A := 0.22129304) (B := 0.23378751) (X := 1.76499894) (rho := 0.10530115)
    (clo := (-0.19298421)) (chi := (-0.19298419)) (C := (-0.1929842)) (h := 0.10530116)
    (by norm_num) (by norm_num) oscBlock17 vbpBr17.1 vbpBr18.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i18 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00134237):ℝ) ≤ ∫ v in (vBP 1.124)..(vBP 1.131), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.86152072) (m := (0:ℤ)) (ylo := 0.29072439) (yhi := 0.2907244)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.124) (q1 := 1.131) (t0 := 7.5) (t1 := 8)
    (A := 0.2337875) (B := 0.2462044) (X := 1.86152072) (rho := 0.10811449)
    (clo := (-0.28664631)) (chi := (-0.28664629)) (C := (-0.2866463)) (h := 0.1081145)
    (by norm_num) (by norm_num) oscBlock18 vbpBr18.1 vbpBr19.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i19 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00175805):ℝ) ≤ ∫ v in (vBP 1.131)..(vBP 1.138), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.95744518) (m := (0:ℤ)) (ylo := 0.38664885) (yhi := 0.38664886)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.131) (q1 := 1.138) (t0 := 7.5) (t1 := 8)
    (A := 0.24620439) (B := 0.25854468) (X := 1.95744518) (rho := 0.11091227)
    (clo := (-0.37708679)) (chi := (-0.37708677)) (C := (-0.37708678)) (h := 0.11091228)
    (by norm_num) (by norm_num) oscBlock19 vbpBr19.1 vbpBr20.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i20 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00214937):ℝ) ≤ ∫ v in (vBP 1.138)..(vBP 1.145), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.05277963) (m := (0:ℤ)) (ylo := 0.4819833) (yhi := 0.48198331)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.138) (q1 := 1.145) (t0 := 7.5) (t1 := 8)
    (A := 0.25854467) (B := 0.27080928) (X := 2.05277963) (rho := 0.11369462)
    (clo := (-0.46353746)) (chi := (-0.46353744)) (C := (-0.46353745)) (h := 0.11369463)
    (by norm_num) (by norm_num) oscBlock20 vbpBr20.1 vbpBr21.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i21 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00253463):ℝ) ≤ ∫ v in (vBP 1.145)..(vBP 1.152), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.14753128) (m := (0:ℤ)) (ylo := 0.57673495) (yhi := 0.57673496)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.145) (q1 := 1.152) (t0 := 7.5) (t1 := 8)
    (A := 0.27080927) (B := 0.28299913) (X := 2.14753128) (rho := 0.11646177)
    (clo := (-0.54528994)) (chi := (-0.54528992)) (C := (-0.54528993)) (h := 0.11646178)
    (by norm_num) (by norm_num) oscBlock21 vbpBr21.1 vbpBr22.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i22 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00289081):ℝ) ≤ ∫ v in (vBP 1.152)..(vBP 1.159), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.24170722) (m := (0:ℤ)) (ylo := 0.67091089) (yhi := 0.6709109)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.152) (q1 := 1.159) (t0 := 7.5) (t1 := 8)
    (A := 0.28299912) (B := 0.29511513) (X := 2.24170722) (rho := 0.11921383)
    (clo := (-0.62169972)) (chi := (-0.6216997)) (C := (-0.62169971)) (h := 0.11921384)
    (by norm_num) (by norm_num) oscBlock22 vbpBr22.1 vbpBr23.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i23 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00320362):ℝ) ≤ ∫ v in (vBP 1.159)..(vBP 1.166), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.33531442) (m := (0:ℤ)) (ylo := 0.76451809) (yhi := 0.7645181)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.159) (q1 := 1.166) (t0 := 7.5) (t1 := 8)
    (A := 0.29511512) (B := 0.30715818) (X := 2.33531442) (rho := 0.12195103)
    (clo := (-0.69218929)) (chi := (-0.69218927)) (C := (-0.69218928)) (h := 0.12195104)
    (by norm_num) (by norm_num) oscBlock23 vbpBr23.1 vbpBr24.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i24 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00346449):ℝ) ≤ ∫ v in (vBP 1.166)..(vBP 1.173), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.42835969) (m := (0:ℤ)) (ylo := 0.85756336) (yhi := 0.85756337)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.166) (q1 := 1.173) (t0 := 7.5) (t1 := 8)
    (A := 0.30715817) (B := 0.31912914) (X := 2.42835969) (rho := 0.12467344)
    (clo := (-0.75625058)) (chi := (-0.75625055)) (C := (-0.75625057)) (h := 0.12467346)
    (by norm_num) (by norm_num) oscBlock24 vbpBr24.1 vbpBr25.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i25 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00366718):ℝ) ≤ ∫ v in (vBP 1.173)..(vBP 1.18), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.52084975) (m := (0:ℤ)) (ylo := 0.95005342) (yhi := 0.95005343)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.173) (q1 := 1.18) (t0 := 7.5) (t1 := 8)
    (A := 0.31912913) (B := 0.33102888) (X := 2.52084975) (rho := 0.1273813)
    (clo := (-0.8134466)) (chi := (-0.81344657)) (C := (-0.81344659)) (h := 0.12738132)
    (by norm_num) (by norm_num) oscBlock25 vbpBr25.1 vbpBr26.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i26 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00380781):ℝ) ≤ ∫ v in (vBP 1.18)..(vBP 1.187), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.61279122) (m := (0:ℤ)) (ylo := 1.04199489) (yhi := 1.0419949)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.18) (q1 := 1.187) (t0 := 7.5) (t1 := 8)
    (A := 0.33102887) (B := 0.34285824) (X := 2.61279122) (rho := 0.13007471)
    (clo := (-0.86341241)) (chi := (-0.86341236)) (C := (-0.86341239)) (h := 0.13007474)
    (by norm_num) (by norm_num) oscBlock26 vbpBr26.1 vbpBr27.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i27 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00374035):ℝ) ≤ ∫ v in (vBP 1.187)..(vBP 1.194), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.70419052) (m := (0:ℤ)) (ylo := 1.13339419) (yhi := 1.1333942)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.187) (q1 := 1.194) (t0 := 7.5) (t1 := 8)
    (A := 0.34285823) (B := 0.35461804) (X := 2.70419052) (rho := 0.13275381)
    (clo := (-0.90585525)) (chi := (-0.90585514)) (C := (-0.88655067)) (h := 0.11344934)
    (by norm_num) (by norm_num) oscBlock27 vbpBr27.1 vbpBr28.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i28 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.0036604):ℝ) ≤ ∫ v in (vBP 1.194)..(vBP 1.201), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.79505393) (m := (0:ℤ)) (ylo := 1.2242576) (yhi := 1.22425761)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.194) (q1 := 1.201) (t0 := 7.5) (t1 := 8)
    (A := 0.35461802) (B := 0.36630909) (X := 2.79505393) (rho := 0.1354188)
    (clo := (-0.94055418)) (chi := (-0.94055394)) (C := (-0.90256757)) (h := 0.09743243)
    (by norm_num) (by norm_num) oscBlock28 vbpBr28.1 vbpBr29.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i29 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.0035206):ℝ) ≤ ∫ v in (vBP 1.201)..(vBP 1.208), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.88538785) (m := (0:ℤ)) (ylo := 1.31459152) (yhi := 1.31459153)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.201) (q1 := 1.208) (t0 := 7.5) (t1 := 8)
    (A := 0.36630908) (B := 0.3779322) (X := 2.88538785) (rho := 0.13806976)
    (clo := (-0.9673592)) (chi := (-0.96735868)) (C := (-0.91464446)) (h := 0.08535554)
    (by norm_num) (by norm_num) oscBlock29 vbpBr29.1 vbpBr30.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i30 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00336131):ℝ) ≤ ∫ v in (vBP 1.208)..(vBP 1.215), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.97519835) (m := (0:ℤ)) (ylo := 1.40440202) (yhi := 1.40440203)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.208) (q1 := 1.215) (t0 := 7.5) (t1 := 8)
    (A := 0.37793219) (B := 0.38948816) (X := 2.97519835) (rho := 0.14070694)
    (clo := (-0.98618942)) (chi := (-0.98618836)) (C := (-0.92274071)) (h := 0.07725929)
    (by norm_num) (by norm_num) oscBlock30 vbpBr30.1 vbpBr31.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i31 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00362487):ℝ) ≤ ∫ v in (vBP 1.215)..(vBP 1.223), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.07103544) (m := (0:ℤ)) (ylo := 1.50023911) (yhi := 1.50023912)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.215) (q1 := 1.223) (t0 := 7.5) (t1 := 8)
    (A := 0.38948815) (B := 0.40261372) (X := 3.07103544) (rho := 0.14987433)
    (clo := (-0.99751402)) (chi := (-0.99751184)) (C := (-0.92381876)) (h := 0.07618125)
    (by norm_num) (by norm_num) oscBlock31 vbpBr31.1 vbpBr32.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i32 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00337361):ℝ) ≤ ∫ v in (vBP 1.223)..(vBP 1.231), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.17241621) (m := (0:ℤ)) (ylo := 0.03082355) (yhi := 0.03082356)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.223) (q1 := 1.231) (t0 := 7.5) (t1 := 8)
    (A := 0.40261371) (B := 0.4156537) (X := 3.17241621) (rho := 0.1528134)
    (clo := (-0.999525)) (chi := (-0.99952499)) (C := (-0.9233558)) (h := 0.07664421)
    (by norm_num) (by norm_num) oscBlock32 vbpBr32.1 vbpBr33.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i33 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00310539):ℝ) ≤ ∫ v in (vBP 1.231)..(vBP 1.239), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.27313817) (m := (0:ℤ)) (ylo := 0.13154551) (yhi := 0.13154552)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.231) (q1 := 1.239) (t0 := 7.5) (t1 := 8)
    (A := 0.41565369) (B := 0.42860921) (X := 3.27313817) (rho := 0.15573552)
    (clo := (-0.99136036)) (chi := (-0.99136035)) (C := (-0.91781242)) (h := 0.08218759)
    (by norm_num) (by norm_num) oscBlock33 vbpBr33.1 vbpBr34.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i34 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.0031571):ℝ) ≤ ∫ v in (vBP 1.239)..(vBP 1.248), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.3796227) (m := (0:ℤ)) (ylo := 0.23803004) (yhi := 0.23803005)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.239) (q1 := 1.248) (t0 := 7.5) (t1 := 8)
    (A := 0.4286092) (B := 0.44308455) (X := 3.3796227) (rho := 0.16505371)
    (clo := (-0.97180436)) (chi := (-0.97180435)) (C := (-0.90337532)) (h := 0.09662468)
    (by norm_num) (by norm_num) oscBlock34 vbpBr34.1 vbpBr35.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i35 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00307604):ℝ) ≤ ∫ v in (vBP 1.248)..(vBP 1.258), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.49775226) (m := (0:ℤ)) (ylo := 0.3561596) (yhi := 0.35615961)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.248) (q1 := 1.258) (t0 := 7.5) (t1 := 8)
    (A := 0.44308453) (B := 0.45904632) (X := 3.49775226) (rho := 0.17461831)
    (clo := (-0.9372428)) (chi := (-0.93724278)) (C := (-0.88131224)) (h := 0.11868777)
    (by norm_num) (by norm_num) oscBlock35 vbpBr35.1 vbpBr36.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i36 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00264808):ℝ) ≤ ∫ v in (vBP 1.258)..(vBP 1.268), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.62095054) (m := (0:ℤ)) (ylo := 0.47935788) (yhi := 0.47935789)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.258) (q1 := 1.268) (t0 := 7.5) (t1 := 8)
    (A := 0.45904631) (B := 0.47488172) (X := 3.62095054) (rho := 0.17810323)
    (clo := (-0.88729126)) (chi := (-0.88729125)) (C := (-0.85459401)) (h := 0.14540599)
    (by norm_num) (by norm_num) oscBlock36 vbpBr36.1 vbpBr37.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i37 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00261048):ℝ) ≤ ∫ v in (vBP 1.268)..(vBP 1.28), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.75568705) (m := (0:ℤ)) (ylo := 0.61409439) (yhi := 0.6140944)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.268) (q1 := 1.28) (t0 := 7.5) (t1 := 8)
    (A := 0.4748817) (B := 0.49372017) (X := 3.75568705) (rho := 0.19407432)
    (clo := (-0.81729562)) (chi := (-0.8172956)) (C := (-0.81161064)) (h := 0.18838936)
    (by norm_num) (by norm_num) oscBlock37 vbpBr37.1 vbpBr38.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i38 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00211963):ℝ) ≤ ∫ v in (vBP 1.28)..(vBP 1.294), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.91335616) (m := (0:ℤ)) (ylo := 0.7717635) (yhi := 0.77176351)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.28) (q1 := 1.294) (t0 := 7.5) (t1 := 8)
    (A := 0.49372014) (B := 0.51547641) (X := 3.91335616) (rho := 0.21045513)
    (clo := (-0.71668194)) (chi := (-0.71668191)) (C := (-0.71668193)) (h := 0.21045515)
    (by norm_num) (by norm_num) oscBlock38 vbpBr38.1 vbpBr39.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i39 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00123009):ℝ) ≤ ∫ v in (vBP 1.294)..(vBP 1.308), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.08103054) (m := (0:ℤ)) (ylo := 0.93943788) (yhi := 0.93943789)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.294) (q1 := 1.308) (t0 := 7.5) (t1 := 8)
    (A := 0.51547638) (B := 0.53699853) (X := 4.08103054) (rho := 0.21495771)
    (clo := (-0.59024203)) (chi := (-0.59024186)) (C := (-0.59024195)) (h := 0.2149578)
    (by norm_num) (by norm_num) oscBlock39 vbpBr39.1 vbpBr40.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i40 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00068855):ℝ) ≤ ∫ v in (vBP 1.308)..(vBP 1.326), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.27107958) (m := (0:ℤ)) (ylo := 1.12948692) (yhi := 1.12948693)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.308) (q1 := 1.326) (t0 := 7.5) (t1 := 8)
    (A := 0.53699848) (B := 0.56433382) (X := 4.27107958) (rho := 0.24359099)
    (clo := (-0.42712471)) (chi := (-0.42712376)) (C := (-0.42712424)) (h := 0.24359147)
    (by norm_num) (by norm_num) oscBlock40 vbpBr40.1 vbpBr41.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i41 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.0003991):ℝ) ≤ ∫ v in (vBP 1.326)..(vBP 1.345), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.48740384) (m := (0:ℤ)) (ylo := 1.34581118) (yhi := 1.34581119)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.326) (q1 := 1.345) (t0 := 7.5) (t1 := 8)
    (A := 0.56433374) (B := 0.59278808) (X := 4.48740384) (rho := 0.25490081)
    (clo := (-0.22309719)) (chi := (-0.2230918)) (C := (-0.2230945)) (h := 0.25490351)
    (by norm_num) (by norm_num) oscBlock41 vbpBr41.1 vbpBr42.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i42 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00047204):ℝ) ≤ ∫ v in (vBP 1.345)..(vBP 1.362), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.69458885) (m := (0:ℤ)) (ylo := 1.55299619) (yhi := 1.5529962)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.345) (q1 := 1.362) (t0 := 7.5) (t1 := 8)
    (A := 0.59278796) (B := 0.6179085) (X := 4.69458885) (rho := 0.24867916)
    (clo := (-0.01782128)) (chi := (-0.01779878)) (C := (-0.01781003)) (h := 0.24869041)
    (by norm_num) (by norm_num) oscBlock42 vbpBr42.1 vbpBr43.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i43 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.0007743):ℝ) ≤ ∫ v in (vBP 1.362)..(vBP 1.376), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.87060256) (m := (0:ℤ)) (ylo := 0.15821357) (yhi := 0.15821358)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.362) (q1 := 1.376) (t0 := 7.5) (t1 := 8)
    (A := 0.61790831) (B := 0.6383616) (X := 4.87060256) (rho := 0.23629025)
    (clo := 0.15755434) (chi := 0.15755436) (C := 0.15755435) (h := 0.23629026)
    (by norm_num) (by norm_num) oscBlock43 vbpBr43.1 vbpBr44.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i44 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00118841):ℝ) ≤ ∫ v in (vBP 1.376)..(vBP 1.39), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.02828566) (m := (0:ℤ)) (ylo := 0.31589667) (yhi := 0.31589668)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.376) (q1 := 1.39) (t0 := 7.5) (t1 := 8)
    (A := 0.63836133) (B := 0.65860767) (X := 5.02828566) (rho := 0.24057571)
    (clo := 0.31066889) (chi := 0.31066891) (C := 0.3106689) (h := 0.24057572)
    (by norm_num) (by norm_num) oscBlock44 vbpBr44.1 vbpBr45.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i45 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00156708):ℝ) ≤ ∫ v in (vBP 1.39)..(vBP 1.404), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.18438077) (m := (0:ℤ)) (ylo := 0.47199178) (yhi := 0.47199179)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.39) (q1 := 1.404) (t0 := 7.5) (t1 := 8)
    (A := 0.65860729) (B := 0.67865086) (X := 5.18438077) (rho := 0.24482612)
    (clo := 0.45466119) (chi := 0.45466121) (C := 0.4546612) (h := 0.24482613)
    (by norm_num) (by norm_num) oscBlock45 vbpBr45.1 vbpBr46.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i46 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00186599):ℝ) ≤ ∫ v in (vBP 1.404)..(vBP 1.418), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.33891949) (m := (0:ℤ)) (ylo := 0.6265305) (yhi := 0.62653051)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.404) (q1 := 1.418) (t0 := 7.5) (t1 := 8)
    (A := 0.67865033) (B := 0.69849519) (X := 5.33891949) (rho := 0.24904204)
    (clo := 0.58633776) (chi := 0.58633778) (C := 0.58633777) (h := 0.24904205)
    (by norm_num) (by norm_num) oscBlock46 vbpBr46.1 vbpBr47.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i47 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00206251):ℝ) ≤ ∫ v in (vBP 1.418)..(vBP 1.432), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.49193262) (m := (0:ℤ)) (ylo := 0.77954363) (yhi := 0.77954364)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.418) (q1 := 1.432) (t0 := 7.5) (t1 := 8)
    (A := 0.69849446) (B := 0.7181446) (X := 5.49193262) (rho := 0.25322419)
    (clo := 0.7029549) (chi := 0.70295492) (C := 0.70295491) (h := 0.2532242)
    (by norm_num) (by norm_num) oscBlock47 vbpBr47.1 vbpBr48.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i48 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00203955):ℝ) ≤ ∫ v in (vBP 1.432)..(vBP 1.446), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.64344994) (m := (0:ℤ)) (ylo := 0.93106095) (yhi := 0.93106096)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.432) (q1 := 1.446) (t0 := 7.5) (t1 := 8)
    (A := 0.7181436) (B := 0.73760286) (X := 5.64344994) (rho := 0.25737295)
    (clo := 0.80225376) (chi := 0.80225378) (C := 0.7724404) (h := 0.2275596)
    (by norm_num) (by norm_num) oscBlock48 vbpBr48.1 vbpBr49.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i49 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00218663):ℝ) ≤ ∫ v in (vBP 1.446)..(vBP 1.462), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.80445205) (m := (0:ℤ)) (ylo := 1.09206306) (yhi := 1.09206307)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.446) (q1 := 1.462) (t0 := 7.5) (t1 := 8)
    (A := 0.73760153) (B := 0.75961158) (X := 5.80445205) (rho := 0.2724406)
    (clo := 0.88757916) (chi := 0.88757924) (C := 0.80756928) (h := 0.19243072)
    (by norm_num) (by norm_num) oscBlock49 vbpBr49.1 vbpBr50.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i50 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00209905):ℝ) ≤ ∫ v in (vBP 1.462)..(vBP 1.478), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.97405972) (m := (0:ℤ)) (ylo := 1.26167073) (yhi := 1.26167074)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.462) (q1 := 1.478) (t0 := 7.5) (t1 := 8)
    (A := 0.75960973) (B := 0.78138081) (X := 5.97405972) (rho := 0.27698677)
    (clo := 0.95259994) (chi := 0.95260028) (C := 0.83780658) (h := 0.16219342)
    (by norm_num) (by norm_num) oscBlock50 vbpBr50.1 vbpBr51.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i51 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00207223):ℝ) ≤ ∫ v in (vBP 1.478)..(vBP 1.495), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.14718466) (m := (0:ℤ)) (ylo := 1.43479567) (yhi := 1.43479568)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.478) (q1 := 1.495) (t0 := 7.5) (t1 := 8)
    (A := 0.7813783) (B := 0.80425401) (X := 6.14718466) (rho := 0.28684743)
    (clo := 0.99076613) (chi := 0.99076747) (C := 0.85195935) (h := 0.14804065)
    (by norm_num) (by norm_num) oscBlock51 vbpBr51.1 vbpBr52.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i52 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00192131):ℝ) ≤ ∫ v in (vBP 1.495)..(vBP 1.512), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.32341448) (m := (1:ℤ)) (ylo := 0.04022917) (yhi := 0.04022918)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.495) (q1 := 1.512) (t0 := 7.5) (t1 := 8)
    (A := 0.80425056) (B := 0.82686872) (X := 6.32341448) (rho := 0.29153529)
    (clo := 0.99919091) (chi := 0.99919092) (C := 0.85382781) (h := 0.14617219)
    (by norm_num) (by norm_num) oscBlock52 vbpBr52.1 vbpBr53.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i53 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00197876):ℝ) ≤ ∫ v in (vBP 1.512)..(vBP 1.531), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.50812106) (m := (1:ℤ)) (ylo := 0.22493575) (yhi := 0.22493576)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.512) (q1 := 1.531) (t0 := 7.5) (t1 := 8)
    (A := 0.82686405) (B := 0.85184522) (X := 6.50812106) (rho := 0.30664071)
    (clo := 0.97480843) (chi := 0.97480844) (C := 0.83408386) (h := 0.16591614)
    (by norm_num) (by norm_num) oscBlock53 vbpBr53.1 vbpBr54.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i54 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.0018127):ℝ) ≤ ∫ v in (vBP 1.531)..(vBP 1.55), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.7004511) (m := (1:ℤ)) (ylo := 0.41726579) (yhi := 0.4172658)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.531) (q1 := 1.55) (t0 := 7.5) (t1 := 8)
    (A := 0.85183877) (B := 0.87651393) (X := 6.7004511) (rho := 0.31166035)
    (clo := 0.91420042) (chi := 0.91420043) (C := 0.80127003) (h := 0.19872997)
    (by norm_num) (by norm_num) oscBlock54 vbpBr54.1 vbpBr55.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i55 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00174878):ℝ) ≤ ∫ v in (vBP 1.55)..(vBP 1.57), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.89552143) (m := (1:ℤ)) (ylo := 0.61233612) (yhi := 0.61233613)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.55) (q1 := 1.57) (t0 := 7.5) (t1 := 8)
    (A := 0.87650515) (B := 0.90215678) (X := 6.89552143) (rho := 0.32173282)
    (clo := 0.81830748) (chi := 0.8183075) (C := 0.74828733) (h := 0.25171267)
    (by norm_num) (by norm_num) oscBlock55 vbpBr55.1 vbpBr56.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i56 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00159903):ℝ) ≤ ∫ v in (vBP 1.57)..(vBP 1.59), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.09294495) (m := (1:ℤ)) (ylo := 0.80975964) (yhi := 0.80975965)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.57) (q1 := 1.59) (t0 := 7.5) (t1 := 8)
    (A := 0.90214481) (B := 0.92747548) (X := 7.09294495) (rho := 0.3268589)
    (clo := 0.68967249) (chi := 0.68967254) (C := 0.68140679) (h := 0.31859321)
    (by norm_num) (by norm_num) oscBlock56 vbpBr56.1 vbpBr57.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i57 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.0012712):ℝ) ≤ ∫ v in (vBP 1.59)..(vBP 1.61), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.28788571) (m := (1:ℤ)) (ylo := 1.0047004) (yhi := 1.00470041)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.59) (q1 := 1.61) (t0 := 7.5) (t1 := 8)
    (A := 0.92745939) (B := 0.95247825) (X := 7.28788571) (rho := 0.3319403)
    (clo := 0.53634109) (chi := 0.53634139) (C := 0.53634124) (h := 0.33194045)
    (by norm_num) (by norm_num) oscBlock57 vbpBr57.1 vbpBr58.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i58 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00104838):ℝ) ≤ ∫ v in (vBP 1.61)..(vBP 1.632), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.49021669) (m := (1:ℤ)) (ylo := 1.20703138) (yhi := 1.20703139)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.61) (q1 := 1.632) (t0 := 7.5) (t1 := 8)
    (A := 0.95245689) (B := 0.97962584) (X := 7.49021669) (rho := 0.34679004)
    (clo := 0.3557953) (chi := 0.35579712) (C := 0.35579621) (h := 0.34679095)
    (by norm_num) (by norm_num) oscBlock58 vbpBr58.1 vbpBr59.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i59 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00075976):ℝ) ≤ ∫ v in (vBP 1.632)..(vBP 1.656), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.70880209) (m := (1:ℤ)) (ylo := 1.42561678) (yhi := 1.42561679)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.632) (q1 := 1.656) (t0 := 7.5) (t1 := 8)
    (A := 0.97959707) (B := 1.00882827) (X := 7.70880209) (rho := 0.36182408)
    (clo := 0.14466993) (chi := 0.14467951) (C := 0.14467472) (h := 0.36182887)
    (by norm_num) (by norm_num) oscBlock59 vbpBr59.1 vbpBr60.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i60 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00056493):ℝ) ≤ ∫ v in (vBP 1.656)..(vBP 1.68), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 7.93340685) (m := (1:ℤ)) (ylo := 0.07942521) (yhi := 0.07942522)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.656) (q1 := 1.68) (t0 := 7.5) (t1 := 8)
    (A := 1.00878907) (B := 1.03761196) (X := 7.93340685) (rho := 0.36748884)
    (clo := (-0.07934174)) (chi := (-0.07934172)) (C := (-0.07934173)) (h := 0.36748885)
    (by norm_num) (by norm_num) oscBlock60 vbpBr60.1 vbpBr61.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i61 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.0006919):ℝ) ≤ ∫ v in (vBP 1.68)..(vBP 1.704), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.15480408) (m := (1:ℤ)) (ylo := 0.30082244) (yhi := 0.30082245)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.68) (q1 := 1.704) (t0 := 7.5) (t1 := 8)
    (A := 1.03755935) (B := 1.06598913) (X := 8.15480408) (rho := 0.37310897)
    (clo := (-0.29630583)) (chi := (-0.29630581)) (C := (-0.29630582)) (h := 0.37310898)
    (by norm_num) (by norm_num) oscBlock61 vbpBr61.1 vbpBr62.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i62 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00103458):ℝ) ≤ ∫ v in (vBP 1.704)..(vBP 1.734), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.40082521) (m := (1:ℤ)) (ylo := 0.54684357) (yhi := 0.54684358)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.704) (q1 := 1.734) (t0 := 7.5) (t1 := 8)
    (A := 1.06591948) (B := 1.10090679) (X := 8.40082521) (rho := 0.40642912)
    (clo := (-0.51999371)) (chi := (-0.51999369)) (C := (-0.5199937)) (h := 0.40642913)
    (by norm_num) (by norm_num) oscBlock62 vbpBr62.1 vbpBr63.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i63 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00104758):ℝ) ≤ ∫ v in (vBP 1.734)..(vBP 1.766), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.67802475) (m := (1:ℤ)) (ylo := 0.82404311) (yhi := 0.82404312)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.734) (q1 := 1.766) (t0 := 7.5) (t1 := 8)
    (A := 1.10080961) (B := 1.13749718) (X := 8.67802475) (rho := 0.4219527)
    (clo := (-0.73389816)) (chi := (-0.73389814)) (C := (-0.65597272)) (h := 0.34402728)
    (by norm_num) (by norm_num) oscBlock63 vbpBr63.1 vbpBr64.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i64 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.0008716):ℝ) ≤ ∫ v in (vBP 1.766)..(vBP 1.796), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.94993979) (m := (1:ℤ)) (ylo := 1.09595815) (yhi := 1.09595816)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.766) (q1 := 1.796) (t0 := 7.5) (t1 := 8)
    (A := 1.1373613) (B := 1.17120873) (X := 8.94993979) (rho := 0.41973006)
    (clo := (-0.8893668)) (chi := (-0.88936671)) (C := (-0.73481833)) (h := 0.26518168)
    (by norm_num) (by norm_num) oscBlock64 vbpBr64.1 vbpBr65.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i65 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00088309):ℝ) ≤ ∫ v in (vBP 1.796)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 9.21758463) (m := (1:ℤ)) (ylo := 1.36360299) (yhi := 1.363603)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.796) (q1 := 1.828) (t0 := 7.5) (t1 := 8)
    (A := 1.1710258) (B := 1.20655947) (X := 9.21758463) (rho := 0.43489114)
    (clo := (-0.9786129)) (chi := (-0.97861212)) (C := (-0.77186049)) (h := 0.22813951)
    (by norm_num) (by norm_num) oscBlock65 vbpBr65.1 vbpBr66.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i66 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00084272):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.86), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 9.48889261) (m := (1:ℤ)) (ylo := 0.06411464) (yhi := 0.06411465)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.828) (q1 := 1.86) (t0 := 7.5) (t1 := 8)
    (A := 1.20631244) (B := 1.24130524) (X := 9.48889261) (rho := 0.44154932)
    (clo := (-0.99794537)) (chi := (-0.99794535)) (C := (-0.77819802)) (h := 0.22180199)
    (by norm_num) (by norm_num) oscBlock66 vbpBr66.1 vbpBr67.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i67 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00072819):ℝ) ≤ ∫ v in (vBP 1.86)..(vBP 1.89), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 9.7470629) (m := (1:ℤ)) (ylo := 0.32228493) (yhi := 0.32228494)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.86) (q1 := 1.89) (t0 := 7.5) (t1 := 8)
    (A := 1.24097685) (B := 1.27334993) (X := 9.7470629) (rho := 0.43973655)
    (clo := (-0.94851418)) (chi := (-0.94851417)) (C := (-0.75438881)) (h := 0.24561119)
    (by norm_num) (by norm_num) oscBlock67 vbpBr67.1 vbpBr68.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i68 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00073027):ℝ) ≤ ∫ v in (vBP 1.89)..(vBP 1.922), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 10.00142161) (m := (1:ℤ)) (ylo := 0.57664364) (yhi := 0.57664365)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.89) (q1 := 1.922) (t0 := 7.5) (t1 := 8)
    (A := 1.27292668) (B := 1.30698664) (X := 10.00142161) (rho := 0.45447152)
    (clo := (-0.83829731)) (chi := (-0.83829729)) (C := (-0.69191289)) (h := 0.30808712)
    (by norm_num) (by norm_num) oscBlock68 vbpBr68.1 vbpBr69.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i69 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00097649):ℝ) ≤ ∫ v in (vBP 1.922)..(vBP 1.969), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 10.32080402) (m := (1:ℤ)) (ylo := 0.89602605) (yhi := 0.89602606)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.922) (q1 := 1.969) (t0 := 7.5) (t1 := 8)
    (A := 1.30643896) (B := 1.35541448) (X := 10.32080402) (rho := 0.52251183)
    (clo := (-0.62471805)) (chi := (-0.62471794)) (C := (-0.55110306)) (h := 0.44889695)
    (by norm_num) (by norm_num) oscBlock69 vbpBr69.1 vbpBr70.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i70 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00073047):ℝ) ≤ ∫ v in (vBP 1.969)..(vBP 2.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 10.69081857) (m := (1:ℤ)) (ylo := 1.2660406) (yhi := 1.26604061)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.969) (q1 := 2.016) (t0 := 7.5) (t1 := 8)
    (A := 1.35463226) (B := 1.4027369) (X := 10.69081857) (rho := 0.53107664)
    (clo := (-0.30006305)) (chi := (-0.30006012)) (C := (-0.30006159)) (h := 0.53107811)
    (by norm_num) (by norm_num) oscBlock70 vbpBr70.1 vbpBr71.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i71 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00045929):ℝ) ≤ ∫ v in (vBP 2.016)..(vBP 2.062), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 11.0483307) (m := (1:ℤ)) (ylo := 0.05275641) (yhi := 0.05275642)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.016) (q1 := 2.062) (t0 := 7.5) (t1 := 8)
    (A := 1.40164597) (B := 1.44803958) (X := 11.0483307) (rho := 0.53598595)
    (clo := 0.05273194) (chi := 0.05273196) (C := 0.05273195) (h := 0.53598596)
    (by norm_num) (by norm_num) oscBlock71 vbpBr71.1 vbpBr72.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB0i72 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.00040162):ℝ) ≤ ∫ v in (vBP 2.062)..(vBP 2.094), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 11.34056766) (m := (1:ℤ)) (ylo := 0.34499337) (yhi := 0.34499338)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.062) (q1 := 2.094) (t0 := 7.5) (t1 := 8)
    (A := 1.44655973) (B := 1.47899217) (X := 11.34056766) (rho := 0.49136971)
    (clo := 0.33819043) (chi := 0.33819045) (C := 0.33819044) (h := 0.49136972)
    (by norm_num) (by norm_num) oscBlock72 vbpBr72.1 vbpBr73.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

/-- Lower bound for the oscillatory integral `∫₀^∞ err(v) cos(tv) dv` on the band
`7.5 ≤ t ≤ 8.0`. -/
theorem oscBandLower0 {t : ℝ} (ht0 : (7.5:ℝ) ≤ t) (ht1 : t ≤ 8) :
    ((-0.17461105):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosB0i0 ht0 ht1)
    (cosB0i1 ht0 ht1))
    (cosB0i2 ht0 ht1))
    (cosB0i3 ht0 ht1))
    (cosB0i4 ht0 ht1))
    (cosB0i5 ht0 ht1))
    (cosB0i6 ht0 ht1))
    (cosB0i7 ht0 ht1))
    (cosB0i8 ht0 ht1))
    (cosB0i9 ht0 ht1))
    (cosB0i10 ht0 ht1))
    (cosB0i11 ht0 ht1))
    (cosB0i12 ht0 ht1))
    (cosB0i13 ht0 ht1))
    (cosB0i14 ht0 ht1))
    (cosB0i15 ht0 ht1))
    (cosB0i16 ht0 ht1))
    (cosB0i17 ht0 ht1))
    (cosB0i18 ht0 ht1))
    (cosB0i19 ht0 ht1))
    (cosB0i20 ht0 ht1))
    (cosB0i21 ht0 ht1))
    (cosB0i22 ht0 ht1))
    (cosB0i23 ht0 ht1))
    (cosB0i24 ht0 ht1))
    (cosB0i25 ht0 ht1))
    (cosB0i26 ht0 ht1))
    (cosB0i27 ht0 ht1))
    (cosB0i28 ht0 ht1))
    (cosB0i29 ht0 ht1))
    (cosB0i30 ht0 ht1))
    (cosB0i31 ht0 ht1))
    (cosB0i32 ht0 ht1))
    (cosB0i33 ht0 ht1))
    (cosB0i34 ht0 ht1))
    (cosB0i35 ht0 ht1))
    (cosB0i36 ht0 ht1))
    (cosB0i37 ht0 ht1))
    (cosB0i38 ht0 ht1))
    (cosB0i39 ht0 ht1))
    (cosB0i40 ht0 ht1))
    (cosB0i41 ht0 ht1))
    (cosB0i42 ht0 ht1))
    (cosB0i43 ht0 ht1))
    (cosB0i44 ht0 ht1))
    (cosB0i45 ht0 ht1))
    (cosB0i46 ht0 ht1))
    (cosB0i47 ht0 ht1))
    (cosB0i48 ht0 ht1))
    (cosB0i49 ht0 ht1))
    (cosB0i50 ht0 ht1))
    (cosB0i51 ht0 ht1))
    (cosB0i52 ht0 ht1))
    (cosB0i53 ht0 ht1))
    (cosB0i54 ht0 ht1))
    (cosB0i55 ht0 ht1))
    (cosB0i56 ht0 ht1))
    (cosB0i57 ht0 ht1))
    (cosB0i58 ht0 ht1))
    (cosB0i59 ht0 ht1))
    (cosB0i60 ht0 ht1))
    (cosB0i61 ht0 ht1))
    (cosB0i62 ht0 ht1))
    (cosB0i63 ht0 ht1))
    (cosB0i64 ht0 ht1))
    (cosB0i65 ht0 ht1))
    (cosB0i66 ht0 ht1))
    (cosB0i67 ht0 ht1))
    (cosB0i68 ht0 ht1))
    (cosB0i69 ht0 ht1))
    (cosB0i70 ht0 ht1))
    (cosB0i71 ht0 ht1))
    (cosB0i72 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 2.094) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 2.094) (S := 0.013709)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_cut
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
