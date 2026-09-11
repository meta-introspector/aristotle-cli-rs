/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscTail

/-!
# Oscillatory lower bound on the band `6.5 ≤ t ≤ 6.625`

On each of the 73 blocks the factor `cos(tv)` is bracketed by a rational constant
`C` up to a rational error `h`; the signed contribution `min(C·P₀, C·P₁) - h·S` is
then summed, and the unresolved tail beyond `q = 2.094` is estimated in absolute
value.  The result is the bound `∫₀^∞ err(v) cos(tv) dv ≥ -0.14305258`.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosB6i0 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00641868):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.0038), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.0251273) (m := (0:ℤ)) (ylo := 0.0251273) (yhi := 0.0251273)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1) (q1 := 1.0038) (t0 := 6.5) (t1 := 6.625)
    (A := 0.0) (B := 0.0075856) (X := 0.0251273) (rho := 0.02512731)
    (clo := 0.99968432) (chi := 0.99968433) (C := 0.9872785) (h := 0.0127215)
    (by norm_num) (by norm_num) oscBlock0 vbpBr0.1 vbpBr1.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i1 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00625872):ℝ) ≤ ∫ v in (vBP 1.0038)..(vBP 1.0078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.07612769) (m := (0:ℤ)) (ylo := 0.07612769) (yhi := 0.07612769)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0038) (q1 := 1.0078) (t0 := 6.5) (t1 := 6.625)
    (A := 0.00758559) (B := 0.01553948) (X := 0.07612769) (rho := 0.02682137)
    (clo := 0.99710368) (chi := 0.99710369) (C := 0.98514115) (h := 0.01485885)
    (by norm_num) (by norm_num) oscBlock1 vbpBr1.1 vbpBr2.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i2 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.0057677):ℝ) ≤ ∫ v in (vBP 1.0078)..(vBP 1.0118), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.12822065) (m := (0:ℤ)) (ylo := 0.12822065) (yhi := 0.12822065)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0078) (q1 := 1.0118) (t0 := 6.5) (t1 := 6.625)
    (A := 0.01553947) (B := 0.02346185) (X := 0.12822065) (rho := 0.02721412)
    (clo := 0.99179098) (chi := 0.99179099) (C := 0.98228843) (h := 0.01771157)
    (by norm_num) (by norm_num) oscBlock2 vbpBr2.1 vbpBr3.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i3 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00554846):ℝ) ≤ ∫ v in (vBP 1.0118)..(vBP 1.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.18141192) (m := (0:ℤ)) (ylo := 0.18141192) (yhi := 0.18141192)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0118) (q1 := 1.016) (t0 := 6.5) (t1 := 6.625)
    (A := 0.02346184) (B := 0.0317467) (X := 0.18141192) (rho := 0.02890998)
    (clo := 0.98358993) (chi := 0.98358994) (C := 0.97733997) (h := 0.02266003)
    (by norm_num) (by norm_num) oscBlock3 vbpBr3.1 vbpBr4.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i4 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00539232):ℝ) ≤ ∫ v in (vBP 1.016)..(vBP 1.0205), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.23761591) (m := (0:ℤ)) (ylo := 0.23761591) (yhi := 0.23761591)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.016) (q1 := 1.0205) (t0 := 6.5) (t1 := 6.625)
    (A := 0.03174669) (B := 0.04058541) (X := 0.23761591) (rho := 0.03126244)
    (clo := 0.97190191) (chi := 0.97190192) (C := 0.97031973) (h := 0.02968027)
    (by norm_num) (by norm_num) oscBlock4 vbpBr4.1 vbpBr5.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i5 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00479443):ℝ) ≤ ∫ v in (vBP 1.0205)..(vBP 1.025), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.29549112) (m := (0:ℤ)) (ylo := 0.29549112) (yhi := 0.29549112)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0205) (q1 := 1.025) (t0 := 6.5) (t1 := 6.625)
    (A := 0.0405854) (B := 0.04938523) (X := 0.29549112) (rho := 0.03168604)
    (clo := 0.95665923) (chi := 0.95665924) (C := 0.95665923) (h := 0.03168605)
    (by norm_num) (by norm_num) oscBlock5 vbpBr5.1 vbpBr6.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i6 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00465913):ℝ) ≤ ∫ v in (vBP 1.025)..(vBP 1.03), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.35632904) (m := (0:ℤ)) (ylo := 0.35632904) (yhi := 0.35632904)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.025) (q1 := 1.03) (t0 := 6.5) (t1 := 6.625)
    (A := 0.04938522) (B := 0.05911761) (X := 0.35632904) (rho := 0.03532513)
    (clo := 0.93718369) (chi := 0.9371837) (C := 0.93718369) (h := 0.03532514)
    (by norm_num) (by norm_num) oscBlock6 vbpBr6.1 vbpBr7.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i7 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00434206):ℝ) ≤ ∫ v in (vBP 1.03)..(vBP 1.0355), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.42324138) (m := (0:ℤ)) (ylo := 0.42324138) (yhi := 0.42324138)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.03) (q1 := 1.0355) (t0 := 6.5) (t1 := 6.625)
    (A := 0.0591176) (B := 0.06976881) (X := 0.42324138) (rho := 0.038977)
    (clo := 0.91176243) (chi := 0.91176244) (C := 0.91176243) (h := 0.03897701)
    (by norm_num) (by norm_num) oscBlock7 vbpBr7.1 vbpBr8.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i8 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00386537):ℝ) ≤ ∫ v in (vBP 1.0355)..(vBP 1.0415), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.49613425) (m := (0:ℤ)) (ylo := 0.49613425) (yhi := 0.49613425)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0355) (q1 := 1.0415) (t0 := 6.5) (t1 := 6.625)
    (A := 0.0697688) (B := 0.08132397) (X := 0.49613425) (rho := 0.04263707)
    (clo := 0.87942933) (chi := 0.87942934) (C := 0.87942933) (h := 0.04263708)
    (by norm_num) (by norm_num) oscBlock8 vbpBr8.1 vbpBr9.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i9 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00325811):ℝ) ≤ ∫ v in (vBP 1.0415)..(vBP 1.048), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.57490665) (m := (0:ℤ)) (ylo := 0.57490665) (yhi := 0.57490665)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.0415) (q1 := 1.048) (t0 := 6.5) (t1 := 6.625)
    (A := 0.08132396) (B := 0.09376718) (X := 0.57490665) (rho := 0.04630093)
    (clo := 0.83924306) (chi := 0.83924307) (C := 0.83924306) (h := 0.04630094)
    (by norm_num) (by norm_num) oscBlock9 vbpBr9.1 vbpBr10.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i10 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.0025755):ℝ) ≤ ∫ v in (vBP 1.048)..(vBP 1.055), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.6594509) (m := (0:ℤ)) (ylo := 0.6594509) (yhi := 0.6594509)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.048) (q1 := 1.055) (t0 := 6.5) (t1 := 6.625)
    (A := 0.09376717) (B := 0.10708154) (X := 0.6594509) (rho := 0.04996431)
    (clo := 0.79032877) (chi := 0.79032878) (C := 0.79032877) (h := 0.04996432)
    (by norm_num) (by norm_num) oscBlock10 vbpBr10.1 vbpBr11.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i11 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00210249):ℝ) ≤ ∫ v in (vBP 1.055)..(vBP 1.064), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.75899946) (m := (0:ℤ)) (ylo := 0.75899946) (yhi := 0.75899946)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.055) (q1 := 1.064) (t0 := 6.5) (t1 := 6.625)
    (A := 0.10708153) (B := 0.12407079) (X := 0.75899946) (rho := 0.06296953)
    (clo := 0.72552494) (chi := 0.72552496) (C := 0.72552495) (h := 0.06296954)
    (by norm_num) (by norm_num) oscBlock11 vbpBr11.1 vbpBr12.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i12 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00133067):ℝ) ≤ ∫ v in (vBP 1.064)..(vBP 1.078), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 0.90081705) (m := (0:ℤ)) (ylo := 0.90081705) (yhi := 0.90081705)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.064) (q1 := 1.078) (t0 := 6.5) (t1 := 6.625)
    (A := 0.12407078) (B := 0.15021495) (X := 0.90081705) (rho := 0.094357)
    (clo := 0.62096974) (chi := 0.62096984) (C := 0.62096979) (h := 0.09435705)
    (by norm_num) (by norm_num) oscBlock12 vbpBr12.1 vbpBr13.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i13 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    (0.00010859:ℝ) ≤ ∫ v in (vBP 1.078)..(vBP 1.09), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.05912581) (m := (0:ℤ)) (ylo := 1.05912581) (yhi := 1.05912581)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.078) (q1 := 1.09) (t0 := 6.5) (t1 := 6.625)
    (A := 0.15021494) (B := 0.1723554) (X := 1.05912581) (rho := 0.08272872)
    (clo := 0.48963449) (chi := 0.48963499) (C := 0.48963474) (h := 0.08272897)
    (by norm_num) (by norm_num) oscBlock13 vbpBr13.1 vbpBr14.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i14 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    (0.00047918:ℝ) ≤ ∫ v in (vBP 1.09)..(vBP 1.1), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.19158496) (m := (0:ℤ)) (ylo := 1.19158496) (yhi := 1.19158496)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.09) (q1 := 1.1) (t0 := 6.5) (t1 := 6.625)
    (A := 0.17235539) (B := 0.19062036) (X := 1.19158496) (rho := 0.07127494)
    (clo := 0.37018796) (chi := 0.37018956) (C := 0.37018876) (h := 0.07127574)
    (by norm_num) (by norm_num) oscBlock14 vbpBr14.1 vbpBr15.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i15 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    (0.00043984:ℝ) ≤ ∫ v in (vBP 1.1)..(vBP 1.109), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.30493009) (m := (0:ℤ)) (ylo := 1.30493009) (yhi := 1.30493009)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.1) (q1 := 1.109) (t0 := 6.5) (t1 := 6.625)
    (A := 0.19062035) (B := 0.20691742) (X := 1.30493009) (rho := 0.06589783)
    (clo := 0.26274511) (chi := 0.26274907) (C := 0.26274709) (h := 0.06589981)
    (by norm_num) (by norm_num) oscBlock15 vbpBr15.1 vbpBr16.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i16 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    (0.00024691:ℝ) ≤ ∫ v in (vBP 1.109)..(vBP 1.117), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.40551481) (m := (0:ℤ)) (ylo := 1.40551481) (yhi := 1.40551481)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.109) (q1 := 1.117) (t0 := 6.5) (t1 := 6.625)
    (A := 0.20691741) (B := 0.22129305) (X := 1.40551481) (rho := 0.06055166)
    (clo := 0.16452989) (chi := 0.16453819) (C := 0.16453404) (h := 0.06055581)
    (by norm_num) (by norm_num) oscBlock16 vbpBr16.1 vbpBr17.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i17 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    (0.00003309:ℝ) ≤ ∫ v in (vBP 1.117)..(vBP 1.124), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 1.4936235) (m := (0:ℤ)) (ylo := 1.4936235) (yhi := 1.4936235)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.117) (q1 := 1.124) (t0 := 6.5) (t1 := 6.625)
    (A := 0.22129304) (B := 0.23378751) (X := 1.4936235) (rho := 0.05521876)
    (clo := 0.07709599) (chi := 0.07711123) (C := 0.07710361) (h := 0.05522638)
    (by norm_num) (by norm_num) oscBlock17 vbpBr17.1 vbpBr18.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i18 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00020508):ℝ) ≤ ∫ v in (vBP 1.124)..(vBP 1.131), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.57536145) (m := (0:ℤ)) (ylo := 0.00456512) (yhi := 0.00456513)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.124) (q1 := 1.131) (t0 := 6.5) (t1 := 6.625)
    (A := 0.2337875) (B := 0.2462044) (X := 1.57536145) (rho := 0.05574271)
    (clo := (-0.00456512)) (chi := (-0.0045651)) (C := (-0.00456511)) (h := 0.05574272)
    (by norm_num) (by norm_num) oscBlock18 vbpBr18.1 vbpBr19.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i19 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00051141):ℝ) ≤ ∫ v in (vBP 1.131)..(vBP 1.138), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.65659352) (m := (0:ℤ)) (ylo := 0.08579719) (yhi := 0.0857972)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.131) (q1 := 1.138) (t0 := 6.5) (t1 := 6.625)
    (A := 0.24620439) (B := 0.25854468) (X := 1.65659352) (rho := 0.056265)
    (clo := (-0.08569198)) (chi := (-0.08569196)) (C := (-0.08569197)) (h := 0.05626501)
    (by norm_num) (by norm_num) oscBlock19 vbpBr19.1 vbpBr20.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i20 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00082867):ℝ) ≤ ∫ v in (vBP 1.138)..(vBP 1.145), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.73732591) (m := (0:ℤ)) (ylo := 0.16652958) (yhi := 0.16652959)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.138) (q1 := 1.145) (t0 := 6.5) (t1 := 6.625)
    (A := 0.25854467) (B := 0.27080928) (X := 1.73732591) (rho := 0.05678558)
    (clo := (-0.16576096)) (chi := (-0.16576094)) (C := (-0.16576095)) (h := 0.05678559)
    (by norm_num) (by norm_num) oscBlock20 vbpBr20.1 vbpBr21.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i21 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.0011551):ℝ) ≤ ∫ v in (vBP 1.145)..(vBP 1.152), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.81756474) (m := (0:ℤ)) (ylo := 0.24676841) (yhi := 0.24676842)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.145) (q1 := 1.152) (t0 := 6.5) (t1 := 6.625)
    (A := 0.27080927) (B := 0.28299913) (X := 1.81756474) (rho := 0.05730451)
    (clo := (-0.24427156)) (chi := (-0.24427154)) (C := (-0.24427155)) (h := 0.05730452)
    (by norm_num) (by norm_num) oscBlock21 vbpBr21.1 vbpBr22.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i22 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00147706):ℝ) ≤ ∫ v in (vBP 1.152)..(vBP 1.159), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.897316) (m := (0:ℤ)) (ylo := 0.32651967) (yhi := 0.32651968)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.152) (q1 := 1.159) (t0 := 6.5) (t1 := 6.625)
    (A := 0.28299912) (B := 0.29511513) (X := 1.897316) (rho := 0.05782174)
    (clo := (-0.32074855)) (chi := (-0.32074853)) (C := (-0.32074854)) (h := 0.05782175)
    (by norm_num) (by norm_num) oscBlock22 vbpBr22.1 vbpBr23.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i23 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00178287):ℝ) ≤ ∫ v in (vBP 1.159)..(vBP 1.166), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 1.97658561) (m := (0:ℤ)) (ylo := 0.40578928) (yhi := 0.40578929)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.159) (q1 := 1.166) (t0 := 6.5) (t1 := 6.625)
    (A := 0.29511512) (B := 0.30715818) (X := 1.97658561) (rho := 0.05833735)
    (clo := (-0.39474408)) (chi := (-0.39474406)) (C := (-0.39474407)) (h := 0.05833736)
    (by norm_num) (by norm_num) oscBlock23 vbpBr23.1 vbpBr24.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i24 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.0020635):ℝ) ≤ ∫ v in (vBP 1.166)..(vBP 1.173), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.05537932) (m := (0:ℤ)) (ylo := 0.48458299) (yhi := 0.484583)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.166) (q1 := 1.173) (t0 := 6.5) (t1 := 6.625)
    (A := 0.30715817) (B := 0.31912914) (X := 2.05537932) (rho := 0.05885124)
    (clo := (-0.46583941)) (chi := (-0.4658394)) (C := (-0.46583941)) (h := 0.05885125)
    (by norm_num) (by norm_num) oscBlock24 vbpBr24.1 vbpBr25.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i25 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00231145):ℝ) ≤ ∫ v in (vBP 1.173)..(vBP 1.18), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.13370283) (m := (0:ℤ)) (ylo := 0.5629065) (yhi := 0.56290651)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.173) (q1 := 1.18) (t0 := 6.5) (t1 := 6.625)
    (A := 0.31912913) (B := 0.33102888) (X := 2.13370283) (rho := 0.05936351)
    (clo := (-0.53364651)) (chi := (-0.53364649)) (C := (-0.5336465)) (h := 0.05936352)
    (by norm_num) (by norm_num) oscBlock25 vbpBr25.1 vbpBr26.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i26 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00252075):ℝ) ≤ ∫ v in (vBP 1.18)..(vBP 1.187), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.21156174) (m := (0:ℤ)) (ylo := 0.64076541) (yhi := 0.64076542)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.18) (q1 := 1.187) (t0 := 6.5) (t1 := 6.625)
    (A := 0.33102887) (B := 0.34285824) (X := 2.21156174) (rho := 0.05987411)
    (clo := (-0.59780921)) (chi := (-0.59780919)) (C := (-0.5978092)) (h := 0.05987412)
    (by norm_num) (by norm_num) oscBlock26 vbpBr26.1 vbpBr27.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i27 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00268702):ℝ) ≤ ∫ v in (vBP 1.187)..(vBP 1.194), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.2889615) (m := (0:ℤ)) (ylo := 0.71816517) (yhi := 0.71816518)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.187) (q1 := 1.194) (t0 := 6.5) (t1 := 6.625)
    (A := 0.34285823) (B := 0.35461804) (X := 2.2889615) (rho := 0.06038302)
    (clo := (-0.65800414)) (chi := (-0.65800412)) (C := (-0.65800413)) (h := 0.06038303)
    (by norm_num) (by norm_num) oscBlock27 vbpBr27.1 vbpBr28.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i28 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.0028362):ℝ) ≤ ∫ v in (vBP 1.194)..(vBP 1.201), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.36590742) (m := (0:ℤ)) (ylo := 0.79511109) (yhi := 0.7951111)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.194) (q1 := 1.201) (t0 := 6.5) (t1 := 6.625)
    (A := 0.35461802) (B := 0.36630909) (X := 2.36590742) (rho := 0.06089031)
    (clo := (-0.71394141)) (chi := (-0.71394139)) (C := (-0.7139414)) (h := 0.06089032)
    (by norm_num) (by norm_num) oscBlock28 vbpBr28.1 vbpBr29.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i29 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.0029107):ℝ) ≤ ∫ v in (vBP 1.201)..(vBP 1.208), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.44240492) (m := (0:ℤ)) (ylo := 0.87160859) (yhi := 0.8716086)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.201) (q1 := 1.208) (t0 := 6.5) (t1 := 6.625)
    (A := 0.36630908) (B := 0.3779322) (X := 2.44240492) (rho := 0.06139592)
    (clo := (-0.76536523)) (chi := (-0.7653652)) (C := (-0.76536522)) (h := 0.06139594)
    (by norm_num) (by norm_num) oscBlock29 vbpBr29.1 vbpBr30.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i30 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00293763):ℝ) ≤ ∫ v in (vBP 1.208)..(vBP 1.215), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.51845914) (m := (0:ℤ)) (ylo := 0.94766281) (yhi := 0.94766282)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.208) (q1 := 1.215) (t0 := 6.5) (t1 := 6.625)
    (A := 0.37793219) (B := 0.38948816) (X := 2.51845914) (rho := 0.06189993)
    (clo := (-0.81205381)) (chi := (-0.81205378)) (C := (-0.8120538)) (h := 0.06189995)
    (by norm_num) (by norm_num) oscBlock30 vbpBr30.1 vbpBr31.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i31 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00335101):ℝ) ≤ ∫ v in (vBP 1.215)..(vBP 1.223), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.59949443) (m := (0:ℤ)) (ylo := 1.0286981) (yhi := 1.02869811)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.215) (q1 := 1.223) (t0 := 6.5) (t1 := 6.625)
    (A := 0.38948815) (B := 0.40261372) (X := 2.59949443) (rho := 0.06782147)
    (clo := (-0.85662806)) (chi := (-0.85662801)) (C := (-0.85662804)) (h := 0.0678215)
    (by norm_num) (by norm_num) oscBlock31 vbpBr31.1 vbpBr32.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i32 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00325914):ℝ) ≤ ∫ v in (vBP 1.223)..(vBP 1.231), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.68534743) (m := (0:ℤ)) (ylo := 1.1145511) (yhi := 1.11455111)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.223) (q1 := 1.231) (t0 := 6.5) (t1 := 6.625)
    (A := 0.40261371) (B := 0.4156537) (X := 2.68534743) (rho := 0.06835834)
    (clo := (-0.89771319)) (chi := (-0.8977131)) (C := (-0.89771315)) (h := 0.06835839)
    (by norm_num) (by norm_num) oscBlock32 vbpBr32.1 vbpBr33.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i33 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00310538):ℝ) ≤ ∫ v in (vBP 1.231)..(vBP 1.239), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.7706425) (m := (0:ℤ)) (ylo := 1.19984617) (yhi := 1.19984618)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.231) (q1 := 1.239) (t0 := 6.5) (t1 := 6.625)
    (A := 0.41565369) (B := 0.42860921) (X := 2.7706425) (rho := 0.06889353)
    (clo := (-0.93198353)) (chi := (-0.93198333)) (C := (-0.9315449)) (h := 0.0684551)
    (by norm_num) (by norm_num) oscBlock33 vbpBr33.1 vbpBr34.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i34 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.0031571):ℝ) ≤ ∫ v in (vBP 1.239)..(vBP 1.248), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.86069747) (m := (0:ℤ)) (ylo := 1.28990114) (yhi := 1.28990115)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.239) (q1 := 1.248) (t0 := 6.5) (t1 := 6.625)
    (A := 0.4286092) (B := 0.44308455) (X := 2.86069747) (rho := 0.07473769)
    (clo := (-0.96080808)) (chi := (-0.96080765)) (C := (-0.94303498)) (h := 0.05696502)
    (by norm_num) (by norm_num) oscBlock34 vbpBr34.1 vbpBr35.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i35 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00307603):ℝ) ≤ ∫ v in (vBP 1.248)..(vBP 1.258), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 2.96061565) (m := (0:ℤ)) (ylo := 1.38981932) (yhi := 1.38981933)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.248) (q1 := 1.258) (t0 := 6.5) (t1 := 6.625)
    (A := 0.44308453) (B := 0.45904632) (X := 2.96061565) (rho := 0.08056623)
    (clo := (-0.98366924)) (chi := (-0.98366829)) (C := (-0.95155103)) (h := 0.04844897)
    (by norm_num) (by norm_num) oscBlock35 vbpBr35.1 vbpBr36.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i36 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00264808):ℝ) ≤ ∫ v in (vBP 1.258)..(vBP 1.268), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 3.0649462) (m := (0:ℤ)) (ylo := 1.49414987) (yhi := 1.49414988)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.258) (q1 := 1.268) (t0 := 6.5) (t1 := 6.625)
    (A := 0.45904631) (B := 0.47488172) (X := 3.0649462) (rho := 0.0811452)
    (clo := (-0.99706615)) (chi := (-0.99706406)) (C := (-0.95795943)) (h := 0.04204057)
    (by norm_num) (by norm_num) oscBlock36 vbpBr36.1 vbpBr37.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i37 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00261049):ℝ) ≤ ∫ v in (vBP 1.268)..(vBP 1.28), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.17881358) (m := (0:ℤ)) (ylo := 0.03722092) (yhi := 0.03722093)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.268) (q1 := 1.28) (t0 := 6.5) (t1 := 6.625)
    (A := 0.4748817) (B := 0.49372017) (X := 3.17881358) (rho := 0.09208255)
    (clo := (-0.99930739)) (chi := (-0.99930738)) (C := (-0.95361242)) (h := 0.04638759)
    (by norm_num) (by norm_num) oscBlock37 vbpBr37.1 vbpBr38.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i38 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.0022862):ℝ) ≤ ∫ v in (vBP 1.28)..(vBP 1.294), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.31210606) (m := (0:ℤ)) (ylo := 0.1705134) (yhi := 0.17051341)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.28) (q1 := 1.294) (t0 := 6.5) (t1 := 6.625)
    (A := 0.49372014) (B := 0.51547641) (X := 3.31210606) (rho := 0.10292517)
    (clo := (-0.98549778)) (chi := (-0.98549777)) (C := (-0.9412863)) (h := 0.0587137)
    (by norm_num) (by norm_num) oscBlock38 vbpBr38.1 vbpBr39.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i39 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00152769):ℝ) ≤ ∫ v in (vBP 1.294)..(vBP 1.308), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.45410586) (m := (0:ℤ)) (ylo := 0.3125132) (yhi := 0.31251321)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.294) (q1 := 1.308) (t0 := 6.5) (t1 := 6.625)
    (A := 0.51547638) (B := 0.53699853) (X := 3.45410586) (rho := 0.10350941)
    (clo := (-0.95156389)) (chi := (-0.95156388)) (C := (-0.92402724)) (h := 0.07597277)
    (by norm_num) (by norm_num) oscBlock39 vbpBr39.1 vbpBr40.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i40 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00100147):ℝ) ≤ ∫ v in (vBP 1.308)..(vBP 1.326), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.61460083) (m := (0:ℤ)) (ylo := 0.47300817) (yhi := 0.47300818)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.308) (q1 := 1.326) (t0 := 6.5) (t1 := 6.625)
    (A := 0.53699848) (B := 0.56433382) (X := 3.61460083) (rho := 0.12411073)
    (clo := (-0.8902019)) (chi := (-0.89020189)) (C := (-0.88304558)) (h := 0.11695442)
    (by norm_num) (by norm_num) oscBlock40 vbpBr40.1 vbpBr41.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i41 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00012533):ℝ) ≤ ∫ v in (vBP 1.326)..(vBP 1.345), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.79769517) (m := (0:ℤ)) (ylo := 0.65610251) (yhi := 0.65610252)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.326) (q1 := 1.345) (t0 := 6.5) (t1 := 6.625)
    (A := 0.56433374) (B := 0.59278808) (X := 3.79769517) (rho := 0.12952587)
    (clo := (-0.79237585)) (chi := (-0.79237583)) (C := (-0.79237584)) (h := 0.12952588)
    (by norm_num) (by norm_num) oscBlock41 vbpBr41.1 vbpBr42.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i42 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    (0.00050358:ℝ) ≤ ∫ v in (vBP 1.345)..(vBP 1.362), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 3.97338277) (m := (0:ℤ)) (ylo := 0.83179011) (yhi := 0.83179012)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.345) (q1 := 1.362) (t0 := 6.5) (t1 := 6.625)
    (A := 0.59278796) (B := 0.6179085) (X := 3.97338277) (rho := 0.12026105)
    (clo := (-0.67355375)) (chi := (-0.67355369)) (C := (-0.67355372)) (h := 0.12026108)
    (by norm_num) (by norm_num) oscBlock42 vbpBr42.1 vbpBr43.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i43 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    (0.00051893:ℝ) ≤ ∫ v in (vBP 1.362)..(vBP 1.376), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.1227748) (m := (0:ℤ)) (ylo := 0.98118214) (yhi := 0.98118215)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.362) (q1 := 1.376) (t0 := 6.5) (t1 := 6.625)
    (A := 0.61790831) (B := 0.6383616) (X := 4.1227748) (rho := 0.10637081)
    (clo := (-0.55604062)) (chi := (-0.55604038)) (C := (-0.5560405)) (h := 0.10637093)
    (by norm_num) (by norm_num) oscBlock43 vbpBr43.1 vbpBr44.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i44 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    (0.00044706:ℝ) ≤ ∫ v in (vBP 1.376)..(vBP 1.39), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.25631222) (m := (0:ℤ)) (ylo := 1.11471956) (yhi := 1.11471957)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.376) (q1 := 1.39) (t0 := 6.5) (t1 := 6.625)
    (A := 0.63836133) (B := 0.65860767) (X := 4.25631222) (rho := 0.1069636)
    (clo := (-0.44043009)) (chi := (-0.44042925)) (C := (-0.44042967)) (h := 0.10696402)
    (by norm_num) (by norm_num) oscBlock44 vbpBr44.1 vbpBr45.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i45 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    (0.00028518:ℝ) ≤ ∫ v in (vBP 1.39)..(vBP 1.404), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.38850466) (m := (0:ℤ)) (ylo := 1.246912) (yhi := 1.24691201)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.39) (q1 := 1.404) (t0 := 6.5) (t1 := 6.625)
    (A := 0.65860729) (B := 0.67865086) (X := 4.38850466) (rho := 0.1075573)
    (clo := (-0.3182538)) (chi := (-0.31825128)) (C := (-0.31825254)) (h := 0.10755856)
    (by norm_num) (by norm_num) oscBlock45 vbpBr45.1 vbpBr46.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i46 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    (0.0000772:ℝ) ≤ ∫ v in (vBP 1.404)..(vBP 1.418), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.51937888) (m := (0:ℤ)) (ylo := 1.37778622) (yhi := 1.37778623)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.404) (q1 := 1.418) (t0 := 6.5) (t1 := 6.625)
    (A := 0.67865033) (B := 0.69849519) (X := 4.51937888) (rho := 0.10815176)
    (clo := (-0.19182067)) (chi := (-0.19181386)) (C := (-0.19181727)) (h := 0.10815517)
    (by norm_num) (by norm_num) oscBlock46 vbpBr46.1 vbpBr47.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i47 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00013464):ℝ) ≤ ∫ v in (vBP 1.418)..(vBP 1.432), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 4.64896098) (m := (0:ℤ)) (ylo := 1.50736832) (yhi := 1.50736833)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.418) (q1 := 1.432) (t0 := 6.5) (t1 := 6.625)
    (A := 0.69849446) (B := 0.7181446) (X := 4.64896098) (rho := 0.10874701)
    (clo := (-0.0634019)) (chi := (-0.06338519)) (C := (-0.06339355)) (h := 0.10875537)
    (by norm_num) (by norm_num) oscBlock47 vbpBr47.1 vbpBr48.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i48 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00035526):ℝ) ≤ ∫ v in (vBP 1.432)..(vBP 1.446), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.77727617) (m := (0:ℤ)) (ylo := 0.06488718) (yhi := 0.06488719)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.432) (q1 := 1.446) (t0 := 6.5) (t1 := 6.625)
    (A := 0.7181436) (B := 0.73760286) (X := 4.77727617) (rho := 0.10934279)
    (clo := 0.06484165) (chi := 0.06484167) (C := 0.06484166) (h := 0.1093428)
    (by norm_num) (by norm_num) oscBlock48 vbpBr48.1 vbpBr49.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i49 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00069685):ℝ) ≤ ∫ v in (vBP 1.446)..(vBP 1.462), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 4.91341833) (m := (0:ℤ)) (ylo := 0.20102934) (yhi := 0.20102935)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.446) (q1 := 1.462) (t0 := 6.5) (t1 := 6.625)
    (A := 0.73760153) (B := 0.75961158) (X := 4.91341833) (rho := 0.1190084)
    (clo := 0.19967804) (chi := 0.19967806) (C := 0.19967805) (h := 0.11900841)
    (by norm_num) (by norm_num) oscBlock49 vbpBr49.1 vbpBr50.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i50 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00096027):ℝ) ≤ ∫ v in (vBP 1.462)..(vBP 1.478), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.05705555) (m := (0:ℤ)) (ylo := 0.34466656) (yhi := 0.34466657)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.462) (q1 := 1.478) (t0 := 6.5) (t1 := 6.625)
    (A := 0.75960973) (B := 0.78138081) (X := 5.05705555) (rho := 0.11959233)
    (clo := 0.33788286) (chi := 0.33788288) (C := 0.33788287) (h := 0.11959234)
    (by norm_num) (by norm_num) oscBlock50 vbpBr50.1 vbpBr51.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i51 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00123564):ℝ) ≤ ∫ v in (vBP 1.478)..(vBP 1.495), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.20357088) (m := (0:ℤ)) (ylo := 0.49118189) (yhi := 0.4911819)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.478) (q1 := 1.495) (t0 := 6.5) (t1 := 6.625)
    (A := 0.7813783) (B := 0.80425401) (X := 5.20357088) (rho := 0.12461195)
    (clo := 0.47166837) (chi := 0.47166839) (C := 0.47166838) (h := 0.12461196)
    (by norm_num) (by norm_num) oscBlock51 vbpBr51.1 vbpBr52.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i52 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00138859):ℝ) ≤ ∫ v in (vBP 1.495)..(vBP 1.512), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.35281695) (m := (0:ℤ)) (ylo := 0.64042796) (yhi := 0.64042797)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.495) (q1 := 1.512) (t0 := 6.5) (t1 := 6.625)
    (A := 0.80425056) (B := 0.82686872) (X := 5.35281695) (rho := 0.12518833)
    (clo := 0.59753865) (chi := 0.59753866) (C := 0.59753865) (h := 0.12518834)
    (by norm_num) (by norm_num) oscBlock52 vbpBr52.1 vbpBr53.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i53 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00168087):ℝ) ≤ ∫ v in (vBP 1.512)..(vBP 1.531), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.50904545) (m := (0:ℤ)) (ylo := 0.79665646) (yhi := 0.79665647)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.512) (q1 := 1.531) (t0 := 6.5) (t1 := 6.625)
    (A := 0.82686405) (B := 0.85184522) (X := 5.50904545) (rho := 0.13442914)
    (clo := 0.71502261) (chi := 0.71502263) (C := 0.71502262) (h := 0.13442915)
    (by norm_num) (by norm_num) oscBlock53 vbpBr53.1 vbpBr54.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i54 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00172915):ℝ) ≤ ∫ v in (vBP 1.531)..(vBP 1.55), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.67192839) (m := (0:ℤ)) (ylo := 0.9595394) (yhi := 0.95953941)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.531) (q1 := 1.55) (t0 := 6.5) (t1 := 6.625)
    (A := 0.85183877) (B := 0.87651393) (X := 5.67192839) (rho := 0.13497641)
    (clo := 0.81892731) (chi := 0.81892734) (C := 0.81892732) (h := 0.13497643)
    (by norm_num) (by norm_num) oscBlock54 vbpBr54.1 vbpBr55.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i55 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00174878):ℝ) ≤ ∫ v in (vBP 1.55)..(vBP 1.57), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 5.83703607) (m := (0:ℤ)) (ylo := 1.12464708) (yhi := 1.12464709)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.55) (q1 := 1.57) (t0 := 6.5) (t1 := 6.625)
    (A := 0.87650515) (B := 0.90215678) (X := 5.83703607) (rho := 0.13975261)
    (clo := 0.90211536) (chi := 0.90211547) (C := 0.88118137) (h := 0.11881863)
    (by norm_num) (by norm_num) oscBlock55 vbpBr55.1 vbpBr56.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i56 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00159903):ℝ) ≤ ∫ v in (vBP 1.57)..(vBP 1.59), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.00423316) (m := (0:ℤ)) (ylo := 1.29184417) (yhi := 1.29184418)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.57) (q1 := 1.59) (t0 := 6.5) (t1 := 6.625)
    (A := 0.90214481) (B := 0.92747548) (X := 6.00423316) (rho := 0.14029191)
    (clo := 0.96134448) (chi := 0.96134491) (C := 0.91052628) (h := 0.08947372)
    (by norm_num) (by norm_num) oscBlock56 vbpBr56.1 vbpBr57.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i57 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00146404):ℝ) ≤ ∫ v in (vBP 1.59)..(vBP 1.61), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case3 (X := 6.16932722) (m := (0:ℤ)) (ylo := 1.45693823) (yhi := 1.45693824)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.59) (q1 := 1.61) (t0 := 6.5) (t1 := 6.625)
    (A := 0.92745939) (B := 0.95247825) (X := 6.16932722) (rho := 0.1408412)
    (clo := 0.99352514) (chi := 0.99352672) (C := 0.92634197) (h := 0.07365803)
    (by norm_num) (by norm_num) oscBlock57 vbpBr57.1 vbpBr58.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i58 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00149216):ℝ) ≤ ∫ v in (vBP 1.61)..(vBP 1.632), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.34049548) (m := (1:ℤ)) (ylo := 0.05731017) (yhi := 0.05731018)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.61) (q1 := 1.632) (t0 := 6.5) (t1 := 6.625)
    (A := 0.95245689) (B := 0.97962584) (X := 6.34049548) (rho := 0.14952572)
    (clo := 0.99835822) (chi := 0.99835823) (C := 0.92441625) (h := 0.07558375)
    (by norm_num) (by norm_num) oscBlock58 vbpBr58.1 vbpBr59.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i59 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00149999):ℝ) ≤ ∫ v in (vBP 1.632)..(vBP 1.656), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.52543412) (m := (1:ℤ)) (ylo := 0.24224881) (yhi := 0.24224882)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.632) (q1 := 1.656) (t0 := 6.5) (t1 := 6.625)
    (A := 0.97959707) (B := 1.00882827) (X := 6.52543412) (rho := 0.15805318)
    (clo := 0.97080096) (chi := 0.97080098) (C := 0.90637389) (h := 0.09362611)
    (by norm_num) (by norm_num) oscBlock59 vbpBr59.1 vbpBr60.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i60 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00135601):ℝ) ≤ ∫ v in (vBP 1.656)..(vBP 1.68), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.71565409) (m := (1:ℤ)) (ylo := 0.43246878) (yhi := 0.43246879)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.656) (q1 := 1.68) (t0 := 6.5) (t1 := 6.625)
    (A := 1.00878907) (B := 1.03761196) (X := 6.71565409) (rho := 0.15852515)
    (clo := 0.90793381) (chi := 0.90793382) (C := 0.87470433) (h := 0.12529567)
    (by norm_num) (by norm_num) oscBlock60 vbpBr60.1 vbpBr61.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i61 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00119482):ℝ) ≤ ∫ v in (vBP 1.68)..(vBP 1.704), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 6.90315688) (m := (1:ℤ)) (ylo := 0.61997157) (yhi := 0.61997158)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.68) (q1 := 1.704) (t0 := 6.5) (t1 := 6.625)
    (A := 1.03755935) (B := 1.06598913) (X := 6.90315688) (rho := 0.15902112)
    (clo := 0.81389496) (chi := 0.81389498) (C := 0.81389497) (h := 0.15902113)
    (by norm_num) (by norm_num) oscBlock61 vbpBr61.1 vbpBr62.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i62 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00117821):ℝ) ≤ ∫ v in (vBP 1.704)..(vBP 1.734), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.11099205) (m := (1:ℤ)) (ylo := 0.82780674) (yhi := 0.82780675)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.704) (q1 := 1.734) (t0 := 6.5) (t1 := 6.625)
    (A := 1.06591948) (B := 1.10090679) (X := 7.11099205) (rho := 0.18251545)
    (clo := 0.6764926) (chi := 0.67649266) (C := 0.67649263) (h := 0.18251548)
    (by norm_num) (by norm_num) oscBlock62 vbpBr62.1 vbpBr63.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i63 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00087938):ℝ) ≤ ∫ v in (vBP 1.734)..(vBP 1.766), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.34559064) (m := (1:ℤ)) (ylo := 1.06240533) (yhi := 1.06240534)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.734) (q1 := 1.766) (t0 := 6.5) (t1 := 6.625)
    (A := 1.10080961) (B := 1.13749718) (X := 7.34559064) (rho := 0.19032819)
    (clo := 0.48677235) (chi := 0.48677287) (C := 0.48677261) (h := 0.19032845)
    (by norm_num) (by norm_num) oscBlock63 vbpBr63.1 vbpBr64.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i64 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00049241):ℝ) ≤ ∫ v in (vBP 1.766)..(vBP 1.796), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.57605314) (m := (1:ℤ)) (ylo := 1.29286783) (yhi := 1.29286784)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.766) (q1 := 1.796) (t0 := 6.5) (t1 := 6.625)
    (A := 1.1373613) (B := 1.17120873) (X := 7.57605314) (rho := 0.18320471)
    (clo := 0.27436417) (chi := 0.27436778) (C := 0.27436597) (h := 0.18320652)
    (by norm_num) (by norm_num) oscBlock64 vbpBr64.1 vbpBr65.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i65 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00025559):ℝ) ≤ ∫ v in (vBP 1.796)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case0 (X := 7.80256209) (m := (1:ℤ)) (ylo := 1.51937678) (yhi := 1.51937679)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.796) (q1 := 1.828) (t0 := 6.5) (t1 := 6.625)
    (A := 1.1710258) (B := 1.20655947) (X := 7.80256209) (rho := 0.19089441)
    (clo := 0.05139656) (chi := 0.05141465) (C := 0.0514056) (h := 0.19090346)
    (by norm_num) (by norm_num) oscBlock65 vbpBr65.1 vbpBr66.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i66 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00032805):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.86), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.03233903) (m := (1:ℤ)) (ylo := 0.17835739) (yhi := 0.1783574)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.828) (q1 := 1.86) (t0 := 6.5) (t1 := 6.625)
    (A := 1.20631244) (B := 1.24130524) (X := 8.03233903) (rho := 0.19130819)
    (clo := (-0.17741328)) (chi := (-0.17741326)) (C := (-0.17741327)) (h := 0.1913082)
    (by norm_num) (by norm_num) oscBlock66 vbpBr66.1 vbpBr67.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i67 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00042071):ℝ) ≤ ∫ v in (vBP 1.86)..(vBP 1.89), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.2511464) (m := (1:ℤ)) (ylo := 0.39716476) (yhi := 0.39716477)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.86) (q1 := 1.89) (t0 := 6.5) (t1 := 6.625)
    (A := 1.24097685) (B := 1.27334993) (X := 8.2511464) (rho := 0.1847969)
    (clo := (-0.38680537)) (chi := (-0.38680535)) (C := (-0.38680536)) (h := 0.18479691)
    (by norm_num) (by norm_num) oscBlock67 vbpBr67.1 vbpBr68.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i68 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00055744):ℝ) ≤ ∫ v in (vBP 1.89)..(vBP 1.922), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.46640495) (m := (1:ℤ)) (ylo := 0.61242331) (yhi := 0.61242332)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.89) (q1 := 1.922) (t0 := 6.5) (t1 := 6.625)
    (A := 1.27292668) (B := 1.30698664) (X := 8.46640495) (rho := 0.19238155)
    (clo := (-0.57485205)) (chi := (-0.57485203)) (C := (-0.57485204)) (h := 0.19238156)
    (by norm_num) (by norm_num) oscBlock68 vbpBr68.1 vbpBr69.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i69 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00096989):ℝ) ≤ ∫ v in (vBP 1.922)..(vBP 1.969), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 8.73573708) (m := (1:ℤ)) (ylo := 0.88175544) (yhi := 0.88175545)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.922) (q1 := 1.969) (t0 := 6.5) (t1 := 6.625)
    (A := 1.30643896) (B := 1.35541448) (X := 8.73573708) (rho := 0.24388386)
    (clo := (-0.77185619)) (chi := (-0.77185617)) (C := (-0.76398616)) (h := 0.23601385)
    (by norm_num) (by norm_num) oscBlock69 vbpBr69.1 vbpBr70.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i70 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00087888):ℝ) ≤ ∫ v in (vBP 1.969)..(vBP 2.016), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 9.04912082) (m := (1:ℤ)) (ylo := 1.19513918) (yhi := 1.19513919)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 1.969) (q1 := 2.016) (t0 := 6.5) (t1 := 6.625)
    (A := 1.35463226) (B := 1.4027369) (X := 9.04912082) (rho := 0.24401115)
    (clo := (-0.93026691)) (chi := (-0.93026672)) (C := (-0.84312779)) (h := 0.15687222)
    (by norm_num) (by norm_num) oscBlock70 vbpBr70.1 vbpBr71.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i71 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00078633):ℝ) ≤ ∫ v in (vBP 2.016)..(vBP 2.062), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case1 (X := 9.35198051) (m := (1:ℤ)) (ylo := 1.49799887) (yhi := 1.49799888)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.016) (q1 := 2.062) (t0 := 6.5) (t1 := 6.625)
    (A := 1.40164597) (B := 1.44803958) (X := 9.35198051) (rho := 0.24128172)
    (clo := (-0.99735355)) (chi := (-0.9973514)) (C := (-0.87803484)) (h := 0.12196516)
    (by norm_num) (by norm_num) oscBlock71 vbpBr71.1 vbpBr72.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

