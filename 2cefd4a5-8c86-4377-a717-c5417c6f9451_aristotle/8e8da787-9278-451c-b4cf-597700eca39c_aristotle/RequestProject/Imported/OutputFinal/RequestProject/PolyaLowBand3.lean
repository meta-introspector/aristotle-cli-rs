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
# Oscillatory lower bound on the band `0.8675 ≤ t ≤ 1.055`

The partition now reaches `q = 5`; on each block the phase `tv` is linearised at
the base point and the signed contributions are summed.
-/

set_option maxHeartbeats 4000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosLBL3_0 {t : ℝ} (ht0 : (0.8675:ℝ) ≤ t) (ht1 : t ≤ 1.055) :
    ((-0.058007344):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.069), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.058009336) (ylo := 0.058009336) (yhi := 0.058009336) (j := (0:ℤ))
    (c0 := 0.9983179302) (c1 := 0.9983179303) (s0 := 0.0579768071) (s1 := 0.0579768072)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.8675) (t1 := 1.055) (X0 := 0.058009336) (W := 0.0125381)
    ht0 ht1 vbpP115.1 vbpP115.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0125381) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.8675) (t1 := 1.055) (d := 0.06686956)
    (ulo := 0.9975125615) (uhi := 0.9983179303) (vlo := 0.05797225) (vhi := 0.0704934893)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP0.1, vbpP115.2]) (by linarith [vbpP160.2, vbpP115.1])
    ht0 ht1 (by norm_num) blkLo0
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL3_1 {t : ℝ} (ht0 : (0.8675:ℝ) ≤ t) (ht1 : t ≤ 1.055) :
    (0.0195239856:ℝ) ≤ ∫ v in (vBP 1.069)..(vBP 1.1455), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.176369088) (ylo := 0.176369088) (yhi := 0.176369088) (j := (0:ℤ))
    (c0 := 0.9844872467) (c1 := 0.9844872468) (s0 := 0.1754561512) (s1 := 0.1754561513)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.8675) (t1 := 1.055) (X0 := 0.176369088) (W := 0.0381202)
    ht0 ht1 vbpP183.1 vbpP183.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0381202) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.8675) (t1 := 1.055) (d := 0.06986005)
    (ulo := 0.9770852258) (uhi := 0.9844872468) (vlo := 0.1753286846) (vhi := 0.2129759136)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP160.1, vbpP183.2]) (by linarith [vbpP228.2, vbpP183.1])
    ht0 ht1 (by norm_num) blkLo1
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL3_2 {t : ℝ} (ht0 : (0.8675:ℝ) ≤ t) (ht1 : t ≤ 1.055) :
    (0.0382437035:ℝ) ≤ ∫ v in (vBP 1.1455)..(vBP 1.227), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.295235626) (ylo := 0.295235626) (yhi := 0.295235626) (j := (0:ℤ))
    (c0 := 0.9567336098) (c1 := 0.9567336099) (s0 := 0.2909652895) (s1 := 0.2909652896)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.8675) (t1 := 1.055) (X0 := 0.295235626) (W := 0.0638118)
    ht0 ht1 vbpP308.1 vbpP308.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0638118) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.8675) (t1 := 1.055) (d := 0.06881509)
    (ulo := 0.9362319661) (uhi := 0.9567336099) (vlo := 0.290373093) (vhi := 0.3519747592)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP228.1, vbpP308.2]) (by linarith [vbpP358.2, vbpP308.1])
    ht0 ht1 (by norm_num) blkLo2
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL3_3 {t : ℝ} (ht0 : (0.8675:ℝ) ≤ t) (ht1 : t ≤ 1.055) :
    (0.0152965252:ℝ) ≤ ∫ v in (vBP 1.227)..(vBP 1.312), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.41195988) (ylo := 0.41195988) (yhi := 0.41195988) (j := (0:ℤ))
    (c0 := 0.9163378354) (c1 := 0.9163378356) (s0 := 0.400406008) (s1 := 0.4004060081)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.8675) (t1 := 1.055) (X0 := 0.41195988) (W := 0.0890404)
    ht0 ht1 vbpP397.1 vbpP397.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0890404) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.8675) (t1 := 1.055) (d := 0.0682237)
    (ulo := 0.877102563) (uhi := 0.9163378356) (vlo := 0.3988198083) (vhi := 0.4818893267)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP358.1, vbpP397.2]) (by linarith [vbpP416.2, vbpP397.1])
    ht0 ht1 (by norm_num) blkLo3
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL3_4 {t : ℝ} (ht0 : (0.8675:ℝ) ≤ t) (ht1 : t ≤ 1.055) :
    ((-0.0088130389):ℝ) ≤ ∫ v in (vBP 1.312)..(vBP 1.406), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.530932529) (ylo := 0.530932529) (yhi := 0.530932529) (j := (0:ℤ))
    (c0 := 0.8623352709) (c1 := 0.8623352715) (s0 := 0.5063377138) (s1 := 0.506337714)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.8675) (t1 := 1.055) (X0 := 0.530932529) (W := 0.1147551)
    ht0 ht1 vbpP428.1 vbpP428.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1147551) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.8675) (t1 := 1.055) (d := 0.06947187)
    (ulo := 0.7986861765) (uhi := 0.8623352715) (vlo := 0.5030074577) (vhi := 0.6050780368)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP416.1, vbpP428.2]) (by linarith [vbpP449.2, vbpP428.1])
    ht0 ht1 (by norm_num) blkLo4
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL3_5 {t : ℝ} (ht0 : (0.8675:ℝ) ≤ t) (ht1 : t ≤ 1.055) :
    ((-0.0092988873):ℝ) ≤ ∫ v in (vBP 1.406)..(vBP 1.504), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.648248004) (ylo := 0.648248004) (yhi := 0.648248004) (j := (0:ℤ))
    (c0 := 0.7971428603) (c1 := 0.797142864) (s0 := 0.603790742) (s1 := 0.6037907423)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.8675) (t1 := 1.055) (X0 := 0.648248004) (W := 0.1401129)
    ht0 ht1 vbpP469.1 vbpP469.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1401129) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.8675) (t1 := 1.055) (d := 0.06899838)
    (ulo := 0.7050087067) (uhi := 0.797142864) (vlo := 0.5978737349) (vhi := 0.7151156566)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP449.1, vbpP469.2]) (by linarith [vbpP488.2, vbpP469.1])
    ht0 ht1 (by norm_num) blkLo5
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL3_6 {t : ℝ} (ht0 : (0.8675:ℝ) ≤ t) (ht1 : t ≤ 1.055) :
    (0.0004258926:ℝ) ≤ ∫ v in (vBP 1.504)..(vBP 1.61), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.769299481) (ylo := 0.769299481) (yhi := 0.769299481) (j := (0:ℤ))
    (c0 := 0.7183981492) (c1 := 0.7183981694) (s0 := 0.6956321577) (s1 := 0.6956321592)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.8675) (t1 := 1.055) (X0 := 0.769299481) (W := 0.1662856)
    ht0 ht1 vbpP502.1 vbpP502.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1662856) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.8675) (t1 := 1.055) (d := 0.07055622)
    (ulo := 0.5933475687) (uhi := 0.7183981694) (vlo := 0.6860368702) (vhi := 0.8145416644)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP488.1, vbpP502.2]) (by linarith [vbpP515.2, vbpP502.1])
    ht0 ht1 (by norm_num) blkLo6
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL3_7 {t : ℝ} (ht0 : (0.8675:ℝ) ≤ t) (ht1 : t ≤ 1.055) :
    ((-0.0013584347):ℝ) ≤ ∫ v in (vBP 1.61)..(vBP 1.719), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.883484074) (ylo := 0.883484074) (yhi := 0.883484074) (j := (0:ℤ))
    (c0 := 0.6344619707) (c1 := 0.6344620507) (s0 := 0.7729540782) (s1 := 0.7729540847)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.8675) (t1 := 1.055) (X0 := 0.883484074) (W := 0.1910005)
    ht0 ht1 vbpP523.1 vbpP523.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1910005) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.8675) (t1 := 1.055) (d := 0.06601185)
    (ulo := 0.4761855419) (uhi := 0.6344620507) (vlo := 0.7588977462) (vhi := 0.8934011824)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP515.1, vbpP523.2]) (by linarith [vbpP530.2, vbpP523.1])
    ht0 ht1 (by norm_num) blkLo7
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL3_8 {t : ℝ} (ht0 : (0.8675:ℝ) ≤ t) (ht1 : t ≤ 1.055) :
    ((-0.0018517142):ℝ) ≤ ∫ v in (vBP 1.719)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.994497426) (ylo := 0.994497426) (yhi := 0.994497426) (j := (0:ℤ))
    (c0 := 0.5449243572) (c1 := 0.544924618) (s0 := 0.8384852071) (s1 := 0.8384852307)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.8675) (t1 := 1.055) (X0 := 0.994497426) (W := 0.2151045)
    ht0 ht1 vbpP537.1 vbpP537.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.2151045) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.8675) (t1 := 1.055) (d := 0.06310085)
    (ulo := 0.3533918107) (uhi := 0.544924618) (vlo := 0.8191615558) (vhi := 0.9547991295)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP530.1, vbpP537.2]) (by linarith [vbpP543.2, vbpP537.1])
    ht0 ht1 (by norm_num) blkLo8
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL3_9 {t : ℝ} (ht0 : (0.8675:ℝ) ≤ t) (ht1 : t ≤ 1.055) :
    ((-0.0003610305):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.954), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.1042639) (ylo := 1.1042639) (yhi := 1.1042639) (j := (0:ℤ))
    (c0 := 0.4497919836) (c1 := 0.4497927267) (s0 := 0.8931333406) (s1 := 0.8931334153)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.8675) (t1 := 1.055) (X0 := 1.1042639) (W := 0.2391203)
    ht0 ht1 vbpP547.1 vbpP547.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.2391203) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.8675) (t1 := 1.055) (d := 0.06715513)
    (ulo := 0.2254570135) (uhi := 0.4497927267) (vlo := 0.867720755) (vhi := 0.9996659449)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP543.1, vbpP547.2]) (by linarith [vbpP551.2, vbpP547.1])
    ht0 ht1 (by norm_num) blkLo9
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL3_10 {t : ℝ} (ht0 : (0.8675:ℝ) ≤ t) (ht1 : t ≤ 1.055) :
    ((-0.0011727556):ℝ) ≤ ∫ v in (vBP 1.954)..(vBP 2.078), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.215927886) (ylo := 1.215927886) (yhi := 1.215927886) (j := (0:ℤ))
    (c0 := 0.3474669845) (c1 := 0.3474689314) (s0 := 0.9376922073) (s1 := 0.9376924226)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.8675) (t1 := 1.055) (X0 := 1.215927886) (W := 0.2639596)
    ht0 ht1 vbpP555.1 vbpP555.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.2639596) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.8675) (t1 := 1.055) (d := 0.06335508)
    (ulo := 0.0907835978) (uhi := 0.3474689314) (vlo := 0.9052147397) (vhi := 1.0283488196)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP551.1, vbpP555.2]) (by linarith [vbpP559.2, vbpP555.1])
    ht0 ht1 (by norm_num) blkLo10
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL3_11 {t : ℝ} (ht0 : (0.8675:ℝ) ≤ t) (ht1 : t ≤ 1.055) :
    ((-0.0001682648):ℝ) ≤ ∫ v in (vBP 2.078)..(vBP 2.17945), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.304711305) (ylo := 1.304711305) (yhi := 1.304711305) (j := (0:ℤ))
    (c0 := 0.2629562098) (c1 := 0.2629601489) (s0 := 0.9648077505) (s1 := 0.9648082178)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.8675) (t1 := 1.055) (X0 := 1.304711305) (W := 0.282174)
    ht0 ht1 vbpT1.1 vbpT1.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.282174) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.8675) (t1 := 1.055) (d := 0.05422059)
    (ulo := (-0.0160884612)) (uhi := 0.2629601489) (vlo := 0.926651891) (vhi := 1.0380279799)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP559.1, vbpT1.2]) (by linarith [vbpT3.2, vbpT1.1])
    ht0 ht1 (by norm_num) blkLo11
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL3_12 {t : ℝ} (ht0 : (0.8675:ℝ) ≤ t) (ht1 : t ≤ 1.055) :
    ((-0.0002688476):ℝ) ≤ ∫ v in (vBP 2.17945)..(vBP 2.2912884), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.396134648) (ylo := 1.396134648) (yhi := 1.396134648) (j := (0:ℤ))
    (c0 := 0.1737748604) (c1 := 0.1737826143) (s0 := 0.9847853748) (s1 := 0.984786359)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.8675) (t1 := 1.055) (X0 := 1.396134648) (W := 0.3018794)
    ht0 ht1 vbpT4.1 vbpT4.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.3018794) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.8675) (t1 := 1.055) (d := 0.05141957)
    (ulo := (-0.1268752401)) (uhi := 0.1737826143) (vlo := 0.9402527908) (vhi := 1.0364545619)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT3.1, vbpT4.2]) (by linarith [vbpT7.2, vbpT4.1])
    ht0 ht1 (by norm_num) blkLo12
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL3_13 {t : ℝ} (ht0 : (0.8675:ℝ) ≤ t) (ht1 : t ≤ 1.055) :
    ((-0.0003909347):ℝ) ≤ ∫ v in (vBP 2.2912884)..(vBP 2.4494903), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.478806018) (ylo := 1.478806018) (yhi := 1.478806018) (j := (0:ℤ))
    (c0 := 0.0918603977) (c1 := 0.0918741809) (s0 := 0.9957718487) (s1 := 0.9957737017)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.8675) (t1 := 1.055) (X0 := 1.478806018) (W := 0.3197738)
    ht0 ht1 vbpT9.1 vbpT9.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.3197738) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.8675) (t1 := 1.055) (d := 0.08716116)
    (ulo := (-0.2258196138)) (uhi := 0.0918741809) (vlo := 0.945292737) (vhi := 1.0246545192)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT7.1, vbpT9.2]) (by linarith [vbpT13.2, vbpT9.1])
    ht0 ht1 (by norm_num) blkLo13
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL3_14 {t : ℝ} (ht0 : (0.8675:ℝ) ≤ t) (ht1 : t ≤ 1.055) :
    ((-0.0004110358):ℝ) ≤ ∫ v in (vBP 2.4494903)..(vBP 2.5980768), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 1.589705231) (ylo := 0.018908904205) (yhi := 0.018908904206) (j := (0:ℤ))
    (c0 := (-0.0189077775)) (c1 := (-0.0189077774)) (s0 := 0.9998212319) (s1 := 0.999821232)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.8675) (t1 := 1.055) (X0 := 1.589705231) (W := 0.3437351)
    ht0 ht1 vbpT15.1 vbpT15.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.3437351) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.8675) (t1 := 1.055) (d := 0.07709944)
    (ulo := (-0.3558535723)) (uhi := (-0.0178017194)) (vlo := 0.9349621387) (vhi := 0.999821232)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT13.1, vbpT15.2]) (by linarith [vbpT19.2, vbpT15.1])
    ht0 ht1 (by norm_num) blkLo14
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL3_15 {t : ℝ} (ht0 : (0.8675:ℝ) ≤ t) (ht1 : t ≤ 1.055) :
    ((-0.0004568096):ℝ) ≤ ∫ v in (vBP 2.5980768)..(vBP 2.7838827), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 1.718448095) (ylo := 0.147651768205) (yhi := 0.147651768206) (j := (0:ℤ))
    (c0 := (-0.147115859)) (c1 := (-0.1471158589)) (s0 := 0.9891192668) (s1 := 0.9891192669)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.8675) (t1 := 1.055) (X0 := 1.718448095) (W := 0.3715872)
    ht0 ht1 vbpT22.1 vbpT22.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.3715872) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.8675) (t1 := 1.055) (d := 0.07160879)
    (ulo := (-0.5062598876)) (uhi := (-0.1370755274)) (vlo := 0.8681970698) (vhi := 0.9891192669)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT19.1, vbpT22.2]) (by linarith [vbpT27.2, vbpT22.1])
    ht0 ht1 (by norm_num) blkLo15
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL3_16 {t : ℝ} (ht0 : (0.8675:ℝ) ≤ t) (ht1 : t ≤ 1.055) :
    ((-0.0003874644):ℝ) ≤ ∫ v in (vBP 2.7838827)..(vBP 2.9580404), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 1.830533659) (ylo := 0.259737332205) (yhi := 0.259737332206) (j := (0:ℤ))
    (c0 := (-0.2568267036)) (c1 := (-0.2568267035)) (s0 := 0.9664574715) (s1 := 0.9664574716)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.8675) (t1 := 1.055) (X0 := 1.830533659) (W := 0.3958269)
    ht0 ht1 vbpT30.1 vbpT30.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.3958269) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.8675) (t1 := 1.055) (d := 0.06268613)
    (ulo := (-0.629464951)) (uhi := (-0.2369683622)) (vlo := 0.7927040945) (vhi := 0.9664574716)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT27.1, vbpT30.2]) (by linarith [vbpT35.2, vbpT30.1])
    ht0 ht1 (by norm_num) blkLo16
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL3_17 {t : ℝ} (ht0 : (0.8675:ℝ) ≤ t) (ht1 : t ≤ 1.055) :
    ((-0.0003619086):ℝ) ≤ ∫ v in (vBP 2.9580404)..(vBP 3.1622782), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 1.929783866) (ylo := 0.358987539205) (yhi := 0.358987539206) (j := (0:ℤ))
    (c0 := (-0.3513264941)) (c1 := (-0.351326494)) (s0 := 0.9362530077) (s1 := 0.9362530078)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.8675) (t1 := 1.055) (X0 := 1.929783866) (W := 0.4172824)
    ht0 ht1 vbpT39.1 vbpT39.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.4172824) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.8675) (t1 := 1.055) (d := 0.07811905)
    (ulo := (-0.7307688099)) (uhi := (-0.3211804664)) (vlo := 0.7135318612) (vhi := 0.9362530078)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT35.1, vbpT39.2]) (by linarith [vbpT45.2, vbpT39.1])
    ht0 ht1 (by norm_num) blkLo17
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL3_18 {t : ℝ} (ht0 : (0.8675:ℝ) ≤ t) (ht1 : t ≤ 1.055) :
    ((-0.0002866225):ℝ) ≤ ∫ v in (vBP 3.1622782)..(vBP 3.3541025), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.039756054) (ylo := 0.468959727205) (yhi := 0.468959727206) (j := (0:ℤ))
    (c0 := (-0.4519585663)) (c1 := (-0.4519585662)) (s0 := 0.8920389309) (s1 := 0.8920389312)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.8675) (t1 := 1.055) (X0 := 2.039756054) (W := 0.4410165)
    ht0 ht1 vbpT49.1 vbpT49.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.4410165) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.8675) (t1 := 1.055) (d := 0.06914293)
    (ulo := (-0.8327333455)) (uhi := (-0.4087143698)) (vlo := 0.6137645179) (vhi := 0.8920389312)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT45.1, vbpT49.2]) (by linarith [vbpT55.2, vbpT49.1])
    ht0 ht1 (by norm_num) blkLo18
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL3_19 {t : ℝ} (ht0 : (0.8675:ℝ) ≤ t) (ht1 : t ≤ 1.055) :
    ((-0.0003490436):ℝ) ≤ ∫ v in (vBP 3.3541025)..(vBP 3.5707148), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.155575111) (ylo := 0.584778784205) (yhi := 0.584778784206) (j := (0:ℤ))
    (c0 := (-0.5520149387)) (c1 := (-0.5520149385)) (s0 := 0.8338342207) (s1 := 0.833834222)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.8675) (t1 := 1.055) (X0 := 2.155575111) (W := 0.4660944)
    ht0 ht1 vbpT60.1 vbpT60.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.4660944) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.8675) (t1 := 1.055) (d := 0.0647093)
    (ulo := (-0.9267406477)) (uhi := (-0.4931316576)) (vlo := 0.4968134379) (vhi := 0.833834222)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT55.1, vbpT60.2]) (by linarith [vbpT67.2, vbpT60.1])
    ht0 ht1 (by norm_num) blkLo19
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL3_20 {t : ℝ} (ht0 : (0.8675:ℝ) ≤ t) (ht1 : t ≤ 1.055) :
    ((-0.0002437173):ℝ) ≤ ∫ v in (vBP 3.5707148)..(vBP 3.8078871), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.25776298) (ylo := 0.686966653205) (yhi := 0.686966653206) (j := (0:ℤ))
    (c0 := (-0.6341948012)) (c1 := (-0.6341948007)) (s0 := 0.7731733018) (s1 := 0.7731733083)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.8675) (t1 := 1.055) (X0 := 2.25776298) (W := 0.4881565)
    ht0 ht1 vbpT73.1 vbpT73.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.4881565) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.8675) (t1 := 1.055) (d := 0.0716348)
    (ulo := (-0.9968119299)) (uhi := (-0.5601201869)) (vlo := 0.3854294381) (vhi := 0.7731733083)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT67.1, vbpT73.2]) (by linarith [vbpT81.2, vbpT73.1])
    ht0 ht1 (by norm_num) blkLo20
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL3_21 {t : ℝ} (ht0 : (0.8675:ℝ) ≤ t) (ht1 : t ≤ 1.055) :
    ((-0.0002243756):ℝ) ≤ ∫ v in (vBP 3.8078871)..(vBP 4.0620198), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.377602352) (ylo := 0.806806025205) (yhi := 0.806806025206) (j := (0:ℤ))
    (c0 := (-0.7220812455)) (c1 := (-0.722081243)) (s0 := 0.6918082668) (s1 := 0.6918082991)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.8675) (t1 := 1.055) (X0 := 2.377602352) (W := 0.5140719)
    ht0 ht1 vbpT88.1 vbpT88.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.5140719) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.8675) (t1 := 1.055) (d := 0.06687385)
    (ulo := (-1.0622620086)) (uhi := (-0.6287518589)) (vlo := 0.2473248953) (vhi := 0.6918082991)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT81.1, vbpT88.2]) (by linarith [vbpT97.2, vbpT88.1])
    ht0 ht1 (by norm_num) blkLo21
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL3_22 {t : ℝ} (ht0 : (0.8675:ℝ) ≤ t) (ht1 : t ≤ 1.055) :
    ((-0.0001937256):ℝ) ≤ ∫ v in (vBP 4.0620198)..(vBP 4.3301276), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.48288233) (ylo := 0.912086003205) (yhi := 0.912086003206) (j := (0:ℤ))
    (c0 := (-0.7907823057)) (c1 := (-0.7907822965)) (s0 := 0.6120975073) (s1 := 0.6120976172)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.8675) (t1 := 1.055) (X0 := 2.48288233) (W := 0.5368297)
    ht0 ht1 vbpT105.1 vbpT105.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.5368297) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.8675) (t1 := 1.055) (d := 0.0691632)
    (ulo := (-1.1038177304)) (uhi := (-0.6795463778)) (vlo := 0.1215790885) (vhi := 0.6120976172)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT97.1, vbpT105.2]) (by linarith [vbpT115.2, vbpT105.1])
    ht0 ht1 (by norm_num) blkLo22
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL3_23 {t : ℝ} (ht0 : (0.8675:ℝ) ≤ t) (ht1 : t ≤ 1.055) :
    ((-0.000148646):ℝ) ≤ ∫ v in (vBP 4.3301276)..(vBP 4.6368098), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.598728405) (ylo := 1.027932078205) (yhi := 1.027932078206) (j := (0:ℤ))
    (c0 := (-0.8562325855)) (c1 := (-0.8562325515)) (s0 := 0.5165905673) (s1 := 0.5165909304)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.8675) (t1 := 1.055) (X0 := 2.598728405) (W := 0.5618507)
    ht0 ht1 vbpT125.1 vbpT125.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.5618507) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.8675) (t1 := 1.055) (d := 0.07247932)
    (ulo := (-1.1314481097)) (uhi := (-0.7246044302)) (vlo := (-0.0189853312)) (vhi := 0.5165909304)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT115.1, vbpT125.2]) (by linarith [vbpT137.2, vbpT125.1])
    ht0 ht1 (by norm_num) blkLo23
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL3_24 {t : ℝ} (ht0 : (0.8675:ℝ) ≤ t) (ht1 : t ≤ 1.055) :
    ((-0.0001188526):ℝ) ≤ ∫ v in (vBP 4.6368098)..(vBP 4.949748), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.71997019) (ylo := 1.149173863205) (yhi := 1.149173863206) (j := (0:ℤ))
    (c0 := (-0.912426277)) (c1 := (-0.9124261613)) (s0 := 0.4092413582) (s1 := 0.4092424652)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.8675) (t1 := 1.055) (X0 := 2.71997019) (W := 0.588059)
    ht0 ht1 vbpT148.1 vbpT148.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.588059) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.8675) (t1 := 1.055) (d := 0.06760111)
    (ulo := (-1.139452356)) (uhi := (-0.7591559113)) (vlo := (-0.1656692599)) (vhi := 0.4092424652)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT137.1, vbpT148.2]) (by linarith [vbpT161.2, vbpT148.1])
    ht0 ht1 (by norm_num) blkLo24
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL3_25 {t : ℝ} (ht0 : (0.8675:ℝ) ≤ t) (ht1 : t ≤ 1.055) :
    ((-0.000016053):ℝ) ≤ ∫ v in (vBP 4.949748)..(vBP 5), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.783580738) (ylo := 1.212784411205) (yhi := 1.212784411206) (j := (0:ℤ))
    (c0 := (-0.9365955318)) (c1 := (-0.9365953226)) (s0 := 0.3504128754) (s1 := 0.3504147725)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.8675) (t1 := 1.055) (X0 := 2.783580738) (W := 0.6018181)
    ht0 ht1 vbpT162.1 vbpT162.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.6018181) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.8675) (t1 := 1.055) (d := 0.01033663)
    (ulo := (-1.1349800808)) (uhi := (-0.7720427127)) (vlo := (-0.241398122)) (vhi := 0.3504147725)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT161.1, vbpT162.2]) (by linarith [vbpT165.2, vbpT162.1])
    ht0 ht1 (by norm_num) blkLo25
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

