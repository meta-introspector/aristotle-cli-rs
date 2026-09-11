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
# Oscillatory lower bound on the band `3.1125 ≤ t ≤ 3.128125`

On each block the phase `t v` is linearised at the base point, so that the error is
quadratic in the block width; the signed contributions are then summed and the
unresolved tail beyond `q = 2.094` is estimated in absolute value.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosLB84_0 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    ((-0.0319000875):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.0228), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.069332456) (ylo := 0.069332456) (yhi := 0.069332456) (j := (0:ℤ))
    (c0 := 0.9975974679) (c1 := 0.997597468) (s0 := 0.0692769226) (s1 := 0.0692769227)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 0.069332456) (W := 0.0003481)
    ht0 ht1 vbpP45.1 vbpP45.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0003481) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.02281245)
    (ulo := 0.9975732921) (uhi := 0.997597468) (vlo := 0.0692769184) (vhi := 0.0696241864)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP0.1, vbpP45.2]) (by linarith [vbpP91.2, vbpP45.1])
    ht0 ht1 (by norm_num) blkLin0
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_1 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    ((-0.0180878458):ℝ) ≤ ∫ v in (vBP 1.0228)..(vBP 1.046), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.211140907) (ylo := 0.211140907) (yhi := 0.211140907) (j := (0:ℤ))
    (c0 := 0.9777924448) (c1 := 0.9777924449) (s0 := 0.2095756062) (s1 := 0.2095756063)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 0.211140907) (W := 0.00106)
    ht0 ht1 vbpP116.1 vbpP116.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.00106) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.02274851)
    (ulo := 0.9775697453) (uhi := 0.9777924449) (vlo := 0.2095754884) (vhi := 0.2106120661)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP91.1, vbpP116.2]) (by linarith [vbpP139.2, vbpP116.1])
    ht0 ht1 (by norm_num) blkLin1
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_2 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    ((-0.007175308):ℝ) ≤ ∫ v in (vBP 1.046)..(vBP 1.069), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.345081047) (ylo := 0.345081047) (yhi := 0.345081047) (j := (0:ℤ))
    (c0 := 0.9410480396) (c1 := 0.9410480397) (s0 := 0.3382729474) (s1 := 0.3382729475)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 0.345081047) (W := 0.0017324)
    ht0 ht1 vbpP151.1 vbpP151.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0017324) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.02257786)
    (ulo := 0.9404606036) (uhi := 0.9410480397) (vlo := 0.3382724397) (vhi := 0.3399032184)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP139.1, vbpP151.2]) (by linarith [vbpP160.2, vbpP151.1])
    ht0 ht1 (by norm_num) blkLin2
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_3 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    (0.0000530329:ℝ) ≤ ∫ v in (vBP 1.069)..(vBP 1.092), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.47908248) (ylo := 0.47908248) (yhi := 0.47908248) (j := (0:ℤ))
    (c0 := 0.8874182409) (c1 := 0.8874182412) (s0 := 0.4609651457) (s1 := 0.4609651458)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 0.47908248) (W := 0.0024051)
    ht0 ht1 vbpP164.1 vbpP164.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0024051) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.02209968)
    (ulo := 0.886307008) (uhi := 0.8874182412) (vlo := 0.4609638124) (vhi := 0.4630994734)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP160.1, vbpP164.2]) (by linarith [vbpP169.2, vbpP164.1])
    ht0 ht1 (by norm_num) blkLin3
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_4 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    (0.0056829935:ℝ) ≤ ∫ v in (vBP 1.092)..(vBP 1.117), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.615901173) (ylo := 0.615901173) (yhi := 0.615901173) (j := (0:ℤ))
    (c0 := 0.8162531758) (c1 := 0.8162531781) (s0 := 0.577694342) (s1 := 0.5776943423)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 0.615901173) (W := 0.0030919)
    ht0 ht1 vbpP180.1 vbpP180.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0030919) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.02341315)
    (ulo := 0.8144631038) (uhi := 0.8162531781) (vlo := 0.5776915806) (vhi := 0.5802181115)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP169.1, vbpP180.2]) (by linarith [vbpP193.2, vbpP180.1])
    ht0 ht1 (by norm_num) blkLin4
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_5 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    (0.0082216182:ℝ) ≤ ∫ v in (vBP 1.117)..(vBP 1.1425), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.760804762) (ylo := 0.760804762) (yhi := 0.760804762) (j := (0:ℤ))
    (c0 := 0.7242813582) (c1 := 0.7242813762) (s0 := 0.6895045424) (s1 := 0.6895045437)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 0.760804762) (W := 0.0038194)
    ht0 ht1 vbpP206.1 vbpP206.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0038194) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.02314223)
    (ulo := 0.7216425881) (uhi := 0.7242813762) (vlo := 0.6894995132) (vhi := 0.6922708573)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP193.1, vbpP206.2]) (by linarith [vbpP222.2, vbpP206.1])
    ht0 ht1 (by norm_num) blkLin5
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_6 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    (0.0084950758:ℝ) ≤ ∫ v in (vBP 1.1425)..(vBP 1.1685), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.899718861) (ylo := 0.899718861) (yhi := 0.899718861) (j := (0:ℤ))
    (c0 := 0.6218301668) (c1 := 0.6218302627) (s0 := 0.7831521198) (s1 := 0.7831521277)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 0.899718861) (W := 0.0045167)
    ht0 ht1 vbpP248.1 vbpP248.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0045167) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.02262862)
    (ulo := 0.6182865727) (uhi := 0.6218302627) (vlo := 0.7831441314) (vhi := 0.7859607389)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP222.1, vbpP248.2]) (by linarith [vbpP274.2, vbpP248.1])
    ht0 ht1 (by norm_num) blkLin6
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_7 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    (0.0070349891:ℝ) ≤ ∫ v in (vBP 1.1685)..(vBP 1.195), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.038235488) (ylo := 1.038235488) (yhi := 1.038235488) (j := (0:ℤ))
    (c0 := 0.5077411877) (c1 := 0.5077415888) (s0 := 0.8615096531) (s1 := 0.8615096911)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 1.038235488) (W := 0.0052121)
    ht0 ht1 vbpP300.1 vbpP300.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0052121) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.02272274)
    (ulo := 0.5032440367) (uhi := 0.5077415888) (vlo := 0.8614979512) (vhi := 0.8641560791)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP274.1, vbpP300.2]) (by linarith [vbpP326.2, vbpP300.1])
    ht0 ht1 (by norm_num) blkLin7
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_8 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    (0.0047169725:ℝ) ≤ ∫ v in (vBP 1.195)..(vBP 1.222), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.176313966) (ylo := 1.176313966) (yhi := 1.176313966) (j := (0:ℤ))
    (c0 := 0.3843303435) (c1 := 0.3843317415) (s0 := 0.9231956311) (s1 := 0.9231957807)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 1.176313966) (W := 0.0059052)
    ht0 ht1 vbpP339.1 vbpP339.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0059052) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.02304553)
    (ulo := 0.3788720184) (uhi := 0.3843317415) (vlo := 0.9231795345) (vhi := 0.9254653234)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP326.1, vbpP339.2]) (by linarith [vbpP353.2, vbpP339.1])
    ht0 ht1 (by norm_num) blkLin8
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_9 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    (0.0024572752:ℝ) ≤ ∫ v in (vBP 1.222)..(vBP 1.25), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.318955228) (ylo := 1.318955228) (yhi := 1.318955228) (j := (0:ℤ))
    (c0 := 0.2491873451) (c1 := 0.2491917359) (s0 := 0.9684552788) (s1 := 0.9684558054)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 1.318955228) (W := 0.0066213)
    ht0 ht1 vbpP367.1 vbpP367.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0066213) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.022783)
    (ulo := 0.2427694931) (uhi := 0.2491917359) (vlo := 0.9684340495) (vhi := 0.9701057666)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP353.1, vbpP367.2]) (by linarith [vbpP381.2, vbpP367.1])
    ht0 ht1 (by norm_num) blkLin9
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_10 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    (0.0006959801:ℝ) ≤ ∫ v in (vBP 1.25)..(vBP 1.278), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.458401052) (ylo := 1.458401052) (yhi := 1.458401052) (j := (0:ℤ))
    (c0 := 0.1121585905) (c1 := 0.1121705858) (s0 := 0.9936902762) (s1 := 0.9936918666)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 1.458401052) (W := 0.0073214)
    ht0 ht1 vbpP395.1 vbpP395.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0073214) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.0222755)
    (ulo := 0.1048804338) (uhi := 0.1121705858) (vlo := 0.9936636439) (vhi := 0.994513105)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP381.1, vbpP395.2]) (by linarith [vbpP403.2, vbpP395.1])
    ht0 ht1 (by norm_num) blkLin10
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_11 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    ((-0.0000773834):ℝ) ≤ ∫ v in (vBP 1.278)..(vBP 1.303), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 1.580320322) (ylo := 0.009523995205) (yhi := 0.009523995206) (j := (0:ℤ))
    (c0 := (-0.0095238513)) (c1 := (-0.0095238512)) (s0 := 0.9999546471) (s1 := 0.9999546472)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 1.580320322) (W := 0.0079334)
    ht0 ht1 vbpP408.1 vbpP408.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0079334) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.02160518)
    (ulo := (-0.0174568083)) (uhi := (-0.0095235514)) (vlo := 0.9998476235) (vhi := 0.9999546472)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP403.1, vbpP408.2]) (by linarith [vbpP414.2, vbpP408.1])
    ht0 ht1 (by norm_num) blkLin11
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_12 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    ((-0.0002013045):ℝ) ≤ ∫ v in (vBP 1.303)..(vBP 1.331), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 1.714093649) (ylo := 0.143297322205) (yhi := 0.143297322206) (j := (0:ℤ))
    (c0 := (-0.1428074114)) (c1 := (-0.1428074113)) (s0 := 0.9897504954) (s1 := 0.9897504955)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 1.714093649) (W := 0.0086051)
    ht0 ht1 vbpP417.1 vbpP417.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0086051) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.02137429)
    (ulo := (-0.1513242083)) (uhi := (-0.142802124)) (vlo := 0.9884849943) (vhi := 0.9897504955)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP414.1, vbpP417.2]) (by linarith [vbpP420.2, vbpP417.1])
    ht0 ht1 (by norm_num) blkLin12
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_13 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    (0.0004438272:ℝ) ≤ ∫ v in (vBP 1.331)..(vBP 1.36), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 1.845052541) (ylo := 0.274256214205) (yhi := 0.274256214206) (j := (0:ℤ))
    (c0 := (-0.2708310238)) (c1 := (-0.2708310237)) (s0 := 0.9626269041) (s1 := 0.9626269042)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 1.845052541) (W := 0.0092627)
    ht0 ht1 vbpP423.1 vbpP423.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0092627) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.02218152)
    (ulo := (-0.2797474206)) (uhi := (-0.2708194054)) (vlo := 0.9600770181) (vhi := 0.9626269042)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP420.1, vbpP423.2]) (by linarith [vbpP429.2, vbpP423.1])
    ht0 ht1 (by norm_num) blkLin13
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_14 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    (0.0014505914:ℝ) ≤ ∫ v in (vBP 1.36)..(vBP 1.39), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 1.97784514) (ylo := 0.407048813205) (yhi := 0.407048813206) (j := (0:ℤ))
    (c0 := (-0.3959010013)) (c1 := (-0.3959010012)) (s0 := 0.9182931978) (s1 := 0.9182931979)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 1.97784514) (W := 0.0099298)
    ht0 ht1 vbpP435.1 vbpP435.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0099298) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.02315542)
    (ulo := (-0.4050193193)) (uhi := (-0.3958814832)) (vlo := 0.9143167727) (vhi := 0.9182931979)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP429.1, vbpP435.2]) (by linarith [vbpP442.2, vbpP435.1])
    ht0 ht1 (by norm_num) blkLin14
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_15 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    (0.0021494411:ℝ) ≤ ∫ v in (vBP 1.39)..(vBP 1.42), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.112299155) (ylo := 0.541502828205) (yhi := 0.541502828206) (j := (0:ℤ))
    (c0 := (-0.5154243995)) (c1 := (-0.5154243993)) (s0 := 0.856935055) (s1 := 0.8569350557)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 2.112299155) (W := 0.0106056)
    ht0 ht1 vbpP448.1 vbpP448.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0106056) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.02266377)
    (ulo := (-0.5245125396)) (uhi := (-0.5153954124)) (vlo := 0.8514205794) (vhi := 0.8569350557)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP442.1, vbpP448.2]) (by linarith [vbpP455.2, vbpP448.1])
    ht0 ht1 (by norm_num) blkLin15
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_16 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    (0.0023208826:ℝ) ≤ ∫ v in (vBP 1.42)..(vBP 1.45), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.243909978) (ylo := 0.673113651205) (yhi := 0.673113651206) (j := (0:ℤ))
    (c0 := (-0.6234235206)) (c1 := (-0.6234235201)) (s0 := 0.7818843357) (s1 := 0.781884341)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 2.243909978) (W := 0.0112679)
    ht0 ht1 vbpP461.1 vbpP461.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0112679) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.02219285)
    (ulo := (-0.6322335288)) (uhi := (-0.6233839438)) (vlo := 0.7748101747) (vhi := 0.781884341)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP455.1, vbpP461.2]) (by linarith [vbpP468.2, vbpP461.1])
    ht0 ht1 (by norm_num) blkLin16
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_17 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    (0.0018538123:ℝ) ≤ ∫ v in (vBP 1.45)..(vBP 1.481), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.372795096) (ylo := 0.801998769205) (yhi := 0.801998769206) (j := (0:ℤ))
    (c0 := (-0.7187472152)) (c1 := (-0.7187472129)) (s0 := 0.6952714891) (s1 := 0.6952715196)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 2.372795096) (W := 0.0119176)
    ht0 ht1 vbpP474.1 vbpP474.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0119176) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.0230925)
    (ulo := (-0.727032987)) (uhi := (-0.7186961719)) (vlo := 0.6866565762) (vhi := 0.6952715196)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP468.1, vbpP474.2]) (by linarith [vbpP480.2, vbpP474.1])
    ht0 ht1 (by norm_num) blkLin17
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_18 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    (0.000732223:ℝ) ≤ ∫ v in (vBP 1.481)..(vBP 1.512), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.503229889) (ylo := 0.932433562205) (yhi := 0.932433562206) (j := (0:ℤ))
    (c0 := (-0.8030724435)) (c1 := (-0.8030724318)) (s0 := 0.595881421) (s1 := 0.595881558)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 2.503229889) (W := 0.0125772)
    ht0 ht1 vbpP485.1 vbpP485.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0125772) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.02261815)
    (ulo := (-0.8105667675)) (uhi := (-0.8030089152)) (vlo := 0.5857341551) (vhi := 0.595881558)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP480.1, vbpP485.2]) (by linarith [vbpP490.2, vbpP485.1])
    ht0 ht1 (by norm_num) blkLin18
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_19 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    ((-0.0002823165):ℝ) ≤ ∫ v in (vBP 1.512)..(vBP 1.546), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.639138839) (ylo := 1.068342512205) (yhi := 1.068342512206) (j := (0:ℤ))
    (c0 := (-0.8764035512)) (c1 := (-0.8764034992)) (s0 := 0.4815775133) (s1 := 0.4815780472)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 2.639138839) (W := 0.0132679)
    ht0 ht1 vbpP494.1 vbpP494.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0132679) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.02342962)
    (ulo := (-0.8827928932)) (uhi := (-0.8763263605)) (vlo := 0.4699074326) (vhi := 0.4815780472)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP490.1, vbpP494.2]) (by linarith [vbpP499.2, vbpP494.1])
    ht0 ht1 (by norm_num) blkLin19
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_20 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    ((-0.0010318116):ℝ) ≤ ∫ v in (vBP 1.546)..(vBP 1.578), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.77612721) (ylo := 1.205330883205) (yhi := 1.205330883206) (j := (0:ℤ))
    (c0 := (-0.9339577139)) (c1 := (-0.9339575184)) (s0 := 0.3573840182) (s1 := 0.3573858019)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 2.77612721) (W := 0.0139695)
    ht0 ht1 vbpP503.1 vbpP503.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0139695) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.02060152)
    (ulo := (-0.9389500525)) (uhi := (-0.9338663904)) (vlo := 0.3443026496) (vhi := 0.3573858019)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP499.1, vbpP503.2]) (by linarith [vbpP507.2, vbpP503.1])
    ht0 ht1 (by norm_num) blkLin20
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_21 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    ((-0.0012712058):ℝ) ≤ ∫ v in (vBP 1.578)..(vBP 1.614), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.902356487) (ylo := 1.331560160205) (yhi := 1.331560160206) (j := (0:ℤ))
    (c0 := (-0.9715198347)) (c1 := (-0.97151925)) (s0 := 0.2369605525) (s1 := 0.2369653814)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 2.902356487) (W := 0.0146234)
    ht0 ht1 vbpP511.1 vbpP511.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0146234) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.02495758)
    (ulo := (-0.9749849508)) (uhi := (-0.9714153751)) (vlo := 0.2227287998) (vhi := 0.2369653814)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP507.1, vbpP511.2]) (by linarith [vbpP516.2, vbpP511.1])
    ht0 ht1 (by norm_num) blkLin21
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_22 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    ((-0.0006608228):ℝ) ≤ ∫ v in (vBP 1.614)..(vBP 1.648), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 3.048995892) (ylo := 1.478199565205) (yhi := 1.478199565206) (j := (0:ℤ))
    (c0 := (-0.9957178013)) (c1 := (-0.9957159566)) (s0 := 0.0924642705) (s1 := 0.0924779973)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 3.048995892) (W := 0.0153962)
    ht0 ht1 vbpP519.1 vbpP519.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0153962) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.02220681)
    (ulo := (-0.9971415548)) (uhi := (-0.9955979451)) (vlo := 0.0771236469) (vhi := 0.0924779973)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP516.1, vbpP519.2]) (by linarith [vbpP521.2, vbpP519.1])
    ht0 ht1 (by norm_num) blkLin22
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_23 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    ((-0.00013135):ℝ) ≤ ∫ v in (vBP 1.648)..(vBP 1.68), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 3.1698492) (ylo := 0.02825654641) (yhi := 0.028256546411) (j := (0:ℤ))
    (c0 := (-0.9996008104)) (c1 := (-0.9996008103)) (s0 := (-0.0282527865)) (s1 := (-0.0282527864))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 3.1698492) (W := 0.0160484)
    ht0 ht1 vbpP523.1 vbpP523.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0160484) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.01936289)
    (ulo := (-0.9996008104)) (uhi := (-0.9990186963)) (vlo := (-0.0442940916)) (vhi := (-0.0282491482))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP521.1, vbpP523.2]) (by linarith [vbpP525.2, vbpP523.1])
    ht0 ht1 (by norm_num) blkLin23
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_24 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    (0.0008088117:ℝ) ≤ ∫ v in (vBP 1.68)..(vBP 1.712), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 3.288390443) (ylo := 0.14679778941) (yhi := 0.146797789411) (j := (0:ℤ))
    (c0 := (-0.98924454)) (c1 := (-0.9892445399)) (s0 := (-0.1462711185)) (s1 := (-0.1462711184))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 3.288390443) (W := 0.0167067)
    ht0 ht1 vbpP527.1 vbpP527.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0167067) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.01901515)
    (ulo := (-0.98924454)) (uhi := (-0.9866628931)) (vlo := (-0.1627973615)) (vhi := (-0.1462507057))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP525.1, vbpP527.2]) (by linarith [vbpP529.2, vbpP527.1])
    ht0 ht1 (by norm_num) blkLin24
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_25 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    (0.000677233:ℝ) ≤ ∫ v in (vBP 1.712)..(vBP 1.75), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 3.426269923) (ylo := 0.28467726941) (yhi := 0.284677269411) (j := (0:ℤ))
    (c0 := (-0.9597523408)) (c1 := (-0.9597523407)) (s0 := (-0.2808477245)) (s1 := (-0.2808477244))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 3.426269923) (W := 0.0175042)
    ht0 ht1 vbpP532.1 vbpP532.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0175042) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.02562316)
    (ulo := (-0.9597523408)) (uhi := (-0.9546895481)) (vlo := (-0.2976465636)) (vhi := (-0.2808047))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP529.1, vbpP532.2]) (by linarith [vbpP534.2, vbpP532.1])
    ht0 ht1 (by norm_num) blkLin25
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_26 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    (0.0006478886:ℝ) ≤ ∫ v in (vBP 1.75)..(vBP 1.788), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 3.540037046) (ylo := 0.39844439241) (yhi := 0.398444392411) (j := (0:ℤ))
    (c0 := (-0.9216656615)) (c1 := (-0.9216656614)) (s0 := (-0.3879850623)) (s1 := (-0.3879850622))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 3.540037046) (W := 0.0181964)
    ht0 ht1 vbpP536.1 vbpP536.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0181964) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.0249125)
    (ulo := (-0.9216656615)) (uhi := (-0.9144535379)) (vlo := (-0.4047551339)) (vhi := (-0.3879208313))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP534.1, vbpP536.2]) (by linarith [vbpP539.2, vbpP536.1])
    ht0 ht1 (by norm_num) blkLin26
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_27 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    ((-0.0003818619):ℝ) ≤ ∫ v in (vBP 1.788)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 3.672460213) (ylo := 0.53086755941) (yhi := 0.530867559411) (j := (0:ℤ))
    (c0 := (-0.8623681662)) (c1 := (-0.8623681656)) (s0 := (-0.5062816873)) (s1 := (-0.5062816872))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 3.672460213) (W := 0.0190539)
    ht0 ht1 vbpP541.1 vbpP541.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0190539) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.02665257)
    (ulo := (-0.8623681662)) (uhi := (-0.8525655715)) (vlo := (-0.5227121699)) (vhi := (-0.5061897869))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP539.1, vbpP541.2]) (by linarith [vbpP543.2, vbpP541.1])
    ht0 ht1 (by norm_num) blkLin27
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_28 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    ((-0.0006067919):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.86), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 3.808832222) (ylo := 0.66723956841) (yhi := 0.667239568411) (j := (0:ℤ))
    (c0 := (-0.7855328715)) (c1 := (-0.7855328666)) (s0 := (-0.6188199381)) (s1 := (-0.6188199377))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 3.808832222) (W := 0.0200133)
    ht0 ht1 vbpP544.1 vbpP544.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0200133) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.01769411)
    (ulo := (-0.7855328715)) (uhi := (-0.7729917539)) (vlo := (-0.6345399937)) (vhi := (-0.6186960131))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP543.1, vbpP544.2]) (by linarith [vbpP545.2, vbpP544.1])
    ht0 ht1 (by norm_num) blkLin28
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_29 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    ((-0.0006413612):ℝ) ≤ ∫ v in (vBP 1.86)..(vBP 1.89), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 3.912465645) (ylo := 0.77087299141) (yhi := 0.770872991411) (j := (0:ℤ))
    (c0 := (-0.7173026964)) (c1 := (-0.7173026759)) (s0 := (-0.6967617046)) (s1 := (-0.6967617031))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 3.912465645) (W := 0.0208089)
    ht0 ht1 vbpP546.1 vbpP546.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0208089) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.01641361)
    (ulo := (-0.7173026964)) (uhi := (-0.7026495834)) (vlo := (-0.7116869075)) (vhi := (-0.696610856))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP545.1, vbpP546.2]) (by linarith [vbpP547.2, vbpP546.1])
    ht0 ht1 (by norm_num) blkLin29
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_30 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    ((-0.0005291133):ℝ) ≤ ∫ v in (vBP 1.89)..(vBP 1.922), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 4.014362515) (ylo := 0.87276986141) (yhi := 0.872769861411) (j := (0:ℤ))
    (c0 := (-0.6427070614)) (c1 := (-0.6427069907)) (s0 := (-0.7661120885)) (s1 := (-0.7661120828))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 4.014362515) (W := 0.0216609)
    ht0 ht1 vbpP548.1 vbpP548.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0216609) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.01731057)
    (ulo := (-0.6427070614)) (uhi := (-0.6259628395)) (vlo := (-0.7800326133)) (vhi := (-0.765932362))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP547.1, vbpP548.2]) (by linarith [vbpP549.2, vbpP548.1])
    ht0 ht1 (by norm_num) blkLin30
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_31 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    ((-0.0004092206):ℝ) ≤ ∫ v in (vBP 1.922)..(vBP 1.954), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 4.117776996) (ylo := 0.97618434241) (yhi := 0.976184342411) (j := (0:ℤ))
    (c0 := (-0.5601875928)) (c1 := (-0.5601873762)) (s0 := (-0.8283659418)) (s1 := (-0.8283659225))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 4.117776996) (W := 0.0226113)
    ht0 ht1 vbpP550.1 vbpP550.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0226113) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.01716169)
    (ulo := (-0.5601875928)) (uhi := (-0.5413153437)) (vlo := (-0.8410314323)) (vhi := (-0.8281541718))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP549.1, vbpP550.2]) (by linarith [vbpP551.2, vbpP550.1])
    ht0 ht1 (by norm_num) blkLin31
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_32 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    ((-0.0001723702):ℝ) ≤ ∫ v in (vBP 1.954)..(vBP 1.984), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 4.216292924) (ylo := 1.07470027041) (yhi := 1.074700270411) (j := (0:ℤ))
    (c0 := (-0.4759964226)) (c1 := (-0.4759958561)) (s0 := (-0.8794475749)) (s1 := (-0.8794475194))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 4.216292924) (W := 0.023613)
    ht0 ht1 vbpP552.1 vbpP552.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.023613) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.01603265)
    (ulo := (-0.4759964226)) (uhi := (-0.455098695)) (vlo := (-0.890686234)) (vhi := (-0.8792023523))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP551.1, vbpP552.2]) (by linarith [vbpP553.2, vbpP552.1])
    ht0 ht1 (by norm_num) blkLin32
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_33 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    ((-0.0004639738):ℝ) ≤ ∫ v in (vBP 1.984)..(vBP 2.016), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 4.313211923) (ylo := 1.17161926941) (yhi := 1.171619269411) (j := (0:ℤ))
    (c0 := (-0.3886615595)) (c1 := (-0.3886602163)) (s0 := (-0.9213812929)) (s1 := (-0.9213811497))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 4.313211923) (W := 0.0247075)
    ht0 ht1 vbpP554.1 vbpP554.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0247075) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.01698487)
    (ulo := (-0.3886615595)) (uhi := (-0.3657788792)) (vlo := (-0.9309831714)) (vhi := (-0.9210999305))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP553.1, vbpP554.2]) (by linarith [vbpP555.2, vbpP554.1])
    ht0 ht1 (by norm_num) blkLin33
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_34 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    ((-0.0003383718):ℝ) ≤ ∫ v in (vBP 2.016)..(vBP 2.046), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 4.40857417) (ylo := 1.26698151641) (yhi := 1.266981516411) (j := (0:ℤ))
    (c0 := (-0.2991653769)) (c1 := (-0.2991624396)) (s0 := (-0.9542025218)) (s1 := (-0.9542021834))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 4.40857417) (W := 0.0259088)
    ht0 ht1 vbpP556.1 vbpP556.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0259088) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.01598297)
    (ulo := (-0.2991653769)) (uhi := (-0.2743425599)) (vlo := (-0.9619526706)) (vhi := (-0.9538819396))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP555.1, vbpP556.2]) (by linarith [vbpP557.2, vbpP556.1])
    ht0 ht1 (by norm_num) blkLin34
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_35 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    ((-0.0005320904):ℝ) ≤ ∫ v in (vBP 2.046)..(vBP 2.078), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 4.502417184) (ylo := 1.36082453041) (yhi := 1.360824530411) (j := (0:ℤ))
    (c0 := (-0.2084382339)) (c1 := (-0.2084322324)) (s0 := (-0.9780375274)) (s1 := (-0.9780367849))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 4.502417184) (W := 0.0272317)
    ht0 ht1 vbpP558.1 vbpP558.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0272317) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.0170124)
    (ulo := (-0.2084382339)) (uhi := (-0.1817246212)) (vlo := (-0.9837129534)) (vhi := (-0.9776741681))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP557.1, vbpP558.2]) (by linarith [vbpP559.2, vbpP558.1])
    ht0 ht1 (by norm_num) blkLin35
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB84_36 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    ((-0.0002792564):ℝ) ≤ ∫ v in (vBP 2.078)..(vBP 2.094), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 4.550269462) (ylo := 1.40867680841) (yhi := 1.408676808411) (j := (0:ℤ))
    (c0 := (-0.1614186466)) (c1 := (-0.1614101674)) (s0 := (-0.9868884605)) (s1 := (-0.9868873745))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 3.1125) (t1 := 3.128125) (X0 := 4.550269462) (W := 0.0279672)
    ht0 ht1 vbpP559.1 vbpP559.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0279672) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 3.1125) (t1 := 3.128125) (d := 0.01705821)
    (ulo := (-0.1614186466)) (uhi := (-0.1337501378)) (vlo := (-0.9914022996)) (vhi := (-0.9865014456))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP559.1, vbpP559.2]) (by linarith [vbpP560.2, vbpP559.1])
    ht0 ht1 (by norm_num) blkLin36
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

