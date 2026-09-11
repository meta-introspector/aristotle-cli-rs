/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscTail

/-!
# Oscillatory lower bound on the band `5.9375 ≤ t ≤ 6.0`

On each of the 73 blocks the factor `cos(tv)` is bracketed by a rational constant
`C` up to a rational error `h`; the signed contribution `min(C·P₀, C·P₁) - h·S` is
then summed, and the unresolved tail beyond `q = 2.094` is estimated in absolute
value.  The result is the bound `∫₀^∞ err(v) cos(tv) dv ≥ -0.12209272`.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosB14i0 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00641868):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.0038), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.0227568) (m := (0:ℤ)) (ylo := 0.0227568) (yhi := 0.0227568)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1) (q1 := 1.0038) (t0 := 5.9375) (t1 := 6)
    (A := 0.0) (B := 0.0075856) (X := 0.0227568) (rho := 0.02275681)
    (clo := 0.99974107) (chi := 0.99974108) (C := 0.98849213) (h := 0.01150787)
    (by norm_num) (by norm_num) oscBlock0 vbpBr0.1 vbpBr1.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i1 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00625872):ℝ) ≤ ∫ v in (vBP 1.0038)..(vBP 1.0078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.06913816) (m := (0:ℤ)) (ylo := 0.06913816) (yhi := 0.06913816)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0038) (q1 := 1.0078) (t0 := 5.9375) (t1 := 6)
    (A := 0.00758559) (B := 0.01553948) (X := 0.06913816) (rho := 0.02409873)
    (clo := 0.9976109) (chi := 0.99761091) (C := 0.98675608) (h := 0.01324392)
    (by norm_num) (by norm_num) oscBlock1 vbpBr1.1 vbpBr2.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i2 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.0057677):ℝ) ≤ ∫ v in (vBP 1.0078)..(vBP 1.0118), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.11651835) (m := (0:ℤ)) (ylo := 0.11651835) (yhi := 0.11651835)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0078) (q1 := 1.0118) (t0 := 5.9375) (t1 := 6)
    (A := 0.01553947) (B := 0.02346185) (X := 0.11651835) (rho := 0.02425276)
    (clo := 0.99321941) (chi := 0.99321942) (C := 0.98448332) (h := 0.01551668)
    (by norm_num) (by norm_num) oscBlock2 vbpBr2.1 vbpBr3.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i3 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00554846):ℝ) ≤ ∫ v in (vBP 1.0118)..(vBP 1.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.16489243) (m := (0:ℤ)) (ylo := 0.16489243) (yhi := 0.16489243)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0118) (q1 := 1.016) (t0 := 5.9375) (t1 := 6)
    (A := 0.02346184) (B := 0.0317467) (X := 0.16489243) (rho := 0.02558778)
    (clo := 0.98643601) (chi := 0.98643602) (C := 0.98042411) (h := 0.01957589)
    (by norm_num) (by norm_num) oscBlock3 vbpBr3.1 vbpBr4.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i4 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00539232):ℝ) ≤ ∫ v in (vBP 1.016)..(vBP 1.0205), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.21600421) (m := (0:ℤ)) (ylo := 0.21600421) (yhi := 0.21600421)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.016) (q1 := 1.0205) (t0 := 5.9375) (t1 := 6)
    (A := 0.03174669) (B := 0.04058541) (X := 0.21600421) (rho := 0.02750826)
    (clo := 0.97676165) (chi := 0.97676166) (C := 0.97462669) (h := 0.02537331)
    (by norm_num) (by norm_num) oscBlock4 vbpBr4.1 vbpBr5.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i5 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00481119):ℝ) ≤ ∫ v in (vBP 1.0205)..(vBP 1.025), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.26864359) (m := (0:ℤ)) (ylo := 0.26864359) (yhi := 0.26864359)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0205) (q1 := 1.025) (t0 := 5.9375) (t1 := 6)
    (A := 0.0405854) (B := 0.04938523) (X := 0.26864359) (rho := 0.0276678)
    (clo := 0.9641318) (chi := 0.96413181) (C := 0.9641318) (h := 0.02766781)
    (by norm_num) (by norm_num) oscBlock5 vbpBr5.1 vbpBr6.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i6 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00468889):ℝ) ≤ ∫ v in (vBP 1.025)..(vBP 1.03), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.3239652) (m := (0:ℤ)) (ylo := 0.3239652) (yhi := 0.3239652)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.025) (q1 := 1.03) (t0 := 5.9375) (t1 := 6)
    (A := 0.04938522) (B := 0.05911761) (X := 0.3239652) (rho := 0.03074047)
    (clo := 0.94798063) (chi := 0.94798064) (C := 0.94798063) (h := 0.03074048)
    (by norm_num) (by norm_num) oscBlock6 vbpBr6.1 vbpBr7.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i7 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00438741):ℝ) ≤ ∫ v in (vBP 1.03)..(vBP 1.0355), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.3848118) (m := (0:ℤ)) (ylo := 0.3848118) (yhi := 0.3848118)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.03) (q1 := 1.0355) (t0 := 5.9375) (t1 := 6)
    (A := 0.0591176) (B := 0.06976881) (X := 0.3848118) (rho := 0.03380107)
    (clo := 0.92686909) (chi := 0.9268691) (C := 0.92686909) (h := 0.03380108)
    (by norm_num) (by norm_num) oscBlock7 vbpBr7.1 vbpBr8.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i8 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.0039272):ℝ) ≤ ∫ v in (vBP 1.0355)..(vBP 1.0415), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.45109803) (m := (0:ℤ)) (ylo := 0.45109803) (yhi := 0.45109803)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0355) (q1 := 1.0415) (t0 := 5.9375) (t1 := 6)
    (A := 0.0697688) (B := 0.08132397) (X := 0.45109803) (rho := 0.0368458)
    (clo := 0.89996895) (chi := 0.89996896) (C := 0.89996895) (h := 0.03684581)
    (by norm_num) (by norm_num) oscBlock8 vbpBr8.1 vbpBr9.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i9 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00333458):ℝ) ≤ ∫ v in (vBP 1.0415)..(vBP 1.048), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.52273204) (m := (0:ℤ)) (ylo := 0.52273204) (yhi := 0.52273204)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0415) (q1 := 1.048) (t0 := 5.9375) (t1 := 6)
    (A := 0.08132396) (B := 0.09376718) (X := 0.52273204) (rho := 0.03987105)
    (clo := 0.86645844) (chi := 0.86645845) (C := 0.86645844) (h := 0.03987106)
    (by norm_num) (by norm_num) oscBlock9 vbpBr9.1 vbpBr10.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i10 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00266173):ℝ) ≤ ∫ v in (vBP 1.048)..(vBP 1.055), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.5996159) (m := (0:ℤ)) (ylo := 0.5996159) (yhi := 0.5996159)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.048) (q1 := 1.055) (t0 := 5.9375) (t1 := 6)
    (A := 0.09376717) (B := 0.10708154) (X := 0.5996159) (rho := 0.04287335)
    (clo := 0.82555243) (chi := 0.82555244) (C := 0.82555243) (h := 0.04287336)
    (by norm_num) (by norm_num) oscBlock10 vbpBr10.1 vbpBr11.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i11 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00220114):ℝ) ≤ ∫ v in (vBP 1.055)..(vBP 1.064), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.69011066) (m := (0:ℤ)) (ylo := 0.69011066) (yhi := 0.69011066)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.055) (q1 := 1.064) (t0 := 5.9375) (t1 := 6)
    (A := 0.10708153) (B := 0.12407079) (X := 0.69011066) (rho := 0.05431409)
    (clo := 0.77117557) (chi := 0.77117558) (C := 0.77117557) (h := 0.0543141)
    (by norm_num) (by norm_num) oscBlock11 vbpBr11.1 vbpBr12.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i12 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00142359):ℝ) ≤ ∫ v in (vBP 1.064)..(vBP 1.078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.81897997) (m := (0:ℤ)) (ylo := 0.81897997) (yhi := 0.81897997)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.064) (q1 := 1.078) (t0 := 5.9375) (t1 := 6)
    (A := 0.12407078) (B := 0.15021495) (X := 0.81897997) (rho := 0.08230974)
    (clo := 0.68296664) (chi := 0.68296669) (C := 0.68296666) (h := 0.08230977)
    (by norm_num) (by norm_num) oscBlock12 vbpBr12.1 vbpBr13.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i13 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    (0.00017278:ℝ) ≤ ∫ v in (vBP 1.078)..(vBP 1.09), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.9630168) (m := (0:ℤ)) (ylo := 0.9630168) (yhi := 0.9630168)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.078) (q1 := 1.09) (t0 := 5.9375) (t1 := 6)
    (A := 0.15021494) (B := 0.1723554) (X := 0.9630168) (rho := 0.07111561)
    (clo := 0.57104604) (chi := 0.57104624) (C := 0.57104614) (h := 0.07111571)
    (by norm_num) (by norm_num) oscBlock13 vbpBr13.1 vbpBr14.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i14 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    (0.0006834:ℝ) ≤ ∫ v in (vBP 1.09)..(vBP 1.1), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.08354114) (m := (0:ℤ)) (ylo := 1.08354114) (yhi := 1.08354114)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.09) (q1 := 1.1) (t0 := 5.9375) (t1 := 6)
    (A := 0.17235539) (B := 0.19062036) (X := 1.08354114) (rho := 0.06018103)
    (clo := 0.46820227) (chi := 0.46820289) (C := 0.46820258) (h := 0.06018134)
    (by norm_num) (by norm_num) oscBlock14 vbpBr14.1 vbpBr15.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i15 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    (0.00074686:ℝ) ≤ ∫ v in (vBP 1.1)..(vBP 1.109), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.18665642) (m := (0:ℤ)) (ylo := 1.18665642) (yhi := 1.18665642)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.1) (q1 := 1.109) (t0 := 5.9375) (t1 := 6)
    (A := 0.19062035) (B := 0.20691742) (X := 1.18665642) (rho := 0.05484811)
    (clo := 0.37476184) (chi := 0.37476338) (C := 0.37476261) (h := 0.05484888)
    (by norm_num) (by norm_num) oscBlock15 vbpBr15.1 vbpBr16.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i16 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    (0.00061536:ℝ) ≤ ∫ v in (vBP 1.109)..(vBP 1.117), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.27816521) (m := (0:ℤ)) (ylo := 1.27816521) (yhi := 1.27816521)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.109) (q1 := 1.117) (t0 := 5.9375) (t1 := 6)
    (A := 0.20691741) (B := 0.22129305) (X := 1.27816521) (rho := 0.0495931)
    (clo := 0.28847244) (chi := 0.28847566) (C := 0.28847405) (h := 0.04959471)
    (by norm_num) (by norm_num) oscBlock16 vbpBr16.1 vbpBr17.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i17 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    (0.00042636:ℝ) ≤ ∫ v in (vBP 1.117)..(vBP 1.124), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.35832624) (m := (0:ℤ)) (ylo := 1.35832624) (yhi := 1.35832624)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.117) (q1 := 1.124) (t0 := 5.9375) (t1 := 6)
    (A := 0.22129304) (B := 0.23378751) (X := 1.35832624) (rho := 0.04439883)
    (clo := 0.210875) (chi := 0.2108809) (C := 0.21087795) (h := 0.04440178)
    (by norm_num) (by norm_num) oscBlock17 vbpBr17.1 vbpBr18.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i18 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    (0.0002535:ℝ) ≤ ∫ v in (vBP 1.124)..(vBP 1.131), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.43266984) (m := (0:ℤ)) (ylo := 1.43266984) (yhi := 1.43266984)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.124) (q1 := 1.131) (t0 := 5.9375) (t1 := 6)
    (A := 0.2337875) (B := 0.2462044) (X := 1.43266984) (rho := 0.04455657)
    (clo := 0.13768753) (chi := 0.13769758) (C := 0.13769255) (h := 0.0445616)
    (by norm_num) (by norm_num) oscBlock18 vbpBr18.1 vbpBr19.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i19 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    (0.00004107:ℝ) ≤ ∫ v in (vBP 1.131)..(vBP 1.138), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.50655332) (m := (0:ℤ)) (ylo := 1.50655332) (yhi := 1.50655332)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.131) (q1 := 1.138) (t0 := 5.9375) (t1 := 6)
    (A := 0.24620439) (B := 0.25854468) (X := 1.50655332) (rho := 0.04471477)
    (clo := 0.06419854) (chi := 0.06421515) (C := 0.06420684) (h := 0.04472308)
    (by norm_num) (by norm_num) oscBlock19 vbpBr19.1 vbpBr20.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i20 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.0002013):ℝ) ≤ ∫ v in (vBP 1.138)..(vBP 1.145), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.57998232) (m := (0:ℤ)) (ylo := 0.00918599) (yhi := 0.009186)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.138) (q1 := 1.145) (t0 := 5.9375) (t1 := 6)
    (A := 0.25854467) (B := 0.27080928) (X := 1.57998232) (rho := 0.04487337)
    (clo := (-0.00918588)) (chi := (-0.00918586)) (C := (-0.00918587)) (h := 0.04487338)
    (by norm_num) (by norm_num) oscBlock20 vbpBr20.1 vbpBr21.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i21 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00048684):ℝ) ≤ ∫ v in (vBP 1.145)..(vBP 1.152), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.65296241) (m := (0:ℤ)) (ylo := 0.08216608) (yhi := 0.08216609)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.145) (q1 := 1.152) (t0 := 5.9375) (t1 := 6)
    (A := 0.27080927) (B := 0.28299913) (X := 1.65296241) (rho := 0.04503238)
    (clo := (-0.08207367)) (chi := (-0.08207365)) (C := (-0.08207366)) (h := 0.04503239)
    (by norm_num) (by norm_num) oscBlock21 vbpBr21.1 vbpBr22.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i22 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00077752):ℝ) ≤ ∫ v in (vBP 1.152)..(vBP 1.159), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.72549902) (m := (0:ℤ)) (ylo := 0.15470269) (yhi := 0.1547027)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.152) (q1 := 1.159) (t0 := 5.9375) (t1 := 6)
    (A := 0.28299912) (B := 0.29511513) (X := 1.72549902) (rho := 0.04519177)
    (clo := (-0.15408636)) (chi := (-0.15408634)) (C := (-0.15408635)) (h := 0.04519178)
    (by norm_num) (by norm_num) oscBlock22 vbpBr22.1 vbpBr23.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i23 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00106329):ℝ) ≤ ∫ v in (vBP 1.159)..(vBP 1.166), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.79759755) (m := (0:ℤ)) (ylo := 0.22680122) (yhi := 0.22680123)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.159) (q1 := 1.166) (t0 := 5.9375) (t1 := 6)
    (A := 0.29511512) (B := 0.30715818) (X := 1.79759755) (rho := 0.04535154)
    (clo := (-0.22486183)) (chi := (-0.22486181)) (C := (-0.22486182)) (h := 0.04535155)
    (by norm_num) (by norm_num) oscBlock23 vbpBr23.1 vbpBr24.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i24 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00133545):ℝ) ≤ ∫ v in (vBP 1.166)..(vBP 1.173), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.86926323) (m := (0:ℤ)) (ylo := 0.2984669) (yhi := 0.29846691)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.166) (q1 := 1.173) (t0 := 5.9375) (t1 := 6)
    (A := 0.30715817) (B := 0.31912914) (X := 1.86926323) (rho := 0.04551162)
    (clo := (-0.29405525)) (chi := (-0.29405523)) (C := (-0.29405524)) (h := 0.04551163)
    (by norm_num) (by norm_num) oscBlock24 vbpBr24.1 vbpBr25.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i25 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00158647):ℝ) ≤ ∫ v in (vBP 1.173)..(vBP 1.18), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.94050124) (m := (0:ℤ)) (ylo := 0.36970491) (yhi := 0.36970492)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.173) (q1 := 1.18) (t0 := 5.9375) (t1 := 6)
    (A := 0.31912913) (B := 0.33102888) (X := 1.94050124) (rho := 0.04567205)
    (clo := (-0.36134031)) (chi := (-0.36134029)) (C := (-0.3613403)) (h := 0.04567206)
    (by norm_num) (by norm_num) oscBlock25 vbpBr25.1 vbpBr26.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i26 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00181):ℝ) ≤ ∫ v in (vBP 1.18)..(vBP 1.187), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.01131667) (m := (0:ℤ)) (ylo := 0.44052034) (yhi := 0.44052035)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.18) (q1 := 1.187) (t0 := 5.9375) (t1 := 6)
    (A := 0.33102887) (B := 0.34285824) (X := 2.01131667) (rho := 0.04583278)
    (clo := (-0.4264102)) (chi := (-0.42641018)) (C := (-0.42641019)) (h := 0.04583279)
    (by norm_num) (by norm_num) oscBlock26 vbpBr26.1 vbpBr27.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i27 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00200098):ℝ) ≤ ∫ v in (vBP 1.187)..(vBP 1.194), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.08171449) (m := (0:ℤ)) (ylo := 0.51091816) (yhi := 0.51091817)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.187) (q1 := 1.194) (t0 := 5.9375) (t1 := 6)
    (A := 0.34285823) (B := 0.35461804) (X := 2.08171449) (rho := 0.04599376)
    (clo := (-0.48897837)) (chi := (-0.48897836)) (C := (-0.48897837)) (h := 0.04599377)
    (by norm_num) (by norm_num) oscBlock27 vbpBr27.1 vbpBr28.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i28 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.0021777):ℝ) ≤ ∫ v in (vBP 1.194)..(vBP 1.201), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.15169951) (m := (0:ℤ)) (ylo := 0.58090318) (yhi := 0.58090319)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.194) (q1 := 1.201) (t0 := 5.9375) (t1 := 6)
    (A := 0.35461802) (B := 0.36630909) (X := 2.15169951) (rho := 0.04615504)
    (clo := (-0.5487792)) (chi := (-0.54877918)) (C := (-0.54877919)) (h := 0.04615505)
    (by norm_num) (by norm_num) oscBlock28 vbpBr28.1 vbpBr29.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i29 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00229503):ℝ) ≤ ∫ v in (vBP 1.201)..(vBP 1.208), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.22127668) (m := (0:ℤ)) (ylo := 0.65048035) (yhi := 0.65048036)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.201) (q1 := 1.208) (t0 := 5.9375) (t1 := 6)
    (A := 0.36630908) (B := 0.3779322) (X := 2.22127668) (rho := 0.04631653)
    (clo := (-0.60556875)) (chi := (-0.60556873)) (C := (-0.60556874)) (h := 0.04631654)
    (by norm_num) (by norm_num) oscBlock29 vbpBr29.1 vbpBr30.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i30 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00237176):ℝ) ≤ ∫ v in (vBP 1.208)..(vBP 1.215), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.29045066) (m := (0:ℤ)) (ylo := 0.71965433) (yhi := 0.71965434)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.208) (q1 := 1.215) (t0 := 5.9375) (t1 := 6)
    (A := 0.37793219) (B := 0.38948816) (X := 2.29045066) (rho := 0.04647831)
    (clo := (-0.65912477)) (chi := (-0.65912475)) (C := (-0.65912476)) (h := 0.04647832)
    (by norm_num) (by norm_num) oscBlock30 vbpBr30.1 vbpBr31.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i31 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00277029):ℝ) ≤ ∫ v in (vBP 1.215)..(vBP 1.223), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.3641341) (m := (0:ℤ)) (ylo := 0.79333777) (yhi := 0.79333778)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.215) (q1 := 1.223) (t0 := 5.9375) (t1 := 6)
    (A := 0.38948815) (B := 0.40261372) (X := 2.3641341) (rho := 0.05154823)
    (clo := (-0.7126986)) (chi := (-0.71269858)) (C := (-0.71269859)) (h := 0.05154824)
    (by norm_num) (by norm_num) oscBlock31 vbpBr31.1 vbpBr32.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i32 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00275606):ℝ) ≤ ∫ v in (vBP 1.223)..(vBP 1.231), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.44222055) (m := (0:ℤ)) (ylo := 0.87142422) (yhi := 0.87142423)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.223) (q1 := 1.231) (t0 := 5.9375) (t1 := 6)
    (A := 0.40261371) (B := 0.4156537) (X := 2.44222055) (rho := 0.05170166)
    (clo := (-0.76524655)) (chi := (-0.76524653)) (C := (-0.76524654)) (h := 0.05170167)
    (by norm_num) (by norm_num) oscBlock32 vbpBr32.1 vbpBr33.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i33 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.0026852):ℝ) ≤ ∫ v in (vBP 1.231)..(vBP 1.239), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.51979952) (m := (0:ℤ)) (ylo := 0.94900319) (yhi := 0.9490032)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.231) (q1 := 1.239) (t0 := 5.9375) (t1 := 6)
    (A := 0.41565369) (B := 0.42860921) (X := 2.51979952) (rho := 0.05185575)
    (clo := (-0.8128353)) (chi := (-0.81283527)) (C := (-0.81283529)) (h := 0.05185577)
    (by norm_num) (by norm_num) oscBlock33 vbpBr33.1 vbpBr34.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i34 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00288742):ℝ) ≤ ∫ v in (vBP 1.239)..(vBP 1.248), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.60168721) (m := (0:ℤ)) (ylo := 1.03089088) (yhi := 1.03089089)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.239) (q1 := 1.248) (t0 := 5.9375) (t1 := 6)
    (A := 0.4286092) (B := 0.44308455) (X := 2.60168721) (rho := 0.0568201)
    (clo := (-0.85775734)) (chi := (-0.85775729)) (C := (-0.85775732)) (h := 0.05682013)
    (by norm_num) (by norm_num) oscBlock34 vbpBr34.1 vbpBr35.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i35 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00296097):ℝ) ≤ ∫ v in (vBP 1.248)..(vBP 1.258), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.69254615) (m := (0:ℤ)) (ylo := 1.12174982) (yhi := 1.12174983)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.248) (q1 := 1.258) (t0 := 5.9375) (t1 := 6)
    (A := 0.44308453) (B := 0.45904632) (X := 2.69254615) (rho := 0.06173178)
    (clo := (-0.90086153)) (chi := (-0.90086142)) (C := (-0.90086148)) (h := 0.06173184)
    (by norm_num) (by norm_num) oscBlock35 vbpBr35.1 vbpBr36.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i36 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00264753):ℝ) ≤ ∫ v in (vBP 1.258)..(vBP 1.268), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.78743889) (m := (0:ℤ)) (ylo := 1.21664256) (yhi := 1.21664257)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.258) (q1 := 1.268) (t0 := 5.9375) (t1 := 6)
    (A := 0.45904631) (B := 0.47488172) (X := 2.78743889) (rho := 0.06185144)
    (clo := (-0.93794052)) (chi := (-0.93794029)) (C := (-0.93794041)) (h := 0.06185156)
    (by norm_num) (by norm_num) oscBlock36 vbpBr36.1 vbpBr37.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i37 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00261049):ℝ) ≤ ∫ v in (vBP 1.268)..(vBP 1.28), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.89096555) (m := (0:ℤ)) (ylo := 1.32016922) (yhi := 1.32016923)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.268) (q1 := 1.28) (t0 := 5.9375) (t1 := 6)
    (A := 0.4748817) (B := 0.49372017) (X := 2.89096555) (rho := 0.07135548)
    (clo := (-0.96875762)) (chi := (-0.96875707)) (C := (-0.9487008)) (h := 0.05129921)
    (by norm_num) (by norm_num) oscBlock37 vbpBr37.1 vbpBr38.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i38 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00228621):ℝ) ≤ ∫ v in (vBP 1.28)..(vBP 1.294), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.01216089) (m := (0:ℤ)) (ylo := 1.44136456) (yhi := 1.44136457)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.28) (q1 := 1.294) (t0 := 5.9375) (t1 := 6)
    (A := 0.49372014) (B := 0.51547641) (X := 3.01216089) (rho := 0.08069758)
    (clo := (-0.99163678)) (chi := (-0.99163537)) (C := (-0.9554689)) (h := 0.04453111)
    (by norm_num) (by norm_num) oscBlock38 vbpBr38.1 vbpBr39.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i39 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00152768):ℝ) ≤ ∫ v in (vBP 1.294)..(vBP 1.308), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.14131609) (m := (0:ℤ)) (ylo := 1.57051976) (yhi := 1.57051977)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.294) (q1 := 1.308) (t0 := 5.9375) (t1 := 6)
    (A := 0.51547638) (B := 0.53699853) (X := 3.14131609) (rho := 0.0806751)
    (clo := (-1.0000035)) (chi := (-0.9999999)) (C := (-0.9596624)) (h := 0.0403376)
    (by norm_num) (by norm_num) oscBlock39 vbpBr39.1 vbpBr40.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i40 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00099512):ℝ) ≤ ∫ v in (vBP 1.308)..(vBP 1.326), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.28721569) (m := (0:ℤ)) (ylo := 0.14562303) (yhi := 0.14562304)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.308) (q1 := 1.326) (t0 := 5.9375) (t1 := 6)
    (A := 0.53699848) (B := 0.56433382) (X := 3.28721569) (rho := 0.09878724)
    (clo := (-0.9894157)) (chi := (-0.98941568)) (C := (-0.94531422)) (h := 0.05468578)
    (by norm_num) (by norm_num) oscBlock40 vbpBr40.1 vbpBr41.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i41 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00002055):ℝ) ≤ ∫ v in (vBP 1.326)..(vBP 1.345), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.45373003) (m := (0:ℤ)) (ylo := 0.31213737) (yhi := 0.31213738)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.326) (q1 := 1.345) (t0 := 5.9375) (t1 := 6)
    (A := 0.56433374) (B := 0.59278808) (X := 3.45373003) (rho := 0.10299846)
    (clo := (-0.95167938)) (chi := (-0.95167936)) (C := (-0.92434045)) (h := 0.07565955)
    (by norm_num) (by norm_num) oscBlock41 vbpBr41.1 vbpBr42.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i42 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    (0.00079468:ℝ) ≤ ∫ v in (vBP 1.345)..(vBP 1.362), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.61356475) (m := (0:ℤ)) (ylo := 0.47197209) (yhi := 0.4719721)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.345) (q1 := 1.362) (t0 := 5.9375) (t1 := 6)
    (A := 0.59278796) (B := 0.6179085) (X := 3.61356475) (rho := 0.09388626)
    (clo := (-0.89067343)) (chi := (-0.89067341)) (C := (-0.89067342)) (h := 0.09388627)
    (by norm_num) (by norm_num) oscBlock42 vbpBr42.1 vbpBr43.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i43 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    (0.00091619:ℝ) ≤ ∫ v in (vBP 1.362)..(vBP 1.376), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.74950009) (m := (0:ℤ)) (ylo := 0.60790743) (yhi := 0.60790744)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.362) (q1 := 1.376) (t0 := 5.9375) (t1 := 6)
    (A := 0.61790831) (B := 0.6383616) (X := 3.74950009) (rho := 0.08066952)
    (clo := (-0.82084499)) (chi := (-0.82084498)) (C := (-0.82084499)) (h := 0.08066953)
    (by norm_num) (by norm_num) oscBlock43 vbpBr43.1 vbpBr44.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i44 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    (0.00097326:ℝ) ≤ ∫ v in (vBP 1.376)..(vBP 1.39), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.8709582) (m := (0:ℤ)) (ylo := 0.72936554) (yhi := 0.72936555)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.376) (q1 := 1.39) (t0 := 5.9375) (t1 := 6)
    (A := 0.63836133) (B := 0.65860767) (X := 3.8709582) (rho := 0.08068783)
    (clo := (-0.74559737)) (chi := (-0.74559734)) (C := (-0.74559736)) (h := 0.08068785)
    (by norm_num) (by norm_num) oscBlock44 vbpBr44.1 vbpBr45.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i45 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    (0.00091078:ℝ) ≤ ∫ v in (vBP 1.39)..(vBP 1.404), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.99119297) (m := (0:ℤ)) (ylo := 0.84960031) (yhi := 0.84960032)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.39) (q1 := 1.404) (t0 := 5.9375) (t1 := 6)
    (A := 0.65860729) (B := 0.67865086) (X := 3.99119297) (rho := 0.0807122)
    (clo := (-0.66028343)) (chi := (-0.66028336)) (C := (-0.6602834)) (h := 0.08071224)
    (by norm_num) (by norm_num) oscBlock45 vbpBr45.1 vbpBr46.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i46 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    (0.00076101:ℝ) ≤ ∫ v in (vBP 1.404)..(vBP 1.418), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.11022873) (m := (0:ℤ)) (ylo := 0.96863607) (yhi := 0.96863608)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.404) (q1 := 1.418) (t0 := 5.9375) (t1 := 6)
    (A := 0.67865033) (B := 0.69849519) (X := 4.11022873) (rho := 0.08074242)
    (clo := (-0.5664243)) (chi := (-0.56642408)) (C := (-0.56642419)) (h := 0.08074253)
    (by norm_num) (by norm_num) oscBlock46 vbpBr46.1 vbpBr47.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i47 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    (0.00055987:ℝ) ≤ ∫ v in (vBP 1.418)..(vBP 1.432), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.22808922) (m := (0:ℤ)) (ylo := 1.08649656) (yhi := 1.08649657)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.418) (q1 := 1.432) (t0 := 5.9375) (t1 := 6)
    (A := 0.69849446) (B := 0.7181446) (X := 4.22808922) (rho := 0.08077839)
    (clo := (-0.4655894)) (chi := (-0.46558875)) (C := (-0.46558908)) (h := 0.08077872)
    (by norm_num) (by norm_num) oscBlock47 vbpBr47.1 vbpBr48.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i48 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    (0.00034242:ℝ) ≤ ∫ v in (vBP 1.432)..(vBP 1.446), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.34479739) (m := (0:ℤ)) (ylo := 1.20320473) (yhi := 1.20320474)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.432) (q1 := 1.446) (t0 := 5.9375) (t1 := 6)
    (A := 0.7181436) (B := 0.73760286) (X := 4.34479739) (rho := 0.08081978)
    (clo := (-0.3593707)) (chi := (-0.35936893)) (C := (-0.35936982)) (h := 0.08082067)
    (by norm_num) (by norm_num) oscBlock48 vbpBr48.1 vbpBr49.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i49 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    (0.00012596:ℝ) ≤ ∫ v in (vBP 1.446)..(vBP 1.462), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.46858928) (m := (0:ℤ)) (ylo := 1.32699662) (yhi := 1.32699663)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.446) (q1 := 1.462) (t0 := 5.9375) (t1 := 6)
    (A := 0.73760153) (B := 0.75961158) (X := 4.46858928) (rho := 0.08908021)
    (clo := (-0.24139631)) (chi := (-0.24139162)) (C := (-0.24139397)) (h := 0.08908256)
    (by norm_num) (by norm_num) oscBlock49 vbpBr49.1 vbpBr50.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i50 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.0002315):ℝ) ≤ ∫ v in (vBP 1.462)..(vBP 1.478), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.59923381) (m := (0:ℤ)) (ylo := 1.45764115) (yhi := 1.45764116)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.462) (q1 := 1.478) (t0 := 5.9375) (t1 := 6)
    (A := 0.75960973) (B := 0.78138081) (X := 4.59923381) (rho := 0.08905106)
    (clo := (-0.1129256)) (chi := (-0.11291365)) (C := (-0.11291963)) (h := 0.08905704)
    (by norm_num) (by norm_num) oscBlock50 vbpBr50.1 vbpBr51.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i51 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00023444):ℝ) ≤ ∫ v in (vBP 1.478)..(vBP 1.495), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.73247885) (m := (0:ℤ)) (ylo := 0.02008986) (yhi := 0.02008987)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.478) (q1 := 1.495) (t0 := 5.9375) (t1 := 6)
    (A := 0.7813783) (B := 0.80425401) (X := 4.73247885) (rho := 0.09304522)
    (clo := 0.0200885) (chi := 0.02008852) (C := 0.02008851) (h := 0.09304523)
    (by norm_num) (by norm_num) oscBlock51 vbpBr51.1 vbpBr52.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i52 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00047686):ℝ) ≤ ∫ v in (vBP 1.495)..(vBP 1.512), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.86822501) (m := (0:ℤ)) (ylo := 0.15583602) (yhi := 0.15583603)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.495) (q1 := 1.512) (t0 := 5.9375) (t1 := 6)
    (A := 0.80425056) (B := 0.82686872) (X := 4.86822501) (rho := 0.09298732)
    (clo := 0.15520604) (chi := 0.15520606) (C := 0.15520605) (h := 0.09298733)
    (by norm_num) (by norm_num) oscBlock52 vbpBr52.1 vbpBr53.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i53 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00078022):ℝ) ≤ ∫ v in (vBP 1.512)..(vBP 1.531), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.0102883) (m := (0:ℤ)) (ylo := 0.29789931) (yhi := 0.29789932)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.512) (q1 := 1.531) (t0 := 5.9375) (t1 := 6)
    (A := 0.82686405) (B := 0.85184522) (X := 5.0102883) (rho := 0.10078303)
    (clo := 0.29351269) (chi := 0.2935127) (C := 0.29351269) (h := 0.10078304)
    (by norm_num) (by norm_num) oscBlock53 vbpBr53.1 vbpBr54.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i54 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00096445):ℝ) ≤ ∫ v in (vBP 1.531)..(vBP 1.55), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.15843813) (m := (0:ℤ)) (ylo := 0.44604914) (yhi := 0.44604915)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.531) (q1 := 1.55) (t0 := 5.9375) (t1 := 6)
    (A := 0.85183877) (B := 0.87651393) (X := 5.15843813) (rho := 0.10064546)
    (clo := 0.4314046) (chi := 0.43140462) (C := 0.43140461) (h := 0.10064547)
    (by norm_num) (by norm_num) oscBlock54 vbpBr54.1 vbpBr55.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i55 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00116444):ℝ) ≤ ∫ v in (vBP 1.55)..(vBP 1.57), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.308595) (m := (0:ℤ)) (ylo := 0.59620601) (yhi := 0.59620602)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.55) (q1 := 1.57) (t0 := 5.9375) (t1 := 6)
    (A := 0.87650515) (B := 0.90215678) (X := 5.308595) (rho := 0.10434569)
    (clo := 0.5615071) (chi := 0.56150712) (C := 0.56150711) (h := 0.1043457)
    (by norm_num) (by norm_num) oscBlock55 vbpBr55.1 vbpBr56.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i56 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00125455):ℝ) ≤ ∫ v in (vBP 1.57)..(vBP 1.59), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.46066884) (m := (0:ℤ)) (ylo := 0.74827985) (yhi := 0.74827986)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.57) (q1 := 1.59) (t0 := 5.9375) (t1 := 6)
    (A := 0.90214481) (B := 0.92747548) (X := 5.46066884) (rho := 0.10418405)
    (clo := 0.68037913) (chi := 0.68037915) (C := 0.68037914) (h := 0.10418406)
    (by norm_num) (by norm_num) oscBlock56 vbpBr56.1 vbpBr57.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i57 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00129772):ℝ) ≤ ∫ v in (vBP 1.59)..(vBP 1.61), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.61082981) (m := (0:ℤ)) (ylo := 0.89844082) (yhi := 0.89844083)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.59) (q1 := 1.61) (t0 := 5.9375) (t1 := 6)
    (A := 0.92745939) (B := 0.95247825) (X := 5.61082981) (rho := 0.1040397)
    (clo := 0.78235675) (chi := 0.78235677) (C := 0.78235676) (h := 0.10403971)
    (by norm_num) (by norm_num) oscBlock57 vbpBr57.1 vbpBr58.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i58 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.0014634):ℝ) ≤ ∫ v in (vBP 1.61)..(vBP 1.632), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.76648391) (m := (0:ℤ)) (ylo := 1.05409492) (yhi := 1.05409493)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.61) (q1 := 1.632) (t0 := 5.9375) (t1 := 6)
    (A := 0.95245689) (B := 0.97962584) (X := 5.76648391) (rho := 0.11127114)
    (clo := 0.86945346) (chi := 0.86945352) (C := 0.86945349) (h := 0.11127117)
    (by norm_num) (by norm_num) oscBlock58 vbpBr58.1 vbpBr59.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i59 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00149999):ℝ) ≤ ∫ v in (vBP 1.632)..(vBP 1.656), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.93466361) (m := (0:ℤ)) (ylo := 1.22227462) (yhi := 1.22227463)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.632) (q1 := 1.656) (t0 := 5.9375) (t1 := 6)
    (A := 0.97959707) (B := 1.00882827) (X := 5.93466361) (rho := 0.11830602)
    (clo := 0.93987858) (chi := 0.93987882) (C := 0.91078628) (h := 0.08921372)
    (by norm_num) (by norm_num) oscBlock59 vbpBr59.1 vbpBr60.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i60 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00135601):ℝ) ≤ ∫ v in (vBP 1.656)..(vBP 1.68), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.10767843) (m := (0:ℤ)) (ylo := 1.39528944) (yhi := 1.39528945)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.656) (q1 := 1.68) (t0 := 5.9375) (t1 := 6)
    (A := 1.00878907) (B := 1.03761196) (X := 6.10767843) (rho := 0.11799334)
    (clo := 0.98463814) (chi := 0.98463913) (C := 0.9333224) (h := 0.0666776)
    (by norm_num) (by norm_num) oscBlock60 vbpBr60.1 vbpBr61.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i61 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00122808):ℝ) ≤ ∫ v in (vBP 1.68)..(vBP 1.704), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.27822171) (m := (0:ℤ)) (ylo := 1.56583272) (yhi := 1.56583273)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.68) (q1 := 1.704) (t0 := 5.9375) (t1 := 6)
    (A := 1.03755935) (B := 1.06598913) (X := 6.27822171) (rho := 0.11771308)
    (clo := 0.99998762) (chi := 0.99999111) (C := 0.94113727) (h := 0.05886273)
    (by norm_num) (by norm_num) oscBlock61 vbpBr61.1 vbpBr62.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i62 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00137159):ℝ) ≤ ∫ v in (vBP 1.704)..(vBP 1.734), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.46716882) (m := (1:ℤ)) (ylo := 0.18398351) (yhi := 0.18398352)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.704) (q1 := 1.734) (t0 := 5.9375) (t1 := 6)
    (A := 1.06591948) (B := 1.10090679) (X := 6.46716882) (rho := 0.13827193)
    (clo := 0.98312272) (chi := 0.98312273) (C := 0.92242539) (h := 0.07757461)
    (by norm_num) (by norm_num) oscBlock62 vbpBr62.1 vbpBr63.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i63 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00129873):ℝ) ≤ ∫ v in (vBP 1.734)..(vBP 1.766), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.68052006) (m := (1:ℤ)) (ylo := 0.39733475) (yhi := 0.39733476)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.734) (q1 := 1.766) (t0 := 5.9375) (t1 := 6)
    (A := 1.10080961) (B := 1.13749718) (X := 6.68052006) (rho := 0.14446303)
    (clo := 0.92209561) (chi := 0.92209562) (C := 0.88881629) (h := 0.11118371)
    (by norm_num) (by norm_num) oscBlock63 vbpBr63.1 vbpBr64.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i64 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00103142):ℝ) ≤ ∫ v in (vBP 1.766)..(vBP 1.796), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.89016754) (m := (1:ℤ)) (ylo := 0.60698223) (yhi := 0.60698224)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.766) (q1 := 1.796) (t0 := 5.9375) (t1 := 6)
    (A := 1.1373613) (B := 1.17120873) (X := 6.89016754) (rho := 0.13708485)
    (clo := 0.82137305) (chi := 0.82137307) (C := 0.82137306) (h := 0.13708486)
    (by norm_num) (by norm_num) oscBlock64 vbpBr64.1 vbpBr65.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i65 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00087604):ℝ) ≤ ∫ v in (vBP 1.796)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.09616125) (m := (1:ℤ)) (ylo := 0.81297594) (yhi := 0.81297595)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.796) (q1 := 1.828) (t0 := 5.9375) (t1 := 6)
    (A := 1.1710258) (B := 1.20655947) (X := 7.09616125) (rho := 0.14319558)
    (clo := 0.68733994) (chi := 0.68733999) (C := 0.68733996) (h := 0.14319561)
    (by norm_num) (by norm_num) oscBlock65 vbpBr65.1 vbpBr66.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i66 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00064161):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.86), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.30515577) (m := (1:ℤ)) (ylo := 1.02197046) (yhi := 1.02197047)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.828) (q1 := 1.86) (t0 := 5.9375) (t1 := 6)
    (A := 1.20631244) (B := 1.24130524) (X := 7.30515577) (rho := 0.14267568)
    (clo := 0.52168588) (chi := 0.52168624) (C := 0.52168606) (h := 0.14267586)
    (by norm_num) (by norm_num) oscBlock66 vbpBr66.1 vbpBr67.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i67 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00038486):ℝ) ≤ ∫ v in (vBP 1.86)..(vBP 1.89), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.50419981) (m := (1:ℤ)) (ylo := 1.2210145) (yhi := 1.22101451)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.86) (q1 := 1.89) (t0 := 5.9375) (t1 := 6)
    (A := 1.24097685) (B := 1.27334993) (X := 7.50419981) (rho := 0.13589978)
    (clo := 0.34269282) (chi := 0.34269487) (C := 0.34269384) (h := 0.13590081)
    (by norm_num) (by norm_num) oscBlock67 vbpBr67.1 vbpBr68.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i68 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00022892):ℝ) ≤ ∫ v in (vBP 1.89)..(vBP 1.922), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.699961) (m := (1:ℤ)) (ylo := 1.41677569) (yhi := 1.4167757)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.89) (q1 := 1.922) (t0 := 5.9375) (t1 := 6)
    (A := 1.27292668) (B := 1.30698664) (X := 7.699961) (rho := 0.14195885)
    (clo := 0.15341225) (chi := 0.15342125) (C := 0.15341675) (h := 0.14196335)
    (by norm_num) (by norm_num) oscBlock68 vbpBr68.1 vbpBr69.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i69 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00027378):ℝ) ≤ ∫ v in (vBP 1.922)..(vBP 1.969), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 7.9447341) (m := (1:ℤ)) (ylo := 0.09075246) (yhi := 0.09075247)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.922) (q1 := 1.969) (t0 := 5.9375) (t1 := 6)
    (A := 1.30643896) (B := 1.35541448) (X := 7.9447341) (rho := 0.18775279)
    (clo := (-0.09062795)) (chi := (-0.09062793)) (C := (-0.09062794)) (h := 0.1877528)
    (by norm_num) (by norm_num) oscBlock69 vbpBr69.1 vbpBr70.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i70 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.0004866):ℝ) ≤ ∫ v in (vBP 1.969)..(vBP 2.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.22977522) (m := (1:ℤ)) (ylo := 0.37579358) (yhi := 0.37579359)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.969) (q1 := 2.016) (t0 := 5.9375) (t1 := 6)
    (A := 1.35463226) (B := 1.4027369) (X := 8.22977522) (rho := 0.18664619)
    (clo := (-0.36701086)) (chi := (-0.36701084)) (C := (-0.36701085)) (h := 0.1866462)
    (by norm_num) (by norm_num) oscBlock70 vbpBr70.1 vbpBr71.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i71 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00062056):ℝ) ≤ ∫ v in (vBP 2.016)..(vBP 2.062), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.50525521) (m := (1:ℤ)) (ylo := 0.65127357) (yhi := 0.65127358)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.016) (q1 := 2.062) (t0 := 5.9375) (t1 := 6)
    (A := 1.40164597) (B := 1.44803958) (X := 8.50525521) (rho := 0.18298228)
    (clo := (-0.6061998)) (chi := (-0.60619978)) (C := (-0.60619979)) (h := 0.18298229)
    (by norm_num) (by norm_num) oscBlock71 vbpBr71.1 vbpBr72.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB14i72 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.00046598):ℝ) ≤ ∫ v in (vBP 2.062)..(vBP 2.094), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.7314507) (m := (1:ℤ)) (ylo := 0.87746906) (yhi := 0.87746907)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.062) (q1 := 2.094) (t0 := 5.9375) (t1 := 6)
    (A := 1.44655973) (B := 1.47899217) (X := 8.7314507) (rho := 0.14250233)
    (clo := (-0.76912384)) (chi := (-0.76912382)) (C := (-0.76912383)) (h := 0.14250234)
    (by norm_num) (by norm_num) oscBlock72 vbpBr72.1 vbpBr73.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

