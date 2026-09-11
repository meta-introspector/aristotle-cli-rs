/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscTail

/-!
# Oscillatory lower bound on the band `6.3125 ≤ t ≤ 6.375`

On each of the 73 blocks the factor `cos(tv)` is bracketed by a rational constant
`C` up to a rational error `h`; the signed contribution `min(C·P₀, C·P₁) - h·S` is
then summed, and the unresolved tail beyond `q = 2.094` is estimated in absolute
value.  The result is the bound `∫₀^∞ err(v) cos(tv) dv ≥ -0.13464132`.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosB8i0 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00641868):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.0038), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.0241791) (m := (0:ℤ)) (ylo := 0.0241791) (yhi := 0.0241791)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1) (q1 := 1.0038) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.0) (B := 0.0075856) (X := 0.0241791) (rho := 0.02417911)
    (clo := 0.99970769) (chi := 0.9997077) (C := 0.98776429) (h := 0.01223571)
    (by norm_num) (by norm_num) oscBlock0 vbpBr0.1 vbpBr1.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i1 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00625872):ℝ) ≤ ∫ v in (vBP 1.0038)..(vBP 1.0078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.07347411) (m := (0:ℤ)) (ylo := 0.07347411) (yhi := 0.07347411)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0038) (q1 := 1.0078) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.00758559) (B := 0.01553948) (X := 0.07347411) (rho := 0.02559009)
    (clo := 0.99730199) (chi := 0.997302) (C := 0.98585595) (h := 0.01414405)
    (by norm_num) (by norm_num) oscBlock1 vbpBr1.1 vbpBr2.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i2 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.0057677):ℝ) ≤ ∫ v in (vBP 1.0078)..(vBP 1.0118), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.12383109) (m := (0:ℤ)) (ylo := 0.12383109) (yhi := 0.12383109)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0078) (q1 := 1.0118) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.01553947) (B := 0.02346185) (X := 0.12383109) (rho := 0.02573821)
    (clo := 0.99234272) (chi := 0.99234273) (C := 0.98330225) (h := 0.01669775)
    (by norm_num) (by norm_num) oscBlock2 vbpBr2.1 vbpBr3.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i3 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00554846):ℝ) ≤ ∫ v in (vBP 1.0118)..(vBP 1.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.17524403) (m := (0:ℤ)) (ylo := 0.17524403) (yhi := 0.17524403)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0118) (q1 := 1.016) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.02346184) (B := 0.0317467) (X := 0.17524403) (rho := 0.02714119)
    (clo := 0.98468402) (chi := 0.98468403) (C := 0.97877141) (h := 0.02122859)
    (by norm_num) (by norm_num) oscBlock3 vbpBr3.1 vbpBr4.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i4 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00539232):ℝ) ≤ ∫ v in (vBP 1.016)..(vBP 1.0205), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.22956648) (m := (0:ℤ)) (ylo := 0.22956648) (yhi := 0.22956648)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.016) (q1 := 1.0205) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.03174669) (B := 0.04058541) (X := 0.22956648) (rho := 0.02916552)
    (clo := 0.97376513) (chi := 0.97376514) (C := 0.9722998) (h := 0.0277002)
    (by norm_num) (by norm_num) oscBlock4 vbpBr4.1 vbpBr5.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i5 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.0047968):ℝ) ≤ ∫ v in (vBP 1.0205)..(vBP 1.025), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.28551308) (m := (0:ℤ)) (ylo := 0.28551308) (yhi := 0.28551308)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0205) (q1 := 1.025) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.0405854) (B := 0.04938523) (X := 0.28551308) (rho := 0.02931777)
    (clo := 0.95951727) (chi := 0.95951728) (C := 0.95951727) (h := 0.02931778)
    (by norm_num) (by norm_num) oscBlock5 vbpBr5.1 vbpBr6.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i6 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00466567):ℝ) ≤ ∫ v in (vBP 1.025)..(vBP 1.03), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.34430948) (m := (0:ℤ)) (ylo := 0.34430948) (yhi := 0.34430948)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.025) (q1 := 1.03) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.04938522) (B := 0.05911761) (X := 0.34430948) (rho := 0.0325653)
    (clo := 0.94130875) (chi := 0.94130876) (C := 0.94130875) (h := 0.03256531)
    (by norm_num) (by norm_num) oscBlock6 vbpBr6.1 vbpBr7.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i7 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00435387):ℝ) ≤ ∫ v in (vBP 1.03)..(vBP 1.0355), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.408978) (m := (0:ℤ)) (ylo := 0.408978) (yhi := 0.408978)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.03) (q1 := 1.0355) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.0591176) (B := 0.06976881) (X := 0.408978) (rho := 0.03579817)
    (clo := 0.91752772) (chi := 0.91752773) (C := 0.91752772) (h := 0.03579818)
    (by norm_num) (by norm_num) oscBlock7 vbpBr7.1 vbpBr8.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i8 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.003883):ℝ) ≤ ∫ v in (vBP 1.0355)..(vBP 1.0415), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.47942792) (m := (0:ℤ)) (ylo := 0.47942792) (yhi := 0.47942792)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0355) (q1 := 1.0415) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.0697688) (B := 0.08132397) (X := 0.47942792) (rho := 0.03901239)
    (clo := 0.88725895) (chi := 0.88725896) (C := 0.88725895) (h := 0.0390124)
    (by norm_num) (by norm_num) oscBlock8 vbpBr8.1 vbpBr9.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i9 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00328116):ℝ) ≤ ∫ v in (vBP 1.0415)..(vBP 1.048), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.55556163) (m := (0:ℤ)) (ylo := 0.55556163) (yhi := 0.55556163)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0415) (q1 := 1.048) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.08132396) (B := 0.09376718) (X := 0.55556163) (rho := 0.04220415)
    (clo := 0.84960435) (chi := 0.84960436) (C := 0.84960435) (h := 0.04220416)
    (by norm_num) (by norm_num) oscBlock9 vbpBr9.1 vbpBr10.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i10 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00260247):ℝ) ≤ ∫ v in (vBP 1.048)..(vBP 1.055), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.63727503) (m := (0:ℤ)) (ylo := 0.63727503) (yhi := 0.63727503)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.048) (q1 := 1.055) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.09376717) (B := 0.10708154) (X := 0.63727503) (rho := 0.04536979)
    (clo := 0.80372011) (chi := 0.80372013) (C := 0.80372012) (h := 0.0453698)
    (by norm_num) (by norm_num) oscBlock10 vbpBr10.1 vbpBr11.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i11 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00213415):ℝ) ≤ ∫ v in (vBP 1.055)..(vBP 1.064), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.73345172) (m := (0:ℤ)) (ylo := 0.73345172) (yhi := 0.73345172)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.055) (q1 := 1.064) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.10708153) (B := 0.12407079) (X := 0.73345172) (rho := 0.05749958)
    (clo := 0.74286812) (chi := 0.74286814) (C := 0.74286813) (h := 0.05749959)
    (by norm_num) (by norm_num) oscBlock11 vbpBr11.1 vbpBr12.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i12 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00136118):ℝ) ≤ ∫ v in (vBP 1.064)..(vBP 1.078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.87040855) (m := (0:ℤ)) (ylo := 0.87040855) (yhi := 0.87040855)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.064) (q1 := 1.078) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.12407078) (B := 0.15021495) (X := 0.87040855) (rho := 0.08721177)
    (clo := 0.64451422) (chi := 0.6445143) (C := 0.64451426) (h := 0.08721181)
    (by norm_num) (by norm_num) oscBlock12 vbpBr12.1 vbpBr13.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i13 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    (0.00013843:ℝ) ≤ ∫ v in (vBP 1.078)..(vBP 1.09), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.02349874) (m := (0:ℤ)) (ylo := 1.02349874) (yhi := 1.02349874)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.078) (q1 := 1.09) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.15021494) (B := 0.1723554) (X := 1.02349874) (rho := 0.07526695)
    (clo := 0.52038144) (chi := 0.5203818) (C := 0.52038162) (h := 0.07526713)
    (by norm_num) (by norm_num) oscBlock13 vbpBr13.1 vbpBr14.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i14 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    (0.00056497:ℝ) ≤ ∫ v in (vBP 1.09)..(vBP 1.1), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.15159909) (m := (0:ℤ)) (ylo := 1.15159909) (yhi := 1.15159909)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.09) (q1 := 1.1) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.17235539) (B := 0.19062036) (X := 1.15159909) (rho := 0.06360571)
    (clo := 0.40702731) (chi := 0.40702845) (C := 0.40702788) (h := 0.06360628)
    (by norm_num) (by norm_num) oscBlock14 vbpBr14.1 vbpBr15.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i15 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    (0.00056655:ℝ) ≤ ∫ v in (vBP 1.1)..(vBP 1.109), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.26119475) (m := (0:ℤ)) (ylo := 1.26119475) (yhi := 1.26119475)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.1) (q1 := 1.109) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.19062035) (B := 0.20691742) (X := 1.26119475) (rho := 0.05790381)
    (clo := 0.30467914) (chi := 0.30468196) (C := 0.30468055) (h := 0.05790522)
    (by norm_num) (by norm_num) oscBlock15 vbpBr15.1 vbpBr16.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i16 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    (0.00039778:ℝ) ≤ ∫ v in (vBP 1.109)..(vBP 1.117), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.35845467) (m := (0:ℤ)) (ylo := 1.35845467) (yhi := 1.35845467)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.109) (q1 := 1.117) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.20691741) (B := 0.22129305) (X := 1.35845467) (rho := 0.05228854)
    (clo := 0.21074945) (chi := 0.21075536) (C := 0.2107524) (h := 0.0522915)
    (by norm_num) (by norm_num) oscBlock16 vbpBr16.1 vbpBr17.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i17 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    (0.00019324:ℝ) ≤ ∫ v in (vBP 1.117)..(vBP 1.124), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.44365384) (m := (0:ℤ)) (ylo := 1.44365384) (yhi := 1.44365384)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.117) (q1 := 1.124) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.22129304) (B := 0.23378751) (X := 1.44365384) (rho := 0.04674155)
    (clo := 0.12680004) (chi := 0.12681089) (C := 0.12680546) (h := 0.04674698)
    (by norm_num) (by norm_num) oscBlock17 vbpBr17.1 vbpBr18.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i18 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00001792):ℝ) ≤ ∫ v in (vBP 1.124)..(vBP 1.131), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.52266832) (m := (0:ℤ)) (ylo := 1.52266832) (yhi := 1.52266832)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.124) (q1 := 1.131) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.2337875) (B := 0.2462044) (X := 1.52266832) (rho := 0.04688474)
    (clo := 0.0481091) (chi := 0.04812758) (C := 0.04811834) (h := 0.04689398)
    (by norm_num) (by norm_num) oscBlock18 vbpBr18.1 vbpBr19.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i19 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00027892):ℝ) ≤ ∫ v in (vBP 1.131)..(vBP 1.138), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.60119377) (m := (0:ℤ)) (ylo := 0.03039744) (yhi := 0.03039745)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.131) (q1 := 1.138) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.24620439) (B := 0.25854468) (X := 1.60119377) (rho := 0.04702858)
    (clo := (-0.03039277)) (chi := (-0.03039275)) (C := (-0.03039276)) (h := 0.04702859)
    (by norm_num) (by norm_num) oscBlock19 vbpBr19.1 vbpBr20.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i20 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00057865):ℝ) ≤ ∫ v in (vBP 1.138)..(vBP 1.145), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.67923619) (m := (0:ℤ)) (ylo := 0.10843986) (yhi := 0.10843987)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.138) (q1 := 1.145) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.25854467) (B := 0.27080928) (X := 1.67923619) (rho := 0.04717298)
    (clo := (-0.10822747)) (chi := (-0.10822745)) (C := (-0.10822746)) (h := 0.04717299)
    (by norm_num) (by norm_num) oscBlock20 vbpBr20.1 vbpBr21.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i21 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00088957):ℝ) ≤ ∫ v in (vBP 1.145)..(vBP 1.152), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.75680148) (m := (0:ℤ)) (ylo := 0.18600515) (yhi := 0.18600516)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.145) (q1 := 1.152) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.27080927) (B := 0.28299913) (X := 1.75680148) (rho := 0.04731798)
    (clo := (-0.18493445)) (chi := (-0.18493443)) (C := (-0.18493444)) (h := 0.04731799)
    (by norm_num) (by norm_num) oscBlock21 vbpBr21.1 vbpBr22.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i22 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00119992):ℝ) ≤ ∫ v in (vBP 1.152)..(vBP 1.159), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.83389544) (m := (0:ℤ)) (ylo := 0.26309911) (yhi := 0.26309912)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.152) (q1 := 1.159) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.28299912) (B := 0.29511513) (X := 1.83389544) (rho := 0.04746352)
    (clo := (-0.26007428)) (chi := (-0.26007426)) (C := (-0.26007427)) (h := 0.04746353)
    (by norm_num) (by norm_num) oscBlock22 vbpBr22.1 vbpBr23.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i23 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.0014986):ℝ) ≤ ∫ v in (vBP 1.159)..(vBP 1.166), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.91052379) (m := (0:ℤ)) (ylo := 0.33972746) (yhi := 0.33972747)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.159) (q1 := 1.166) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.29511512) (B := 0.30715818) (X := 1.91052379) (rho := 0.04760962)
    (clo := (-0.33323016)) (chi := (-0.33323014)) (C := (-0.33323015)) (h := 0.04760963)
    (by norm_num) (by norm_num) oscBlock23 vbpBr23.1 vbpBr24.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i24 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.0017767):ℝ) ≤ ∫ v in (vBP 1.166)..(vBP 1.173), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.9866921) (m := (0:ℤ)) (ylo := 0.41589577) (yhi := 0.41589578)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.166) (q1 := 1.173) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.30715817) (B := 0.31912914) (X := 1.9866921) (rho := 0.04775617)
    (clo := (-0.40400952)) (chi := (-0.4040095)) (C := (-0.40400951)) (h := 0.04775618)
    (by norm_num) (by norm_num) oscBlock24 vbpBr24.1 vbpBr25.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i25 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00202667):ℝ) ≤ ∫ v in (vBP 1.173)..(vBP 1.18), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.06240587) (m := (0:ℤ)) (ylo := 0.49160954) (yhi := 0.49160955)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.173) (q1 := 1.18) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.31912913) (B := 0.33102888) (X := 2.06240587) (rho := 0.04790325)
    (clo := (-0.47204544)) (chi := (-0.47204542)) (C := (-0.47204543)) (h := 0.04790326)
    (by norm_num) (by norm_num) oscBlock25 vbpBr25.1 vbpBr26.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i26 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00224236):ℝ) ≤ ∫ v in (vBP 1.18)..(vBP 1.187), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.13767051) (m := (0:ℤ)) (ylo := 0.56687418) (yhi := 0.56687419)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.18) (q1 := 1.187) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.33102887) (B := 0.34285824) (X := 2.13767051) (rho := 0.04805078)
    (clo := (-0.5369978)) (chi := (-0.53699778)) (C := (-0.53699779)) (h := 0.04805079)
    (by norm_num) (by norm_num) oscBlock26 vbpBr26.1 vbpBr27.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i27 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00241908):ℝ) ≤ ∫ v in (vBP 1.187)..(vBP 1.194), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.21249129) (m := (0:ℤ)) (ylo := 0.64169496) (yhi := 0.64169497)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.187) (q1 := 1.194) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.34285823) (B := 0.35461804) (X := 2.21249129) (rho := 0.04819873)
    (clo := (-0.59855412)) (chi := (-0.5985541)) (C := (-0.59855411)) (h := 0.04819874)
    (by norm_num) (by norm_num) oscBlock27 vbpBr27.1 vbpBr28.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i28 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00257977):ℝ) ≤ ∫ v in (vBP 1.194)..(vBP 1.201), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.28687335) (m := (0:ℤ)) (ylo := 0.71607702) (yhi := 0.71607703)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.194) (q1 := 1.201) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.35461802) (B := 0.36630909) (X := 2.28687335) (rho := 0.04834711)
    (clo := (-0.6564303)) (chi := (-0.65643028)) (C := (-0.65643029)) (h := 0.04834712)
    (by norm_num) (by norm_num) oscBlock28 vbpBr28.1 vbpBr29.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i29 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00267167):ℝ) ≤ ∫ v in (vBP 1.201)..(vBP 1.208), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.36082192) (m := (0:ℤ)) (ylo := 0.79002559) (yhi := 0.7900256)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.201) (q1 := 1.208) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.36630908) (B := 0.3779322) (X := 2.36082192) (rho := 0.04849587)
    (clo := (-0.7103713)) (chi := (-0.71037128)) (C := (-0.71037129)) (h := 0.04849588)
    (by norm_num) (by norm_num) oscBlock29 vbpBr29.1 vbpBr30.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i30 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00271862):ℝ) ≤ ∫ v in (vBP 1.208)..(vBP 1.215), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.43434198) (m := (0:ℤ)) (ylo := 0.86354565) (yhi := 0.86354566)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.208) (q1 := 1.215) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.37793219) (B := 0.38948816) (X := 2.43434198) (rho := 0.04864505)
    (clo := (-0.76015113)) (chi := (-0.7601511)) (C := (-0.76015112)) (h := 0.04864507)
    (by norm_num) (by norm_num) oscBlock30 vbpBr30.1 vbpBr31.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i31 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00312703):ℝ) ≤ ∫ v in (vBP 1.215)..(vBP 1.223), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.5126532) (m := (0:ℤ)) (ylo := 0.94185687) (yhi := 0.94185688)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.215) (q1 := 1.223) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.38948815) (B := 0.40261372) (X := 2.5126532) (rho := 0.05400927)
    (clo := (-0.80865189)) (chi := (-0.80865186)) (C := (-0.80865188)) (h := 0.05400929)
    (by norm_num) (by norm_num) oscBlock31 vbpBr31.1 vbpBr32.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i32 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00306587):ℝ) ≤ ∫ v in (vBP 1.223)..(vBP 1.231), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.59564569) (m := (0:ℤ)) (ylo := 1.02484936) (yhi := 1.02484937)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.223) (q1 := 1.231) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.40261371) (B := 0.4156537) (X := 2.59564569) (rho := 0.05414666)
    (clo := (-0.85463603)) (chi := (-0.85463598)) (C := (-0.85463601)) (h := 0.05414669)
    (by norm_num) (by norm_num) oscBlock32 vbpBr32.1 vbpBr33.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i33 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00294633):ℝ) ≤ ∫ v in (vBP 1.231)..(vBP 1.239), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.67809881) (m := (0:ℤ)) (ylo := 1.10730248) (yhi := 1.10730249)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.231) (q1 := 1.239) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.41565369) (B := 0.42860921) (X := 2.67809881) (rho := 0.05428491)
    (clo := (-0.89449603)) (chi := (-0.89449594)) (C := (-0.89449599)) (h := 0.05428496)
    (by norm_num) (by norm_num) oscBlock33 vbpBr33.1 vbpBr34.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i34 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00312397):ℝ) ≤ ∫ v in (vBP 1.239)..(vBP 1.248), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.76512979) (m := (0:ℤ)) (ylo := 1.19433346) (yhi := 1.19433347)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.239) (q1 := 1.248) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.4286092) (B := 0.44308455) (X := 2.76512979) (rho := 0.05953423)
    (clo := (-0.929971)) (chi := (-0.92997081)) (C := (-0.92997091)) (h := 0.05953433)
    (by norm_num) (by norm_num) oscBlock34 vbpBr34.1 vbpBr35.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i35 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00307604):ℝ) ≤ ∫ v in (vBP 1.248)..(vBP 1.258), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.86169569) (m := (0:ℤ)) (ylo := 1.29089936) (yhi := 1.29089937)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.248) (q1 := 1.258) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.44308453) (B := 0.45904632) (X := 2.86169569) (rho := 0.06472461)
    (clo := (-0.96108433)) (chi := (-0.9610839)) (C := (-0.94817965)) (h := 0.05182036)
    (by norm_num) (by norm_num) oscBlock35 vbpBr35.1 vbpBr36.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i36 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00264809):ℝ) ≤ ∫ v in (vBP 1.258)..(vBP 1.268), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.96255039) (m := (0:ℤ)) (ylo := 1.39175406) (yhi := 1.39175407)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.258) (q1 := 1.268) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.45904631) (B := 0.47488172) (X := 2.96255039) (rho := 0.06482058)
    (clo := (-0.98401565)) (chi := (-0.98401469)) (C := (-0.95959706)) (h := 0.04040295)
    (by norm_num) (by norm_num) oscBlock36 vbpBr36.1 vbpBr37.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i37 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00261049):ℝ) ≤ ∫ v in (vBP 1.268)..(vBP 1.28), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.0725784) (m := (0:ℤ)) (ylo := 1.50178207) (yhi := 1.50178208)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.268) (q1 := 1.28) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.4748817) (B := 0.49372017) (X := 3.0725784) (rho := 0.07488769)
    (clo := (-0.99762163)) (chi := (-0.99761942)) (C := (-0.96136587)) (h := 0.03863414)
    (by norm_num) (by norm_num) oscBlock37 vbpBr37.1 vbpBr38.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i38 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00228621):ℝ) ≤ ∫ v in (vBP 1.28)..(vBP 1.294), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.20138524) (m := (0:ℤ)) (ylo := 0.05979258) (yhi := 0.05979259)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.28) (q1 := 1.294) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.49372014) (B := 0.51547641) (X := 3.20138524) (rho := 0.08477688)
    (clo := (-0.99821296)) (chi := (-0.99821295)) (C := (-0.95671804)) (h := 0.04328197)
    (by norm_num) (by norm_num) oscBlock38 vbpBr38.1 vbpBr39.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i39 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00152768):ℝ) ≤ ∫ v in (vBP 1.294)..(vBP 1.308), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.33865513) (m := (0:ℤ)) (ylo := 0.19706247) (yhi := 0.19706248)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.294) (q1 := 1.308) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.51547638) (B := 0.53699853) (X := 3.33865513) (rho := 0.0847105)
    (clo := (-0.98064595)) (chi := (-0.98064594)) (C := (-0.94796772)) (h := 0.05203228)
    (by norm_num) (by norm_num) oscBlock39 vbpBr39.1 vbpBr40.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i40 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00099797):ℝ) ≤ ∫ v in (vBP 1.308)..(vBP 1.326), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.4937155) (m := (0:ℤ)) (ylo := 0.35212284) (yhi := 0.35212285)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.308) (q1 := 1.326) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.53699848) (B := 0.56433382) (X := 3.4937155) (rho := 0.10391261)
    (clo := (-0.93864268)) (chi := (-0.93864267)) (C := (-0.91736503)) (h := 0.08263497)
    (by norm_num) (by norm_num) oscBlock40 vbpBr40.1 vbpBr41.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i41 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00008194):ℝ) ≤ ∫ v in (vBP 1.326)..(vBP 1.345), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.67069037) (m := (0:ℤ)) (ylo := 0.52909771) (yhi := 0.52909772)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.326) (q1 := 1.345) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.56433374) (B := 0.59278808) (X := 3.67069037) (rho := 0.10833365)
    (clo := (-0.86326286)) (chi := (-0.86326285)) (C := (-0.86326286)) (h := 0.10833366)
    (by norm_num) (by norm_num) oscBlock41 vbpBr41.1 vbpBr42.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i42 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    (0.0006476:ℝ) ≤ ∫ v in (vBP 1.345)..(vBP 1.362), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.84057034) (m := (0:ℤ)) (ylo := 0.69897768) (yhi := 0.69897769)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.345) (q1 := 1.362) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.59278796) (B := 0.6179085) (X := 3.84057034) (rho := 0.09859636)
    (clo := (-0.7655004)) (chi := (-0.76550037)) (C := (-0.76550039)) (h := 0.09859638)
    (by norm_num) (by norm_num) oscBlock42 vbpBr42.1 vbpBr43.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i43 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    (0.00070444:ℝ) ≤ ∫ v in (vBP 1.362)..(vBP 1.376), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.9850507) (m := (0:ℤ)) (ylo := 0.84345804) (yhi := 0.84345805)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.362) (q1 := 1.376) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.61790831) (B := 0.6383616) (X := 3.9850507) (rho := 0.08450451)
    (clo := (-0.66488389)) (chi := (-0.66488382)) (C := (-0.66488386)) (h := 0.08450455)
    (by norm_num) (by norm_num) oscBlock43 vbpBr43.1 vbpBr44.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i44 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    (0.00068442:ℝ) ≤ ∫ v in (vBP 1.376)..(vBP 1.39), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.11413989) (m := (0:ℤ)) (ylo := 0.97254723) (yhi := 0.97254724)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.376) (q1 := 1.39) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.63836133) (B := 0.65860767) (X := 4.11413989) (rho := 0.08448402)
    (clo := (-0.56319674)) (chi := (-0.56319651)) (C := (-0.56319663)) (h := 0.08448414)
    (by norm_num) (by norm_num) oscBlock44 vbpBr44.1 vbpBr45.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i45 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    (0.00056016:ℝ) ≤ ∫ v in (vBP 1.39)..(vBP 1.404), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.24192887) (m := (0:ℤ)) (ylo := 1.10033621) (yhi := 1.10033622)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.39) (q1 := 1.404) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.65860729) (B := 0.67865086) (X := 4.24192887) (rho := 0.08447037)
    (clo := (-0.45329718)) (chi := (-0.45329644)) (C := (-0.45329681)) (h := 0.08447074)
    (by norm_num) (by norm_num) oscBlock45 vbpBr45.1 vbpBr46.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i46 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    (0.00037175:ℝ) ≤ ∫ v in (vBP 1.404)..(vBP 1.418), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.36844352) (m := (0:ℤ)) (ylo := 1.22685086) (yhi := 1.22685087)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.404) (q1 := 1.418) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.67865033) (B := 0.69849519) (X := 4.36844352) (rho := 0.08446333)
    (clo := (-0.3372062)) (chi := (-0.33720406)) (C := (-0.33720513)) (h := 0.0844644)
    (by norm_num) (by norm_num) oscBlock46 vbpBr46.1 vbpBr47.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i47 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    (0.00015986:ℝ) ≤ ∫ v in (vBP 1.418)..(vBP 1.432), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.49370905) (m := (0:ℤ)) (ylo := 1.35211639) (yhi := 1.3521164)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.418) (q1 := 1.432) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.69849446) (B := 0.7181446) (X := 4.49370905) (rho := 0.08446279)
    (clo := (-0.21694674)) (chi := (-0.2169411)) (C := (-0.21694392)) (h := 0.08446561)
    (by norm_num) (by norm_num) oscBlock47 vbpBr47.1 vbpBr48.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i48 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.0000389):ℝ) ≤ ∫ v in (vBP 1.432)..(vBP 1.446), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.61774985) (m := (0:ℤ)) (ylo := 1.47615719) (yhi := 1.4761572)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.432) (q1 := 1.446) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.7181436) (B := 0.73760286) (X := 4.61774985) (rho := 0.08446839)
    (clo := (-0.09451125)) (chi := (-0.09449769)) (C := (-0.09450447)) (h := 0.08447517)
    (by norm_num) (by norm_num) oscBlock48 vbpBr48.1 vbpBr49.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i49 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00028454):ℝ) ≤ ∫ v in (vBP 1.446)..(vBP 1.462), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.74931674) (m := (0:ℤ)) (ylo := 0.03692775) (yhi := 0.03692776)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.446) (q1 := 1.462) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.73760153) (B := 0.75961158) (X := 4.74931674) (rho := 0.0932071)
    (clo := 0.03691935) (chi := 0.03691937) (C := 0.03691936) (h := 0.09320711)
    (by norm_num) (by norm_num) oscBlock49 vbpBr49.1 vbpBr50.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i50 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00056257):ℝ) ≤ ∫ v in (vBP 1.462)..(vBP 1.478), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.88816954) (m := (0:ℤ)) (ylo := 0.17578055) (yhi := 0.17578056)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.462) (q1 := 1.478) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.75960973) (B := 0.78138081) (X := 4.88816954) (rho := 0.09313314)
    (clo := 0.17487671) (chi := 0.17487673) (C := 0.17487672) (h := 0.09313315)
    (by norm_num) (by norm_num) oscBlock50 vbpBr50.1 vbpBr51.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i51 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00084843):ℝ) ≤ ∫ v in (vBP 1.478)..(vBP 1.495), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.02978491) (m := (0:ℤ)) (ylo := 0.31739592) (yhi := 0.31739593)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.478) (q1 := 1.495) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.7813783) (B := 0.80425401) (X := 5.02978491) (rho := 0.09733441)
    (clo := 0.31209361) (chi := 0.31209363) (C := 0.31209362) (h := 0.09733442)
    (by norm_num) (by norm_num) oscBlock51 vbpBr51.1 vbpBr52.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i52 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00104265):ℝ) ≤ ∫ v in (vBP 1.495)..(vBP 1.512), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.17405987) (m := (0:ℤ)) (ylo := 0.46167088) (yhi := 0.46167089)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.495) (q1 := 1.512) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.80425056) (B := 0.82686872) (X := 5.17405987) (rho := 0.09722823)
    (clo := 0.44544468) (chi := 0.4454447) (C := 0.44544469) (h := 0.09722824)
    (by norm_num) (by norm_num) oscBlock52 vbpBr52.1 vbpBr53.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i53 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00134657):ℝ) ≤ ∫ v in (vBP 1.512)..(vBP 1.531), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.32504629) (m := (0:ℤ)) (ylo := 0.6126573) (yhi := 0.61265731)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.512) (q1 := 1.531) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.82686405) (B := 0.85184522) (X := 5.32504629) (rho := 0.105467)
    (clo := 0.57504348) (chi := 0.5750435) (C := 0.57504349) (h := 0.10546701)
    (by norm_num) (by norm_num) oscBlock53 vbpBr53.1 vbpBr54.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i54 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00145287):ℝ) ≤ ∫ v in (vBP 1.531)..(vBP 1.55), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.48250426) (m := (0:ℤ)) (ylo := 0.77011527) (yhi := 0.77011528)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.531) (q1 := 1.55) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.85183877) (B := 0.87651393) (X := 5.48250426) (rho := 0.10527205)
    (clo := 0.69621798) (chi := 0.696218) (C := 0.69621799) (h := 0.10527206)
    (by norm_num) (by norm_num) oscBlock54 vbpBr54.1 vbpBr55.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i55 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00159244):ℝ) ≤ ∫ v in (vBP 1.55)..(vBP 1.57), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.64209411) (m := (0:ℤ)) (ylo := 0.92970512) (yhi := 0.92970513)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.55) (q1 := 1.57) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.87650515) (B := 0.90215678) (X := 5.64209411) (rho := 0.10915537)
    (clo := 0.80144361) (chi := 0.80144364) (C := 0.80144362) (h := 0.10915539)
    (by norm_num) (by norm_num) oscBlock55 vbpBr55.1 vbpBr56.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i56 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00159292):ℝ) ≤ ∫ v in (vBP 1.57)..(vBP 1.59), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.80372264) (m := (0:ℤ)) (ylo := 1.09133365) (yhi := 1.09133366)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.57) (q1 := 1.59) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.90214481) (B := 0.92747548) (X := 5.80372264) (rho := 0.10893355)
    (clo := 0.88724291) (chi := 0.88724299) (C := 0.88724295) (h := 0.10893359)
    (by norm_num) (by norm_num) oscBlock56 vbpBr56.1 vbpBr57.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i57 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00146404):ℝ) ≤ ∫ v in (vBP 1.59)..(vBP 1.61), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.96331812) (m := (0:ℤ)) (ylo := 1.25092913) (yhi := 1.25092914)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.59) (q1 := 1.61) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.92745939) (B := 0.95247825) (X := 5.96331812) (rho := 0.10873074)
    (clo := 0.94927718) (chi := 0.94927748) (C := 0.92027322) (h := 0.07972678)
    (by norm_num) (by norm_num) oscBlock57 vbpBr57.1 vbpBr58.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i58 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00149216):ℝ) ≤ ∫ v in (vBP 1.61)..(vBP 1.632), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.12874942) (m := (0:ℤ)) (ylo := 1.41636043) (yhi := 1.41636044)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.61) (q1 := 1.632) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.95245689) (B := 0.97962584) (X := 6.12874942) (rho := 0.11636532)
    (clo := 0.98809844) (chi := 0.9880996) (C := 0.93586656) (h := 0.06413344)
    (by norm_num) (by norm_num) oscBlock58 vbpBr58.1 vbpBr59.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i59 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00149999):ℝ) ≤ ∫ v in (vBP 1.632)..(vBP 1.656), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.30749336) (m := (1:ℤ)) (ylo := 0.02430805) (yhi := 0.02430806)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.632) (q1 := 1.656) (t0 := 6.3125) (t1 := 6.375)
    (A := 0.97959707) (B := 1.00882827) (X := 6.30749336) (rho := 0.12378687)
    (clo := 0.99970457) (chi := 0.99970458) (C := 0.93795885) (h := 0.06204115)
    (by norm_num) (by norm_num) oscBlock59 vbpBr59.1 vbpBr60.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i60 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00135601):ℝ) ≤ ∫ v in (vBP 1.656)..(vBP 1.68), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.49137862) (m := (1:ℤ)) (ylo := 0.20819331) (yhi := 0.20819332)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.656) (q1 := 1.68) (t0 := 6.3125) (t1 := 6.375)
    (A := 1.00878907) (B := 1.03761196) (X := 6.49137862) (rho := 0.12339764)
    (clo := 0.97840593) (chi := 0.97840595) (C := 0.92750414) (h := 0.07249586)
    (by norm_num) (by norm_num) oscBlock60 vbpBr60.1 vbpBr61.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i61 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00122808):ℝ) ≤ ∫ v in (vBP 1.68)..(vBP 1.704), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.67263705) (m := (1:ℤ)) (ylo := 0.38945174) (yhi := 0.38945175)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.68) (q1 := 1.704) (t0 := 6.3125) (t1 := 6.375)
    (A := 1.03755935) (B := 1.06598913) (X := 6.67263705) (rho := 0.12304367)
    (clo := 0.92511735) (chi := 0.92511737) (C := 0.90103684) (h := 0.09896316)
    (by norm_num) (by norm_num) oscBlock61 vbpBr61.1 vbpBr62.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i62 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00133816):ℝ) ≤ ∫ v in (vBP 1.704)..(vBP 1.734), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.87344875) (m := (1:ℤ)) (ylo := 0.59026344) (yhi := 0.59026345)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.704) (q1 := 1.734) (t0 := 6.3125) (t1 := 6.375)
    (A := 1.06591948) (B := 1.10090679) (X := 6.87344875) (rho := 0.14483205)
    (clo := 0.83079407) (chi := 0.83079409) (C := 0.83079408) (h := 0.14483206)
    (by norm_num) (by norm_num) oscBlock62 vbpBr62.1 vbpBr63.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i63 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00108541):ℝ) ≤ ∫ v in (vBP 1.734)..(vBP 1.766), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.10020259) (m := (1:ℤ)) (ylo := 0.81701728) (yhi := 0.81701729)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.734) (q1 := 1.766) (t0 := 6.3125) (t1 := 6.375)
    (A := 1.10080961) (B := 1.13749718) (X := 7.10020259) (rho := 0.15134194)
    (clo := 0.68439896) (chi := 0.68439901) (C := 0.68439898) (h := 0.15134197)
    (by norm_num) (by norm_num) oscBlock63 vbpBr63.1 vbpBr64.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i64 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00069926):ℝ) ≤ ∫ v in (vBP 1.766)..(vBP 1.796), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.32302443) (m := (1:ℤ)) (ylo := 1.03983912) (yhi := 1.03983913)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.766) (q1 := 1.796) (t0 := 6.3125) (t1 := 6.375)
    (A := 1.1373613) (B := 1.17120873) (X := 7.32302443) (rho := 0.14343124)
    (clo := 0.50635898) (chi := 0.5063594) (C := 0.50635919) (h := 0.14343145)
    (by norm_num) (by norm_num) oscBlock64 vbpBr64.1 vbpBr65.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i65 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00048188):ℝ) ≤ ∫ v in (vBP 1.796)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.54195849) (m := (1:ℤ)) (ylo := 1.25877318) (yhi := 1.25877319)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.796) (q1 := 1.828) (t0 := 6.3125) (t1 := 6.375)
    (A := 1.1710258) (B := 1.20655947) (X := 7.54195849) (rho := 0.14985814)
    (clo := 0.30698467) (chi := 0.30698745) (C := 0.30698606) (h := 0.14985953)
    (by norm_num) (by norm_num) oscBlock65 vbpBr65.1 vbpBr66.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i66 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00023084):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.86), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.76408409) (m := (1:ℤ)) (ylo := 1.48089878) (yhi := 1.48089879)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.828) (q1 := 1.86) (t0 := 6.3125) (t1 := 6.375)
    (A := 1.20631244) (B := 1.24130524) (X := 7.76408409) (rho := 0.14923683)
    (clo := 0.08977627) (chi := 0.08979027) (C := 0.08978327) (h := 0.14924383)
    (by norm_num) (by norm_num) oscBlock66 vbpBr66.1 vbpBr67.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i67 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00019954):ℝ) ≤ ∫ v in (vBP 1.86)..(vBP 1.89), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 7.97563608) (m := (1:ℤ)) (ylo := 0.12165444) (yhi := 0.12165445)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.86) (q1 := 1.89) (t0 := 6.3125) (t1 := 6.375)
    (A := 1.24097685) (B := 1.27334993) (X := 7.97563608) (rho := 0.14196973)
    (clo := (-0.1213546)) (chi := (-0.12135458)) (C := (-0.12135459)) (h := 0.14196974)
    (by norm_num) (by norm_num) oscBlock67 vbpBr67.1 vbpBr68.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i68 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00034496):ℝ) ≤ ∫ v in (vBP 1.89)..(vBP 1.922), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.18369474) (m := (1:ℤ)) (ylo := 0.3297131) (yhi := 0.32971311)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.89) (q1 := 1.922) (t0 := 6.3125) (t1 := 6.375)
    (A := 1.27292668) (B := 1.30698664) (X := 8.18369474) (rho := 0.1483451)
    (clo := (-0.32377161)) (chi := (-0.32377159)) (C := (-0.3237716)) (h := 0.14834511)
    (by norm_num) (by norm_num) oscBlock68 vbpBr68.1 vbpBr69.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i69 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00073109):ℝ) ≤ ∫ v in (vBP 1.922)..(vBP 1.969), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.44383162) (m := (1:ℤ)) (ylo := 0.58984998) (yhi := 0.58984999)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.922) (q1 := 1.969) (t0 := 6.3125) (t1 := 6.375)
    (A := 1.30643896) (B := 1.35541448) (X := 8.44383162) (rho := 0.1969357)
    (clo := (-0.55623637)) (chi := (-0.55623635)) (C := (-0.55623636)) (h := 0.19693571)
    (by norm_num) (by norm_num) oscBlock69 vbpBr69.1 vbpBr70.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i70 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00085646):ℝ) ≤ ∫ v in (vBP 1.969)..(vBP 2.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.74678193) (m := (1:ℤ)) (ylo := 0.89280029) (yhi := 0.8928003)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.969) (q1 := 2.016) (t0 := 6.3125) (t1 := 6.375)
    (A := 1.35463226) (B := 1.4027369) (X := 8.74678193) (rho := 0.19566581)
    (clo := (-0.77883125)) (chi := (-0.77883123)) (C := (-0.77883124)) (h := 0.19566582)
    (by norm_num) (by norm_num) oscBlock70 vbpBr70.1 vbpBr71.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i71 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00078634):ℝ) ≤ ∫ v in (vBP 2.016)..(vBP 2.062), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 9.03957125) (m := (1:ℤ)) (ylo := 1.18558961) (yhi := 1.18558962)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.016) (q1 := 2.062) (t0 := 6.3125) (t1 := 6.375)
    (A := 1.40164597) (B := 1.44803958) (X := 9.03957125) (rho := 0.19168108)
    (clo := (-0.92672095)) (chi := (-0.92672077)) (C := (-0.86751985)) (h := 0.13248016)
    (by norm_num) (by norm_num) oscBlock71 vbpBr71.1 vbpBr72.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB8i72 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.00051116):ℝ) ≤ ∫ v in (vBP 2.062)..(vBP 2.094), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 9.27999168) (m := (1:ℤ)) (ylo := 1.42601004) (yhi := 1.42601005)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.062) (q1 := 2.094) (t0 := 6.3125) (t1 := 6.375)
    (A := 1.44655973) (B := 1.47899217) (X := 9.27999168) (rho := 0.14858341)
    (clo := (-0.989538)) (chi := (-0.98953674)) (C := (-0.92047667)) (h := 0.07952334)
    (by norm_num) (by norm_num) oscBlock72 vbpBr72.1 vbpBr73.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

