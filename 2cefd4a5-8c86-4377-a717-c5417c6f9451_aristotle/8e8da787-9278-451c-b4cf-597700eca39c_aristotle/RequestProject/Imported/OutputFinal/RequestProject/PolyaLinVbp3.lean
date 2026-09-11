/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscLin

/-!
# Rational brackets for the breakpoints `vBP q = 2 log q` (part 3)

Each bracket comes from the logarithmic series `vBP_bracket 12`.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem vbpP282 : (0.318276442:ℝ) ≤ vBP 1.1725 ∧ vBP 1.1725 ≤ 0.318276443 := by
  have h := vBP_bracket 12 (q := 1.1725) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP283 : (0.319129139:ℝ) ≤ vBP 1.173 ∧ vBP 1.173 ≤ 0.31912914 := by
  have h := vBP_bracket 12 (q := 1.173) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP284 : (0.319981472:ℝ) ≤ vBP 1.1735 ∧ vBP 1.1735 ≤ 0.319981473 := by
  have h := vBP_bracket 12 (q := 1.1735) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP285 : (0.320833442:ℝ) ≤ vBP 1.174 ∧ vBP 1.174 ≤ 0.320833443 := by
  have h := vBP_bracket 12 (q := 1.174) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP286 : (0.32168505:ℝ) ≤ vBP 1.1745 ∧ vBP 1.1745 ≤ 0.321685051 := by
  have h := vBP_bracket 12 (q := 1.1745) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP287 : (0.322536295:ℝ) ≤ vBP 1.175 ∧ vBP 1.175 ≤ 0.322536296 := by
  have h := vBP_bracket 12 (q := 1.175) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP288 : (0.323387177:ℝ) ≤ vBP 1.1755 ∧ vBP 1.1755 ≤ 0.323387179 := by
  have h := vBP_bracket 12 (q := 1.1755) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP289 : (0.324237698:ℝ) ≤ vBP 1.176 ∧ vBP 1.176 ≤ 0.324237699 := by
  have h := vBP_bracket 12 (q := 1.176) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP290 : (0.325087858:ℝ) ≤ vBP 1.1765 ∧ vBP 1.1765 ≤ 0.325087859 := by
  have h := vBP_bracket 12 (q := 1.1765) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP291 : (0.325937656:ℝ) ≤ vBP 1.177 ∧ vBP 1.177 ≤ 0.325937657 := by
  have h := vBP_bracket 12 (q := 1.177) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP292 : (0.326787093:ℝ) ≤ vBP 1.1775 ∧ vBP 1.1775 ≤ 0.326787094 := by
  have h := vBP_bracket 12 (q := 1.1775) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP293 : (0.32763617:ℝ) ≤ vBP 1.178 ∧ vBP 1.178 ≤ 0.327636171 := by
  have h := vBP_bracket 12 (q := 1.178) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP294 : (0.328484886:ℝ) ≤ vBP 1.1785 ∧ vBP 1.1785 ≤ 0.328484887 := by
  have h := vBP_bracket 12 (q := 1.1785) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP295 : (0.329333243:ℝ) ≤ vBP 1.179 ∧ vBP 1.179 ≤ 0.329333244 := by
  have h := vBP_bracket 12 (q := 1.179) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP296 : (0.330181239:ℝ) ≤ vBP 1.1795 ∧ vBP 1.1795 ≤ 0.33018124 := by
  have h := vBP_bracket 12 (q := 1.1795) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP297 : (0.331028876:ℝ) ≤ vBP 1.18 ∧ vBP 1.18 ≤ 0.331028878 := by
  have h := vBP_bracket 12 (q := 1.18) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP298 : (0.331876155:ℝ) ≤ vBP 1.1805 ∧ vBP 1.1805 ≤ 0.331876156 := by
  have h := vBP_bracket 12 (q := 1.1805) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP299 : (0.332723074:ℝ) ≤ vBP 1.181 ∧ vBP 1.181 ≤ 0.332723075 := by
  have h := vBP_bracket 12 (q := 1.181) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP300 : (0.333569635:ℝ) ≤ vBP 1.1815 ∧ vBP 1.1815 ≤ 0.333569636 := by
  have h := vBP_bracket 12 (q := 1.1815) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP301 : (0.334415837:ℝ) ≤ vBP 1.182 ∧ vBP 1.182 ≤ 0.334415839 := by
  have h := vBP_bracket 12 (q := 1.182) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP302 : (0.335261682:ℝ) ≤ vBP 1.1825 ∧ vBP 1.1825 ≤ 0.335261683 := by
  have h := vBP_bracket 12 (q := 1.1825) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP303 : (0.336107169:ℝ) ≤ vBP 1.183 ∧ vBP 1.183 ≤ 0.336107171 := by
  have h := vBP_bracket 12 (q := 1.183) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP304 : (0.336952299:ℝ) ≤ vBP 1.1835 ∧ vBP 1.1835 ≤ 0.336952301 := by
  have h := vBP_bracket 12 (q := 1.1835) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP305 : (0.337797072:ℝ) ≤ vBP 1.184 ∧ vBP 1.184 ≤ 0.337797073 := by
  have h := vBP_bracket 12 (q := 1.184) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP306 : (0.338641489:ℝ) ≤ vBP 1.1845 ∧ vBP 1.1845 ≤ 0.33864149 := by
  have h := vBP_bracket 12 (q := 1.1845) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP307 : (0.339485549:ℝ) ≤ vBP 1.185 ∧ vBP 1.185 ≤ 0.33948555 := by
  have h := vBP_bracket 12 (q := 1.185) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP308 : (0.340329252:ℝ) ≤ vBP 1.1855 ∧ vBP 1.1855 ≤ 0.340329254 := by
  have h := vBP_bracket 12 (q := 1.1855) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP309 : (0.341172601:ℝ) ≤ vBP 1.186 ∧ vBP 1.186 ≤ 0.341172602 := by
  have h := vBP_bracket 12 (q := 1.186) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP310 : (0.342015593:ℝ) ≤ vBP 1.1865 ∧ vBP 1.1865 ≤ 0.342015594 := by
  have h := vBP_bracket 12 (q := 1.1865) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP311 : (0.342858231:ℝ) ≤ vBP 1.187 ∧ vBP 1.187 ≤ 0.342858232 := by
  have h := vBP_bracket 12 (q := 1.187) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP312 : (0.343700513:ℝ) ≤ vBP 1.1875 ∧ vBP 1.1875 ≤ 0.343700514 := by
  have h := vBP_bracket 12 (q := 1.1875) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP313 : (0.344542441:ℝ) ≤ vBP 1.188 ∧ vBP 1.188 ≤ 0.344542442 := by
  have h := vBP_bracket 12 (q := 1.188) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP314 : (0.345384015:ℝ) ≤ vBP 1.1885 ∧ vBP 1.1885 ≤ 0.345384016 := by
  have h := vBP_bracket 12 (q := 1.1885) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP315 : (0.346225235:ℝ) ≤ vBP 1.189 ∧ vBP 1.189 ≤ 0.346225236 := by
  have h := vBP_bracket 12 (q := 1.189) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP316 : (0.347066101:ℝ) ≤ vBP 1.1895 ∧ vBP 1.1895 ≤ 0.347066102 := by
  have h := vBP_bracket 12 (q := 1.1895) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP317 : (0.347906614:ℝ) ≤ vBP 1.19 ∧ vBP 1.19 ≤ 0.347906615 := by
  have h := vBP_bracket 12 (q := 1.19) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP318 : (0.348746773:ℝ) ≤ vBP 1.1905 ∧ vBP 1.1905 ≤ 0.348746774 := by
  have h := vBP_bracket 12 (q := 1.1905) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP319 : (0.34958658:ℝ) ≤ vBP 1.191 ∧ vBP 1.191 ≤ 0.349586581 := by
  have h := vBP_bracket 12 (q := 1.191) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP320 : (0.350426034:ℝ) ≤ vBP 1.1915 ∧ vBP 1.1915 ≤ 0.350426036 := by
  have h := vBP_bracket 12 (q := 1.1915) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP321 : (0.351265137:ℝ) ≤ vBP 1.192 ∧ vBP 1.192 ≤ 0.351265138 := by
  have h := vBP_bracket 12 (q := 1.192) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP322 : (0.352103887:ℝ) ≤ vBP 1.1925 ∧ vBP 1.1925 ≤ 0.352103888 := by
  have h := vBP_bracket 12 (q := 1.1925) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP323 : (0.352942286:ℝ) ≤ vBP 1.193 ∧ vBP 1.193 ≤ 0.352942287 := by
  have h := vBP_bracket 12 (q := 1.193) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP324 : (0.353780333:ℝ) ≤ vBP 1.1935 ∧ vBP 1.1935 ≤ 0.353780334 := by
  have h := vBP_bracket 12 (q := 1.1935) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP325 : (0.354618029:ℝ) ≤ vBP 1.194 ∧ vBP 1.194 ≤ 0.354618031 := by
  have h := vBP_bracket 12 (q := 1.194) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP326 : (0.35629237:ℝ) ≤ vBP 1.195 ∧ vBP 1.195 ≤ 0.356292371 := by
  have h := vBP_bracket 12 (q := 1.195) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP327 : (0.35796531:ℝ) ≤ vBP 1.196 ∧ vBP 1.196 ≤ 0.357965312 := by
  have h := vBP_bracket 12 (q := 1.196) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP328 : (0.359636852:ℝ) ≤ vBP 1.197 ∧ vBP 1.197 ≤ 0.359636854 := by
  have h := vBP_bracket 12 (q := 1.197) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP329 : (0.361306999:ℝ) ≤ vBP 1.198 ∧ vBP 1.198 ≤ 0.361307 := by
  have h := vBP_bracket 12 (q := 1.198) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP330 : (0.362975751:ℝ) ≤ vBP 1.199 ∧ vBP 1.199 ≤ 0.362975753 := by
  have h := vBP_bracket 12 (q := 1.199) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP331 : (0.364643113:ℝ) ≤ vBP 1.2 ∧ vBP 1.2 ≤ 0.364643114 := by
  have h := vBP_bracket 12 (q := 1.2) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP332 : (0.366309085:ℝ) ≤ vBP 1.201 ∧ vBP 1.201 ≤ 0.366309087 := by
  have h := vBP_bracket 12 (q := 1.201) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP333 : (0.367973672:ℝ) ≤ vBP 1.202 ∧ vBP 1.202 ≤ 0.367973673 := by
  have h := vBP_bracket 12 (q := 1.202) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP334 : (0.369636873:ℝ) ≤ vBP 1.203 ∧ vBP 1.203 ≤ 0.369636875 := by
  have h := vBP_bracket 12 (q := 1.203) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP335 : (0.371298693:ℝ) ≤ vBP 1.204 ∧ vBP 1.204 ≤ 0.371298694 := by
  have h := vBP_bracket 12 (q := 1.204) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP336 : (0.372959133:ℝ) ≤ vBP 1.205 ∧ vBP 1.205 ≤ 0.372959135 := by
  have h := vBP_bracket 12 (q := 1.205) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP337 : (0.374618196:ℝ) ≤ vBP 1.206 ∧ vBP 1.206 ≤ 0.374618197 := by
  have h := vBP_bracket 12 (q := 1.206) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP338 : (0.376275883:ℝ) ≤ vBP 1.207 ∧ vBP 1.207 ≤ 0.376275885 := by
  have h := vBP_bracket 12 (q := 1.207) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP339 : (0.377932198:ℝ) ≤ vBP 1.208 ∧ vBP 1.208 ≤ 0.3779322 := by
  have h := vBP_bracket 12 (q := 1.208) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP340 : (0.379587142:ℝ) ≤ vBP 1.209 ∧ vBP 1.209 ≤ 0.379587144 := by
  have h := vBP_bracket 12 (q := 1.209) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP341 : (0.381240718:ℝ) ≤ vBP 1.21 ∧ vBP 1.21 ≤ 0.38124072 := by
  have h := vBP_bracket 12 (q := 1.21) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP342 : (0.382892928:ℝ) ≤ vBP 1.211 ∧ vBP 1.211 ≤ 0.38289293 := by
  have h := vBP_bracket 12 (q := 1.211) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP343 : (0.384543774:ℝ) ≤ vBP 1.212 ∧ vBP 1.212 ≤ 0.384543776 := by
  have h := vBP_bracket 12 (q := 1.212) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP344 : (0.386193259:ℝ) ≤ vBP 1.213 ∧ vBP 1.213 ≤ 0.386193261 := by
  have h := vBP_bracket 12 (q := 1.213) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP345 : (0.387841384:ℝ) ≤ vBP 1.214 ∧ vBP 1.214 ≤ 0.387841386 := by
  have h := vBP_bracket 12 (q := 1.214) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP346 : (0.389488153:ℝ) ≤ vBP 1.215 ∧ vBP 1.215 ≤ 0.389488154 := by
  have h := vBP_bracket 12 (q := 1.215) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP347 : (0.391133566:ℝ) ≤ vBP 1.216 ∧ vBP 1.216 ≤ 0.391133568 := by
  have h := vBP_bracket 12 (q := 1.216) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP348 : (0.392777627:ℝ) ≤ vBP 1.217 ∧ vBP 1.217 ≤ 0.392777629 := by
  have h := vBP_bracket 12 (q := 1.217) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP349 : (0.394420338:ℝ) ≤ vBP 1.218 ∧ vBP 1.218 ≤ 0.39442034 := by
  have h := vBP_bracket 12 (q := 1.218) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP350 : (0.3960617:ℝ) ≤ vBP 1.219 ∧ vBP 1.219 ≤ 0.396061702 := by
  have h := vBP_bracket 12 (q := 1.219) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP351 : (0.397701716:ℝ) ≤ vBP 1.22 ∧ vBP 1.22 ≤ 0.397701718 := by
  have h := vBP_bracket 12 (q := 1.22) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP352 : (0.399340389:ℝ) ≤ vBP 1.221 ∧ vBP 1.221 ≤ 0.399340391 := by
  have h := vBP_bracket 12 (q := 1.221) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP353 : (0.40097772:ℝ) ≤ vBP 1.222 ∧ vBP 1.222 ≤ 0.400977723 := by
  have h := vBP_bracket 12 (q := 1.222) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP354 : (0.402613712:ℝ) ≤ vBP 1.223 ∧ vBP 1.223 ≤ 0.402613714 := by
  have h := vBP_bracket 12 (q := 1.223) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP355 : (0.404248367:ℝ) ≤ vBP 1.224 ∧ vBP 1.224 ≤ 0.404248369 := by
  have h := vBP_bracket 12 (q := 1.224) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP356 : (0.405881687:ℝ) ≤ vBP 1.225 ∧ vBP 1.225 ≤ 0.405881689 := by
  have h := vBP_bracket 12 (q := 1.225) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP357 : (0.407513674:ℝ) ≤ vBP 1.226 ∧ vBP 1.226 ≤ 0.407513676 := by
  have h := vBP_bracket 12 (q := 1.226) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP358 : (0.40914433:ℝ) ≤ vBP 1.227 ∧ vBP 1.227 ≤ 0.409144333 := by
  have h := vBP_bracket 12 (q := 1.227) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP359 : (0.410773658:ℝ) ≤ vBP 1.228 ∧ vBP 1.228 ≤ 0.410773661 := by
  have h := vBP_bracket 12 (q := 1.228) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP360 : (0.41240166:ℝ) ≤ vBP 1.229 ∧ vBP 1.229 ≤ 0.412401662 := by
  have h := vBP_bracket 12 (q := 1.229) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP361 : (0.414028337:ℝ) ≤ vBP 1.23 ∧ vBP 1.23 ≤ 0.41402834 := by
  have h := vBP_bracket 12 (q := 1.23) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP362 : (0.415653693:ℝ) ≤ vBP 1.231 ∧ vBP 1.231 ≤ 0.415653696 := by
  have h := vBP_bracket 12 (q := 1.231) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP363 : (0.417277729:ℝ) ≤ vBP 1.232 ∧ vBP 1.232 ≤ 0.417277732 := by
  have h := vBP_bracket 12 (q := 1.232) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP364 : (0.418900447:ℝ) ≤ vBP 1.233 ∧ vBP 1.233 ≤ 0.41890045 := by
  have h := vBP_bracket 12 (q := 1.233) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP365 : (0.420521849:ℝ) ≤ vBP 1.234 ∧ vBP 1.234 ≤ 0.420521852 := by
  have h := vBP_bracket 12 (q := 1.234) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP366 : (0.422141939:ℝ) ≤ vBP 1.235 ∧ vBP 1.235 ≤ 0.422141942 := by
  have h := vBP_bracket 12 (q := 1.235) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP367 : (0.423760716:ℝ) ≤ vBP 1.236 ∧ vBP 1.236 ≤ 0.42376072 := by
  have h := vBP_bracket 12 (q := 1.236) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP368 : (0.425378185:ℝ) ≤ vBP 1.237 ∧ vBP 1.237 ≤ 0.425378188 := by
  have h := vBP_bracket 12 (q := 1.237) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP369 : (0.426994347:ℝ) ≤ vBP 1.238 ∧ vBP 1.238 ≤ 0.42699435 := by
  have h := vBP_bracket 12 (q := 1.238) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP370 : (0.428609203:ℝ) ≤ vBP 1.239 ∧ vBP 1.239 ≤ 0.428609207 := by
  have h := vBP_bracket 12 (q := 1.239) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP371 : (0.430222757:ℝ) ≤ vBP 1.24 ∧ vBP 1.24 ≤ 0.430222761 := by
  have h := vBP_bracket 12 (q := 1.24) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP372 : (0.43183501:ℝ) ≤ vBP 1.241 ∧ vBP 1.241 ≤ 0.431835014 := by
  have h := vBP_bracket 12 (q := 1.241) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP373 : (0.433445965:ℝ) ≤ vBP 1.242 ∧ vBP 1.242 ≤ 0.433445969 := by
  have h := vBP_bracket 12 (q := 1.242) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP374 : (0.435055623:ℝ) ≤ vBP 1.243 ∧ vBP 1.243 ≤ 0.435055627 := by
  have h := vBP_bracket 12 (q := 1.243) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP375 : (0.436663986:ℝ) ≤ vBP 1.244 ∧ vBP 1.244 ≤ 0.436663991 := by
  have h := vBP_bracket 12 (q := 1.244) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP376 : (0.438271058:ℝ) ≤ vBP 1.245 ∧ vBP 1.245 ≤ 0.438271062 := by
  have h := vBP_bracket 12 (q := 1.245) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP377 : (0.439876838:ℝ) ≤ vBP 1.246 ∧ vBP 1.246 ≤ 0.439876843 := by
  have h := vBP_bracket 12 (q := 1.246) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP378 : (0.441481331:ℝ) ≤ vBP 1.247 ∧ vBP 1.247 ≤ 0.441481336 := by
  have h := vBP_bracket 12 (q := 1.247) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP379 : (0.443084537:ℝ) ≤ vBP 1.248 ∧ vBP 1.248 ≤ 0.443084542 := by
  have h := vBP_bracket 12 (q := 1.248) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP380 : (0.44468646:ℝ) ≤ vBP 1.249 ∧ vBP 1.249 ≤ 0.444686465 := by
  have h := vBP_bracket 12 (q := 1.249) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP381 : (0.4462871:ℝ) ≤ vBP 1.25 ∧ vBP 1.25 ≤ 0.446287105 := by
  have h := vBP_bracket 12 (q := 1.25) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP382 : (0.44788646:ℝ) ≤ vBP 1.251 ∧ vBP 1.251 ≤ 0.447886465 := by
  have h := vBP_bracket 12 (q := 1.251) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP383 : (0.449484542:ℝ) ≤ vBP 1.252 ∧ vBP 1.252 ≤ 0.449484548 := by
  have h := vBP_bracket 12 (q := 1.252) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP384 : (0.451081349:ℝ) ≤ vBP 1.253 ∧ vBP 1.253 ≤ 0.451081354 := by
  have h := vBP_bracket 12 (q := 1.253) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP385 : (0.452676881:ℝ) ≤ vBP 1.254 ∧ vBP 1.254 ≤ 0.452676887 := by
  have h := vBP_bracket 12 (q := 1.254) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP386 : (0.454271142:ℝ) ≤ vBP 1.255 ∧ vBP 1.255 ≤ 0.454271148 := by
  have h := vBP_bracket 12 (q := 1.255) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP387 : (0.455864133:ℝ) ≤ vBP 1.256 ∧ vBP 1.256 ≤ 0.455864139 := by
  have h := vBP_bracket 12 (q := 1.256) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP388 : (0.457455856:ℝ) ≤ vBP 1.257 ∧ vBP 1.257 ≤ 0.457455862 := by
  have h := vBP_bracket 12 (q := 1.257) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP389 : (0.459046313:ℝ) ≤ vBP 1.258 ∧ vBP 1.258 ≤ 0.45904632 := by
  have h := vBP_bracket 12 (q := 1.258) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP390 : (0.460635506:ℝ) ≤ vBP 1.259 ∧ vBP 1.259 ≤ 0.460635513 := by
  have h := vBP_bracket 12 (q := 1.259) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP391 : (0.462223438:ℝ) ≤ vBP 1.26 ∧ vBP 1.26 ≤ 0.462223445 := by
  have h := vBP_bracket 12 (q := 1.26) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP392 : (0.46381011:ℝ) ≤ vBP 1.261 ∧ vBP 1.261 ≤ 0.463810117 := by
  have h := vBP_bracket 12 (q := 1.261) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP393 : (0.465395524:ℝ) ≤ vBP 1.262 ∧ vBP 1.262 ≤ 0.465395532 := by
  have h := vBP_bracket 12 (q := 1.262) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP394 : (0.466979682:ℝ) ≤ vBP 1.263 ∧ vBP 1.263 ≤ 0.46697969 := by
  have h := vBP_bracket 12 (q := 1.263) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP395 : (0.468562587:ℝ) ≤ vBP 1.264 ∧ vBP 1.264 ≤ 0.468562595 := by
  have h := vBP_bracket 12 (q := 1.264) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP396 : (0.471724643:ℝ) ≤ vBP 1.266 ∧ vBP 1.266 ≤ 0.471724652 := by
  have h := vBP_bracket 12 (q := 1.266) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP397 : (0.474881707:ℝ) ≤ vBP 1.268 ∧ vBP 1.268 ≤ 0.474881716 := by
  have h := vBP_bracket 12 (q := 1.268) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP398 : (0.478033795:ℝ) ≤ vBP 1.27 ∧ vBP 1.27 ≤ 0.478033806 := by
  have h := vBP_bracket 12 (q := 1.27) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP399 : (0.481180924:ℝ) ≤ vBP 1.272 ∧ vBP 1.272 ≤ 0.481180935 := by
  have h := vBP_bracket 12 (q := 1.272) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP400 : (0.484323108:ℝ) ≤ vBP 1.274 ∧ vBP 1.274 ≤ 0.48432312 := by
  have h := vBP_bracket 12 (q := 1.274) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP401 : (0.485892351:ℝ) ≤ vBP 1.275 ∧ vBP 1.275 ≤ 0.485892363 := by
  have h := vBP_bracket 12 (q := 1.275) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP402 : (0.487460363:ℝ) ≤ vBP 1.276 ∧ vBP 1.276 ≤ 0.487460376 := by
  have h := vBP_bracket 12 (q := 1.276) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP403 : (0.490592705:ℝ) ≤ vBP 1.278 ∧ vBP 1.278 ≤ 0.490592718 := by
  have h := vBP_bracket 12 (q := 1.278) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP404 : (0.493720148:ℝ) ≤ vBP 1.28 ∧ vBP 1.28 ≤ 0.493720163 := by
  have h := vBP_bracket 12 (q := 1.28) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP405 : (0.496842709:ℝ) ≤ vBP 1.282 ∧ vBP 1.282 ≤ 0.496842724 := by
  have h := vBP_bracket 12 (q := 1.282) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP406 : (0.499960402:ℝ) ≤ vBP 1.284 ∧ vBP 1.284 ≤ 0.499960418 := by
  have h := vBP_bracket 12 (q := 1.284) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP407 : (0.503073242:ℝ) ≤ vBP 1.286 ∧ vBP 1.286 ≤ 0.50307326 := by
  have h := vBP_bracket 12 (q := 1.286) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP408 : (0.507733437:ℝ) ≤ vBP 1.289 ∧ vBP 1.289 ≤ 0.507733457 := by
  have h := vBP_bracket 12 (q := 1.289) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP409 : (0.512382799:ℝ) ≤ vBP 1.292 ∧ vBP 1.292 ≤ 0.512382821 := by
  have h := vBP_bracket 12 (q := 1.292) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP410 : (0.51547638:ℝ) ≤ vBP 1.294 ∧ vBP 1.294 ≤ 0.515476403 := by
  have h := vBP_bracket 12 (q := 1.294) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP411 : (0.518565183:ℝ) ≤ vBP 1.296 ∧ vBP 1.296 ≤ 0.518565207 := by
  have h := vBP_bracket 12 (q := 1.296) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP412 : (0.521649222:ℝ) ≤ vBP 1.298 ∧ vBP 1.298 ≤ 0.521649249 := by
  have h := vBP_bracket 12 (q := 1.298) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP413 : (0.524728514:ℝ) ≤ vBP 1.3 ∧ vBP 1.3 ≤ 0.524728542 := by
  have h := vBP_bracket 12 (q := 1.3) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP414 : (0.529338579:ℝ) ≤ vBP 1.303 ∧ vBP 1.303 ≤ 0.529338611 := by
  have h := vBP_bracket 12 (q := 1.303) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP415 : (0.536998486:ℝ) ≤ vBP 1.308 ∧ vBP 1.308 ≤ 0.536998523 := by
  have h := vBP_bracket 12 (q := 1.308) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP416 : (0.543105359:ℝ) ≤ vBP 1.312 ∧ vBP 1.312 ≤ 0.5431054 := by
  have h := vBP_bracket 12 (q := 1.312) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP417 : (0.550712819:ℝ) ≤ vBP 1.317 ∧ vBP 1.317 ≤ 0.550712868 := by
  have h := vBP_bracket 12 (q := 1.317) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP418 : (0.558291452:ℝ) ≤ vBP 1.322 ∧ vBP 1.322 ≤ 0.558291509 := by
  have h := vBP_bracket 12 (q := 1.322) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP419 : (0.564333749:ℝ) ≤ vBP 1.326 ∧ vBP 1.326 ≤ 0.564333813 := by
  have h := vBP_bracket 12 (q := 1.326) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP420 : (0.571861039:ℝ) ≤ vBP 1.331 ∧ vBP 1.331 ≤ 0.571861114 := by
  have h := vBP_bracket 12 (q := 1.331) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP421 : (0.579360103:ℝ) ≤ vBP 1.336 ∧ vBP 1.336 ≤ 0.579360191 := by
  have h := vBP_bracket 12 (q := 1.336) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP422 : (0.585339175:ℝ) ≤ vBP 1.34 ∧ vBP 1.34 ≤ 0.585339273 := by
  have h := vBP_bracket 12 (q := 1.34) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

end ConnesConsani.WeilPositivity
