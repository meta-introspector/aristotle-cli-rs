/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscTail

/-!
# Oscillatory lower bound on the band `5.59375 ≤ t ≤ 5.625`

On each of the 73 blocks the factor `cos(tv)` is bracketed by a rational constant
`C` up to a rational error `h`; the signed contribution `min(C·P₀, C·P₁) - h·S` is
then summed, and the unresolved tail beyond `q = 2.094` is estimated in absolute
value.  The result is the bound `∫₀^∞ err(v) cos(tv) dv ≥ -0.10934648`.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosB23i0 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00641868):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.0038), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.0213345) (m := (0:ℤ)) (ylo := 0.0213345) (yhi := 0.0213345)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1) (q1 := 1.0038) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.0) (B := 0.0075856) (X := 0.0213345) (rho := 0.02133451)
    (clo := 0.99977242) (chi := 0.99977243) (C := 0.98921895) (h := 0.01078105)
    (by norm_num) (by norm_num) oscBlock0 vbpBr0.1 vbpBr1.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i1 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00625872):ℝ) ≤ ∫ v in (vBP 1.0038)..(vBP 1.0078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.06492073) (m := (0:ℤ)) (ylo := 0.06492073) (yhi := 0.06492073)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0038) (q1 := 1.0078) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.00758559) (B := 0.01553948) (X := 0.06492073) (rho := 0.02248886)
    (clo := 0.99789338) (chi := 0.99789339) (C := 0.98770226) (h := 0.01229774)
    (by norm_num) (by norm_num) oscBlock1 vbpBr1.1 vbpBr2.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i2 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.0057677):ℝ) ≤ ∫ v in (vBP 1.0078)..(vBP 1.0118), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.1094484) (m := (0:ℤ)) (ylo := 0.1094484) (yhi := 0.1094484)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0078) (q1 := 1.0118) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.01553947) (B := 0.02346185) (X := 0.1094484) (rho := 0.02252451)
    (clo := 0.9940165) (chi := 0.99401651) (C := 0.98574599) (h := 0.01425401)
    (by norm_num) (by norm_num) oscBlock2 vbpBr2.1 vbpBr3.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i3 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00554846):ℝ) ≤ ∫ v in (vBP 1.0118)..(vBP 1.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.15490742) (m := (0:ℤ)) (ylo := 0.15490742) (yhi := 0.15490742)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0118) (q1 := 1.016) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.02346184) (B := 0.0317467) (X := 0.15490742) (rho := 0.02366777)
    (clo := 0.98802581) (chi := 0.98802582) (C := 0.98217902) (h := 0.01782098)
    (by norm_num) (by norm_num) oscBlock3 vbpBr3.1 vbpBr4.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i4 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00539232):ℝ) ≤ ∫ v in (vBP 1.016)..(vBP 1.0205), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.20293798) (m := (0:ℤ)) (ylo := 0.20293798) (yhi := 0.20293798)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.016) (q1 := 1.0205) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.03174669) (B := 0.04058541) (X := 0.20293798) (rho := 0.02535496)
    (clo := 0.97947866) (chi := 0.97947867) (C := 0.97706185) (h := 0.02293815)
    (by norm_num) (by norm_num) oscBlock4 vbpBr4.1 vbpBr5.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i5 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00482039):ℝ) ≤ ∫ v in (vBP 1.0205)..(vBP 1.025), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.25240825) (m := (0:ℤ)) (ylo := 0.25240825) (yhi := 0.25240825)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0205) (q1 := 1.025) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.0405854) (B := 0.04938523) (X := 0.25240825) (rho := 0.02538368)
    (clo := 0.9683138) (chi := 0.96831381) (C := 0.9683138) (h := 0.02538369)
    (by norm_num) (by norm_num) oscBlock5 vbpBr5.1 vbpBr6.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i6 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00470543):ℝ) ≤ ∫ v in (vBP 1.025)..(vBP 1.03), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.30439256) (m := (0:ℤ)) (ylo := 0.30439256) (yhi := 0.30439256)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.025) (q1 := 1.03) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.04938522) (B := 0.05911761) (X := 0.30439256) (rho := 0.02814401)
    (clo := 0.95402918) (chi := 0.95402919) (C := 0.95402918) (h := 0.02814402)
    (by norm_num) (by norm_num) oscBlock6 vbpBr6.1 vbpBr7.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i7 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00441277):ℝ) ≤ ∫ v in (vBP 1.03)..(vBP 1.0355), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.36156931) (m := (0:ℤ)) (ylo := 0.36156931) (yhi := 0.36156931)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.03) (q1 := 1.0355) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.0591176) (B := 0.06976881) (X := 0.36156931) (rho := 0.03088026)
    (clo := 0.93534284) (chi := 0.93534285) (C := 0.93534284) (h := 0.03088027)
    (by norm_num) (by norm_num) oscBlock7 vbpBr7.1 vbpBr8.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i8 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00396192):ℝ) ≤ ∫ v in (vBP 1.0355)..(vBP 1.0415), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.42385827) (m := (0:ℤ)) (ylo := 0.42385827) (yhi := 0.42385827)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0355) (q1 := 1.0415) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.0697688) (B := 0.08132397) (X := 0.42385827) (rho := 0.03358907)
    (clo := 0.91150889) (chi := 0.9115089) (C := 0.91150889) (h := 0.03358908)
    (by norm_num) (by norm_num) oscBlock8 vbpBr8.1 vbpBr9.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i9 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00337769):ℝ) ≤ ∫ v in (vBP 1.0415)..(vBP 1.048), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.49117314) (m := (0:ℤ)) (ylo := 0.49117314) (yhi := 0.49117314)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0415) (q1 := 1.048) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.08132396) (B := 0.09376718) (X := 0.49117314) (rho := 0.03626726)
    (clo := 0.88178014) (chi := 0.88178015) (C := 0.88178014) (h := 0.03626727)
    (by norm_num) (by norm_num) oscBlock9 vbpBr9.1 vbpBr10.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i10 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00271052):ℝ) ≤ ∫ v in (vBP 1.048)..(vBP 1.055), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.56342188) (m := (0:ℤ)) (ylo := 0.56342188) (yhi := 0.56342188)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.048) (q1 := 1.055) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.09376717) (B := 0.10708154) (X := 0.56342188) (rho := 0.03891179)
    (clo := 0.84543249) (chi := 0.8454325) (C := 0.84543249) (h := 0.0389118)
    (by norm_num) (by norm_num) oscBlock10 vbpBr10.1 vbpBr11.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i11 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00225711):ℝ) ≤ ∫ v in (vBP 1.055)..(vBP 1.064), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.64844275) (m := (0:ℤ)) (ylo := 0.64844275) (yhi := 0.64844275)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.055) (q1 := 1.064) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.10708153) (B := 0.12407079) (X := 0.64844275) (rho := 0.04945546)
    (clo := 0.79702525) (chi := 0.79702527) (C := 0.79702526) (h := 0.04945547)
    (by norm_num) (by norm_num) oscBlock11 vbpBr11.1 vbpBr12.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i12 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00147653):ℝ) ≤ ∫ v in (vBP 1.064)..(vBP 1.078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.76949) (m := (0:ℤ)) (ylo := 0.76949) (yhi := 0.76949)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.064) (q1 := 1.078) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.12407078) (B := 0.15021495) (X := 0.76949) (rho := 0.0754691)
    (clo := 0.7182656) (chi := 0.71826563) (C := 0.71826561) (h := 0.07546912)
    (by norm_num) (by norm_num) oscBlock12 vbpBr12.1 vbpBr13.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i13 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    (0.00020932:ℝ) ≤ ∫ v in (vBP 1.078)..(vBP 1.09), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.90488197) (m := (0:ℤ)) (ylo := 0.90488197) (yhi := 0.90488197)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.078) (q1 := 1.09) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.15021494) (B := 0.1723554) (X := 0.90488197) (rho := 0.06461717)
    (clo := 0.61777839) (chi := 0.6177785) (C := 0.61777844) (h := 0.06461723)
    (by norm_num) (by norm_num) oscBlock13 vbpBr13.1 vbpBr14.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i14 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    (0.00080079:ℝ) ≤ ∫ v in (vBP 1.09)..(vBP 1.1), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.01817624) (m := (0:ℤ)) (ylo := 1.01817624) (yhi := 1.01817624)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.09) (q1 := 1.1) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.17235539) (B := 0.19062036) (X := 1.01817624) (rho := 0.0540633)
    (clo := 0.52491911) (chi := 0.52491945) (C := 0.52491928) (h := 0.05406347)
    (by norm_num) (by norm_num) oscBlock14 vbpBr14.1 vbpBr15.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i15 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    (0.00092466:ℝ) ≤ ∫ v in (vBP 1.1)..(vBP 1.109), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.11509653) (m := (0:ℤ)) (ylo := 1.11509653) (yhi := 1.11509653)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.1) (q1 := 1.109) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.19062035) (B := 0.20691742) (X := 1.11509653) (rho := 0.04881397)
    (clo := 0.44009079) (chi := 0.44009162) (C := 0.4400912) (h := 0.04881439)
    (by norm_num) (by norm_num) oscBlock15 vbpBr15.1 vbpBr16.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i16 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    (0.00083028:ℝ) ≤ ∫ v in (vBP 1.109)..(vBP 1.117), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.20110883) (m := (0:ℤ)) (ylo := 1.20110883) (yhi := 1.20110883)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.109) (q1 := 1.117) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.20691741) (B := 0.22129305) (X := 1.20110883) (rho := 0.04366459)
    (clo := 0.36132404) (chi := 0.36132577) (C := 0.3613249) (h := 0.04366546)
    (by norm_num) (by norm_num) oscBlock16 vbpBr16.1 vbpBr17.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i17 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    (0.00065736:ℝ) ≤ ∫ v in (vBP 1.117)..(vBP 1.124), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.27645634) (m := (0:ℤ)) (ylo := 1.27645634) (yhi := 1.27645634)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.117) (q1 := 1.124) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.22129304) (B := 0.23378751) (X := 1.27645634) (rho := 0.03859842)
    (clo := 0.29010824) (chi := 0.29011142) (C := 0.29010983) (h := 0.03860001)
    (by norm_num) (by norm_num) oscBlock17 vbpBr17.1 vbpBr18.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i18 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    (0.00052358:ℝ) ≤ ∫ v in (vBP 1.124)..(vBP 1.131), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.34632428) (m := (0:ℤ)) (ylo := 1.34632428) (yhi := 1.34632428)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.124) (q1 := 1.131) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.2337875) (B := 0.2462044) (X := 1.34632428) (rho := 0.03857548)
    (clo := 0.22259161) (chi := 0.22259701) (C := 0.22259431) (h := 0.03857818)
    (by norm_num) (by norm_num) oscBlock18 vbpBr18.1 vbpBr19.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i19 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    (0.00034736:ℝ) ≤ ∫ v in (vBP 1.131)..(vBP 1.138), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.41575981) (m := (0:ℤ)) (ylo := 1.41575981) (yhi := 1.41575981)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.131) (q1 := 1.138) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.24620439) (B := 0.25854468) (X := 1.41575981) (rho := 0.03855402)
    (clo := 0.15441604) (chi := 0.15442496) (C := 0.1544205) (h := 0.03855848)
    (by norm_num) (by norm_num) oscBlock19 vbpBr19.1 vbpBr20.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i20 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    (0.0001439:ℝ) ≤ ∫ v in (vBP 1.138)..(vBP 1.145), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.48476822) (m := (0:ℤ)) (ylo := 1.48476822) (yhi := 1.48476822)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.138) (q1 := 1.145) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.25854467) (B := 0.27080928) (X := 1.48476822) (rho := 0.03853399)
    (clo := 0.08592179) (chi := 0.08593615) (C := 0.08592897) (h := 0.03854117)
    (by norm_num) (by norm_num) oscBlock20 vbpBr20.1 vbpBr21.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i21 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00008705):ℝ) ≤ ∫ v in (vBP 1.145)..(vBP 1.152), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.55335473) (m := (0:ℤ)) (ylo := 1.55335473) (yhi := 1.55335473)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.145) (q1 := 1.152) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.27080927) (B := 0.28299913) (X := 1.55335473) (rho := 0.03851539)
    (clo := 0.0174403) (chi := 0.01746285) (C := 0.01745157) (h := 0.03852667)
    (by norm_num) (by norm_num) oscBlock21 vbpBr21.1 vbpBr22.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i22 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00034805):ℝ) ≤ ∫ v in (vBP 1.152)..(vBP 1.159), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.62152446) (m := (0:ℤ)) (ylo := 0.05072813) (yhi := 0.05072814)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.152) (q1 := 1.159) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.28299912) (B := 0.29511513) (X := 1.62152446) (rho := 0.03849815)
    (clo := (-0.05070639)) (chi := (-0.05070637)) (C := (-0.05070638)) (h := 0.03849816)
    (by norm_num) (by norm_num) oscBlock22 vbpBr22.1 vbpBr23.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i23 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00061658):ℝ) ≤ ∫ v in (vBP 1.159)..(vBP 1.166), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.68928248) (m := (0:ℤ)) (ylo := 0.11848615) (yhi := 0.11848616)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.159) (q1 := 1.166) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.29511512) (B := 0.30715818) (X := 1.68928248) (rho := 0.03848229)
    (clo := (-0.11820912)) (chi := (-0.1182091)) (C := (-0.11820911)) (h := 0.0384823)
    (by norm_num) (by norm_num) oscBlock23 vbpBr23.1 vbpBr24.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i24 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00087795):ℝ) ≤ ∫ v in (vBP 1.166)..(vBP 1.173), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.75663371) (m := (0:ℤ)) (ylo := 0.18583738) (yhi := 0.18583739)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.166) (q1 := 1.173) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.30715817) (B := 0.31912914) (X := 1.75663371) (rho := 0.03846771)
    (clo := (-0.18476957)) (chi := (-0.18476956)) (C := (-0.18476957)) (h := 0.03846772)
    (by norm_num) (by norm_num) oscBlock24 vbpBr24.1 vbpBr25.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i25 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00112475):ℝ) ≤ ∫ v in (vBP 1.173)..(vBP 1.18), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.82358301) (m := (0:ℤ)) (ylo := 0.25278668) (yhi := 0.25278669)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.173) (q1 := 1.18) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.31912913) (B := 0.33102888) (X := 1.82358301) (rho := 0.03845445)
    (clo := (-0.25010306)) (chi := (-0.25010304)) (C := (-0.25010305)) (h := 0.03845446)
    (by norm_num) (by norm_num) oscBlock25 vbpBr25.1 vbpBr26.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i26 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.0013506):ℝ) ≤ ∫ v in (vBP 1.18)..(vBP 1.187), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.89013517) (m := (0:ℤ)) (ylo := 0.31933884) (yhi := 0.31933885)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.18) (q1 := 1.187) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.33102887) (B := 0.34285824) (X := 1.89013517) (rho := 0.03844244)
    (clo := (-0.31393891)) (chi := (-0.31393889)) (C := (-0.3139389)) (h := 0.03844245)
    (by norm_num) (by norm_num) oscBlock26 vbpBr26.1 vbpBr27.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i27 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.0015502):ℝ) ≤ ∫ v in (vBP 1.187)..(vBP 1.194), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.95629484) (m := (0:ℤ)) (ylo := 0.38549851) (yhi := 0.38549852)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.187) (q1 := 1.194) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.34285823) (B := 0.35461804) (X := 1.95629484) (rho := 0.03843164)
    (clo := (-0.37602112)) (chi := (-0.3760211)) (C := (-0.37602111)) (h := 0.03843165)
    (by norm_num) (by norm_num) oscBlock27 vbpBr27.1 vbpBr28.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i28 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00173698):ℝ) ≤ ∫ v in (vBP 1.194)..(vBP 1.201), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.02206659) (m := (0:ℤ)) (ylo := 0.45127026) (yhi := 0.45127027)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.194) (q1 := 1.201) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.35461802) (B := 0.36630909) (X := 2.02206659) (rho := 0.03842206)
    (clo := (-0.436109)) (chi := (-0.43610898)) (C := (-0.43610899)) (h := 0.03842207)
    (by norm_num) (by norm_num) oscBlock28 vbpBr28.1 vbpBr29.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i29 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00187434):ℝ) ≤ ∫ v in (vBP 1.201)..(vBP 1.208), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.08745502) (m := (0:ℤ)) (ylo := 0.51665869) (yhi := 0.5166587)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.201) (q1 := 1.208) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.36630908) (B := 0.3779322) (X := 2.08745502) (rho := 0.03841362)
    (clo := (-0.49397773)) (chi := (-0.49397771)) (C := (-0.49397772)) (h := 0.03841363)
    (by norm_num) (by norm_num) oscBlock29 vbpBr29.1 vbpBr30.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i30 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00197587):ℝ) ≤ ∫ v in (vBP 1.208)..(vBP 1.215), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.15246454) (m := (0:ℤ)) (ylo := 0.58166821) (yhi := 0.58166822)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.208) (q1 := 1.215) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.37793219) (B := 0.38948816) (X := 2.15246454) (rho := 0.03840637)
    (clo := (-0.54941858)) (chi := (-0.54941856)) (C := (-0.54941857)) (h := 0.03840638)
    (by norm_num) (by norm_num) oscBlock30 vbpBr30.1 vbpBr31.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i31 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.0023522):ℝ) ≤ ∫ v in (vBP 1.215)..(vBP 1.223), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.22170075) (m := (0:ℤ)) (ylo := 0.65090442) (yhi := 0.65090443)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.215) (q1 := 1.223) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.38948815) (B := 0.40261372) (X := 2.22170075) (rho := 0.04300143)
    (clo := (-0.60590617)) (chi := (-0.60590615)) (C := (-0.60590616)) (h := 0.04300144)
    (by norm_num) (by norm_num) oscBlock31 vbpBr31.1 vbpBr32.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i32 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00238031):ℝ) ≤ ∫ v in (vBP 1.223)..(vBP 1.231), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.29508625) (m := (0:ℤ)) (ylo := 0.72428992) (yhi := 0.72428993)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.223) (q1 := 1.231) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.40261371) (B := 0.4156537) (X := 2.29508625) (rho := 0.04296583)
    (clo := (-0.66260379)) (chi := (-0.66260378)) (C := (-0.66260379)) (h := 0.04296584)
    (by norm_num) (by norm_num) oscBlock32 vbpBr32.1 vbpBr33.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i33 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00235492):ℝ) ≤ ∫ v in (vBP 1.231)..(vBP 1.239), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.36799481) (m := (0:ℤ)) (ylo := 0.79719848) (yhi := 0.79719849)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.231) (q1 := 1.239) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.41565369) (B := 0.42860921) (X := 2.36799481) (rho := 0.042932)
    (clo := (-0.71540145)) (chi := (-0.71540144)) (C := (-0.71540145)) (h := 0.04293201)
    (by norm_num) (by norm_num) oscBlock33 vbpBr33.1 vbpBr34.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i34 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00257116):ℝ) ≤ ∫ v in (vBP 1.239)..(vBP 1.248), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.44494165) (m := (0:ℤ)) (ylo := 0.87414532) (yhi := 0.87414533)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.239) (q1 := 1.248) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.4286092) (B := 0.44308455) (X := 2.44494165) (rho := 0.04740896)
    (clo := (-0.76699539)) (chi := (-0.76699537)) (C := (-0.76699538)) (h := 0.04740897)
    (by norm_num) (by norm_num) oscBlock34 vbpBr34.1 vbpBr35.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i35 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00267841):ℝ) ≤ ∫ v in (vBP 1.248)..(vBP 1.258), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.53031981) (m := (0:ℤ)) (ylo := 0.95952348) (yhi := 0.95952349)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.248) (q1 := 1.258) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.44308453) (B := 0.45904632) (X := 2.53031981) (rho := 0.05181575)
    (clo := (-0.81891821)) (chi := (-0.81891818)) (C := (-0.8189182)) (h := 0.05181577)
    (by norm_num) (by norm_num) oscBlock35 vbpBr35.1 vbpBr36.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i36 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00243223):ℝ) ≤ ∫ v in (vBP 1.258)..(vBP 1.268), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.61949998) (m := (0:ℤ)) (ylo := 1.04870365) (yhi := 1.04870366)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.258) (q1 := 1.268) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.45904631) (B := 0.47488172) (X := 2.61949998) (rho := 0.0517097)
    (clo := (-0.86677752)) (chi := (-0.86677747)) (C := (-0.8667775)) (h := 0.05170973)
    (by norm_num) (by norm_num) oscBlock36 vbpBr36.1 vbpBr37.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i37 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00253613):ℝ) ≤ ∫ v in (vBP 1.268)..(vBP 1.28), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.71677273) (m := (0:ℤ)) (ylo := 1.1459764) (yhi := 1.14597641)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.268) (q1 := 1.28) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.4748817) (B := 0.49372017) (X := 2.71677273) (rho := 0.06040324)
    (clo := (-0.91111309)) (chi := (-0.91111296)) (C := (-0.91111303)) (h := 0.06040331)
    (by norm_num) (by norm_num) oscBlock37 vbpBr37.1 vbpBr38.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i38 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00228621):ℝ) ≤ ∫ v in (vBP 1.28)..(vBP 1.294), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.83065091) (m := (0:ℤ)) (ylo := 1.25985458) (yhi := 1.25985459)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.28) (q1 := 1.294) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.49372014) (B := 0.51547641) (X := 2.83065091) (rho := 0.0689039)
    (clo := (-0.95204618)) (chi := (-0.95204585)) (C := (-0.94157098)) (h := 0.05842903)
    (by norm_num) (by norm_num) oscBlock38 vbpBr38.1 vbpBr39.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i39 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00152768):ℝ) ≤ ∫ v in (vBP 1.294)..(vBP 1.308), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.95203136) (m := (0:ℤ)) (ylo := 1.38123503) (yhi := 1.38123504)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.294) (q1 := 1.308) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.51547638) (B := 0.53699853) (X := 2.95203136) (rho := 0.06858538)
    (clo := (-0.98208786)) (chi := (-0.98208698)) (C := (-0.9567508)) (h := 0.0432492)
    (by norm_num) (by norm_num) oscBlock39 vbpBr39.1 vbpBr40.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i40 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00099396):ℝ) ≤ ∫ v in (vBP 1.308)..(vBP 1.326), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.08910649) (m := (0:ℤ)) (ylo := 1.51831016) (yhi := 1.51831017)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.308) (q1 := 1.326) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.53699848) (B := 0.56433382) (X := 3.08910649) (rho := 0.08527126)
    (clo := (-0.99862536)) (chi := (-0.99862288)) (C := (-0.95667581)) (h := 0.04332419)
    (by norm_num) (by norm_num) oscBlock40 vbpBr40.1 vbpBr41.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i41 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    (0.00003023:ℝ) ≤ ∫ v in (vBP 1.326)..(vBP 1.345), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.2455874) (m := (0:ℤ)) (ylo := 0.10399474) (yhi := 0.10399475)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.326) (q1 := 1.345) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.56433374) (B := 0.59278808) (X := 3.2455874) (rho := 0.08884556)
    (clo := (-0.99459742)) (chi := (-0.99459741)) (C := (-0.95287593)) (h := 0.04712408)
    (by norm_num) (by norm_num) oscBlock41 vbpBr41.1 vbpBr42.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i42 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    (0.00092819:ℝ) ≤ ∫ v in (vBP 1.345)..(vBP 1.362), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.39582148) (m := (0:ℤ)) (ylo := 0.25422882) (yhi := 0.25422883)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.345) (q1 := 1.362) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.59278796) (B := 0.6179085) (X := 3.39582148) (rho := 0.07991385)
    (clo := (-0.96785754)) (chi := (-0.96785753)) (C := (-0.94397184)) (h := 0.05602816)
    (by norm_num) (by norm_num) oscBlock42 vbpBr42.1 vbpBr43.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i43 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    (0.00108291:ℝ) ≤ ∫ v in (vBP 1.362)..(vBP 1.376), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.5236043) (m := (0:ℤ)) (ylo := 0.38201164) (yhi := 0.38201165)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.362) (q1 := 1.376) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.61790831) (B := 0.6383616) (X := 3.5236043) (rho := 0.06717971)
    (clo := (-0.9279166)) (chi := (-0.92791659)) (C := (-0.9279166)) (h := 0.06717972)
    (by norm_num) (by norm_num) oscBlock43 vbpBr43.1 vbpBr44.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i44 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    (0.00120885:ℝ) ≤ ∫ v in (vBP 1.376)..(vBP 1.39), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.63775091) (m := (0:ℤ)) (ylo := 0.49615825) (yhi := 0.49615826)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.376) (q1 := 1.39) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.63836133) (B := 0.65860767) (X := 3.63775091) (rho := 0.06691724)
    (clo := (-0.87941792)) (chi := (-0.8794179)) (C := (-0.87941791)) (h := 0.06691725)
    (by norm_num) (by norm_num) oscBlock44 vbpBr44.1 vbpBr45.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i45 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    (0.00120652:ℝ) ≤ ∫ v in (vBP 1.39)..(vBP 1.404), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.7507478) (m := (0:ℤ)) (ylo := 0.60915514) (yhi := 0.60915515)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.39) (q1 := 1.404) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.65860729) (B := 0.67865086) (X := 3.7507478) (rho := 0.06666329)
    (clo := (-0.82013172)) (chi := (-0.82013171)) (C := (-0.82013172)) (h := 0.0666633)
    (by norm_num) (by norm_num) oscBlock45 vbpBr45.1 vbpBr46.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i46 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    (0.00109998:ℝ) ≤ ∫ v in (vBP 1.404)..(vBP 1.418), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.86261786) (m := (0:ℤ)) (ylo := 0.7210252) (yhi := 0.72102521)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.404) (q1 := 1.418) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.67865033) (B := 0.69849519) (X := 3.86261786) (rho := 0.0664176)
    (clo := (-0.75112935)) (chi := (-0.75112932)) (C := (-0.75112934)) (h := 0.06641762)
    (by norm_num) (by norm_num) oscBlock46 vbpBr46.1 vbpBr47.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i47 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    (0.00091926:ℝ) ≤ ∫ v in (vBP 1.418)..(vBP 1.432), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.97338338) (m := (0:ℤ)) (ylo := 0.83179072) (yhi := 0.83179073)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.418) (q1 := 1.432) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.69849446) (B := 0.7181446) (X := 3.97338338) (rho := 0.06618001)
    (clo := (-0.6735533)) (chi := (-0.67355324)) (C := (-0.67355327)) (h := 0.06618004)
    (by norm_num) (by norm_num) oscBlock47 vbpBr47.1 vbpBr48.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i48 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    (0.00069631:ℝ) ≤ ∫ v in (vBP 1.432)..(vBP 1.446), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.08306592) (m := (0:ℤ)) (ylo := 0.94147326) (yhi := 0.94147327)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.432) (q1 := 1.446) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.7181436) (B := 0.73760286) (X := 4.08306592) (rho := 0.06595018)
    (clo := (-0.5885978)) (chi := (-0.58859763)) (C := (-0.58859772)) (h := 0.06595027)
    (by norm_num) (by norm_num) oscBlock48 vbpBr48.1 vbpBr49.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i49 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    (0.00049159:ℝ) ≤ ∫ v in (vBP 1.446)..(vBP 1.462), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.19938684) (m := (0:ℤ)) (ylo := 1.05779418) (yhi := 1.05779419)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.446) (q1 := 1.462) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.73760153) (B := 0.75961158) (X := 4.19938684) (rho := 0.0734283)
    (clo := (-0.49079563)) (chi := (-0.49079513)) (C := (-0.49079538)) (h := 0.07342855)
    (by norm_num) (by norm_num) oscBlock49 vbpBr49.1 vbpBr50.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i50 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00030355):ℝ) ≤ ∫ v in (vBP 1.462)..(vBP 1.478), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.32216699) (m := (0:ℤ)) (ylo := 1.18057433) (yhi := 1.18057434)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.462) (q1 := 1.478) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.75960973) (B := 0.78138081) (X := 4.32216699) (rho := 0.07310008)
    (clo := (-0.38039517)) (chi := (-0.3803937)) (C := (-0.38039444)) (h := 0.07310082)
    (by norm_num) (by norm_num) oscBlock50 vbpBr50.1 vbpBr51.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i51 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00043506):ℝ) ≤ ∫ v in (vBP 1.478)..(vBP 1.495), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.44738183) (m := (0:ℤ)) (ylo := 1.30578917) (yhi := 1.30578918)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.478) (q1 := 1.495) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.7813783) (B := 0.80425401) (X := 4.44738183) (rho := 0.07654699)
    (clo := (-0.2619201)) (chi := (-0.26191611)) (C := (-0.26191811)) (h := 0.07654899)
    (by norm_num) (by norm_num) oscBlock51 vbpBr51.1 vbpBr52.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i52 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.000281):ℝ) ≤ ∫ v in (vBP 1.495)..(vBP 1.512), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.57495656) (m := (0:ℤ)) (ylo := 1.4333639) (yhi := 1.43336391)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.495) (q1 := 1.512) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.80425056) (B := 0.82686872) (X := 4.57495656) (rho := 0.07618)
    (clo := (-0.13701014)) (chi := (-0.13700004)) (C := (-0.13700509)) (h := 0.07618505)
    (by norm_num) (by norm_num) oscBlock52 vbpBr52.1 vbpBr53.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i53 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00016864):ℝ) ≤ ∫ v in (vBP 1.512)..(vBP 1.531), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.70845007) (m := (0:ℤ)) (ylo := 1.56685741) (yhi := 1.56685742)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.512) (q1 := 1.531) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.82686405) (B := 0.85184522) (X := 4.70845007) (rho := 0.08317931)
    (clo := (-0.00396304)) (chi := (-0.00393844)) (C := (-0.00395074)) (h := 0.08319161)
    (by norm_num) (by norm_num) oscBlock53 vbpBr53.1 vbpBr54.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i54 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00039443):ℝ) ≤ ∫ v in (vBP 1.531)..(vBP 1.55), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.84768198) (m := (0:ℤ)) (ylo := 0.13529299) (yhi := 0.135293)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.531) (q1 := 1.55) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.85183877) (B := 0.87651393) (X := 4.84768198) (rho := 0.08270888)
    (clo := 0.13488062) (chi := 0.13488064) (C := 0.13488063) (h := 0.08270889)
    (by norm_num) (by norm_num) oscBlock54 vbpBr54.1 vbpBr55.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i55 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00062736):ℝ) ≤ ∫ v in (vBP 1.55)..(vBP 1.57), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.98879128) (m := (0:ℤ)) (ylo := 0.27640229) (yhi := 0.2764023)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.55) (q1 := 1.57) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.87650515) (B := 0.90215678) (X := 4.98879128) (rho := 0.08584062)
    (clo := 0.27289626) (chi := 0.27289628) (C := 0.27289627) (h := 0.08584063)
    (by norm_num) (by norm_num) oscBlock55 vbpBr55.1 vbpBr56.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i56 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.0007875):ℝ) ≤ ∫ v in (vBP 1.57)..(vBP 1.59), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.13171105) (m := (0:ℤ)) (ylo := 0.41932206) (yhi := 0.41932207)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.57) (q1 := 1.59) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.90214481) (B := 0.92747548) (X := 5.13171105) (rho := 0.08533854)
    (clo := 0.40714133) (chi := 0.40714135) (C := 0.40714134) (h := 0.08533855)
    (by norm_num) (by norm_num) oscBlock56 vbpBr56.1 vbpBr57.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i57 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00090247):ℝ) ≤ ∫ v in (vBP 1.59)..(vBP 1.61), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.27283305) (m := (0:ℤ)) (ylo := 0.56044406) (yhi := 0.56044407)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.59) (q1 := 1.61) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.92745939) (B := 0.95247825) (X := 5.27283305) (rho := 0.08485711)
    (clo := 0.53156237) (chi := 0.53156239) (C := 0.53156238) (h := 0.08485712)
    (by norm_num) (by norm_num) oscBlock57 vbpBr57.1 vbpBr58.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i58 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00110515):ℝ) ≤ ∫ v in (vBP 1.61)..(vBP 1.632), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.41910053) (m := (0:ℤ)) (ylo := 0.70671154) (yhi := 0.70671155)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.61) (q1 := 1.632) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.95245689) (B := 0.97962584) (X := 5.41910053) (rho := 0.09129483)
    (clo := 0.6493364) (chi := 0.64933642) (C := 0.64933641) (h := 0.09129484)
    (by norm_num) (by norm_num) oscBlock58 vbpBr58.1 vbpBr59.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i59 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00128768):ℝ) ≤ ∫ v in (vBP 1.632)..(vBP 1.656), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.57714006) (m := (0:ℤ)) (ylo := 0.86475107) (yhi := 0.86475108)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.632) (q1 := 1.656) (t0 := 5.59375) (t1 := 5.625)
    (A := 0.97959707) (B := 1.00882827) (X := 5.57714006) (rho := 0.09751897)
    (clo := 0.76093377) (chi := 0.76093379) (C := 0.76093378) (h := 0.09751898)
    (by norm_num) (by norm_num) oscBlock59 vbpBr59.1 vbpBr60.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i60 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00129196):ℝ) ≤ ∫ v in (vBP 1.656)..(vBP 1.68), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.73974056) (m := (0:ℤ)) (ylo := 1.02735157) (yhi := 1.02735158)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.656) (q1 := 1.68) (t0 := 5.59375) (t1 := 5.625)
    (A := 1.00878907) (B := 1.03761196) (X := 5.73974056) (rho := 0.09682672)
    (clo := 0.85593252) (chi := 0.85593257) (C := 0.85593254) (h := 0.09682675)
    (by norm_num) (by norm_num) oscBlock60 vbpBr60.1 vbpBr61.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i61 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00122808):ℝ) ≤ ∫ v in (vBP 1.68)..(vBP 1.704), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.90001823) (m := (0:ℤ)) (ylo := 1.18762924) (yhi := 1.18762925)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.68) (q1 := 1.704) (t0 := 5.59375) (t1 := 5.625)
    (A := 1.03755935) (B := 1.06598913) (X := 5.90001823) (rho := 0.09617064)
    (clo := 0.92748524) (chi := 0.92748542) (C := 0.9156573) (h := 0.0843427)
    (by norm_num) (by norm_num) oscBlock61 vbpBr61.1 vbpBr62.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i62 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00137159):ℝ) ≤ ∫ v in (vBP 1.704)..(vBP 1.734), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.07754389) (m := (0:ℤ)) (ylo := 1.3651549) (yhi := 1.36515491)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.704) (q1 := 1.734) (t0 := 5.59375) (t1 := 5.625)
    (A := 1.06591948) (B := 1.10090679) (X := 6.07754389) (rho := 0.11505682)
    (clo := 0.9789302) (chi := 0.97893098) (C := 0.93193669) (h := 0.06806331)
    (by norm_num) (by norm_num) oscBlock62 vbpBr62.1 vbpBr63.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i63 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00129873):ℝ) ≤ ∫ v in (vBP 1.734)..(vBP 1.766), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.27803769) (m := (0:ℤ)) (ylo := 1.5656487) (yhi := 1.56564871)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.734) (q1 := 1.766) (t0 := 5.59375) (t1 := 5.625)
    (A := 1.10080961) (B := 1.13749718) (X := 6.27803769) (rho := 0.12038396)
    (clo := 0.99998669) (chi := 0.99999017) (C := 0.93980136) (h := 0.06019864)
    (by norm_num) (by norm_num) oscBlock63 vbpBr63.1 vbpBr64.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i64 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00107612):ℝ) ≤ ∫ v in (vBP 1.766)..(vBP 1.796), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.47508193) (m := (1:ℤ)) (ylo := 0.19189662) (yhi := 0.19189663)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.766) (q1 := 1.796) (t0 := 5.59375) (t1 := 5.625)
    (A := 1.1373613) (B := 1.17120873) (X := 6.47508193) (rho := 0.11296718)
    (clo := 0.98164427) (chi := 0.98164428) (C := 0.93433854) (h := 0.06566146)
    (by norm_num) (by norm_num) oscBlock64 vbpBr64.1 vbpBr65.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i65 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00105478):ℝ) ≤ ∫ v in (vBP 1.796)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.66866129) (m := (1:ℤ)) (ylo := 0.38547598) (yhi := 0.38547599)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.796) (q1 := 1.828) (t0 := 5.59375) (t1 := 5.625)
    (A := 1.1710258) (B := 1.20655947) (X := 6.66866129) (rho := 0.11823574)
    (clo := 0.92661956) (chi := 0.92661957) (C := 0.90419191) (h := 0.09580809)
    (by norm_num) (by norm_num) oscBlock65 vbpBr65.1 vbpBr66.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i66 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00092006):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.86), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.86507609) (m := (1:ℤ)) (ylo := 0.58189078) (yhi := 0.58189079)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.828) (q1 := 1.86) (t0 := 5.59375) (t1 := 5.625)
    (A := 1.20631244) (B := 1.24130524) (X := 6.86507609) (rho := 0.1172659)
    (clo := 0.83542495) (chi := 0.83542497) (C := 0.83542496) (h := 0.11726591)
    (by norm_num) (by norm_num) oscBlock66 vbpBr66.1 vbpBr67.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i67 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00066669):ℝ) ≤ ∫ v in (vBP 1.86)..(vBP 1.89), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.0521538) (m := (1:ℤ)) (ylo := 0.76896849) (yhi := 0.7689685)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.86) (q1 := 1.89) (t0 := 5.59375) (t1 := 5.625)
    (A := 1.24097685) (B := 1.27334993) (X := 7.0521538) (rho := 0.11043957)
    (clo := 0.71862835) (chi := 0.71862838) (C := 0.71862836) (h := 0.11043959)
    (by norm_num) (by norm_num) oscBlock67 vbpBr67.1 vbpBr68.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i68 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00053861):ℝ) ≤ ∫ v in (vBP 1.89)..(vBP 1.922), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.23611673) (m := (1:ℤ)) (ylo := 0.95293142) (yhi := 0.95293143)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.89) (q1 := 1.922) (t0 := 5.59375) (t1 := 5.625)
    (A := 1.27292668) (B := 1.30698664) (X := 7.23611673) (rho := 0.11568313)
    (clo := 0.57929612) (chi := 0.57929631) (C := 0.57929621) (h := 0.11568323)
    (by norm_num) (by norm_num) oscBlock68 vbpBr68.1 vbpBr69.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i69 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00053298):ℝ) ≤ ∫ v in (vBP 1.922)..(vBP 1.969), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.46604969) (m := (1:ℤ)) (ylo := 1.18286438) (yhi := 1.18286439)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.922) (q1 := 1.969) (t0 := 5.59375) (t1 := 5.625)
    (A := 1.30643896) (B := 1.35541448) (X := 7.46604969) (rho := 0.15815677)
    (clo := 0.37827481) (chi := 0.37827631) (C := 0.37827556) (h := 0.15815752)
    (by norm_num) (by norm_num) oscBlock69 vbpBr69.1 vbpBr70.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i70 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00023945):ℝ) ≤ ∫ v in (vBP 1.969)..(vBP 2.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.73393463) (m := (1:ℤ)) (ylo := 1.45074932) (yhi := 1.45074933)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.969) (q1 := 2.016) (t0 := 5.59375) (t1 := 5.625)
    (A := 1.35463226) (B := 1.4027369) (X := 7.73393463) (rho := 0.15646044)
    (clo := 0.11975868) (chi := 0.11977008) (C := 0.11976438) (h := 0.15646614)
    (by norm_num) (by norm_num) oscBlock70 vbpBr70.1 vbpBr71.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i71 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00022867):ℝ) ≤ ∫ v in (vBP 2.016)..(vBP 2.062), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 7.99283989) (m := (1:ℤ)) (ylo := 0.13885825) (yhi := 0.13885826)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.016) (q1 := 2.062) (t0 := 5.59375) (t1 := 5.625)
    (A := 1.40164597) (B := 1.44803958) (X := 7.99283989) (rho := 0.15238276)
    (clo := (-0.13841246)) (chi := (-0.13841244)) (C := (-0.13841245)) (h := 0.15238277)
    (by norm_num) (by norm_num) oscBlock71 vbpBr71.1 vbpBr72.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB23i72 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.00023419):ℝ) ≤ ∫ v in (vBP 2.062)..(vBP 2.094), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.20551222) (m := (1:ℤ)) (ylo := 0.35153058) (yhi := 0.35153059)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.062) (q1 := 2.094) (t0 := 5.59375) (t1 := 5.625)
    (A := 1.44655973) (B := 1.47899217) (X := 8.20551222) (rho := 0.11381875)
    (clo := (-0.3443352)) (chi := (-0.34433519)) (C := (-0.3443352)) (h := 0.11381876)
    (by norm_num) (by norm_num) oscBlock72 vbpBr72.1 vbpBr73.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

