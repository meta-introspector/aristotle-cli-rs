/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscTail

/-!
# Oscillatory lower bound on the band `5.6875 ≤ t ≤ 5.71875`

On each of the 73 blocks the factor `cos(tv)` is bracketed by a rational constant
`C` up to a rational error `h`; the signed contribution `min(C·P₀, C·P₁) - h·S` is
then summed, and the unresolved tail beyond `q = 2.094` is estimated in absolute
value.  The result is the bound `∫₀^∞ err(v) cos(tv) dv ≥ -0.11233569`.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosB20i0 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00641868):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.0038), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.02169007) (m := (0:ℤ)) (ylo := 0.02169007) (yhi := 0.02169007)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1) (q1 := 1.0038) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.0) (B := 0.0075856) (X := 0.02169007) (rho := 0.02169009)
    (clo := 0.99976477) (chi := 0.99976478) (C := 0.98903734) (h := 0.01096266)
    (by norm_num) (by norm_num) oscBlock0 vbpBr0.1 vbpBr1.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i1 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00625872):ℝ) ≤ ∫ v in (vBP 1.0038)..(vBP 1.0078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.06600472) (m := (0:ℤ)) (ylo := 0.06600472) (yhi := 0.06600472)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0038) (q1 := 1.0078) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.00758559) (B := 0.01553948) (X := 0.06600472) (rho := 0.02286169)
    (clo := 0.99782247) (chi := 0.99782248) (C := 0.98748039) (h := 0.01251961)
    (by norm_num) (by norm_num) oscBlock1 vbpBr1.1 vbpBr2.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i2 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.0057677):ℝ) ≤ ∫ v in (vBP 1.0078)..(vBP 1.0118), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.11127659) (m := (0:ℤ)) (ylo := 0.11127659) (yhi := 0.11127659)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0078) (q1 := 1.0118) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.01553947) (B := 0.02346185) (X := 0.11127659) (rho := 0.02289587)
    (clo := 0.99381514) (chi := 0.99381515) (C := 0.98545963) (h := 0.01454037)
    (by norm_num) (by norm_num) oscBlock2 vbpBr2.1 vbpBr3.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i3 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00554846):ℝ) ≤ ∫ v in (vBP 1.0118)..(vBP 1.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.15749532) (m := (0:ℤ)) (ylo := 0.15749532) (yhi := 0.15749532)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0118) (q1 := 1.016) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.02346184) (B := 0.0317467) (X := 0.15749532) (rho := 0.02405613)
    (clo := 0.98762322) (chi := 0.98762323) (C := 0.98178354) (h := 0.01821646)
    (by norm_num) (by norm_num) oscBlock3 vbpBr3.1 vbpBr4.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i4 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00539232):ℝ) ≤ ∫ v in (vBP 1.016)..(vBP 1.0205), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.20632855) (m := (0:ℤ)) (ylo := 0.20632855) (yhi := 0.20632855)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.016) (q1 := 1.0205) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.03174669) (B := 0.04058541) (X := 0.20632855) (rho := 0.02576927)
    (clo := 0.97878967) (chi := 0.97878968) (C := 0.9765102) (h := 0.0234898)
    (by norm_num) (by norm_num) oscBlock4 vbpBr4.1 vbpBr5.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i5 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00481724):ℝ) ≤ ∫ v in (vBP 1.0205)..(vBP 1.025), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.25662562) (m := (0:ℤ)) (ylo := 0.25662562) (yhi := 0.25662562)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0205) (q1 := 1.025) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.0405854) (B := 0.04938523) (X := 0.25662562) (rho := 0.02579618)
    (clo := 0.96725196) (chi := 0.96725197) (C := 0.96725196) (h := 0.02579619)
    (by norm_num) (by norm_num) oscBlock5 vbpBr5.1 vbpBr6.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i6 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00470025):ℝ) ≤ ∫ v in (vBP 1.025)..(vBP 1.03), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.30947863) (m := (0:ℤ)) (ylo := 0.30947863) (yhi := 0.30947863)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.025) (q1 := 1.03) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.04938522) (B := 0.05911761) (X := 0.30947863) (rho := 0.02860021)
    (clo := 0.95249248) (chi := 0.95249249) (C := 0.95249248) (h := 0.02860022)
    (by norm_num) (by norm_num) oscBlock6 vbpBr6.1 vbpBr7.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i7 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00440522):ℝ) ≤ ∫ v in (vBP 1.03)..(vBP 1.0355), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.36761086) (m := (0:ℤ)) (ylo := 0.36761086) (yhi := 0.36761086)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.03) (q1 := 1.0355) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.0591176) (B := 0.06976881) (X := 0.36761086) (rho := 0.03137953)
    (clo := 0.93318863) (chi := 0.93318864) (C := 0.93318863) (h := 0.03137954)
    (by norm_num) (by norm_num) oscBlock7 vbpBr7.1 vbpBr8.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i8 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00395189):ℝ) ≤ ∫ v in (vBP 1.0355)..(vBP 1.0415), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.43094075) (m := (0:ℤ)) (ylo := 0.43094075) (yhi := 0.43094075)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0355) (q1 := 1.0415) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.0697688) (B := 0.08132397) (X := 0.43094075) (rho := 0.03413072)
    (clo := 0.90857317) (chi := 0.90857318) (C := 0.90857317) (h := 0.03413073)
    (by norm_num) (by norm_num) oscBlock8 vbpBr8.1 vbpBr9.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i9 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00336549):ℝ) ≤ ∫ v in (vBP 1.0415)..(vBP 1.048), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.49938054) (m := (0:ℤ)) (ylo := 0.49938054) (yhi := 0.49938054)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0415) (q1 := 1.048) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.08132396) (B := 0.09376718) (X := 0.49938054) (rho := 0.03685053)
    (clo := 0.87787937) (chi := 0.87787938) (C := 0.87787937) (h := 0.03685054)
    (by norm_num) (by norm_num) oscBlock9 vbpBr9.1 vbpBr10.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i10 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00269691):ℝ) ≤ ∫ v in (vBP 1.048)..(vBP 1.055), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.57283666) (m := (0:ℤ)) (ylo := 0.57283666) (yhi := 0.57283666)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.048) (q1 := 1.055) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.09376717) (B := 0.10708154) (X := 0.57283666) (rho := 0.0395359)
    (clo := 0.84036683) (chi := 0.84036684) (C := 0.84036683) (h := 0.03953591)
    (by norm_num) (by norm_num) oscBlock10 vbpBr10.1 vbpBr11.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i11 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00224166):ℝ) ≤ ∫ v in (vBP 1.055)..(vBP 1.064), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.65927801) (m := (0:ℤ)) (ylo := 0.65927801) (yhi := 0.65927801)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.055) (q1 := 1.064) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.10708153) (B := 0.12407079) (X := 0.65927801) (rho := 0.05025183)
    (clo := 0.79043468) (chi := 0.7904347) (C := 0.79043469) (h := 0.05025184)
    (by norm_num) (by norm_num) oscBlock11 vbpBr11.1 vbpBr12.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i12 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00146206):ℝ) ≤ ∫ v in (vBP 1.064)..(vBP 1.078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.78234715) (m := (0:ℤ)) (ylo := 0.78234715) (yhi := 0.78234715)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.064) (q1 := 1.078) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.12407078) (B := 0.15021495) (X := 0.78234715) (rho := 0.07669461)
    (clo := 0.70926087) (chi := 0.70926091) (C := 0.70926089) (h := 0.07669463)
    (by norm_num) (by norm_num) oscBlock12 vbpBr12.1 vbpBr13.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i13 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    (0.00020111:ℝ) ≤ ∫ v in (vBP 1.078)..(vBP 1.09), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.92000245) (m := (0:ℤ)) (ylo := 0.92000245) (yhi := 0.92000245)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.078) (q1 := 1.09) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.15021494) (B := 0.1723554) (X := 0.92000245) (rho := 0.065655)
    (clo := 0.6058182) (chi := 0.60581833) (C := 0.60581826) (h := 0.06565507)
    (by norm_num) (by norm_num) oscBlock13 vbpBr13.1 vbpBr14.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i14 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    (0.0007725:ℝ) ≤ ∫ v in (vBP 1.09)..(vBP 1.1), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.03519073) (m := (0:ℤ)) (ylo := 1.03519073) (yhi := 1.03519073)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.09) (q1 := 1.1) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.17235539) (B := 0.19062036) (X := 1.03519073) (rho := 0.05491947)
    (clo := 0.51036191) (chi := 0.51036231) (C := 0.51036211) (h := 0.05491967)
    (by norm_num) (by norm_num) oscBlock14 vbpBr14.1 vbpBr15.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i15 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    (0.00088133:ℝ) ≤ ∫ v in (vBP 1.1)..(vBP 1.109), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.13373111) (m := (0:ℤ)) (ylo := 1.13373111) (yhi := 1.13373111)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.1) (q1 := 1.109) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.19062035) (B := 0.20691742) (X := 1.13373111) (rho := 0.04957789)
    (clo := 0.42328237) (chi := 0.42328335) (C := 0.42328286) (h := 0.04957838)
    (by norm_num) (by norm_num) oscBlock15 vbpBr15.1 vbpBr16.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i16 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    (0.00077761:ℝ) ≤ ∫ v in (vBP 1.109)..(vBP 1.117), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.22118119) (m := (0:ℤ)) (ylo := 1.22118119) (yhi := 1.22118119)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.109) (q1 := 1.117) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.20691741) (B := 0.22129305) (X := 1.22118119) (rho := 0.04433845)
    (clo := 0.34253622) (chi := 0.34253827) (C := 0.34253724) (h := 0.04433948)
    (by norm_num) (by norm_num) oscBlock16 vbpBr16.1 vbpBr17.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i17 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    (0.00060053:ℝ) ≤ ∫ v in (vBP 1.117)..(vBP 1.124), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.29778824) (m := (0:ℤ)) (ylo := 1.29778824) (yhi := 1.29778824)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.117) (q1 := 1.124) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.22129304) (B := 0.23378751) (X := 1.29778824) (rho := 0.03918409)
    (clo := 0.26962928) (chi := 0.26963302) (C := 0.26963115) (h := 0.03918596)
    (by norm_num) (by norm_num) oscBlock17 vbpBr17.1 vbpBr18.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i18 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    (0.00045692:ℝ) ≤ ∫ v in (vBP 1.124)..(vBP 1.131), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.3688239) (m := (0:ℤ)) (ylo := 1.3688239) (yhi := 1.3688239)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.124) (q1 := 1.131) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.2337875) (B := 0.2462044) (X := 1.3688239) (rho := 0.03915752)
    (clo := 0.20060196) (chi := 0.20060833) (C := 0.20060514) (h := 0.03916071)
    (by norm_num) (by norm_num) oscBlock18 vbpBr18.1 vbpBr19.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i19 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    (0.00027153:ℝ) ≤ ∫ v in (vBP 1.131)..(vBP 1.138), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.43941992) (m := (0:ℤ)) (ylo := 1.43941992) (yhi := 1.43941992)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.131) (q1 := 1.138) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.24620439) (B := 0.25854468) (X := 1.43941992) (rho := 0.03913248)
    (clo := 0.13099864) (chi := 0.13100918) (C := 0.13100391) (h := 0.03913775)
    (by norm_num) (by norm_num) oscBlock19 vbpBr19.1 vbpBr20.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i20 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    (0.00005899:ℝ) ≤ ∫ v in (vBP 1.138)..(vBP 1.145), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.50958169) (m := (0:ℤ)) (ylo := 1.50958169) (yhi := 1.50958169)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.138) (q1 := 1.145) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.25854467) (B := 0.27080928) (X := 1.50958169) (rho := 0.03910889)
    (clo := 0.06117612) (chi := 0.06119307) (C := 0.06118459) (h := 0.03911737)
    (by norm_num) (by norm_num) oscBlock20 vbpBr20.1 vbpBr21.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i21 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00018234):ℝ) ≤ ∫ v in (vBP 1.145)..(vBP 1.152), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.57931449) (m := (0:ℤ)) (ylo := 0.00851816) (yhi := 0.00851817)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.145) (q1 := 1.152) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.27080927) (B := 0.28299913) (X := 1.57931449) (rho := 0.03908679)
    (clo := (-0.00851807)) (chi := (-0.00851805)) (C := (-0.00851806)) (h := 0.0390868)
    (by norm_num) (by norm_num) oscBlock21 vbpBr21.1 vbpBr22.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i22 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00045578):ℝ) ≤ ∫ v in (vBP 1.152)..(vBP 1.159), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.64862357) (m := (0:ℤ)) (ylo := 0.07782724) (yhi := 0.07782725)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.152) (q1 := 1.159) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.28299912) (B := 0.29511513) (X := 1.64862357) (rho := 0.03906609)
    (clo := (-0.07774871)) (chi := (-0.07774869)) (C := (-0.0777487)) (h := 0.0390661)
    (by norm_num) (by norm_num) oscBlock22 vbpBr22.1 vbpBr23.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i23 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00072891):ℝ) ≤ ∫ v in (vBP 1.159)..(vBP 1.166), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.71751404) (m := (0:ℤ)) (ylo := 0.14671771) (yhi := 0.14671772)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.159) (q1 := 1.166) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.29511512) (B := 0.30715818) (X := 1.71751404) (rho := 0.03904681)
    (clo := (-0.14619191)) (chi := (-0.14619189)) (C := (-0.1461919)) (h := 0.03904682)
    (by norm_num) (by norm_num) oscBlock23 vbpBr23.1 vbpBr24.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i24 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00099329):ℝ) ≤ ∫ v in (vBP 1.166)..(vBP 1.173), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.78599093) (m := (0:ℤ)) (ylo := 0.2151946) (yhi := 0.21519461)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.166) (q1 := 1.173) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.30715817) (B := 0.31912914) (X := 1.78599093) (rho := 0.03902885)
    (clo := (-0.21353756)) (chi := (-0.21353754)) (C := (-0.21353755)) (h := 0.03902886)
    (by norm_num) (by norm_num) oscBlock24 vbpBr24.1 vbpBr25.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i25 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00124147):ℝ) ≤ ∫ v in (vBP 1.173)..(vBP 1.18), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.85405916) (m := (0:ℤ)) (ylo := 0.28326283) (yhi := 0.28326284)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.173) (q1 := 1.18) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.31912913) (B := 0.33102888) (X := 1.85405916) (rho := 0.03901226)
    (clo := (-0.27948995)) (chi := (-0.27948993)) (C := (-0.27948994)) (h := 0.03901227)
    (by norm_num) (by norm_num) oscBlock25 vbpBr25.1 vbpBr26.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i26 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00146706):ℝ) ≤ ∫ v in (vBP 1.18)..(vBP 1.187), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.92172362) (m := (0:ℤ)) (ylo := 0.35092729) (yhi := 0.3509273)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.18) (q1 := 1.187) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.33102887) (B := 0.34285824) (X := 1.92172362) (rho := 0.03899695)
    (clo := (-0.34376875)) (chi := (-0.34376873)) (C := (-0.34376874)) (h := 0.03899696)
    (by norm_num) (by norm_num) oscBlock26 vbpBr26.1 vbpBr27.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i27 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.0016648):ℝ) ≤ ∫ v in (vBP 1.187)..(vBP 1.194), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.98898904) (m := (0:ℤ)) (ylo := 0.41819271) (yhi := 0.41819272)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.187) (q1 := 1.194) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.34285823) (B := 0.35461804) (X := 1.98898904) (rho := 0.03898288)
    (clo := (-0.40610959)) (chi := (-0.40610957)) (C := (-0.40610958)) (h := 0.03898289)
    (by norm_num) (by norm_num) oscBlock27 vbpBr27.1 vbpBr28.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i28 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00184937):ℝ) ≤ ∫ v in (vBP 1.194)..(vBP 1.201), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.05586004) (m := (0:ℤ)) (ylo := 0.48506371) (yhi := 0.48506372)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.194) (q1 := 1.201) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.35461802) (B := 0.36630909) (X := 2.05586004) (rho := 0.03897007)
    (clo := (-0.46626473)) (chi := (-0.46626472)) (C := (-0.46626473)) (h := 0.03897008)
    (by norm_num) (by norm_num) oscBlock28 vbpBr28.1 vbpBr29.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i29 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00198197):ℝ) ≤ ∫ v in (vBP 1.201)..(vBP 1.208), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.12234133) (m := (0:ℤ)) (ylo := 0.551545) (yhi := 0.55154501)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.201) (q1 := 1.208) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.36630908) (B := 0.3779322) (X := 2.12234133) (rho := 0.03895845)
    (clo := (-0.52400377)) (chi := (-0.52400375)) (C := (-0.52400376)) (h := 0.03895846)
    (by norm_num) (by norm_num) oscBlock29 vbpBr29.1 vbpBr30.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i30 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.0020775):ℝ) ≤ ∫ v in (vBP 1.208)..(vBP 1.215), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.18843737) (m := (0:ℤ)) (ylo := 0.61764104) (yhi := 0.61764105)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.208) (q1 := 1.215) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.37793219) (B := 0.38948816) (X := 2.18843737) (rho := 0.03894806)
    (clo := (-0.57911365)) (chi := (-0.57911363)) (C := (-0.57911364)) (h := 0.03894807)
    (by norm_num) (by norm_num) oscBlock30 vbpBr30.1 vbpBr31.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i31 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00245997):ℝ) ≤ ∫ v in (vBP 1.215)..(vBP 1.223), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.25883053) (m := (0:ℤ)) (ylo := 0.6880342) (yhi := 0.68803421)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.215) (q1 := 1.223) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.38948815) (B := 0.40261372) (X := 2.25883053) (rho := 0.04361669)
    (clo := (-0.63501985)) (chi := (-0.63501983)) (C := (-0.63501984)) (h := 0.0436167)
    (by norm_num) (by norm_num) oscBlock31 vbpBr31.1 vbpBr32.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i32 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00247762):ℝ) ≤ ∫ v in (vBP 1.223)..(vBP 1.231), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.33344253) (m := (0:ℤ)) (ylo := 0.7626462) (yhi := 0.76264621)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.223) (q1 := 1.231) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.40261371) (B := 0.4156537) (X := 2.33344253) (rho := 0.04357708)
    (clo := (-0.69083711)) (chi := (-0.69083709)) (C := (-0.6908371)) (h := 0.04357709)
    (by norm_num) (by norm_num) oscBlock32 vbpBr32.1 vbpBr33.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i33 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00244091):ℝ) ≤ ∫ v in (vBP 1.231)..(vBP 1.239), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.40756964) (m := (0:ℤ)) (ylo := 0.83677331) (yhi := 0.83677332)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.231) (q1 := 1.239) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.41565369) (B := 0.42860921) (X := 2.40756964) (rho := 0.04353929)
    (clo := (-0.74248557)) (chi := (-0.74248555)) (C := (-0.74248556)) (h := 0.0435393)
    (by norm_num) (by norm_num) oscBlock33 vbpBr33.1 vbpBr34.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i34 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00265403):ℝ) ≤ ∫ v in (vBP 1.239)..(vBP 1.248), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.48580229) (m := (0:ℤ)) (ylo := 0.91500596) (yhi := 0.91500597)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.239) (q1 := 1.248) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.4286092) (B := 0.44308455) (X := 2.48580229) (rho := 0.04808749)
    (clo := (-0.79256624)) (chi := (-0.79256622)) (C := (-0.79256623)) (h := 0.0480875)
    (by norm_num) (by norm_num) oscBlock34 vbpBr34.1 vbpBr35.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i35 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00275309):ℝ) ≤ ∫ v in (vBP 1.248)..(vBP 1.258), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.5726072) (m := (0:ℤ)) (ylo := 1.00181087) (yhi := 1.00181088)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.248) (q1 := 1.258) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.44308453) (B := 0.45904632) (X := 2.5726072) (rho := 0.05256395)
    (clo := (-0.84244806)) (chi := (-0.84244802)) (C := (-0.84244804)) (h := 0.05256397)
    (by norm_num) (by norm_num) oscBlock35 vbpBr35.1 vbpBr36.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i36 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00248979):ℝ) ≤ ∫ v in (vBP 1.258)..(vBP 1.268), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.66327786) (m := (0:ℤ)) (ylo := 1.09248153) (yhi := 1.09248154)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.258) (q1 := 1.268) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.45904631) (B := 0.47488172) (X := 2.66327786) (rho := 0.05245199)
    (clo := (-0.88777193)) (chi := (-0.88777185)) (C := (-0.88777189)) (h := 0.05245203)
    (by norm_num) (by norm_num) oscBlock36 vbpBr36.1 vbpBr37.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i37 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00258482):ℝ) ≤ ∫ v in (vBP 1.268)..(vBP 1.28), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.76217594) (m := (0:ℤ)) (ylo := 1.19137961) (yhi := 1.19137962)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.268) (q1 := 1.28) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.4748817) (B := 0.49372017) (X := 2.76217594) (rho := 0.06128629)
    (clo := (-0.92888101)) (chi := (-0.92888082)) (C := (-0.92888092)) (h := 0.06128639)
    (by norm_num) (by norm_num) oscBlock37 vbpBr37.1 vbpBr38.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i38 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.0022862):ℝ) ≤ ∫ v in (vBP 1.28)..(vBP 1.294), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.877957) (m := (0:ℤ)) (ylo := 1.30716067) (yhi := 1.30716068)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.28) (q1 := 1.294) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.49372014) (B := 0.51547641) (X := 2.877957) (rho := 0.06992373)
    (clo := (-0.96544942)) (chi := (-0.96544893)) (C := (-0.9477626)) (h := 0.0522374)
    (by norm_num) (by norm_num) oscBlock38 vbpBr38.1 vbpBr39.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i39 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00152769):ℝ) ≤ ∫ v in (vBP 1.294)..(vBP 1.308), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.00136612) (m := (0:ℤ)) (ylo := 1.43056979) (yhi := 1.4305698)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.294) (q1 := 1.308) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.51547638) (B := 0.53699853) (X := 3.00136612) (rho := 0.06959423)
    (clo := (-0.99018564)) (chi := (-0.99018434)) (C := (-0.96029506)) (h := 0.03970495)
    (by norm_num) (by norm_num) oscBlock39 vbpBr39.1 vbpBr40.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i40 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00099396):ℝ) ≤ ∫ v in (vBP 1.308)..(vBP 1.326), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.14073144) (m := (0:ℤ)) (ylo := 1.56993511) (yhi := 1.56993512)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.308) (q1 := 1.326) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.53699848) (B := 0.56433382) (X := 3.14073144) (rho := 0.0865526)
    (clo := (-1.00000316)) (chi := (-0.99999957)) (C := (-0.95672349)) (h := 0.04327652)
    (by norm_num) (by norm_num) oscBlock40 vbpBr40.1 vbpBr41.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i41 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    (0.00002274:ℝ) ≤ ∫ v in (vBP 1.326)..(vBP 1.345), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.29982748) (m := (0:ℤ)) (ylo := 0.15823482) (yhi := 0.15823483)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.326) (q1 := 1.345) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.56433374) (B := 0.59278808) (X := 3.29982748) (rho := 0.09017936)
    (clo := (-0.98750698)) (chi := (-0.98750696)) (C := (-0.9486638)) (h := 0.0513362)
    (by norm_num) (by norm_num) oscBlock41 vbpBr41.1 vbpBr42.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i42 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    (0.00090203:ℝ) ≤ ∫ v in (vBP 1.345)..(vBP 1.362), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.45257287) (m := (0:ℤ)) (ylo := 0.31098021) (yhi := 0.31098022)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.345) (q1 := 1.362) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.59278796) (B := 0.6179085) (X := 3.45257287) (rho := 0.08109137)
    (clo := (-0.9520341)) (chi := (-0.95203408)) (C := (-0.93547136)) (h := 0.06452865)
    (by norm_num) (by norm_num) oscBlock42 vbpBr42.1 vbpBr43.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i43 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    (0.00105019:ℝ) ≤ ∫ v in (vBP 1.362)..(vBP 1.376), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.58249195) (m := (0:ℤ)) (ylo := 0.44089929) (yhi := 0.4408993)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.362) (q1 := 1.376) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.61790831) (B := 0.6383616) (X := 3.58249195) (rho := 0.06813846)
    (clo := (-0.90436826)) (chi := (-0.90436825)) (C := (-0.90436826)) (h := 0.06813847)
    (by norm_num) (by norm_num) oscBlock43 vbpBr43.1 vbpBr44.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i44 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    (0.0011598:ℝ) ≤ ∫ v in (vBP 1.376)..(vBP 1.39), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.69854633) (m := (0:ℤ)) (ylo := 0.55695367) (yhi := 0.55695368)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.376) (q1 := 1.39) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.63836133) (B := 0.65860767) (X := 3.69854633) (rho := 0.06786629)
    (clo := (-0.84886935)) (chi := (-0.84886934)) (C := (-0.84886935)) (h := 0.0678663)
    (by norm_num) (by norm_num) oscBlock44 vbpBr44.1 vbpBr45.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i45 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    (0.0011425:ℝ) ≤ ∫ v in (vBP 1.39)..(vBP 1.404), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.81343178) (m := (0:ℤ)) (ylo := 0.67183912) (yhi := 0.67183913)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.39) (q1 := 1.404) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.65860729) (B := 0.67865086) (X := 3.81343178) (rho := 0.06760284)
    (clo := (-0.78267828)) (chi := (-0.78267826)) (C := (-0.78267827)) (h := 0.06760285)
    (by norm_num) (by norm_num) oscBlock45 vbpBr45.1 vbpBr46.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i46 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    (0.00102453:ℝ) ≤ ∫ v in (vBP 1.404)..(vBP 1.418), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.92717155) (m := (0:ℤ)) (ylo := 0.78557889) (yhi := 0.7855789)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.404) (q1 := 1.418) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.67865033) (B := 0.69849519) (X := 3.92717155) (rho := 0.06734782)
    (clo := (-0.70697901)) (chi := (-0.70697896)) (C := (-0.70697899)) (h := 0.06734785)
    (by norm_num) (by norm_num) oscBlock46 vbpBr46.1 vbpBr47.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i47 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    (0.0008376:ℝ) ≤ ∫ v in (vBP 1.418)..(vBP 1.432), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.03978833) (m := (0:ℤ)) (ylo := 0.89819567) (yhi := 0.89819568)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.418) (q1 := 1.432) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.69849446) (B := 0.7181446) (X := 4.03978833) (rho := 0.06710111)
    (clo := (-0.62302243)) (chi := (-0.62302232)) (C := (-0.62302238)) (h := 0.06710117)
    (by norm_num) (by norm_num) oscBlock47 vbpBr47.1 vbpBr48.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i48 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    (0.00061471:ℝ) ≤ ∫ v in (vBP 1.432)..(vBP 1.446), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.15130404) (m := (0:ℤ)) (ylo := 1.00971138) (yhi := 1.00971139)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.432) (q1 := 1.446) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.7181436) (B := 0.73760286) (X := 4.15130404) (rho := 0.06686233)
    (clo := (-0.53210542)) (chi := (-0.5321051)) (C := (-0.53210526)) (h := 0.06686249)
    (by norm_num) (by norm_num) oscBlock48 vbpBr48.1 vbpBr49.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i49 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    (0.00040655:ℝ) ≤ ∫ v in (vBP 1.446)..(vBP 1.462), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.26956871) (m := (0:ℤ)) (ylo := 1.12797605) (yhi := 1.12797606)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.446) (q1 := 1.462) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.73760153) (B := 0.75961158) (X := 4.26956871) (rho := 0.07446003)
    (clo := (-0.42849033)) (chi := (-0.4284894)) (C := (-0.42848987)) (h := 0.0744605)
    (by norm_num) (by norm_num) oscBlock49 vbpBr49.1 vbpBr50.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i50 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00027896):ℝ) ≤ ∫ v in (vBP 1.462)..(vBP 1.478), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.39440092) (m := (0:ℤ)) (ylo := 1.25280826) (yhi := 1.25280827)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.462) (q1 := 1.478) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.75960973) (B := 0.78138081) (X := 4.39440092) (rho := 0.0741206)
    (clo := (-0.31265873)) (chi := (-0.31265608)) (C := (-0.31265741)) (h := 0.07412193)
    (by norm_num) (by norm_num) oscBlock50 vbpBr50.1 vbpBr51.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i51 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00036088):ℝ) ≤ ∫ v in (vBP 1.478)..(vBP 1.495), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.52170835) (m := (0:ℤ)) (ylo := 1.38011569) (yhi := 1.3801157)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.478) (q1 := 1.495) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.7813783) (B := 0.80425401) (X := 4.52170835) (rho := 0.07761928)
    (clo := (-0.18953405)) (chi := (-0.18952713)) (C := (-0.18953059)) (h := 0.07762274)
    (by norm_num) (by norm_num) oscBlock51 vbpBr51.1 vbpBr52.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i52 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00020831):ℝ) ≤ ∫ v in (vBP 1.495)..(vBP 1.512), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.65141527) (m := (0:ℤ)) (ylo := 1.50982261) (yhi := 1.50982262)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.495) (q1 := 1.512) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.80425056) (B := 0.82686872) (X := 4.65141527) (rho := 0.07724023)
    (clo := (-0.06095262)) (chi := (-0.06093564)) (C := (-0.06094413)) (h := 0.07724872)
    (by norm_num) (by norm_num) oscBlock52 vbpBr52.1 vbpBr53.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i53 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00031469):ℝ) ≤ ∫ v in (vBP 1.512)..(vBP 1.531), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.78713956) (m := (0:ℤ)) (ylo := 0.07475057) (yhi := 0.07475058)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.512) (q1 := 1.531) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.82686405) (B := 0.85184522) (X := 4.78713956) (rho := 0.0843503)
    (clo := 0.07468097) (chi := 0.07468099) (C := 0.07468098) (h := 0.08435031)
    (by norm_num) (by norm_num) oscBlock53 vbpBr53.1 vbpBr54.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i54 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00054108):ℝ) ≤ ∫ v in (vBP 1.531)..(vBP 1.55), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.92869852) (m := (0:ℤ)) (ylo := 0.21630953) (yhi := 0.21630954)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.531) (q1 := 1.55) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.85183877) (B := 0.87651393) (X := 4.92869852) (rho := 0.08386553)
    (clo := 0.21462662) (chi := 0.21462664) (C := 0.21462663) (h := 0.08386554)
    (by norm_num) (by norm_num) oscBlock54 vbpBr54.1 vbpBr55.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i55 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00076791):ℝ) ≤ ∫ v in (vBP 1.55)..(vBP 1.57), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.07216606) (m := (0:ℤ)) (ylo := 0.35977707) (yhi := 0.35977708)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.55) (q1 := 1.57) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.87650515) (B := 0.90215678) (X := 5.07216606) (rho := 0.08704304)
    (clo := 0.35206558) (chi := 0.3520656) (C := 0.35206559) (h := 0.08704305)
    (by norm_num) (by norm_num) oscBlock55 vbpBr55.1 vbpBr56.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i56 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.0009121):ℝ) ≤ ∫ v in (vBP 1.57)..(vBP 1.59), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.2174745) (m := (0:ℤ)) (ylo := 0.50508551) (yhi := 0.50508552)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.57) (q1 := 1.59) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.90214481) (B := 0.92747548) (X := 5.2174745) (rho := 0.08652591)
    (clo := 0.48388227) (chi := 0.48388229) (C := 0.48388228) (h := 0.08652592)
    (by norm_num) (by norm_num) oscBlock56 vbpBr56.1 vbpBr57.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i57 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.0010103):ℝ) ≤ ∫ v in (vBP 1.59)..(vBP 1.61), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.36095513) (m := (0:ℤ)) (ylo := 0.64856614) (yhi := 0.64856615)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.59) (q1 := 1.61) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.92745939) (B := 0.95247825) (X := 5.36095513) (rho := 0.08602987)
    (clo := 0.60404431) (chi := 0.60404432) (C := 0.60404431) (h := 0.08602988)
    (by norm_num) (by norm_num) oscBlock57 vbpBr57.1 vbpBr58.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i58 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00120571):ℝ) ≤ ∫ v in (vBP 1.61)..(vBP 1.632), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.50966691) (m := (0:ℤ)) (ylo := 0.79727792) (yhi := 0.79727793)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.61) (q1 := 1.632) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.95245689) (B := 0.97962584) (X := 5.50966691) (rho := 0.09256837)
    (clo := 0.71545694) (chi := 0.71545696) (C := 0.71545695) (h := 0.09256838)
    (by norm_num) (by norm_num) oscBlock58 vbpBr58.1 vbpBr59.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i59 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00137536):ℝ) ≤ ∫ v in (vBP 1.632)..(vBP 1.656), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.6703475) (m := (0:ℤ)) (ylo := 0.95795851) (yhi := 0.95795852)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.632) (q1 := 1.656) (t0 := 5.6875) (t1 := 5.71875)
    (A := 0.97959707) (B := 1.00882827) (X := 5.6703475) (rho := 0.09888918)
    (clo := 0.81801902) (chi := 0.81801905) (C := 0.81801903) (h := 0.0988892)
    (by norm_num) (by norm_num) oscBlock59 vbpBr59.1 vbpBr60.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i60 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00135561):ℝ) ≤ ∫ v in (vBP 1.656)..(vBP 1.68), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.83566561) (m := (0:ℤ)) (ylo := 1.12327662) (yhi := 1.12327663)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.656) (q1 := 1.68) (t0 := 5.6875) (t1 := 5.71875)
    (A := 1.00878907) (B := 1.03761196) (X := 5.83566561) (rho := 0.0981778)
    (clo := 0.90152317) (chi := 0.90152327) (C := 0.90152322) (h := 0.09817785)
    (by norm_num) (by norm_num) oscBlock60 vbpBr60.1 vbpBr61.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i61 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00122808):ℝ) ≤ ∫ v in (vBP 1.68)..(vBP 1.704), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.99862207) (m := (0:ℤ)) (ylo := 1.28623308) (yhi := 1.28623309)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.68) (q1 := 1.704) (t0 := 5.6875) (t1 := 5.71875)
    (A := 1.03755935) (B := 1.06598913) (X := 5.99862207) (rho := 0.09750328)
    (clo := 0.95978435) (chi := 0.95978476) (C := 0.93114053) (h := 0.06885947)
    (by norm_num) (by norm_num) oscBlock61 vbpBr61.1 vbpBr62.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i62 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00137159):ℝ) ≤ ∫ v in (vBP 1.704)..(vBP 1.734), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.17911387) (m := (0:ℤ)) (ylo := 1.46672488) (yhi := 1.46672489)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.704) (q1 := 1.734) (t0 := 5.6875) (t1 := 5.71875)
    (A := 1.06591948) (B := 1.10090679) (X := 6.17911387) (rho := 0.11669685)
    (clo := 0.99458942) (chi := 0.99459113) (C := 0.93894628) (h := 0.06105372)
    (by norm_num) (by norm_num) oscBlock62 vbpBr62.1 vbpBr63.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i63 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00129873):ℝ) ≤ ∫ v in (vBP 1.734)..(vBP 1.766), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.38295832) (m := (1:ℤ)) (ylo := 0.09977301) (yhi := 0.09977302)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.734) (q1 := 1.766) (t0 := 5.6875) (t1 := 5.71875)
    (A := 1.10080961) (B := 1.13749718) (X := 6.38295832) (rho := 0.12210369)
    (clo := 0.99502679) (chi := 0.99502681) (C := 0.93646155) (h := 0.06353845)
    (by norm_num) (by norm_num) oscBlock63 vbpBr63.1 vbpBr64.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i64 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00107612):ℝ) ≤ ∫ v in (vBP 1.766)..(vBP 1.796), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.58329615) (m := (1:ℤ)) (ylo := 0.30011084) (yhi := 0.30011085)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.766) (q1 := 1.796) (t0 := 5.6875) (t1 := 5.71875)
    (A := 1.1373613) (B := 1.17120873) (X := 6.58329615) (rho := 0.11455378)
    (clo := 0.95530372) (chi := 0.95530373) (C := 0.92037497) (h := 0.07962503)
    (by norm_num) (by norm_num) oscBlock64 vbpBr64.1 vbpBr65.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i65 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00105368):ℝ) ≤ ∫ v in (vBP 1.796)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.7801106) (m := (1:ℤ)) (ylo := 0.49692529) (yhi := 0.4969253)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.796) (q1 := 1.828) (t0 := 5.6875) (t1 := 5.71875)
    (A := 1.1710258) (B := 1.20655947) (X := 6.7801106) (rho := 0.11990138)
    (clo := 0.8790525) (chi := 0.87905251) (C := 0.8790525) (h := 0.11990139)
    (by norm_num) (by norm_num) oscBlock65 vbpBr65.1 vbpBr66.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i66 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00085557):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.86), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.97980817) (m := (1:ℤ)) (ylo := 0.69662286) (yhi := 0.69662287)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.828) (q1 := 1.86) (t0 := 5.6875) (t1 := 5.71875)
    (A := 1.20631244) (B := 1.24130524) (X := 6.97980817) (rho := 0.11890618)
    (clo := 0.76701342) (chi := 0.76701345) (C := 0.76701343) (h := 0.1189062)
    (by norm_num) (by norm_num) oscBlock66 vbpBr66.1 vbpBr67.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i67 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00059815):ℝ) ≤ ∫ v in (vBP 1.86)..(vBP 1.89), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.17001287) (m := (1:ℤ)) (ylo := 0.88682756) (yhi := 0.88682757)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.86) (q1 := 1.89) (t0 := 5.6875) (t1 := 5.71875)
    (A := 1.24097685) (B := 1.27334993) (X := 7.17001287) (rho := 0.11195705)
    (clo := 0.63187406) (chi := 0.63187416) (C := 0.63187411) (h := 0.1119571)
    (by norm_num) (by norm_num) oscBlock67 vbpBr67.1 vbpBr68.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i68 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00046036):ℝ) ≤ ∫ v in (vBP 1.89)..(vBP 1.922), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.35705017) (m := (1:ℤ)) (ylo := 1.07386486) (yhi := 1.07386487)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.89) (q1 := 1.922) (t0 := 5.6875) (t1 := 5.71875)
    (A := 1.27292668) (B := 1.30698664) (X := 7.35705017) (rho := 0.11727969)
    (clo := 0.47673038) (chi := 0.47673096) (C := 0.47673067) (h := 0.11727998)
    (by norm_num) (by norm_num) oscBlock68 vbpBr68.1 vbpBr69.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i69 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00041788):ℝ) ≤ ∫ v in (vBP 1.922)..(vBP 1.969), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.59082407) (m := (1:ℤ)) (ylo := 1.30763876) (yhi := 1.30763877)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.922) (q1 := 1.969) (t0 := 5.6875) (t1 := 5.71875)
    (A := 1.30643896) (B := 1.35541448) (X := 7.59082407) (rho := 0.1604525)
    (clo := 0.26013064) (chi := 0.26013469) (C := 0.26013266) (h := 0.16045453)
    (by norm_num) (by norm_num) oscBlock69 vbpBr69.1 vbpBr70.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i70 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00014758):ℝ) ≤ ∫ v in (vBP 1.969)..(vBP 2.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 7.86318631) (m := (1:ℤ)) (ylo := 0.00920467) (yhi := 0.00920468)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.969) (q1 := 2.016) (t0 := 5.6875) (t1 := 5.71875)
    (A := 1.35463226) (B := 1.4027369) (X := 7.86318631) (rho := 0.15871535)
    (clo := (-0.00920456)) (chi := (-0.00920454)) (C := (-0.00920455)) (h := 0.15871536)
    (by norm_num) (by norm_num) oscBlock70 vbpBr70.1 vbpBr71.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i71 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00033312):ℝ) ≤ ∫ v in (vBP 2.016)..(vBP 2.062), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.1264189) (m := (1:ℤ)) (ylo := 0.27243726) (yhi := 0.27243727)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.016) (q1 := 2.062) (t0 := 5.6875) (t1 := 5.71875)
    (A := 1.40164597) (B := 1.44803958) (X := 8.1264189) (rho := 0.15455746)
    (clo := (-0.26907962)) (chi := (-0.2690796)) (C := (-0.26907961)) (h := 0.15455747)
    (by norm_num) (by norm_num) oscBlock71 vbpBr71.1 vbpBr72.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB20i72 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.00029892):ℝ) ≤ ∫ v in (vBP 2.062)..(vBP 2.094), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.34264746) (m := (1:ℤ)) (ylo := 0.48866582) (yhi := 0.48866583)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.062) (q1 := 2.094) (t0 := 5.6875) (t1 := 5.71875)
    (A := 1.44655973) (B := 1.47899217) (X := 8.34264746) (rho := 0.11533902)
    (clo := (-0.46944829)) (chi := (-0.46944827)) (C := (-0.46944828)) (h := 0.11533903)
    (by norm_num) (by norm_num) oscBlock72 vbpBr72.1 vbpBr73.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

