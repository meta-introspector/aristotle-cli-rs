/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBase

/-!
# Oscillatory blocks, part 1

Rational brackets for the 74 block breakpoints `vBP q` and the signed integral brackets
`errIntBracket (vBP q0) (vBP q1) P0 P1 S` for the first group of blocks.  The 560 pieces of the
partition of `RequestProject/PolyaPartition1.lean`–`PolyaPartition3.lean` covering the `q`-range
`[1, 2.094]` are grouped into 73 blocks, chosen so that the loss incurred by replacing `cos(tv)`
by a constant on a block stays below a fixed budget.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

/-! ### Rational brackets for the block breakpoints `vBP q = 2 log q` -/

theorem vbpBr0 : (0.0 : ℝ) ≤ vBP 1 ∧ vBP 1 ≤ 0.0 := by
  rw [vBP_one]; norm_num

theorem vbpBr1 : (0.00758559 : ℝ) ≤ vBP 1.0038 ∧ vBP 1.0038 ≤ 0.0075856 := by
  have h := vBP_bracket 12 (q := 1.0038) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr2 : (0.01553947 : ℝ) ≤ vBP 1.0078 ∧ vBP 1.0078 ≤ 0.01553948 := by
  have h := vBP_bracket 12 (q := 1.0078) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr3 : (0.02346184 : ℝ) ≤ vBP 1.0118 ∧ vBP 1.0118 ≤ 0.02346185 := by
  have h := vBP_bracket 12 (q := 1.0118) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr4 : (0.03174669 : ℝ) ≤ vBP 1.016 ∧ vBP 1.016 ≤ 0.0317467 := by
  have h := vBP_bracket 12 (q := 1.016) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr5 : (0.0405854 : ℝ) ≤ vBP 1.0205 ∧ vBP 1.0205 ≤ 0.04058541 := by
  have h := vBP_bracket 12 (q := 1.0205) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr6 : (0.04938522 : ℝ) ≤ vBP 1.025 ∧ vBP 1.025 ≤ 0.04938523 := by
  have h := vBP_bracket 12 (q := 1.025) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr7 : (0.0591176 : ℝ) ≤ vBP 1.03 ∧ vBP 1.03 ≤ 0.05911761 := by
  have h := vBP_bracket 12 (q := 1.03) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr8 : (0.0697688 : ℝ) ≤ vBP 1.0355 ∧ vBP 1.0355 ≤ 0.06976881 := by
  have h := vBP_bracket 12 (q := 1.0355) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr9 : (0.08132396 : ℝ) ≤ vBP 1.0415 ∧ vBP 1.0415 ≤ 0.08132397 := by
  have h := vBP_bracket 12 (q := 1.0415) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr10 : (0.09376717 : ℝ) ≤ vBP 1.048 ∧ vBP 1.048 ≤ 0.09376718 := by
  have h := vBP_bracket 12 (q := 1.048) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr11 : (0.10708153 : ℝ) ≤ vBP 1.055 ∧ vBP 1.055 ≤ 0.10708154 := by
  have h := vBP_bracket 12 (q := 1.055) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr12 : (0.12407078 : ℝ) ≤ vBP 1.064 ∧ vBP 1.064 ≤ 0.12407079 := by
  have h := vBP_bracket 12 (q := 1.064) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr13 : (0.15021494 : ℝ) ≤ vBP 1.078 ∧ vBP 1.078 ≤ 0.15021495 := by
  have h := vBP_bracket 12 (q := 1.078) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr14 : (0.17235539 : ℝ) ≤ vBP 1.09 ∧ vBP 1.09 ≤ 0.1723554 := by
  have h := vBP_bracket 12 (q := 1.09) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr15 : (0.19062035 : ℝ) ≤ vBP 1.1 ∧ vBP 1.1 ≤ 0.19062036 := by
  have h := vBP_bracket 12 (q := 1.1) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr16 : (0.20691741 : ℝ) ≤ vBP 1.109 ∧ vBP 1.109 ≤ 0.20691742 := by
  have h := vBP_bracket 12 (q := 1.109) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr17 : (0.22129304 : ℝ) ≤ vBP 1.117 ∧ vBP 1.117 ≤ 0.22129305 := by
  have h := vBP_bracket 12 (q := 1.117) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr18 : (0.2337875 : ℝ) ≤ vBP 1.124 ∧ vBP 1.124 ≤ 0.23378751 := by
  have h := vBP_bracket 12 (q := 1.124) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr19 : (0.24620439 : ℝ) ≤ vBP 1.131 ∧ vBP 1.131 ≤ 0.2462044 := by
  have h := vBP_bracket 12 (q := 1.131) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr20 : (0.25854467 : ℝ) ≤ vBP 1.138 ∧ vBP 1.138 ≤ 0.25854468 := by
  have h := vBP_bracket 12 (q := 1.138) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr21 : (0.27080927 : ℝ) ≤ vBP 1.145 ∧ vBP 1.145 ≤ 0.27080928 := by
  have h := vBP_bracket 12 (q := 1.145) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr22 : (0.28299912 : ℝ) ≤ vBP 1.152 ∧ vBP 1.152 ≤ 0.28299913 := by
  have h := vBP_bracket 12 (q := 1.152) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr23 : (0.29511512 : ℝ) ≤ vBP 1.159 ∧ vBP 1.159 ≤ 0.29511513 := by
  have h := vBP_bracket 12 (q := 1.159) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr24 : (0.30715817 : ℝ) ≤ vBP 1.166 ∧ vBP 1.166 ≤ 0.30715818 := by
  have h := vBP_bracket 12 (q := 1.166) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr25 : (0.31912913 : ℝ) ≤ vBP 1.173 ∧ vBP 1.173 ≤ 0.31912914 := by
  have h := vBP_bracket 12 (q := 1.173) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr26 : (0.33102887 : ℝ) ≤ vBP 1.18 ∧ vBP 1.18 ≤ 0.33102888 := by
  have h := vBP_bracket 12 (q := 1.18) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr27 : (0.34285823 : ℝ) ≤ vBP 1.187 ∧ vBP 1.187 ≤ 0.34285824 := by
  have h := vBP_bracket 12 (q := 1.187) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr28 : (0.35461802 : ℝ) ≤ vBP 1.194 ∧ vBP 1.194 ≤ 0.35461804 := by
  have h := vBP_bracket 12 (q := 1.194) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr29 : (0.36630908 : ℝ) ≤ vBP 1.201 ∧ vBP 1.201 ≤ 0.36630909 := by
  have h := vBP_bracket 12 (q := 1.201) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr30 : (0.37793219 : ℝ) ≤ vBP 1.208 ∧ vBP 1.208 ≤ 0.3779322 := by
  have h := vBP_bracket 12 (q := 1.208) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr31 : (0.38948815 : ℝ) ≤ vBP 1.215 ∧ vBP 1.215 ≤ 0.38948816 := by
  have h := vBP_bracket 12 (q := 1.215) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr32 : (0.40261371 : ℝ) ≤ vBP 1.223 ∧ vBP 1.223 ≤ 0.40261372 := by
  have h := vBP_bracket 12 (q := 1.223) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr33 : (0.41565369 : ℝ) ≤ vBP 1.231 ∧ vBP 1.231 ≤ 0.4156537 := by
  have h := vBP_bracket 12 (q := 1.231) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr34 : (0.4286092 : ℝ) ≤ vBP 1.239 ∧ vBP 1.239 ≤ 0.42860921 := by
  have h := vBP_bracket 12 (q := 1.239) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr35 : (0.44308453 : ℝ) ≤ vBP 1.248 ∧ vBP 1.248 ≤ 0.44308455 := by
  have h := vBP_bracket 12 (q := 1.248) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr36 : (0.45904631 : ℝ) ≤ vBP 1.258 ∧ vBP 1.258 ≤ 0.45904632 := by
  have h := vBP_bracket 12 (q := 1.258) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr37 : (0.4748817 : ℝ) ≤ vBP 1.268 ∧ vBP 1.268 ≤ 0.47488172 := by
  have h := vBP_bracket 12 (q := 1.268) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr38 : (0.49372014 : ℝ) ≤ vBP 1.28 ∧ vBP 1.28 ≤ 0.49372017 := by
  have h := vBP_bracket 12 (q := 1.28) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr39 : (0.51547638 : ℝ) ≤ vBP 1.294 ∧ vBP 1.294 ≤ 0.51547641 := by
  have h := vBP_bracket 12 (q := 1.294) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr40 : (0.53699848 : ℝ) ≤ vBP 1.308 ∧ vBP 1.308 ≤ 0.53699853 := by
  have h := vBP_bracket 12 (q := 1.308) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr41 : (0.56433374 : ℝ) ≤ vBP 1.326 ∧ vBP 1.326 ≤ 0.56433382 := by
  have h := vBP_bracket 12 (q := 1.326) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr42 : (0.59278796 : ℝ) ≤ vBP 1.345 ∧ vBP 1.345 ≤ 0.59278808 := by
  have h := vBP_bracket 12 (q := 1.345) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr43 : (0.61790831 : ℝ) ≤ vBP 1.362 ∧ vBP 1.362 ≤ 0.6179085 := by
  have h := vBP_bracket 12 (q := 1.362) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr44 : (0.63836133 : ℝ) ≤ vBP 1.376 ∧ vBP 1.376 ≤ 0.6383616 := by
  have h := vBP_bracket 12 (q := 1.376) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr45 : (0.65860729 : ℝ) ≤ vBP 1.39 ∧ vBP 1.39 ≤ 0.65860767 := by
  have h := vBP_bracket 12 (q := 1.39) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr46 : (0.67865033 : ℝ) ≤ vBP 1.404 ∧ vBP 1.404 ≤ 0.67865086 := by
  have h := vBP_bracket 12 (q := 1.404) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr47 : (0.69849446 : ℝ) ≤ vBP 1.418 ∧ vBP 1.418 ≤ 0.69849519 := by
  have h := vBP_bracket 12 (q := 1.418) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr48 : (0.7181436 : ℝ) ≤ vBP 1.432 ∧ vBP 1.432 ≤ 0.7181446 := by
  have h := vBP_bracket 12 (q := 1.432) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr49 : (0.73760153 : ℝ) ≤ vBP 1.446 ∧ vBP 1.446 ≤ 0.73760286 := by
  have h := vBP_bracket 12 (q := 1.446) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr50 : (0.75960973 : ℝ) ≤ vBP 1.462 ∧ vBP 1.462 ≤ 0.75961158 := by
  have h := vBP_bracket 12 (q := 1.462) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr51 : (0.7813783 : ℝ) ≤ vBP 1.478 ∧ vBP 1.478 ≤ 0.78138081 := by
  have h := vBP_bracket 12 (q := 1.478) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr52 : (0.80425056 : ℝ) ≤ vBP 1.495 ∧ vBP 1.495 ≤ 0.80425401 := by
  have h := vBP_bracket 12 (q := 1.495) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr53 : (0.82686405 : ℝ) ≤ vBP 1.512 ∧ vBP 1.512 ≤ 0.82686872 := by
  have h := vBP_bracket 12 (q := 1.512) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr54 : (0.85183877 : ℝ) ≤ vBP 1.531 ∧ vBP 1.531 ≤ 0.85184522 := by
  have h := vBP_bracket 12 (q := 1.531) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr55 : (0.87650515 : ℝ) ≤ vBP 1.55 ∧ vBP 1.55 ≤ 0.87651393 := by
  have h := vBP_bracket 12 (q := 1.55) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr56 : (0.90214481 : ℝ) ≤ vBP 1.57 ∧ vBP 1.57 ≤ 0.90215678 := by
  have h := vBP_bracket 12 (q := 1.57) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr57 : (0.92745939 : ℝ) ≤ vBP 1.59 ∧ vBP 1.59 ≤ 0.92747548 := by
  have h := vBP_bracket 12 (q := 1.59) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr58 : (0.95245689 : ℝ) ≤ vBP 1.61 ∧ vBP 1.61 ≤ 0.95247825 := by
  have h := vBP_bracket 12 (q := 1.61) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr59 : (0.97959707 : ℝ) ≤ vBP 1.632 ∧ vBP 1.632 ≤ 0.97962584 := by
  have h := vBP_bracket 12 (q := 1.632) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr60 : (1.00878907 : ℝ) ≤ vBP 1.656 ∧ vBP 1.656 ≤ 1.00882827 := by
  have h := vBP_bracket 12 (q := 1.656) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr61 : (1.03755935 : ℝ) ≤ vBP 1.68 ∧ vBP 1.68 ≤ 1.03761196 := by
  have h := vBP_bracket 12 (q := 1.68) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr62 : (1.06591948 : ℝ) ≤ vBP 1.704 ∧ vBP 1.704 ≤ 1.06598913 := by
  have h := vBP_bracket 12 (q := 1.704) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr63 : (1.10080961 : ℝ) ≤ vBP 1.734 ∧ vBP 1.734 ≤ 1.10090679 := by
  have h := vBP_bracket 12 (q := 1.734) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr64 : (1.1373613 : ℝ) ≤ vBP 1.766 ∧ vBP 1.766 ≤ 1.13749718 := by
  have h := vBP_bracket 12 (q := 1.766) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr65 : (1.1710258 : ℝ) ≤ vBP 1.796 ∧ vBP 1.796 ≤ 1.17120873 := by
  have h := vBP_bracket 12 (q := 1.796) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr66 : (1.20631244 : ℝ) ≤ vBP 1.828 ∧ vBP 1.828 ≤ 1.20655947 := by
  have h := vBP_bracket 12 (q := 1.828) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr67 : (1.24097685 : ℝ) ≤ vBP 1.86 ∧ vBP 1.86 ≤ 1.24130524 := by
  have h := vBP_bracket 12 (q := 1.86) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr68 : (1.27292668 : ℝ) ≤ vBP 1.89 ∧ vBP 1.89 ≤ 1.27334993 := by
  have h := vBP_bracket 12 (q := 1.89) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr69 : (1.30643896 : ℝ) ≤ vBP 1.922 ∧ vBP 1.922 ≤ 1.30698664 := by
  have h := vBP_bracket 12 (q := 1.922) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr70 : (1.35463226 : ℝ) ≤ vBP 1.969 ∧ vBP 1.969 ≤ 1.35541448 := by
  have h := vBP_bracket 12 (q := 1.969) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr71 : (1.40164597 : ℝ) ≤ vBP 2.016 ∧ vBP 2.016 ≤ 1.4027369 := by
  have h := vBP_bracket 12 (q := 2.016) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr72 : (1.44655973 : ℝ) ≤ vBP 2.062 ∧ vBP 2.062 ≤ 1.44803958 := by
  have h := vBP_bracket 12 (q := 2.062) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpBr73 : (1.47718263 : ℝ) ≤ vBP 2.094 ∧ vBP 2.094 ≤ 1.47899217 := by
  have h := vBP_bracket 12 (q := 2.094) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

