/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Part 3 of the 601-breakpoint partition, and the assembled certified L¹ bound
`∫₀^∞ |δ(e^v) - h(v)| dv ≤ 0.21088` for the Pólya model of `RequestProject/PolyaModel.lean`.
The true value of the integral is `≈ 0.1741`.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaPartition2

noncomputable section

open MeasureTheory Set Real Filter Topology

namespace ConnesConsani.WeilPositivity

set_option maxHeartbeats 1000000 in
/-- Partition chunk 41: the `q`-range `[1.274, 1.294]`. -/
theorem integral_abs_errFun_chunk41 :
    (∫ v in Ioi (vBP 1.274), |errFun v|)
      ≤ 0.003501 + ∫ v in Ioi (vBP 1.294), |errFun v| := by
  have e1 := integral_piece_taylor_le (q0 := 1.274) (q1 := 1.275) (M := 0.16919)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e2 := integral_piece_taylor_le (q0 := 1.275) (q1 := 1.276) (M := 0.16574)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e3 := integral_piece_taylor_le (q0 := 1.276) (q1 := 1.278) (M := 0.16719)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e4 := integral_piece_taylor_le (q0 := 1.278) (q1 := 1.28) (M := 0.16023)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e5 := integral_piece_taylor_le (q0 := 1.28) (q1 := 1.282) (M := 0.15326)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e6 := integral_piece_taylor_le (q0 := 1.282) (q1 := 1.284) (M := 0.1463)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e7 := integral_piece_taylor_le (q0 := 1.284) (q1 := 1.286) (M := 0.13935)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e8 := integral_piece_taylor_le (q0 := 1.286) (q1 := 1.289) (M := 0.13708)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e9 := integral_piece_taylor_le (q0 := 1.289) (q1 := 1.292) (M := 0.12663)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e10 := integral_piece_taylor_le (q0 := 1.292) (q1 := 1.294) (M := 0.11169)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have s1 := integral_Ioi_abs_errFun_split (a := vBP 1.274) (b := vBP 1.275)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s2 := integral_Ioi_abs_errFun_split (a := vBP 1.275) (b := vBP 1.276)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s3 := integral_Ioi_abs_errFun_split (a := vBP 1.276) (b := vBP 1.278)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s4 := integral_Ioi_abs_errFun_split (a := vBP 1.278) (b := vBP 1.28)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s5 := integral_Ioi_abs_errFun_split (a := vBP 1.28) (b := vBP 1.282)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s6 := integral_Ioi_abs_errFun_split (a := vBP 1.282) (b := vBP 1.284)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s7 := integral_Ioi_abs_errFun_split (a := vBP 1.284) (b := vBP 1.286)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s8 := integral_Ioi_abs_errFun_split (a := vBP 1.286) (b := vBP 1.289)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s9 := integral_Ioi_abs_errFun_split (a := vBP 1.289) (b := vBP 1.292)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s10 := integral_Ioi_abs_errFun_split (a := vBP 1.292) (b := vBP 1.294)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  rw [s1, s2, s3, s4, s5, s6, s7, s8, s9, s10]
  norm_num at e1 e2 e3 e4 e5 e6 e7 e8 e9 e10 ⊢
  linarith

set_option maxHeartbeats 1000000 in
/-- Partition chunk 42: the `q`-range `[1.294, 1.331]`. -/
theorem integral_abs_errFun_chunk42 :
    (∫ v in Ioi (vBP 1.294), |errFun v|)
      ≤ 0.002973 + ∫ v in Ioi (vBP 1.331), |errFun v| := by
  have e1 := integral_piece_taylor_le (q0 := 1.294) (q1 := 1.296) (M := 0.10485)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e2 := integral_piece_taylor_le (q0 := 1.296) (q1 := 1.298) (M := 0.09804)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e3 := integral_piece_taylor_le (q0 := 1.298) (q1 := 1.3) (M := 0.09127)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e4 := integral_piece_taylor_le (q0 := 1.3) (q1 := 1.303) (M := 0.08892)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e5 := integral_piece_taylor_le (q0 := 1.303) (q1 := 1.308) (M := 0.08748)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e6 := integral_piece_taylor_le (q0 := 1.308) (q1 := 1.312) (M := 0.06661)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e7 := integral_piece_taylor_le (q0 := 1.312) (q1 := 1.317) (M := 0.05779)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e8 := integral_piece_taylor_le (q0 := 1.317) (q1 := 1.322) (M := 0.04195)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e9 := integral_piece_taylor_le (q0 := 1.322) (q1 := 1.326) (M := 0.04507)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e10 := integral_piece_taylor_le (q0 := 1.326) (q1 := 1.331) (M := 0.06226)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have s1 := integral_Ioi_abs_errFun_split (a := vBP 1.294) (b := vBP 1.296)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s2 := integral_Ioi_abs_errFun_split (a := vBP 1.296) (b := vBP 1.298)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s3 := integral_Ioi_abs_errFun_split (a := vBP 1.298) (b := vBP 1.3)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s4 := integral_Ioi_abs_errFun_split (a := vBP 1.3) (b := vBP 1.303)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s5 := integral_Ioi_abs_errFun_split (a := vBP 1.303) (b := vBP 1.308)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s6 := integral_Ioi_abs_errFun_split (a := vBP 1.308) (b := vBP 1.312)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s7 := integral_Ioi_abs_errFun_split (a := vBP 1.312) (b := vBP 1.317)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s8 := integral_Ioi_abs_errFun_split (a := vBP 1.317) (b := vBP 1.322)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s9 := integral_Ioi_abs_errFun_split (a := vBP 1.322) (b := vBP 1.326)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s10 := integral_Ioi_abs_errFun_split (a := vBP 1.326) (b := vBP 1.331)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  rw [s1, s2, s3, s4, s5, s6, s7, s8, s9, s10]
  norm_num at e1 e2 e3 e4 e5 e6 e7 e8 e9 e10 ⊢
  linarith

set_option maxHeartbeats 1000000 in
/-- Partition chunk 43: the `q`-range `[1.331, 1.362]`. -/
theorem integral_abs_errFun_chunk43 :
    (∫ v in Ioi (vBP 1.331), |errFun v|)
      ≤ 0.00329 + ∫ v in Ioi (vBP 1.362), |errFun v| := by
  have e1 := integral_piece_taylor_le (q0 := 1.331) (q1 := 1.336) (M := 0.07486)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e2 := integral_piece_taylor_le (q0 := 1.336) (q1 := 1.34) (M := 0.08073)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e3 := integral_piece_taylor_le (q0 := 1.34) (q1 := 1.345) (M := 0.09572)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e4 := integral_piece_taylor_le (q0 := 1.345) (q1 := 1.348) (M := 0.095)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e5 := integral_piece_taylor_le (q0 := 1.348) (q1 := 1.35) (M := 0.09565)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e6 := integral_piece_taylor_le (q0 := 1.35) (q1 := 1.352) (M := 0.09972)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e7 := integral_piece_taylor_le (q0 := 1.352) (q1 := 1.355) (M := 0.10903)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e8 := integral_piece_taylor_le (q0 := 1.355) (q1 := 1.358) (M := 0.11454)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e9 := integral_piece_taylor_le (q0 := 1.358) (q1 := 1.36) (M := 0.11466)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e10 := integral_piece_taylor_le (q0 := 1.36) (q1 := 1.362) (M := 0.11806)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have s1 := integral_Ioi_abs_errFun_split (a := vBP 1.331) (b := vBP 1.336)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s2 := integral_Ioi_abs_errFun_split (a := vBP 1.336) (b := vBP 1.34)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s3 := integral_Ioi_abs_errFun_split (a := vBP 1.34) (b := vBP 1.345)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s4 := integral_Ioi_abs_errFun_split (a := vBP 1.345) (b := vBP 1.348)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s5 := integral_Ioi_abs_errFun_split (a := vBP 1.348) (b := vBP 1.35)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s6 := integral_Ioi_abs_errFun_split (a := vBP 1.35) (b := vBP 1.352)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s7 := integral_Ioi_abs_errFun_split (a := vBP 1.352) (b := vBP 1.355)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s8 := integral_Ioi_abs_errFun_split (a := vBP 1.355) (b := vBP 1.358)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s9 := integral_Ioi_abs_errFun_split (a := vBP 1.358) (b := vBP 1.36)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s10 := integral_Ioi_abs_errFun_split (a := vBP 1.36) (b := vBP 1.362)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  rw [s1, s2, s3, s4, s5, s6, s7, s8, s9, s10]
  norm_num at e1 e2 e3 e4 e5 e6 e7 e8 e9 e10 ⊢
  linarith

