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
# Oscillatory lower bound on the band `1.64875 ≤ t ≤ 1.7425`

The partition now reaches `q = 5`; on each block the phase `tv` is linearised at
the base point and the signed contributions are summed.
-/

set_option maxHeartbeats 4000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosLBL9_0 {t : ℝ} (ht0 : (1.64875:ℝ) ≤ t) (ht1 : t ≤ 1.7425) :
    ((-0.0581720571):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.069), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.110251173) (ylo := 0.110251173) (yhi := 0.110251173) (j := (0:ℤ))
    (c0 := 0.9939284932) (c1 := 0.9939284933) (s0 := 0.1100279523) (s1 := 0.1100279524)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.64875) (t1 := 1.7425) (X0 := 0.110251173) (W := 0.0062691)
    ht0 ht1 vbpP115.1 vbpP115.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0062691) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.64875) (t1 := 1.7425) (d := 0.06686956)
    (ulo := 0.99321919) (uhi := 0.9939284933) (vlo := 0.1100257901) (vhi := 0.1162589488)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP0.1, vbpP115.2]) (by linarith [vbpP160.2, vbpP115.1])
    ht0 ht1 (by norm_num) blkLo0
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL9_1 {t : ℝ} (ht0 : (1.64875:ℝ) ≤ t) (ht1 : t ≤ 1.7425) :
    (0.0183811417:ℝ) ≤ ∫ v in (vBP 1.069)..(vBP 1.1455), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.335202922) (ylo := 0.335202922) (yhi := 0.335202922) (j := (0:ℤ))
    (c0 := 0.9443435756) (c1 := 0.9443435757) (s0 := 0.3289608047) (s1 := 0.3289608048)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.64875) (t1 := 1.7425) (X0 := 0.335202922) (W := 0.0190601)
    ht0 ht1 vbpP183.1 vbpP183.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0190601) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.64875) (t1 := 1.7425) (d := 0.06986005)
    (ulo := 0.9379024005) (uhi := 0.9443435757) (vlo := 0.3289010528) (vhi := 0.346958998)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP160.1, vbpP183.2]) (by linarith [vbpP228.2, vbpP183.1])
    ht0 ht1 (by norm_num) blkLo1
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL9_2 {t : ℝ} (ht0 : (1.64875:ℝ) ≤ t) (ht1 : t ≤ 1.7425) :
    (0.0336934513:ℝ) ≤ ∫ v in (vBP 1.1455)..(vBP 1.227), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.561117854) (ylo := 0.561117854) (yhi := 0.561117854) (j := (0:ℤ))
    (c0 := 0.8466607931) (c1 := 0.8466607941) (s0 := 0.5321329733) (s1 := 0.5321329734)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.64875) (t1 := 1.7425) (X0 := 0.561117854) (W := 0.0319059)
    ht0 ht1 vbpP308.1 vbpP308.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0319059) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.64875) (t1 := 1.7425) (d := 0.06881509)
    (ulo := 0.829254584) (uhi := 0.8466607941) (vlo := 0.5318621441) (vhi := 0.5591418651)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP228.1, vbpP308.2]) (by linarith [vbpP358.2, vbpP308.1])
    ht0 ht1 (by norm_num) blkLo2
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL9_3 {t : ℝ} (ht0 : (1.64875:ℝ) ≤ t) (ht1 : t ≤ 1.7425) :
    (0.0119488711:ℝ) ≤ ∫ v in (vBP 1.227)..(vBP 1.312), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.782961214) (ylo := 0.782961214) (yhi := 0.782961214) (j := (0:ℤ))
    (c0 := 0.7088278631) (c1 := 0.7088278871) (s0 := 0.7053814997) (s1 := 0.7053815015)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.64875) (t1 := 1.7425) (X0 := 0.782961214) (W := 0.0445202)
    ht0 ht1 vbpP397.1 vbpP397.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0445202) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.64875) (t1 := 1.7425) (d := 0.0682237)
    (ulo := 0.676732161) (uhi := 0.7088278871) (vlo := 0.704682565) (vhi := 0.7369282372)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP358.1, vbpP397.2]) (by linarith [vbpP416.2, vbpP397.1])
    ht0 ht1 (by norm_num) blkLo3
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL9_4 {t : ℝ} (ht0 : (1.64875:ℝ) ≤ t) (ht1 : t ≤ 1.7425) :
    ((-0.0053444707):ℝ) ≤ ∫ v in (vBP 1.312)..(vBP 1.406), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.009077819) (ylo := 1.009077819) (yhi := 1.009077819) (j := (0:ℤ))
    (c0 := 0.532641425) (c1 := 0.5326417267) (s0 := 0.8463410125) (s1 := 0.8463410403)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.64875) (t1 := 1.7425) (X0 := 1.009077819) (W := 0.0573778)
    ht0 ht1 vbpP428.1 vbpP428.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0573778) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.64875) (t1 := 1.7425) (d := 0.06947187)
    (ulo := 0.4832303355) (uhi := 0.5326417267) (vlo := 0.8449482276) (vhi := 0.8768860843)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP416.1, vbpP428.2]) (by linarith [vbpP449.2, vbpP428.1])
    ht0 ht1 (by norm_num) blkLo4
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL9_5 {t : ℝ} (ht0 : (1.64875:ℝ) ≤ t) (ht1 : t ≤ 1.7425) :
    ((-0.0041896704):ℝ) ≤ ∫ v in (vBP 1.406)..(vBP 1.504), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.232044839) (ylo := 1.232044839) (yhi := 1.232044839) (j := (0:ℤ))
    (c0 := 0.3323097664) (c1 := 0.3323119873) (s0 := 0.9431702909) (s1 := 0.9431705397)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.64875) (t1 := 1.7425) (X0 := 1.232044839) (W := 0.0700583)
    ht0 ht1 vbpP469.1 vbpP469.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0700583) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.64875) (t1 := 1.7425) (d := 0.06899838)
    (ulo := 0.2654716991) (uhi := 0.3323119873) (vlo := 0.9408566195) (vhi := 0.9664327126)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP449.1, vbpP469.2]) (by linarith [vbpP488.2, vbpP469.1])
    ht0 ht1 (by norm_num) blkLo5
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL9_6 {t : ℝ} (ht0 : (1.64875:ℝ) ≤ t) (ht1 : t ≤ 1.7425) :
    ((-0.0001926367):ℝ) ≤ ∫ v in (vBP 1.504)..(vBP 1.61), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.462112415) (ylo := 1.462112415) (yhi := 1.462112415) (j := (0:ℤ))
    (c0 := 0.1084698752) (c1 := 0.1084821793) (s0 := 0.9940996928) (s1 := 0.9941013283)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.64875) (t1 := 1.7425) (X0 := 1.462112415) (W := 0.0831549)
    ht0 ht1 vbpP502.1 vbpP502.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0831549) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.64875) (t1 := 1.7425) (d := 0.07055622)
    (ulo := 0.0255259085) (uhi := 0.1084821793) (vlo := 0.9906647036) (vhi := 1.0031117606)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP488.1, vbpP502.2]) (by linarith [vbpP515.2, vbpP502.1])
    ht0 ht1 (by norm_num) blkLo6
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL9_7 {t : ℝ} (ht0 : (1.64875:ℝ) ≤ t) (ht1 : t ≤ 1.7425) :
    (0.0000196695:ℝ) ≤ ∫ v in (vBP 1.61)..(vBP 1.719), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 1.679128954) (ylo := 0.108332627205) (yhi := 0.108332627206) (j := (0:ℤ))
    (c0 := (-0.1081208537)) (c1 := (-0.1081208536)) (s0 := 0.9941377575) (s1 := 0.9941377576)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.64875) (t1 := 1.7425) (X0 := 1.679128954) (W := 0.0955529)
    ht0 ht1 vbpP523.1 vbpP523.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0955529) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.64875) (t1 := 1.7425) (d := 0.06601185)
    (ulo := (-0.2029691125)) (uhi := (-0.107627638)) (vlo := 0.9792872464) (vhi := 0.9941377576)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP515.1, vbpP523.2]) (by linarith [vbpP530.2, vbpP523.1])
    ht0 ht1 (by norm_num) blkLo7
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL9_8 {t : ℝ} (ht0 : (1.64875:ℝ) ≤ t) (ht1 : t ≤ 1.7425) :
    ((-0.0001411249):ℝ) ≤ ∫ v in (vBP 1.719)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 1.890118307) (ylo := 0.319321980205) (yhi := 0.319321980206) (j := (0:ℤ))
    (c0 := (-0.313922888)) (c1 := (-0.3139228879)) (s0 := 0.9494484822) (s1 := 0.9494484823)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.64875) (t1 := 1.7425) (X0 := 1.890118307) (W := 0.1077313)
    ht0 ht1 vbpP537.1 vbpP537.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1077313) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.64875) (t1 := 1.7425) (d := 0.06310085)
    (ulo := (-0.4160104676)) (uhi := (-0.3121029494)) (vlo := 0.9101902029) (vhi := 0.9494484823)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP530.1, vbpP537.2]) (by linarith [vbpP543.2, vbpP537.1])
    ht0 ht1 (by norm_num) blkLo8
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL9_9 {t : ℝ} (ht0 : (1.64875:ℝ) ≤ t) (ht1 : t ≤ 1.7425) :
    ((-0.0017752585):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.954), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.098737875) (ylo := 0.527941548205) (yhi := 0.527941548206) (j := (0:ℤ))
    (c0 := (-0.5037562247)) (c1 := (-0.5037562246)) (s0 := 0.8638458578) (s1 := 0.8638458584)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.64875) (t1 := 1.7425) (X0 := 2.098737875) (W := 0.1200744)
    ht0 ht1 vbpP547.1 vbpP547.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1200744) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.64875) (t1 := 1.7425) (d := 0.06715513)
    (ulo := (-0.6072329269)) (uhi := (-0.500129042)) (vlo := 0.797282952) (vhi := 0.8638458584)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP543.1, vbpP547.2]) (by linarith [vbpP551.2, vbpP547.1])
    ht0 ht1 (by norm_num) blkLo9
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL9_10 {t : ℝ} (ht0 : (1.64875:ℝ) ≤ t) (ht1 : t ≤ 1.7425) :
    ((-0.0008142067):ℝ) ≤ ∫ v in (vBP 1.954)..(vBP 2.078), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.310963807) (ylo := 0.740167480205) (yhi := 0.740167480206) (j := (0:ℤ))
    (c0 := (-0.674411582)) (c1 := (-0.674411581)) (s0 := 0.7383556184) (s1 := 0.7383556321)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.64875) (t1 := 1.7425) (X0 := 2.310963807) (W := 0.1333053)
    ht0 ht1 vbpP555.1 vbpP555.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1333053) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.64875) (t1 := 1.7425) (d := 0.06335508)
    (ulo := (-0.7725470479)) (uhi := (-0.6684282003)) (vlo := 0.6421683175) (vhi := 0.7383556321)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP551.1, vbpP555.2]) (by linarith [vbpP559.2, vbpP555.1])
    ht0 ht1 (by norm_num) blkLo10
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL9_11 {t : ℝ} (ht0 : (1.64875:ℝ) ≤ t) (ht1 : t ≤ 1.7425) :
    ((-0.0015682634):ℝ) ≤ ∫ v in (vBP 2.078)..(vBP 2.17945), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.479703474) (ylo := 0.908907147205) (yhi := 0.908907147206) (j := (0:ℤ))
    (c0 := (-0.7888325434)) (c1 := (-0.7888325345)) (s0 := 0.6146081935) (s1 := 0.6146082996)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.64875) (t1 := 1.7425) (X0 := 2.479703474) (W := 0.1412895)
    ht0 ht1 vbpT1.1 vbpT1.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1412895) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.64875) (t1 := 1.7425) (d := 0.05422059)
    (ulo := (-0.8753816116)) (uhi := (-0.7809720014)) (vlo := 0.49740046) (vhi := 0.6146082996)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP559.1, vbpT1.2]) (by linarith [vbpT3.2, vbpT1.1])
    ht0 ht1 (by norm_num) blkLo11
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL9_12 {t : ℝ} (ht0 : (1.64875:ℝ) ≤ t) (ht1 : t ≤ 1.7425) :
    ((-0.0005721972):ℝ) ≤ ∫ v in (vBP 2.17945)..(vBP 2.2912884), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.65346052) (ylo := 1.082664193205) (yhi := 1.082664193206) (j := (0:ℤ))
    (c0 := (-0.8832104448)) (c1 := (-0.8832103847)) (s0 := 0.4689769828) (s1 := 0.4689775927)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.64875) (t1 := 1.7425) (X0 := 2.65346052) (W := 0.1510793)
    ht0 ht1 vbpT4.1 vbpT4.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1510793) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.64875) (t1 := 1.7425) (d := 0.05141957)
    (ulo := (-0.9537940234)) (uhi := (-0.8731499237)) (vlo := 0.3307071786) (vhi := 0.4689775927)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT3.1, vbpT4.2]) (by linarith [vbpT7.2, vbpT4.1])
    ht0 ht1 (by norm_num) blkLo12
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL9_13 {t : ℝ} (ht0 : (1.64875:ℝ) ≤ t) (ht1 : t ≤ 1.7425) :
    ((-0.0014757068):ℝ) ≤ ∫ v in (vBP 2.2912884)..(vBP 2.4494903), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.810583773) (ylo := 1.239787446205) (yhi := 1.239787446206) (j := (0:ℤ))
    (c0 := (-0.9457152053)) (c1 := (-0.9457149387)) (s0 := 0.3249972797) (s1 := 0.3249996442)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.64875) (t1 := 1.7425) (X0 := 2.810583773) (W := 0.1600564)
    ht0 ht1 vbpT9.1 vbpT9.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1600564) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.64875) (t1 := 1.7425) (d := 0.08716116)
    (ulo := (-0.9975116616)) (uhi := (-0.9336270905)) (vlo := 0.1701209534) (vhi := 0.3249996442)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT7.1, vbpT9.2]) (by linarith [vbpT13.2, vbpT9.1])
    ht0 ht1 (by norm_num) blkLo13
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL9_14 {t : ℝ} (ht0 : (1.64875:ℝ) ≤ t) (ht1 : t ≤ 1.7425) :
    ((-0.0009826391):ℝ) ≤ ∫ v in (vBP 2.4494903)..(vBP 2.5980768), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 3.021356196) (ylo := 1.450559869205) (yhi := 1.450559869206) (j := (0:ℤ))
    (c0 := (-0.9927817801)) (c1 := (-0.9927802812)) (s0 := 0.1199467819) (s1 := 0.1199581477)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.64875) (t1 := 1.7425) (X0 := 3.021356196) (W := 0.1720275)
    ht0 ht1 vbpT15.1 vbpT15.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1720275) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.64875) (t1 := 1.7425) (d := 0.07709944)
    (ulo := (-1.0133162486)) (uhi := (-0.9781265704)) (vlo := (-0.051768322)) (vhi := 0.1199581477)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT13.1, vbpT15.2]) (by linarith [vbpT19.2, vbpT15.1])
    ht0 ht1 (by norm_num) blkLo14
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL9_15 {t : ℝ} (ht0 : (1.64875:ℝ) ≤ t) (ht1 : t ≤ 1.7425) :
    ((-0.000776329):ℝ) ≤ ∫ v in (vBP 2.5980768)..(vBP 2.7838827), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 3.266041841) (ylo := 0.12444918741) (yhi := 0.124449187411) (j := (0:ℤ))
    (c0 := (-0.9922661892)) (c1 := (-0.9922661891)) (s0 := (-0.1241281996)) (s1 := (-0.1241281995))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.64875) (t1 := 1.7425) (X0 := 3.266041841) (W := 0.1859833)
    ht0 ht1 vbpT22.1 vbpT22.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1859833) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.64875) (t1 := 1.7425) (d := 0.07160879)
    (ulo := (-0.9922661892)) (uhi := (-0.9522015467)) (vlo := (-0.3076110834)) (vhi := (-0.1219875963))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT19.1, vbpT22.2]) (by linarith [vbpT27.2, vbpT22.1])
    ht0 ht1 (by norm_num) blkLo15
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL9_16 {t : ℝ} (ht0 : (1.64875:ℝ) ≤ t) (ht1 : t ≤ 1.7425) :
    ((-0.0005303666):ℝ) ≤ ∫ v in (vBP 2.7838827)..(vBP 2.9580404), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 3.479069015) (ylo := 0.33747636141) (yhi := 0.337476361411) (j := (0:ℤ))
    (c0 := (-0.9435932635)) (c1 := (-0.9435932634)) (s0 := (-0.3311068607)) (s1 := (-0.3311068606))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.64875) (t1 := 1.7425) (X0 := 3.479069015) (W := 0.1981189)
    ht0 ht1 vbpT30.1 vbpT30.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1981189) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.64875) (t1 := 1.7425) (d := 0.06268613)
    (ulo := (-0.9435932635)) (uhi := (-0.8599649881)) (vlo := (-0.5168299607)) (vhi := (-0.3246299337))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT27.1, vbpT30.2]) (by linarith [vbpT35.2, vbpT30.1])
    ht0 ht1 (by norm_num) blkLo16
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL9_17 {t : ℝ} (ht0 : (1.64875:ℝ) ≤ t) (ht1 : t ≤ 1.7425) :
    ((-0.0004149905):ℝ) ≤ ∫ v in (vBP 2.9580404)..(vBP 3.1622782), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 3.667701613) (ylo := 0.52610895941) (yhi := 0.526108959411) (j := (0:ℤ))
    (c0 := (-0.8647675853)) (c1 := (-0.8647675847)) (s0 := (-0.5021723055)) (s1 := (-0.5021723054))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.64875) (t1 := 1.7425) (X0 := 3.667701613) (W := 0.2088509)
    ht0 ht1 vbpT39.1 vbpT39.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.2088509) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.64875) (t1 := 1.7425) (d := 0.07811905)
    (ulo := (-0.8647675853)) (uhi := (-0.7418576704)) (vlo := (-0.6814696773)) (vhi := (-0.4912600059))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT35.1, vbpT39.2]) (by linarith [vbpT45.2, vbpT39.1])
    ht0 ht1 (by norm_num) blkLo17
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL9_18 {t : ℝ} (ht0 : (1.64875:ℝ) ≤ t) (ht1 : t ≤ 1.7425) :
    ((-0.0002758646):ℝ) ≤ ∫ v in (vBP 3.1622782)..(vBP 3.3541025), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 3.876712155) (ylo := 0.73511950141) (yhi := 0.735119501411) (j := (0:ℤ))
    (c0 := (-0.7417506247)) (c1 := (-0.7417506119)) (s0 := (-0.6706758016)) (s1 := (-0.6706758006))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.64875) (t1 := 1.7425) (X0 := 3.876712155) (W := 0.2206776)
    ht0 ht1 vbpT49.1 vbpT49.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.2206776) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.64875) (t1 := 1.7425) (d := 0.06914293)
    (ulo := (-0.7417506247)) (uhi := (-0.5769578893)) (vlo := (-0.8330382197)) (vhi := (-0.6544114784))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT45.1, vbpT49.2]) (by linarith [vbpT55.2, vbpT49.1])
    ht0 ht1 (by norm_num) blkLo18
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL9_19 {t : ℝ} (ht0 : (1.64875:ℝ) ≤ t) (ht1 : t ≤ 1.7425) :
    ((-0.0002537012):ℝ) ≤ ∫ v in (vBP 3.3541025)..(vBP 3.5707148), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 4.096835118) (ylo := 0.95524246441) (yhi := 0.955242464411) (j := (0:ℤ))
    (c0 := (-0.577410987)) (c1 := (-0.5774108126)) (s0 := (-0.8164537811)) (s1 := (-0.8164537659))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.64875) (t1 := 1.7425) (X0 := 4.096835118) (W := 0.2332683)
    ht0 ht1 vbpT60.1 vbpT60.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.2332683) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.64875) (t1 := 1.7425) (d := 0.0647093)
    (ulo := (-0.577410987)) (uhi := (-0.373042015)) (vlo := (-0.9499272585)) (vhi := (-0.7943410114))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT55.1, vbpT60.2]) (by linarith [vbpT67.2, vbpT60.1])
    ht0 ht1 (by norm_num) blkLo19
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL9_20 {t : ℝ} (ht0 : (1.64875:ℝ) ≤ t) (ht1 : t ≤ 1.7425) :
    ((-0.0001329245):ℝ) ≤ ∫ v in (vBP 3.5707148)..(vBP 3.8078871), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 4.291050967) (ylo := 1.14945831341) (yhi := 1.149458313411) (j := (0:ℤ))
    (c0 := (-0.4089829115)) (c1 := (-0.4089818018)) (s0 := (-0.9125426492)) (s1 := (-0.9125425332))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.64875) (t1 := 1.7425) (X0 := 4.291050967) (W := 0.244271)
    ht0 ht1 vbpT73.1 vbpT73.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.244271) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.64875) (t1 := 1.7425) (d := 0.0716348)
    (ulo := (-0.4089829115)) (uhi := (-0.1761431685)) (vlo := (-1.0114547698)) (vhi := (-0.8854526958))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT67.1, vbpT73.2]) (by linarith [vbpT81.2, vbpT73.1])
    ht0 ht1 (by norm_num) blkLo20
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL9_21 {t : ℝ} (ht0 : (1.64875:ℝ) ≤ t) (ht1 : t ≤ 1.7425) :
    ((-0.0000825936):ℝ) ≤ ∫ v in (vBP 3.8078871)..(vBP 4.0620198), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 4.518814845) (ylo := 1.37722219141) (yhi := 1.377222191411) (j := (0:ℤ))
    (c0 := (-0.1923741663)) (c1 := (-0.1923674011)) (s0 := (-0.9813237939)) (s1 := (-0.9813229468))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.64875) (t1 := 1.7425) (X0 := 4.518814845) (W := 0.2572442)
    ht0 ht1 vbpT88.1 vbpT88.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.2572442) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.64875) (t1 := 1.7425) (d := 0.06687385)
    (ulo := (-0.1923741663)) (uhi := 0.0636273609) (vlo := (-1.0302669371)) (vhi := (-0.9490322897))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT81.1, vbpT88.2]) (by linarith [vbpT97.2, vbpT88.1])
    ht0 ht1 (by norm_num) blkLo21
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL9_22 {t : ℝ} (ht0 : (1.64875:ℝ) ≤ t) (ht1 : t ≤ 1.7425) :
    ((-0.0000494191):ℝ) ≤ ∫ v in (vBP 4.0620198)..(vBP 4.3301276), errFun v * Real.cos (t * v) := by
  have hp := trigPoint3 (X := 4.718907484) (ylo := 0.006518503615) (yhi := 0.006518503616) (j := (0:ℤ))
    (c0 := 0.0065184574) (c1 := 0.0065184575) (s0 := (-0.9999787547)) (s1 := (-0.9999787546))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.64875) (t1 := 1.7425) (X0 := 4.718907484) (W := 0.2686263)
    ht0 ht1 vbpT105.1 vbpT105.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.2686263) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.64875) (t1 := 1.7425) (d := 0.0691632)
    (ulo := 0.006284682) (uhi := 0.2719200723) (vlo := (-0.9999787547)) (vhi := (-0.9623858665))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT97.1, vbpT105.2]) (by linarith [vbpT115.2, vbpT105.1])
    ht0 ht1 (by norm_num) blkLo22
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL9_23 {t : ℝ} (ht0 : (1.64875:ℝ) ≤ t) (ht1 : t ≤ 1.7425) :
    ((-0.0000618488):ℝ) ≤ ∫ v in (vBP 4.3301276)..(vBP 4.6368098), errFun v * Real.cos (t * v) := by
  have hp := trigPoint3 (X := 4.939081797) (ylo := 0.226692816615) (yhi := 0.226692816616) (j := (0:ℤ))
    (c0 := 0.2247561893) (c1 := 0.2247561894) (s0 := (-0.9744150324)) (s1 := (-0.9744150323))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.64875) (t1 := 1.7425) (X0 := 4.939081797) (W := 0.2811163)
    ht0 ht1 vbpT125.1 vbpT125.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.2811163) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.64875) (t1 := 1.7425) (d := 0.07247932)
    (ulo := 0.2159336871) (uhi := 0.4950864977) (vlo := (-0.9744150324)) (vhi := (-0.8738119515))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT115.1, vbpT125.2]) (by linarith [vbpT137.2, vbpT125.1])
    ht0 ht1 (by norm_num) blkLo23
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL9_24 {t : ℝ} (ht0 : (1.64875:ℝ) ≤ t) (ht1 : t ≤ 1.7425) :
    ((-0.0000562294):ℝ) ≤ ∫ v in (vBP 4.6368098)..(vBP 4.949748), errFun v * Real.cos (t * v) := by
  have hp := trigPoint3 (X := 5.169511067) (ylo := 0.457122086615) (yhi := 0.457122086616) (j := (0:ℤ))
    (c0 := 0.4413675105) (c1 := 0.4413675106) (s0 := (-0.8973264294)) (s1 := (-0.8973264292))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.64875) (t1 := 1.7425) (X0 := 5.169511067) (W := 0.2942244)
    ht0 ht1 vbpT148.1 vbpT148.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.2942244) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.64875) (t1 := 1.7425) (d := 0.06760111)
    (ulo := 0.4224007799) (uhi := 0.7015900817) (vlo := (-0.8973264294)) (vhi := (-0.7307703883))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT137.1, vbpT148.2]) (by linarith [vbpT161.2, vbpT148.1])
    ht0 ht1 (by norm_num) blkLo24
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL9_25 {t : ℝ} (ht0 : (1.64875:ℝ) ≤ t) (ht1 : t ≤ 1.7425) :
    ((-0.0000082257):ℝ) ≤ ∫ v in (vBP 4.949748)..(vBP 5), errFun v * Real.cos (t * v) := by
  have hp := trigPoint3 (X := 5.290407771) (ylo := 0.578018790615) (yhi := 0.578018790616) (j := (0:ℤ))
    (c0 := 0.5463656546) (c1 := 0.5463656548) (s0 := (-0.8375467589)) (s1 := (-0.8375467577))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.64875) (t1 := 1.7425) (X0 := 5.290407771) (W := 0.3011159)
    ht0 ht1 vbpT162.1 vbpT162.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.3011159) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.64875) (t1 := 1.7425) (d := 0.01033663)
    (ulo := 0.5217825457) (uhi := 0.7947703669) (vlo := (-0.8375467589)) (vhi := (-0.637817833))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT161.1, vbpT162.2]) (by linarith [vbpT165.2, vbpT162.1])
    ht0 ht1 (by norm_num) blkLo25
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

