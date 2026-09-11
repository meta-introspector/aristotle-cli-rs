/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscLin

/-!
# Rational brackets for the breakpoints of the extended partition (part 2)

The extended partition reaches `q = 5`, where the logarithmic series converges
slowly, so the number of terms is chosen breakpoint by breakpoint.
-/

set_option maxHeartbeats 4000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem vbpT83 : (2.691160492:ℝ) ≤ vBP 3.8405734 ∧ vBP 3.8405734 ≤ 2.691322239 := by
  have h := vBP_bracket 37 (q := 3.8405734) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT84 : (2.707956473:ℝ) ≤ vBP 3.8729828 ∧ vBP 3.8729828 ≤ 2.708138876 := by
  have h := vBP_bracket 37 (q := 3.8729828) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT85 : (2.707957041:ℝ) ≤ vBP 3.8729839 ∧ vBP 3.8729839 ≤ 2.708139444 := by
  have h := vBP_bracket 37 (q := 3.8729839) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT86 : (2.724501131:ℝ) ≤ vBP 3.9051243 ∧ vBP 3.9051243 ≤ 2.724653663 := by
  have h := vBP_bracket 38 (q := 3.9051243) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT87 : (2.724501694:ℝ) ≤ vBP 3.9051254 ∧ vBP 3.9051254 ≤ 2.724654227 := by
  have h := vBP_bracket 38 (q := 3.9051254) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT88 : (2.740751991:ℝ) ≤ vBP 3.9370034 ∧ vBP 3.9370034 ≤ 2.740923401 := by
  have h := vBP_bracket 38 (q := 3.9370034) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT89 : (2.740752549:ℝ) ≤ vBP 3.9370045 ∧ vBP 3.9370045 ≤ 2.74092396 := by
  have h := vBP_bracket 38 (q := 3.9370045) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT90 : (2.756741756:ℝ) ≤ vBP 3.9686264 ∧ vBP 3.9686264 ≤ 2.7569338 := by
  have h := vBP_bracket 38 (q := 3.9686264) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT91 : (2.75674231:ℝ) ≤ vBP 3.9686275 ∧ vBP 3.9686275 ≤ 2.756934355 := by
  have h := vBP_bracket 38 (q := 3.9686275) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT92 : (2.772506138:ℝ) ≤ vBP 3.9999995 ∧ vBP 3.9999995 ≤ 2.772667044 := by
  have h := vBP_bracket 39 (q := 3.9999995) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT93 : (2.772506637:ℝ) ≤ vBP 4.0000005 ∧ vBP 4.0000005 ≤ 2.772667544 := by
  have h := vBP_bracket 39 (q := 4.0000005) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT94 : (2.788000663:ℝ) ≤ vBP 4.0311283 ∧ vBP 4.0311283 ≤ 2.788180384 := by
  have h := vBP_bracket 39 (q := 4.0311283) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT95 : (2.788001209:ℝ) ≤ vBP 4.0311294 ∧ vBP 4.0311294 ≤ 2.78818093 := by
  have h := vBP_bracket 39 (q := 4.0311294) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT96 : (2.803282958:ℝ) ≤ vBP 4.0620187 ∧ vBP 4.0620187 ≤ 2.803433865 := by
  have h := vBP_bracket 40 (q := 4.0620187) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT97 : (2.8032835:ℝ) ≤ vBP 4.0620198 ∧ vBP 4.0620198 ≤ 2.803434407 := by
  have h := vBP_bracket 40 (q := 4.0620198) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT98 : (2.818312022:ℝ) ≤ vBP 4.0926758 ∧ vBP 4.0926758 ≤ 2.818480088 := by
  have h := vBP_bracket 40 (q := 4.0926758) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT99 : (2.81831256:ℝ) ≤ vBP 4.0926769 ∧ vBP 4.0926769 ≤ 2.818480626 := by
  have h := vBP_bracket 40 (q := 4.0926769) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT100 : (2.833117613:ℝ) ≤ vBP 4.1231051 ∧ vBP 4.1231051 ≤ 2.83330431 := by
  have h := vBP_bracket 40 (q := 4.1231051) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT101 : (2.833118146:ℝ) ≤ vBP 4.1231062 ∧ vBP 4.1231062 ≤ 2.833304843 := by
  have h := vBP_bracket 40 (q := 4.1231062) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT102 : (2.847731603:ℝ) ≤ vBP 4.1533114 ∧ vBP 4.1533114 ≤ 2.847888674 := by
  have h := vBP_bracket 41 (q := 4.1533114) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT103 : (2.847732132:ℝ) ≤ vBP 4.1533125 ∧ vBP 4.1533125 ≤ 2.847889204 := by
  have h := vBP_bracket 41 (q := 4.1533125) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT104 : (2.862111671:ℝ) ≤ vBP 4.1832996 ∧ vBP 4.1832996 ≤ 2.862285708 := by
  have h := vBP_bracket 41 (q := 4.1832996) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT105 : (2.862112197:ℝ) ≤ vBP 4.1833007 ∧ vBP 4.1833007 ≤ 2.862286234 := by
  have h := vBP_bracket 41 (q := 4.1833007) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT106 : (2.876286905:ℝ) ≤ vBP 4.2130743 ∧ vBP 4.2130743 ≤ 2.87647929 := by
  have h := vBP_bracket 41 (q := 4.2130743) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT107 : (2.876287427:ℝ) ≤ vBP 4.2130754 ∧ vBP 4.2130754 ≤ 2.876479812 := by
  have h := vBP_bracket 41 (q := 4.2130754) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT108 : (2.890288629:ℝ) ≤ vBP 4.2426401 ∧ vBP 4.2426401 ≤ 2.890450806 := by
  have h := vBP_bracket 42 (q := 4.2426401) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT109 : (2.890289147:ℝ) ≤ vBP 4.2426412 ∧ vBP 4.2426412 ≤ 2.890451325 := by
  have h := vBP_bracket 42 (q := 4.2426412) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT110 : (2.904073436:ℝ) ≤ vBP 4.2720013 ∧ vBP 4.2720013 ≤ 2.9042523 := by
  have h := vBP_bracket 42 (q := 4.2720013) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT111 : (2.904073951:ℝ) ≤ vBP 4.2720024 ∧ vBP 4.2720024 ≤ 2.904252816 := by
  have h := vBP_bracket 42 (q := 4.2720024) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT112 : (2.917669921:ℝ) ≤ vBP 4.3011621 ∧ vBP 4.3011621 ≤ 2.91786677 := by
  have h := vBP_bracket 42 (q := 4.3011621) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT113 : (2.917670433:ℝ) ≤ vBP 4.3011632 ∧ vBP 4.3011632 ≤ 2.917867282 := by
  have h := vBP_bracket 42 (q := 4.3011632) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT114 : (2.931108612:ℝ) ≤ vBP 4.3301265 ∧ vBP 4.3301265 ≤ 2.931274881 := by
  have h := vBP_bracket 43 (q := 4.3301265) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT115 : (2.93110912:ℝ) ≤ vBP 4.3301276 ∧ vBP 4.3301276 ≤ 2.931275389 := by
  have h := vBP_bracket 43 (q := 4.3301276) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT116 : (2.944345486:ℝ) ≤ vBP 4.3588984 ∧ vBP 4.3588984 ≤ 2.944528096 := by
  have h := vBP_bracket 43 (q := 4.3588984) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT117 : (2.94434599:ℝ) ≤ vBP 4.3588995 ∧ vBP 4.3588995 ≤ 2.944528601 := by
  have h := vBP_bracket 43 (q := 4.3588995) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT118 : (2.957431912:ℝ) ≤ vBP 4.3874816 ∧ vBP 4.3874816 ≤ 2.957586456 := by
  have h := vBP_bracket 44 (q := 4.3874816) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT119 : (2.957432413:ℝ) ≤ vBP 4.3874827 ∧ vBP 4.3874827 ≤ 2.957586958 := by
  have h := vBP_bracket 44 (q := 4.3874827) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT120 : (2.970327763:ℝ) ≤ vBP 4.4158799 ∧ vBP 4.4158799 ≤ 2.970497166 := by
  have h := vBP_bracket 44 (q := 4.4158799) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT121 : (2.970328261:ℝ) ≤ vBP 4.415881 ∧ vBP 4.415881 ≤ 2.970497665 := by
  have h := vBP_bracket 44 (q := 4.415881) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT122 : (2.983058667:ℝ) ≤ vBP 4.4440967 ∧ vBP 4.4440967 ≤ 2.98324401 := by
  have h := vBP_bracket 44 (q := 4.4440967) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT123 : (2.983059161:ℝ) ≤ vBP 4.4440978 ∧ vBP 4.4440978 ≤ 2.983244506 := by
  have h := vBP_bracket 44 (q := 4.4440978) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT124 : (2.995651849:ℝ) ≤ vBP 4.4721354 ∧ vBP 4.4721354 ≤ 2.995809007 := by
  have h := vBP_bracket 45 (q := 4.4721354) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT125 : (2.995652341:ℝ) ≤ vBP 4.4721365 ∧ vBP 4.4721365 ≤ 2.995809499 := by
  have h := vBP_bracket 45 (q := 4.4721365) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT126 : (3.008067006:ℝ) ≤ vBP 4.4999995 ∧ vBP 4.4999995 ≤ 3.00823865 := by
  have h := vBP_bracket 45 (q := 4.4999995) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT127 : (3.00806745:ℝ) ≤ vBP 4.5000005 ∧ vBP 4.5000005 ≤ 3.008239094 := by
  have h := vBP_bracket 45 (q := 4.5000005) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT128 : (3.020329163:ℝ) ≤ vBP 4.527692 ∧ vBP 4.527692 ≤ 3.020516306 := by
  have h := vBP_bracket 45 (q := 4.527692) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT129 : (3.020329649:ℝ) ≤ vBP 4.5276931 ∧ vBP 4.5276931 ≤ 3.020516792 := by
  have h := vBP_bracket 45 (q := 4.5276931) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT130 : (3.032464915:ℝ) ≤ vBP 4.5552162 ∧ vBP 4.5552162 ≤ 3.032623898 := by
  have h := vBP_bracket 46 (q := 4.5552162) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT131 : (3.032465398:ℝ) ≤ vBP 4.5552173 ∧ vBP 4.5552173 ≤ 3.032624382 := by
  have h := vBP_bracket 46 (q := 4.5552173) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT132 : (3.044433927:ℝ) ≤ vBP 4.5825751 ∧ vBP 4.5825751 ≤ 3.044606988 := by
  have h := vBP_bracket 46 (q := 4.5825751) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT133 : (3.044434407:ℝ) ≤ vBP 4.5825762 ∧ vBP 4.5825762 ≤ 3.044607469 := by
  have h := vBP_bracket 46 (q := 4.5825762) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT134 : (3.056260754:ℝ) ≤ vBP 4.6097717 ∧ vBP 4.6097717 ≤ 3.05644884 := by
  have h := vBP_bracket 46 (q := 4.6097717) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT135 : (3.056261231:ℝ) ≤ vBP 4.6097728 ∧ vBP 4.6097728 ≤ 3.056449318 := by
  have h := vBP_bracket 46 (q := 4.6097728) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT136 : (3.067971099:ℝ) ≤ vBP 4.6368087 ∧ vBP 4.6368087 ≤ 3.068131181 := by
  have h := vBP_bracket 47 (q := 4.6368087) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT137 : (3.067971573:ℝ) ≤ vBP 4.6368098 ∧ vBP 4.6368098 ≤ 3.068131656 := by
  have h := vBP_bracket 47 (q := 4.6368098) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT138 : (3.079524978:ℝ) ≤ vBP 4.663689 ∧ vBP 4.663689 ≤ 3.079698704 := by
  have h := vBP_bracket 47 (q := 4.663689) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT139 : (3.079525449:ℝ) ≤ vBP 4.6636901 ∧ vBP 4.6636901 ≤ 3.079699176 := by
  have h := vBP_bracket 47 (q := 4.6636901) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT140 : (3.090946257:ℝ) ≤ vBP 4.6904152 ∧ vBP 4.6904152 ≤ 3.09113451 := by
  have h := vBP_bracket 47 (q := 4.6904152) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT141 : (3.090946725:ℝ) ≤ vBP 4.6904163 ∧ vBP 4.6904163 ≤ 3.091134979 := by
  have h := vBP_bracket 47 (q := 4.6904163) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT142 : (3.102259979:ℝ) ≤ vBP 4.71699 ∧ vBP 4.71699 ≤ 3.102420497 := by
  have h := vBP_bracket 48 (q := 4.71699) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT143 : (3.102260445:ℝ) ≤ vBP 4.7169911 ∧ vBP 4.7169911 ≤ 3.102420963 := by
  have h := vBP_bracket 48 (q := 4.7169911) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT144 : (3.11342655:ℝ) ≤ vBP 4.7434159 ∧ vBP 4.7434159 ≤ 3.113600259 := by
  have h := vBP_bracket 48 (q := 4.7434159) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT145 : (3.113427014:ℝ) ≤ vBP 4.743417 ∧ vBP 4.743417 ≤ 3.113600723 := by
  have h := vBP_bracket 48 (q := 4.743417) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT146 : (3.124469282:ℝ) ≤ vBP 4.7696955 ∧ vBP 4.7696955 ≤ 3.124657006 := by
  have h := vBP_bracket 48 (q := 4.7696955) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT147 : (3.124469743:ℝ) ≤ vBP 4.7696966 ∧ vBP 4.7696966 ≤ 3.124657467 := by
  have h := vBP_bracket 48 (q := 4.7696966) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT148 : (3.135412323:ℝ) ≤ vBP 4.795831 ∧ vBP 4.795831 ≤ 3.135572675 := by
  have h := vBP_bracket 49 (q := 4.795831) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT149 : (3.135412781:ℝ) ≤ vBP 4.7958321 ∧ vBP 4.7958321 ≤ 3.135573134 := by
  have h := vBP_bracket 49 (q := 4.7958321) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT150 : (3.146216735:ℝ) ≤ vBP 4.8218248 ∧ vBP 4.8218248 ≤ 3.146389813 := by
  have h := vBP_bracket 49 (q := 4.8218248) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT151 : (3.146217191:ℝ) ≤ vBP 4.8218259 ∧ vBP 4.8218259 ≤ 3.14639027 := by
  have h := vBP_bracket 49 (q := 4.8218259) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT152 : (3.156905163:ℝ) ≤ vBP 4.8476793 ∧ vBP 4.8476793 ≤ 3.157091735 := by
  have h := vBP_bracket 49 (q := 4.8476793) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT153 : (3.156905617:ℝ) ≤ vBP 4.8476804 ∧ vBP 4.8476804 ≤ 3.157092189 := by
  have h := vBP_bracket 49 (q := 4.8476804) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT154 : (3.167501009:ℝ) ≤ vBP 4.8733966 ∧ vBP 4.8733966 ≤ 3.167660657 := by
  have h := vBP_bracket 50 (q := 4.8733966) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT155 : (3.16750146:ℝ) ≤ vBP 4.8733977 ∧ vBP 4.8733977 ≤ 3.167661109 := by
  have h := vBP_bracket 50 (q := 4.8733977) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT156 : (3.177966066:ℝ) ≤ vBP 4.8989789 ∧ vBP 4.8989789 ≤ 3.178137968 := by
  have h := vBP_bracket 50 (q := 4.8989789) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT157 : (3.177966515:ℝ) ≤ vBP 4.89898 ∧ vBP 4.89898 ≤ 3.178138417 := by
  have h := vBP_bracket 50 (q := 4.89898) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT158 : (3.188322286:ℝ) ≤ vBP 4.9244284 ∧ vBP 4.9244284 ≤ 3.188507157 := by
  have h := vBP_bracket 50 (q := 4.9244284) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT159 : (3.188322733:ℝ) ≤ vBP 4.9244295 ∧ vBP 4.9244295 ≤ 3.188507604 := by
  have h := vBP_bracket 50 (q := 4.9244295) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT160 : (3.198571778:ℝ) ≤ vBP 4.9497469 ∧ vBP 4.9497469 ≤ 3.198770363 := by
  have h := vBP_bracket 50 (q := 4.9497469) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT161 : (3.198572223:ℝ) ≤ vBP 4.949748 ∧ vBP 4.949748 ≤ 3.198770808 := by
  have h := vBP_bracket 50 (q := 4.949748) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT162 : (3.208738603:ℝ) ≤ vBP 4.9749366 ∧ vBP 4.9749366 ≤ 3.208908846 := by
  have h := vBP_bracket 51 (q := 4.9749366) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT163 : (3.208739045:ℝ) ≤ vBP 4.9749377 ∧ vBP 4.9749377 ≤ 3.208909288 := by
  have h := vBP_bracket 51 (q := 4.9749377) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT164 : (3.21878264:ℝ) ≤ vBP 4.9999995 ∧ vBP 4.9999995 ≤ 3.218965329 := by
  have h := vBP_bracket 51 (q := 4.9999995) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT165 : (3.21878284:ℝ) ≤ vBP 5 ∧ vBP 5 ≤ 3.218965529 := by
  have h := vBP_bracket 51 (q := 5) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

end ConnesConsani.WeilPositivity