set_option maxHeartbeats 1000000 in
/-- Partition chunk 44: the `q`-range `[1.362, 1.386]`. -/
theorem integral_abs_errFun_chunk44 :
    (∫ v in Ioi (vBP 1.362), |errFun v|)
      ≤ 0.003499 + ∫ v in Ioi (vBP 1.386), |errFun v| := by
  have e1 := integral_piece_taylor_le (q0 := 1.362) (q1 := 1.364) (M := 0.12131)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e2 := integral_piece_taylor_le (q0 := 1.364) (q1 := 1.366) (M := 0.12442)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e3 := integral_piece_taylor_le (q0 := 1.366) (q1 := 1.369) (M := 0.13208)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e4 := integral_piece_taylor_le (q0 := 1.369) (q1 := 1.372) (M := 0.13613)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e5 := integral_piece_taylor_le (q0 := 1.372) (q1 := 1.374) (M := 0.13546)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e6 := integral_piece_taylor_le (q0 := 1.374) (q1 := 1.376) (M := 0.13787)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e7 := integral_piece_taylor_le (q0 := 1.376) (q1 := 1.378) (M := 0.14013)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e8 := integral_piece_taylor_le (q0 := 1.378) (q1 := 1.38) (M := 0.14225)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e9 := integral_piece_taylor_le (q0 := 1.38) (q1 := 1.383) (M := 0.14824)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e10 := integral_piece_taylor_le (q0 := 1.383) (q1 := 1.386) (M := 0.15081)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have s1 := integral_Ioi_abs_errFun_split (a := vBP 1.362) (b := vBP 1.364)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s2 := integral_Ioi_abs_errFun_split (a := vBP 1.364) (b := vBP 1.366)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s3 := integral_Ioi_abs_errFun_split (a := vBP 1.366) (b := vBP 1.369)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s4 := integral_Ioi_abs_errFun_split (a := vBP 1.369) (b := vBP 1.372)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s5 := integral_Ioi_abs_errFun_split (a := vBP 1.372) (b := vBP 1.374)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s6 := integral_Ioi_abs_errFun_split (a := vBP 1.374) (b := vBP 1.376)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s7 := integral_Ioi_abs_errFun_split (a := vBP 1.376) (b := vBP 1.378)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s8 := integral_Ioi_abs_errFun_split (a := vBP 1.378) (b := vBP 1.38)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s9 := integral_Ioi_abs_errFun_split (a := vBP 1.38) (b := vBP 1.383)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s10 := integral_Ioi_abs_errFun_split (a := vBP 1.383) (b := vBP 1.386)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  rw [s1, s2, s3, s4, s5, s6, s7, s8, s9, s10]
  norm_num at e1 e2 e3 e4 e5 e6 e7 e8 e9 e10 ⊢
  linarith

set_option maxHeartbeats 1000000 in
/-- Partition chunk 45: the `q`-range `[1.386, 1.408]`. -/
theorem integral_abs_errFun_chunk45 :
    (∫ v in Ioi (vBP 1.386), |errFun v|)
      ≤ 0.003501 + ∫ v in Ioi (vBP 1.408), |errFun v| := by
  have e1 := integral_piece_taylor_le (q0 := 1.386) (q1 := 1.388) (M := 0.14932)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e2 := integral_piece_taylor_le (q0 := 1.388) (q1 := 1.39) (M := 0.15074)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e3 := integral_piece_taylor_le (q0 := 1.39) (q1 := 1.392) (M := 0.15203)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e4 := integral_piece_taylor_le (q0 := 1.392) (q1 := 1.394) (M := 0.15318)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e5 := integral_piece_taylor_le (q0 := 1.394) (q1 := 1.397) (M := 0.15758)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e6 := integral_piece_taylor_le (q0 := 1.397) (q1 := 1.4) (M := 0.15874)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e7 := integral_piece_taylor_le (q0 := 1.4) (q1 := 1.402) (M := 0.15647)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e8 := integral_piece_taylor_le (q0 := 1.402) (q1 := 1.404) (M := 0.15698)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e9 := integral_piece_taylor_le (q0 := 1.404) (q1 := 1.406) (M := 0.15737)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e10 := integral_piece_taylor_le (q0 := 1.406) (q1 := 1.408) (M := 0.15764)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have s1 := integral_Ioi_abs_errFun_split (a := vBP 1.386) (b := vBP 1.388)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s2 := integral_Ioi_abs_errFun_split (a := vBP 1.388) (b := vBP 1.39)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s3 := integral_Ioi_abs_errFun_split (a := vBP 1.39) (b := vBP 1.392)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s4 := integral_Ioi_abs_errFun_split (a := vBP 1.392) (b := vBP 1.394)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s5 := integral_Ioi_abs_errFun_split (a := vBP 1.394) (b := vBP 1.397)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s6 := integral_Ioi_abs_errFun_split (a := vBP 1.397) (b := vBP 1.4)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s7 := integral_Ioi_abs_errFun_split (a := vBP 1.4) (b := vBP 1.402)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s8 := integral_Ioi_abs_errFun_split (a := vBP 1.402) (b := vBP 1.404)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s9 := integral_Ioi_abs_errFun_split (a := vBP 1.404) (b := vBP 1.406)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s10 := integral_Ioi_abs_errFun_split (a := vBP 1.406) (b := vBP 1.408)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  rw [s1, s2, s3, s4, s5, s6, s7, s8, s9, s10]
  norm_num at e1 e2 e3 e4 e5 e6 e7 e8 e9 e10 ⊢
  linarith

