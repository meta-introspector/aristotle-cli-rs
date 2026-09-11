/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscLin

/-!
# Rational brackets for the breakpoints `vBP q = 2 log q` (part 1)

Each bracket comes from the logarithmic series `vBP_bracket 12`.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem vbpP0 : (0:ℝ) ≤ vBP 1 ∧ vBP 1 ≤ 0 := by
  rw [vBP_one]; norm_num

theorem vbpP1 : (0.00039996:ℝ) ≤ vBP 1.0002 ∧ vBP 1.0002 ≤ 0.000399961 := by
  have h := vBP_bracket 12 (q := 1.0002) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP2 : (0.00099975:ℝ) ≤ vBP 1.0005 ∧ vBP 1.0005 ≤ 0.000999751 := by
  have h := vBP_bracket 12 (q := 1.0005) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP3 : (0.00159936:ℝ) ≤ vBP 1.0008 ∧ vBP 1.0008 ≤ 0.001599361 := by
  have h := vBP_bracket 12 (q := 1.0008) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP4 : (0.001999:ℝ) ≤ vBP 1.001 ∧ vBP 1.001 ≤ 0.001999001 := by
  have h := vBP_bracket 12 (q := 1.001) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP5 : (0.002398561:ℝ) ≤ vBP 1.0012 ∧ vBP 1.0012 ≤ 0.002398562 := by
  have h := vBP_bracket 12 (q := 1.0012) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP6 : (0.002997752:ℝ) ≤ vBP 1.0015 ∧ vBP 1.0015 ≤ 0.002997753 := by
  have h := vBP_bracket 12 (q := 1.0015) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP7 : (0.003596763:ℝ) ≤ vBP 1.0018 ∧ vBP 1.0018 ≤ 0.003596764 := by
  have h := vBP_bracket 12 (q := 1.0018) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP8 : (0.003996005:ℝ) ≤ vBP 1.002 ∧ vBP 1.002 ≤ 0.003996006 := by
  have h := vBP_bracket 12 (q := 1.002) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP9 : (0.004395167:ℝ) ≤ vBP 1.0022 ∧ vBP 1.0022 ≤ 0.004395168 := by
  have h := vBP_bracket 12 (q := 1.0022) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP10 : (0.00499376:ℝ) ≤ vBP 1.0025 ∧ vBP 1.0025 ≤ 0.004993761 := by
  have h := vBP_bracket 12 (q := 1.0025) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP11 : (0.005592174:ℝ) ≤ vBP 1.0028 ∧ vBP 1.0028 ≤ 0.005592175 := by
  have h := vBP_bracket 12 (q := 1.0028) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP12 : (0.005991017:ℝ) ≤ vBP 1.003 ∧ vBP 1.003 ≤ 0.005991018 := by
  have h := vBP_bracket 12 (q := 1.003) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP13 : (0.006389781:ℝ) ≤ vBP 1.0032 ∧ vBP 1.0032 ≤ 0.006389782 := by
  have h := vBP_bracket 12 (q := 1.0032) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP14 : (0.006987778:ℝ) ≤ vBP 1.0035 ∧ vBP 1.0035 ≤ 0.006987779 := by
  have h := vBP_bracket 12 (q := 1.0035) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP15 : (0.007585596:ℝ) ≤ vBP 1.0038 ∧ vBP 1.0038 ≤ 0.007585597 := by
  have h := vBP_bracket 12 (q := 1.0038) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP16 : (0.007984042:ℝ) ≤ vBP 1.004 ∧ vBP 1.004 ≤ 0.007984043 := by
  have h := vBP_bracket 12 (q := 1.004) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP17 : (0.008382409:ℝ) ≤ vBP 1.0042 ∧ vBP 1.0042 ≤ 0.00838241 := by
  have h := vBP_bracket 12 (q := 1.0042) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP18 : (0.00897981:ℝ) ≤ vBP 1.0045 ∧ vBP 1.0045 ≤ 0.008979811 := by
  have h := vBP_bracket 12 (q := 1.0045) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP19 : (0.009577033:ℝ) ≤ vBP 1.0048 ∧ vBP 1.0048 ≤ 0.009577034 := by
  have h := vBP_bracket 12 (q := 1.0048) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP20 : (0.009975083:ℝ) ≤ vBP 1.005 ∧ vBP 1.005 ≤ 0.009975084 := by
  have h := vBP_bracket 12 (q := 1.005) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP21 : (0.010373053:ℝ) ≤ vBP 1.0052 ∧ vBP 1.0052 ≤ 0.010373054 := by
  have h := vBP_bracket 12 (q := 1.0052) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP22 : (0.01096986:ℝ) ≤ vBP 1.0055 ∧ vBP 1.0055 ≤ 0.010969861 := by
  have h := vBP_bracket 12 (q := 1.0055) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP23 : (0.011566489:ℝ) ≤ vBP 1.0058 ∧ vBP 1.0058 ≤ 0.01156649 := by
  have h := vBP_bracket 12 (q := 1.0058) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP24 : (0.011964143:ℝ) ≤ vBP 1.006 ∧ vBP 1.006 ≤ 0.011964144 := by
  have h := vBP_bracket 12 (q := 1.006) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP25 : (0.012361718:ℝ) ≤ vBP 1.0062 ∧ vBP 1.0062 ≤ 0.012361719 := by
  have h := vBP_bracket 12 (q := 1.0062) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP26 : (0.012957932:ℝ) ≤ vBP 1.0065 ∧ vBP 1.0065 ≤ 0.012957933 := by
  have h := vBP_bracket 12 (q := 1.0065) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP27 : (0.013553968:ℝ) ≤ vBP 1.0068 ∧ vBP 1.0068 ≤ 0.013553969 := by
  have h := vBP_bracket 12 (q := 1.0068) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP28 : (0.013951227:ℝ) ≤ vBP 1.007 ∧ vBP 1.007 ≤ 0.013951228 := by
  have h := vBP_bracket 12 (q := 1.007) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP29 : (0.014348407:ℝ) ≤ vBP 1.0072 ∧ vBP 1.0072 ≤ 0.014348408 := by
  have h := vBP_bracket 12 (q := 1.0072) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP30 : (0.014944029:ℝ) ≤ vBP 1.0075 ∧ vBP 1.0075 ≤ 0.01494403 := by
  have h := vBP_bracket 12 (q := 1.0075) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP31 : (0.015539474:ℝ) ≤ vBP 1.0078 ∧ vBP 1.0078 ≤ 0.015539475 := by
  have h := vBP_bracket 12 (q := 1.0078) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP32 : (0.015936339:ℝ) ≤ vBP 1.008 ∧ vBP 1.008 ≤ 0.01593634 := by
  have h := vBP_bracket 12 (q := 1.008) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP33 : (0.016333125:ℝ) ≤ vBP 1.0082 ∧ vBP 1.0082 ≤ 0.016333126 := by
  have h := vBP_bracket 12 (q := 1.0082) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP34 : (0.016928156:ℝ) ≤ vBP 1.0085 ∧ vBP 1.0085 ≤ 0.016928157 := by
  have h := vBP_bracket 12 (q := 1.0085) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP35 : (0.017523011:ℝ) ≤ vBP 1.0088 ∧ vBP 1.0088 ≤ 0.017523012 := by
  have h := vBP_bracket 12 (q := 1.0088) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP36 : (0.017919482:ℝ) ≤ vBP 1.009 ∧ vBP 1.009 ≤ 0.017919483 := by
  have h := vBP_bracket 12 (q := 1.009) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP37 : (0.018315875:ℝ) ≤ vBP 1.0092 ∧ vBP 1.0092 ≤ 0.018315876 := by
  have h := vBP_bracket 12 (q := 1.0092) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP38 : (0.018910317:ℝ) ≤ vBP 1.0095 ∧ vBP 1.0095 ≤ 0.018910318 := by
  have h := vBP_bracket 12 (q := 1.0095) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP39 : (0.019504582:ℝ) ≤ vBP 1.0098 ∧ vBP 1.0098 ≤ 0.019504583 := by
  have h := vBP_bracket 12 (q := 1.0098) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP40 : (0.019900661:ℝ) ≤ vBP 1.01 ∧ vBP 1.01 ≤ 0.019900662 := by
  have h := vBP_bracket 12 (q := 1.01) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP41 : (0.020296662:ℝ) ≤ vBP 1.0102 ∧ vBP 1.0102 ≤ 0.020296663 := by
  have h := vBP_bracket 12 (q := 1.0102) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP42 : (0.020890515:ℝ) ≤ vBP 1.0105 ∧ vBP 1.0105 ≤ 0.020890516 := by
  have h := vBP_bracket 12 (q := 1.0105) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP43 : (0.021484193:ℝ) ≤ vBP 1.0108 ∧ vBP 1.0108 ≤ 0.021484194 := by
  have h := vBP_bracket 12 (q := 1.0108) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP44 : (0.02187988:ℝ) ≤ vBP 1.011 ∧ vBP 1.011 ≤ 0.021879881 := by
  have h := vBP_bracket 12 (q := 1.011) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP45 : (0.022275488:ℝ) ≤ vBP 1.0112 ∧ vBP 1.0112 ≤ 0.022275489 := by
  have h := vBP_bracket 12 (q := 1.0112) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP46 : (0.022868755:ℝ) ≤ vBP 1.0115 ∧ vBP 1.0115 ≤ 0.022868756 := by
  have h := vBP_bracket 12 (q := 1.0115) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP47 : (0.023461845:ℝ) ≤ vBP 1.0118 ∧ vBP 1.0118 ≤ 0.023461846 := by
  have h := vBP_bracket 12 (q := 1.0118) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP48 : (0.023857141:ℝ) ≤ vBP 1.012 ∧ vBP 1.012 ≤ 0.023857142 := by
  have h := vBP_bracket 12 (q := 1.012) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP49 : (0.024252359:ℝ) ≤ vBP 1.0122 ∧ vBP 1.0122 ≤ 0.02425236 := by
  have h := vBP_bracket 12 (q := 1.0122) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP50 : (0.024845039:ℝ) ≤ vBP 1.0125 ∧ vBP 1.0125 ≤ 0.02484504 := by
  have h := vBP_bracket 12 (q := 1.0125) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP51 : (0.025437544:ℝ) ≤ vBP 1.0128 ∧ vBP 1.0128 ≤ 0.025437545 := by
  have h := vBP_bracket 12 (q := 1.0128) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP52 : (0.02583245:ℝ) ≤ vBP 1.013 ∧ vBP 1.013 ≤ 0.025832451 := by
  have h := vBP_bracket 12 (q := 1.013) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP53 : (0.026227278:ℝ) ≤ vBP 1.0132 ∧ vBP 1.0132 ≤ 0.026227279 := by
  have h := vBP_bracket 12 (q := 1.0132) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP54 : (0.026819373:ℝ) ≤ vBP 1.0135 ∧ vBP 1.0135 ≤ 0.026819374 := by
  have h := vBP_bracket 12 (q := 1.0135) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP55 : (0.027411294:ℝ) ≤ vBP 1.0138 ∧ vBP 1.0138 ≤ 0.027411295 := by
  have h := vBP_bracket 12 (q := 1.0138) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP56 : (0.02780581:ℝ) ≤ vBP 1.014 ∧ vBP 1.014 ≤ 0.027805811 := by
  have h := vBP_bracket 12 (q := 1.014) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP57 : (0.028200248:ℝ) ≤ vBP 1.0142 ∧ vBP 1.0142 ≤ 0.028200249 := by
  have h := vBP_bracket 12 (q := 1.0142) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP58 : (0.02879176:ℝ) ≤ vBP 1.0145 ∧ vBP 1.0145 ≤ 0.028791761 := by
  have h := vBP_bracket 12 (q := 1.0145) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP59 : (0.029383097:ℝ) ≤ vBP 1.0148 ∧ vBP 1.0148 ≤ 0.029383098 := by
  have h := vBP_bracket 12 (q := 1.0148) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP60 : (0.029777224:ℝ) ≤ vBP 1.015 ∧ vBP 1.015 ≤ 0.029777225 := by
  have h := vBP_bracket 12 (q := 1.015) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP61 : (0.030171274:ℝ) ≤ vBP 1.0152 ∧ vBP 1.0152 ≤ 0.030171275 := by
  have h := vBP_bracket 12 (q := 1.0152) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP62 : (0.030762204:ℝ) ≤ vBP 1.0155 ∧ vBP 1.0155 ≤ 0.030762205 := by
  have h := vBP_bracket 12 (q := 1.0155) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP63 : (0.031352958:ℝ) ≤ vBP 1.0158 ∧ vBP 1.0158 ≤ 0.031352959 := by
  have h := vBP_bracket 12 (q := 1.0158) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP64 : (0.031746698:ℝ) ≤ vBP 1.016 ∧ vBP 1.016 ≤ 0.031746699 := by
  have h := vBP_bracket 12 (q := 1.016) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP65 : (0.03214036:ℝ) ≤ vBP 1.0162 ∧ vBP 1.0162 ≤ 0.032140361 := by
  have h := vBP_bracket 12 (q := 1.0162) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP66 : (0.032730708:ℝ) ≤ vBP 1.0165 ∧ vBP 1.0165 ≤ 0.032730709 := by
  have h := vBP_bracket 12 (q := 1.0165) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP67 : (0.033320881:ℝ) ≤ vBP 1.0168 ∧ vBP 1.0168 ≤ 0.033320882 := by
  have h := vBP_bracket 12 (q := 1.0168) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP68 : (0.033714234:ℝ) ≤ vBP 1.017 ∧ vBP 1.017 ≤ 0.033714235 := by
  have h := vBP_bracket 12 (q := 1.017) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP69 : (0.034107509:ℝ) ≤ vBP 1.0172 ∧ vBP 1.0172 ≤ 0.03410751 := by
  have h := vBP_bracket 12 (q := 1.0172) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP70 : (0.034697276:ℝ) ≤ vBP 1.0175 ∧ vBP 1.0175 ≤ 0.034697277 := by
  have h := vBP_bracket 12 (q := 1.0175) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP71 : (0.03528687:ℝ) ≤ vBP 1.0178 ∧ vBP 1.0178 ≤ 0.035286871 := by
  have h := vBP_bracket 12 (q := 1.0178) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP72 : (0.035679836:ℝ) ≤ vBP 1.018 ∧ vBP 1.018 ≤ 0.035679837 := by
  have h := vBP_bracket 12 (q := 1.018) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP73 : (0.036072724:ℝ) ≤ vBP 1.0182 ∧ vBP 1.0182 ≤ 0.036072725 := by
  have h := vBP_bracket 12 (q := 1.0182) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP74 : (0.036661913:ℝ) ≤ vBP 1.0185 ∧ vBP 1.0185 ≤ 0.036661914 := by
  have h := vBP_bracket 12 (q := 1.0185) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP75 : (0.037250928:ℝ) ≤ vBP 1.0188 ∧ vBP 1.0188 ≤ 0.037250929 := by
  have h := vBP_bracket 12 (q := 1.0188) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP76 : (0.037643508:ℝ) ≤ vBP 1.019 ∧ vBP 1.019 ≤ 0.037643509 := by
  have h := vBP_bracket 12 (q := 1.019) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP77 : (0.038036011:ℝ) ≤ vBP 1.0192 ∧ vBP 1.0192 ≤ 0.038036012 := by
  have h := vBP_bracket 12 (q := 1.0192) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP78 : (0.038624622:ℝ) ≤ vBP 1.0195 ∧ vBP 1.0195 ≤ 0.038624623 := by
  have h := vBP_bracket 12 (q := 1.0195) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP79 : (0.039213059:ℝ) ≤ vBP 1.0198 ∧ vBP 1.0198 ≤ 0.03921306 := by
  have h := vBP_bracket 12 (q := 1.0198) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP80 : (0.039605254:ℝ) ≤ vBP 1.02 ∧ vBP 1.02 ≤ 0.039605255 := by
  have h := vBP_bracket 12 (q := 1.02) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP81 : (0.039997373:ℝ) ≤ vBP 1.0202 ∧ vBP 1.0202 ≤ 0.039997374 := by
  have h := vBP_bracket 12 (q := 1.0202) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP82 : (0.040585406:ℝ) ≤ vBP 1.0205 ∧ vBP 1.0205 ≤ 0.040585407 := by
  have h := vBP_bracket 12 (q := 1.0205) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP83 : (0.041173267:ℝ) ≤ vBP 1.0208 ∧ vBP 1.0208 ≤ 0.041173268 := by
  have h := vBP_bracket 12 (q := 1.0208) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP84 : (0.041565078:ℝ) ≤ vBP 1.021 ∧ vBP 1.021 ≤ 0.041565079 := by
  have h := vBP_bracket 12 (q := 1.021) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP85 : (0.041956812:ℝ) ≤ vBP 1.0212 ∧ vBP 1.0212 ≤ 0.041956813 := by
  have h := vBP_bracket 12 (q := 1.0212) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP86 : (0.04254427:ℝ) ≤ vBP 1.0215 ∧ vBP 1.0215 ≤ 0.042544271 := by
  have h := vBP_bracket 12 (q := 1.0215) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP87 : (0.043131555:ℝ) ≤ vBP 1.0218 ∧ vBP 1.0218 ≤ 0.043131556 := by
  have h := vBP_bracket 12 (q := 1.0218) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP88 : (0.043522983:ℝ) ≤ vBP 1.022 ∧ vBP 1.022 ≤ 0.043522984 := by
  have h := vBP_bracket 12 (q := 1.022) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP89 : (0.043914334:ℝ) ≤ vBP 1.0222 ∧ vBP 1.0222 ≤ 0.043914335 := by
  have h := vBP_bracket 12 (q := 1.0222) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP90 : (0.044501217:ℝ) ≤ vBP 1.0225 ∧ vBP 1.0225 ≤ 0.044501218 := by
  have h := vBP_bracket 12 (q := 1.0225) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP91 : (0.045087928:ℝ) ≤ vBP 1.0228 ∧ vBP 1.0228 ≤ 0.045087929 := by
  have h := vBP_bracket 12 (q := 1.0228) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP92 : (0.045478973:ℝ) ≤ vBP 1.023 ∧ vBP 1.023 ≤ 0.045478974 := by
  have h := vBP_bracket 12 (q := 1.023) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP93 : (0.045869942:ℝ) ≤ vBP 1.0232 ∧ vBP 1.0232 ≤ 0.045869943 := by
  have h := vBP_bracket 12 (q := 1.0232) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP94 : (0.046456252:ℝ) ≤ vBP 1.0235 ∧ vBP 1.0235 ≤ 0.046456253 := by
  have h := vBP_bracket 12 (q := 1.0235) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP95 : (0.047433053:ℝ) ≤ vBP 1.024 ∧ vBP 1.024 ≤ 0.047433054 := by
  have h := vBP_bracket 12 (q := 1.024) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP96 : (0.048409377:ℝ) ≤ vBP 1.0245 ∧ vBP 1.0245 ≤ 0.048409378 := by
  have h := vBP_bracket 12 (q := 1.0245) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP97 : (0.049385225:ℝ) ≤ vBP 1.025 ∧ vBP 1.025 ≤ 0.049385226 := by
  have h := vBP_bracket 12 (q := 1.025) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP98 : (0.050360597:ℝ) ≤ vBP 1.0255 ∧ vBP 1.0255 ≤ 0.050360598 := by
  have h := vBP_bracket 12 (q := 1.0255) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP99 : (0.051335493:ℝ) ≤ vBP 1.026 ∧ vBP 1.026 ≤ 0.051335494 := by
  have h := vBP_bracket 12 (q := 1.026) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP100 : (0.052309914:ℝ) ≤ vBP 1.0265 ∧ vBP 1.0265 ≤ 0.052309915 := by
  have h := vBP_bracket 12 (q := 1.0265) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP101 : (0.053283861:ℝ) ≤ vBP 1.027 ∧ vBP 1.027 ≤ 0.053283862 := by
  have h := vBP_bracket 12 (q := 1.027) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP102 : (0.054257334:ℝ) ≤ vBP 1.0275 ∧ vBP 1.0275 ≤ 0.054257335 := by
  have h := vBP_bracket 12 (q := 1.0275) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP103 : (0.055230334:ℝ) ≤ vBP 1.028 ∧ vBP 1.028 ≤ 0.055230335 := by
  have h := vBP_bracket 12 (q := 1.028) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP104 : (0.05620286:ℝ) ≤ vBP 1.0285 ∧ vBP 1.0285 ≤ 0.056202861 := by
  have h := vBP_bracket 12 (q := 1.0285) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP105 : (0.057174913:ℝ) ≤ vBP 1.029 ∧ vBP 1.029 ≤ 0.057174914 := by
  have h := vBP_bracket 12 (q := 1.029) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP106 : (0.058146494:ℝ) ≤ vBP 1.0295 ∧ vBP 1.0295 ≤ 0.058146495 := by
  have h := vBP_bracket 12 (q := 1.0295) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP107 : (0.059117604:ℝ) ≤ vBP 1.03 ∧ vBP 1.03 ≤ 0.059117605 := by
  have h := vBP_bracket 12 (q := 1.03) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP108 : (0.060088242:ℝ) ≤ vBP 1.0305 ∧ vBP 1.0305 ≤ 0.060088243 := by
  have h := vBP_bracket 12 (q := 1.0305) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP109 : (0.06105841:ℝ) ≤ vBP 1.031 ∧ vBP 1.031 ≤ 0.061058411 := by
  have h := vBP_bracket 12 (q := 1.031) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP110 : (0.062028107:ℝ) ≤ vBP 1.0315 ∧ vBP 1.0315 ≤ 0.062028108 := by
  have h := vBP_bracket 12 (q := 1.0315) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP111 : (0.062997334:ℝ) ≤ vBP 1.032 ∧ vBP 1.032 ≤ 0.062997335 := by
  have h := vBP_bracket 12 (q := 1.032) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP112 : (0.063966091:ℝ) ≤ vBP 1.0325 ∧ vBP 1.0325 ≤ 0.063966092 := by
  have h := vBP_bracket 12 (q := 1.0325) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP113 : (0.06493438:ℝ) ≤ vBP 1.033 ∧ vBP 1.033 ≤ 0.064934381 := by
  have h := vBP_bracket 12 (q := 1.033) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP114 : (0.0659022:ℝ) ≤ vBP 1.0335 ∧ vBP 1.0335 ≤ 0.065902201 := by
  have h := vBP_bracket 12 (q := 1.0335) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP115 : (0.066869552:ℝ) ≤ vBP 1.034 ∧ vBP 1.034 ≤ 0.066869553 := by
  have h := vBP_bracket 12 (q := 1.034) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP116 : (0.067836436:ℝ) ≤ vBP 1.0345 ∧ vBP 1.0345 ≤ 0.067836437 := by
  have h := vBP_bracket 12 (q := 1.0345) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP117 : (0.068802853:ℝ) ≤ vBP 1.035 ∧ vBP 1.035 ≤ 0.068802854 := by
  have h := vBP_bracket 12 (q := 1.035) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP118 : (0.069768803:ℝ) ≤ vBP 1.0355 ∧ vBP 1.0355 ≤ 0.069768804 := by
  have h := vBP_bracket 12 (q := 1.0355) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP119 : (0.070734287:ℝ) ≤ vBP 1.036 ∧ vBP 1.036 ≤ 0.070734288 := by
  have h := vBP_bracket 12 (q := 1.036) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP120 : (0.071699305:ℝ) ≤ vBP 1.0365 ∧ vBP 1.0365 ≤ 0.071699306 := by
  have h := vBP_bracket 12 (q := 1.0365) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP121 : (0.072663858:ℝ) ≤ vBP 1.037 ∧ vBP 1.037 ≤ 0.072663859 := by
  have h := vBP_bracket 12 (q := 1.037) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP122 : (0.073627946:ℝ) ≤ vBP 1.0375 ∧ vBP 1.0375 ≤ 0.073627947 := by
  have h := vBP_bracket 12 (q := 1.0375) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP123 : (0.074591569:ℝ) ≤ vBP 1.038 ∧ vBP 1.038 ≤ 0.07459157 := by
  have h := vBP_bracket 12 (q := 1.038) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP124 : (0.075554728:ℝ) ≤ vBP 1.0385 ∧ vBP 1.0385 ≤ 0.075554729 := by
  have h := vBP_bracket 12 (q := 1.0385) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP125 : (0.076517424:ℝ) ≤ vBP 1.039 ∧ vBP 1.039 ≤ 0.076517425 := by
  have h := vBP_bracket 12 (q := 1.039) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP126 : (0.077479656:ℝ) ≤ vBP 1.0395 ∧ vBP 1.0395 ≤ 0.077479657 := by
  have h := vBP_bracket 12 (q := 1.0395) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP127 : (0.078441426:ℝ) ≤ vBP 1.04 ∧ vBP 1.04 ≤ 0.078441427 := by
  have h := vBP_bracket 12 (q := 1.04) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP128 : (0.079402733:ℝ) ≤ vBP 1.0405 ∧ vBP 1.0405 ≤ 0.079402734 := by
  have h := vBP_bracket 12 (q := 1.0405) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP129 : (0.080363579:ℝ) ≤ vBP 1.041 ∧ vBP 1.041 ≤ 0.08036358 := by
  have h := vBP_bracket 12 (q := 1.041) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP130 : (0.081323963:ℝ) ≤ vBP 1.0415 ∧ vBP 1.0415 ≤ 0.081323964 := by
  have h := vBP_bracket 12 (q := 1.0415) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP131 : (0.082283886:ℝ) ≤ vBP 1.042 ∧ vBP 1.042 ≤ 0.082283887 := by
  have h := vBP_bracket 12 (q := 1.042) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP132 : (0.083243349:ℝ) ≤ vBP 1.0425 ∧ vBP 1.0425 ≤ 0.08324335 := by
  have h := vBP_bracket 12 (q := 1.0425) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP133 : (0.084202352:ℝ) ≤ vBP 1.043 ∧ vBP 1.043 ≤ 0.084202353 := by
  have h := vBP_bracket 12 (q := 1.043) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP134 : (0.085160895:ℝ) ≤ vBP 1.0435 ∧ vBP 1.0435 ≤ 0.085160896 := by
  have h := vBP_bracket 12 (q := 1.0435) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP135 : (0.086118978:ℝ) ≤ vBP 1.044 ∧ vBP 1.044 ≤ 0.086118979 := by
  have h := vBP_bracket 12 (q := 1.044) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP136 : (0.087076604:ℝ) ≤ vBP 1.0445 ∧ vBP 1.0445 ≤ 0.087076605 := by
  have h := vBP_bracket 12 (q := 1.0445) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP137 : (0.08803377:ℝ) ≤ vBP 1.045 ∧ vBP 1.045 ≤ 0.088033771 := by
  have h := vBP_bracket 12 (q := 1.045) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP138 : (0.088990479:ℝ) ≤ vBP 1.0455 ∧ vBP 1.0455 ≤ 0.08899048 := by
  have h := vBP_bracket 12 (q := 1.0455) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP139 : (0.089946731:ℝ) ≤ vBP 1.046 ∧ vBP 1.046 ≤ 0.089946732 := by
  have h := vBP_bracket 12 (q := 1.046) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP140 : (0.090902525:ℝ) ≤ vBP 1.0465 ∧ vBP 1.0465 ≤ 0.090902526 := by
  have h := vBP_bracket 12 (q := 1.0465) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

end ConnesConsani.WeilPositivity
