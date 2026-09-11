/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLowTail
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLowBlocks1
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLowBlocks2
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLowBlocks3
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLowBlocks4

/-!
# Oscillatory lower bound on the band `0.68 ≤ t ≤ 0.8675`

The partition now reaches `q = 5`; on each block the phase `tv` is linearised at
the base point and the signed contributions are summed.
-/

set_option maxHeartbeats 4000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosLBL2_0 {t : ℝ} (ht0 : (0.68:ℝ) ≤ t) (ht1 : t ≤ 0.8675) :
    ((-0.0579670578):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.069), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.045471295) (ylo := 0.045471295) (yhi := 0.045471295) (j := (0:ℤ))
    (c0 := 0.9989663587) (c1 := 0.9989663588) (s0 := 0.0454556269) (s1 := 0.045455627)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.68) (t1 := 0.8675) (X0 := 0.045471295) (W := 0.0125381)
    ht0 ht1 vbpP115.1 vbpP115.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0125381) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.68) (t1 := 0.8675) (d := 0.06686956)
    (ulo := 0.9983179267) (uhi := 0.9989663588) (vlo := 0.045452054) (vhi := 0.057980439)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP0.1, vbpP115.2]) (by linarith [vbpP160.2, vbpP115.1])
    ht0 ht1 (by norm_num) blkLo0
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL2_1 {t : ℝ} (ht0 : (0.68:ℝ) ≤ t) (ht1 : t ≤ 0.8675) :
    (0.0197397498:ℝ) ≤ ∫ v in (vBP 1.069)..(vBP 1.1455), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.138248968) (ylo := 0.138248968) (yhi := 0.138248968) (j := (0:ℤ))
    (c0 := 0.9904588224) (c1 := 0.9904588225) (s0 := 0.1378090017) (s1 := 0.1378090018)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.68) (t1 := 0.8675) (X0 := 0.138248968) (W := 0.0381202)
    ht0 ht1 vbpP183.1 vbpP183.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0381202) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.68) (t1 := 0.8675) (d := 0.06986005)
    (ulo := 0.9844872326) (uhi := 0.9904588225) (vlo := 0.1377088852) (vhi := 0.1755563466)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP160.1, vbpP183.2]) (by linarith [vbpP228.2, vbpP183.1])
    ht0 ht1 (by norm_num) blkLo1
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL2_2 {t : ℝ} (ht0 : (0.68:ℝ) ≤ t) (ht1 : t ≤ 0.8675) :
    (0.0391155468:ℝ) ≤ ∫ v in (vBP 1.1455)..(vBP 1.227), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.231423891) (ylo := 0.231423891) (yhi := 0.231423891) (j := (0:ℤ))
    (c0 := 0.9733407929) (c1 := 0.973340793) (s0 := 0.2293636867) (s1 := 0.2293636868)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.68) (t1 := 0.8675) (X0 := 0.231423891) (W := 0.0638118)
    ht0 ht1 vbpP308.1 vbpP308.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0638118) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.68) (t1 := 0.8675) (d := 0.06881509)
    (ulo := 0.9567335909) (uhi := 0.973340793) (vlo := 0.2288968668) (vhi := 0.2914321716)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP228.1, vbpP308.2]) (by linarith [vbpP358.2, vbpP308.1])
    ht0 ht1 (by norm_num) blkLo2
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL2_3 {t : ℝ} (ht0 : (0.68:ℝ) ≤ t) (ht1 : t ≤ 0.8675) :
    (0.0159590995:ℝ) ≤ ∫ v in (vBP 1.227)..(vBP 1.312), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.32291956) (ylo := 0.32291956) (yhi := 0.32291956) (j := (0:ℤ))
    (c0 := 0.9483129778) (c1 := 0.9483129779) (s0 := 0.3173365657) (s1 := 0.3173365658)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.68) (t1 := 0.8675) (X0 := 0.32291956) (W := 0.0890404)
    ht0 ht1 vbpP397.1 vbpP397.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0890404) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.68) (t1 := 0.8675) (d := 0.0682237)
    (ulo := 0.9163378033) (uhi := 0.9483129779) (vlo := 0.3160794438) (vhi := 0.4016632033)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP358.1, vbpP397.2]) (by linarith [vbpP416.2, vbpP397.1])
    ht0 ht1 (by norm_num) blkLo3
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL2_4 {t : ℝ} (ht0 : (0.68:ℝ) ≤ t) (ht1 : t ≤ 0.8675) :
    ((-0.0093636456):ℝ) ≤ ∫ v in (vBP 1.312)..(vBP 1.406), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.41617766) (ylo := 0.41617766) (yhi := 0.41617766) (j := (0:ℤ))
    (c0 := 0.9146408653) (c1 := 0.9146408655) (s0 := 0.4042673464) (s1 := 0.4042673465)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.68) (t1 := 0.8675) (X0 := 0.41617766) (W := 0.1147551)
    ht0 ht1 vbpP428.1 vbpP428.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1147551) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.68) (t1 := 0.8675) (d := 0.06947187)
    (ulo := 0.8623351538) (uhi := 0.9146408655) (vlo := 0.4016084218) (vhi := 0.5089968378)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP416.1, vbpP428.2]) (by linarith [vbpP449.2, vbpP428.1])
    ht0 ht1 (by norm_num) blkLo4
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL2_5 {t : ℝ} (ht0 : (0.68:ℝ) ≤ t) (ht1 : t ≤ 0.8675) :
    ((-0.0101258663):ℝ) ≤ ∫ v in (vBP 1.406)..(vBP 1.504), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.508136764) (ylo := 0.508136764) (yhi := 0.508136764) (j := (0:ℤ))
    (c0 := 0.8736525816) (c1 := 0.873652582) (s0 := 0.4865502714) (s1 := 0.4865502715)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.68) (t1 := 0.8675) (X0 := 0.508136764) (W := 0.1401126)
    ht0 ht1 vbpP469.1 vbpP469.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1401126) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.68) (t1 := 0.8675) (d := 0.06899838)
    (ulo := 0.7971420392) (uhi := 0.873652582) (vlo := 0.4817822136) (vhi := 0.608559884)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP449.1, vbpP469.2]) (by linarith [vbpP488.2, vbpP469.1])
    ht0 ht1 (by norm_num) blkLo5
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL2_6 {t : ℝ} (ht0 : (0.68:ℝ) ≤ t) (ht1 : t ≤ 0.8675) :
    (0.0005673483:ℝ) ≤ ∫ v in (vBP 1.504)..(vBP 1.61), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.603024377) (ylo := 0.603024377) (yhi := 0.603024377) (j := (0:ℤ))
    (c0 := 0.8236241511) (c1 := 0.823624153) (s0 := 0.5671360132) (s1 := 0.5671360134)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.68) (t1 := 0.8675) (X0 := 0.603024377) (W := 0.1662838)
    ht0 ht1 vbpP502.1 vbpP502.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1662838) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.68) (t1 := 0.8675) (d := 0.07055622)
    (ulo := 0.7183921) (uhi := 0.823624153) (vlo := 0.559313322) (vhi := 0.7034610966)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP488.1, vbpP502.2]) (by linarith [vbpP515.2, vbpP502.1])
    ht0 ht1 (by norm_num) blkLo6
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL2_7 {t : ℝ} (ht0 : (0.68:ℝ) ≤ t) (ht1 : t ≤ 0.8675) :
    ((-0.0016488201):ℝ) ≤ ∫ v in (vBP 1.61)..(vBP 1.719), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.692529303) (ylo := 0.692529303) (yhi := 0.692529303) (j := (0:ℤ))
    (c0 := 0.7696335543) (c1 := 0.7696335614) (s0 := 0.6384858589) (s1 := 0.6384858594)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.68) (t1 := 0.8675) (X0 := 0.692529303) (W := 0.1909924)
    ht0 ht1 vbpP523.1 vbpP523.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1909924) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.68) (t1 := 0.8675) (d := 0.06601185)
    (ulo := 0.6344328851) (uhi := 0.7696335614) (vlo := 0.6268758414) (vhi := 0.7845879712)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP515.1, vbpP523.2]) (by linarith [vbpP530.2, vbpP523.1])
    ht0 ht1 (by norm_num) blkLo7
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL2_8 {t : ℝ} (ht0 : (0.68:ℝ) ≤ t) (ht1 : t ≤ 0.8675) :
    ((-0.0022632837):ℝ) ≤ ∫ v in (vBP 1.719)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.779548415) (ylo := 0.779548415) (yhi := 0.779548415) (j := (0:ℤ))
    (c0 := 0.7112310558) (c1 := 0.7112310787) (s0 := 0.7029583096) (s1 := 0.7029583113)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.68) (t1 := 0.8675) (X0 := 0.779548415) (W := 0.2150769)
    ht0 ht1 vbpP537.1 vbpP537.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.2150769) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.68) (t1 := 0.8675) (d := 0.06310085)
    (ulo := 0.5448171211) (uhi := 0.7112310787) (vlo := 0.6867621395) (vhi := 0.8547510669)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP530.1, vbpP537.2]) (by linarith [vbpP543.2, vbpP537.1])
    ht0 ht1 (by norm_num) blkLo8
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL2_9 {t : ℝ} (ht0 : (0.68:ℝ) ≤ t) (ht1 : t ≤ 0.8675) :
    ((-0.0003408655):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.954), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.865590147) (ylo := 0.865590147) (yhi := 0.865590147) (j := (0:ℤ))
    (c0 := 0.6481908443) (c1 := 0.6481909094) (s0 := 0.761477924) (s1 := 0.7614779292)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.68) (t1 := 0.8675) (X0 := 0.865590147) (W := 0.239041)
    ht0 ht1 vbpP547.1 vbpP547.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.239041) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.68) (t1 := 0.8675) (d := 0.06715513)
    (ulo := 0.449463958) (uhi := 0.6481909094) (vlo := 0.7398256685) (vhi := 0.9149507417)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP543.1, vbpP547.2]) (by linarith [vbpP551.2, vbpP547.1])
    ht0 ht1 (by norm_num) blkLo9
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL2_10 {t : ℝ} (ht0 : (0.68:ℝ) ≤ t) (ht1 : t ≤ 0.8675) :
    ((-0.0014214977):ℝ) ≤ ∫ v in (vBP 1.954)..(vBP 2.078), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.953119265) (ylo := 0.953119265) (yhi := 0.953119265) (j := (0:ℤ))
    (c0 := 0.579143004) (c1 := 0.5791431746) (s0 := 0.8152259682) (s1 := 0.8152259831)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.68) (t1 := 0.8675) (X0 := 0.953119265) (W := 0.263755)
    ht0 ht1 vbpP555.1 vbpP555.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.263755) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.68) (t1 := 0.8675) (d := 0.06335508)
    (ulo := 0.3465794334) (uhi := 0.5791431746) (vlo := 0.787033685) (vhi := 0.966212967)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP551.1, vbpP555.2]) (by linarith [vbpP559.2, vbpP555.1])
    ht0 ht1 (by norm_num) blkLo10
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL2_11 {t : ℝ} (ht0 : (0.68:ℝ) ≤ t) (ht1 : t ≤ 0.8675) :
    ((-0.0000854506):ℝ) ≤ ∫ v in (vBP 2.078)..(vBP 2.17945), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.022713184) (ylo := 1.022713184) (yhi := 1.022713184) (j := (0:ℤ))
    (c0 := 0.5210520991) (c1 := 0.5210524442) (s0 := 0.8535248717) (s1 := 0.8535249039)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.68) (t1 := 0.8675) (X0 := 1.022713184) (W := 0.2821427)
    ht0 ht1 vbpT1.1 vbpT1.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.2821427) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.68) (t1 := 0.8675) (d := 0.05422059)
    (ulo := 0.2628167549) (uhi := 0.5210524442) (vlo := 0.8197774246) (vhi := 0.9985933378)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP559.1, vbpT1.2]) (by linarith [vbpT3.2, vbpT1.1])
    ht0 ht1 (by norm_num) blkLo11
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL2_12 {t : ℝ} (ht0 : (0.68:ℝ) ≤ t) (ht1 : t ≤ 0.8675) :
    ((-0.000616504):ℝ) ≤ ∫ v in (vBP 2.17945)..(vBP 2.2912884), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.094376438) (ylo := 1.094376438) (yhi := 1.094376438) (j := (0:ℤ))
    (c0 := 0.4586006763) (c1 := 0.4586013555) (s0 := 0.8886424551) (s1 := 0.8886425228)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.68) (t1 := 0.8675) (X0 := 1.094376438) (W := 0.3018579)
    ht0 ht1 vbpT4.1 vbpT4.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.3018579) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.68) (t1 := 0.8675) (d := 0.05141957)
    (ulo := 0.1736767737) (uhi := 0.4586013555) (vlo := 0.8484631917) (vhi := 1.0249822364)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT3.1, vbpT4.2]) (by linarith [vbpT7.2, vbpT4.1])
    ht0 ht1 (by norm_num) blkLo12
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL2_13 {t : ℝ} (ht0 : (0.68:ℝ) ≤ t) (ht1 : t ≤ 0.8675) :
    ((-0.0002306117):ℝ) ≤ ∫ v in (vBP 2.2912884)..(vBP 2.4494903), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.159179357) (ylo := 1.159179357) (yhi := 1.159179357) (j := (0:ℤ))
    (c0 := 0.4000917507) (c1 := 0.4000929579) (s0 := 0.9164750838) (s1 := 0.9164752111)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.68) (t1 := 0.8675) (X0 := 1.159179357) (W := 0.3197477)
    ht0 ht1 vbpT9.1 vbpT9.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.3197477) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.68) (t1 := 0.8675) (d := 0.08716116)
    (ulo := 0.0917400441) (uhi := 0.4000929579) (vlo := 0.8700233178) (vhi := 1.0422352537)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT7.1, vbpT9.2]) (by linarith [vbpT13.2, vbpT9.1])
    ht0 ht1 (by norm_num) blkLo13
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL2_14 {t : ℝ} (ht0 : (0.68:ℝ) ≤ t) (ht1 : t ≤ 0.8675) :
    ((-0.0001608771):ℝ) ≤ ∫ v in (vBP 2.4494903)..(vBP 2.5980768), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.246108999) (ylo := 1.246108999) (yhi := 1.246108999) (j := (0:ℤ))
    (c0 := 0.3190124371) (c1 := 0.3190149249) (s0 := 0.9477505162) (s1 := 0.9477507982)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.68) (t1 := 0.8675) (X0 := 1.246108999) (W := 0.3437105)
    ht0 ht1 vbpT15.1 vbpT15.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.3437105) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.68) (t1 := 0.8675) (d := 0.07709944)
    (ulo := (-0.0190221464)) (uhi := 0.3190149249) (vlo := 0.8923173227) (vhi := 1.0552533663)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT13.1, vbpT15.2]) (by linarith [vbpT19.2, vbpT15.1])
    ht0 ht1 (by norm_num) blkLo14
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL2_15 {t : ℝ} (ht0 : (0.68:ℝ) ≤ t) (ht1 : t ≤ 0.8675) :
    ((-0.0001749976):ℝ) ≤ ∫ v in (vBP 2.5980768)..(vBP 2.7838827), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.347025596) (ylo := 1.347025596) (yhi := 1.347025596) (j := (0:ℤ))
    (c0 := 0.2219078357) (c1 := 0.2219132557) (s0 := 0.9750676206) (s1 := 0.9750682844)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.68) (t1 := 0.8675) (X0 := 1.347025596) (W := 0.371558)
    ht0 ht1 vbpT22.1 vbpT22.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.371558) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.68) (t1 := 0.8675) (d := 0.07160879)
    (ulo := (-0.1472501912)) (uhi := 0.2219132557) (vlo := 0.9085317533) (vhi := 1.0556377884)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT19.1, vbpT22.2]) (by linarith [vbpT27.2, vbpT22.1])
    ht0 ht1 (by norm_num) blkLo15
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL2_16 {t : ℝ} (ht0 : (0.68:ℝ) ≤ t) (ht1 : t ≤ 0.8675) :
    ((-0.0001821922):ℝ) ≤ ∫ v in (vBP 2.7838827)..(vBP 2.9580404), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.434885174) (ylo := 1.434885174) (yhi := 1.434885174) (j := (0:ℤ))
    (c0 := 0.1354929602) (c1 := 0.1355031558) (s0 := 0.9907782701) (s1 := 0.9907796002)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.68) (t1 := 0.8675) (X0 := 1.434885174) (W := 0.3957952)
    ht0 ht1 vbpT30.1 vbpT30.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.3957952) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.68) (t1 := 0.8675) (d := 0.06268613)
    (ulo := (-0.2569691458)) (uhi := 0.1355031558) (vlo := 0.9141814726) (vhi := 1.0430217625)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT27.1, vbpT30.2]) (by linarith [vbpT35.2, vbpT30.1])
    ht0 ht1 (by norm_num) blkLo16
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL2_17 {t : ℝ} (ht0 : (0.68:ℝ) ≤ t) (ht1 : t ≤ 0.8675) :
    ((-0.0001923891):ℝ) ≤ ∫ v in (vBP 2.9580404)..(vBP 3.1622782), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.512683606) (ylo := 1.512683606) (yhi := 1.512683606) (j := (0:ℤ))
    (c0 := 0.0580797217) (c1 := 0.0580970087) (s0 := 0.9983118964) (s1 := 0.9983142738)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.68) (t1 := 0.8675) (X0 := 1.512683606) (W := 0.41725)
    ht0 ht1 vbpT39.1 vbpT39.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.41725) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.68) (t1 := 0.8675) (d := 0.07811905)
    (ulo := (-0.3514679047)) (uhi := 0.0580970087) (vlo := 0.9126635516) (vhi := 1.0218579658)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT35.1, vbpT39.2]) (by linarith [vbpT45.2, vbpT39.1])
    ht0 ht1 (by norm_num) blkLo17
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL2_18 {t : ℝ} (ht0 : (0.68:ℝ) ≤ t) (ht1 : t ≤ 0.8675) :
    ((-0.000165773):ℝ) ≤ ∫ v in (vBP 3.1622782)..(vBP 3.3541025), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 1.59888659) (ylo := 0.028090263205) (yhi := 0.028090263206) (j := (0:ℤ))
    (c0 := (-0.0280865692)) (c1 := (-0.0280865691)) (s0 := 0.9996054944) (s1 := 0.9996054945)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.68) (t1 := 0.8675) (X0 := 1.59888659) (W := 0.4409904)
    ht0 ht1 vbpT49.1 vbpT49.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.4409904) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.68) (t1 := 0.8675) (d := 0.06914293)
    (ulo := (-0.4547535024)) (uhi := (-0.0253995093)) (vlo := 0.8919842663) (vhi := 0.9996054945)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT45.1, vbpT49.2]) (by linarith [vbpT55.2, vbpT49.1])
    ht0 ht1 (by norm_num) blkLo18
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL2_19 {t : ℝ} (ht0 : (0.68:ℝ) ≤ t) (ht1 : t ≤ 0.8675) :
    ((-0.0002214058):ℝ) ≤ ∫ v in (vBP 3.3541025)..(vBP 3.5707148), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 1.68967271) (ylo := 0.118876383205) (yhi := 0.118876383206) (j := (0:ℤ))
    (c0 := (-0.1185965955)) (c1 := (-0.1185965954)) (s0 := 0.9929425197) (s1 := 0.9929425198)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.68) (t1 := 0.8675) (X0 := 1.68967271) (W := 0.4660603)
    ht0 ht1 vbpT60.1 vbpT60.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.4660603) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.68) (t1 := 0.8675) (d := 0.0647093)
    (ulo := (-0.564795442)) (uhi := (-0.1059477467)) (vlo := 0.8337470476) (vhi := 0.9929425198)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT55.1, vbpT60.2]) (by linarith [vbpT67.2, vbpT60.1])
    ht0 ht1 (by norm_num) blkLo19
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL2_20 {t : ℝ} (ht0 : (0.68:ℝ) ≤ t) (ht1 : t ≤ 0.8675) :
    ((-0.0001694861):ℝ) ≤ ∫ v in (vBP 3.5707148)..(vBP 3.8078871), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 1.769773863) (ylo := 0.198977536205) (yhi := 0.198977536206) (j := (0:ℤ))
    (c0 := (-0.1976671446)) (c1 := (-0.1976671445)) (s0 := 0.9802691977) (s1 := 0.9802691978)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.68) (t1 := 0.8675) (X0 := 1.769773863) (W := 0.4881268)
    ht0 ht1 vbpT73.1 vbpT73.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.4881268) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.68) (t1 := 0.8675) (d := 0.0716348)
    (ulo := (-0.657386223)) (uhi := (-0.1745821692)) (vlo := 0.7730859766) (vhi := 0.9802691978)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT67.1, vbpT73.2]) (by linarith [vbpT81.2, vbpT73.1])
    ht0 ht1 (by norm_num) blkLo20
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL2_21 {t : ℝ} (ht0 : (0.68:ℝ) ≤ t) (ht1 : t ≤ 0.8675) :
    ((-0.0001675238):ℝ) ≤ ∫ v in (vBP 3.8078871)..(vBP 4.0620198), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 1.863711353) (ylo := 0.292915026205) (yhi := 0.292915026206) (j := (0:ℤ))
    (c0 := (-0.2887443123)) (c1 := (-0.2887443122)) (s0 := 0.9574062471) (s1 := 0.9574062472)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.68) (t1 := 0.8675) (X0 := 1.863711353) (W := 0.5140397)
    ht0 ht1 vbpT88.1 vbpT88.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.5140397) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.68) (t1 := 0.8675) (d := 0.06687385)
    (ulo := (-0.7594998918)) (uhi := (-0.2514285282)) (vlo := 0.691700885) (vhi := 0.9574062472)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT81.1, vbpT88.2]) (by linarith [vbpT97.2, vbpT88.1])
    ht0 ht1 (by norm_num) blkLo21
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL2_22 {t : ℝ} (ht0 : (0.68:ℝ) ≤ t) (ht1 : t ≤ 0.8675) :
    ((-0.0001548774):ℝ) ≤ ∫ v in (vBP 4.0620198)..(vBP 4.3301276), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 1.946236293) (ylo := 0.375439966205) (yhi := 0.375439966206) (j := (0:ℤ))
    (c0 := (-0.3666818856)) (c1 := (-0.3666818855)) (s0 := 0.9303463843) (s1 := 0.9303463844)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.68) (t1 := 0.8675) (X0 := 1.946236293) (W := 0.5367971)
    ht0 ht1 vbpT105.1 vbpT105.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.5367971) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.68) (t1 := 0.8675) (d := 0.0691632)
    (ulo := (-0.8424481917)) (uhi := (-0.3151084469)) (vlo := 0.611978043) (vhi := 0.9303463844)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT97.1, vbpT105.2]) (by linarith [vbpT115.2, vbpT105.1])
    ht0 ht1 (by norm_num) blkLo22
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL2_23 {t : ℝ} (ht0 : (0.68:ℝ) ≤ t) (ht1 : t ≤ 0.8675) :
    ((-0.0001283675):ℝ) ≤ ∫ v in (vBP 4.3301276)..(vBP 4.6368098), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.037043591) (ylo := 0.466247264205) (yhi := 0.466247264206) (j := (0:ℤ))
    (c0 := (-0.4495372841)) (c1 := (-0.449537284)) (s0 := 0.8932615687) (s1 := 0.893261569)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.68) (t1 := 0.8675) (X0 := 2.037043591) (W := 0.5618212)
    ht0 ht1 vbpT125.1 vbpT125.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.5618212) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.68) (t1 := 0.8675) (d := 0.07247932)
    (ulo := (-0.9254030345)) (uhi := (-0.3804372493)) (vlo := 0.5164737871) (vhi := 0.893261569)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT115.1, vbpT125.2]) (by linarith [vbpT137.2, vbpT125.1])
    ht0 ht1 (by norm_num) blkLo23
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL2_24 {t : ℝ} (ht0 : (0.68:ℝ) ≤ t) (ht1 : t ≤ 0.8675) :
    ((-0.0001105755):ℝ) ≤ ∫ v in (vBP 4.6368098)..(vBP 4.949748), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.132080379) (ylo := 0.561284052205) (yhi := 0.561284052206) (j := (0:ℤ))
    (c0 := (-0.5322736796)) (c1 := (-0.5322736795)) (s0 := 0.8465723419) (s1 := 0.8465723428)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.68) (t1 := 0.8675) (X0 := 2.132080379) (W := 0.588029)
    ht0 ht1 vbpT148.1 vbpT148.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.588029) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.68) (t1 := 0.8675) (d := 0.06760111)
    (ulo := (-1.0018861176)) (uhi := (-0.4428706779)) (vlo := 0.4091143655) (vhi := 0.8465723428)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT137.1, vbpT148.2]) (by linarith [vbpT161.2, vbpT148.1])
    ht0 ht1 (by norm_num) blkLo24
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL2_25 {t : ℝ} (ht0 : (0.68:ℝ) ≤ t) (ht1 : t ≤ 0.8675) :
    ((-0.0000156239):ℝ) ≤ ∫ v in (vBP 4.949748)..(vBP 5), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.18194225) (ylo := 0.611145923205) (yhi := 0.611145923206) (j := (0:ℤ))
    (c0 := (-0.5738063376)) (c1 := (-0.5738063374)) (s0 := 0.8189910177) (s1 := 0.8189910198)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.68) (t1 := 0.8675) (X0 := 2.18194225) (W := 0.6017862)
    ht0 ht1 vbpT162.1 vbpT162.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.6017862) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.68) (t1 := 0.8675) (d := 0.01033663)
    (ulo := (-1.0374500829)) (uhi := (-0.4730033305)) (vlo := 0.350274546) (vhi := 0.8189910198)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT161.1, vbpT162.2]) (by linarith [vbpT165.2, vbpT162.1])
    ht0 ht1 (by norm_num) blkLo25
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