set_option maxHeartbeats 1000000 in
/-- Partition chunk 46: the `q`-range `[1.408, 1.432]`. -/
theorem integral_abs_errFun_chunk46 :
    (∫ v in Ioi (vBP 1.408), |errFun v|)
      ≤ 0.003754 + ∫ v in Ioi (vBP 1.432), |errFun v| := by
  have e1 := integral_piece_taylor_le (q0 := 1.408) (q1 := 1.411) (M := 0.16063)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e2 := integral_piece_taylor_le (q0 := 1.411) (q1 := 1.414) (M := 0.16056)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e3 := integral_piece_taylor_le (q0 := 1.414) (q1 := 1.416) (M := 0.15763)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e4 := integral_piece_taylor_le (q0 := 1.416) (q1 := 1.418) (M := 0.15737)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e5 := integral_piece_taylor_le (q0 := 1.418) (q1 := 1.42) (M := 0.15703)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e6 := integral_piece_taylor_le (q0 := 1.42) (q1 := 1.422) (M := 0.15659)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e7 := integral_piece_taylor_le (q0 := 1.422) (q1 := 1.425) (M := 0.15847)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e8 := integral_piece_taylor_le (q0 := 1.425) (q1 := 1.428) (M := 0.15748)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e9 := integral_piece_taylor_le (q0 := 1.428) (q1 := 1.43) (M := 0.15411)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e10 := integral_piece_taylor_le (q0 := 1.43) (q1 := 1.432) (M := 0.15334)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have s1 := integral_Ioi_abs_errFun_split (a := vBP 1.408) (b := vBP 1.411)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s2 := integral_Ioi_abs_errFun_split (a := vBP 1.411) (b := vBP 1.414)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s3 := integral_Ioi_abs_errFun_split (a := vBP 1.414) (b := vBP 1.416)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s4 := integral_Ioi_abs_errFun_split (a := vBP 1.416) (b := vBP 1.418)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s5 := integral_Ioi_abs_errFun_split (a := vBP 1.418) (b := vBP 1.42)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s6 := integral_Ioi_abs_errFun_split (a := vBP 1.42) (b := vBP 1.422)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s7 := integral_Ioi_abs_errFun_split (a := vBP 1.422) (b := vBP 1.425)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s8 := integral_Ioi_abs_errFun_split (a := vBP 1.425) (b := vBP 1.428)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s9 := integral_Ioi_abs_errFun_split (a := vBP 1.428) (b := vBP 1.43)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s10 := integral_Ioi_abs_errFun_split (a := vBP 1.43) (b := vBP 1.432)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  rw [s1, s2, s3, s4, s5, s6, s7, s8, s9, s10]
  norm_num at e1 e2 e3 e4 e5 e6 e7 e8 e9 e10 ⊢
  linarith

set_option maxHeartbeats 1000000 in
/-- Partition chunk 47: the `q`-range `[1.432, 1.456]`. -/
theorem integral_abs_errFun_chunk47 :
    (∫ v in Ioi (vBP 1.432), |errFun v|)
      ≤ 0.003426 + ∫ v in Ioi (vBP 1.456), |errFun v| := by
  have e1 := integral_piece_taylor_le (q0 := 1.432) (q1 := 1.434) (M := 0.15251)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e2 := integral_piece_taylor_le (q0 := 1.434) (q1 := 1.436) (M := 0.15165)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e3 := integral_piece_taylor_le (q0 := 1.436) (q1 := 1.439) (M := 0.15288)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e4 := integral_piece_taylor_le (q0 := 1.439) (q1 := 1.442) (M := 0.15147)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e5 := integral_piece_taylor_le (q0 := 1.442) (q1 := 1.444) (M := 0.148)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e6 := integral_piece_taylor_le (q0 := 1.444) (q1 := 1.446) (M := 0.14708)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e7 := integral_piece_taylor_le (q0 := 1.446) (q1 := 1.448) (M := 0.14619)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e8 := integral_piece_taylor_le (q0 := 1.448) (q1 := 1.45) (M := 0.14532)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e9 := integral_piece_taylor_le (q0 := 1.45) (q1 := 1.453) (M := 0.14658)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e10 := integral_piece_taylor_le (q0 := 1.453) (q1 := 1.456) (M := 0.1455)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have s1 := integral_Ioi_abs_errFun_split (a := vBP 1.432) (b := vBP 1.434)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s2 := integral_Ioi_abs_errFun_split (a := vBP 1.434) (b := vBP 1.436)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s3 := integral_Ioi_abs_errFun_split (a := vBP 1.436) (b := vBP 1.439)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s4 := integral_Ioi_abs_errFun_split (a := vBP 1.439) (b := vBP 1.442)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s5 := integral_Ioi_abs_errFun_split (a := vBP 1.442) (b := vBP 1.444)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s6 := integral_Ioi_abs_errFun_split (a := vBP 1.444) (b := vBP 1.446)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s7 := integral_Ioi_abs_errFun_split (a := vBP 1.446) (b := vBP 1.448)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s8 := integral_Ioi_abs_errFun_split (a := vBP 1.448) (b := vBP 1.45)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s9 := integral_Ioi_abs_errFun_split (a := vBP 1.45) (b := vBP 1.453)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s10 := integral_Ioi_abs_errFun_split (a := vBP 1.453) (b := vBP 1.456)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  rw [s1, s2, s3, s4, s5, s6, s7, s8, s9, s10]
  norm_num at e1 e2 e3 e4 e5 e6 e7 e8 e9 e10 ⊢
  linarith

set_option maxHeartbeats 1000000 in
/-- Partition chunk 48: the `q`-range `[1.456, 1.481]`. -/
theorem integral_abs_errFun_chunk48 :
    (∫ v in Ioi (vBP 1.456), |errFun v|)
      ≤ 0.003278 + ∫ v in Ioi (vBP 1.481), |errFun v| := by
  have e1 := integral_piece_taylor_le (q0 := 1.456) (q1 := 1.458) (M := 0.14245)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e2 := integral_piece_taylor_le (q0 := 1.458) (q1 := 1.46) (M := 0.14195)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e3 := integral_piece_taylor_le (q0 := 1.46) (q1 := 1.462) (M := 0.14158)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e4 := integral_piece_taylor_le (q0 := 1.462) (q1 := 1.464) (M := 0.14134)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e5 := integral_piece_taylor_le (q0 := 1.464) (q1 := 1.467) (M := 0.14366)
    (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq])
  have e6 := integral_piece_asymp_le (q0 := 1.467) (q1 := 1.47) (M := 0.14325)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e7 := integral_piece_asymp_le (q0 := 1.47) (q1 := 1.472) (M := 0.14079)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e8 := integral_piece_asymp_le (q0 := 1.472) (q1 := 1.476) (M := 0.14175)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e9 := integral_piece_asymp_le (q0 := 1.476) (q1 := 1.478) (M := 0.13791)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e10 := integral_piece_asymp_le (q0 := 1.478) (q1 := 1.481) (M := 0.13791)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have s1 := integral_Ioi_abs_errFun_split (a := vBP 1.456) (b := vBP 1.458)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s2 := integral_Ioi_abs_errFun_split (a := vBP 1.458) (b := vBP 1.46)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s3 := integral_Ioi_abs_errFun_split (a := vBP 1.46) (b := vBP 1.462)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s4 := integral_Ioi_abs_errFun_split (a := vBP 1.462) (b := vBP 1.464)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s5 := integral_Ioi_abs_errFun_split (a := vBP 1.464) (b := vBP 1.467)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s6 := integral_Ioi_abs_errFun_split (a := vBP 1.467) (b := vBP 1.47)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s7 := integral_Ioi_abs_errFun_split (a := vBP 1.47) (b := vBP 1.472)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s8 := integral_Ioi_abs_errFun_split (a := vBP 1.472) (b := vBP 1.476)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s9 := integral_Ioi_abs_errFun_split (a := vBP 1.476) (b := vBP 1.478)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s10 := integral_Ioi_abs_errFun_split (a := vBP 1.478) (b := vBP 1.481)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  rw [s1, s2, s3, s4, s5, s6, s7, s8, s9, s10]
  norm_num at e1 e2 e3 e4 e5 e6 e7 e8 e9 e10 ⊢
  linarith

