/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscTail

/-!
# Oscillatory lower bound on the band `6.125 ≤ t ≤ 6.1875`

On each of the 73 blocks the factor `cos(tv)` is bracketed by a rational constant
`C` up to a rational error `h`; the signed contribution `min(C·P₀, C·P₁) - h·S` is
then summed, and the unresolved tail beyond `q = 2.094` is estimated in absolute
value.  The result is the bound `∫₀^∞ err(v) cos(tv) dv ≥ -0.12847188`.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosB11i0 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00641868):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.0038), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.02346795) (m := (0:ℤ)) (ylo := 0.02346795) (yhi := 0.02346795)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1) (q1 := 1.0038) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.0) (B := 0.0075856) (X := 0.02346795) (rho := 0.02346796)
    (clo := 0.99972464) (chi := 0.99972465) (C := 0.98812834) (h := 0.01187166)
    (by norm_num) (by norm_num) oscBlock0 vbpBr0.1 vbpBr1.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i1 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00625872):ℝ) ≤ ∫ v in (vBP 1.0038)..(vBP 1.0078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.07130613) (m := (0:ℤ)) (ylo := 0.07130613) (yhi := 0.07130613)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0038) (q1 := 1.0078) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.00758559) (B := 0.01553948) (X := 0.07130613) (rho := 0.02484441)
    (clo := 0.99745879) (chi := 0.9974588) (C := 0.98630719) (h := 0.01369281)
    (by norm_num) (by norm_num) oscBlock1 vbpBr1.1 vbpBr2.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i2 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.0057677):ℝ) ≤ ∫ v in (vBP 1.0078)..(vBP 1.0118), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.12017472) (m := (0:ℤ)) (ylo := 0.12017472) (yhi := 0.12017472)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0078) (q1 := 1.0118) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.01553947) (B := 0.02346185) (X := 0.12017472) (rho := 0.02499549)
    (clo := 0.9927877) (chi := 0.99278771) (C := 0.9838961) (h := 0.0161039)
    (by norm_num) (by norm_num) oscBlock2 vbpBr2.1 vbpBr3.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i3 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00554846):ℝ) ≤ ∫ v in (vBP 1.0118)..(vBP 1.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.17006823) (m := (0:ℤ)) (ylo := 0.17006823) (yhi := 0.17006823)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0118) (q1 := 1.016) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.02346184) (B := 0.0317467) (X := 0.17006823) (rho := 0.02636448)
    (clo := 0.98557322) (chi := 0.98557323) (C := 0.97960437) (h := 0.02039563)
    (by norm_num) (by norm_num) oscBlock3 vbpBr3.1 vbpBr4.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i4 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00539232):ℝ) ≤ ∫ v in (vBP 1.016)..(vBP 1.0205), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.22278535) (m := (0:ℤ)) (ylo := 0.22278535) (yhi := 0.22278535)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.016) (q1 := 1.0205) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.03174669) (B := 0.04058541) (X := 0.22278535) (rho := 0.02833689)
    (clo := 0.97528581) (chi := 0.97528582) (C := 0.97347446) (h := 0.02652554)
    (by norm_num) (by norm_num) oscBlock4 vbpBr4.1 vbpBr5.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i5 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00480416):ℝ) ≤ ∫ v in (vBP 1.0205)..(vBP 1.025), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.27707834) (m := (0:ℤ)) (ylo := 0.27707834) (yhi := 0.27707834)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0205) (q1 := 1.025) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.0405854) (B := 0.04938523) (X := 0.27707834) (rho := 0.02849278)
    (clo := 0.96185875) (chi := 0.96185876) (C := 0.96185875) (h := 0.02849279)
    (by norm_num) (by norm_num) oscBlock5 vbpBr5.1 vbpBr6.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i6 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00467751):ℝ) ≤ ∫ v in (vBP 1.025)..(vBP 1.03), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.33413734) (m := (0:ℤ)) (ylo := 0.33413734) (yhi := 0.33413734)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.025) (q1 := 1.03) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.04938522) (B := 0.05911761) (X := 0.33413734) (rho := 0.03165288)
    (clo := 0.94469357) (chi := 0.94469358) (C := 0.94469357) (h := 0.03165289)
    (by norm_num) (by norm_num) oscBlock6 vbpBr6.1 vbpBr7.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i7 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00437095):ℝ) ≤ ∫ v in (vBP 1.03)..(vBP 1.0355), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.3968949) (m := (0:ℤ)) (ylo := 0.3968949) (yhi := 0.3968949)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.03) (q1 := 1.0355) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.0591176) (B := 0.06976881) (X := 0.3968949) (rho := 0.03479962)
    (clo := 0.92226573) (chi := 0.92226574) (C := 0.92226573) (h := 0.03479963)
    (by norm_num) (by norm_num) oscBlock7 vbpBr7.1 vbpBr8.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i8 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00390547):ℝ) ≤ ∫ v in (vBP 1.0355)..(vBP 1.0415), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.46526298) (m := (0:ℤ)) (ylo := 0.46526298) (yhi := 0.46526298)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0355) (q1 := 1.0415) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.0697688) (B := 0.08132397) (X := 0.46526298) (rho := 0.0379291)
    (clo := 0.8937036) (chi := 0.89370361) (C := 0.8937036) (h := 0.03792911)
    (by norm_num) (by norm_num) oscBlock8 vbpBr8.1 vbpBr9.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i9 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00330829):ℝ) ≤ ∫ v in (vBP 1.0415)..(vBP 1.048), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.53914684) (m := (0:ℤ)) (ylo := 0.53914684) (yhi := 0.53914684)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0415) (q1 := 1.048) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.08132396) (B := 0.09376718) (X := 0.53914684) (rho := 0.0410376)
    (clo := 0.858147) (chi := 0.85814701) (C := 0.858147) (h := 0.04103761)
    (by norm_num) (by norm_num) oscBlock9 vbpBr9.1 vbpBr10.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i10 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00263254):ℝ) ≤ ∫ v in (vBP 1.048)..(vBP 1.055), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.61844547) (m := (0:ℤ)) (ylo := 0.61844547) (yhi := 0.61844547)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.048) (q1 := 1.055) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.09376717) (B := 0.10708154) (X := 0.61844547) (rho := 0.04412157)
    (clo := 0.8147807) (chi := 0.81478072) (C := 0.81478071) (h := 0.04412158)
    (by norm_num) (by norm_num) oscBlock10 vbpBr10.1 vbpBr11.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i11 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00216812):ℝ) ≤ ∫ v in (vBP 1.055)..(vBP 1.064), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.71178119) (m := (0:ℤ)) (ylo := 0.71178119) (yhi := 0.71178119)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.055) (q1 := 1.064) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.10708153) (B := 0.12407079) (X := 0.71178119) (rho := 0.05590684)
    (clo := 0.75719963) (chi := 0.75719965) (C := 0.75719964) (h := 0.05590685)
    (by norm_num) (by norm_num) oscBlock11 vbpBr11.1 vbpBr12.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i12 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00139279):ℝ) ≤ ∫ v in (vBP 1.064)..(vBP 1.078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.84469426) (m := (0:ℤ)) (ylo := 0.84469426) (yhi := 0.84469426)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.064) (q1 := 1.078) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.12407078) (B := 0.15021495) (X := 0.84469426) (rho := 0.08476075)
    (clo := 0.66395993) (chi := 0.66395999) (C := 0.66395996) (h := 0.08476078)
    (by norm_num) (by norm_num) oscBlock12 vbpBr12.1 vbpBr13.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i13 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    (0.00015574:ℝ) ≤ ∫ v in (vBP 1.078)..(vBP 1.09), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.99325777) (m := (0:ℤ)) (ylo := 0.99325777) (yhi := 0.99325777)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.078) (q1 := 1.09) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.15021494) (B := 0.1723554) (X := 0.99325777) (rho := 0.07319128)
    (clo := 0.54596337) (chi := 0.54596363) (C := 0.5459635) (h := 0.07319141)
    (by norm_num) (by norm_num) oscBlock13 vbpBr13.1 vbpBr14.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i14 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    (0.00062464:ℝ) ≤ ∫ v in (vBP 1.09)..(vBP 1.1), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.11757012) (m := (0:ℤ)) (ylo := 1.11757012) (yhi := 1.11757012)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.09) (q1 := 1.1) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.17235539) (B := 0.19062036) (X := 1.11757012) (rho := 0.06189337)
    (clo := 0.43786828) (chi := 0.43786913) (C := 0.4378687) (h := 0.0618938)
    (by norm_num) (by norm_num) oscBlock14 vbpBr14.1 vbpBr15.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i15 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    (0.00065728:ℝ) ≤ ∫ v in (vBP 1.1)..(vBP 1.109), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.22392559) (m := (0:ℤ)) (ylo := 1.22392559) (yhi := 1.22392559)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.1) (q1 := 1.109) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.19062035) (B := 0.20691742) (X := 1.22392559) (rho := 0.05637596)
    (clo := 0.33995656) (chi := 0.33995865) (C := 0.3399576) (h := 0.05637701)
    (by norm_num) (by norm_num) oscBlock15 vbpBr15.1 vbpBr16.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i16 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    (0.00050711:ℝ) ≤ ∫ v in (vBP 1.109)..(vBP 1.117), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.31830994) (m := (0:ℤ)) (ylo := 1.31830994) (yhi := 1.31830994)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.109) (q1 := 1.117) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.20691741) (B := 0.22129305) (X := 1.31830994) (rho := 0.05094082)
    (clo := 0.24981222) (chi := 0.2498166) (C := 0.24981441) (h := 0.05094301)
    (by norm_num) (by norm_num) oscBlock16 vbpBr16.1 vbpBr17.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i17 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    (0.00031021:ℝ) ≤ ∫ v in (vBP 1.117)..(vBP 1.124), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.40099004) (m := (0:ℤ)) (ylo := 1.40099004) (yhi := 1.40099004)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.117) (q1 := 1.124) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.22129304) (B := 0.23378751) (X := 1.40099004) (rho := 0.04557019)
    (clo := 0.1689913) (chi := 0.16899934) (C := 0.16899532) (h := 0.04557421)
    (by norm_num) (by norm_num) oscBlock17 vbpBr17.1 vbpBr18.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i18 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    (0.00011806:ℝ) ≤ ∫ v in (vBP 1.124)..(vBP 1.131), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.47766908) (m := (0:ℤ)) (ylo := 1.47766908) (yhi := 1.47766908)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.124) (q1 := 1.131) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.2337875) (B := 0.2462044) (X := 1.47766908) (rho := 0.04572066)
    (clo := 0.09299247) (chi := 0.09300615) (C := 0.09299931) (h := 0.0457275)
    (by norm_num) (by norm_num) oscBlock18 vbpBr18.1 vbpBr19.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i19 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00011198):ℝ) ≤ ∫ v in (vBP 1.131)..(vBP 1.138), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.55387354) (m := (0:ℤ)) (ylo := 1.55387354) (yhi := 1.55387354)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.131) (q1 := 1.138) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.24620439) (B := 0.25854468) (X := 1.55387354) (rho := 0.04587167)
    (clo := 0.01692157) (chi := 0.01694419) (C := 0.01693288) (h := 0.04588298)
    (by norm_num) (by norm_num) oscBlock19 vbpBr19.1 vbpBr20.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i20 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00039024):ℝ) ≤ ∫ v in (vBP 1.138)..(vBP 1.145), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.62960926) (m := (0:ℤ)) (ylo := 0.05881293) (yhi := 0.05881294)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.138) (q1 := 1.145) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.25854467) (B := 0.27080928) (X := 1.62960926) (rho := 0.04602317)
    (clo := (-0.05877905)) (chi := (-0.05877903)) (C := (-0.05877904)) (h := 0.04602318)
    (by norm_num) (by norm_num) oscBlock20 vbpBr20.1 vbpBr21.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i21 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.0006889):ℝ) ≤ ∫ v in (vBP 1.145)..(vBP 1.152), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.70488194) (m := (0:ℤ)) (ylo := 0.13408561) (yhi := 0.13408562)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.145) (q1 := 1.152) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.27080927) (B := 0.28299913) (X := 1.70488194) (rho := 0.04617518)
    (clo := (-0.1336842)) (chi := (-0.13368418)) (C := (-0.13368419)) (h := 0.04617519)
    (by norm_num) (by norm_num) oscBlock21 vbpBr21.1 vbpBr22.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i22 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00098991):ℝ) ≤ ∫ v in (vBP 1.152)..(vBP 1.159), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.77969723) (m := (0:ℤ)) (ylo := 0.2089009) (yhi := 0.20890091)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.152) (q1 := 1.159) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.28299912) (B := 0.29511513) (X := 1.77969723) (rho := 0.04632764)
    (clo := (-0.20738484)) (chi := (-0.20738482)) (C := (-0.20738483)) (h := 0.04632765)
    (by norm_num) (by norm_num) oscBlock22 vbpBr22.1 vbpBr23.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i23 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00128269):ℝ) ≤ ∫ v in (vBP 1.159)..(vBP 1.166), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.85406067) (m := (0:ℤ)) (ylo := 0.28326434) (yhi := 0.28326435)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.159) (q1 := 1.166) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.29511512) (B := 0.30715818) (X := 1.85406067) (rho := 0.04648058)
    (clo := (-0.2794914)) (chi := (-0.27949138)) (C := (-0.27949139)) (h := 0.04648059)
    (by norm_num) (by norm_num) oscBlock23 vbpBr23.1 vbpBr24.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i24 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00155844):ℝ) ≤ ∫ v in (vBP 1.166)..(vBP 1.173), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.92797767) (m := (0:ℤ)) (ylo := 0.35718134) (yhi := 0.35718135)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.166) (q1 := 1.173) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.30715817) (B := 0.31912914) (X := 1.92797767) (rho := 0.0466339)
    (clo := (-0.34963488)) (chi := (-0.34963486)) (C := (-0.34963487)) (h := 0.04663391)
    (by norm_num) (by norm_num) oscBlock24 vbpBr24.1 vbpBr25.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i25 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00180959):ℝ) ≤ ∫ v in (vBP 1.173)..(vBP 1.18), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.00145355) (m := (0:ℤ)) (ylo := 0.43065722) (yhi := 0.43065723)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.173) (q1 := 1.18) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.31912913) (B := 0.33102888) (X := 2.00145355) (rho := 0.04678765)
    (clo := (-0.41746812)) (chi := (-0.4174681)) (C := (-0.41746811)) (h := 0.04678766)
    (by norm_num) (by norm_num) oscBlock25 vbpBr25.1 vbpBr26.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i26 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00202987):ℝ) ≤ ∫ v in (vBP 1.18)..(vBP 1.187), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.07449359) (m := (0:ℤ)) (ylo := 0.50369726) (yhi := 0.50369727)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.18) (q1 := 1.187) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.33102887) (B := 0.34285824) (X := 2.07449359) (rho := 0.04694178)
    (clo := (-0.48266692)) (chi := (-0.4826669)) (C := (-0.48266691)) (h := 0.04694179)
    (by norm_num) (by norm_num) oscBlock26 vbpBr26.1 vbpBr27.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i27 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00221439):ℝ) ≤ ∫ v in (vBP 1.187)..(vBP 1.194), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.14710289) (m := (0:ℤ)) (ylo := 0.57630656) (yhi := 0.57630657)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.187) (q1 := 1.194) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.34285823) (B := 0.35461804) (X := 2.14710289) (rho := 0.04709625)
    (clo := (-0.54493079)) (chi := (-0.54493078)) (C := (-0.54493079)) (h := 0.04709626)
    (by norm_num) (by norm_num) oscBlock27 vbpBr27.1 vbpBr28.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i28 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00238378):ℝ) ≤ ∫ v in (vBP 1.194)..(vBP 1.201), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.21928643) (m := (0:ℤ)) (ylo := 0.6484901) (yhi := 0.64849011)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.194) (q1 := 1.201) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.35461802) (B := 0.36630909) (X := 2.21928643) (rho := 0.04725108)
    (clo := (-0.60398372)) (chi := (-0.6039837)) (C := (-0.60398371)) (h := 0.04725109)
    (by norm_num) (by norm_num) oscBlock28 vbpBr28.1 vbpBr29.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i29 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.002489):ℝ) ≤ ∫ v in (vBP 1.201)..(vBP 1.208), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.2910493) (m := (0:ℤ)) (ylo := 0.72025297) (yhi := 0.72025298)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.201) (q1 := 1.208) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.36630908) (B := 0.3779322) (X := 2.2910493) (rho := 0.0474062)
    (clo := (-0.65957485)) (chi := (-0.65957483)) (C := (-0.65957484)) (h := 0.04740621)
    (by norm_num) (by norm_num) oscBlock29 vbpBr29.1 vbpBr30.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i30 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00255137):ℝ) ≤ ∫ v in (vBP 1.208)..(vBP 1.215), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.36239632) (m := (0:ℤ)) (ylo := 0.79159999) (yhi := 0.7916)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.208) (q1 := 1.215) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.37793219) (B := 0.38948816) (X := 2.36239632) (rho := 0.04756168)
    (clo := (-0.71147852)) (chi := (-0.7114785)) (C := (-0.71147851)) (h := 0.04756169)
    (by norm_num) (by norm_num) oscBlock30 vbpBr30.1 vbpBr31.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i31 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00295628):ℝ) ≤ ∫ v in (vBP 1.215)..(vBP 1.223), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.43839365) (m := (0:ℤ)) (ylo := 0.86759732) (yhi := 0.86759733)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.215) (q1 := 1.223) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.38948815) (B := 0.40261372) (X := 2.43839365) (rho := 0.05277875)
    (clo := (-0.76277744)) (chi := (-0.76277742)) (C := (-0.76277743)) (h := 0.05277876)
    (by norm_num) (by norm_num) oscBlock31 vbpBr31.1 vbpBr32.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i32 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00291903):ℝ) ≤ ∫ v in (vBP 1.223)..(vBP 1.231), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.51893312) (m := (0:ℤ)) (ylo := 0.94813679) (yhi := 0.9481368)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.223) (q1 := 1.231) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.40261371) (B := 0.4156537) (X := 2.51893312) (rho := 0.05292416)
    (clo := (-0.81233032)) (chi := (-0.81233029)) (C := (-0.81233031)) (h := 0.05292418)
    (by norm_num) (by norm_num) oscBlock32 vbpBr32.1 vbpBr33.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i33 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00282409):ℝ) ≤ ∫ v in (vBP 1.231)..(vBP 1.239), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.59894916) (m := (0:ℤ)) (ylo := 1.02815283) (yhi := 1.02815284)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.231) (q1 := 1.239) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.41565369) (B := 0.42860921) (X := 2.59894916) (rho := 0.05307033)
    (clo := (-0.85634661)) (chi := (-0.85634656)) (C := (-0.85634659)) (h := 0.05307036)
    (by norm_num) (by norm_num) oscBlock33 vbpBr33.1 vbpBr34.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i34 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00301514):ℝ) ≤ ∫ v in (vBP 1.239)..(vBP 1.248), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.6834085) (m := (0:ℤ)) (ylo := 1.11261217) (yhi := 1.11261218)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.239) (q1 := 1.248) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.4286092) (B := 0.44308455) (X := 2.6834085) (rho := 0.05817717)
    (clo := (-0.89685725)) (chi := (-0.89685715)) (C := (-0.8968572)) (h := 0.05817722)
    (by norm_num) (by norm_num) oscBlock34 vbpBr34.1 vbpBr35.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i35 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00306847):ℝ) ≤ ∫ v in (vBP 1.248)..(vBP 1.258), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.77712092) (m := (0:ℤ)) (ylo := 1.20632459) (yhi := 1.2063246)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.248) (q1 := 1.258) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.44308453) (B := 0.45904632) (X := 2.77712092) (rho := 0.06322819)
    (clo := (-0.9343124)) (chi := (-0.93431219)) (C := (-0.9343123)) (h := 0.0632283)
    (by norm_num) (by norm_num) oscBlock35 vbpBr35.1 vbpBr36.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i36 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00264809):ℝ) ≤ ∫ v in (vBP 1.258)..(vBP 1.268), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.87499464) (m := (0:ℤ)) (ylo := 1.30419831) (yhi := 1.30419832)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.258) (q1 := 1.268) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.45904631) (B := 0.47488172) (X := 2.87499464) (rho := 0.06333601)
    (clo := (-0.9646732)) (chi := (-0.96467272)) (C := (-0.95066836)) (h := 0.04933165)
    (by norm_num) (by norm_num) oscBlock36 vbpBr36.1 vbpBr37.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i37 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00261048):ℝ) ≤ ∫ v in (vBP 1.268)..(vBP 1.28), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.98177198) (m := (0:ℤ)) (ylo := 1.41097565) (yhi := 1.41097566)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.268) (q1 := 1.28) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.4748817) (B := 0.49372017) (X := 2.98177198) (rho := 0.07312158)
    (clo := (-0.98725694)) (chi := (-0.98725582)) (C := (-0.95706712)) (h := 0.04293288)
    (by norm_num) (by norm_num) oscBlock37 vbpBr37.1 vbpBr38.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i38 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.0022862):ℝ) ≤ ∫ v in (vBP 1.28)..(vBP 1.294), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.10677307) (m := (0:ℤ)) (ylo := 1.53597674) (yhi := 1.53597675)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.28) (q1 := 1.294) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.49372014) (B := 0.51547641) (X := 3.10677307) (rho := 0.08273723)
    (clo := (-0.99939664)) (chi := (-0.99939381)) (C := (-0.95832829)) (h := 0.04167171)
    (by norm_num) (by norm_num) oscBlock38 vbpBr38.1 vbpBr39.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i39 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00152769):ℝ) ≤ ∫ v in (vBP 1.294)..(vBP 1.308), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.23998561) (m := (0:ℤ)) (ylo := 0.09839295) (yhi := 0.09839296)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.294) (q1 := 1.308) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.51547638) (B := 0.53699853) (X := 3.23998561) (rho := 0.0826928)
    (clo := (-0.99516332)) (chi := (-0.99516331)) (C := (-0.95623526)) (h := 0.04376475)
    (by norm_num) (by norm_num) oscBlock39 vbpBr39.1 vbpBr40.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i40 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00099629):ℝ) ≤ ∫ v in (vBP 1.308)..(vBP 1.326), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.3904656) (m := (0:ℤ)) (ylo := 0.24887294) (yhi := 0.24887295)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.308) (q1 := 1.326) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.53699848) (B := 0.56433382) (X := 3.3904656) (rho := 0.10134993)
    (clo := (-0.96919065)) (chi := (-0.96919064)) (C := (-0.93392036)) (h := 0.06607965)
    (by norm_num) (by norm_num) oscBlock40 vbpBr40.1 vbpBr41.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i41 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00005749):ℝ) ≤ ∫ v in (vBP 1.326)..(vBP 1.345), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.5622102) (m := (0:ℤ)) (ylo := 0.42061754) (yhi := 0.42061755)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.326) (q1 := 1.345) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.56433374) (B := 0.59278808) (X := 3.5622102) (rho := 0.10566606)
    (clo := (-0.91283696)) (chi := (-0.91283695)) (C := (-0.90358545)) (h := 0.09641456)
    (by norm_num) (by norm_num) oscBlock41 vbpBr41.1 vbpBr42.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i42 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    (0.00072705:ℝ) ≤ ∫ v in (vBP 1.345)..(vBP 1.362), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.72706754) (m := (0:ℤ)) (ylo := 0.58547488) (yhi := 0.58547489)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.345) (q1 := 1.362) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.59278796) (B := 0.6179085) (X := 3.72706754) (rho := 0.09624131)
    (clo := (-0.83344977)) (chi := (-0.83344975)) (C := (-0.83344976)) (h := 0.09624132)
    (by norm_num) (by norm_num) oscBlock42 vbpBr42.1 vbpBr43.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i43 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    (0.0008171:ℝ) ≤ ∫ v in (vBP 1.362)..(vBP 1.376), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.86727539) (m := (0:ℤ)) (ylo := 0.72568273) (yhi := 0.72568274)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.362) (q1 := 1.376) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.61790831) (B := 0.6383616) (X := 3.86727539) (rho := 0.08258702)
    (clo := (-0.74804652)) (chi := (-0.74804649)) (C := (-0.74804651)) (h := 0.08258704)
    (by norm_num) (by norm_num) oscBlock43 vbpBr43.1 vbpBr44.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i44 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    (0.00083633:ℝ) ≤ ∫ v in (vBP 1.376)..(vBP 1.39), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.99254905) (m := (0:ℤ)) (ylo := 0.85095639) (yhi := 0.8509564)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.376) (q1 := 1.39) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.63836133) (B := 0.65860767) (X := 3.99254905) (rho := 0.08258592)
    (clo := (-0.65926439)) (chi := (-0.65926431)) (C := (-0.65926435)) (h := 0.08258596)
    (by norm_num) (by norm_num) oscBlock44 vbpBr44.1 vbpBr45.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i45 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    (0.00074275:ℝ) ≤ ∫ v in (vBP 1.39)..(vBP 1.404), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.11656092) (m := (0:ℤ)) (ylo := 0.97496826) (yhi := 0.97496827)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.39) (q1 := 1.404) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.65860729) (B := 0.67865086) (X := 4.11656092) (rho := 0.08259129)
    (clo := (-0.56119454)) (chi := (-0.56119431)) (C := (-0.56119443)) (h := 0.08259141)
    (by norm_num) (by norm_num) oscBlock45 vbpBr45.1 vbpBr46.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i46 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    (0.00057268:ℝ) ≤ ∫ v in (vBP 1.404)..(vBP 1.418), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.23933612) (m := (0:ℤ)) (ylo := 1.09774346) (yhi := 1.09774347)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.404) (q1 := 1.418) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.67865033) (B := 0.69849519) (X := 4.23933612) (rho := 0.08260287)
    (clo := (-0.45560671)) (chi := (-0.45560599)) (C := (-0.45560635)) (h := 0.08260323)
    (by norm_num) (by norm_num) oscBlock46 vbpBr46.1 vbpBr47.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i47 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    (0.00036465:ℝ) ≤ ∫ v in (vBP 1.418)..(vBP 1.432), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.36089914) (m := (0:ℤ)) (ylo := 1.21930648) (yhi := 1.21930649)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.418) (q1 := 1.432) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.69849446) (B := 0.7181446) (X := 4.36089914) (rho := 0.08262059)
    (clo := (-0.34429893)) (chi := (-0.34429691)) (C := (-0.34429792)) (h := 0.0826216)
    (by norm_num) (by norm_num) oscBlock47 vbpBr47.1 vbpBr48.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i48 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    (0.00015477:ℝ) ≤ ∫ v in (vBP 1.432)..(vBP 1.446), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.48127362) (m := (0:ℤ)) (ylo := 1.33968096) (yhi := 1.33968097)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.432) (q1 := 1.446) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.7181436) (B := 0.73760286) (X := 4.48127362) (rho := 0.08264409)
    (clo := (-0.22906844)) (chi := (-0.22906329)) (C := (-0.22906587)) (h := 0.08264667)
    (by norm_num) (by norm_num) oscBlock48 vbpBr48.1 vbpBr49.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i49 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00006211):ℝ) ≤ ∫ v in (vBP 1.446)..(vBP 1.462), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.60895301) (m := (0:ℤ)) (ylo := 1.46736035) (yhi := 1.46736036)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.446) (q1 := 1.462) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.73760153) (B := 0.75961158) (X := 4.60895301) (rho := 0.09114365)
    (clo := (-0.10326418)) (chi := (-0.10325141)) (C := (-0.1032578)) (h := 0.09115004)
    (by norm_num) (by norm_num) oscBlock49 vbpBr49.1 vbpBr50.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i50 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00025693):ℝ) ≤ ∫ v in (vBP 1.462)..(vBP 1.478), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.74370167) (m := (0:ℤ)) (ylo := 0.03131268) (yhi := 0.03131269)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.462) (q1 := 1.478) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.75960973) (B := 0.78138081) (X := 4.74370167) (rho := 0.0910921)
    (clo := 0.03130756) (chi := 0.03130758) (C := 0.03130757) (h := 0.09109211)
    (by norm_num) (by norm_num) oscBlock50 vbpBr50.1 vbpBr51.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i51 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00054528):ℝ) ≤ ∫ v in (vBP 1.478)..(vBP 1.495), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.88113188) (m := (0:ℤ)) (ylo := 0.16874289) (yhi := 0.1687429)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.478) (q1 := 1.495) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.7813783) (B := 0.80425401) (X := 4.88113188) (rho := 0.09518981)
    (clo := 0.16794322) (chi := 0.16794324) (C := 0.16794323) (h := 0.09518982)
    (by norm_num) (by norm_num) oscBlock51 vbpBr51.1 vbpBr52.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i52 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00076657):ℝ) ≤ ∫ v in (vBP 1.495)..(vBP 1.512), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.02114244) (m := (0:ℤ)) (ylo := 0.30875345) (yhi := 0.30875346)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.495) (q1 := 1.512) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.80425056) (B := 0.82686872) (X := 5.02114244) (rho := 0.09510778)
    (clo := 0.30387126) (chi := 0.30387128) (C := 0.30387127) (h := 0.09510779)
    (by norm_num) (by norm_num) oscBlock52 vbpBr52.1 vbpBr53.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i53 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00107415):ℝ) ≤ ∫ v in (vBP 1.512)..(vBP 1.531), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.1676673) (m := (0:ℤ)) (ylo := 0.45527831) (yhi := 0.45527832)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.512) (q1 := 1.531) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.82686405) (B := 0.85184522) (X := 5.1676673) (rho := 0.10312501)
    (clo := 0.43971229) (chi := 0.43971231) (C := 0.4397123) (h := 0.10312502)
    (by norm_num) (by norm_num) oscBlock53 vbpBr53.1 vbpBr54.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i54 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00122222):ℝ) ≤ ∫ v in (vBP 1.531)..(vBP 1.55), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.3204712) (m := (0:ℤ)) (ylo := 0.60808221) (yhi := 0.60808222)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.531) (q1 := 1.55) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.85183877) (B := 0.87651393) (X := 5.3204712) (rho := 0.10295875)
    (clo := 0.57129449) (chi := 0.57129451) (C := 0.5712945) (h := 0.10295876)
    (by norm_num) (by norm_num) oscBlock54 vbpBr54.1 vbpBr55.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i55 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.0013952):ℝ) ≤ ∫ v in (vBP 1.55)..(vBP 1.57), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.47534456) (m := (0:ℤ)) (ylo := 0.76295557) (yhi := 0.76295558)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.55) (q1 := 1.57) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.87650515) (B := 0.90215678) (X := 5.47534456) (rho := 0.10675053)
    (clo := 0.69106073) (chi := 0.69106075) (C := 0.69106074) (h := 0.10675054)
    (by norm_num) (by norm_num) oscBlock55 vbpBr55.1 vbpBr56.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i56 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.0014424):ℝ) ≤ ∫ v in (vBP 1.57)..(vBP 1.59), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.63219574) (m := (0:ℤ)) (ylo := 0.91980675) (yhi := 0.91980676)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.57) (q1 := 1.59) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.90214481) (B := 0.92747548) (X := 5.63219574) (rho := 0.1065588)
    (clo := 0.79548453) (chi := 0.79548455) (C := 0.79548454) (h := 0.10655881)
    (by norm_num) (by norm_num) oscBlock56 vbpBr56.1 vbpBr57.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i57 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00144329):ℝ) ≤ ∫ v in (vBP 1.59)..(vBP 1.61), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.78707396) (m := (0:ℤ)) (ylo := 1.07468497) (yhi := 1.07468498)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.59) (q1 := 1.61) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.92745939) (B := 0.95247825) (X := 5.78707396) (rho := 0.10638522)
    (clo := 0.87944023) (chi := 0.8794403) (C := 0.87944026) (h := 0.10638526)
    (by norm_num) (by norm_num) oscBlock57 vbpBr57.1 vbpBr58.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i58 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00149216):ℝ) ≤ ∫ v in (vBP 1.61)..(vBP 1.632), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.94761666) (m := (0:ℤ)) (ylo := 1.23522767) (yhi := 1.23522768)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.61) (q1 := 1.632) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.95245689) (B := 0.97962584) (X := 5.94761666) (rho := 0.11381823)
    (clo := 0.94422319) (chi := 0.94422346) (C := 0.91520248) (h := 0.08479752)
    (by norm_num) (by norm_num) oscBlock58 vbpBr58.1 vbpBr59.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i59 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00149999):ℝ) ≤ ∫ v in (vBP 1.632)..(vBP 1.656), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.12107848) (m := (0:ℤ)) (ylo := 1.40868949) (yhi := 1.4086895)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.632) (q1 := 1.656) (t0 := 6.125) (t1 := 6.1875)
    (A := 0.97959707) (B := 1.00882827) (X := 6.12107848) (rho := 0.12104645)
    (clo := 0.98688942) (chi := 0.98689051) (C := 0.93292148) (h := 0.06707852)
    (by norm_num) (by norm_num) oscBlock59 vbpBr59.1 vbpBr60.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i60 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00135601):ℝ) ≤ ∫ v in (vBP 1.656)..(vBP 1.68), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.29952852) (m := (1:ℤ)) (ylo := 0.01634321) (yhi := 0.01634322)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.656) (q1 := 1.68) (t0 := 6.125) (t1 := 6.1875)
    (A := 1.00878907) (B := 1.03761196) (X := 6.29952852) (rho := 0.12069549)
    (clo := 0.99986645) (chi := 0.99986646) (C := 0.93958548) (h := 0.06041452)
    (by norm_num) (by norm_num) oscBlock60 vbpBr60.1 vbpBr61.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i61 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00122808):ℝ) ≤ ∫ v in (vBP 1.68)..(vBP 1.704), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.47542938) (m := (1:ℤ)) (ylo := 0.19224407) (yhi := 0.19224408)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.68) (q1 := 1.704) (t0 := 6.125) (t1 := 6.1875)
    (A := 1.03755935) (B := 1.06598913) (X := 6.47542938) (rho := 0.12037838)
    (clo := 0.98157794) (chi := 0.98157796) (C := 0.93059978) (h := 0.06940022)
    (by norm_num) (by norm_num) oscBlock61 vbpBr61.1 vbpBr62.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i62 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00137159):ℝ) ≤ ∫ v in (vBP 1.704)..(vBP 1.734), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.67030878) (m := (1:ℤ)) (ylo := 0.38712347) (yhi := 0.38712348)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.704) (q1 := 1.734) (t0 := 6.125) (t1 := 6.1875)
    (A := 1.06591948) (B := 1.10090679) (X := 6.67030878) (rho := 0.14155199)
    (clo := 0.92599885) (chi := 0.92599886) (C := 0.89222343) (h := 0.10777657)
    (by norm_num) (by norm_num) oscBlock62 vbpBr62.1 vbpBr63.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i63 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00125869):ℝ) ≤ ∫ v in (vBP 1.734)..(vBP 1.766), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.89036133) (m := (1:ℤ)) (ylo := 0.60717602) (yhi := 0.60717603)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.734) (q1 := 1.766) (t0 := 6.125) (t1 := 6.1875)
    (A := 1.10080961) (B := 1.13749718) (X := 6.89036133) (rho := 0.14790248)
    (clo := 0.8212625) (chi := 0.82126252) (C := 0.82126251) (h := 0.14790249)
    (by norm_num) (by norm_num) oscBlock63 vbpBr63.1 vbpBr64.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i64 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.0008824):ℝ) ≤ ∫ v in (vBP 1.766)..(vBP 1.796), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.10659598) (m := (1:ℤ)) (ylo := 0.82341067) (yhi := 0.82341068)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.766) (q1 := 1.796) (t0 := 6.125) (t1 := 6.1875)
    (A := 1.1373613) (B := 1.17120873) (X := 7.10659598) (rho := 0.14025804)
    (clo := 0.67972353) (chi := 0.67972359) (C := 0.67972356) (h := 0.14025807)
    (by norm_num) (by norm_num) oscBlock64 vbpBr64.1 vbpBr65.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i65 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00069226):ℝ) ≤ ∫ v in (vBP 1.796)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.31905987) (m := (1:ℤ)) (ylo := 1.03587456) (yhi := 1.03587457)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.796) (q1 := 1.828) (t0 := 6.125) (t1 := 6.1875)
    (A := 1.1710258) (B := 1.20655947) (X := 7.31905987) (rho := 0.14652686)
    (clo := 0.50977372) (chi := 0.50977413) (C := 0.50977392) (h := 0.14652707)
    (by norm_num) (by norm_num) oscBlock65 vbpBr65.1 vbpBr66.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i66 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00044417):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.86), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.53461993) (m := (1:ℤ)) (ylo := 1.25143462) (yhi := 1.25143463)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.828) (q1 := 1.86) (t0 := 6.125) (t1 := 6.1875)
    (A := 1.20631244) (B := 1.24130524) (X := 7.53461993) (rho := 0.14595625)
    (clo := 0.31396056) (chi := 0.31396318) (C := 0.31396187) (h := 0.14595756)
    (by norm_num) (by norm_num) oscBlock66 vbpBr66.1 vbpBr67.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i67 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00020326):ℝ) ≤ ∫ v in (vBP 1.86)..(vBP 1.89), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.73991794) (m := (1:ℤ)) (ylo := 1.45673263) (yhi := 1.45673264)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.86) (q1 := 1.89) (t0 := 6.125) (t1 := 6.1875)
    (A := 1.24097685) (B := 1.27334993) (X := 7.73991794) (rho := 0.13893476)
    (clo := 0.11381632) (chi := 0.11382819) (C := 0.11382225) (h := 0.1389407)
    (by norm_num) (by norm_num) oscBlock67 vbpBr67.1 vbpBr68.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i68 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00017482):ℝ) ≤ ∫ v in (vBP 1.89)..(vBP 1.922), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 7.94182787) (m := (1:ℤ)) (ylo := 0.08784623) (yhi := 0.08784624)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.89) (q1 := 1.922) (t0 := 6.125) (t1 := 6.1875)
    (A := 1.27292668) (B := 1.30698664) (X := 7.94182787) (rho := 0.14515197)
    (clo := (-0.0877333)) (chi := (-0.08773328)) (C := (-0.08773329)) (h := 0.14515198)
    (by norm_num) (by norm_num) oscBlock68 vbpBr68.1 vbpBr69.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i69 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00051239):ℝ) ≤ ∫ v in (vBP 1.922)..(vBP 1.969), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.19428286) (m := (1:ℤ)) (ylo := 0.34030122) (yhi := 0.34030123)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.922) (q1 := 1.969) (t0 := 6.125) (t1 := 6.1875)
    (A := 1.30643896) (B := 1.35541448) (X := 8.19428286) (rho := 0.19234425)
    (clo := (-0.33377107)) (chi := (-0.33377105)) (C := (-0.33377106)) (h := 0.19234426)
    (by norm_num) (by norm_num) oscBlock69 vbpBr69.1 vbpBr70.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i70 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00068883):ℝ) ≤ ∫ v in (vBP 1.969)..(vBP 2.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.48827858) (m := (1:ℤ)) (ylo := 0.63429694) (yhi := 0.63429695)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.969) (q1 := 2.016) (t0 := 6.125) (t1 := 6.1875)
    (A := 1.35463226) (B := 1.4027369) (X := 8.48827858) (rho := 0.191156)
    (clo := (-0.59261137)) (chi := (-0.59261135)) (C := (-0.59261136)) (h := 0.19115601)
    (by norm_num) (by norm_num) oscBlock70 vbpBr70.1 vbpBr71.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i71 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00077217):ℝ) ≤ ∫ v in (vBP 2.016)..(vBP 2.062), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.77241323) (m := (1:ℤ)) (ylo := 0.91843159) (yhi := 0.9184316)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.016) (q1 := 2.062) (t0 := 6.125) (t1 := 6.1875)
    (A := 1.40164597) (B := 1.44803958) (X := 8.77241323) (rho := 0.18733168)
    (clo := (-0.79465049)) (chi := (-0.79465046)) (C := (-0.79465048)) (h := 0.1873317)
    (by norm_num) (by norm_num) oscBlock71 vbpBr71.1 vbpBr72.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB11i72 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.00051116):ℝ) ≤ ∫ v in (vBP 2.062)..(vBP 2.094), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 9.00572119) (m := (1:ℤ)) (ylo := 1.15173955) (yhi := 1.15173956)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.062) (q1 := 2.094) (t0 := 6.125) (t1 := 6.1875)
    (A := 1.44655973) (B := 1.47899217) (X := 9.00572119) (rho := 0.14554287)
    (clo := (-0.91347327)) (chi := (-0.91347314)) (C := (-0.88396514)) (h := 0.11603487)
    (by norm_num) (by norm_num) oscBlock72 vbpBr72.1 vbpBr73.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

