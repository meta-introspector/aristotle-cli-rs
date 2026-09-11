/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscLin

/-!
# Rational brackets for the breakpoints `vBP q = 2 log q` (part 2)

Each bracket comes from the logarithmic series `vBP_bracket 12`.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem vbpP141 : (0.091857863:ℝ) ≤ vBP 1.047 ∧ vBP 1.047 ≤ 0.091857864 := by
  have h := vBP_bracket 12 (q := 1.047) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP142 : (0.093767171:ℝ) ≤ vBP 1.048 ∧ vBP 1.048 ≤ 0.093767172 := by
  have h := vBP_bracket 12 (q := 1.048) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP143 : (0.095674658:ℝ) ≤ vBP 1.049 ∧ vBP 1.049 ≤ 0.095674659 := by
  have h := vBP_bracket 12 (q := 1.049) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP144 : (0.097580328:ℝ) ≤ vBP 1.05 ∧ vBP 1.05 ≤ 0.097580329 := by
  have h := vBP_bracket 12 (q := 1.05) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP145 : (0.099484183:ℝ) ≤ vBP 1.051 ∧ vBP 1.051 ≤ 0.099484184 := by
  have h := vBP_bracket 12 (q := 1.051) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP146 : (0.101386228:ℝ) ≤ vBP 1.052 ∧ vBP 1.052 ≤ 0.101386229 := by
  have h := vBP_bracket 12 (q := 1.052) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP147 : (0.103286466:ℝ) ≤ vBP 1.053 ∧ vBP 1.053 ≤ 0.103286467 := by
  have h := vBP_bracket 12 (q := 1.053) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP148 : (0.1051849:ℝ) ≤ vBP 1.054 ∧ vBP 1.054 ≤ 0.105184901 := by
  have h := vBP_bracket 12 (q := 1.054) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP149 : (0.107081533:ℝ) ≤ vBP 1.055 ∧ vBP 1.055 ≤ 0.107081534 := by
  have h := vBP_bracket 12 (q := 1.055) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP150 : (0.10897637:ℝ) ≤ vBP 1.056 ∧ vBP 1.056 ≤ 0.108976371 := by
  have h := vBP_bracket 12 (q := 1.056) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP151 : (0.110869413:ℝ) ≤ vBP 1.057 ∧ vBP 1.057 ≤ 0.110869414 := by
  have h := vBP_bracket 12 (q := 1.057) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP152 : (0.112760666:ℝ) ≤ vBP 1.058 ∧ vBP 1.058 ≤ 0.112760667 := by
  have h := vBP_bracket 12 (q := 1.058) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP153 : (0.114650133:ℝ) ≤ vBP 1.059 ∧ vBP 1.059 ≤ 0.114650134 := by
  have h := vBP_bracket 12 (q := 1.059) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP154 : (0.116537816:ℝ) ≤ vBP 1.06 ∧ vBP 1.06 ≤ 0.116537817 := by
  have h := vBP_bracket 12 (q := 1.06) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP155 : (0.118423719:ℝ) ≤ vBP 1.061 ∧ vBP 1.061 ≤ 0.11842372 := by
  have h := vBP_bracket 12 (q := 1.061) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP156 : (0.120307845:ℝ) ≤ vBP 1.062 ∧ vBP 1.062 ≤ 0.120307846 := by
  have h := vBP_bracket 12 (q := 1.062) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP157 : (0.124070781:ℝ) ≤ vBP 1.064 ∧ vBP 1.064 ≤ 0.124070782 := by
  have h := vBP_bracket 12 (q := 1.064) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP158 : (0.127826651:ℝ) ≤ vBP 1.066 ∧ vBP 1.066 ≤ 0.127826652 := by
  have h := vBP_bracket 12 (q := 1.066) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP159 : (0.131575481:ℝ) ≤ vBP 1.068 ∧ vBP 1.068 ≤ 0.131575482 := by
  have h := vBP_bracket 12 (q := 1.068) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP160 : (0.133447264:ℝ) ≤ vBP 1.069 ∧ vBP 1.069 ≤ 0.133447265 := by
  have h := vBP_bracket 12 (q := 1.069) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP161 : (0.139052125:ℝ) ≤ vBP 1.072 ∧ vBP 1.072 ≤ 0.139052126 := by
  have h := vBP_bracket 12 (q := 1.072) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP162 : (0.142779992:ℝ) ≤ vBP 1.074 ∧ vBP 1.074 ≤ 0.142779993 := by
  have h := vBP_bracket 12 (q := 1.074) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP163 : (0.150214944:ℝ) ≤ vBP 1.078 ∧ vBP 1.078 ≤ 0.150214945 := by
  have h := vBP_bracket 12 (q := 1.078) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP164 : (0.153922082:ℝ) ≤ vBP 1.08 ∧ vBP 1.08 ≤ 0.153922083 := by
  have h := vBP_bracket 12 (q := 1.08) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP165 : (0.159469936:ℝ) ≤ vBP 1.083 ∧ vBP 1.083 ≤ 0.159469937 := by
  have h := vBP_bracket 12 (q := 1.083) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP166 : (0.165002443:ℝ) ≤ vBP 1.086 ∧ vBP 1.086 ≤ 0.165002444 := by
  have h := vBP_bracket 12 (q := 1.086) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP167 : (0.168682296:ℝ) ≤ vBP 1.088 ∧ vBP 1.088 ≤ 0.168682297 := by
  have h := vBP_bracket 12 (q := 1.088) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP168 : (0.172355392:ℝ) ≤ vBP 1.09 ∧ vBP 1.09 ≤ 0.172355393 := by
  have h := vBP_bracket 12 (q := 1.09) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP169 : (0.176021754:ℝ) ≤ vBP 1.092 ∧ vBP 1.092 ≤ 0.176021755 := by
  have h := vBP_bracket 12 (q := 1.092) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP170 : (0.179681407:ℝ) ≤ vBP 1.094 ∧ vBP 1.094 ≤ 0.179681408 := by
  have h := vBP_bracket 12 (q := 1.094) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP171 : (0.181508726:ℝ) ≤ vBP 1.095 ∧ vBP 1.095 ≤ 0.181508727 := by
  have h := vBP_bracket 12 (q := 1.095) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP172 : (0.183334377:ℝ) ≤ vBP 1.096 ∧ vBP 1.096 ≤ 0.183334378 := by
  have h := vBP_bracket 12 (q := 1.096) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP173 : (0.185158362:ℝ) ≤ vBP 1.097 ∧ vBP 1.097 ≤ 0.185158363 := by
  have h := vBP_bracket 12 (q := 1.097) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP174 : (0.186980686:ℝ) ≤ vBP 1.098 ∧ vBP 1.098 ≤ 0.186980687 := by
  have h := vBP_bracket 12 (q := 1.098) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP175 : (0.18880135:ℝ) ≤ vBP 1.099 ∧ vBP 1.099 ≤ 0.188801351 := by
  have h := vBP_bracket 12 (q := 1.099) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP176 : (0.190620359:ℝ) ≤ vBP 1.1 ∧ vBP 1.1 ≤ 0.19062036 := by
  have h := vBP_bracket 12 (q := 1.1) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP177 : (0.192437715:ℝ) ≤ vBP 1.101 ∧ vBP 1.101 ≤ 0.192437716 := by
  have h := vBP_bracket 12 (q := 1.101) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP178 : (0.194253421:ℝ) ≤ vBP 1.102 ∧ vBP 1.102 ≤ 0.194253422 := by
  have h := vBP_bracket 12 (q := 1.102) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP179 : (0.19606748:ℝ) ≤ vBP 1.103 ∧ vBP 1.103 ≤ 0.196067481 := by
  have h := vBP_bracket 12 (q := 1.103) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP180 : (0.197879895:ℝ) ≤ vBP 1.104 ∧ vBP 1.104 ≤ 0.197879896 := by
  have h := vBP_bracket 12 (q := 1.104) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP181 : (0.199690669:ℝ) ≤ vBP 1.105 ∧ vBP 1.105 ≤ 0.19969067 := by
  have h := vBP_bracket 12 (q := 1.105) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP182 : (0.201499806:ℝ) ≤ vBP 1.106 ∧ vBP 1.106 ≤ 0.201499807 := by
  have h := vBP_bracket 12 (q := 1.106) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP183 : (0.203307307:ℝ) ≤ vBP 1.107 ∧ vBP 1.107 ≤ 0.203307308 := by
  have h := vBP_bracket 12 (q := 1.107) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP184 : (0.205113176:ℝ) ≤ vBP 1.108 ∧ vBP 1.108 ≤ 0.205113177 := by
  have h := vBP_bracket 12 (q := 1.108) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP185 : (0.206917416:ℝ) ≤ vBP 1.109 ∧ vBP 1.109 ≤ 0.206917417 := by
  have h := vBP_bracket 12 (q := 1.109) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP186 : (0.20872003:ℝ) ≤ vBP 1.11 ∧ vBP 1.11 ≤ 0.208720031 := by
  have h := vBP_bracket 12 (q := 1.11) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP187 : (0.210521021:ℝ) ≤ vBP 1.111 ∧ vBP 1.111 ≤ 0.210521022 := by
  have h := vBP_bracket 12 (q := 1.111) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP188 : (0.212320391:ℝ) ≤ vBP 1.112 ∧ vBP 1.112 ≤ 0.212320392 := by
  have h := vBP_bracket 12 (q := 1.112) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP189 : (0.214118144:ℝ) ≤ vBP 1.113 ∧ vBP 1.113 ≤ 0.214118145 := by
  have h := vBP_bracket 12 (q := 1.113) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP190 : (0.215914283:ℝ) ≤ vBP 1.114 ∧ vBP 1.114 ≤ 0.215914284 := by
  have h := vBP_bracket 12 (q := 1.114) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP191 : (0.217708809:ℝ) ≤ vBP 1.115 ∧ vBP 1.115 ≤ 0.21770881 := by
  have h := vBP_bracket 12 (q := 1.115) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP192 : (0.219501727:ℝ) ≤ vBP 1.116 ∧ vBP 1.116 ≤ 0.219501728 := by
  have h := vBP_bracket 12 (q := 1.116) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP193 : (0.22129304:ℝ) ≤ vBP 1.117 ∧ vBP 1.117 ≤ 0.221293041 := by
  have h := vBP_bracket 12 (q := 1.117) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP194 : (0.223082749:ℝ) ≤ vBP 1.118 ∧ vBP 1.118 ≤ 0.22308275 := by
  have h := vBP_bracket 12 (q := 1.118) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP195 : (0.224870858:ℝ) ≤ vBP 1.119 ∧ vBP 1.119 ≤ 0.224870859 := by
  have h := vBP_bracket 12 (q := 1.119) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP196 : (0.22665737:ℝ) ≤ vBP 1.12 ∧ vBP 1.12 ≤ 0.226657371 := by
  have h := vBP_bracket 12 (q := 1.12) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP197 : (0.228442288:ℝ) ≤ vBP 1.121 ∧ vBP 1.121 ≤ 0.228442289 := by
  have h := vBP_bracket 12 (q := 1.121) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP198 : (0.230225614:ℝ) ≤ vBP 1.122 ∧ vBP 1.122 ≤ 0.230225615 := by
  have h := vBP_bracket 12 (q := 1.122) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP199 : (0.232007351:ℝ) ≤ vBP 1.123 ∧ vBP 1.123 ≤ 0.232007352 := by
  have h := vBP_bracket 12 (q := 1.123) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP200 : (0.233787502:ℝ) ≤ vBP 1.124 ∧ vBP 1.124 ≤ 0.233787503 := by
  have h := vBP_bracket 12 (q := 1.124) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP201 : (0.235566071:ℝ) ≤ vBP 1.125 ∧ vBP 1.125 ≤ 0.235566072 := by
  have h := vBP_bracket 12 (q := 1.125) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP202 : (0.237343059:ℝ) ≤ vBP 1.126 ∧ vBP 1.126 ≤ 0.23734306 := by
  have h := vBP_bracket 12 (q := 1.126) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP203 : (0.23911847:ℝ) ≤ vBP 1.127 ∧ vBP 1.127 ≤ 0.239118471 := by
  have h := vBP_bracket 12 (q := 1.127) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP204 : (0.240892306:ℝ) ≤ vBP 1.128 ∧ vBP 1.128 ≤ 0.240892307 := by
  have h := vBP_bracket 12 (q := 1.128) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP205 : (0.24266457:ℝ) ≤ vBP 1.129 ∧ vBP 1.129 ≤ 0.242664571 := by
  have h := vBP_bracket 12 (q := 1.129) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP206 : (0.244435265:ℝ) ≤ vBP 1.13 ∧ vBP 1.13 ≤ 0.244435266 := by
  have h := vBP_bracket 12 (q := 1.13) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP207 : (0.246204394:ℝ) ≤ vBP 1.131 ∧ vBP 1.131 ≤ 0.246204395 := by
  have h := vBP_bracket 12 (q := 1.131) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP208 : (0.247971959:ℝ) ≤ vBP 1.132 ∧ vBP 1.132 ≤ 0.24797196 := by
  have h := vBP_bracket 12 (q := 1.132) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP209 : (0.249737964:ℝ) ≤ vBP 1.133 ∧ vBP 1.133 ≤ 0.249737965 := by
  have h := vBP_bracket 12 (q := 1.133) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP210 : (0.25150241:ℝ) ≤ vBP 1.134 ∧ vBP 1.134 ≤ 0.251502411 := by
  have h := vBP_bracket 12 (q := 1.134) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP211 : (0.253265301:ℝ) ≤ vBP 1.135 ∧ vBP 1.135 ≤ 0.253265302 := by
  have h := vBP_bracket 12 (q := 1.135) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP212 : (0.25502664:ℝ) ≤ vBP 1.136 ∧ vBP 1.136 ≤ 0.255026641 := by
  have h := vBP_bracket 12 (q := 1.136) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP213 : (0.256786429:ℝ) ≤ vBP 1.137 ∧ vBP 1.137 ≤ 0.25678643 := by
  have h := vBP_bracket 12 (q := 1.137) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP214 : (0.258544671:ℝ) ≤ vBP 1.138 ∧ vBP 1.138 ≤ 0.258544672 := by
  have h := vBP_bracket 12 (q := 1.138) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP215 : (0.260301368:ℝ) ≤ vBP 1.139 ∧ vBP 1.139 ≤ 0.260301369 := by
  have h := vBP_bracket 12 (q := 1.139) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP216 : (0.261179139:ℝ) ≤ vBP 1.1395 ∧ vBP 1.1395 ≤ 0.26117914 := by
  have h := vBP_bracket 12 (q := 1.1395) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP217 : (0.262056524:ℝ) ≤ vBP 1.14 ∧ vBP 1.14 ≤ 0.262056525 := by
  have h := vBP_bracket 12 (q := 1.14) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP218 : (0.262933525:ℝ) ≤ vBP 1.1405 ∧ vBP 1.1405 ≤ 0.262933526 := by
  have h := vBP_bracket 12 (q := 1.1405) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP219 : (0.263810141:ℝ) ≤ vBP 1.141 ∧ vBP 1.141 ≤ 0.263810142 := by
  have h := vBP_bracket 12 (q := 1.141) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP220 : (0.264686373:ℝ) ≤ vBP 1.1415 ∧ vBP 1.1415 ≤ 0.264686374 := by
  have h := vBP_bracket 12 (q := 1.1415) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP221 : (0.265562222:ℝ) ≤ vBP 1.142 ∧ vBP 1.142 ≤ 0.265562223 := by
  have h := vBP_bracket 12 (q := 1.142) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP222 : (0.266437687:ℝ) ≤ vBP 1.1425 ∧ vBP 1.1425 ≤ 0.266437688 := by
  have h := vBP_bracket 12 (q := 1.1425) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP223 : (0.267312769:ℝ) ≤ vBP 1.143 ∧ vBP 1.143 ≤ 0.26731277 := by
  have h := vBP_bracket 12 (q := 1.143) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP224 : (0.268187468:ℝ) ≤ vBP 1.1435 ∧ vBP 1.1435 ≤ 0.268187469 := by
  have h := vBP_bracket 12 (q := 1.1435) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP225 : (0.269061785:ℝ) ≤ vBP 1.144 ∧ vBP 1.144 ≤ 0.269061786 := by
  have h := vBP_bracket 12 (q := 1.144) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP226 : (0.26993572:ℝ) ≤ vBP 1.1445 ∧ vBP 1.1445 ≤ 0.269935721 := by
  have h := vBP_bracket 12 (q := 1.1445) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP227 : (0.270809274:ℝ) ≤ vBP 1.145 ∧ vBP 1.145 ≤ 0.270809275 := by
  have h := vBP_bracket 12 (q := 1.145) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP228 : (0.271682445:ℝ) ≤ vBP 1.1455 ∧ vBP 1.1455 ≤ 0.271682446 := by
  have h := vBP_bracket 12 (q := 1.1455) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP229 : (0.272555236:ℝ) ≤ vBP 1.146 ∧ vBP 1.146 ≤ 0.272555237 := by
  have h := vBP_bracket 12 (q := 1.146) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP230 : (0.273427646:ℝ) ≤ vBP 1.1465 ∧ vBP 1.1465 ≤ 0.273427647 := by
  have h := vBP_bracket 12 (q := 1.1465) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP231 : (0.274299676:ℝ) ≤ vBP 1.147 ∧ vBP 1.147 ≤ 0.274299677 := by
  have h := vBP_bracket 12 (q := 1.147) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP232 : (0.275171325:ℝ) ≤ vBP 1.1475 ∧ vBP 1.1475 ≤ 0.275171326 := by
  have h := vBP_bracket 12 (q := 1.1475) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP233 : (0.276042595:ℝ) ≤ vBP 1.148 ∧ vBP 1.148 ≤ 0.276042596 := by
  have h := vBP_bracket 12 (q := 1.148) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP234 : (0.276913486:ℝ) ≤ vBP 1.1485 ∧ vBP 1.1485 ≤ 0.276913487 := by
  have h := vBP_bracket 12 (q := 1.1485) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP235 : (0.277783997:ℝ) ≤ vBP 1.149 ∧ vBP 1.149 ≤ 0.277783998 := by
  have h := vBP_bracket 12 (q := 1.149) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP236 : (0.27865413:ℝ) ≤ vBP 1.1495 ∧ vBP 1.1495 ≤ 0.278654131 := by
  have h := vBP_bracket 12 (q := 1.1495) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP237 : (0.279523884:ℝ) ≤ vBP 1.15 ∧ vBP 1.15 ≤ 0.279523885 := by
  have h := vBP_bracket 12 (q := 1.15) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP238 : (0.28039326:ℝ) ≤ vBP 1.1505 ∧ vBP 1.1505 ≤ 0.280393261 := by
  have h := vBP_bracket 12 (q := 1.1505) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP239 : (0.281262259:ℝ) ≤ vBP 1.151 ∧ vBP 1.151 ≤ 0.28126226 := by
  have h := vBP_bracket 12 (q := 1.151) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP240 : (0.28213088:ℝ) ≤ vBP 1.1515 ∧ vBP 1.1515 ≤ 0.282130881 := by
  have h := vBP_bracket 12 (q := 1.1515) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP241 : (0.282999124:ℝ) ≤ vBP 1.152 ∧ vBP 1.152 ≤ 0.282999125 := by
  have h := vBP_bracket 12 (q := 1.152) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP242 : (0.283866991:ℝ) ≤ vBP 1.1525 ∧ vBP 1.1525 ≤ 0.283866992 := by
  have h := vBP_bracket 12 (q := 1.1525) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP243 : (0.284734482:ℝ) ≤ vBP 1.153 ∧ vBP 1.153 ≤ 0.284734483 := by
  have h := vBP_bracket 12 (q := 1.153) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP244 : (0.285601597:ℝ) ≤ vBP 1.1535 ∧ vBP 1.1535 ≤ 0.285601598 := by
  have h := vBP_bracket 12 (q := 1.1535) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP245 : (0.286468336:ℝ) ≤ vBP 1.154 ∧ vBP 1.154 ≤ 0.286468337 := by
  have h := vBP_bracket 12 (q := 1.154) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP246 : (0.287334699:ℝ) ≤ vBP 1.1545 ∧ vBP 1.1545 ≤ 0.2873347 := by
  have h := vBP_bracket 12 (q := 1.1545) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP247 : (0.288200687:ℝ) ≤ vBP 1.155 ∧ vBP 1.155 ≤ 0.288200688 := by
  have h := vBP_bracket 12 (q := 1.155) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP248 : (0.289066301:ℝ) ≤ vBP 1.1555 ∧ vBP 1.1555 ≤ 0.289066302 := by
  have h := vBP_bracket 12 (q := 1.1555) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP249 : (0.28993154:ℝ) ≤ vBP 1.156 ∧ vBP 1.156 ≤ 0.289931541 := by
  have h := vBP_bracket 12 (q := 1.156) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP250 : (0.290796405:ℝ) ≤ vBP 1.1565 ∧ vBP 1.1565 ≤ 0.290796406 := by
  have h := vBP_bracket 12 (q := 1.1565) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP251 : (0.291660896:ℝ) ≤ vBP 1.157 ∧ vBP 1.157 ≤ 0.291660897 := by
  have h := vBP_bracket 12 (q := 1.157) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP252 : (0.292525013:ℝ) ≤ vBP 1.1575 ∧ vBP 1.1575 ≤ 0.292525014 := by
  have h := vBP_bracket 12 (q := 1.1575) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP253 : (0.293388758:ℝ) ≤ vBP 1.158 ∧ vBP 1.158 ≤ 0.293388759 := by
  have h := vBP_bracket 12 (q := 1.158) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP254 : (0.294252129:ℝ) ≤ vBP 1.1585 ∧ vBP 1.1585 ≤ 0.29425213 := by
  have h := vBP_bracket 12 (q := 1.1585) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP255 : (0.295115128:ℝ) ≤ vBP 1.159 ∧ vBP 1.159 ≤ 0.295115129 := by
  have h := vBP_bracket 12 (q := 1.159) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP256 : (0.295977755:ℝ) ≤ vBP 1.1595 ∧ vBP 1.1595 ≤ 0.295977756 := by
  have h := vBP_bracket 12 (q := 1.1595) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP257 : (0.29684001:ℝ) ≤ vBP 1.16 ∧ vBP 1.16 ≤ 0.296840011 := by
  have h := vBP_bracket 12 (q := 1.16) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP258 : (0.297701893:ℝ) ≤ vBP 1.1605 ∧ vBP 1.1605 ≤ 0.297701894 := by
  have h := vBP_bracket 12 (q := 1.1605) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP259 : (0.298563405:ℝ) ≤ vBP 1.161 ∧ vBP 1.161 ≤ 0.298563406 := by
  have h := vBP_bracket 12 (q := 1.161) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP260 : (0.299424546:ℝ) ≤ vBP 1.1615 ∧ vBP 1.1615 ≤ 0.299424547 := by
  have h := vBP_bracket 12 (q := 1.1615) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP261 : (0.300285316:ℝ) ≤ vBP 1.162 ∧ vBP 1.162 ≤ 0.300285317 := by
  have h := vBP_bracket 12 (q := 1.162) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP262 : (0.301145716:ℝ) ≤ vBP 1.1625 ∧ vBP 1.1625 ≤ 0.301145717 := by
  have h := vBP_bracket 12 (q := 1.1625) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP263 : (0.302005747:ℝ) ≤ vBP 1.163 ∧ vBP 1.163 ≤ 0.302005748 := by
  have h := vBP_bracket 12 (q := 1.163) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP264 : (0.302865407:ℝ) ≤ vBP 1.1635 ∧ vBP 1.1635 ≤ 0.302865408 := by
  have h := vBP_bracket 12 (q := 1.1635) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP265 : (0.303724698:ℝ) ≤ vBP 1.164 ∧ vBP 1.164 ≤ 0.303724699 := by
  have h := vBP_bracket 12 (q := 1.164) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP266 : (0.30458362:ℝ) ≤ vBP 1.1645 ∧ vBP 1.1645 ≤ 0.304583621 := by
  have h := vBP_bracket 12 (q := 1.1645) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP267 : (0.305442174:ℝ) ≤ vBP 1.165 ∧ vBP 1.165 ≤ 0.305442175 := by
  have h := vBP_bracket 12 (q := 1.165) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP268 : (0.306300358:ℝ) ≤ vBP 1.1655 ∧ vBP 1.1655 ≤ 0.30630036 := by
  have h := vBP_bracket 12 (q := 1.1655) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP269 : (0.307158175:ℝ) ≤ vBP 1.166 ∧ vBP 1.166 ≤ 0.307158176 := by
  have h := vBP_bracket 12 (q := 1.166) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP270 : (0.308015624:ℝ) ≤ vBP 1.1665 ∧ vBP 1.1665 ≤ 0.308015625 := by
  have h := vBP_bracket 12 (q := 1.1665) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP271 : (0.308872706:ℝ) ≤ vBP 1.167 ∧ vBP 1.167 ≤ 0.308872707 := by
  have h := vBP_bracket 12 (q := 1.167) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP272 : (0.309729421:ℝ) ≤ vBP 1.1675 ∧ vBP 1.1675 ≤ 0.309729422 := by
  have h := vBP_bracket 12 (q := 1.1675) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP273 : (0.310585768:ℝ) ≤ vBP 1.168 ∧ vBP 1.168 ≤ 0.310585769 := by
  have h := vBP_bracket 12 (q := 1.168) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP274 : (0.311441749:ℝ) ≤ vBP 1.1685 ∧ vBP 1.1685 ≤ 0.311441751 := by
  have h := vBP_bracket 12 (q := 1.1685) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP275 : (0.312297364:ℝ) ≤ vBP 1.169 ∧ vBP 1.169 ≤ 0.312297366 := by
  have h := vBP_bracket 12 (q := 1.169) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP276 : (0.313152614:ℝ) ≤ vBP 1.1695 ∧ vBP 1.1695 ≤ 0.313152615 := by
  have h := vBP_bracket 12 (q := 1.1695) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP277 : (0.314007497:ℝ) ≤ vBP 1.17 ∧ vBP 1.17 ≤ 0.314007498 := by
  have h := vBP_bracket 12 (q := 1.17) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP278 : (0.314862015:ℝ) ≤ vBP 1.1705 ∧ vBP 1.1705 ≤ 0.314862016 := by
  have h := vBP_bracket 12 (q := 1.1705) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP279 : (0.315716169:ℝ) ≤ vBP 1.171 ∧ vBP 1.171 ≤ 0.31571617 := by
  have h := vBP_bracket 12 (q := 1.171) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP280 : (0.316569957:ℝ) ≤ vBP 1.1715 ∧ vBP 1.1715 ≤ 0.316569958 := by
  have h := vBP_bracket 12 (q := 1.1715) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP281 : (0.317423382:ℝ) ≤ vBP 1.172 ∧ vBP 1.172 ≤ 0.317423383 := by
  have h := vBP_bracket 12 (q := 1.172) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

end ConnesConsani.WeilPositivity