/-! ### Signed integral brackets for the blocks -/

/-- Signed integral bracket for block 0: the `q`-range `[1, 1.0038]`. -/
theorem oscBlock0 : errIntBracket (vBP 1) (vBP 1.0038) (-0.00641868) (-0.0061821) 0.00641868 := by
  refine errIntBracket.mono
    (((((((((((((((errPiece_taylor (q0 := 1) (q1 := 1.0002) (Lo := (-0.87368961)) (Hi := (-0.84336462)) (M := 0.87368961)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.0002) (q1 := 1.0005) (Lo := (-0.87073429)) (Hi := (-0.83893041)) (M := 0.87073429)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0005) (q1 := 1.0008) (Lo := (-0.86630709)) (Hi := (-0.83450599)) (M := 0.86630709)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0008) (q1 := 1.001) (Lo := (-0.86188472)) (Hi := (-0.83156521)) (M := 0.86188472)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.001) (q1 := 1.0012) (Lo := (-0.85894295)) (Hi := (-0.82862481)) (M := 0.85894295)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0012) (q1 := 1.0015) (Lo := (-0.85601008)) (Hi := (-0.82421542)) (M := 0.85601008)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0015) (q1 := 1.0018) (Lo := (-0.85161126)) (Hi := (-0.81981934)) (M := 0.85161126)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0018) (q1 := 1.002) (Lo := (-0.8472137)) (Hi := (-0.81690099)) (M := 0.8472137)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.002) (q1 := 1.0022) (Lo := (-0.84429083)) (Hi := (-0.81397947)) (M := 0.84429083)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0022) (q1 := 1.0025) (Lo := (-0.84138041)) (Hi := (-0.80959484)) (M := 0.84138041)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0025) (q1 := 1.0028) (Lo := (-0.83700992)) (Hi := (-0.80522706)) (M := 0.83700992)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0028) (q1 := 1.003) (Lo := (-0.83263712)) (Hi := (-0.80233113)) (M := 0.83263712)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.003) (q1 := 1.0032) (Lo := (-0.82973313)) (Hi := (-0.79942848)) (M := 0.82973313)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0032) (q1 := 1.0035) (Lo := (-0.82684515)) (Hi := (-0.79506855)) (M := 0.82684515)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0035) (q1 := 1.0038) (Lo := (-0.82250297)) (Hi := (-0.79072903)) (M := 0.82250297)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 1: the `q`-range `[1.0038, 1.0078]`. -/
theorem oscBlock1 : errIntBracket (vBP 1.0038) (vBP 1.0078) (-0.00625872) (-0.00601224) 0.00625872 := by
  refine errIntBracket.mono
    ((((((((((((((((errPiece_taylor (q0 := 1.0038) (q1 := 1.004) (Lo := (-0.81815487)) (Hi := (-0.78785553)) (M := 0.81815487)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.004) (q1 := 1.0042) (Lo := (-0.81526972)) (Hi := (-0.78497171)) (M := 0.81526972)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0042) (q1 := 1.0045) (Lo := (-0.81240419)) (Hi := (-0.78063642)) (M := 0.81240419)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0045) (q1 := 1.0048) (Lo := (-0.80809028)) (Hi := (-0.77632513)) (M := 0.80809028)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0048) (q1 := 1.005) (Lo := (-0.80376681)) (Hi := (-0.77347406)) (M := 0.80376681)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.005) (q1 := 1.0052) (Lo := (-0.80090049)) (Hi := (-0.77060905)) (M := 0.80090049)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0052) (q1 := 1.0055) (Lo := (-0.79805741)) (Hi := (-0.76629835)) (M := 0.79805741)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0055) (q1 := 1.0058) (Lo := (-0.79377173)) (Hi := (-0.76201525)) (M := 0.79377173)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0058) (q1 := 1.006) (Lo := (-0.78947284)) (Hi := (-0.75918661)) (M := 0.78947284)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.006) (q1 := 1.0062) (Lo := (-0.78662532)) (Hi := (-0.75634039)) (M := 0.78662532)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0062) (q1 := 1.0065) (Lo := (-0.7838047)) (Hi := (-0.75205422)) (M := 0.7838047)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0065) (q1 := 1.0068) (Lo := (-0.77954721)) (Hi := (-0.74779928)) (M := 0.77954721)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0068) (q1 := 1.007) (Lo := (-0.77527284)) (Hi := (-0.74499306)) (M := 0.77527284)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.007) (q1 := 1.0072) (Lo := (-0.77244411)) (Hi := (-0.74216561)) (M := 0.77244411)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0072) (q1 := 1.0075) (Lo := (-0.76964593)) (Hi := (-0.73790391)) (M := 0.76964593)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0075) (q1 := 1.0078) (Lo := (-0.76541661)) (Hi := (-0.7336771)) (M := 0.76541661)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 2: the `q`-range `[1.0078, 1.0118]`. -/
theorem oscBlock2 : errIntBracket (vBP 1.0078) (vBP 1.0118) (-0.0057677) (-0.00552341) 0.0057677 := by
  refine errIntBracket.mono
    ((((((((((((((((errPiece_taylor (q0 := 1.0078) (q1 := 1.008) (Lo := (-0.76116671)) (Hi := (-0.73089331)) (M := 0.76116671)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.008) (q1 := 1.0082) (Lo := (-0.75835673)) (Hi := (-0.72808461)) (M := 0.75835673)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0082) (q1 := 1.0085) (Lo := (-0.75558101)) (Hi := (-0.72384732)) (M := 0.75558101)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0085) (q1 := 1.0088) (Lo := (-0.75137982)) (Hi := (-0.7196486)) (M := 0.75137982)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0088) (q1 := 1.009) (Lo := (-0.74715433)) (Hi := (-0.71688725)) (M := 0.74715433)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.009) (q1 := 1.0092) (Lo := (-0.74436309)) (Hi := (-0.71409728)) (M := 0.74436309)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0092) (q1 := 1.0095) (Lo := (-0.74160983)) (Hi := (-0.70988435)) (M := 0.74160983)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0095) (q1 := 1.0098) (Lo := (-0.73743673)) (Hi := (-0.70571369)) (M := 0.73743673)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0098) (q1 := 1.01) (Lo := (-0.73323559)) (Hi := (-0.70297478)) (M := 0.73323559)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.01) (q1 := 1.0102) (Lo := (-0.73046308)) (Hi := (-0.70020351)) (M := 0.73046308)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0102) (q1 := 1.0105) (Lo := (-0.72773227)) (Hi := (-0.69601488)) (M := 0.72773227)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0105) (q1 := 1.0108) (Lo := (-0.72358725)) (Hi := (-0.69187226)) (M := 0.72358725)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0108) (q1 := 1.011) (Lo := (-0.71941041)) (Hi := (-0.68915579)) (M := 0.71941041)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.011) (q1 := 1.0112) (Lo := (-0.71665659)) (Hi := (-0.6864032)) (M := 0.71665659)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0112) (q1 := 1.0115) (Lo := (-0.71394824)) (Hi := (-0.68223883)) (M := 0.71394824)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0115) (q1 := 1.0118) (Lo := (-0.70983126)) (Hi := (-0.67812421)) (M := 0.70983126)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 3: the `q`-range `[1.0118, 1.016]`. -/
theorem oscBlock3 : errIntBracket (vBP 1.0118) (vBP 1.016) (-0.00554846) (-0.00529459) 0.00554846 := by
  refine errIntBracket.mono
    (((((((((((((((((errPiece_taylor (q0 := 1.0118) (q1 := 1.012) (Lo := (-0.70567867)) (Hi := (-0.67543018)) (M := 0.70567867)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.012) (q1 := 1.0122) (Lo := (-0.70294352)) (Hi := (-0.67269626)) (M := 0.70294352)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0122) (q1 := 1.0125) (Lo := (-0.70025765)) (Hi := (-0.66855608)) (M := 0.70025765)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0125) (q1 := 1.0128) (Lo := (-0.69616867)) (Hi := (-0.66446944)) (M := 0.69616867)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0128) (q1 := 1.013) (Lo := (-0.69204027)) (Hi := (-0.66179786)) (M := 0.69204027)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.013) (q1 := 1.0132) (Lo := (-0.68932378)) (Hi := (-0.65908258)) (M := 0.68932378)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0132) (q1 := 1.0135) (Lo := (-0.68666038)) (Hi := (-0.65496655)) (M := 0.68666038)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0135) (q1 := 1.0138) (Lo := (-0.68259938)) (Hi := (-0.65090785)) (M := 0.68259938)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0138) (q1 := 1.014) (Lo := (-0.67849512)) (Hi := (-0.64825872)) (M := 0.67849512)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.014) (q1 := 1.0142) (Lo := (-0.67579728)) (Hi := (-0.64556207)) (M := 0.67579728)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0142) (q1 := 1.0145) (Lo := (-0.67315634)) (Hi := (-0.64147013)) (M := 0.67315634)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0145) (q1 := 1.0148) (Lo := (-0.6691233)) (Hi := (-0.63743935)) (M := 0.6691233)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0148) (q1 := 1.015) (Lo := (-0.66504313)) (Hi := (-0.63481268)) (M := 0.66504313)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.015) (q1 := 1.0152) (Lo := (-0.6623639)) (Hi := (-0.63213463)) (M := 0.6623639)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0152) (q1 := 1.0155) (Lo := (-0.65974544)) (Hi := (-0.62806674)) (M := 0.65974544)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0155) (q1 := 1.0158) (Lo := (-0.65574032)) (Hi := (-0.62406385)) (M := 0.65574032)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0158) (q1 := 1.016) (Lo := (-0.6516842)) (Hi := (-0.62145964)) (M := 0.6516842)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 4: the `q`-range `[1.016, 1.0205]`. -/
theorem oscBlock4 : errIntBracket (vBP 1.016) (vBP 1.0205) (-0.00539232) (-0.00512254) 0.00539232 := by
  refine errIntBracket.mono
    ((((((((((((((((((errPiece_taylor (q0 := 1.016) (q1 := 1.0162) (Lo := (-0.64902357)) (Hi := (-0.61880018)) (M := 0.64902357)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.0162) (q1 := 1.0165) (Lo := (-0.64642759)) (Hi := (-0.61475629)) (M := 0.64642759)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0165) (q1 := 1.0168) (Lo := (-0.64245037)) (Hi := (-0.61078126)) (M := 0.64245037)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0168) (q1 := 1.017) (Lo := (-0.63841824)) (Hi := (-0.60819951)) (M := 0.63841824)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.017) (q1 := 1.0172) (Lo := (-0.63577619)) (Hi := (-0.60555863)) (M := 0.63577619)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0172) (q1 := 1.0175) (Lo := (-0.6332027)) (Hi := (-0.60153868)) (M := 0.6332027)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0175) (q1 := 1.0178) (Lo := (-0.62925335)) (Hi := (-0.59759149)) (M := 0.62925335)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0178) (q1 := 1.018) (Lo := (-0.62524516)) (Hi := (-0.59503221)) (M := 0.62524516)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.018) (q1 := 1.0182) (Lo := (-0.62262168)) (Hi := (-0.59240988)) (M := 0.62262168)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0182) (q1 := 1.0185) (Lo := (-0.62007068)) (Hi := (-0.58841383)) (M := 0.62007068)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0185) (q1 := 1.0188) (Lo := (-0.61614917)) (Hi := (-0.58449445)) (M := 0.61614917)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0188) (q1 := 1.019) (Lo := (-0.61216487)) (Hi := (-0.58195764)) (M := 0.61216487)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.019) (q1 := 1.0192) (Lo := (-0.60955994)) (Hi := (-0.57935385)) (M := 0.60955994)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0192) (q1 := 1.0195) (Lo := (-0.60703144)) (Hi := (-0.57538165)) (M := 0.60703144)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0195) (q1 := 1.0198) (Lo := (-0.60313774)) (Hi := (-0.57149006)) (M := 0.60313774)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0198) (q1 := 1.02) (Lo := (-0.5991773)) (Hi := (-0.56897573)) (M := 0.5991773)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.02) (q1 := 1.0202) (Lo := (-0.5965909)) (Hi := (-0.56639046)) (M := 0.5965909)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0202) (q1 := 1.0205) (Lo := (-0.59408489)) (Hi := (-0.56244206)) (M := 0.59408489)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 5: the `q`-range `[1.0205, 1.025]`. -/
theorem oscBlock5 : errIntBracket (vBP 1.0205) (vBP 1.025) (-0.00485096) (-0.00457392) 0.00485096 := by
  refine errIntBracket.mono
    (((((((((((((((errPiece_taylor (q0 := 1.0205) (q1 := 1.0208) (Lo := (-0.59021899)) (Hi := (-0.55857823)) (M := 0.59021899)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.0208) (q1 := 1.021) (Lo := (-0.58628234)) (Hi := (-0.55608639)) (M := 0.58628234)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.021) (q1 := 1.0212) (Lo := (-0.58371446)) (Hi := (-0.55351962)) (M := 0.58371446)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0212) (q1 := 1.0215) (Lo := (-0.58123096)) (Hi := (-0.54959498)) (M := 0.58123096)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0215) (q1 := 1.0218) (Lo := (-0.57739283)) (Hi := (-0.54575889)) (M := 0.57739283)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0218) (q1 := 1.022) (Lo := (-0.57347993)) (Hi := (-0.54328954)) (M := 0.57347993)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.022) (q1 := 1.0222) (Lo := (-0.57093055)) (Hi := (-0.54074126)) (M := 0.57093055)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0222) (q1 := 1.0225) (Lo := (-0.56846956)) (Hi := (-0.53684033)) (M := 0.56846956)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0225) (q1 := 1.0228) (Lo := (-0.56465917)) (Hi := (-0.53303195)) (M := 0.56465917)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0228) (q1 := 1.023) (Lo := (-0.56076999)) (Hi := (-0.53058509)) (M := 0.56076999)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.023) (q1 := 1.0232) (Lo := (-0.55823909)) (Hi := (-0.52805528)) (M := 0.55823909)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0232) (q1 := 1.0235) (Lo := (-0.55580061)) (Hi := (-0.52417802)) (M := 0.55580061)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0235) (q1 := 1.024) (Lo := (-0.552199)) (Hi := (-0.51769965)) (M := 0.552199)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.024) (q1 := 1.0245) (Lo := (-0.54591708)) (Hi := (-0.5114221)) (M := 0.54591708)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0245) (q1 := 1.025) (Lo := (-0.53965825)) (Hi := (-0.50516759)) (M := 0.53965825)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 6: the `q`-range `[1.025, 1.03]`. -/
theorem oscBlock6 : errIntBracket (vBP 1.025) (vBP 1.03) (-0.00479083) (-0.00446434) 0.00479083 := by
  refine errIntBracket.mono
    ((((((((((errPiece_taylor (q0 := 1.025) (q1 := 1.0255) (Lo := (-0.5334225)) (Hi := (-0.4989361)) (M := 0.5334225)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.0255) (q1 := 1.026) (Lo := (-0.52720982)) (Hi := (-0.49272764)) (M := 0.52720982)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.026) (q1 := 1.0265) (Lo := (-0.52102019)) (Hi := (-0.48654219)) (M := 0.52102019)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0265) (q1 := 1.027) (Lo := (-0.51485362)) (Hi := (-0.48037973)) (M := 0.51485362)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.027) (q1 := 1.0275) (Lo := (-0.50871008)) (Hi := (-0.47424027)) (M := 0.50871008)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0275) (q1 := 1.028) (Lo := (-0.50258958)) (Hi := (-0.4681238)) (M := 0.50258958)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.028) (q1 := 1.0285) (Lo := (-0.4964921)) (Hi := (-0.46203029)) (M := 0.4964921)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0285) (q1 := 1.029) (Lo := (-0.49041763)) (Hi := (-0.45595975)) (M := 0.49041763)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.029) (q1 := 1.0295) (Lo := (-0.48436616)) (Hi := (-0.44991217)) (M := 0.48436616)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0295) (q1 := 1.03) (Lo := (-0.47833769)) (Hi := (-0.44388753)) (M := 0.47833769)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 7: the `q`-range `[1.03, 1.0355]`. -/
theorem oscBlock7 : errIntBracket (vBP 1.03) (vBP 1.0355) (-0.00456703) (-0.00421194) 0.00456703 := by
  refine errIntBracket.mono
    (((((((((((errPiece_taylor (q0 := 1.03) (q1 := 1.0305) (Lo := (-0.47233221)) (Hi := (-0.43788584)) (M := 0.47233221)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.0305) (q1 := 1.031) (Lo := (-0.4663497)) (Hi := (-0.43190707)) (M := 0.4663497)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.031) (q1 := 1.0315) (Lo := (-0.46039016)) (Hi := (-0.42595122)) (M := 0.46039016)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0315) (q1 := 1.032) (Lo := (-0.45445357)) (Hi := (-0.42001829)) (M := 0.45445357)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.032) (q1 := 1.0325) (Lo := (-0.44853994)) (Hi := (-0.41410827)) (M := 0.44853994)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0325) (q1 := 1.033) (Lo := (-0.44264925)) (Hi := (-0.40822113)) (M := 0.44264925)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.033) (q1 := 1.0335) (Lo := (-0.43678149)) (Hi := (-0.40235689)) (M := 0.43678149)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0335) (q1 := 1.034) (Lo := (-0.43093665)) (Hi := (-0.39651553)) (M := 0.43093665)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.034) (q1 := 1.0345) (Lo := (-0.42511474)) (Hi := (-0.39069703)) (M := 0.42511474)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0345) (q1 := 1.035) (Lo := (-0.41931572)) (Hi := (-0.3849014)) (M := 0.41931572)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.035) (q1 := 1.0355) (Lo := (-0.41353961)) (Hi := (-0.37912863)) (M := 0.41353961)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 8: the `q`-range `[1.0355, 1.0415]`. -/
theorem oscBlock8 : errIntBracket (vBP 1.0355) (vBP 1.0415) (-0.00419207) (-0.00380941) 0.00419207 := by
  refine errIntBracket.mono
    ((((((((((((errPiece_taylor (q0 := 1.0355) (q1 := 1.036) (Lo := (-0.40778638)) (Hi := (-0.3733787)) (M := 0.40778638)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.036) (q1 := 1.0365) (Lo := (-0.40205604)) (Hi := (-0.36765161)) (M := 0.40205604)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0365) (q1 := 1.037) (Lo := (-0.39634857)) (Hi := (-0.36194735)) (M := 0.39634857)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.037) (q1 := 1.0375) (Lo := (-0.39066397)) (Hi := (-0.35626591)) (M := 0.39066397)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0375) (q1 := 1.038) (Lo := (-0.38500222)) (Hi := (-0.35060729)) (M := 0.38500222)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.038) (q1 := 1.0385) (Lo := (-0.37936332)) (Hi := (-0.34497147)) (M := 0.37936332)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0385) (q1 := 1.039) (Lo := (-0.37374726)) (Hi := (-0.33935845)) (M := 0.37374726)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.039) (q1 := 1.0395) (Lo := (-0.36815403)) (Hi := (-0.33376822)) (M := 0.36815403)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0395) (q1 := 1.04) (Lo := (-0.36258363)) (Hi := (-0.32820078)) (M := 0.36258363)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.04) (q1 := 1.0405) (Lo := (-0.35703604)) (Hi := (-0.32265611)) (M := 0.35703604)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0405) (q1 := 1.041) (Lo := (-0.35151125)) (Hi := (-0.3171342)) (M := 0.35151125)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.041) (q1 := 1.0415) (Lo := (-0.34600927)) (Hi := (-0.31163505)) (M := 0.34600927)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 9: the `q`-range `[1.0415, 1.048]`. -/
theorem oscBlock9 : errIntBracket (vBP 1.0415) (vBP 1.048) (-0.00367921) (-0.00325701) 0.00367921 := by
  refine errIntBracket.mono
    ((((((((((((errPiece_taylor (q0 := 1.0415) (q1 := 1.042) (Lo := (-0.34053007)) (Hi := (-0.30615866)) (M := 0.34053007)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.042) (q1 := 1.0425) (Lo := (-0.33507366)) (Hi := (-0.30070501)) (M := 0.33507366)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0425) (q1 := 1.043) (Lo := (-0.32964003)) (Hi := (-0.29527409)) (M := 0.32964003)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.043) (q1 := 1.0435) (Lo := (-0.32422915)) (Hi := (-0.2898659)) (M := 0.32422915)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0435) (q1 := 1.044) (Lo := (-0.31884104)) (Hi := (-0.28448043)) (M := 0.31884104)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.044) (q1 := 1.0445) (Lo := (-0.31347568)) (Hi := (-0.27911767)) (M := 0.31347568)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0445) (q1 := 1.045) (Lo := (-0.30813305)) (Hi := (-0.27377761)) (M := 0.30813305)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.045) (q1 := 1.0455) (Lo := (-0.30281317)) (Hi := (-0.26846025)) (M := 0.30281317)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0455) (q1 := 1.046) (Lo := (-0.297516)) (Hi := (-0.26316558)) (M := 0.297516)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.046) (q1 := 1.0465) (Lo := (-0.29224156)) (Hi := (-0.25789359)) (M := 0.29224156)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.0465) (q1 := 1.047) (Lo := (-0.28698982)) (Hi := (-0.25264427)) (M := 0.28698982)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.047) (q1 := 1.048) (Lo := (-0.28272394)) (Hi := (-0.24125168)) (M := 0.28272394)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

end ConnesConsani.WeilPositivity