/-- Lower bound for the oscillatory integral `∫₀^∞ err(v) cos(tv) dv` on the band
`6.125 ≤ t ≤ 6.1875`. -/
theorem oscBandLower11 {t : ℝ} (ht0 : (6.125:ℝ) ≤ t) (ht1 : t ≤ 6.1875) :
    ((-0.12847188):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosB11i0 ht0 ht1)
    (cosB11i1 ht0 ht1))
    (cosB11i2 ht0 ht1))
    (cosB11i3 ht0 ht1))
    (cosB11i4 ht0 ht1))
    (cosB11i5 ht0 ht1))
    (cosB11i6 ht0 ht1))
    (cosB11i7 ht0 ht1))
    (cosB11i8 ht0 ht1))
    (cosB11i9 ht0 ht1))
    (cosB11i10 ht0 ht1))
    (cosB11i11 ht0 ht1))
    (cosB11i12 ht0 ht1))
    (cosB11i13 ht0 ht1))
    (cosB11i14 ht0 ht1))
    (cosB11i15 ht0 ht1))
    (cosB11i16 ht0 ht1))
    (cosB11i17 ht0 ht1))
    (cosB11i18 ht0 ht1))
    (cosB11i19 ht0 ht1))
    (cosB11i20 ht0 ht1))
    (cosB11i21 ht0 ht1))
    (cosB11i22 ht0 ht1))
    (cosB11i23 ht0 ht1))
    (cosB11i24 ht0 ht1))
    (cosB11i25 ht0 ht1))
    (cosB11i26 ht0 ht1))
    (cosB11i27 ht0 ht1))
    (cosB11i28 ht0 ht1))
    (cosB11i29 ht0 ht1))
    (cosB11i30 ht0 ht1))
    (cosB11i31 ht0 ht1))
    (cosB11i32 ht0 ht1))
    (cosB11i33 ht0 ht1))
    (cosB11i34 ht0 ht1))
    (cosB11i35 ht0 ht1))
    (cosB11i36 ht0 ht1))
    (cosB11i37 ht0 ht1))
    (cosB11i38 ht0 ht1))
    (cosB11i39 ht0 ht1))
    (cosB11i40 ht0 ht1))
    (cosB11i41 ht0 ht1))
    (cosB11i42 ht0 ht1))
    (cosB11i43 ht0 ht1))
    (cosB11i44 ht0 ht1))
    (cosB11i45 ht0 ht1))
    (cosB11i46 ht0 ht1))
    (cosB11i47 ht0 ht1))
    (cosB11i48 ht0 ht1))
    (cosB11i49 ht0 ht1))
    (cosB11i50 ht0 ht1))
    (cosB11i51 ht0 ht1))
    (cosB11i52 ht0 ht1))
    (cosB11i53 ht0 ht1))
    (cosB11i54 ht0 ht1))
    (cosB11i55 ht0 ht1))
    (cosB11i56 ht0 ht1))
    (cosB11i57 ht0 ht1))
    (cosB11i58 ht0 ht1))
    (cosB11i59 ht0 ht1))
    (cosB11i60 ht0 ht1))
    (cosB11i61 ht0 ht1))
    (cosB11i62 ht0 ht1))
    (cosB11i63 ht0 ht1))
    (cosB11i64 ht0 ht1))
    (cosB11i65 ht0 ht1))
    (cosB11i66 ht0 ht1))
    (cosB11i67 ht0 ht1))
    (cosB11i68 ht0 ht1))
    (cosB11i69 ht0 ht1))
    (cosB11i70 ht0 ht1))
    (cosB11i71 ht0 ht1))
    (cosB11i72 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 2.094) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 2.094) (S := 0.013709)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_cut
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