/-- Lower bound for the oscillatory integral `∫₀^∞ err(v) cos(tv) dv` on the band
`5.59375 ≤ t ≤ 5.625`. -/
theorem oscBandLower23 {t : ℝ} (ht0 : (5.59375:ℝ) ≤ t) (ht1 : t ≤ 5.625) :
    ((-0.10934648):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosB23i0 ht0 ht1)
    (cosB23i1 ht0 ht1))
    (cosB23i2 ht0 ht1))
    (cosB23i3 ht0 ht1))
    (cosB23i4 ht0 ht1))
    (cosB23i5 ht0 ht1))
    (cosB23i6 ht0 ht1))
    (cosB23i7 ht0 ht1))
    (cosB23i8 ht0 ht1))
    (cosB23i9 ht0 ht1))
    (cosB23i10 ht0 ht1))
    (cosB23i11 ht0 ht1))
    (cosB23i12 ht0 ht1))
    (cosB23i13 ht0 ht1))
    (cosB23i14 ht0 ht1))
    (cosB23i15 ht0 ht1))
    (cosB23i16 ht0 ht1))
    (cosB23i17 ht0 ht1))
    (cosB23i18 ht0 ht1))
    (cosB23i19 ht0 ht1))
    (cosB23i20 ht0 ht1))
    (cosB23i21 ht0 ht1))
    (cosB23i22 ht0 ht1))
    (cosB23i23 ht0 ht1))
    (cosB23i24 ht0 ht1))
    (cosB23i25 ht0 ht1))
    (cosB23i26 ht0 ht1))
    (cosB23i27 ht0 ht1))
    (cosB23i28 ht0 ht1))
    (cosB23i29 ht0 ht1))
    (cosB23i30 ht0 ht1))
    (cosB23i31 ht0 ht1))
    (cosB23i32 ht0 ht1))
    (cosB23i33 ht0 ht1))
    (cosB23i34 ht0 ht1))
    (cosB23i35 ht0 ht1))
    (cosB23i36 ht0 ht1))
    (cosB23i37 ht0 ht1))
    (cosB23i38 ht0 ht1))
    (cosB23i39 ht0 ht1))
    (cosB23i40 ht0 ht1))
    (cosB23i41 ht0 ht1))
    (cosB23i42 ht0 ht1))
    (cosB23i43 ht0 ht1))
    (cosB23i44 ht0 ht1))
    (cosB23i45 ht0 ht1))
    (cosB23i46 ht0 ht1))
    (cosB23i47 ht0 ht1))
    (cosB23i48 ht0 ht1))
    (cosB23i49 ht0 ht1))
    (cosB23i50 ht0 ht1))
    (cosB23i51 ht0 ht1))
    (cosB23i52 ht0 ht1))
    (cosB23i53 ht0 ht1))
    (cosB23i54 ht0 ht1))
    (cosB23i55 ht0 ht1))
    (cosB23i56 ht0 ht1))
    (cosB23i57 ht0 ht1))
    (cosB23i58 ht0 ht1))
    (cosB23i59 ht0 ht1))
    (cosB23i60 ht0 ht1))
    (cosB23i61 ht0 ht1))
    (cosB23i62 ht0 ht1))
    (cosB23i63 ht0 ht1))
    (cosB23i64 ht0 ht1))
    (cosB23i65 ht0 ht1))
    (cosB23i66 ht0 ht1))
    (cosB23i67 ht0 ht1))
    (cosB23i68 ht0 ht1))
    (cosB23i69 ht0 ht1))
    (cosB23i70 ht0 ht1))
    (cosB23i71 ht0 ht1))
    (cosB23i72 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 2.094) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 2.094) (S := 0.013709)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_cut
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