set_option maxHeartbeats 1000000 in
/-- Partition chunk 49: the `q`-range `[1.481, 1.512]`. -/
theorem integral_abs_errFun_chunk49 :
    (∫ v in Ioi (vBP 1.481), |errFun v|)
      ≤ 0.003616 + ∫ v in Ioi (vBP 1.512), |errFun v| := by
  have e1 := integral_piece_asymp_le (q0 := 1.481) (q1 := 1.484) (M := 0.13649)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e2 := integral_piece_asymp_le (q0 := 1.484) (q1 := 1.486) (M := 0.13418)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e3 := integral_piece_asymp_le (q0 := 1.486) (q1 := 1.49) (M := 0.13509)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e4 := integral_piece_asymp_le (q0 := 1.49) (q1 := 1.492) (M := 0.13146)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e5 := integral_piece_asymp_le (q0 := 1.492) (q1 := 1.495) (M := 0.13147)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e6 := integral_piece_asymp_le (q0 := 1.495) (q1 := 1.498) (M := 0.13013)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e7 := integral_piece_asymp_le (q0 := 1.498) (q1 := 1.5) (M := 0.12795)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e8 := integral_piece_asymp_le (q0 := 1.5) (q1 := 1.504) (M := 0.12881)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e9 := integral_piece_asymp_le (q0 := 1.504) (q1 := 1.508) (M := 0.12708)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e10 := integral_piece_asymp_le (q0 := 1.508) (q1 := 1.512) (M := 0.12539)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have s1 := integral_Ioi_abs_errFun_split (a := vBP 1.481) (b := vBP 1.484)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s2 := integral_Ioi_abs_errFun_split (a := vBP 1.484) (b := vBP 1.486)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s3 := integral_Ioi_abs_errFun_split (a := vBP 1.486) (b := vBP 1.49)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s4 := integral_Ioi_abs_errFun_split (a := vBP 1.49) (b := vBP 1.492)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s5 := integral_Ioi_abs_errFun_split (a := vBP 1.492) (b := vBP 1.495)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s6 := integral_Ioi_abs_errFun_split (a := vBP 1.495) (b := vBP 1.498)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s7 := integral_Ioi_abs_errFun_split (a := vBP 1.498) (b := vBP 1.5)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s8 := integral_Ioi_abs_errFun_split (a := vBP 1.5) (b := vBP 1.504)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s9 := integral_Ioi_abs_errFun_split (a := vBP 1.504) (b := vBP 1.508)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s10 := integral_Ioi_abs_errFun_split (a := vBP 1.508) (b := vBP 1.512)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  rw [s1, s2, s3, s4, s5, s6, s7, s8, s9, s10]
  norm_num at e1 e2 e3 e4 e5 e6 e7 e8 e9 e10 ⊢
  linarith

set_option maxHeartbeats 1000000 in
/-- Partition chunk 50: the `q`-range `[1.512, 1.55]`. -/
theorem integral_abs_errFun_chunk50 :
    (∫ v in Ioi (vBP 1.512), |errFun v|)
      ≤ 0.003792 + ∫ v in Ioi (vBP 1.55), |errFun v| := by
  have e1 := integral_piece_asymp_le (q0 := 1.512) (q1 := 1.516) (M := 0.12372)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e2 := integral_piece_asymp_le (q0 := 1.516) (q1 := 1.52) (M := 0.12207)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e3 := integral_piece_asymp_le (q0 := 1.52) (q1 := 1.524) (M := 0.12046)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e4 := integral_piece_asymp_le (q0 := 1.524) (q1 := 1.528) (M := 0.11887)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e5 := integral_piece_asymp_le (q0 := 1.528) (q1 := 1.531) (M := 0.11653)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e6 := integral_piece_asymp_le (q0 := 1.531) (q1 := 1.534) (M := 0.11538)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e7 := integral_piece_asymp_le (q0 := 1.534) (q1 := 1.538) (M := 0.11501)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e8 := integral_piece_asymp_le (q0 := 1.538) (q1 := 1.542) (M := 0.11351)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e9 := integral_piece_asymp_le (q0 := 1.542) (q1 := 1.546) (M := 0.11203)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e10 := integral_piece_asymp_le (q0 := 1.546) (q1 := 1.55) (M := 0.11058)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have s1 := integral_Ioi_abs_errFun_split (a := vBP 1.512) (b := vBP 1.516)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s2 := integral_Ioi_abs_errFun_split (a := vBP 1.516) (b := vBP 1.52)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s3 := integral_Ioi_abs_errFun_split (a := vBP 1.52) (b := vBP 1.524)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s4 := integral_Ioi_abs_errFun_split (a := vBP 1.524) (b := vBP 1.528)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s5 := integral_Ioi_abs_errFun_split (a := vBP 1.528) (b := vBP 1.531)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s6 := integral_Ioi_abs_errFun_split (a := vBP 1.531) (b := vBP 1.534)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s7 := integral_Ioi_abs_errFun_split (a := vBP 1.534) (b := vBP 1.538)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s8 := integral_Ioi_abs_errFun_split (a := vBP 1.538) (b := vBP 1.542)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s9 := integral_Ioi_abs_errFun_split (a := vBP 1.542) (b := vBP 1.546)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s10 := integral_Ioi_abs_errFun_split (a := vBP 1.546) (b := vBP 1.55)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  rw [s1, s2, s3, s4, s5, s6, s7, s8, s9, s10]
  norm_num at e1 e2 e3 e4 e5 e6 e7 e8 e9 e10 ⊢
  linarith

set_option maxHeartbeats 1000000 in
/-- Partition chunk 51: the `q`-range `[1.55, 1.59]`. -/
theorem integral_abs_errFun_chunk51 :
    (∫ v in Ioi (vBP 1.55), |errFun v|)
      ≤ 0.003348 + ∫ v in Ioi (vBP 1.59), |errFun v| := by
  have e1 := integral_piece_asymp_le (q0 := 1.55) (q1 := 1.554) (M := 0.10915)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e2 := integral_piece_asymp_le (q0 := 1.554) (q1 := 1.558) (M := 0.10774)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e3 := integral_piece_asymp_le (q0 := 1.558) (q1 := 1.562) (M := 0.10636)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e4 := integral_piece_asymp_le (q0 := 1.562) (q1 := 1.566) (M := 0.105)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e5 := integral_piece_asymp_le (q0 := 1.566) (q1 := 1.57) (M := 0.10366)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e6 := integral_piece_asymp_le (q0 := 1.57) (q1 := 1.574) (M := 0.10234)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e7 := integral_piece_asymp_le (q0 := 1.574) (q1 := 1.578) (M := 0.10104)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e8 := integral_piece_asymp_le (q0 := 1.578) (q1 := 1.582) (M := 0.09976)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e9 := integral_piece_asymp_le (q0 := 1.582) (q1 := 1.586) (M := 0.09851)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e10 := integral_piece_asymp_le (q0 := 1.586) (q1 := 1.59) (M := 0.09727)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have s1 := integral_Ioi_abs_errFun_split (a := vBP 1.55) (b := vBP 1.554)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s2 := integral_Ioi_abs_errFun_split (a := vBP 1.554) (b := vBP 1.558)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s3 := integral_Ioi_abs_errFun_split (a := vBP 1.558) (b := vBP 1.562)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s4 := integral_Ioi_abs_errFun_split (a := vBP 1.562) (b := vBP 1.566)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s5 := integral_Ioi_abs_errFun_split (a := vBP 1.566) (b := vBP 1.57)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s6 := integral_Ioi_abs_errFun_split (a := vBP 1.57) (b := vBP 1.574)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s7 := integral_Ioi_abs_errFun_split (a := vBP 1.574) (b := vBP 1.578)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s8 := integral_Ioi_abs_errFun_split (a := vBP 1.578) (b := vBP 1.582)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s9 := integral_Ioi_abs_errFun_split (a := vBP 1.582) (b := vBP 1.586)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s10 := integral_Ioi_abs_errFun_split (a := vBP 1.586) (b := vBP 1.59)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  rw [s1, s2, s3, s4, s5, s6, s7, s8, s9, s10]
  norm_num at e1 e2 e3 e4 e5 e6 e7 e8 e9 e10 ⊢
  linarith