/-- Lower bound for `∫₀^∞ err(v) cos(tv) dv` on the band `3.1125 ≤ t ≤ 3.128125`. -/
theorem oscLinBand84 {t : ℝ} (ht0 : (3.1125:ℝ) ≤ t) (ht1 : t ≤ 3.128125) :
    ((-0.0304401992):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosLB84_0 ht0 ht1)
    (cosLB84_1 ht0 ht1))
    (cosLB84_2 ht0 ht1))
    (cosLB84_3 ht0 ht1))
    (cosLB84_4 ht0 ht1))
    (cosLB84_5 ht0 ht1))
    (cosLB84_6 ht0 ht1))
    (cosLB84_7 ht0 ht1))
    (cosLB84_8 ht0 ht1))
    (cosLB84_9 ht0 ht1))
    (cosLB84_10 ht0 ht1))
    (cosLB84_11 ht0 ht1))
    (cosLB84_12 ht0 ht1))
    (cosLB84_13 ht0 ht1))
    (cosLB84_14 ht0 ht1))
    (cosLB84_15 ht0 ht1))
    (cosLB84_16 ht0 ht1))
    (cosLB84_17 ht0 ht1))
    (cosLB84_18 ht0 ht1))
    (cosLB84_19 ht0 ht1))
    (cosLB84_20 ht0 ht1))
    (cosLB84_21 ht0 ht1))
    (cosLB84_22 ht0 ht1))
    (cosLB84_23 ht0 ht1))
    (cosLB84_24 ht0 ht1))
    (cosLB84_25 ht0 ht1))
    (cosLB84_26 ht0 ht1))
    (cosLB84_27 ht0 ht1))
    (cosLB84_28 ht0 ht1))
    (cosLB84_29 ht0 ht1))
    (cosLB84_30 ht0 ht1))
    (cosLB84_31 ht0 ht1))
    (cosLB84_32 ht0 ht1))
    (cosLB84_33 ht0 ht1))
    (cosLB84_34 ht0 ht1))
    (cosLB84_35 ht0 ht1))
    (cosLB84_36 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 2.094) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 2.094) (S := 0.013709)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_cut
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