/-- Lower bound for `∫₀^∞ err(v) cos(tv) dv` on the band `0.8675 ≤ t ≤ 1.055`. -/
theorem oscLowBand3 {t : ℝ} (ht0 : (0.8675:ℝ) ≤ t) (ht1 : t ≤ 1.055) :
    ((-0.0135994):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosLBL3_0 ht0 ht1)
    (cosLBL3_1 ht0 ht1))
    (cosLBL3_2 ht0 ht1))
    (cosLBL3_3 ht0 ht1))
    (cosLBL3_4 ht0 ht1))
    (cosLBL3_5 ht0 ht1))
    (cosLBL3_6 ht0 ht1))
    (cosLBL3_7 ht0 ht1))
    (cosLBL3_8 ht0 ht1))
    (cosLBL3_9 ht0 ht1))
    (cosLBL3_10 ht0 ht1))
    (cosLBL3_11 ht0 ht1))
    (cosLBL3_12 ht0 ht1))
    (cosLBL3_13 ht0 ht1))
    (cosLBL3_14 ht0 ht1))
    (cosLBL3_15 ht0 ht1))
    (cosLBL3_16 ht0 ht1))
    (cosLBL3_17 ht0 ht1))
    (cosLBL3_18 ht0 ht1))
    (cosLBL3_19 ht0 ht1))
    (cosLBL3_20 ht0 ht1))
    (cosLBL3_21 ht0 ht1))
    (cosLBL3_22 ht0 ht1))
    (cosLBL3_23 ht0 ht1))
    (cosLBL3_24 ht0 ht1))
    (cosLBL3_25 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 5) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 5) (S := 0.0022)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_five
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
