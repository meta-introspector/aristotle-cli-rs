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
# Oscillatory lower bound on the band `5.159375 ≤ t ≤ 5.284375`

On each block the phase `t v` is linearised at the base point, so that the error is
quadratic in the block width; the signed contributions are then summed and the
unresolved tail beyond `q = 2.094` is estimated in absolute value.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosLB125_0 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    ((-0.0319435162):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.0228), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.114927595) (ylo := 0.114927595) (yhi := 0.114927595) (j := (0:ℤ))
    (c0 := 0.9934030899) (c1 := 0.99340309) (s0 := 0.1146747613) (s1 := 0.1146747614)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 0.114927595) (W := 0.0027845)
    ht0 ht1 vbpP45.1 vbpP45.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0027845) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.02281245)
    (ulo := 0.9930799272) (uhi := 0.99340309) (vlo := 0.1146743167) (vhi := 0.1174408888)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP0.1, vbpP45.2]) (by linarith [vbpP91.2, vbpP45.1])
    ht0 ht1 (by norm_num) blkLin0
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_1 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    ((-0.0175344617):ℝ) ≤ ∫ v in (vBP 1.0228)..(vBP 1.046), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.349993611) (ylo := 0.349993611) (yhi := 0.349993611) (j := (0:ℤ))
    (c0 := 0.9393749036) (c1 := 0.9393749037) (s0 := 0.3428918057) (s1 := 0.3428918058)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 0.349993611) (W := 0.0084796)
    ht0 ht1 vbpP116.1 vbpP116.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0084796) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.02274851)
    (ulo := 0.936433581) (uhi := 0.9393749037) (vlo := 0.3428794781) (vhi := 0.3508572338)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP91.1, vbpP116.2]) (by linarith [vbpP139.2, vbpP116.1])
    ht0 ht1 (by norm_num) blkLin1
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_2 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    ((-0.0065124224):ℝ) ≤ ∫ v in (vBP 1.046)..(vBP 1.069), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.572016877) (ylo := 0.572016877) (yhi := 0.572016877) (j := (0:ℤ))
    (c0 := 0.840810892) (c1 := 0.8408108932) (s0 := 0.5413289607) (s1 := 0.5413289608)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 0.572016877) (W := 0.0138587)
    ht0 ht1 vbpP151.1 vbpP151.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0138587) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.02257786)
    (ulo := 0.8332282731) (uhi := 0.8408108932) (vlo := 0.5412769767) (vhi := 0.5529811338)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP139.1, vbpP151.2]) (by linarith [vbpP160.2, vbpP151.1])
    ht0 ht1 (by norm_num) blkLin2
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_3 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    ((-0.0000614572):ℝ) ≤ ∫ v in (vBP 1.069)..(vBP 1.092), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.794141741) (ylo := 0.794141741) (yhi := 0.794141741) (j := (0:ℤ))
    (c0 := 0.7008971877) (c1 := 0.7008972153) (s0 := 0.7132623163) (s1 := 0.7132623184)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 0.794141741) (W := 0.0192403)
    ht0 ht1 vbpP164.1 vbpP164.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0192403) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.02209968)
    (ulo := 0.6870449251) (uhi := 0.7008972153) (vlo := 0.7131302993) (vhi := 0.7267469591)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP160.1, vbpP164.2]) (by linarith [vbpP169.2, vbpP164.1])
    ht0 ht1 (by norm_num) blkLin3
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_4 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    (0.0033440178:ℝ) ≤ ∫ v in (vBP 1.092)..(vBP 1.117), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.020936583) (ylo := 1.020936583) (yhi := 1.020936583) (j := (0:ℤ))
    (c0 := 0.5225676492) (c1 := 0.5225679883) (s0 := 0.8525978235) (s1 := 0.8525978551)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 1.020936583) (W := 0.024735)
    ht0 ht1 vbpP180.1 vbpP180.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.024735) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.02341315)
    (ulo := 0.501320941) (uhi := 0.5225679883) (vlo := 0.8523370185) (vhi := 0.8655222563)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP169.1, vbpP180.2]) (by linarith [vbpP193.2, vbpP180.1])
    ht0 ht1 (by norm_num) blkLin4
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_5 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    (0.0030184125:ℝ) ≤ ∫ v in (vBP 1.117)..(vBP 1.1425), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.261133195) (ylo := 1.261133195) (yhi := 1.261133195) (j := (0:ℤ))
    (c0 := 0.3047377747) (c1 := 0.3047405792) (s0 := 0.9524362771) (s1 := 0.9524365987)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 1.261133195) (W := 0.0305545)
    ht0 ht1 vbpP206.1 vbpP206.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0305545) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.02314223)
    (ulo := 0.2754988413) (uhi := 0.3047405792) (vlo := 0.9519917251) (vhi := 0.9617463461)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP193.1, vbpP206.2]) (by linarith [vbpP222.2, vbpP206.1])
    ht0 ht1 (by norm_num) blkLin5
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_6 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    (0.0004682955:ℝ) ≤ ∫ v in (vBP 1.1425)..(vBP 1.1685), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.491401446) (ylo := 1.491401446) (yhi := 1.491401446) (j := (0:ℤ))
    (c0 := 0.0793112457) (c1 := 0.079326249) (s0 := 0.996849853) (s1 := 0.9968518872)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 1.491401446) (W := 0.0361333)
    ht0 ht1 vbpP248.1 vbpP248.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0361333) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.02262862)
    (ulo := 0.0432477654) (uhi := 0.079326249) (vlo := 0.9961991725) (vhi := 0.9997175827)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP222.1, vbpP248.2]) (by linarith [vbpP274.2, vbpP248.1])
    ht0 ht1 (by norm_num) blkLin6
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_7 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    ((-0.0028734236):ℝ) ≤ ∫ v in (vBP 1.1685)..(vBP 1.195), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 1.721010835) (ylo := 0.150214508205) (yhi := 0.150214508206) (j := (0:ℤ))
    (c0 := (-0.1496502286)) (c1 := (-0.1496502285)) (s0 := 0.9887389994) (s1 := 0.9887389995)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 1.721010835) (W := 0.0416963)
    ht0 ht1 vbpP300.1 vbpP300.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0416963) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.02272274)
    (ulo := (-0.1908650416)) (uhi := (-0.1495201577)) (vlo := 0.9816415693) (vhi := 0.9887389995)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP274.1, vbpP300.2]) (by linarith [vbpP326.2, vbpP300.1])
    ht0 ht1 (by norm_num) blkLin7
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_8 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    ((-0.0055660097):ℝ) ≤ ∫ v in (vBP 1.195)..(vBP 1.222), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 1.949893934) (ylo := 0.379097607205) (yhi := 0.379097607206) (j := (0:ℤ))
    (c0 := (-0.3700822983)) (c1 := (-0.3700822982)) (s0 := 0.9289989733) (s1 := 0.9289989734)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 1.949893934) (W := 0.0472416)
    ht0 ht1 vbpP339.1 vbpP339.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0472416) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.02304553)
    (ulo := (-0.4139533737)) (uhi := (-0.3696694059)) (vlo := 0.9104857331) (vhi := 0.9289989734)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP326.1, vbpP339.2]) (by linarith [vbpP353.2, vbpP339.1])
    ht0 ht1 (by norm_num) blkLin8
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_9 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    ((-0.0066810842):ℝ) ≤ ∫ v in (vBP 1.222)..(vBP 1.25), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.186340444) (ylo := 0.615544117205) (yhi := 0.615544117206) (j := (0:ℤ))
    (c0 := (-0.5774028575)) (c1 := (-0.5774028573)) (s0 := 0.8164593929) (s1 := 0.8164593951)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 2.186340444) (W := 0.0529702)
    ht0 ht1 vbpP367.1 vbpP367.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0529702) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.022783)
    (ulo := (-0.6206306533)) (uhi := (-0.576592996)) (vlo := 0.7847433886) (vhi := 0.8164593951)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP353.1, vbpP367.2]) (by linarith [vbpP381.2, vbpP367.1])
    ht0 ht1 (by norm_num) blkLin9
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_10 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    ((-0.005695361):ℝ) ≤ ∫ v in (vBP 1.25)..(vBP 1.278), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.417490097) (ylo := 0.846693770205) (yhi := 0.846693770206) (j := (0:ℤ))
    (c0 := (-0.749094251)) (c1 := (-0.7490942469)) (s0 := 0.6624634395) (s1 := 0.6624634918)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 2.417490097) (W := 0.0585704)
    ht0 ht1 vbpP395.1 vbpP395.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0585704) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.0222755)
    (ulo := (-0.7878728223)) (uhi := (-0.7478097333)) (vlo := 0.6174778077) (vhi := 0.6624634918)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP381.1, vbpP395.2]) (by linarith [vbpP403.2, vbpP395.1])
    ht0 ht1 (by norm_num) blkLin10
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_11 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    ((-0.0031913924):ℝ) ≤ ∫ v in (vBP 1.278)..(vBP 1.303), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.619587201) (ylo := 1.048790874205) (yhi := 1.048790874206) (j := (0:ℤ))
    (c0 := (-0.8668210077)) (c1 := (-0.8668209653)) (s0 := 0.498619504) (s1 := 0.4986199478)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 2.619587201) (W := 0.0634668)
    ht0 ht1 vbpP408.1 vbpP408.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0634668) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.02160518)
    (ulo := (-0.8984455795)) (uhi := (-0.8650757587)) (vlo := 0.442638183) (vhi := 0.4986199478)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP403.1, vbpP408.2]) (by linarith [vbpP414.2, vbpP408.1])
    ht0 ht1 (by norm_num) blkLin11
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_12 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    ((-0.0012894928):ℝ) ≤ ∫ v in (vBP 1.303)..(vBP 1.331), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.84133395) (ylo := 1.270537623205) (yhi := 1.270537623206) (j := (0:ℤ))
    (c0 := (-0.9552603504)) (c1 := (-0.9552600014)) (s0 := 0.2957673091) (s1 := 0.2957703299)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 2.84133395) (W := 0.0688394)
    ht0 ht1 vbpP417.1 vbpP417.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0688394) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.02137429)
    (ulo := (-0.9756049253)) (uhi := (-0.9529974719)) (vlo := 0.2293591613) (vhi := 0.2957703299)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP414.1, vbpP417.2]) (by linarith [vbpP420.2, vbpP417.1])
    ht0 ht1 (by norm_num) blkLin12
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_13 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    (0.0016025383:ℝ) ≤ ∫ v in (vBP 1.331)..(vBP 1.36), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 3.058415406) (ylo := 1.487619079205) (yhi := 1.487619079206) (j := (0:ℤ))
    (c0 := (-0.9965447171)) (c1 := (-0.9965427388)) (s0 := 0.0830811288) (s1 := 0.0830957558)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 3.058415406) (W := 0.0740991)
    ht0 ht1 vbpP423.1 vbpP423.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0740991) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.02218152)
    (ulo := (-1.0026964048)) (uhi := (-0.9938081434)) (vlo := 0.0090776368) (vhi := 0.0830957558)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP420.1, vbpP423.2]) (by linarith [vbpP429.2, vbpP423.1])
    ht0 ht1 (by norm_num) blkLin13
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_14 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    (0.0035215666:ℝ) ≤ ∫ v in (vBP 1.36)..(vBP 1.39), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 3.278536472) (ylo := 0.13694381841) (yhi := 0.136943818411) (j := (0:ℤ))
    (c0 := (-0.9906378403)) (c1 := (-0.9906378402)) (s0 := (-0.1365161878)) (s1 := (-0.1365161877))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 3.278536472) (W := 0.0794329)
    ht0 ht1 vbpP435.1 vbpP435.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0794329) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.02315542)
    (ulo := (-0.9906378403)) (uhi := (-0.976681749)) (vlo := (-0.215122701)) (vhi := (-0.1360857338))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP429.1, vbpP435.2]) (by linarith [vbpP442.2, vbpP435.1])
    ht0 ht1 (by norm_num) blkLin14
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_15 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    (0.0037241736:ℝ) ≤ ∫ v in (vBP 1.39)..(vBP 1.42), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 3.501411551) (ylo := 0.35981889741) (yhi := 0.359818897411) (j := (0:ℤ))
    (c0 := (-0.9359606062)) (c1 := (-0.9359606061)) (s0 := (-0.3521047342)) (s1 := (-0.3521047341))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 3.501411551) (W := 0.0848341)
    ht0 ht1 vbpP448.1 vbpP448.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0848341) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.02266377)
    (ulo := (-0.9359606062)) (uhi := (-0.902759981)) (vlo := (-0.4314109045)) (vhi := (-0.3508384758))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP442.1, vbpP448.2]) (by linarith [vbpP455.2, vbpP448.1])
    ht0 ht1 (by norm_num) blkLin15
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_16 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    (0.0028837173:ℝ) ≤ ∫ v in (vBP 1.42)..(vBP 1.45), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 3.719573669) (ylo := 0.57798101541) (yhi := 0.577981015411) (j := (0:ℤ))
    (c0 := (-0.8375673974)) (c1 := (-0.8375673962)) (s0 := (-0.5463340159)) (s1 := (-0.5463340157))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 3.719573669) (W := 0.0901223)
    ht0 ht1 vbpP461.1 vbpP461.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0901223) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.02219285)
    (ulo := (-0.8375673974)) (uhi := (-0.7849980698)) (vlo := (-0.6217153778)) (vhi := (-0.5441168466))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP455.1, vbpP461.2]) (by linarith [vbpP468.2, vbpP461.1])
    ht0 ht1 (by norm_num) blkLin16
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_17 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    (0.0015926609:ℝ) ≤ ∫ v in (vBP 1.45)..(vBP 1.481), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 3.933217574) (ylo := 0.79162492041) (yhi := 0.791624920411) (j := (0:ℤ))
    (c0 := (-0.702690146)) (c1 := (-0.7026901192)) (s0 := (-0.7114960287)) (s1 := (-0.7114960267))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 3.933217574) (W := 0.0953031)
    ht0 ht1 vbpP474.1 vbpP474.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0953031) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.0230925)
    (ulo := (-0.702690146)) (uhi := (-0.631796201)) (vlo := (-0.7783632484)) (vhi := (-0.7082673259))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP468.1, vbpP474.2]) (by linarith [vbpP480.2, vbpP474.1])
    ht0 ht1 (by norm_num) blkLin17
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_18 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    (0.0003813431:ℝ) ≤ ∫ v in (vBP 1.481)..(vBP 1.512), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 4.149430269) (ylo := 1.00783761541) (yhi := 1.007837615411) (j := (0:ℤ))
    (c0 := (-0.5336909483)) (c1 := (-0.5336906503)) (s0 := (-0.8456798054)) (s1 := (-0.845679778))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 4.149430269) (W := 0.1005495)
    ht0 ht1 vbpP485.1 vbpP485.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1005495) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.02261815)
    (ulo := (-0.5336909483)) (uhi := (-0.4461055913)) (vlo := (-0.8992517863)) (vhi := (-0.8414083818))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP480.1, vbpP485.2]) (by linarith [vbpP490.2, vbpP485.1])
    ht0 ht1 (by norm_num) blkLin18
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_19 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    ((-0.0000967694):ℝ) ≤ ∫ v in (vBP 1.512)..(vBP 1.546), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 4.374717092) (ylo := 1.23312443841) (yhi := 1.233124438411) (j := (0:ℤ))
    (c0 := (-0.331293567)) (c1 := (-0.3312913266)) (s0 := (-0.9435287538)) (s1 := (-0.9435285026))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 4.374717092) (W := 0.1060219)
    ht0 ht1 vbpP494.1 vbpP494.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1060219) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.02342962)
    (ulo := (-0.331293567)) (uhi := (-0.2295836988)) (vlo := (-0.9785873608)) (vhi := (-0.9382305344))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP490.1, vbpP494.2]) (by linarith [vbpP499.2, vbpP494.1])
    ht0 ht1 (by norm_num) blkLin19
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_20 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    ((-0.0001698025):ℝ) ≤ ∫ v in (vBP 1.546)..(vBP 1.578), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 4.601793197) (ylo := 1.46020054341) (yhi := 1.460200543411) (j := (0:ℤ))
    (c0 := (-0.110382414)) (c1 := (-0.1103702699)) (s0 := (-0.9938921078)) (s1 := (-0.9938904956))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 4.601793197) (W := 0.111547)
    ht0 ht1 vbpP503.1 vbpP503.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.111547) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.02060152)
    (ulo := (-0.110382414)) (uhi := 0.0009515863) (vlo := (-1.0061794167)) (vhi := (-0.9877135472))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP499.1, vbpP503.2]) (by linarith [vbpP507.2, vbpP503.1])
    ht0 ht1 (by norm_num) blkLin20
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_21 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    ((-0.0000458369):ℝ) ≤ ∫ v in (vBP 1.578)..(vBP 1.614), errFun v * Real.cos (t * v) := by
  have hp := trigPoint3 (X := 4.811034699) (ylo := 0.098645718615) (yhi := 0.098645718616) (j := (0:ℤ))
    (c0 := 0.0984858098) (c1 := 0.0984858099) (s0 := (-0.9951384554)) (s1 := (-0.9951384553))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 4.811034699) (W := 0.1166506)
    ht0 ht1 vbpP511.1 vbpP511.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1166506) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.02495758)
    (ulo := 0.0978165032) (uhi := 0.2143062219) (vlo := (-0.9951384554)) (vhi := (-0.9769131324))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP507.1, vbpP511.2]) (by linarith [vbpP516.2, vbpP511.1])
    ht0 ht1 (by norm_num) blkLin21
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_22 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    ((-0.0000055781):ℝ) ≤ ∫ v in (vBP 1.614)..(vBP 1.648), errFun v * Real.cos (t * v) := by
  have hp := trigPoint3 (X := 5.054108653) (ylo := 0.341719672615) (yhi := 0.341719672616) (j := (0:ℤ))
    (c0 := 0.3351078276) (c1 := 0.3351078277) (s0 := (-0.9421797833)) (s1 := (-0.9421797831))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 5.054108653) (W := 0.1226017)
    ht0 ht1 vbpP519.1 vbpP519.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1226017) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.02220681)
    (ulo := 0.3325924482) (uhi := 0.450331506) (vlo := (-0.9421797833)) (vhi := (-0.8941256716))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP516.1, vbpP519.2]) (by linarith [vbpP521.2, vbpP519.1])
    ht0 ht1 (by norm_num) blkLin22
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_23 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    ((-0.0006848763):ℝ) ≤ ∫ v in (vBP 1.648)..(vBP 1.68), errFun v * Real.cos (t * v) := by
  have hp := trigPoint3 (X := 5.254438785) (ylo := 0.542049804615) (yhi := 0.542049804616) (j := (0:ℤ))
    (c0 := 0.5158930455) (c1 := 0.5158930456) (s0 := (-0.8566530025)) (s1 := (-0.8566530018))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 5.254438785) (W := 0.127532)
    ht0 ht1 vbpP523.1 vbpP523.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.127532) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.01936289)
    (ulo := 0.5117033803) (uhi := 0.6248478075) (vlo := (-0.8566530025)) (vhi := (-0.7840812907))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP521.1, vbpP523.2]) (by linarith [vbpP525.2, vbpP523.1])
    ht0 ht1 (by norm_num) blkLin23
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_24 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    ((-0.0010524791):ℝ) ≤ ∫ v in (vBP 1.68)..(vBP 1.712), errFun v * Real.cos (t * v) := by
  have hp := trigPoint3 (X := 5.450936368) (ylo := 0.738547387615) (yhi := 0.738547387616) (j := (0:ℤ))
    (c0 := 0.673214492) (c1 := 0.673214493) (s0 := (-0.7394472715)) (s1 := (-0.7394472581))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 5.450936368) (W := 0.1323996)
    ht0 ht1 vbpP527.1 vbpP527.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1323996) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.01901515)
    (ulo := 0.667322498) (uhi := 0.7708312337) (vlo := (-0.7394472715)) (vhi := (-0.6441024479))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP525.1, vbpP527.2]) (by linarith [vbpP529.2, vbpP527.1])
    ht0 ht1 (by norm_num) blkLin24
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_25 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    ((-0.0016214908):ℝ) ≤ ∫ v in (vBP 1.712)..(vBP 1.75), errFun v * Real.cos (t * v) := by
  have hp := trigPoint3 (X := 5.679489602) (ylo := 0.967100621615) (yhi := 0.967100621616) (j := (0:ℤ))
    (c0 := 0.8232432311) (c1 := 0.8232432485) (s0 := (-0.5676890034)) (s1 := (-0.5676888061))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 5.679489602) (W := 0.1381147)
    ht0 ht1 vbpP532.1 vbpP532.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1381147) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.02562316)
    (ulo := 0.8154037466) (uhi := 0.9014004075) (vlo := (-0.5676890034)) (vhi := (-0.4489420368))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP529.1, vbpP532.2]) (by linarith [vbpP534.2, vbpP532.1])
    ht0 ht1 (by norm_num) blkLin25
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_26 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    ((-0.0012495264):ℝ) ≤ ∫ v in (vBP 1.75)..(vBP 1.788), errFun v * Real.cos (t * v) := by
  have hp := trigPoint3 (X := 5.868073457) (ylo := 1.155684476615) (yhi := 1.155684476616) (j := (0:ℤ))
    (c0 := 0.9150712168) (c1 := 0.91507134) (s0 := (-0.4032934433)) (s1 := (-0.403292272))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 5.868073457) (W := 0.1428882)
    ht0 ht1 vbpP536.1 vbpP536.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1428882) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.0249125)
    (ulo := 0.905745578) (uhi := 0.9725013227) (vlo := (-0.4032934433)) (vhi := (-0.2688738357))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP534.1, vbpP536.2]) (by linarith [vbpP539.2, vbpP536.1])
    ht0 ht1 (by norm_num) blkLin26
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_27 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    ((-0.0005602505):ℝ) ≤ ∫ v in (vBP 1.788)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hp := trigPoint3 (X := 6.087582141) (ylo := 1.375193160615) (yhi := 1.375193160616) (j := (0:ℤ))
    (c0 := 0.9809306076) (c1 := 0.9809314411) (s0 := (-0.1943648061)) (s1 := (-0.1943581399))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 6.087582141) (W := 0.148532)
    ht0 ht1 vbpP541.1 vbpP541.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.148532) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.02665257)
    (ulo := 0.9701299609) (uhi := 1.0096948) (vlo := (-0.1943648061)) (vhi := (-0.0470535701))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP539.1, vbpP541.2]) (by linarith [vbpP543.2, vbpP541.1])
    ht0 ht1 (by norm_num) blkLin27
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_28 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    (0.0002154794:ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.86), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 6.313636545) (ylo := 0.03045123782) (yhi := 0.030451237821) (j := (1:ℤ))
    (c0 := 0.9995363968) (c1 := 0.9995363969) (s0 := 0.0304465319) (s1 := 0.030446532)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 6.313636545) (W := 0.1544731)
    ht0 ht1 vbpP544.1 vbpP544.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1544731) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.01769411)
    (ulo := 0.9829501655) (uhi := 0.9995363969) (vlo := 0.030083997) (vhi := 0.1842346969)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP543.1, vbpP544.2]) (by linarith [vbpP545.2, vbpP544.1])
    ht0 ht1 (by norm_num) blkLin28
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_29 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    ((-0.0003426944):ℝ) ≤ ∫ v in (vBP 1.86)..(vBP 1.89), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 6.485422471) (ylo := 0.20223716382) (yhi := 0.202237163821) (j := (1:ℤ))
    (c0 := 0.9796196698) (c1 := 0.9796196699) (s0 := 0.2008614012) (s1 := 0.2008614013)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 6.485422471) (W := 0.1591003)
    ht0 ht1 vbpP546.1 vbpP546.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1591003) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.01641361)
    (ulo := 0.9354248327) (uhi := 0.9796196699) (vlo := 0.1983245663) (vhi := 0.3560624809)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP545.1, vbpP546.2]) (by linarith [vbpP547.2, vbpP546.1])
    ht0 ht1 (by norm_num) blkLin29
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_30 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    (0.0000042079:ℝ) ≤ ∫ v in (vBP 1.89)..(vBP 1.922), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 6.654329832) (ylo := 0.37114452482) (yhi := 0.371144524821) (j := (1:ℤ))
    (c0 := 0.9319128572) (c1 := 0.9319128573) (s0 := 0.3626822666) (s1 := 0.3626822667)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 6.654329832) (W := 0.1637677)
    ht0 ht1 vbpP548.1 vbpP548.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1637677) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.01731057)
    (ulo := 0.8603133773) (uhi := 0.9319128573) (vlo := 0.3578295831) (vhi := 0.5146182108)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP547.1, vbpP548.2]) (by linarith [vbpP549.2, vbpP548.1])
    ht0 ht1 (by norm_num) blkLin30
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_31 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    ((-0.0006978604):ℝ) ≤ ∫ v in (vBP 1.922)..(vBP 1.954), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 6.825752831) (ylo := 0.54256752382) (yhi := 0.542567523821) (j := (1:ℤ))
    (c0 := 0.8563857993) (c1 := 0.8563858) (s0 := 0.516336482) (s1 := 0.5163364821)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 6.825752831) (W := 0.1686494)
    ht0 ht1 vbpP550.1 vbpP550.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1686494) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.01716169)
    (ulo := 0.7575680825) (uhi := 0.8563858) (vlo := 0.5090108887) (vhi := 0.6600817502)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP549.1, vbpP550.2]) (by linarith [vbpP551.2, vbpP550.1])
    ht0 ht1 (by norm_num) blkLin31
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_32 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    ((-0.0007292105):ℝ) ≤ ∫ v in (vBP 1.954)..(vBP 1.984), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 6.989055842) (ylo := 0.70587053482) (yhi := 0.705870534821) (j := (1:ℤ))
    (c0 := 0.7610471272) (c1 := 0.7610471357) (s0 := 0.6486965932) (s1 := 0.6486965939)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 6.989055842) (W := 0.1734626)
    ht0 ht1 vbpP552.1 vbpP552.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1734626) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.01603265)
    (ulo := 0.6376649812) (uhi := 0.7610471357) (vlo := 0.6389616351) (vhi := 0.7800487738)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP551.1, vbpP552.2]) (by linarith [vbpP553.2, vbpP552.1])
    ht0 ht1 (by norm_num) blkLin32
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_33 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    ((-0.0009966344):ℝ) ≤ ∫ v in (vBP 1.984)..(vBP 2.016), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 7.149711732) (ylo := 0.86652642482) (yhi := 0.866526424821) (j := (1:ℤ))
    (c0 := 0.6474776054) (c1 := 0.6474776712) (s0 := 0.7620844769) (s1 := 0.7620844822)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 7.149711732) (W := 0.1783819)
    ht0 ht1 vbpP554.1 vbpP554.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1783819) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.01698487)
    (ulo := 0.501981215) (uhi := 0.6474776712) (vlo := 0.7499917908) (vhi := 0.8769712253)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP553.1, vbpP554.2]) (by linarith [vbpP555.2, vbpP554.1])
    ht0 ht1 (by norm_num) blkLin33
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_34 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    ((-0.0008515353):ℝ) ≤ ∫ v in (vBP 2.016)..(vBP 2.046), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 7.307787103) (ylo := 1.02460179582) (yhi := 1.024601795821) (j := (1:ℤ))
    (c0 := 0.5194391936) (c1 := 0.5194395451) (s0 := 0.8545074141) (s1 := 0.8545074469)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 7.307787103) (W := 0.1834323)
    ht0 ht1 vbpP556.1 vbpP556.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1834323) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.01598297)
    (ulo := 0.3548580405) (uhi := 0.5194395451) (vlo := 0.8401716983) (vhi := 0.9492560036)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP555.1, vbpP556.2]) (by linarith [vbpP557.2, vbpP556.1])
    ht0 ht1 (by norm_num) blkLin34
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_35 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    ((-0.0008605503):ℝ) ≤ ∫ v in (vBP 2.046)..(vBP 2.078), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 7.463344148) (ylo := 1.18015884082) (yhi := 1.180158840821) (j := (1:ℤ))
    (c0 := 0.3807779392) (c1 := 0.3807793836) (s0 := 0.9246665057) (s1 := 0.9246666608)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 7.463344148) (W := 0.1886401)
    ht0 ht1 vbpP558.1 vbpP558.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1886401) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.0170124)
    (ulo := 0.2006264607) (uhi := 0.3807793836) (vlo := 0.9082630663) (vhi := 0.9960716648)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP557.1, vbpP558.2]) (by linarith [vbpP559.2, vbpP558.1])
    ht0 ht1 (by norm_num) blkLin35
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB125_36 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    ((-0.000437769):ℝ) ≤ ∫ v in (vBP 2.078)..(vBP 2.094), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 7.542665545) (ylo := 1.25948023782) (yhi := 1.259480237821) (j := (1:ℤ))
    (c0 := 0.3063116946) (c1 := 0.3063144626) (s0 := 0.9519312577) (s1 := 0.9519315747)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 5.159375) (t1 := 5.284375) (X0 := 7.542665545) (W := 0.1913985)
    ht0 ht1 vbpP559.1 vbpP559.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1913985) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 5.159375) (t1 := 5.284375) (d := 0.01705821)
    (ulo := 0.1196302964) (uhi := 0.3063144626) (vlo := 0.9345481892) (vhi := 1.0102024007)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP559.1, vbpP559.2]) (by linarith [vbpP560.2, vbpP559.1])
    ht0 ht1 (by norm_num) blkLin36
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