theorem cosB6i72 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.00051115):ℝ) ≤ ∫ v in (vBP 2.062)..(vBP 2.094), errFun v * Real.cos (t * v) := by
  have hc := cos_bracket_case2 (X := 9.60048068) (m := (1:ℤ)) (ylo := 0.17570271) (yhi := 0.17570272)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
  exact errCos_block_ge_rat (q0 := 2.062) (q1 := 2.094) (t0 := 6.5) (t1 := 6.625)
    (A := 1.44655973) (B := 1.47899217) (X := 9.60048068) (rho := 0.19784246)
    (clo := (-0.98460395)) (chi := (-0.98460394)) (C := (-0.89338074)) (h := 0.10661926)
    (by norm_num) (by norm_num) oscBlock72 vbpBr72.1 vbpBr73.2 (by norm_num) ht0 ht1 (by norm_num)
    (le_trans (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) hc.1)
    (le_trans hc.2 (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)

/-- Lower bound for the oscillatory integral `∫₀^∞ err(v) cos(tv) dv` on the band
`6.5 ≤ t ≤ 6.625`. -/
theorem oscBandLower6 {t : ℝ} (ht0 : (6.5:ℝ) ≤ t) (ht1 : t ≤ 6.625) :
    ((-0.14305258):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosB6i0 ht0 ht1)
    (cosB6i1 ht0 ht1))
    (cosB6i2 ht0 ht1))
    (cosB6i3 ht0 ht1))
    (cosB6i4 ht0 ht1))
    (cosB6i5 ht0 ht1))
    (cosB6i6 ht0 ht1))
    (cosB6i7 ht0 ht1))
    (cosB6i8 ht0 ht1))
    (cosB6i9 ht0 ht1))
    (cosB6i10 ht0 ht1))
    (cosB6i11 ht0 ht1))
    (cosB6i12 ht0 ht1))
    (cosB6i13 ht0 ht1))
    (cosB6i14 ht0 ht1))
    (cosB6i15 ht0 ht1))
    (cosB6i16 ht0 ht1))
    (cosB6i17 ht0 ht1))
    (cosB6i18 ht0 ht1))
    (cosB6i19 ht0 ht1))
    (cosB6i20 ht0 ht1))
    (cosB6i21 ht0 ht1))
    (cosB6i22 ht0 ht1))
    (cosB6i23 ht0 ht1))
    (cosB6i24 ht0 ht1))
    (cosB6i25 ht0 ht1))
    (cosB6i26 ht0 ht1))
    (cosB6i27 ht0 ht1))
    (cosB6i28 ht0 ht1))
    (cosB6i29 ht0 ht1))
    (cosB6i30 ht0 ht1))
    (cosB6i31 ht0 ht1))
    (cosB6i32 ht0 ht1))
    (cosB6i33 ht0 ht1))
    (cosB6i34 ht0 ht1))
    (cosB6i35 ht0 ht1))
    (cosB6i36 ht0 ht1))
    (cosB6i37 ht0 ht1))
    (cosB6i38 ht0 ht1))
    (cosB6i39 ht0 ht1))
    (cosB6i40 ht0 ht1))
    (cosB6i41 ht0 ht1))
    (cosB6i42 ht0 ht1))
    (cosB6i43 ht0 ht1))
    (cosB6i44 ht0 ht1))
    (cosB6i45 ht0 ht1))
    (cosB6i46 ht0 ht1))
    (cosB6i47 ht0 ht1))
    (cosB6i48 ht0 ht1))
    (cosB6i49 ht0 ht1))
    (cosB6i50 ht0 ht1))
    (cosB6i51 ht0 ht1))
    (cosB6i52 ht0 ht1))
    (cosB6i53 ht0 ht1))
    (cosB6i54 ht0 ht1))
    (cosB6i55 ht0 ht1))
    (cosB6i56 ht0 ht1))
    (cosB6i57 ht0 ht1))
    (cosB6i58 ht0 ht1))
    (cosB6i59 ht0 ht1))
    (cosB6i60 ht0 ht1))
    (cosB6i61 ht0 ht1))
    (cosB6i62 ht0 ht1))
    (cosB6i63 ht0 ht1))
    (cosB6i64 ht0 ht1))
    (cosB6i65 ht0 ht1))
    (cosB6i66 ht0 ht1))
    (cosB6i67 ht0 ht1))
    (cosB6i68 ht0 ht1))
    (cosB6i69 ht0 ht1))
    (cosB6i70 ht0 ht1))
    (cosB6i71 ht0 ht1))
    (cosB6i72 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 2.094) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 2.094) (S := 0.013709)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_cut
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
