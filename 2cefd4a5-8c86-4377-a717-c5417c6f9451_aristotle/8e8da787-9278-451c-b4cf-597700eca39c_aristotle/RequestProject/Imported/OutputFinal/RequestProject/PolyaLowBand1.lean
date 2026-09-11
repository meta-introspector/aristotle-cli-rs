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
# Oscillatory lower bound on the band `0.43 ≤ t ≤ 0.68`

The partition now reaches `q = 5`; on each block the phase `tv` is linearised at
the base point and the signed contributions are summed.
-/

set_option maxHeartbeats 4000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosLBL1_0 {t : ℝ} (ht0 : (0.43:ℝ) ≤ t) (ht1 : t ≤ 0.68) :
    ((-0.0579405437):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.069), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.028753907) (ylo := 0.028753907) (yhi := 0.028753907) (j := (0:ℤ))
    (c0 := 0.9995866348) (c1 := 0.9995866349) (s0 := 0.0287499449) (s1 := 0.028749945)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.43) (t1 := 0.68) (X0 := 0.028753907) (W := 0.0167174)
    ht0 ht1 vbpP115.1 vbpP115.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0167174) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.43) (t1 := 0.68) (d := 0.06686956)
    (ulo := 0.9989663581) (uhi := 0.9995866349) (vlo := 0.0287459275) (vhi := 0.0454596563)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP0.1, vbpP115.2]) (by linarith [vbpP160.2, vbpP115.1])
    ht0 ht1 (by norm_num) blkLo0
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL1_1 {t : ℝ} (ht0 : (0.43:ℝ) ≤ t) (ht1 : t ≤ 0.68) :
    (0.0199137313:ℝ) ≤ ∫ v in (vBP 1.069)..(vBP 1.1455), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.087422142) (ylo := 0.087422142) (yhi := 0.087422142) (j := (0:ℤ))
    (c0 := 0.9961811176) (c1 := 0.9961811177) (s0 := 0.0873108286) (s1 := 0.0873108287)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.43) (t1 := 0.68) (X0 := 0.087422142) (W := 0.0508269)
    ht0 ht1 vbpP183.1 vbpP183.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0508269) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.43) (t1 := 0.68) (d := 0.06986005)
    (ulo := 0.9904588122) (uhi := 0.9961811177) (vlo := 0.0871980746) (vhi := 0.137921829)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP160.1, vbpP183.2]) (by linarith [vbpP228.2, vbpP183.1])
    ht0 ht1 (by norm_num) blkLo1
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL1_2 {t : ℝ} (ht0 : (0.43:ℝ) ≤ t) (ht1 : t ≤ 0.68) :
    (0.0398206003:ℝ) ≤ ∫ v in (vBP 1.1455)..(vBP 1.227), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.146341578) (ylo := 0.146341578) (yhi := 0.146341578) (j := (0:ℤ))
    (c0 := 0.9893111675) (c1 := 0.9893111676) (s0 := 0.1458197986) (s1 := 0.1458197987)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.43) (t1 := 0.68) (X0 := 0.146341578) (W := 0.0850824)
    ht0 ht1 vbpP308.1 vbpP308.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0850824) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.43) (t1 := 0.68) (d := 0.06881509)
    (ulo := 0.9733407728) (uhi := 0.9893111676) (vlo := 0.145292321) (vhi := 0.2298912491)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP228.1, vbpP308.2]) (by linarith [vbpP358.2, vbpP308.1])
    ht0 ht1 (by norm_num) blkLo2
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL1_3 {t : ℝ} (ht0 : (0.43:ℝ) ≤ t) (ht1 : t ≤ 0.68) :
    (0.016492723:ℝ) ≤ ∫ v in (vBP 1.227)..(vBP 1.312), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.204199134) (ylo := 0.204199134) (yhi := 0.204199134) (j := (0:ℤ))
    (c0 := 0.9792237005) (c1 := 0.9792237006) (s0 := 0.202782998) (s1 := 0.2027829981)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.43) (t1 := 0.68) (X0 := 0.204199134) (W := 0.1187205)
    ht0 ht1 vbpP397.1 vbpP397.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1187205) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.43) (t1 := 0.68) (d := 0.0682237)
    (ulo := 0.9483129543) (uhi := 0.9792237006) (vlo := 0.2013556074) (vhi := 0.3187640266)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP358.1, vbpP397.2]) (by linarith [vbpP416.2, vbpP397.1])
    ht0 ht1 (by norm_num) blkLo3
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL1_4 {t : ℝ} (ht0 : (0.43:ℝ) ≤ t) (ht1 : t ≤ 0.68) :
    ((-0.0099019183):ℝ) ≤ ∫ v in (vBP 1.312)..(vBP 1.406), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.263171167) (ylo := 0.263171167) (yhi := 0.263171167) (j := (0:ℤ))
    (c0 := 0.9655698749) (c1 := 0.965569875) (s0 := 0.2601438381) (s1 := 0.2601438382)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.43) (t1 := 0.68) (X0 := 0.263171167) (W := 0.1530067)
    ht0 ht1 vbpP428.1 vbpP428.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1530067) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.43) (t1 := 0.68) (d := 0.06947187)
    (ulo := 0.9146407815) (uhi := 0.965569875) (vlo := 0.257104654) (vhi := 0.40730672)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP416.1, vbpP428.2]) (by linarith [vbpP449.2, vbpP428.1])
    ht0 ht1 (by norm_num) blkLo4
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL1_5 {t : ℝ} (ht0 : (0.43:ℝ) ≤ t) (ht1 : t ≤ 0.68) :
    ((-0.0109452966):ℝ) ≤ ∫ v in (vBP 1.406)..(vBP 1.504), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.321321777) (ylo := 0.321321777) (yhi := 0.321321777) (j := (0:ℤ))
    (c0 := 0.9488188021) (c1 := 0.9488188022) (s0 := 0.315820963) (s1 := 0.3158209631)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.43) (t1 := 0.68) (X0 := 0.321321777) (W := 0.1868161)
    ht0 ht1 vbpP469.1 vbpP469.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1868161) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.43) (t1 := 0.68) (d := 0.06899838)
    (ulo := 0.87365204) (uhi := 0.9488188022) (vlo := 0.3103258565) (vhi := 0.4920463504)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP449.1, vbpP469.2]) (by linarith [vbpP488.2, vbpP469.1])
    ht0 ht1 (by norm_num) blkLo5
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL1_6 {t : ℝ} (ht0 : (0.43:ℝ) ≤ t) (ht1 : t ≤ 0.68) :
    (0.0006872205:ℝ) ≤ ∫ v in (vBP 1.504)..(vBP 1.61), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.381324238) (ylo := 0.381324238) (yhi := 0.381324238) (j := (0:ℤ))
    (c0 := 0.9281726344) (c1 := 0.9281726346) (s0 := 0.3721499168) (s1 := 0.3721499169)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.43) (t1 := 0.68) (X0 := 0.381324238) (W := 0.221707)
    ht0 ht1 vbpP502.1 vbpP502.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.221707) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.43) (t1 := 0.68) (d := 0.07055622)
    (ulo := 0.8236202599) (uhi := 0.9281726346) (vlo := 0.3630409929) (vhi := 0.5762505881)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP488.1, vbpP502.2]) (by linarith [vbpP515.2, vbpP502.1])
    ht0 ht1 (by norm_num) blkLo6
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL1_7 {t : ℝ} (ht0 : (0.43:ℝ) ≤ t) (ht1 : t ≤ 0.68) :
    ((-0.0019417532):ℝ) ≤ ∫ v in (vBP 1.61)..(vBP 1.719), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.437922941) (ylo := 0.437922941) (yhi := 0.437922941) (j := (0:ℤ))
    (c0 := 0.9056344123) (c1 := 0.9056344125) (s0 := 0.424059325) (s1 := 0.4240593251)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.43) (t1 := 0.68) (X0 := 0.437922941) (W := 0.2546359)
    ht0 ht1 vbpP523.1 vbpP523.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.2546359) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.43) (t1 := 0.68) (d := 0.06601185)
    (ulo := 0.7696146943) (uhi := 0.9056344125) (vlo := 0.4103855634) (vhi := 0.6521823537)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP515.1, vbpP523.2]) (by linarith [vbpP530.2, vbpP523.1])
    ht0 ht1 (by norm_num) blkLo7
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL1_8 {t : ℝ} (ht0 : (0.43:ℝ) ≤ t) (ht1 : t ≤ 0.68) :
    ((-0.0026892259):ℝ) ≤ ∫ v in (vBP 1.719)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.492949733) (ylo := 0.492949733) (yhi := 0.492949733) (j := (0:ℤ))
    (c0 := 0.8809408013) (c1 := 0.8809408016) (s0 := 0.4732264833) (s1 := 0.4732264834)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.43) (t1 := 0.68) (X0 := 0.492949733) (W := 0.2866989)
    ht0 ht1 vbpP537.1 vbpP537.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.2866989) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.43) (t1 := 0.68) (d := 0.06310085)
    (ulo := 0.7111606032) (uhi := 0.8809408016) (vlo := 0.4539106131) (vhi := 0.7223454546)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP530.1, vbpP537.2]) (by linarith [vbpP543.2, vbpP537.1])
    ht0 ht1 (by norm_num) blkLo8
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL1_9 {t : ℝ} (ht0 : (0.43:ℝ) ≤ t) (ht1 : t ≤ 0.68) :
    ((-0.0003234691):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.954), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.547358475) (ylo := 0.547358475) (yhi := 0.547358475) (j := (0:ℤ))
    (c0 := 0.8539022375) (c1 := 0.8539022382) (s0 := 0.5204334431) (s1 := 0.5204334432)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.43) (t1 := 0.68) (X0 := 0.547358475) (W := 0.3185195)
    ht0 ht1 vbpP547.1 vbpP547.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.3185195) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.43) (t1 := 0.68) (d := 0.06715513)
    (ulo := 0.6479716431) (uhi := 0.8539022382) (vlo := 0.4942556895) (vhi := 0.7878422139)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP543.1, vbpP547.2]) (by linarith [vbpP551.2, vbpP547.1])
    ht0 ht1 (by norm_num) blkLo9
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL1_10 {t : ℝ} (ht0 : (0.43:ℝ) ≤ t) (ht1 : t ≤ 0.68) :
    ((-0.0016848136):ℝ) ≤ ∫ v in (vBP 1.954)..(vBP 2.078), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.60270777) (ylo := 0.60270777) (yhi := 0.60270777) (j := (0:ℤ))
    (c0 := 0.8238036691) (c1 := 0.8238036709) (s0 := 0.5668752196) (s1 := 0.5668752198)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.43) (t1 := 0.68) (X0 := 0.60270777) (W := 0.3511534)
    ht0 ht1 vbpP555.1 vbpP555.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.3511534) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.43) (t1 := 0.68) (d := 0.06335508)
    (ulo := 0.5785380256) (uhi := 0.8238036709) (vlo := 0.5322825605) (vhi := 0.8502480729)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP551.1, vbpP555.2]) (by linarith [vbpP559.2, vbpP555.1])
    ht0 ht1 (by norm_num) blkLo10
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL1_11 {t : ℝ} (ht0 : (0.43:ℝ) ≤ t) (ht1 : t ≤ 0.68) :
    ((-0.0000258571):ℝ) ≤ ∫ v in (vBP 2.078)..(vBP 2.17945), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.64671569) (ylo := 0.64671569) (yhi := 0.64671569) (j := (0:ℤ))
    (c0 := 0.7980671211) (c1 := 0.7980671248) (s0 := 0.6025685604) (s1 := 0.6025685607)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.43) (t1 := 0.68) (X0 := 0.64671569) (W := 0.3761109)
    ht0 ht1 vbpT1.1 vbpT1.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.3761109) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.43) (t1 := 0.68) (d := 0.05422059)
    (ulo := 0.5209553035) (uhi := 0.7980671248) (vlo := 0.5604491118) (vhi := 0.8957034071)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP559.1, vbpT1.2]) (by linarith [vbpT3.2, vbpT1.1])
    ht0 ht1 (by norm_num) blkLo11
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL1_12 {t : ℝ} (ht0 : (0.43:ℝ) ≤ t) (ht1 : t ≤ 0.68) :
    ((-0.000995521):ℝ) ≤ ∫ v in (vBP 2.17945)..(vBP 2.2912884), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.692032159) (ylo := 0.692032159) (yhi := 0.692032159) (j := (0:ℤ))
    (c0 := 0.7699508786) (c1 := 0.7699508856) (s0 := 0.6381031613) (s1 := 0.6381031618)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.43) (t1 := 0.68) (X0 := 0.692032159) (W := 0.4024224)
    ht0 ht1 vbpT4.1 vbpT4.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.4024224) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.43) (t1 := 0.68) (d := 0.05141957)
    (ulo := 0.4585312592) (uhi := 0.7699508856) (vlo := 0.5871282682) (vhi := 0.9396531756)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT3.1, vbpT4.2]) (by linarith [vbpT7.2, vbpT4.1])
    ht0 ht1 (by norm_num) blkLo12
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL1_13 {t : ℝ} (ht0 : (0.43:ℝ) ≤ t) (ht1 : t ≤ 0.68) :
    ((-0.0003646795):ℝ) ≤ ∫ v in (vBP 2.2912884)..(vBP 2.4494903), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.733010476) (ylo := 0.733010476) (yhi := 0.733010476) (j := (0:ℤ))
    (c0 := 0.7431634335) (c1 := 0.7431634459) (s0 := 0.6691099393) (s1 := 0.6691099402)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.43) (t1 := 0.68) (X0 := 0.733010476) (W := 0.4262638)
    ht0 ht1 vbpT9.1 vbpT9.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.4262638) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.43) (t1 := 0.68) (d := 0.08716116)
    (ulo := 0.4000047697) (uhi := 0.7431634459) (vlo := 0.6092359174) (vhi := 0.9763870849)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT7.1, vbpT9.2]) (by linarith [vbpT13.2, vbpT9.1])
    ht0 ht1 (by norm_num) blkLo13
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL1_14 {t : ℝ} (ht0 : (0.43:ℝ) ≤ t) (ht1 : t ≤ 0.68) :
    ((-0.0002624097):ℝ) ≤ ∫ v in (vBP 2.4494903)..(vBP 2.5980768), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.787980691) (ylo := 0.787980691) (yhi := 0.787980691) (j := (0:ℤ))
    (c0 := 0.7052783023) (c1 := 0.7052783278) (s0 := 0.7089305439) (s1 := 0.7089305458)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.43) (t1 := 0.68) (X0 := 0.787980691) (W := 0.4582179)
    ht0 ht1 vbpT15.1 vbpT15.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.4582179) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.43) (t1 := 0.68) (d := 0.07709944)
    (ulo := 0.3189275531) (uhi := 0.7052783278) (vlo := 0.6357988528) (vhi := 1.0209108004)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT13.1, vbpT15.2]) (by linarith [vbpT19.2, vbpT15.1])
    ht0 ht1 (by norm_num) blkLo14
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL1_15 {t : ℝ} (ht0 : (0.43:ℝ) ≤ t) (ht1 : t ≤ 0.68) :
    ((-0.0002910843):ℝ) ≤ ∫ v in (vBP 2.5980768)..(vBP 2.7838827), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.851795597) (ylo := 0.851795597) (yhi := 0.851795597) (j := (0:ℤ))
    (c0 := 0.6586330855) (c1 := 0.658633141) (s0 := 0.7524642571) (s1 := 0.7524642615)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.43) (t1 := 0.68) (X0 := 0.851795597) (W := 0.4953362)
    ht0 ht1 vbpT22.1 vbpT22.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.4953362) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.43) (t1 := 0.68) (d := 0.07160879)
    (ulo := 0.2218043527) (uhi := 0.658633141) (vlo := 0.6620247913) (vhi := 1.0655306861)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT19.1, vbpT22.2]) (by linarith [vbpT27.2, vbpT22.1])
    ht0 ht1 (by norm_num) blkLo15
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL1_16 {t : ℝ} (ht0 : (0.43:ℝ) ≤ t) (ht1 : t ≤ 0.68) :
    ((-0.0001775128):ℝ) ≤ ∫ v in (vBP 2.7838827)..(vBP 2.9580404), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.90735386) (ylo := 0.90735386) (yhi := 0.90735386) (j := (0:ℤ))
    (c0 := 0.615832735) (c1 := 0.6158328394) (s0 := 0.7878769202) (s1 := 0.7878769289)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.43) (t1 := 0.68) (X0 := 0.90735386) (W := 0.5276463)
    ht0 ht1 vbpT30.1 vbpT30.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.5276463) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.43) (t1 := 0.68) (d := 0.06268613)
    (ulo := 0.135379186) (uhi := 0.6158328394) (vlo := 0.6807213677) (vhi := 1.0979494741)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT27.1, vbpT30.2]) (by linarith [vbpT35.2, vbpT30.1])
    ht0 ht1 (by norm_num) blkLo16
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL1_17 {t : ℝ} (ht0 : (0.43:ℝ) ≤ t) (ht1 : t ≤ 0.68) :
    ((-0.0001639093):ℝ) ≤ ∫ v in (vBP 2.9580404)..(vBP 3.1622782), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.956549927) (ylo := 0.956549927) (yhi := 0.956549927) (j := (0:ℤ))
    (c0 := 0.5763428366) (c1 := 0.5763430134) (s0 := 0.8172080109) (s1 := 0.8172080263)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.43) (t1 := 0.68) (X0 := 0.956549927) (W := 0.5562511)
    ht0 ht1 vbpT39.1 vbpT39.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.5562511) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.43) (t1 := 0.68) (d := 0.07811905)
    (ulo := 0.0579627853) (uhi := 0.5763430134) (vlo := 0.6940061532) (vhi := 1.1215207096)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT35.1, vbpT39.2]) (by linarith [vbpT45.2, vbpT39.1])
    ht0 ht1 (by norm_num) blkLo17
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL1_18 {t : ℝ} (ht0 : (0.43:ℝ) ≤ t) (ht1 : t ≤ 0.68) :
    ((-0.0000983604):ℝ) ≤ ∫ v in (vBP 3.1622782)..(vBP 3.3541025), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.011060637) (ylo := 1.011060637) (yhi := 1.011060637) (j := (0:ℤ))
    (c0 := 0.5309622388) (c1 := 0.5309625465) (s0 := 0.8473954791) (s1 := 0.8473955075)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.43) (t1 := 0.68) (X0 := 1.011060637) (W := 0.5879208)
    ht0 ht1 vbpT49.1 vbpT49.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.5879208) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.43) (t1 := 0.68) (d := 0.06914293)
    (ulo := (-0.0281813964)) (uhi := 0.5309625465) (vlo := 0.7051141072) (vhi := 1.1418843955)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT45.1, vbpT49.2]) (by linarith [vbpT55.2, vbpT49.1])
    ht0 ht1 (by norm_num) blkLo18
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL1_19 {t : ℝ} (ht0 : (0.43:ℝ) ≤ t) (ht1 : t ≤ 0.68) :
    ((-0.0000628457):ℝ) ≤ ∫ v in (vBP 3.3541025)..(vBP 3.5707148), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.068469507) (ylo := 1.068469507) (yhi := 1.068469507) (j := (0:ℤ))
    (c0 := 0.4814662108) (c1 := 0.4814667453) (s0 := 0.87646465) (s1 := 0.876464702)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.43) (t1 := 0.68) (X0 := 1.068469507) (W := 0.621327)
    ht0 ht1 vbpT60.1 vbpT60.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.621327) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.43) (t1 := 0.68) (d := 0.0647093)
    (ulo := (-0.1187195518)) (uhi := 0.4814667453) (vlo := 0.712659285) (vhi := 1.1567335554)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT55.1, vbpT60.2]) (by linarith [vbpT67.2, vbpT60.1])
    ht0 ht1 (by norm_num) blkLo19
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL1_20 {t : ℝ} (ht0 : (0.43:ℝ) ≤ t) (ht1 : t ≤ 0.68) :
    ((-0.0000673165):ℝ) ≤ ∫ v in (vBP 3.5707148)..(vBP 3.8078871), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.119121707) (ylo := 1.119121707) (yhi := 1.119121707) (j := (0:ℤ))
    (c0 := 0.436472822) (c1 := 0.4364736713) (s0 := 0.8997174375) (s1 := 0.899717524)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.43) (t1 := 0.68) (X0 := 1.119121707) (W := 0.6507601)
    ht0 ht1 vbpT73.1 vbpT73.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.6507601) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.43) (t1 := 0.68) (d := 0.0716348)
    (ulo := (-0.1977730162)) (uhi := 0.4364736713) (vlo := 0.7158363963) (vhi := 1.1641294918)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT67.1, vbpT73.2]) (by linarith [vbpT81.2, vbpT73.1])
    ht0 ht1 (by norm_num) blkLo20
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL1_21 {t : ℝ} (ht0 : (0.43:ℝ) ≤ t) (ht1 : t ≤ 0.68) :
    ((-0.000074817):ℝ) ≤ ∫ v in (vBP 3.8078871)..(vBP 4.0620198), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.178523356) (ylo := 1.178523356) (yhi := 1.178523356) (j := (0:ℤ))
    (c0 := 0.3822897076) (c1 := 0.382291132) (s0 := 0.9240425128) (s1 := 0.9240426655)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.43) (t1 := 0.68) (X0 := 1.178523356) (W := 0.6853046)
    ht0 ht1 vbpT88.1 vbpT88.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.6853046) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.43) (t1 := 0.68) (d := 0.06687385)
    (ulo := (-0.2888560544)) (uhi := 0.382291132) (vlo := 0.7154180147) (vhi := 1.1659981141)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT81.1, vbpT88.2]) (by linarith [vbpT97.2, vbpT88.1])
    ht0 ht1 (by norm_num) blkLo21
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL1_22 {t : ℝ} (ht0 : (0.43:ℝ) ≤ t) (ht1 : t ≤ 0.68) :
    ((-0.0000773647):ℝ) ≤ ∫ v in (vBP 4.0620198)..(vBP 4.3301276), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.230708244) (ylo := 1.230708244) (yhi := 1.230708244) (j := (0:ℤ))
    (c0 := 0.3335701063) (c1 := 0.3335723032) (s0 := 0.942725285) (s1 := 0.9427255309)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.43) (t1 := 0.68) (X0 := 1.230708244) (W := 0.7156464)
    ht0 ht1 vbpT105.1 vbpT105.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.7156464) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.43) (t1 := 0.68) (d := 0.0691632)
    (ulo := (-0.3667921697)) (uhi := 0.3335723032) (vlo := 0.7114458237) (vhi := 1.1615841112)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT97.1, vbpT105.2]) (by linarith [vbpT115.2, vbpT105.1])
    ht0 ht1 (by norm_num) blkLo22
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL1_23 {t : ℝ} (ht0 : (0.43:ℝ) ≤ t) (ht1 : t ≤ 0.68) :
    ((-0.0000708688):ℝ) ≤ ∫ v in (vBP 4.3301276)..(vBP 4.6368098), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.288130506) (ylo := 1.288130506) (yhi := 1.288130506) (j := (0:ℤ))
    (c0 := 0.2789166219) (c1 := 0.2789200881) (s0 := 0.9603153053) (s1 := 0.9603157113)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.43) (t1 := 0.68) (X0 := 1.288130506) (W := 0.74902)
    ht0 ht1 vbpT125.1 vbpT125.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.74902) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.43) (t1 := 0.68) (d := 0.07247932)
    (ulo := (-0.4496330907)) (uhi := 0.2789200881) (vlo := 0.7032931782) (vhi := 1.1502383623)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT115.1, vbpT125.2]) (by linarith [vbpT137.2, vbpT125.1])
    ht0 ht1 (by norm_num) blkLo23
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL1_24 {t : ℝ} (ht0 : (0.43:ℝ) ≤ t) (ht1 : t ≤ 0.68) :
    ((-0.0000653344):ℝ) ≤ ∫ v in (vBP 4.6368098)..(vBP 4.949748), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.348227298) (ylo := 1.348227298) (yhi := 1.348227298) (j := (0:ℤ))
    (c0 := 0.2207359342) (c1 := 0.2207414028) (s0 := 0.9753335836) (s1 := 0.9753342539)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.43) (t1 := 0.68) (X0 := 1.348227298) (W := 0.7839622)
    ht0 ht1 vbpT148.1 vbpT148.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.7839622) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.43) (t1 := 0.68) (d := 0.06760111)
    (ulo := (-0.5323665759)) (uhi := 0.2207414028) (vlo := 0.690654613) (vhi := 1.1311977)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT137.1, vbpT148.2]) (by linarith [vbpT161.2, vbpT148.1])
    ht0 ht1 (by norm_num) blkLo24
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL1_25 {t : ℝ} (ht0 : (0.43:ℝ) ≤ t) (ht1 : t ≤ 0.68) :
    ((-0.0000095806):ℝ) ≤ ∫ v in (vBP 4.949748)..(vBP 5), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.379757599) (ylo := 1.379757599) (yhi := 1.379757599) (j := (0:ℤ))
    (c0 := 0.1898787296) (c1 := 0.1898856204) (s0 := 0.9818075219) (s1 := 0.9818083863)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 0.43) (t1 := 0.68) (X0 := 1.379757599) (W := 0.8023005)
    ht0 ht1 vbpT162.1 vbpT162.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.8023005) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 0.43) (t1 := 0.68) (d := 0.01033663)
    (ulo := (-0.5739018975)) (uhi := 0.1898856204) (vlo := 0.6824098239) (vhi := 1.1183279761)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT161.1, vbpT162.2]) (by linarith [vbpT165.2, vbpT162.1])
    ht0 ht1 (by norm_num) blkLo25
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