/-- Lower bound for `∫₀^∞ err(v) cos(tv) dv` on the band `5.159375 ≤ t ≤ 5.284375`. -/
theorem oscLinBand125 {t : ℝ} (ht0 : (5.159375:ℝ) ≤ t) (ht1 : t ≤ 5.284375) :
    ((-0.0847040726):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosLB125_0 ht0 ht1)
    (cosLB125_1 ht0 ht1))
    (cosLB125_2 ht0 ht1))
    (cosLB125_3 ht0 ht1))
    (cosLB125_4 ht0 ht1))
    (cosLB125_5 ht0 ht1))
    (cosLB125_6 ht0 ht1))
    (cosLB125_7 ht0 ht1))
    (cosLB125_8 ht0 ht1))
    (cosLB125_9 ht0 ht1))
    (cosLB125_10 ht0 ht1))
    (cosLB125_11 ht0 ht1))
    (cosLB125_12 ht0 ht1))
    (cosLB125_13 ht0 ht1))
    (cosLB125_14 ht0 ht1))
    (cosLB125_15 ht0 ht1))
    (cosLB125_16 ht0 ht1))
    (cosLB125_17 ht0 ht1))
    (cosLB125_18 ht0 ht1))
    (cosLB125_19 ht0 ht1))
    (cosLB125_20 ht0 ht1))
    (cosLB125_21 ht0 ht1))
    (cosLB125_22 ht0 ht1))
    (cosLB125_23 ht0 ht1))
    (cosLB125_24 ht0 ht1))
    (cosLB125_25 ht0 ht1))
    (cosLB125_26 ht0 ht1))
    (cosLB125_27 ht0 ht1))
    (cosLB125_28 ht0 ht1))
    (cosLB125_29 ht0 ht1))
    (cosLB125_30 ht0 ht1))
    (cosLB125_31 ht0 ht1))
    (cosLB125_32 ht0 ht1))
    (cosLB125_33 ht0 ht1))
    (cosLB125_34 ht0 ht1))
    (cosLB125_35 ht0 ht1))
    (cosLB125_36 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 2.094) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 2.094) (S := 0.013709)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_cut
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