/-- Lower bound for the oscillatory integral `∫₀^∞ err(v) cos(tv) dv` on the band
`5.9375 ≤ t ≤ 6.0`. -/
theorem oscBandLower14 {t : ℝ} (ht0 : (5.9375:ℝ) ≤ t) (ht1 : t ≤ 6) :
    ((-0.12209272):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosB14i0 ht0 ht1)
    (cosB14i1 ht0 ht1))
    (cosB14i2 ht0 ht1))
    (cosB14i3 ht0 ht1))
    (cosB14i4 ht0 ht1))
    (cosB14i5 ht0 ht1))
    (cosB14i6 ht0 ht1))
    (cosB14i7 ht0 ht1))
    (cosB14i8 ht0 ht1))
    (cosB14i9 ht0 ht1))
    (cosB14i10 ht0 ht1))
    (cosB14i11 ht0 ht1))
    (cosB14i12 ht0 ht1))
    (cosB14i13 ht0 ht1))
    (cosB14i14 ht0 ht1))
    (cosB14i15 ht0 ht1))
    (cosB14i16 ht0 ht1))
    (cosB14i17 ht0 ht1))
    (cosB14i18 ht0 ht1))
    (cosB14i19 ht0 ht1))
    (cosB14i20 ht0 ht1))
    (cosB14i21 ht0 ht1))
    (cosB14i22 ht0 ht1))
    (cosB14i23 ht0 ht1))
    (cosB14i24 ht0 ht1))
    (cosB14i25 ht0 ht1))
    (cosB14i26 ht0 ht1))
    (cosB14i27 ht0 ht1))
    (cosB14i28 ht0 ht1))
    (cosB14i29 ht0 ht1))
    (cosB14i30 ht0 ht1))
    (cosB14i31 ht0 ht1))
    (cosB14i32 ht0 ht1))
    (cosB14i33 ht0 ht1))
    (cosB14i34 ht0 ht1))
    (cosB14i35 ht0 ht1))
    (cosB14i36 ht0 ht1))
    (cosB14i37 ht0 ht1))
    (cosB14i38 ht0 ht1))
    (cosB14i39 ht0 ht1))
    (cosB14i40 ht0 ht1))
    (cosB14i41 ht0 ht1))
    (cosB14i42 ht0 ht1))
    (cosB14i43 ht0 ht1))
    (cosB14i44 ht0 ht1))
    (cosB14i45 ht0 ht1))
    (cosB14i46 ht0 ht1))
    (cosB14i47 ht0 ht1))
    (cosB14i48 ht0 ht1))
    (cosB14i49 ht0 ht1))
    (cosB14i50 ht0 ht1))
    (cosB14i51 ht0 ht1))
    (cosB14i52 ht0 ht1))
    (cosB14i53 ht0 ht1))
    (cosB14i54 ht0 ht1))
    (cosB14i55 ht0 ht1))
    (cosB14i56 ht0 ht1))
    (cosB14i57 ht0 ht1))
    (cosB14i58 ht0 ht1))
    (cosB14i59 ht0 ht1))
    (cosB14i60 ht0 ht1))
    (cosB14i61 ht0 ht1))
    (cosB14i62 ht0 ht1))
    (cosB14i63 ht0 ht1))
    (cosB14i64 ht0 ht1))
    (cosB14i65 ht0 ht1))
    (cosB14i66 ht0 ht1))
    (cosB14i67 ht0 ht1))
    (cosB14i68 ht0 ht1))
    (cosB14i69 ht0 ht1))
    (cosB14i70 ht0 ht1))
    (cosB14i71 ht0 ht1))
    (cosB14i72 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 2.094) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 2.094) (S := 0.013709)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_cut
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
