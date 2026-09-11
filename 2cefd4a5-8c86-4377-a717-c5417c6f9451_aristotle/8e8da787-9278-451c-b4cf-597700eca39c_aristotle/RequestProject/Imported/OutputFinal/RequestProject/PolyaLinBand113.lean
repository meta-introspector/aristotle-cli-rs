/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscTail
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLinBlocks1
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLinBlocks2
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLinBlocks3
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLinBlocks4

/-!
# Oscillatory lower bound on the band `4.034375 ≤ t ≤ 4.096875`

On each block the phase `t v` is linearised at the base point, so that the error is
quadratic in the block width; the signed contributions are then summed and the
unresolved tail beyond `q = 2.094` is estimated in absolute value.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosLB113_0 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    ((-0.0319159518):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.0228), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.089867671) (ylo := 0.089867671) (yhi := 0.089867671) (j := (0:ℤ))
    (c0 := 0.9959646178) (c1 := 0.9959646179) (s0 := 0.0897467549) (s1 := 0.089746755)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 0.089867671) (W := 0.0013923)
    ht0 ht1 vbpP45.1 vbpP45.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0013923) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.02281245)
    (ulo := 0.995838698) (uhi := 0.9959646179) (vlo := 0.0897466679) (vhi := 0.0911334361)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP0.1, vbpP45.2]) (by linarith [vbpP91.2, vbpP45.1])
    ht0 ht1 (by norm_num) blkLin0
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_1 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    ((-0.0178708657):ℝ) ≤ ∫ v in (vBP 1.0228)..(vBP 1.046), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.273677621) (ylo := 0.273677621) (yhi := 0.273677621) (j := (0:ℤ))
    (c0 := 0.962783444) (c1 := 0.9627834441) (s0 := 0.270274009) (s1 := 0.2702740091)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 0.273677621) (W := 0.0042398)
    ht0 ht1 vbpP116.1 vbpP116.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0042398) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.02274851)
    (ulo := 0.9616288862) (uhi := 0.9627834441) (vlo := 0.2702715797) (vhi := 0.2743560062)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP91.1, vbpP116.2]) (by linarith [vbpP139.2, vbpP116.1])
    ht0 ht1 (by norm_num) blkLin1
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_2 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    ((-0.0069143103):ℝ) ≤ ∫ v in (vBP 1.046)..(vBP 1.069), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.447288788) (ylo := 0.447288788) (yhi := 0.447288788) (j := (0:ℤ))
    (c0 := 0.9016230752) (c1 := 0.9016230754) (s0 := 0.4325226354) (s1 := 0.4325226355)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 0.447288788) (W := 0.0069294)
    ht0 ht1 vbpP151.1 vbpP151.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0069294) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.02257786)
    (ulo := 0.8986043304) (uhi := 0.9016230754) (vlo := 0.4325122513) (vhi := 0.4387702925)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP139.1, vbpP151.2]) (by linarith [vbpP160.2, vbpP151.1])
    ht0 ht1 (by norm_num) blkLin2
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_3 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    (0.000007232:ℝ) ≤ ∫ v in (vBP 1.069)..(vBP 1.092), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.620979399) (ylo := 0.620979399) (yhi := 0.620979399) (j := (0:ℤ))
    (c0 := 0.8133090011) (c1 := 0.8133090035) (s0 := 0.5818319934) (s1 := 0.5818319937)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 0.620979399) (W := 0.0096202)
    ht0 ht1 vbpP164.1 vbpP164.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0096202) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.02209968)
    (ulo := 0.8076741124) (uhi := 0.8133090035) (vlo := 0.5818050698) (vhi := 0.5896560683)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP160.1, vbpP164.2]) (by linarith [vbpP169.2, vbpP164.1])
    ht0 ht1 (by norm_num) blkLin3
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_4 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    (0.0047450688:ℝ) ≤ ∫ v in (vBP 1.092)..(vBP 1.117), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.798321701) (ylo := 0.798321701) (yhi := 0.798321701) (j := (0:ℤ))
    (c0 := 0.6979096654) (c1 := 0.6979096945) (s0 := 0.7161857989) (s1 := 0.7161858011)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 0.798321701) (W := 0.0123675)
    ht0 ht1 vbpP180.1 vbpP180.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0123675) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.02341315)
    (ulo := 0.6889990895) (uhi := 0.6979096945) (vlo := 0.7161310274) (vhi := 0.7248169793)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP169.1, vbpP180.2]) (by linarith [vbpP193.2, vbpP180.1])
    ht0 ht1 (by norm_num) blkLin4
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_5 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    (0.0060935343:ℝ) ≤ ∫ v in (vBP 1.117)..(vBP 1.1425), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.986143522) (ylo := 0.986143522) (yhi := 0.986143522) (j := (0:ℤ))
    (c0 := 0.5519098864) (c1 := 0.5519101262) (s0 := 0.8339037564) (s1 := 0.833903778)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 0.986143522) (W := 0.0152773)
    ht0 ht1 vbpP206.1 vbpP206.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0152773) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.02314223)
    (ulo := 0.5391061782) (uhi := 0.5519101262) (vlo := 0.8338064434) (vhi := 0.8423351466)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP193.1, vbpP206.2]) (by linarith [vbpP222.2, vbpP206.1])
    ht0 ht1 (by norm_num) blkLin5
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_6 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    (0.0051284979:ℝ) ≤ ∫ v in (vBP 1.1425)..(vBP 1.1685), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.166201858) (ylo := 1.166201858) (yhi := 1.166201858) (j := (0:ℤ))
    (c0 := 0.3936459901) (c1 := 0.3936472725) (s0 := 0.9192621073) (s1 := 0.9192622433)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 1.166201858) (W := 0.0180667)
    ht0 ht1 vbpP248.1 vbpP248.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0180667) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.02262862)
    (ulo := 0.376974616) (uhi := 0.3936472725) (vlo := 0.9191120852) (vhi := 0.9263737636)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP222.1, vbpP248.2]) (by linarith [vbpP274.2, vbpP248.1])
    ht0 ht1 (by norm_num) blkLin6
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_7 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    (0.0027739745:ℝ) ≤ ∫ v in (vBP 1.1685)..(vBP 1.195), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.345744996) (ylo := 1.345744996) (yhi := 1.345744996) (j := (0:ℤ))
    (c0 := 0.2231563258) (c1 := 0.2231616946) (s0 := 0.9747826459) (s1 := 0.9747833029)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 1.345744996) (W := 0.0208482)
    ht0 ht1 vbpP300.1 vbpP300.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0208482) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.02272274)
    (ulo := 0.2027868252) (uhi := 0.2231616946) (vlo := 0.9745708101) (vhi := 0.9794354856)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP274.1, vbpP300.2]) (by linarith [vbpP326.2, vbpP300.1])
    ht0 ht1 (by norm_num) blkLin7
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_8 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    (0.000202442:ℝ) ≤ ∫ v in (vBP 1.195)..(vBP 1.222), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.524720211) (ylo := 1.524720211) (yhi := 1.524720211) (j := (0:ℤ))
    (c0 := 0.0460594887) (c1 := 0.0460782016) (s0 := 0.9989386453) (s1 := 0.9989412392)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 1.524720211) (W := 0.0236208)
    ht0 ht1 vbpP339.1 vbpP339.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0236208) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.02304553)
    (ulo := 0.0224530429) (uhi := 0.0460782016) (vlo := 0.9986599832) (vhi := 1.000029542)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP326.1, vbpP339.2]) (by linarith [vbpP353.2, vbpP339.1])
    ht0 ht1 (by norm_num) blkLin8
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_9 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    ((-0.001771274):ℝ) ≤ ∫ v in (vBP 1.222)..(vBP 1.25), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 1.709609638) (ylo := 0.138813311205) (yhi := 0.138813311206) (j := (0:ℤ))
    (c0 := (-0.1383679385)) (c1 := (-0.1383679384)) (s0 := 0.9903808931) (s1 := 0.9903808932)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 1.709609638) (W := 0.0264851)
    ht0 ht1 vbpP367.1 vbpP367.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0264851) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.022783)
    (ulo := (-0.1645952091)) (uhi := (-0.1383194114)) (vlo := 0.9863692965) (vhi := 0.9903808932)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP353.1, vbpP367.2]) (by linarith [vbpP381.2, vbpP367.1])
    ht0 ht1 (by norm_num) blkLin9
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_10 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    ((-0.0024561327):ℝ) ≤ ∫ v in (vBP 1.25)..(vBP 1.278), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 1.890357186) (ylo := 0.319560859205) (yhi := 0.319560859206) (j := (0:ℤ))
    (c0 := (-0.3141496824)) (c1 := (-0.3141496823)) (s0 := 0.9493734655) (s1 := 0.9493734656)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 1.890357186) (W := 0.0292852)
    ht0 ht1 vbpP395.1 vbpP395.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0292852) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.0222755)
    (ulo := (-0.3419483004)) (uhi := (-0.3140149809)) (vlo := 0.939767771) (vhi := 0.9493734656)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP381.1, vbpP395.2]) (by linarith [vbpP403.2, vbpP395.1])
    ht0 ht1 (by norm_num) blkLin10
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_11 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    ((-0.0017395278):ℝ) ≤ ∫ v in (vBP 1.278)..(vBP 1.303), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.048387084) (ylo := 0.477590757205) (yhi := 0.477590757206) (j := (0:ℤ))
    (c0 := (-0.4596408514)) (c1 := (-0.4596408512)) (s0 := 0.8881048855) (s1 := 0.8881048858)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 2.048387084) (W := 0.0317335)
    ht0 ht1 vbpP408.1 vbpP408.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0317335) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.02160518)
    (ulo := (-0.487818798)) (uhi := (-0.4594094379)) (vlo := 0.8730741905) (vhi := 0.8881048858)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP403.1, vbpP408.2]) (by linarith [vbpP414.2, vbpP408.1])
    ht0 ht1 (by norm_num) blkLin11
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_12 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    ((-0.0008358505):ℝ) ≤ ∫ v in (vBP 1.303)..(vBP 1.331), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.221782029) (ylo := 0.650985702205) (yhi := 0.650985702206) (j := (0:ℤ))
    (c0 := (-0.6059708134)) (c1 := (-0.6059708131)) (s0 := 0.7954868783) (s1 := 0.7954868821)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 2.221782029) (W := 0.0344198)
    ht0 ht1 vbpP417.1 vbpP417.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0344198) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.02137429)
    (ulo := (-0.6333459068)) (uhi := (-0.6056118948)) (vlo := 0.774162433) (vhi := 0.7954868821)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP414.1, vbpP417.2]) (by linarith [vbpP420.2, vbpP417.1])
    ht0 ht1 (by norm_num) blkLin12
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_13 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    (0.0011892373:ℝ) ≤ ∫ v in (vBP 1.331)..(vBP 1.36), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.391528946) (ylo := 0.820732619205) (yhi := 0.820732619206) (j := (0:ℤ))
    (c0 := (-0.7316454447)) (c1 := (-0.7316454418)) (s0 := 0.6816853725) (s1 := 0.6816854108)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 2.391528946) (W := 0.0370498)
    ht0 ht1 vbpP423.1 vbpP423.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0370498) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.02218152)
    (ulo := (-0.7568959751)) (uhi := (-0.7311433388)) (vlo := 0.6541164392) (vhi := 0.6816854108)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP420.1, vbpP423.2]) (by linarith [vbpP429.2, vbpP423.1])
    ht0 ht1 (by norm_num) blkLin13
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_14 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    (0.0030507449:ℝ) ≤ ∫ v in (vBP 1.36)..(vBP 1.39), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.563652687) (ylo := 0.992856360205) (yhi := 0.992856360206) (j := (0:ℤ))
    (c0 := (-0.8375898449)) (c1 := (-0.8375898217)) (s0 := 0.5462996322) (s1 := 0.5462998888)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 2.563652687) (W := 0.0397168)
    ht0 ht1 vbpP435.1 vbpP435.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0397168) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.02315542)
    (ulo := (-0.8592814245)) (uhi := (-0.8369292913)) (vlo := 0.5126111725) (vhi := 0.5462998888)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP429.1, vbpP435.2]) (by linarith [vbpP442.2, vbpP435.1])
    ht0 ht1 (by norm_num) blkLin14
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_15 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    (0.003832876:ℝ) ≤ ∫ v in (vBP 1.39)..(vBP 1.42), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.737929929) (ylo := 1.167133602205) (yhi := 1.167133602206) (j := (0:ℤ))
    (c0 := (-0.9196286228)) (c1 := (-0.9196284856)) (s0 := 0.3927893021) (s1 := 0.3927905947)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 2.737929929) (W := 0.0424178)
    ht0 ht1 vbpP448.1 vbpP448.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0424178) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.02266377)
    (ulo := (-0.9362849398)) (uhi := (-0.9188012797)) (vlo := 0.3534390619) (vhi := 0.3927905947)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP442.1, vbpP448.2]) (by linarith [vbpP455.2, vbpP448.1])
    ht0 ht1 (by norm_num) blkLin15
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_16 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    (0.0036333499:ℝ) ≤ ∫ v in (vBP 1.42)..(vBP 1.45), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.90852187) (ylo := 1.337725543205) (yhi := 1.337725543206) (j := (0:ℤ))
    (c0 := (-0.9729623438)) (c1 := (-0.9729617287)) (s0 := 0.2309662948) (s1 := 0.2309713521)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 2.90852187) (W := 0.0450627)
    ht0 ht1 vbpP461.1 vbpP461.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0450627) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.02219285)
    (ulo := (-0.9833670144)) (uhi := (-0.9719740249)) (vlo := 0.1869023559) (vhi := 0.2309713521)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP455.1, vbpP461.2]) (by linarith [vbpP468.2, vbpP461.1])
    ht0 ht1 (by norm_num) blkLin16
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_17 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    (0.0025980757:ℝ) ≤ ∫ v in (vBP 1.45)..(vBP 1.481), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 3.075580792) (ylo := 1.504784465205) (yhi := 1.504784465206) (j := (0:ℤ))
    (c0 := (-0.9978242202)) (c1 := (-0.9978219759)) (s0 := 0.0659636522) (s1 := 0.0659800574)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 3.075580792) (W := 0.0476544)
    ht0 ht1 vbpP474.1 vbpP474.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0476544) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.0230925)
    (ulo := (-1.0009672704)) (uhi := (-0.9966891924)) (vlo := 0.0183560474) (vhi := 0.0659800574)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP468.1, vbpP474.2]) (by linarith [vbpP480.2, vbpP474.1])
    ht0 ht1 (by norm_num) blkLin17
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_18 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    (0.0009193644:ℝ) ≤ ∫ v in (vBP 1.481)..(vBP 1.512), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 3.244648381) (ylo := 0.10305572741) (yhi := 0.103055727411) (j := (0:ℤ))
    (c0 := (-0.9946944567)) (c1 := (-0.9946944566)) (s0 := (-0.1028734074)) (s1 := (-0.1028734073))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 3.244648381) (W := 0.0502798)
    ht0 ht1 vbpP485.1 vbpP485.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0502798) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.02261815)
    (ulo := (-0.9946944567)) (uhi := (-0.9882671234)) (vlo := (-0.1528653758)) (vhi := (-0.1027433997))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP480.1, vbpP485.2]) (by linarith [vbpP490.2, vbpP485.1])
    ht0 ht1 (by norm_num) blkLin18
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_19 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    ((-0.000290313):ℝ) ≤ ∫ v in (vBP 1.512)..(vBP 1.546), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 3.420811487) (ylo := 0.27921883341) (yhi := 0.279218833411) (j := (0:ℤ))
    (c0 := (-0.9612710249)) (c1 := (-0.9612710248)) (s0 := (-0.27560482)) (s1 := (-0.2756048199))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 3.420811487) (W := 0.0530199)
    ht0 ht1 vbpP494.1 vbpP494.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0530199) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.02342962)
    (ulo := (-0.9612710249)) (uhi := (-0.9453145273)) (vlo := (-0.3265474383)) (vhi := (-0.2752175329))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP490.1, vbpP494.2]) (by linarith [vbpP499.2, vbpP494.1])
    ht0 ht1 (by norm_num) blkLin19
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_20 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    ((-0.0009927481):ℝ) ≤ ∫ v in (vBP 1.546)..(vBP 1.578), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 3.598373723) (ylo := 0.45678106941) (yhi := 0.456781069411) (j := (0:ℤ))
    (c0 := (-0.8974768911)) (c1 := (-0.8974768909)) (s0 := (-0.4410614812)) (s1 := (-0.4410614811))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 3.598373723) (W := 0.0557889)
    ht0 ht1 vbpP503.1 vbpP503.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0557889) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.02060152)
    (ulo := (-0.8974768911)) (uhi := (-0.8714870262)) (vlo := (-0.4911047612)) (vhi := (-0.4403752789))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP499.1, vbpP503.2]) (by linarith [vbpP507.2, vbpP503.1])
    ht0 ht1 (by norm_num) blkLin20
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_21 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    ((-0.0010887803):ℝ) ≤ ∫ v in (vBP 1.578)..(vBP 1.614), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 3.761990185) (ylo := 0.62039753141) (yhi := 0.620397531411) (j := (0:ℤ))
    (c0 := (-0.813647415)) (c1 := (-0.8136474126)) (s0 := (-0.5813586571)) (s1 := (-0.5813586568))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 3.761990185) (W := 0.0583501)
    ht0 ht1 vbpP511.1 vbpP511.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0583501) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.02495758)
    (ulo := (-0.813647415)) (uhi := (-0.7783595893)) (vlo := (-0.628808129)) (vhi := (-0.5803692517))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP507.1, vbpP511.2]) (by linarith [vbpP516.2, vbpP511.1])
    ht0 ht1 (by norm_num) blkLin21
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_22 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    ((-0.0004999312):ℝ) ≤ ∫ v in (vBP 1.614)..(vBP 1.648), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 3.952061945) (ylo := 0.81046929141) (yhi := 0.810469291411) (j := (0:ℤ))
    (c0 := (-0.6891584889)) (c1 := (-0.6891584551)) (s0 := (-0.7246106728)) (s1 := (-0.7246106702))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 3.952061945) (W := 0.0613427)
    ht0 ht1 vbpP519.1 vbpP519.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0613427) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.02220681)
    (ulo := (-0.6891584889)) (uhi := (-0.6434405316)) (vlo := (-0.7668590074)) (vhi := (-0.7232477691))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP516.1, vbpP519.2]) (by linarith [vbpP521.2, vbpP519.1])
    ht0 ht1 (by norm_num) blkLin22
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_23 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    ((-0.0001420637):ℝ) ≤ ∫ v in (vBP 1.648)..(vBP 1.68), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 4.108710158) (ylo := 0.96711750441) (yhi := 0.967117504411) (j := (0:ℤ))
    (c0 := (-0.5676751047)) (c1 := (-0.5676749074)) (s0 := (-0.8232528326)) (s1 := (-0.8232528151))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 4.108710158) (W := 0.063829)
    ht0 ht1 vbpP523.1 vbpP523.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.063829) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.01936289)
    (ulo := (-0.5676751047)) (uhi := (-0.5140071746)) (vlo := (-0.8594623681)) (vhi := (-0.8215763602))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP521.1, vbpP523.2]) (by linarith [vbpP525.2, vbpP523.1])
    ht0 ht1 (by norm_num) blkLin23
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_24 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    (0.0001833981:ℝ) ≤ ∫ v in (vBP 1.68)..(vBP 1.712), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 4.262361509) (ylo := 1.12076885541) (yhi := 1.120768855411) (j := (0:ℤ))
    (c0 := (-0.4349911242)) (c1 := (-0.4349902623)) (s0 := (-0.9004352401)) (s1 := (-0.9004351522))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 4.262361509) (W := 0.0662922)
    ht0 ht1 vbpP527.1 vbpP527.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0662922) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.01901515)
    (ulo := (-0.4349911242)) (uhi := (-0.3743866742)) (vlo := (-0.9292506423)) (vhi := (-0.8984573254))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP525.1, vbpP527.2]) (by linarith [vbpP529.2, vbpP527.1])
    ht0 ht1 (by norm_num) blkLin24
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_25 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    ((-0.000105076):ℝ) ≤ ∫ v in (vBP 1.712)..(vBP 1.75), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 4.441078786) (ylo := 1.29948613241) (yhi := 1.299486132411) (j := (0:ℤ))
    (c0 := (-0.2679976707)) (c1 := (-0.2679938866)) (s0 := (-0.9634210415)) (s1 := (-0.9634205944))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 4.441078786) (W := 0.0691987)
    ht0 ht1 vbpP532.1 vbpP532.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0691987) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.02562316)
    (ulo := (-0.2679976707)) (uhi := (-0.2007382129)) (vlo := (-0.9819513351)) (vhi := (-0.9611148641))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP529.1, vbpP532.2]) (by linarith [vbpP534.2, vbpP532.1])
    ht0 ht1 (by norm_num) blkLin25
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_26 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    ((-0.0002581396):ℝ) ≤ ∫ v in (vBP 1.75)..(vBP 1.788), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 4.588541994) (ylo := 1.44694934041) (yhi := 1.446949340411) (j := (0:ℤ))
    (c0 := (-0.1235415454)) (c1 := (-0.1235304595)) (s0 := (-0.9923421982)) (s1 := (-0.9923407399))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 4.588541994) (W := 0.0716418)
    ht0 ht1 vbpP536.1 vbpP536.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0716418) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.0249125)
    (ulo := (-0.1235415454)) (uhi := (-0.0521812)) (vlo := (-1.0011853677)) (vhi := (-0.9897952109))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP534.1, vbpP536.2]) (by linarith [vbpP539.2, vbpP536.1])
    ht0 ht1 (by norm_num) blkLin26
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_27 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    ((-0.0002401658):ℝ) ≤ ∫ v in (vBP 1.788)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hp := trigPoint3 (X := 4.760186883) (ylo := 0.047797902615) (yhi := 0.047797902616) (j := (0:ℤ))
    (c0 := 0.0477797045) (c1 := 0.0477797046) (s0 := (-0.9988578978)) (s1 := (-0.9988578977))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 4.760186883) (W := 0.0745533)
    ht0 ht1 vbpP541.1 vbpP541.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0745533) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.02665257)
    (ulo := 0.0476469815) (uhi := 0.1221788916) (vlo := (-0.9988578978)) (vhi := (-0.9925244242))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP539.1, vbpP541.2]) (by linarith [vbpP543.2, vbpP541.1])
    ht0 ht1 (by norm_num) blkLin27
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_28 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    ((-0.0001152856):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.86), errFun v * Real.cos (t * v) := by
  have hp := trigPoint3 (X := 4.9369502) (ylo := 0.224561219615) (yhi := 0.224561219616) (j := (0:ℤ))
    (c0 := 0.2226786201) (c1 := 0.2226786202) (s0 := (-0.974891908)) (s1 := (-0.9748919079))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 4.9369502) (W := 0.0776517)
    ht0 ht1 vbpP544.1 vbpP544.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0776517) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.01769411)
    (ulo := 0.2220076051) (uhi := 0.2983045793) (vlo := (-0.974891908)) (vhi := (-0.954680188))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP543.1, vbpP544.2]) (by linarith [vbpP545.2, vbpP544.1])
    ht0 ht1 (by norm_num) blkLin28
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_29 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    ((-0.0003357735):ℝ) ≤ ∫ v in (vBP 1.86)..(vBP 1.89), errFun v * Real.cos (t * v) := by
  have hp := trigPoint3 (X := 5.071278261) (ylo := 0.358889280615) (yhi := 0.358889280616) (j := (0:ℤ))
    (c0 := 0.3512344974) (c1 := 0.3512344975) (s0 := (-0.9362875242)) (s1 := (-0.9362875241))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 5.071278261) (W := 0.0800933)
    ht0 ht1 vbpP546.1 vbpP546.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0800933) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.01641361)
    (ulo := 0.3501085259) (uhi := 0.4261447044) (vlo := (-0.9362875242)) (vhi := (-0.9051845539))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP545.1, vbpP546.2]) (by linarith [vbpP547.2, vbpP546.1])
    ht0 ht1 (by norm_num) blkLin29
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_30 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    ((-0.0001397203):ℝ) ≤ ∫ v in (vBP 1.89)..(vBP 1.922), errFun v * Real.cos (t * v) := by
  have hp := trigPoint3 (X := 5.203355428) (ylo := 0.490966447615) (yhi := 0.490966447616) (j := (0:ℤ))
    (c0 := 0.4714783967) (c1 := 0.4714783968) (s0 := (-0.8818776116)) (s1 := (-0.8818776113))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 5.203355428) (W := 0.0825854)
    ht0 ht1 vbpP548.1 vbpP548.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0825854) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.01731057)
    (ulo := 0.4698714868) (uhi := 0.5442258525) (vlo := (-0.8818776116)) (vhi := (-0.8399789777))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP547.1, vbpP548.2]) (by linarith [vbpP549.2, vbpP548.1])
    ht0 ht1 (by norm_num) blkLin30
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_31 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    ((-0.0005817656):ℝ) ≤ ∫ v in (vBP 1.922)..(vBP 1.954), errFun v * Real.cos (t * v) := by
  have hp := trigPoint3 (X := 5.3373997) (ylo := 0.625010719615) (yhi := 0.625010719616) (j := (0:ℤ))
    (c0 := 0.5851059661) (c1 := 0.5851059663) (s0 := (-0.81095685)) (s1 := (-0.8109568474))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 5.3373997) (W := 0.0852268)
    ht0 ht1 vbpP550.1 vbpP550.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0852268) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.01716169)
    (ulo := 0.582982262) (uhi := 0.654137583) (vlo := (-0.81095685)) (vhi := (-0.7582070312))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP549.1, vbpP550.2]) (by linarith [vbpP551.2, vbpP550.1])
    ht0 ht1 (by norm_num) blkLin31
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_32 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    ((-0.0006202852):ℝ) ≤ ∫ v in (vBP 1.954)..(vBP 1.984), errFun v * Real.cos (t * v) := by
  have hp := trigPoint3 (X := 5.465094544) (ylo := 0.752705563615) (yhi := 0.752705563616) (j := (0:ℤ))
    (c0 := 0.6836158935) (c1 := 0.6836158947) (s0 := (-0.7298419922)) (s1 := (-0.729841976))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 5.465094544) (W := 0.0878692)
    ht0 ht1 vbpP552.1 vbpP552.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0878692) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.01603265)
    (ulo := 0.6809784932) (uhi := 0.7476640332) (vlo := (-0.7298419922)) (vhi := (-0.6670347216))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP551.1, vbpP552.2]) (by linarith [vbpP553.2, vbpP552.1])
    ht0 ht1 (by norm_num) blkLin32
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_33 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    ((-0.0008388657):ℝ) ≤ ∫ v in (vBP 1.984)..(vBP 2.016), errFun v * Real.cos (t * v) := by
  have hp := trigPoint3 (X := 5.59071947) (ylo := 0.878330489615) (yhi := 0.878330489616) (j := (0:ℤ))
    (c0 := 0.7696740747) (c1 := 0.7696740808) (s0 := (-0.6384370871)) (s1 := (-0.6384370117))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 5.59071947) (W := 0.0906116)
    ht0 ht1 vbpP554.1 vbpP554.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0906116) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.01698487)
    (ulo := 0.766516546) (uhi := 0.827444757) (vlo := (-0.6384370871)) (vhi := (-0.5661718687))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP553.1, vbpP554.2]) (by linarith [vbpP555.2, vbpP554.1])
    ht0 ht1 (by norm_num) blkLin33
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_34 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    ((-0.0006358326):ℝ) ≤ ∫ v in (vBP 2.016)..(vBP 2.046), errFun v * Real.cos (t * v) := by
  have hp := trigPoint3 (X := 5.71432656) (ylo := 1.001937579615) (yhi := 1.001937579616) (j := (0:ℤ))
    (c0 := 0.8425162831) (c1 := 0.8425163088) (s0 := (-0.5386711545)) (s1 := (-0.5386708735))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 5.71432656) (W := 0.0934728)
    ht0 ht1 vbpP556.1 vbpP556.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0934728) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.01598297)
    (ulo := 0.8388383605) (uhi := 0.892794121) (vlo := (-0.5386711545)) (vhi := (-0.4576816286))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP555.1, vbpP556.2]) (by linarith [vbpP557.2, vbpP556.1])
    ht0 ht1 (by norm_num) blkLin34
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_35 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    ((-0.000500545):ℝ) ≤ ∫ v in (vBP 2.046)..(vBP 2.078), errFun v * Real.cos (t * v) := by
  have hp := trigPoint3 (X := 5.835964442) (ylo := 1.123575461615) (yhi := 1.123575461616) (j := (0:ℤ))
    (c0 := 0.9016524505) (c1 := 0.9016525409) (s0 := (-0.432462269)) (s1 := (-0.4324613852))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 5.835964442) (W := 0.0964728)
    ht0 ht1 vbpP558.1 vbpP558.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0964728) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.0170124)
    (ulo := 0.8974598635) (uhi := 0.9433087011) (vlo := (-0.432462269)) (vhi := (-0.3436004063))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP557.1, vbpP558.2]) (by linarith [vbpP559.2, vbpP558.1])
    ht0 ht1 (by norm_num) blkLin35
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB113_36 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    ((-0.0000606627):ℝ) ≤ ∫ v in (vBP 2.078)..(vBP 2.094), errFun v * Real.cos (t * v) := by
  have hp := trigPoint3 (X := 5.897989836) (ylo := 1.185600855615) (yhi := 1.185600855616) (j := (0:ℤ))
    (c0 := 0.9267250025) (c1 := 0.9267251656) (s0 := (-0.3757417883)) (s1 := (-0.3757402759))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.034375) (t1 := 4.096875) (X0 := 5.897989836) (W := 0.0980823)
    ht0 ht1 vbpP559.1 vbpP559.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0980823) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.034375) (t1 := 4.096875) (d := 0.01705821)
    (ulo := 0.9222709639) (uhi := 0.9635197234) (vlo := (-0.3757417883)) (vhi := (-0.2831847195))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP559.1, vbpP559.2]) (by linarith [vbpP560.2, vbpP559.1])
    ht0 ht1 (by norm_num) blkLin36
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