/-- Lower bound for the oscillatory integral `∫₀^∞ err(v) cos(tv) dv` on the band
`5.6875 ≤ t ≤ 5.71875`. -/
theorem oscBandLower20 {t : ℝ} (ht0 : (5.6875:ℝ) ≤ t) (ht1 : t ≤ 5.71875) :
    ((-0.11233569):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosB20i0 ht0 ht1)
    (cosB20i1 ht0 ht1))
    (cosB20i2 ht0 ht1))
    (cosB20i3 ht0 ht1))
    (cosB20i4 ht0 ht1))
    (cosB20i5 ht0 ht1))
    (cosB20i6 ht0 ht1))
    (cosB20i7 ht0 ht1))
    (cosB20i8 ht0 ht1))
    (cosB20i9 ht0 ht1))
    (cosB20i10 ht0 ht1))
    (cosB20i11 ht0 ht1))
    (cosB20i12 ht0 ht1))
    (cosB20i13 ht0 ht1))
    (cosB20i14 ht0 ht1))
    (cosB20i15 ht0 ht1))
    (cosB20i16 ht0 ht1))
    (cosB20i17 ht0 ht1))
    (cosB20i18 ht0 ht1))
    (cosB20i19 ht0 ht1))
    (cosB20i20 ht0 ht1))
    (cosB20i21 ht0 ht1))
    (cosB20i22 ht0 ht1))
    (cosB20i23 ht0 ht1))
    (cosB20i24 ht0 ht1))
    (cosB20i25 ht0 ht1))
    (cosB20i26 ht0 ht1))
    (cosB20i27 ht0 ht1))
    (cosB20i28 ht0 ht1))
    (cosB20i29 ht0 ht1))
    (cosB20i30 ht0 ht1))
    (cosB20i31 ht0 ht1))
    (cosB20i32 ht0 ht1))
    (cosB20i33 ht0 ht1))
    (cosB20i34 ht0 ht1))
    (cosB20i35 ht0 ht1))
    (cosB20i36 ht0 ht1))
    (cosB20i37 ht0 ht1))
    (cosB20i38 ht0 ht1))
    (cosB20i39 ht0 ht1))
    (cosB20i40 ht0 ht1))
    (cosB20i41 ht0 ht1))
    (cosB20i42 ht0 ht1))
    (cosB20i43 ht0 ht1))
    (cosB20i44 ht0 ht1))
    (cosB20i45 ht0 ht1))
    (cosB20i46 ht0 ht1))
    (cosB20i47 ht0 ht1))
    (cosB20i48 ht0 ht1))
    (cosB20i49 ht0 ht1))
    (cosB20i50 ht0 ht1))
    (cosB20i51 ht0 ht1))
    (cosB20i52 ht0 ht1))
    (cosB20i53 ht0 ht1))
    (cosB20i54 ht0 ht1))
    (cosB20i55 ht0 ht1))
    (cosB20i56 ht0 ht1))
    (cosB20i57 ht0 ht1))
    (cosB20i58 ht0 ht1))
    (cosB20i59 ht0 ht1))
    (cosB20i60 ht0 ht1))
    (cosB20i61 ht0 ht1))
    (cosB20i62 ht0 ht1))
    (cosB20i63 ht0 ht1))
    (cosB20i64 ht0 ht1))
    (cosB20i65 ht0 ht1))
    (cosB20i66 ht0 ht1))
    (cosB20i67 ht0 ht1))
    (cosB20i68 ht0 ht1))
    (cosB20i69 ht0 ht1))
    (cosB20i70 ht0 ht1))
    (cosB20i71 ht0 ht1))
    (cosB20i72 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 2.094) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 2.094) (S := 0.013709)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_cut
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
