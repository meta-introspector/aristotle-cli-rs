/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscLin

/-!
# Rational brackets for the breakpoints of the extended partition (part 1)

The extended partition reaches `q = 5`, where the logarithmic series converges
slowly, so the number of terms is chosen breakpoint by breakpoint.
-/

set_option maxHeartbeats 4000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem vbpT0 : (1.50398894:ℝ) ≤ vBP 2.1213198 ∧ vBP 2.1213198 ≤ 1.504155575 := by
  have h := vBP_bracket 16 (q := 2.1213198) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT1 : (1.503989977:ℝ) ≤ vBP 2.1213209 ∧ vBP 2.1213209 ≤ 1.504156613 := by
  have h := vBP_bracket 16 (q := 2.1213209) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT2 : (1.558071388:ℝ) ≤ vBP 2.1794489 ∧ vBP 2.1794489 ≤ 1.558209551 := by
  have h := vBP_bracket 17 (q := 2.1794489) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT3 : (1.558072397:ℝ) ≤ vBP 2.17945 ∧ vBP 2.17945 ≤ 1.558210561 := by
  have h := vBP_bracket 17 (q := 2.17945) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT4 : (1.609377116:ℝ) ≤ vBP 2.2360674 ∧ vBP 2.2360674 ≤ 1.609491967 := by
  have h := vBP_bracket 18 (q := 2.2360674) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT5 : (1.609378099:ℝ) ≤ vBP 2.2360685 ∧ vBP 2.2360685 ≤ 1.609492951 := by
  have h := vBP_bracket 18 (q := 2.2360685) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT6 : (1.658138462:ℝ) ≤ vBP 2.2912873 ∧ vBP 2.2912873 ≤ 1.658308312 := by
  have h := vBP_bracket 18 (q := 2.2912873) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT7 : (1.658139422:ℝ) ≤ vBP 2.2912884 ∧ vBP 2.2912884 ≤ 1.658309273 := by
  have h := vBP_bracket 18 (q := 2.2912884) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT8 : (1.704674589:ℝ) ≤ vBP 2.3452073 ∧ vBP 2.3452073 ≤ 1.704814034 := by
  have h := vBP_bracket 19 (q := 2.3452073) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT9 : (1.704675526:ℝ) ≤ vBP 2.3452084 ∧ vBP 2.3452084 ≤ 1.704814973 := by
  have h := vBP_bracket 19 (q := 2.3452084) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT10 : (1.749096166:ℝ) ≤ vBP 2.3979152 ∧ vBP 2.3979152 ≤ 1.749293334 := by
  have h := vBP_bracket 19 (q := 2.3979152) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT11 : (1.749097083:ℝ) ≤ vBP 2.3979163 ∧ vBP 2.3979163 ≤ 1.749294252 := by
  have h := vBP_bracket 19 (q := 2.3979163) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT12 : (1.791675065:ℝ) ≤ vBP 2.4494892 ∧ vBP 2.4494892 ≤ 1.791835784 := by
  have h := vBP_bracket 20 (q := 2.4494892) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT13 : (1.791675963:ℝ) ≤ vBP 2.4494903 ∧ vBP 2.4494903 ≤ 1.791836683 := by
  have h := vBP_bracket 20 (q := 2.4494903) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT14 : (1.832512436:ℝ) ≤ vBP 2.4999995 ∧ vBP 2.4999995 ≤ 1.832644058 := by
  have h := vBP_bracket 21 (q := 2.4999995) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT15 : (1.832513235:ℝ) ≤ vBP 2.5000005 ∧ vBP 2.5000005 ≤ 1.832644858 := by
  have h := vBP_bracket 21 (q := 2.5000005) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT16 : (1.871708868:ℝ) ≤ vBP 2.5495092 ∧ vBP 2.5495092 ≤ 1.871887001 := by
  have h := vBP_bracket 21 (q := 2.5495092) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT17 : (1.87170973:ℝ) ≤ vBP 2.5495103 ∧ vBP 2.5495103 ≤ 1.871887865 := by
  have h := vBP_bracket 21 (q := 2.5495103) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT18 : (1.909466456:ℝ) ≤ vBP 2.5980757 ∧ vBP 2.5980757 ≤ 1.909611822 := by
  have h := vBP_bracket 22 (q := 2.5980757) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT19 : (1.909467302:ℝ) ≤ vBP 2.5980768 ∧ vBP 2.5980768 ≤ 1.909612669 := by
  have h := vBP_bracket 22 (q := 2.5980768) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT20 : (1.94581006:ℝ) ≤ vBP 2.6457508 ∧ vBP 2.6457508 ≤ 1.946001644 := by
  have h := vBP_bracket 22 (q := 2.6457508) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT21 : (1.945810891:ℝ) ≤ vBP 2.6457519 ∧ vBP 2.6457519 ≤ 1.946002476 := by
  have h := vBP_bracket 22 (q := 2.6457519) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT22 : (1.980919995:ℝ) ≤ vBP 2.6925819 ∧ vBP 2.6925819 ≤ 1.981076083 := by
  have h := vBP_bracket 23 (q := 2.6925819) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT23 : (1.980920811:ℝ) ≤ vBP 2.692583 ∧ vBP 2.692583 ≤ 1.981076901 := by
  have h := vBP_bracket 23 (q := 2.692583) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT24 : (2.014836308:ℝ) ≤ vBP 2.7386122 ∧ vBP 2.7386122 ≤ 2.014964069 := by
  have h := vBP_bracket 24 (q := 2.7386122) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT25 : (2.014837111:ℝ) ≤ vBP 2.7386133 ∧ vBP 2.7386133 ≤ 2.014964873 := by
  have h := vBP_bracket 24 (q := 2.7386133) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT26 : (2.047607394:ℝ) ≤ vBP 2.7838816 ∧ vBP 2.7838816 ≤ 2.0477713 := by
  have h := vBP_bracket 24 (q := 2.7838816) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT27 : (2.047608184:ℝ) ≤ vBP 2.7838827 ∧ vBP 2.7838827 ≤ 2.047772091 := by
  have h := vBP_bracket 24 (q := 2.7838827) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT28 : (2.079371693:ℝ) ≤ vBP 2.8284266 ∧ vBP 2.8284266 ≤ 2.079505801 := by
  have h := vBP_bracket 25 (q := 2.8284266) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT29 : (2.07937247:ℝ) ≤ vBP 2.8284277 ∧ vBP 2.8284277 ≤ 2.079506579 := by
  have h := vBP_bracket 25 (q := 2.8284277) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT30 : (2.110125256:ℝ) ≤ vBP 2.8722808 ∧ vBP 2.8722808 ≤ 2.110294314 := by
  have h := vBP_bracket 25 (q := 2.8722808) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT31 : (2.110126021:ℝ) ≤ vBP 2.8722819 ∧ vBP 2.8722819 ≤ 2.11029508 := by
  have h := vBP_bracket 25 (q := 2.8722819) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT32 : (2.139994189:ℝ) ≤ vBP 2.9154754 ∧ vBP 2.9154754 ≤ 2.140132573 := by
  have h := vBP_bracket 26 (q := 2.9154754) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT33 : (2.139994943:ℝ) ≤ vBP 2.9154765 ∧ vBP 2.9154765 ≤ 2.140133328 := by
  have h := vBP_bracket 26 (q := 2.9154765) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT34 : (2.168964393:ℝ) ≤ vBP 2.9580393 ∧ vBP 2.9580393 ≤ 2.169136238 := by
  have h := vBP_bracket 26 (q := 2.9580393) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT35 : (2.168965136:ℝ) ≤ vBP 2.9580404 ∧ vBP 2.9580404 ≤ 2.169136982 := by
  have h := vBP_bracket 26 (q := 2.9580404) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT36 : (2.197151479:ℝ) ≤ vBP 2.9999995 ∧ vBP 2.9999995 ≤ 2.197292288 := by
  have h := vBP_bracket 27 (q := 2.9999995) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT37 : (2.197152146:ℝ) ≤ vBP 3.0000005 ∧ vBP 3.0000005 ≤ 2.197292955 := by
  have h := vBP_bracket 27 (q := 3.0000005) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT38 : (2.224533993:ℝ) ≤ vBP 3.0413807 ∧ vBP 3.0413807 ≤ 2.224706587 := by
  have h := vBP_bracket 27 (q := 3.0413807) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT39 : (2.224534716:ℝ) ≤ vBP 3.0413818 ∧ vBP 3.0413818 ≤ 2.22470731 := by
  have h := vBP_bracket 27 (q := 3.0413818) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT40 : (2.251218372:ℝ) ≤ vBP 3.0822065 ∧ vBP 3.0822065 ≤ 2.251359992 := by
  have h := vBP_bracket 28 (q := 3.0822065) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT41 : (2.251219085:ℝ) ≤ vBP 3.0822076 ∧ vBP 3.0822076 ≤ 2.251360706 := by
  have h := vBP_bracket 28 (q := 3.0822076) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT42 : (2.277178316:ℝ) ≤ vBP 3.1224984 ∧ vBP 3.1224984 ≤ 2.277349939 := by
  have h := vBP_bracket 28 (q := 3.1224984) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT43 : (2.27717902:ℝ) ≤ vBP 3.1224995 ∧ vBP 3.1224995 ≤ 2.277350644 := by
  have h := vBP_bracket 28 (q := 3.1224995) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT44 : (2.302512003:ℝ) ≤ vBP 3.1622771 ∧ vBP 3.1622771 ≤ 2.302653063 := by
  have h := vBP_bracket 29 (q := 3.1622771) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT45 : (2.302512698:ℝ) ≤ vBP 3.1622782 ∧ vBP 3.1622782 ≤ 2.302653759 := by
  have h := vBP_bracket 29 (q := 3.1622782) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT46 : (2.32719012:ℝ) ≤ vBP 3.2015616 ∧ vBP 3.2015616 ≤ 2.327359356 := by
  have h := vBP_bracket 29 (q := 3.2015616) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT47 : (2.327190807:ℝ) ≤ vBP 3.2015627 ∧ vBP 3.2015627 ≤ 2.327360044 := by
  have h := vBP_bracket 29 (q := 3.2015627) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT48 : (2.35130313:ℝ) ≤ vBP 3.2403698 ∧ vBP 3.2403698 ≤ 2.35144249 := by
  have h := vBP_bracket 30 (q := 3.2403698) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT49 : (2.351303809:ℝ) ≤ vBP 3.2403709 ∧ vBP 3.2403709 ≤ 2.351443169 := by
  have h := vBP_bracket 30 (q := 3.2403709) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT50 : (2.374820052:ℝ) ≤ vBP 3.2787187 ∧ vBP 3.2787187 ≤ 2.374985762 := by
  have h := vBP_bracket 30 (q := 3.2787187) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT51 : (2.374820723:ℝ) ≤ vBP 3.2787198 ∧ vBP 3.2787198 ≤ 2.374986434 := by
  have h := vBP_bracket 30 (q := 3.2787198) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT52 : (2.397794087:ℝ) ≤ vBP 3.3166242 ∧ vBP 3.3166242 ≤ 2.397989835 := by
  have h := vBP_bracket 30 (q := 3.3166242) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT53 : (2.39779475:ℝ) ≤ vBP 3.3166253 ∧ vBP 3.3166253 ≤ 2.397990499 := by
  have h := vBP_bracket 30 (q := 3.3166253) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT54 : (2.420284785:ℝ) ≤ vBP 3.3541014 ∧ vBP 3.3541014 ≤ 2.420446075 := by
  have h := vBP_bracket 31 (q := 3.3541014) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT55 : (2.420285441:ℝ) ≤ vBP 3.3541025 ∧ vBP 3.3541025 ≤ 2.420446731 := by
  have h := vBP_bracket 31 (q := 3.3541025) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT56 : (2.442249358:ℝ) ≤ vBP 3.3911644 ∧ vBP 3.3911644 ≤ 2.442438483 := by
  have h := vBP_bracket 31 (q := 3.3911644) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT57 : (2.442250006:ℝ) ≤ vBP 3.3911655 ∧ vBP 3.3911655 ≤ 2.442439132 := by
  have h := vBP_bracket 31 (q := 3.3911655) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT58 : (2.463772638:ℝ) ≤ vBP 3.4278268 ∧ vBP 3.4278268 ≤ 2.463928825 := by
  have h := vBP_bracket 32 (q := 3.4278268) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT59 : (2.46377328:ℝ) ≤ vBP 3.4278279 ∧ vBP 3.4278279 ≤ 2.463929467 := by
  have h := vBP_bracket 32 (q := 3.4278279) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT60 : (2.484812809:ℝ) ≤ vBP 3.4641011 ∧ vBP 3.4641011 ≤ 2.484994735 := by
  have h := vBP_bracket 32 (q := 3.4641011) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT61 : (2.484813444:ℝ) ≤ vBP 3.4641022 ∧ vBP 3.4641022 ≤ 2.484995371 := by
  have h := vBP_bracket 32 (q := 3.4641022) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT62 : (2.505448285:ℝ) ≤ vBP 3.4999995 ∧ vBP 3.4999995 ≤ 2.505598868 := by
  have h := vBP_bracket 33 (q := 3.4999995) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT63 : (2.505448856:ℝ) ≤ vBP 3.5000005 ∧ vBP 3.5000005 ≤ 2.50559944 := by
  have h := vBP_bracket 33 (q := 3.5000005) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT64 : (2.525638786:ℝ) ≤ vBP 3.5355334 ∧ vBP 3.5355334 ≤ 2.52581313 := by
  have h := vBP_bracket 33 (q := 3.5355334) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT65 : (2.525639408:ℝ) ≤ vBP 3.5355345 ∧ vBP 3.5355345 ≤ 2.525813753 := by
  have h := vBP_bracket 33 (q := 3.5355345) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT66 : (2.54545673:ℝ) ≤ vBP 3.5707137 ∧ vBP 3.5707137 ≤ 2.545601365 := by
  have h := vBP_bracket 34 (q := 3.5707137) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT67 : (2.545457346:ℝ) ≤ vBP 3.5707148 ∧ vBP 3.5707148 ≤ 2.545601981 := by
  have h := vBP_bracket 34 (q := 3.5707148) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT68 : (2.564863542:ℝ) ≤ vBP 3.6055507 ∧ vBP 3.6055507 ≤ 2.56503008 := by
  have h := vBP_bracket 34 (q := 3.6055507) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT69 : (2.564864152:ℝ) ≤ vBP 3.6055518 ∧ vBP 3.6055518 ≤ 2.56503069 := by
  have h := vBP_bracket 34 (q := 3.6055518) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT70 : (2.583899243:ℝ) ≤ vBP 3.6400544 ∧ vBP 3.6400544 ≤ 2.584090161 := by
  have h := vBP_bracket 34 (q := 3.6400544) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT71 : (2.583899847:ℝ) ≤ vBP 3.6400555 ∧ vBP 3.6400555 ≤ 2.584090765 := by
  have h := vBP_bracket 34 (q := 3.6400555) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT72 : (2.602608025:ℝ) ≤ vBP 3.6742341 ∧ vBP 3.6742341 ≤ 2.602766661 := by
  have h := vBP_bracket 35 (q := 3.6742341) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT73 : (2.602608623:ℝ) ≤ vBP 3.6742352 ∧ vBP 3.6742352 ≤ 2.60276726 := by
  have h := vBP_bracket 35 (q := 3.6742352) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT74 : (2.620945677:ℝ) ≤ vBP 3.7080987 ∧ vBP 3.7080987 ≤ 2.621126681 := by
  have h := vBP_bracket 35 (q := 3.7080987) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT75 : (2.62094627:ℝ) ≤ vBP 3.7080998 ∧ vBP 3.7080998 ≤ 2.621127275 := by
  have h := vBP_bracket 35 (q := 3.7080998) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT76 : (2.638979736:ℝ) ≤ vBP 3.7416568 ∧ vBP 3.7416568 ≤ 2.639130481 := by
  have h := vBP_bracket 36 (q := 3.7416568) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT77 : (2.638980323:ℝ) ≤ vBP 3.7416579 ∧ vBP 3.7416579 ≤ 2.63913107 := by
  have h := vBP_bracket 36 (q := 3.7416579) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT78 : (2.656668839:ℝ) ≤ vBP 3.7749167 ∧ vBP 3.7749167 ≤ 2.656840095 := by
  have h := vBP_bracket 36 (q := 3.7749167) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT79 : (2.656669422:ℝ) ≤ vBP 3.7749178 ∧ vBP 3.7749178 ≤ 2.656840678 := by
  have h := vBP_bracket 36 (q := 3.7749178) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT80 : (2.674048981:ℝ) ≤ vBP 3.807886 ∧ vBP 3.807886 ≤ 2.674242838 := by
  have h := vBP_bracket 36 (q := 3.807886) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT81 : (2.674049559:ℝ) ≤ vBP 3.8078871 ∧ vBP 3.8078871 ≤ 2.674243416 := by
  have h := vBP_bracket 36 (q := 3.8078871) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpT82 : (2.691159919:ℝ) ≤ vBP 3.8405723 ∧ vBP 3.8405723 ≤ 2.691321666 := by
  have h := vBP_bracket 37 (q := 3.8405723) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

end ConnesConsani.WeilPositivity