/-- Lower bound for `∫₀^∞ err(v) cos(tv) dv` on the band `1.64875 ≤ t ≤ 1.7425`. -/
theorem oscLowBand9 {t : ℝ} (ht0 : (1.64875:ℝ) ≤ t) (ht1 : t ≤ 1.7425) :
    ((-0.0160275909):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosLBL9_0 ht0 ht1)
    (cosLBL9_1 ht0 ht1))
    (cosLBL9_2 ht0 ht1))
    (cosLBL9_3 ht0 ht1))
    (cosLBL9_4 ht0 ht1))
    (cosLBL9_5 ht0 ht1))
    (cosLBL9_6 ht0 ht1))
    (cosLBL9_7 ht0 ht1))
    (cosLBL9_8 ht0 ht1))
    (cosLBL9_9 ht0 ht1))
    (cosLBL9_10 ht0 ht1))
    (cosLBL9_11 ht0 ht1))
    (cosLBL9_12 ht0 ht1))
    (cosLBL9_13 ht0 ht1))
    (cosLBL9_14 ht0 ht1))
    (cosLBL9_15 ht0 ht1))
    (cosLBL9_16 ht0 ht1))
    (cosLBL9_17 ht0 ht1))
    (cosLBL9_18 ht0 ht1))
    (cosLBL9_19 ht0 ht1))
    (cosLBL9_20 ht0 ht1))
    (cosLBL9_21 ht0 ht1))
    (cosLBL9_22 ht0 ht1))
    (cosLBL9_23 ht0 ht1))
    (cosLBL9_24 ht0 ht1))
    (cosLBL9_25 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 5) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 5) (S := 0.0022)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_five
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