set_option maxHeartbeats 1000000 in
/-- Partition chunk 52: the `q`-range `[1.59, 1.64]`. -/
theorem integral_abs_errFun_chunk52 :
    (∫ v in Ioi (vBP 1.59), |errFun v|)
      ≤ 0.003474 + ∫ v in Ioi (vBP 1.64), |errFun v| := by
  have e1 := integral_piece_asymp_le (q0 := 1.59) (q1 := 1.594) (M := 0.09605)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e2 := integral_piece_asymp_le (q0 := 1.594) (q1 := 1.598) (M := 0.09485)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e3 := integral_piece_asymp_le (q0 := 1.598) (q1 := 1.602) (M := 0.09367)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e4 := integral_piece_asymp_le (q0 := 1.602) (q1 := 1.606) (M := 0.09251)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e5 := integral_piece_asymp_le (q0 := 1.606) (q1 := 1.61) (M := 0.09136)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e6 := integral_piece_asymp_le (q0 := 1.61) (q1 := 1.614) (M := 0.09024)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e7 := integral_piece_asymp_le (q0 := 1.614) (q1 := 1.618) (M := 0.08913)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e8 := integral_piece_asymp_le (q0 := 1.618) (q1 := 1.625) (M := 0.08973)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e9 := integral_piece_asymp_le (q0 := 1.625) (q1 := 1.632) (M := 0.08782)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e10 := integral_piece_asymp_le (q0 := 1.632) (q1 := 1.64) (M := 0.0865)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have s1 := integral_Ioi_abs_errFun_split (a := vBP 1.59) (b := vBP 1.594)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s2 := integral_Ioi_abs_errFun_split (a := vBP 1.594) (b := vBP 1.598)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s3 := integral_Ioi_abs_errFun_split (a := vBP 1.598) (b := vBP 1.602)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s4 := integral_Ioi_abs_errFun_split (a := vBP 1.602) (b := vBP 1.606)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s5 := integral_Ioi_abs_errFun_split (a := vBP 1.606) (b := vBP 1.61)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s6 := integral_Ioi_abs_errFun_split (a := vBP 1.61) (b := vBP 1.614)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s7 := integral_Ioi_abs_errFun_split (a := vBP 1.614) (b := vBP 1.618)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s8 := integral_Ioi_abs_errFun_split (a := vBP 1.618) (b := vBP 1.625)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s9 := integral_Ioi_abs_errFun_split (a := vBP 1.625) (b := vBP 1.632)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s10 := integral_Ioi_abs_errFun_split (a := vBP 1.632) (b := vBP 1.64)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  rw [s1, s2, s3, s4, s5, s6, s7, s8, s9, s10]
  norm_num at e1 e2 e3 e4 e5 e6 e7 e8 e9 e10 ⊢
  linarith

set_option maxHeartbeats 1000000 in
/-- Partition chunk 53: the `q`-range `[1.64, 1.719]`. -/
theorem integral_abs_errFun_chunk53 :
    (∫ v in Ioi (vBP 1.64), |errFun v|)
      ≤ 0.004274 + ∫ v in Ioi (vBP 1.719), |errFun v| := by
  have e1 := integral_piece_asymp_le (q0 := 1.64) (q1 := 1.648) (M := 0.08443)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e2 := integral_piece_asymp_le (q0 := 1.648) (q1 := 1.656) (M := 0.08241)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e3 := integral_piece_asymp_le (q0 := 1.656) (q1 := 1.664) (M := 0.08046)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e4 := integral_piece_asymp_le (q0 := 1.664) (q1 := 1.672) (M := 0.07857)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e5 := integral_piece_asymp_le (q0 := 1.672) (q1 := 1.68) (M := 0.07673)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e6 := integral_piece_asymp_le (q0 := 1.68) (q1 := 1.688) (M := 0.07495)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e7 := integral_piece_asymp_le (q0 := 1.688) (q1 := 1.696) (M := 0.07322)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e8 := integral_piece_asymp_le (q0 := 1.696) (q1 := 1.704) (M := 0.07154)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e9 := integral_piece_asymp_le (q0 := 1.704) (q1 := 1.712) (M := 0.06991)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e10 := integral_piece_asymp_le (q0 := 1.712) (q1 := 1.719) (M := 0.06791)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have s1 := integral_Ioi_abs_errFun_split (a := vBP 1.64) (b := vBP 1.648)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s2 := integral_Ioi_abs_errFun_split (a := vBP 1.648) (b := vBP 1.656)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s3 := integral_Ioi_abs_errFun_split (a := vBP 1.656) (b := vBP 1.664)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s4 := integral_Ioi_abs_errFun_split (a := vBP 1.664) (b := vBP 1.672)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s5 := integral_Ioi_abs_errFun_split (a := vBP 1.672) (b := vBP 1.68)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s6 := integral_Ioi_abs_errFun_split (a := vBP 1.68) (b := vBP 1.688)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s7 := integral_Ioi_abs_errFun_split (a := vBP 1.688) (b := vBP 1.696)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s8 := integral_Ioi_abs_errFun_split (a := vBP 1.696) (b := vBP 1.704)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s9 := integral_Ioi_abs_errFun_split (a := vBP 1.704) (b := vBP 1.712)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s10 := integral_Ioi_abs_errFun_split (a := vBP 1.712) (b := vBP 1.719)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  rw [s1, s2, s3, s4, s5, s6, s7, s8, s9, s10]
  norm_num at e1 e2 e3 e4 e5 e6 e7 e8 e9 e10 ⊢
  linarith