/-- Lower bound for `∫₀^∞ err(v) cos(tv) dv` on the band `0.43 ≤ t ≤ 0.68`. -/
theorem oscLowBand1 {t : ℝ} (ht0 : (0.43:ℝ) ≤ t) (ht1 : t ≤ 0.68) :
    ((-0.0135202071):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosLBL1_0 ht0 ht1)
    (cosLBL1_1 ht0 ht1))
    (cosLBL1_2 ht0 ht1))
    (cosLBL1_3 ht0 ht1))
    (cosLBL1_4 ht0 ht1))
    (cosLBL1_5 ht0 ht1))
    (cosLBL1_6 ht0 ht1))
    (cosLBL1_7 ht0 ht1))
    (cosLBL1_8 ht0 ht1))
    (cosLBL1_9 ht0 ht1))
    (cosLBL1_10 ht0 ht1))
    (cosLBL1_11 ht0 ht1))
    (cosLBL1_12 ht0 ht1))
    (cosLBL1_13 ht0 ht1))
    (cosLBL1_14 ht0 ht1))
    (cosLBL1_15 ht0 ht1))
    (cosLBL1_16 ht0 ht1))
    (cosLBL1_17 ht0 ht1))
    (cosLBL1_18 ht0 ht1))
    (cosLBL1_19 ht0 ht1))
    (cosLBL1_20 ht0 ht1))
    (cosLBL1_21 ht0 ht1))
    (cosLBL1_22 ht0 ht1))
    (cosLBL1_23 ht0 ht1))
    (cosLBL1_24 ht0 ht1))
    (cosLBL1_25 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 5) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 5) (S := 0.0022)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_five
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