/-- Lower bound for `∫₀^∞ err(v) cos(tv) dv` on the band `4.034375 ≤ t ≤ 4.096875`. -/
theorem oscLinBand113 {t : ℝ} (ht0 : (4.034375:ℝ) ≤ t) (ht1 : t ≤ 4.096875) :
    ((-0.0503010709):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosLB113_0 ht0 ht1)
    (cosLB113_1 ht0 ht1))
    (cosLB113_2 ht0 ht1))
    (cosLB113_3 ht0 ht1))
    (cosLB113_4 ht0 ht1))
    (cosLB113_5 ht0 ht1))
    (cosLB113_6 ht0 ht1))
    (cosLB113_7 ht0 ht1))
    (cosLB113_8 ht0 ht1))
    (cosLB113_9 ht0 ht1))
    (cosLB113_10 ht0 ht1))
    (cosLB113_11 ht0 ht1))
    (cosLB113_12 ht0 ht1))
    (cosLB113_13 ht0 ht1))
    (cosLB113_14 ht0 ht1))
    (cosLB113_15 ht0 ht1))
    (cosLB113_16 ht0 ht1))
    (cosLB113_17 ht0 ht1))
    (cosLB113_18 ht0 ht1))
    (cosLB113_19 ht0 ht1))
    (cosLB113_20 ht0 ht1))
    (cosLB113_21 ht0 ht1))
    (cosLB113_22 ht0 ht1))
    (cosLB113_23 ht0 ht1))
    (cosLB113_24 ht0 ht1))
    (cosLB113_25 ht0 ht1))
    (cosLB113_26 ht0 ht1))
    (cosLB113_27 ht0 ht1))
    (cosLB113_28 ht0 ht1))
    (cosLB113_29 ht0 ht1))
    (cosLB113_30 ht0 ht1))
    (cosLB113_31 ht0 ht1))
    (cosLB113_32 ht0 ht1))
    (cosLB113_33 ht0 ht1))
    (cosLB113_34 ht0 ht1))
    (cosLB113_35 ht0 ht1))
    (cosLB113_36 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 2.094) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 2.094) (S := 0.013709)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_cut
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