set_option maxHeartbeats 1000000 in
/-- Partition chunk 54: the `q`-range `[1.719, 1.796]`. -/
theorem integral_abs_errFun_chunk54 :
    (∫ v in Ioi (vBP 1.719), |errFun v|)
      ≤ 0.003041 + ∫ v in Ioi (vBP 1.796), |errFun v| := by
  have e1 := integral_piece_asymp_le (q0 := 1.719) (q1 := 1.726) (M := 0.06657)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e2 := integral_piece_asymp_le (q0 := 1.726) (q1 := 1.734) (M := 0.06567)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e3 := integral_piece_asymp_le (q0 := 1.734) (q1 := 1.742) (M := 0.06421)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e4 := integral_piece_asymp_le (q0 := 1.742) (q1 := 1.75) (M := 0.0628)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e5 := integral_piece_asymp_le (q0 := 1.75) (q1 := 1.758) (M := 0.06142)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e6 := integral_piece_asymp_le (q0 := 1.758) (q1 := 1.766) (M := 0.06009)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e7 := integral_piece_asymp_le (q0 := 1.766) (q1 := 1.774) (M := 0.05879)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e8 := integral_piece_asymp_le (q0 := 1.774) (q1 := 1.781) (M := 0.05717)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e9 := integral_piece_asymp_le (q0 := 1.781) (q1 := 1.788) (M := 0.0561)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e10 := integral_piece_asymp_le (q0 := 1.788) (q1 := 1.796) (M := 0.0554)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have s1 := integral_Ioi_abs_errFun_split (a := vBP 1.719) (b := vBP 1.726)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s2 := integral_Ioi_abs_errFun_split (a := vBP 1.726) (b := vBP 1.734)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s3 := integral_Ioi_abs_errFun_split (a := vBP 1.734) (b := vBP 1.742)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s4 := integral_Ioi_abs_errFun_split (a := vBP 1.742) (b := vBP 1.75)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s5 := integral_Ioi_abs_errFun_split (a := vBP 1.75) (b := vBP 1.758)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s6 := integral_Ioi_abs_errFun_split (a := vBP 1.758) (b := vBP 1.766)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s7 := integral_Ioi_abs_errFun_split (a := vBP 1.766) (b := vBP 1.774)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s8 := integral_Ioi_abs_errFun_split (a := vBP 1.774) (b := vBP 1.781)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s9 := integral_Ioi_abs_errFun_split (a := vBP 1.781) (b := vBP 1.788)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s10 := integral_Ioi_abs_errFun_split (a := vBP 1.788) (b := vBP 1.796)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  rw [s1, s2, s3, s4, s5, s6, s7, s8, s9, s10]
  norm_num at e1 e2 e3 e4 e5 e6 e7 e8 e9 e10 ⊢
  linarith

set_option maxHeartbeats 1000000 in
/-- Partition chunk 55: the `q`-range `[1.796, 1.938]`. -/
theorem integral_abs_errFun_chunk55 :
    (∫ v in Ioi (vBP 1.796), |errFun v|)
      ≤ 0.003957 + ∫ v in Ioi (vBP 1.938), |errFun v| := by
  have e1 := integral_piece_asymp_le (q0 := 1.796) (q1 := 1.804) (M := 0.05423)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e2 := integral_piece_asymp_le (q0 := 1.804) (q1 := 1.812) (M := 0.0531)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e3 := integral_piece_asymp_le (q0 := 1.812) (q1 := 1.828) (M := 0.05456)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e4 := integral_piece_asymp_le (q0 := 1.828) (q1 := 1.844) (M := 0.05235)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e5 := integral_piece_asymp_le (q0 := 1.844) (q1 := 1.86) (M := 0.05025)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e6 := integral_piece_asymp_le (q0 := 1.86) (q1 := 1.875) (M := 0.04799)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e7 := integral_piece_asymp_le (q0 := 1.875) (q1 := 1.89) (M := 0.04624)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e8 := integral_piece_asymp_le (q0 := 1.89) (q1 := 1.906) (M := 0.04483)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e9 := integral_piece_asymp_le (q0 := 1.906) (q1 := 1.922) (M := 0.04314)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e10 := integral_piece_asymp_le (q0 := 1.922) (q1 := 1.938) (M := 0.04153)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have s1 := integral_Ioi_abs_errFun_split (a := vBP 1.796) (b := vBP 1.804)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s2 := integral_Ioi_abs_errFun_split (a := vBP 1.804) (b := vBP 1.812)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s3 := integral_Ioi_abs_errFun_split (a := vBP 1.812) (b := vBP 1.828)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s4 := integral_Ioi_abs_errFun_split (a := vBP 1.828) (b := vBP 1.844)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s5 := integral_Ioi_abs_errFun_split (a := vBP 1.844) (b := vBP 1.86)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s6 := integral_Ioi_abs_errFun_split (a := vBP 1.86) (b := vBP 1.875)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s7 := integral_Ioi_abs_errFun_split (a := vBP 1.875) (b := vBP 1.89)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s8 := integral_Ioi_abs_errFun_split (a := vBP 1.89) (b := vBP 1.906)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s9 := integral_Ioi_abs_errFun_split (a := vBP 1.906) (b := vBP 1.922)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s10 := integral_Ioi_abs_errFun_split (a := vBP 1.922) (b := vBP 1.938)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  rw [s1, s2, s3, s4, s5, s6, s7, s8, s9, s10]
  norm_num at e1 e2 e3 e4 e5 e6 e7 e8 e9 e10 ⊢
  linarith

set_option maxHeartbeats 1000000 in
/-- Partition chunk 56: the `q`-range `[1.938, 2.094]`. -/
theorem integral_abs_errFun_chunk56 :
    (∫ v in Ioi (vBP 1.938), |errFun v|)
      ≤ 0.002814 + ∫ v in Ioi (vBP 2.094), |errFun v| := by
  have e1 := integral_piece_asymp_le (q0 := 1.938) (q1 := 1.954) (M := 0.04)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e2 := integral_piece_asymp_le (q0 := 1.954) (q1 := 1.969) (M := 0.03833)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e3 := integral_piece_asymp_le (q0 := 1.969) (q1 := 1.984) (M := 0.03747)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e4 := integral_piece_asymp_le (q0 := 1.984) (q1 := 2) (M := 0.03721)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e5 := integral_piece_asymp_le (q0 := 2) (q1 := 2.016) (M := 0.03668)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e6 := integral_piece_asymp_le (q0 := 2.016) (q1 := 2.031) (M := 0.03593)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e7 := integral_piece_asymp_le (q0 := 2.031) (q1 := 2.046) (M := 0.03546)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e8 := integral_piece_asymp_le (q0 := 2.046) (q1 := 2.062) (M := 0.03522)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e9 := integral_piece_asymp_le (q0 := 2.062) (q1 := 2.078) (M := 0.03473)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e10 := integral_piece_asymp_le (q0 := 2.078) (q1 := 2.094) (M := 0.03425)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have s1 := integral_Ioi_abs_errFun_split (a := vBP 1.938) (b := vBP 1.954)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s2 := integral_Ioi_abs_errFun_split (a := vBP 1.954) (b := vBP 1.969)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s3 := integral_Ioi_abs_errFun_split (a := vBP 1.969) (b := vBP 1.984)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s4 := integral_Ioi_abs_errFun_split (a := vBP 1.984) (b := vBP 2)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s5 := integral_Ioi_abs_errFun_split (a := vBP 2) (b := vBP 2.016)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s6 := integral_Ioi_abs_errFun_split (a := vBP 2.016) (b := vBP 2.031)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s7 := integral_Ioi_abs_errFun_split (a := vBP 2.031) (b := vBP 2.046)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s8 := integral_Ioi_abs_errFun_split (a := vBP 2.046) (b := vBP 2.062)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s9 := integral_Ioi_abs_errFun_split (a := vBP 2.062) (b := vBP 2.078)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s10 := integral_Ioi_abs_errFun_split (a := vBP 2.078) (b := vBP 2.094)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  rw [s1, s2, s3, s4, s5, s6, s7, s8, s9, s10]
  norm_num at e1 e2 e3 e4 e5 e6 e7 e8 e9 e10 ⊢
  linarith

