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
# Oscillatory lower bound on the band `1.83125 ≤ t ≤ 1.846875`

On each block the phase `t v` is linearised at the base point, so that the error is
quadratic in the block width; the signed contributions are then summed and the
unresolved tail beyond `q = 2.094` is estimated in absolute value.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosLB2_0 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    ((-0.0318889566):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.0228), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.040791987) (ylo := 0.040791987) (yhi := 0.040791987) (j := (0:ℤ))
    (c0 := 0.9991681222) (c1 := 0.9991681223) (s0 := 0.040780675) (s1 := 0.0407806751)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 0.040791987) (W := 0.0003481)
    ht0 ht1 vbpP45.1 vbpP45.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0003481) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.02281245)
    (ulo := 0.9991538659) (uhi := 0.9991681223) (vlo := 0.0407806725) (vhi := 0.0411284856)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP0.1, vbpP45.2]) (by linarith [vbpP91.2, vbpP45.1])
    ht0 ht1 (by norm_num) blkLin0
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_1 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    ((-0.0183009285):ℝ) ≤ ∫ v in (vBP 1.0228)..(vBP 1.046), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.124225473) (ylo := 0.124225473) (yhi := 0.124225473) (j := (0:ℤ))
    (c0 := 0.9922939335) (c1 := 0.9922939336) (s0 := 0.1239062121) (s1 := 0.1239062122)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 0.124225473) (W := 0.00106)
    ht0 ht1 vbpP116.1 vbpP116.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.00106) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.02274851)
    (ulo := 0.9921620354) (uhi := 0.9922939336) (vlo := 0.1239061424) (vhi := 0.1249580436)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP91.1, vbpP116.2]) (by linarith [vbpP139.2, vbpP116.1])
    ht0 ht1 (by norm_num) blkLin1
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_2 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    ((-0.0074315275):ℝ) ≤ ∫ v in (vBP 1.046)..(vBP 1.069), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.203029612) (ylo := 0.203029612) (yhi := 0.203029612) (j := (0:ℤ))
    (c0 := 0.9794601899) (c1 := 0.97946019) (s0 := 0.2016376359) (s1 := 0.201637636)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 0.203029612) (W := 0.0017324)
    ht0 ht1 vbpP151.1 vbpP151.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0017324) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.02257786)
    (ulo := 0.9791094032) (uhi := 0.97946019) (vlo := 0.2016373333) (vhi := 0.203334452)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP139.1, vbpP151.2]) (by linarith [vbpP160.2, vbpP151.1])
    ht0 ht1 (by norm_num) blkLin2
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_3 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    (0.0000965611:ℝ) ≤ ∫ v in (vBP 1.069)..(vBP 1.092), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.281869812) (ylo := 0.281869812) (yhi := 0.281869812) (j := (0:ℤ))
    (c0 := 0.9605370254) (c1 := 0.9605370255) (s0 := 0.2781521574) (s1 := 0.2781521575)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 0.281869812) (W := 0.0024051)
    ht0 ht1 vbpP164.1 vbpP164.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0024051) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.02209968)
    (ulo := 0.9598652641) (uhi := 0.9605370255) (vlo := 0.2781513529) (vhi := 0.2804623429)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP160.1, vbpP164.2]) (by linarith [vbpP169.2, vbpP164.1])
    ht0 ht1 (by norm_num) blkLin3
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_4 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    (0.0065771794:ℝ) ≤ ∫ v in (vBP 1.092)..(vBP 1.117), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.362367557) (ylo := 0.362367557) (yhi := 0.362367557) (j := (0:ℤ))
    (c0 := 0.9350601721) (c1 := 0.9350601722) (s0 := 0.3544890329) (s1 := 0.354489033)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 0.362367557) (W := 0.0030919)
    ht0 ht1 vbpP180.1 vbpP180.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0030919) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.02341315)
    (ulo := 0.9339596596) (uhi := 0.9350601722) (vlo := 0.3544873384) (vhi := 0.357380141)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP169.1, vbpP180.2]) (by linarith [vbpP193.2, vbpP180.1])
    ht0 ht1 (by norm_num) blkLin4
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_5 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    (0.010298027:ℝ) ≤ ∫ v in (vBP 1.117)..(vBP 1.1425), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.447622079) (ylo := 0.447622079) (yhi := 0.447622079) (j := (0:ℤ))
    (c0 := 0.9014788692) (c1 := 0.9014788694) (s0 := 0.4328231142) (s1 := 0.4328231144)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 0.447622079) (W := 0.0038194)
    ht0 ht1 vbpP206.1 vbpP206.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0038194) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.02314223)
    (ulo := 0.8998191733) (uhi := 0.9014788694) (vlo := 0.4328199572) (vhi := 0.4362662145)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP193.1, vbpP206.2]) (by linarith [vbpP222.2, vbpP206.1])
    ht0 ht1 (by norm_num) blkLin5
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_6 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    (0.0118770691:ℝ) ≤ ∫ v in (vBP 1.1425)..(vBP 1.1685), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.529352663) (ylo := 0.529352663) (yhi := 0.529352663) (j := (0:ℤ))
    (c0 := 0.8631341401) (c1 := 0.8631341407) (s0 := 0.5049747083) (s1 := 0.5049747085)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 0.529352663) (W := 0.0045167)
    ht0 ht1 vbpP248.1 vbpP248.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0045167) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.02262862)
    (ulo := 0.8608445243) (uhi := 0.8631341407) (vlo := 0.5049695574) (vhi := 0.5088732133)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP222.1, vbpP248.2]) (by linarith [vbpP274.2, vbpP248.1])
    ht0 ht1 (by norm_num) blkLin6
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_7 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    (0.0114699448:ℝ) ≤ ∫ v in (vBP 1.1685)..(vBP 1.195), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.610849394) (ylo := 0.610849394) (yhi := 0.610849394) (j := (0:ℤ))
    (c0 := 0.819161132) (c1 := 0.8191611341) (s0 := 0.5735634574) (s1 := 0.5735634576)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 0.610849394) (W := 0.0052121)
    ht0 ht1 vbpP300.1 vbpP300.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0052121) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.02272274)
    (ulo := 0.8161605488) (uhi := 0.8191611341) (vlo := 0.5735556667) (vhi := 0.5778329881)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP274.1, vbpP300.2]) (by linarith [vbpP326.2, vbpP300.1])
    ht0 ht1 (by norm_num) blkLin7
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_8 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    (0.009619326:ℝ) ≤ ∫ v in (vBP 1.195)..(vBP 1.222), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.692088337) (ylo := 0.692088337) (yhi := 0.692088337) (j := (0:ℤ))
    (c0 := 0.76991503) (c1 := 0.769915037) (s0 := 0.6381464146) (s1 := 0.6381464151)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 0.692088337) (W := 0.0059052)
    ht0 ht1 vbpP339.1 vbpP339.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0059052) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.02304553)
    (ulo := 0.7661332457) (uhi := 0.769915037) (vlo := 0.6381352881) (vhi := 0.642692891)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP326.1, vbpP339.2]) (by linarith [vbpP353.2, vbpP339.1])
    ht0 ht1 (by norm_num) blkLin8
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_9 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    (0.0071780678:ℝ) ≤ ∫ v in (vBP 1.222)..(vBP 1.25), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.776011811) (ylo := 0.776011811) (yhi := 0.776011811) (j := (0:ℤ))
    (c0 := 0.7137126879) (c1 := 0.7137127098) (s0 := 0.7004385761) (s1 := 0.7004385777)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 0.776011811) (W := 0.0066213)
    ht0 ht1 vbpP367.1 vbpP367.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0066213) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.022783)
    (ulo := 0.7090592627) (uhi := 0.7137127098) (vlo := 0.7004232219) (vhi := 0.7051642492)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP353.1, vbpP367.2]) (by linarith [vbpP381.2, vbpP367.1])
    ht0 ht1 (by norm_num) blkLin9
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_10 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    (0.004229172:ℝ) ≤ ∫ v in (vBP 1.25)..(vBP 1.278), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.858055237) (ylo := 0.858055237) (yhi := 0.858055237) (j := (0:ℤ))
    (c0 := 0.6539100572) (c1 := 0.653910117) (s0 := 0.7565722943) (s1 := 0.756572299)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 0.858055237) (W := 0.0073214)
    ht0 ht1 vbpP395.1 vbpP395.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0073214) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.0222755)
    (ulo := 0.6483534125) (uhi := 0.653910117) (vlo := 0.7565520171) (vhi := 0.7613597938)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP381.1, vbpP395.2]) (by linarith [vbpP403.2, vbpP395.1])
    ht0 ht1 (by norm_num) blkLin10
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_11 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    (0.0015403287:ℝ) ≤ ∫ v in (vBP 1.278)..(vBP 1.303), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.929786856) (ylo := 0.929786856) (yhi := 0.929786856) (j := (0:ℤ))
    (c0 := 0.5980048283) (c1 := 0.5980049614) (s0 := 0.8014924978) (s1 := 0.8014925092)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 0.929786856) (W := 0.0079334)
    ht0 ht1 vbpP408.1 vbpP408.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0079334) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.02160518)
    (ulo := 0.5916275155) (uhi := 0.5980049614) (vlo := 0.8014672754) (vhi := 0.806236672)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP403.1, vbpP408.2]) (by linarith [vbpP414.2, vbpP408.1])
    ht0 ht1 (by norm_num) blkLin11
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_12 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    ((-0.0002809507):ℝ) ≤ ∫ v in (vBP 1.303)..(vBP 1.331), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.008492849) (ylo := 1.008492849) (yhi := 1.008492849) (j := (0:ℤ))
    (c0 := 0.5331364179) (c1 := 0.5331367179) (s0 := 0.8460292885) (s1 := 0.8460293161)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 1.008492849) (W := 0.008605)
    ht0 ht1 vbpP417.1 vbpP417.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.008605) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.02137429)
    (ulo := 0.5258366872) (uhi := 0.5331367179) (vlo := 0.8459979661) (vhi := 0.850616901)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP414.1, vbpP417.2]) (by linarith [vbpP420.2, vbpP417.1])
    ht0 ht1 (by norm_num) blkLin12
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_13 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    ((-0.0012889728):ℝ) ≤ ∫ v in (vBP 1.331)..(vBP 1.36), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.08554296) (ylo := 1.08554296) (yhi := 1.08554296) (j := (0:ℤ))
    (c0 := 0.4664324861) (c1 := 0.4664331124) (s0 := 0.8845567985) (s1 := 0.8845568604)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 1.08554296) (W := 0.0092626)
    ht0 ht1 vbpP423.1 vbpP423.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0092626) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.02218152)
    (ulo := 0.458219298) (uhi := 0.4664331124) (vlo := 0.8845188531) (vhi := 0.888877182)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP420.1, vbpP423.2]) (by linarith [vbpP429.2, vbpP423.1])
    ht0 ht1 (by norm_num) blkLin13
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_14 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    ((-0.0016830988):ℝ) ≤ ∫ v in (vBP 1.36)..(vBP 1.39), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.16367194) (ylo := 1.16367194) (yhi := 1.16367194) (j := (0:ℤ))
    (c0 := 0.395970386) (c1 := 0.3959716408) (s0 := 0.9182632744) (s1 := 0.9182634072)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 1.16367194) (W := 0.0099295)
    ht0 ht1 vbpP435.1 vbpP435.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0099295) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.02315542)
    (ulo := 0.3868331191) (uhi := 0.3959716408) (vlo := 0.9182180067) (vhi := 0.922195143)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP429.1, vbpP435.2]) (by linarith [vbpP442.2, vbpP435.1])
    ht0 ht1 (by norm_num) blkLin14
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_15 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    ((-0.0015373534):ℝ) ≤ ∫ v in (vBP 1.39)..(vBP 1.42), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.242778418) (ylo := 1.242778418) (yhi := 1.242778418) (j := (0:ℤ))
    (c0 := 0.3221672227) (c1 := 0.3221696448) (s0 := 0.9466827649) (s1 := 0.9466830386)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 1.242778418) (W := 0.0106049)
    ht0 ht1 vbpP448.1 vbpP448.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0106049) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.02266377)
    (ulo := 0.312109816) (uhi := 0.3221696448) (vlo := 0.9466295315) (vhi := 0.9500995515)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP442.1, vbpP448.2]) (by linarith [vbpP455.2, vbpP448.1])
    ht0 ht1 (by norm_num) blkLin15
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_16 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    ((-0.0011067136):ℝ) ≤ ∫ v in (vBP 1.42)..(vBP 1.45), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.320212096) (ylo := 1.320212096) (yhi := 1.320212096) (j := (0:ℤ))
    (c0 := 0.2479699274) (c1 := 0.2479743603) (s0 := 0.9687677094) (s1 := 0.9687682415)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 1.320212096) (W := 0.0112666)
    ht0 ht1 vbpP461.1 vbpP461.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0112666) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.02219285)
    (ulo := 0.237039696) (uhi := 0.2479743603) (vlo := 0.9687062241) (vhi := 0.9715620104)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP455.1, vbpP461.2]) (by linarith [vbpP468.2, vbpP461.1])
    ht0 ht1 (by norm_num) blkLin16
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_17 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    ((-0.0006212923):ℝ) ≤ ∫ v in (vBP 1.45)..(vBP 1.481), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.396042094) (ylo := 1.396042094) (yhi := 1.396042094) (j := (0:ℤ))
    (c0 := 0.1738660056) (c1 := 0.1738737543) (s0 := 0.984769287) (s1 := 0.9847702705)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 1.396042094) (W := 0.0119152)
    ht0 ht1 vbpP474.1 vbpP474.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0119152) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.0230925)
    (ulo := 0.1621202066) (uhi := 0.1738737543) (vlo := 0.9846993829) (vhi := 0.9868419621)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP468.1, vbpP474.2]) (by linarith [vbpP480.2, vbpP474.1])
    ht0 ht1 (by norm_num) blkLin17
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_18 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    ((-0.0001814288):ℝ) ≤ ∫ v in (vBP 1.481)..(vBP 1.512), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.47278385) (ylo := 1.47278385) (yhi := 1.47278385) (j := (0:ℤ))
    (c0 := 0.097855412) (c1 := 0.0978686441) (s0 := 0.9952005967) (s1 := 0.9952023684)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 1.47278385) (W := 0.0125728)
    ht0 ht1 vbpP485.1 vbpP485.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0125728) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.02261815)
    (ulo := 0.0853355271) (uhi := 0.0978686441) (vlo := 0.9951219394) (vhi := 0.9964328189)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP480.1, vbpP485.2]) (by linarith [vbpP490.2, vbpP485.1])
    ht0 ht1 (by norm_num) blkLin18
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_19 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    ((-0.0000209033):ℝ) ≤ ∫ v in (vBP 1.512)..(vBP 1.546), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.552746345) (ylo := 1.552746345) (yhi := 1.552746345) (j := (0:ℤ))
    (c0 := 0.0180485969) (c1 := 0.0180710484) (s0 := 0.999837055) (s1 := 0.9998402243)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 1.552746345) (W := 0.01326)
    ht0 ht1 vbpP494.1 vbpP494.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.01326) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.02342962)
    (ulo := 0.0047895173) (uhi := 0.0180710484) (vlo := 0.9997491568) (vhi := 1.0000798394)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP490.1, vbpP494.2]) (by linarith [vbpP499.2, vbpP494.1])
    ht0 ht1 (by norm_num) blkLin19
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_20 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    ((-0.000103861):ℝ) ≤ ∫ v in (vBP 1.546)..(vBP 1.578), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 1.63334392) (ylo := 0.062547593205) (yhi := 0.062547593206) (j := (0:ℤ))
    (c0 := (-0.0625068181)) (c1 := (-0.062506818)) (s0 := 0.9980445369) (s1 := 0.998044537)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 1.63334392) (W := 0.013956)
    ht0 ht1 vbpP503.1 vbpP503.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.013956) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.02060152)
    (ulo := (-0.0764350756)) (uhi := (-0.0625007308)) (vlo := 0.9970750271) (vhi := 0.998044537)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP499.1, vbpP503.2]) (by linarith [vbpP507.2, vbpP503.1])
    ht0 ht1 (by norm_num) blkLin20
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_21 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    ((-0.0002481238):ℝ) ≤ ∫ v in (vBP 1.578)..(vBP 1.614), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 1.707611346) (ylo := 0.136815019205) (yhi := 0.136815019206) (j := (0:ℤ))
    (c0 := (-0.1363885933)) (c1 := (-0.1363885932)) (s0 := 0.9906554151) (s1 := 0.9906554152)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 1.707611346) (W := 0.0146016)
    ht0 ht1 vbpP511.1 vbpP511.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0146016) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.02495758)
    (ulo := (-0.1508532335)) (uhi := (-0.1363740539)) (vlo := 0.9885583888) (vhi := 0.9906554152)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP507.1, vbpP511.2]) (by linarith [vbpP516.2, vbpP511.1])
    ht0 ht1 (by norm_num) blkLin21
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_22 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    ((-0.000167089):ℝ) ≤ ∫ v in (vBP 1.614)..(vBP 1.648), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 1.793887141) (ylo := 0.223090814205) (yhi := 0.223090814206) (j := (0:ℤ))
    (c0 := (-0.2212448936)) (c1 := (-0.2212448935)) (s0 := 0.9752182817) (s1 := 0.9752182818)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 1.793887141) (W := 0.0153594)
    ht0 ht1 vbpP519.1 vbpP519.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0153594) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.02220681)
    (ulo := (-0.2362230724)) (uhi := (-0.2212187969)) (vlo := 0.9717051963) (vhi := 0.9752182818)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP516.1, vbpP519.2]) (by linarith [vbpP521.2, vbpP519.1])
    ht0 ht1 (by norm_num) blkLin22
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_23 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    ((-0.0000687574):ℝ) ≤ ∫ v in (vBP 1.648)..(vBP 1.68), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 1.864991597) (ylo := 0.294195270205) (yhi := 0.294195270206) (j := (0:ℤ))
    (c0 := (-0.2899697889)) (c1 := (-0.2899697888)) (s0 := 0.9570357995) (s1 := 0.9570357996)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 1.864991597) (W := 0.0159929)
    ht0 ht1 vbpP523.1 vbpP523.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0159929) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.01936289)
    (ulo := (-0.3052749143)) (uhi := (-0.2899327063)) (vlo := 0.95227615) (vhi := 0.9570357996)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP521.1, vbpP523.2]) (by linarith [vbpP525.2, vbpP523.1])
    ht0 ht1 (by norm_num) blkLin23
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_24 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    (0.0002441945:ℝ) ≤ ∫ v in (vBP 1.68)..(vBP 1.712), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 1.934735743) (ylo := 0.363939416205) (yhi := 0.363939416206) (j := (0:ℤ))
    (c0 := (-0.3559583774)) (c1 := (-0.3559583773)) (s0 := 0.9345018103) (s1 := 0.9345018104)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 1.934735743) (W := 0.0166253)
    ht0 ht1 vbpP527.1 vbpP527.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0166253) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.01901515)
    (ulo := (-0.3714940347)) (uhi := (-0.3559091848)) (vlo := 0.9284550226) (vhi := 0.9345018104)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP525.1, vbpP527.2]) (by linarith [vbpP529.2, vbpP527.1])
    ht0 ht1 (by norm_num) blkLin24
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_25 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    (0.000208267:ℝ) ≤ ∫ v in (vBP 1.712)..(vBP 1.75), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.015857605) (ylo := 0.445061278205) (yhi := 0.445061278206) (j := (0:ℤ))
    (c0 := (-0.4305131899)) (c1 := (-0.4305131898)) (s0 := 0.902584286) (s1 := 0.9025842861)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 2.015857605) (W := 0.0173797)
    ht0 ht1 vbpP532.1 vbpP532.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0173797) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.02562316)
    (ulo := (-0.4461990444)) (uhi := (-0.4304481723)) (vlo := 0.8949661614) (vhi := 0.9025842861)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP529.1, vbpP532.2]) (by linarith [vbpP534.2, vbpP532.1])
    ht0 ht1 (by norm_num) blkLin25
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_26 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    (0.0002848026:ℝ) ≤ ∫ v in (vBP 1.75)..(vBP 1.788), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.08279288) (ylo := 0.511996553205) (yhi := 0.511996553206) (j := (0:ℤ))
    (c0 := (-0.4899187536)) (c1 := (-0.4899187535)) (s0 := 0.8717680969) (s1 := 0.8717680974)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 2.08279288) (W := 0.0180223)
    ht0 ht1 vbpP536.1 vbpP536.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0180223) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.0249125)
    (ulo := (-0.5056291693)) (uhi := (-0.489839192)) (vlo := 0.8627975393) (vhi := 0.8717680974)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP534.1, vbpP536.2]) (by linarith [vbpP539.2, vbpP536.1])
    ht0 ht1 (by norm_num) blkLin26
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_27 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    ((-0.0002908759):ℝ) ≤ ∫ v in (vBP 1.788)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.160704503) (ylo := 0.589908176205) (yhi := 0.589908176206) (j := (0:ℤ))
    (c0 := (-0.5562847206)) (c1 := (-0.5562847204)) (s0 := 0.8309917627) (s1 := 0.8309917642)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 2.160704503) (W := 0.0188008)
    ht0 ht1 vbpP541.1 vbpP541.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0188008) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.02665257)
    (ulo := (-0.5719071102)) (uhi := (-0.5561864082)) (vlo := 0.82038692) (vhi := 0.8309917642)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP539.1, vbpP541.2]) (by linarith [vbpP543.2, vbpP541.1])
    ht0 ht1 (by norm_num) blkLin27
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_28 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    ((-0.0004858611):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.86), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.24093944) (ylo := 0.670143113205) (yhi := 0.670143113206) (j := (0:ℤ))
    (c0 := (-0.6210981563)) (c1 := (-0.6210981559)) (s0 := 0.7837327865) (s1 := 0.7837327916)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 2.24093944) (W := 0.0196477)
    ht0 ht1 vbpP544.1 vbpP544.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0196477) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.01769411)
    (ulo := (-0.6364957124)) (uhi := (-0.6209782778)) (vlo := 0.7713791532) (vhi := 0.7837327916)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP543.1, vbpP544.2]) (by linarith [vbpP545.2, vbpP544.1])
    ht0 ht1 (by norm_num) blkLin28
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_29 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    ((-0.0005768107):ℝ) ≤ ∫ v in (vBP 1.86)..(vBP 1.89), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.301912518) (ylo := 0.731116191205) (yhi := 0.731116191206) (j := (0:ℤ))
    (c0 := (-0.6677009774)) (c1 := (-0.6677009765)) (s0 := 0.7444295842) (s1 := 0.7444295963)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 2.301912518) (W := 0.0203305)
    ht0 ht1 vbpP546.1 vbpP546.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0203305) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.01641361)
    (ulo := (-0.6828345608)) (uhi := (-0.667562991)) (vlo := 0.7307019826) (vhi := 0.7444295963)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP545.1, vbpP546.2]) (by linarith [vbpP547.2, vbpP546.1])
    ht0 ht1 (by norm_num) blkLin29
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_30 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    ((-0.0004994519):ℝ) ≤ ∫ v in (vBP 1.89)..(vBP 1.922), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.361863889) (ylo := 0.791067562205) (yhi := 0.791067562206) (j := (0:ℤ))
    (c0 := (-0.7111042681)) (c1 := (-0.7111042661)) (s0 := 0.7030865682) (s1 := 0.7030865948)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 2.361863889) (W := 0.0210431)
    ht0 ht1 vbpP548.1 vbpP548.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0210431) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.01731057)
    (ulo := (-0.7258982978)) (uhi := (-0.7109468291)) (vlo := 0.6879681724) (vhi := 0.7030865948)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP547.1, vbpP548.2]) (by linarith [vbpP549.2, vbpP548.1])
    ht0 ht1 (by norm_num) blkLin30
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_31 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    ((-0.0003790498):ℝ) ≤ ∫ v in (vBP 1.922)..(vBP 1.954), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.422708152) (ylo := 0.851911825205) (yhi := 0.851911825206) (j := (0:ℤ))
    (c0 := (-0.7525408081)) (c1 := (-0.7525408037)) (s0 := 0.6585456234) (s1 := 0.658545679)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 2.422708152) (W := 0.0218168)
    ht0 ht1 vbpP550.1 vbpP550.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0218168) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.01716169)
    (ulo := (-0.7669070278)) (uhi := (-0.7523617163)) (vlo := 0.6419721748) (vhi := 0.658545679)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP549.1, vbpP550.2]) (by linarith [vbpP551.2, vbpP550.1])
    ht0 ht1 (by norm_num) blkLin31
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_32 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    (0.0000501751:ℝ) ≤ ∫ v in (vBP 1.954)..(vBP 1.984), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.480670335) (ylo := 0.909874008205) (yhi := 0.909874008206) (j := (0:ℤ))
    (c0 := (-0.7894264154)) (c1 := (-0.7894264064)) (s0 := 0.6138452149) (s1 := 0.6138453222)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 2.480670335) (W := 0.0226108)
    ht0 ht1 vbpP552.1 vbpP552.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0226108) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.01603265)
    (ulo := (-0.8033047666)) (uhi := (-0.7892246185)) (vlo := 0.595840266) (vhi := 0.6138453222)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP551.1, vbpP552.2]) (by linarith [vbpP553.2, vbpP552.1])
    ht0 ht1 (by norm_num) blkLin32
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_33 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    ((-0.0002420149):ℝ) ≤ ∫ v in (vBP 1.984)..(vBP 2.016), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.537692958) (ylo := 0.966896631205) (yhi := 0.966896631206) (j := (0:ℤ))
    (c0 := (-0.8231274283)) (c1 := (-0.8231274109)) (s0 := 0.567856728) (s1 := 0.5678569249)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 2.537692958) (W := 0.0234563)
    ht0 ht1 vbpP554.1 vbpP554.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0234563) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.01698487)
    (ulo := (-0.8364460293)) (uhi := (-0.8229009797)) (vlo := 0.5483947648) (vhi := 0.5678569249)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP553.1, vbpP554.2]) (by linarith [vbpP555.2, vbpP554.1])
    ht0 ht1 (by norm_num) blkLin33
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_34 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    (0.0000260736:ℝ) ≤ ∫ v in (vBP 2.016)..(vBP 2.046), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.593799662) (ylo := 1.023003335205) (yhi := 1.023003335206) (j := (0:ℤ))
    (c0 := (-0.853676052)) (c1 := (-0.8536760197)) (s0 := 0.5208044259) (s1 := 0.520804772)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 2.593799662) (W := 0.0243616)
    ht0 ht1 vbpP556.1 vbpP556.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0243616) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.01598297)
    (ulo := (-0.8663624346)) (uhi := (-0.8534227091)) (vlo := 0.4998550306) (vhi := 0.520804772)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP555.1, vbpP556.2]) (by linarith [vbpP557.2, vbpP556.1])
    ht0 ht1 (by norm_num) blkLin34
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_35 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    ((-0.000471336):ℝ) ≤ ∫ v in (vBP 2.046)..(vBP 2.078), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.64901252) (ylo := 1.078216193205) (yhi := 1.078216193206) (j := (0:ℤ))
    (c0 := (-0.8811157024)) (c1 := (-0.8811156449)) (s0 := 0.4729008506) (s1 := 0.4729014359)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 2.64901252) (W := 0.0253356)
    ht0 ht1 vbpP558.1 vbpP558.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0253356) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.0170124)
    (ulo := (-0.8930956623)) (uhi := (-0.8808328692)) (vlo := 0.450427876) (vhi := 0.4729014359)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP557.1, vbpP558.2]) (by linarith [vbpP559.2, vbpP558.1])
    ht0 ht1 (by norm_num) blkLin35
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB2_36 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    ((-0.0002381575):ℝ) ≤ ∫ v in (vBP 2.078)..(vBP 2.094), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.677166571) (ylo := 1.106370244205) (yhi := 1.106370244206) (j := (0:ℤ))
    (c0 := (-0.8940788517)) (c1 := (-0.8940787754)) (s0 := 0.4479097408) (s1 := 0.4479104982)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.83125) (t1 := 1.846875) (X0 := 2.677166571) (W := 0.0258683)
    ht0 ht1 vbpP559.1 vbpP559.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0258683) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.83125) (t1 := 1.846875) (d := 0.01705821)
    (ulo := (-0.9056642427)) (uhi := (-0.8937796472)) (vlo := 0.4246341649) (vhi := 0.4479104982)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP559.1, vbpP559.2]) (by linarith [vbpP560.2, vbpP559.1])
    ht0 ht1 (by norm_num) blkLin36
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