/-- Lower bound for `∫₀^∞ err(v) cos(tv) dv` on the band `0.68 ≤ t ≤ 0.8675`. -/
theorem oscLowBand2 {t : ℝ} (ht0 : (0.68:ℝ) ≤ t) (ht1 : t ≤ 0.8675) :
    ((-0.0127259476):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosLBL2_0 ht0 ht1)
    (cosLBL2_1 ht0 ht1))
    (cosLBL2_2 ht0 ht1))
    (cosLBL2_3 ht0 ht1))
    (cosLBL2_4 ht0 ht1))
    (cosLBL2_5 ht0 ht1))
    (cosLBL2_6 ht0 ht1))
    (cosLBL2_7 ht0 ht1))
    (cosLBL2_8 ht0 ht1))
    (cosLBL2_9 ht0 ht1))
    (cosLBL2_10 ht0 ht1))
    (cosLBL2_11 ht0 ht1))
    (cosLBL2_12 ht0 ht1))
    (cosLBL2_13 ht0 ht1))
    (cosLBL2_14 ht0 ht1))
    (cosLBL2_15 ht0 ht1))
    (cosLBL2_16 ht0 ht1))
    (cosLBL2_17 ht0 ht1))
    (cosLBL2_18 ht0 ht1))
    (cosLBL2_19 ht0 ht1))
    (cosLBL2_20 ht0 ht1))
    (cosLBL2_21 ht0 ht1))
    (cosLBL2_22 ht0 ht1))
    (cosLBL2_23 ht0 ht1))
    (cosLBL2_24 ht0 ht1))
    (cosLBL2_25 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 5) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 5) (S := 0.0022)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_five
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