set_option maxHeartbeats 1000000 in
/-- Partition chunk 57: the `q`-range `[2.094, 2.406]`. -/
theorem integral_abs_errFun_chunk57 :
    (∫ v in Ioi (vBP 2.094), |errFun v|)
      ≤ 0.004025 + ∫ v in Ioi (vBP 2.406), |errFun v| := by
  have e1 := integral_piece_asymp_le (q0 := 2.094) (q1 := 2.125) (M := 0.03661)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e2 := integral_piece_asymp_le (q0 := 2.125) (q1 := 2.156) (M := 0.03554)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e3 := integral_piece_asymp_le (q0 := 2.156) (q1 := 2.188) (M := 0.03468)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e4 := integral_piece_asymp_le (q0 := 2.188) (q1 := 2.219) (M := 0.0335)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e5 := integral_piece_asymp_le (q0 := 2.219) (q1 := 2.25) (M := 0.03256)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e6 := integral_piece_asymp_le (q0 := 2.25) (q1 := 2.281) (M := 0.03165)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e7 := integral_piece_asymp_le (q0 := 2.281) (q1 := 2.312) (M := 0.03078)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e8 := integral_piece_asymp_le (q0 := 2.312) (q1 := 2.344) (M := 0.03006)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e9 := integral_piece_asymp_le (q0 := 2.344) (q1 := 2.375) (M := 0.0291)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e10 := integral_piece_asymp_le (q0 := 2.375) (q1 := 2.406) (M := 0.02832)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have s1 := integral_Ioi_abs_errFun_split (a := vBP 2.094) (b := vBP 2.125)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s2 := integral_Ioi_abs_errFun_split (a := vBP 2.125) (b := vBP 2.156)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s3 := integral_Ioi_abs_errFun_split (a := vBP 2.156) (b := vBP 2.188)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s4 := integral_Ioi_abs_errFun_split (a := vBP 2.188) (b := vBP 2.219)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s5 := integral_Ioi_abs_errFun_split (a := vBP 2.219) (b := vBP 2.25)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s6 := integral_Ioi_abs_errFun_split (a := vBP 2.25) (b := vBP 2.281)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s7 := integral_Ioi_abs_errFun_split (a := vBP 2.281) (b := vBP 2.312)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s8 := integral_Ioi_abs_errFun_split (a := vBP 2.312) (b := vBP 2.344)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s9 := integral_Ioi_abs_errFun_split (a := vBP 2.344) (b := vBP 2.375)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s10 := integral_Ioi_abs_errFun_split (a := vBP 2.375) (b := vBP 2.406)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  rw [s1, s2, s3, s4, s5, s6, s7, s8, s9, s10]
  norm_num at e1 e2 e3 e4 e5 e6 e7 e8 e9 e10 ⊢
  linarith

set_option maxHeartbeats 1000000 in
/-- Partition chunk 58: the `q`-range `[2.406, 2.875]`. -/
theorem integral_abs_errFun_chunk58 :
    (∫ v in Ioi (vBP 2.406), |errFun v|)
      ≤ 0.003368 + ∫ v in Ioi (vBP 2.875), |errFun v| := by
  have e1 := integral_piece_asymp_le (q0 := 2.406) (q1 := 2.438) (M := 0.02766)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e2 := integral_piece_asymp_le (q0 := 2.438) (q1 := 2.469) (M := 0.02681)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e3 := integral_piece_asymp_le (q0 := 2.469) (q1 := 2.5) (M := 0.02611)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e4 := integral_piece_asymp_le (q0 := 2.5) (q1 := 2.531) (M := 0.02543)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e5 := integral_piece_asymp_le (q0 := 2.531) (q1 := 2.562) (M := 0.02477)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e6 := integral_piece_asymp_le (q0 := 2.562) (q1 := 2.625) (M := 0.0266)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e7 := integral_piece_asymp_le (q0 := 2.625) (q1 := 2.688) (M := 0.02515)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e8 := integral_piece_asymp_le (q0 := 2.688) (q1 := 2.75) (M := 0.02375)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e9 := integral_piece_asymp_le (q0 := 2.75) (q1 := 2.812) (M := 0.02253)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e10 := integral_piece_asymp_le (q0 := 2.812) (q1 := 2.875) (M := 0.02144)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have s1 := integral_Ioi_abs_errFun_split (a := vBP 2.406) (b := vBP 2.438)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s2 := integral_Ioi_abs_errFun_split (a := vBP 2.438) (b := vBP 2.469)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s3 := integral_Ioi_abs_errFun_split (a := vBP 2.469) (b := vBP 2.5)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s4 := integral_Ioi_abs_errFun_split (a := vBP 2.5) (b := vBP 2.531)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s5 := integral_Ioi_abs_errFun_split (a := vBP 2.531) (b := vBP 2.562)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s6 := integral_Ioi_abs_errFun_split (a := vBP 2.562) (b := vBP 2.625)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s7 := integral_Ioi_abs_errFun_split (a := vBP 2.625) (b := vBP 2.688)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s8 := integral_Ioi_abs_errFun_split (a := vBP 2.688) (b := vBP 2.75)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s9 := integral_Ioi_abs_errFun_split (a := vBP 2.75) (b := vBP 2.812)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s10 := integral_Ioi_abs_errFun_split (a := vBP 2.812) (b := vBP 2.875)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  rw [s1, s2, s3, s4, s5, s6, s7, s8, s9, s10]
  norm_num at e1 e2 e3 e4 e5 e6 e7 e8 e9 e10 ⊢
  linarith

set_option maxHeartbeats 1000000 in
/-- Partition chunk 59: the `q`-range `[2.875, 3.938]`. -/
theorem integral_abs_errFun_chunk59 :
    (∫ v in Ioi (vBP 2.875), |errFun v|)
      ≤ 0.003099 + ∫ v in Ioi (vBP 3.938), |errFun v| := by
  have e1 := integral_piece_asymp_le (q0 := 2.875) (q1 := 2.938) (M := 0.02037)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e2 := integral_piece_asymp_le (q0 := 2.938) (q1 := 3) (M := 0.01932)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e3 := integral_piece_asymp_le (q0 := 3) (q1 := 3.094) (M := 0.0197)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e4 := integral_piece_asymp_le (q0 := 3.094) (q1 := 3.188) (M := 0.01828)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e5 := integral_piece_asymp_le (q0 := 3.188) (q1 := 3.282) (M := 0.01701)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e6 := integral_piece_asymp_le (q0 := 3.282) (q1 := 3.375) (M := 0.01582)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e7 := integral_piece_asymp_le (q0 := 3.375) (q1 := 3.468) (M := 0.01479)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e8 := integral_piece_asymp_le (q0 := 3.468) (q1 := 3.562) (M := 0.01387)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e9 := integral_piece_asymp_le (q0 := 3.562) (q1 := 3.75) (M := 0.01501)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e10 := integral_piece_asymp_le (q0 := 3.75) (q1 := 3.938) (M := 0.01319)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have s1 := integral_Ioi_abs_errFun_split (a := vBP 2.875) (b := vBP 2.938)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s2 := integral_Ioi_abs_errFun_split (a := vBP 2.938) (b := vBP 3)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s3 := integral_Ioi_abs_errFun_split (a := vBP 3) (b := vBP 3.094)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s4 := integral_Ioi_abs_errFun_split (a := vBP 3.094) (b := vBP 3.188)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s5 := integral_Ioi_abs_errFun_split (a := vBP 3.188) (b := vBP 3.282)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s6 := integral_Ioi_abs_errFun_split (a := vBP 3.282) (b := vBP 3.375)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s7 := integral_Ioi_abs_errFun_split (a := vBP 3.375) (b := vBP 3.468)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s8 := integral_Ioi_abs_errFun_split (a := vBP 3.468) (b := vBP 3.562)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s9 := integral_Ioi_abs_errFun_split (a := vBP 3.562) (b := vBP 3.75)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s10 := integral_Ioi_abs_errFun_split (a := vBP 3.75) (b := vBP 3.938)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  rw [s1, s2, s3, s4, s5, s6, s7, s8, s9, s10]
  norm_num at e1 e2 e3 e4 e5 e6 e7 e8 e9 e10 ⊢
  linarith