/-- Lower bound for `∫₀^∞ err(v) cos(tv) dv` on the band `1.83125 ≤ t ≤ 1.846875`. -/
theorem oscLinBand2 {t : ℝ} (ht0 : (1.83125:ℝ) ≤ t) (ht1 : t ≤ 1.846875) :
    ((-0.0181233266):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosLB2_0 ht0 ht1)
    (cosLB2_1 ht0 ht1))
    (cosLB2_2 ht0 ht1))
    (cosLB2_3 ht0 ht1))
    (cosLB2_4 ht0 ht1))
    (cosLB2_5 ht0 ht1))
    (cosLB2_6 ht0 ht1))
    (cosLB2_7 ht0 ht1))
    (cosLB2_8 ht0 ht1))
    (cosLB2_9 ht0 ht1))
    (cosLB2_10 ht0 ht1))
    (cosLB2_11 ht0 ht1))
    (cosLB2_12 ht0 ht1))
    (cosLB2_13 ht0 ht1))
    (cosLB2_14 ht0 ht1))
    (cosLB2_15 ht0 ht1))
    (cosLB2_16 ht0 ht1))
    (cosLB2_17 ht0 ht1))
    (cosLB2_18 ht0 ht1))
    (cosLB2_19 ht0 ht1))
    (cosLB2_20 ht0 ht1))
    (cosLB2_21 ht0 ht1))
    (cosLB2_22 ht0 ht1))
    (cosLB2_23 ht0 ht1))
    (cosLB2_24 ht0 ht1))
    (cosLB2_25 ht0 ht1))
    (cosLB2_26 ht0 ht1))
    (cosLB2_27 ht0 ht1))
    (cosLB2_28 ht0 ht1))
    (cosLB2_29 ht0 ht1))
    (cosLB2_30 ht0 ht1))
    (cosLB2_31 ht0 ht1))
    (cosLB2_32 ht0 ht1))
    (cosLB2_33 ht0 ht1))
    (cosLB2_34 ht0 ht1))
    (cosLB2_35 ht0 ht1))
    (cosLB2_36 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 2.094) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 2.094) (S := 0.013709)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_cut
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