/-- Lower bound for the oscillatory integral `∫₀^∞ err(v) cos(tv) dv` on the band
`6.3125 ≤ t ≤ 6.375`. -/
theorem oscBandLower8 {t : ℝ} (ht0 : (6.3125:ℝ) ≤ t) (ht1 : t ≤ 6.375) :
    ((-0.13464132):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosB8i0 ht0 ht1)
    (cosB8i1 ht0 ht1))
    (cosB8i2 ht0 ht1))
    (cosB8i3 ht0 ht1))
    (cosB8i4 ht0 ht1))
    (cosB8i5 ht0 ht1))
    (cosB8i6 ht0 ht1))
    (cosB8i7 ht0 ht1))
    (cosB8i8 ht0 ht1))
    (cosB8i9 ht0 ht1))
    (cosB8i10 ht0 ht1))
    (cosB8i11 ht0 ht1))
    (cosB8i12 ht0 ht1))
    (cosB8i13 ht0 ht1))
    (cosB8i14 ht0 ht1))
    (cosB8i15 ht0 ht1))
    (cosB8i16 ht0 ht1))
    (cosB8i17 ht0 ht1))
    (cosB8i18 ht0 ht1))
    (cosB8i19 ht0 ht1))
    (cosB8i20 ht0 ht1))
    (cosB8i21 ht0 ht1))
    (cosB8i22 ht0 ht1))
    (cosB8i23 ht0 ht1))
    (cosB8i24 ht0 ht1))
    (cosB8i25 ht0 ht1))
    (cosB8i26 ht0 ht1))
    (cosB8i27 ht0 ht1))
    (cosB8i28 ht0 ht1))
    (cosB8i29 ht0 ht1))
    (cosB8i30 ht0 ht1))
    (cosB8i31 ht0 ht1))
    (cosB8i32 ht0 ht1))
    (cosB8i33 ht0 ht1))
    (cosB8i34 ht0 ht1))
    (cosB8i35 ht0 ht1))
    (cosB8i36 ht0 ht1))
    (cosB8i37 ht0 ht1))
    (cosB8i38 ht0 ht1))
    (cosB8i39 ht0 ht1))
    (cosB8i40 ht0 ht1))
    (cosB8i41 ht0 ht1))
    (cosB8i42 ht0 ht1))
    (cosB8i43 ht0 ht1))
    (cosB8i44 ht0 ht1))
    (cosB8i45 ht0 ht1))
    (cosB8i46 ht0 ht1))
    (cosB8i47 ht0 ht1))
    (cosB8i48 ht0 ht1))
    (cosB8i49 ht0 ht1))
    (cosB8i50 ht0 ht1))
    (cosB8i51 ht0 ht1))
    (cosB8i52 ht0 ht1))
    (cosB8i53 ht0 ht1))
    (cosB8i54 ht0 ht1))
    (cosB8i55 ht0 ht1))
    (cosB8i56 ht0 ht1))
    (cosB8i57 ht0 ht1))
    (cosB8i58 ht0 ht1))
    (cosB8i59 ht0 ht1))
    (cosB8i60 ht0 ht1))
    (cosB8i61 ht0 ht1))
    (cosB8i62 ht0 ht1))
    (cosB8i63 ht0 ht1))
    (cosB8i64 ht0 ht1))
    (cosB8i65 ht0 ht1))
    (cosB8i66 ht0 ht1))
    (cosB8i67 ht0 ht1))
    (cosB8i68 ht0 ht1))
    (cosB8i69 ht0 ht1))
    (cosB8i70 ht0 ht1))
    (cosB8i71 ht0 ht1))
    (cosB8i72 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 2.094) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 2.094) (S := 0.013709)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_cut
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