set_option maxHeartbeats 1000000 in
/-- Partition chunk 60: the `q`-range `[3.938, 13.5]`. -/
theorem integral_abs_errFun_chunk60 :
    (∫ v in Ioi (vBP 3.938), |errFun v|)
      ≤ 0.002719 + ∫ v in Ioi (vBP 13.5), |errFun v| := by
  have e1 := integral_piece_asymp_le (q0 := 3.938) (q1 := 4.125) (M := 0.01165)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e2 := integral_piece_asymp_le (q0 := 4.125) (q1 := 4.5) (M := 0.01265)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e3 := integral_piece_asymp_le (q0 := 4.5) (q1 := 4.875) (M := 0.01012)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e4 := integral_piece_asymp_le (q0 := 4.875) (q1 := 5.25) (M := 0.00826)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e5 := integral_piece_asymp_le (q0 := 5.25) (q1 := 6) (M := 0.00877)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e6 := integral_piece_asymp_le (q0 := 6) (q1 := 6.75) (M := 0.00625)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e7 := integral_piece_asymp_le (q0 := 6.75) (q1 := 7.5) (M := 0.00465)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e8 := integral_piece_asymp_le (q0 := 7.5) (q1 := 9) (M := 0.00474)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have e9 := integral_piece_asymp_le (q0 := 9) (q1 := 13.5) (M := 0.00478)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have s1 := integral_Ioi_abs_errFun_split (a := vBP 3.938) (b := vBP 4.125)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s2 := integral_Ioi_abs_errFun_split (a := vBP 4.125) (b := vBP 4.5)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s3 := integral_Ioi_abs_errFun_split (a := vBP 4.5) (b := vBP 4.875)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s4 := integral_Ioi_abs_errFun_split (a := vBP 4.875) (b := vBP 5.25)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s5 := integral_Ioi_abs_errFun_split (a := vBP 5.25) (b := vBP 6)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s6 := integral_Ioi_abs_errFun_split (a := vBP 6) (b := vBP 6.75)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s7 := integral_Ioi_abs_errFun_split (a := vBP 6.75) (b := vBP 7.5)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s8 := integral_Ioi_abs_errFun_split (a := vBP 7.5) (b := vBP 9)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s9 := integral_Ioi_abs_errFun_split (a := vBP 9) (b := vBP 13.5)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  rw [s1, s2, s3, s4, s5, s6, s7, s8, s9]
  norm_num at e1 e2 e3 e4 e5 e6 e7 e8 e9 ⊢
  linarith

set_option maxHeartbeats 1000000 in
/-- **The certified L¹ bound for the model error**: `∫₀^∞ |δ(e^v) - h(v)| dv ≤ 0.21088`.
The partition has 600 breakpoints; the true value of the integral is `≈ 0.1741`. -/
theorem integral_Ioi_abs_errFun_le : (∫ v in Ioi (0:ℝ), |errFun v|) ≤ 0.21088 := by
  have et := integral_tail_le (q0 := 13.5) (M := 0.00336)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have c1 := integral_abs_errFun_chunk1
  have c2 := integral_abs_errFun_chunk2
  have c3 := integral_abs_errFun_chunk3
  have c4 := integral_abs_errFun_chunk4
  have c5 := integral_abs_errFun_chunk5
  have c6 := integral_abs_errFun_chunk6
  have c7 := integral_abs_errFun_chunk7
  have c8 := integral_abs_errFun_chunk8
  have c9 := integral_abs_errFun_chunk9
  have c10 := integral_abs_errFun_chunk10
  have c11 := integral_abs_errFun_chunk11
  have c12 := integral_abs_errFun_chunk12
  have c13 := integral_abs_errFun_chunk13
  have c14 := integral_abs_errFun_chunk14
  have c15 := integral_abs_errFun_chunk15
  have c16 := integral_abs_errFun_chunk16
  have c17 := integral_abs_errFun_chunk17
  have c18 := integral_abs_errFun_chunk18
  have c19 := integral_abs_errFun_chunk19
  have c20 := integral_abs_errFun_chunk20
  have c21 := integral_abs_errFun_chunk21
  have c22 := integral_abs_errFun_chunk22
  have c23 := integral_abs_errFun_chunk23
  have c24 := integral_abs_errFun_chunk24
  have c25 := integral_abs_errFun_chunk25
  have c26 := integral_abs_errFun_chunk26
  have c27 := integral_abs_errFun_chunk27
  have c28 := integral_abs_errFun_chunk28
  have c29 := integral_abs_errFun_chunk29
  have c30 := integral_abs_errFun_chunk30
  have c31 := integral_abs_errFun_chunk31
  have c32 := integral_abs_errFun_chunk32
  have c33 := integral_abs_errFun_chunk33
  have c34 := integral_abs_errFun_chunk34
  have c35 := integral_abs_errFun_chunk35
  have c36 := integral_abs_errFun_chunk36
  have c37 := integral_abs_errFun_chunk37
  have c38 := integral_abs_errFun_chunk38
  have c39 := integral_abs_errFun_chunk39
  have c40 := integral_abs_errFun_chunk40
  have c41 := integral_abs_errFun_chunk41
  have c42 := integral_abs_errFun_chunk42
  have c43 := integral_abs_errFun_chunk43
  have c44 := integral_abs_errFun_chunk44
  have c45 := integral_abs_errFun_chunk45
  have c46 := integral_abs_errFun_chunk46
  have c47 := integral_abs_errFun_chunk47
  have c48 := integral_abs_errFun_chunk48
  have c49 := integral_abs_errFun_chunk49
  have c50 := integral_abs_errFun_chunk50
  have c51 := integral_abs_errFun_chunk51
  have c52 := integral_abs_errFun_chunk52
  have c53 := integral_abs_errFun_chunk53
  have c54 := integral_abs_errFun_chunk54
  have c55 := integral_abs_errFun_chunk55
  have c56 := integral_abs_errFun_chunk56
  have c57 := integral_abs_errFun_chunk57
  have c58 := integral_abs_errFun_chunk58
  have c59 := integral_abs_errFun_chunk59
  have c60 := integral_abs_errFun_chunk60
  have h0 : (∫ v in Ioi (0:ℝ), |errFun v|) = ∫ v in Ioi (vBP 1), |errFun v| := by
    rw [vBP_one]
  rw [h0]
  norm_num at et c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 c16 c17 c18 c19 c20 c21 c22 c23 c24 c25 c26 c27 c28 c29 c30 c31 c32 c33 c34 c35 c36 c37 c38 c39 c40 c41 c42 c43 c44 c45 c46 c47 c48 c49 c50 c51 c52 c53 c54 c55 c56 c57 c58 c59 c60 ⊢
  linarith

end ConnesConsani.WeilPositivity
