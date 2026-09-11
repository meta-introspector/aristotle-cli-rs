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
# Oscillatory lower bound on the band `1.18 ≤ t ≤ 1.305`

The partition now reaches `q = 5`; on each block the phase `tv` is linearised at
the base point and the signed contributions are summed.
-/

set_option maxHeartbeats 4000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosLBL5_0 {t : ℝ} (ht0 : (1.18:ℝ) ≤ t) (ht1 : t ≤ 1.305) :
    ((-0.0580525058):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.069), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.078906071) (ylo := 0.078906071) (yhi := 0.078906071) (j := (0:ℤ))
    (c0 := 0.9968885308) (c1 := 0.9968885309) (s0 := 0.078824216) (s1 := 0.0788242161)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.18) (t1 := 1.305) (X0 := 0.078906071) (W := 0.0083587)
    ht0 ht1 vbpP115.1 vbpP115.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0083587) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.18) (t1 := 1.305) (d := 0.06686956)
    (ulo := 0.9961948454) (uhi := 0.9968885309) (vlo := 0.0788214623) (vhi := 0.0871568113)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP0.1, vbpP115.2]) (by linarith [vbpP160.2, vbpP115.1])
    ht0 ht1 (by norm_num) blkLo0
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL5_1 {t : ℝ} (ht0 : (1.18:ℝ) ≤ t) (ht1 : t ≤ 1.305) :
    (0.0191719161:ℝ) ≤ ∫ v in (vBP 1.069)..(vBP 1.1455), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.239902622) (ylo := 0.239902622) (yhi := 0.239902622) (j := (0:ℤ))
    (c0 := 0.9713611172) (c1 := 0.9713611173) (s0 := 0.2376080383) (s1 := 0.2376080384)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.18) (t1 := 1.305) (X0 := 0.239902622) (W := 0.0254135)
    ht0 ht1 vbpP183.1 vbpP183.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0254135) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.18) (t1 := 1.305) (d := 0.06986005)
    (ulo := 0.9650096573) (uhi := 0.9713611173) (vlo := 0.2375313133) (vhi := 0.2622910671)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP160.1, vbpP183.2]) (by linarith [vbpP228.2, vbpP183.1])
    ht0 ht1 (by norm_num) blkLo1
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL5_2 {t : ℝ} (ht0 : (1.18:ℝ) ≤ t) (ht1 : t ≤ 1.305) :
    (0.036831626:ℝ) ≤ ∫ v in (vBP 1.1455)..(vBP 1.227), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.401588517) (ylo := 0.401588517) (yhi := 0.401588517) (j := (0:ℤ))
    (c0 := 0.9204412345) (c1 := 0.9204412346) (s0 := 0.3908809714) (s1 := 0.3908809715)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.18) (t1 := 1.305) (X0 := 0.401588517) (W := 0.0425412)
    ht0 ht1 vbpP308.1 vbpP308.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0425412) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.18) (t1 := 1.305) (d := 0.06881509)
    (ulo := 0.9029849436) (uhi := 0.9204412346) (vlo := 0.3905273255) (vhi := 0.4300258366)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP228.1, vbpP308.2]) (by linarith [vbpP358.2, vbpP308.1])
    ht0 ht1 (by norm_num) blkLo2
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL5_3 {t : ℝ} (ht0 : (1.18:ℝ) ≤ t) (ht1 : t ≤ 1.305) :
    (0.014250486:ℝ) ≤ ∫ v in (vBP 1.227)..(vBP 1.312), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.560360414) (ylo := 0.560360414) (yhi := 0.560360414) (j := (0:ℤ))
    (c0 := 0.847063609) (c1 := 0.8470636099) (s0 := 0.531491526) (s1 := 0.5314915261)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.18) (t1 := 1.305) (X0 := 0.560360414) (W := 0.0593603)
    ht0 ht1 vbpP397.1 vbpP397.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0593603) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.18) (t1 := 1.305) (d := 0.0682237)
    (ulo := 0.8140406998) (uhi := 0.8470636099) (vlo := 0.5305554071) (vhi := 0.5817439521)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP358.1, vbpP397.2]) (by linarith [vbpP416.2, vbpP397.1])
    ht0 ht1 (by norm_num) blkLo3
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL5_4 {t : ℝ} (ht0 : (1.18:ℝ) ≤ t) (ht1 : t ≤ 1.305) :
    ((-0.0076308169):ℝ) ≤ ∫ v in (vBP 1.312)..(vBP 1.406), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.722190645) (ylo := 0.722190645) (yhi := 0.722190645) (j := (0:ℤ))
    (c0 := 0.7503594485) (c1 := 0.7503594593) (s0 := 0.6610300279) (s1 := 0.6610300287)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.18) (t1 := 1.305) (X0 := 0.722190645) (W := 0.0765035)
    ht0 ht1 vbpP428.1 vbpP428.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0765035) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.18) (t1 := 1.305) (d := 0.06947187)
    (ulo := 0.6976428778) (uhi := 0.7503594593) (vlo := 0.6590965377) (vhi := 0.7183791734)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP416.1, vbpP428.2]) (by linarith [vbpP449.2, vbpP428.1])
    ht0 ht1 (by norm_num) blkLo4
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL5_5 {t : ℝ} (ht0 : (1.18:ℝ) ≤ t) (ht1 : t ≤ 1.305) :
    ((-0.0075243181):ℝ) ≤ ∫ v in (vBP 1.406)..(vBP 1.504), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.881766738) (ylo := 0.881766738) (yhi := 0.881766738) (j := (0:ℤ))
    (c0 := 0.6357884563) (c1 := 0.6357885347) (s0 := 0.7718633545) (s1 := 0.7718633609)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.18) (t1 := 1.305) (X0 := 0.881766738) (W := 0.0934095)
    ht0 ht1 vbpP469.1 vbpP469.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0934095) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.18) (t1 := 1.305) (d := 0.06899838)
    (ulo := 0.5610221711) (uhi := 0.6357885347) (vlo := 0.7684984191) (vhi := 0.8311657234)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP449.1, vbpP469.2]) (by linarith [vbpP488.2, vbpP469.1])
    ht0 ht1 (by norm_num) blkLo5
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL5_6 {t : ℝ} (ht0 : (1.18:ℝ) ≤ t) (ht1 : t ≤ 1.305) :
    (0.0002131242:ℝ) ≤ ∫ v in (vBP 1.504)..(vBP 1.61), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.046424654) (ylo := 1.046424654) (yhi := 1.046424654) (j := (0:ℤ))
    (c0 := 0.5006691956) (c1 := 0.5006696295) (s0 := 0.8656386962) (s1 := 0.8656387376)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.18) (t1 := 1.305) (X0 := 1.046424654) (W := 0.1108631)
    ht0 ht1 vbpP502.1 vbpP502.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1108631) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.18) (t1 := 1.305) (d := 0.07055622)
    (ulo := 0.4018246449) (uhi := 0.5006696295) (vlo := 0.8603245212) (vhi := 0.9210308946)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP488.1, vbpP502.2]) (by linarith [vbpP515.2, vbpP502.1])
    ht0 ht1 (by norm_num) blkLo6
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL5_7 {t : ℝ} (ht0 : (1.18:ℝ) ≤ t) (ht1 : t ≤ 1.305) :
    ((-0.000769934):ℝ) ≤ ∫ v in (vBP 1.61)..(vBP 1.719), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.201742026) (ylo := 1.201742026) (yhi := 1.201742026) (j := (0:ℤ))
    (c0 := 0.3607335503) (c1 := 0.3607352816) (s0 := 0.9326689063) (s1 := 0.9326690955)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.18) (t1 := 1.305) (X0 := 1.201742026) (W := 0.1273597)
    ht0 ht1 vbpP523.1 vbpP523.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1273597) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.18) (t1 := 1.305) (d := 0.06601185)
    (ulo := 0.2393482719) (uhi := 0.3607352816) (vlo := 0.9251149505) (vhi := 0.9784881301)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP515.1, vbpP523.2]) (by linarith [vbpP530.2, vbpP523.1])
    ht0 ht1 (by norm_num) blkLo7
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL5_8 {t : ℝ} (ht0 : (1.18:ℝ) ≤ t) (ht1 : t ≤ 1.305) :
    ((-0.0009810353):ℝ) ≤ ∫ v in (vBP 1.719)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.352745779) (ylo := 1.352745779) (yhi := 1.352745779) (j := (0:ℤ))
    (c0 := 0.2163266665) (c1 := 0.2163323212) (s0 := 0.9763210148) (s1 := 0.9763217102)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.18) (t1 := 1.305) (X0 := 1.352745779) (W := 0.1434916)
    ht0 ht1 vbpP537.1 vbpP537.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1434916) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.18) (t1 := 1.305) (d := 0.06310085)
    (ulo := 0.0744897125) (uhi := 0.2163323212) (vlo := 0.9662871025) (vhi := 1.0072571662)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP530.1, vbpP537.2]) (by linarith [vbpP543.2, vbpP537.1])
    ht0 ht1 (by norm_num) blkLo8
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL5_9 {t : ℝ} (ht0 : (1.18:ℝ) ≤ t) (ht1 : t ≤ 1.305) :
    ((-0.0005348608):ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.954), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.50205349) (ylo := 1.50205349) (yhi := 1.50205349) (j := (0:ℤ))
    (c0 := 0.068688436) (c1 := 0.0687045459) (s0 := 0.99763811) (s1 := 0.9976403099)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.18) (t1 := 1.305) (X0 := 1.50205349) (W := 0.1596682)
    ht0 ht1 vbpP547.1 vbpP547.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1596682) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.18) (t1 := 1.305) (d := 0.06715513)
    (ulo := (-0.0908007419)) (uhi := 0.0687045459) (vlo := 0.9849482438) (vhi := 1.0085636894)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP543.1, vbpP547.2]) (by linarith [vbpP551.2, vbpP547.1])
    ht0 ht1 (by norm_num) blkLo9
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL5_10 {t : ℝ} (ht0 : (1.18:ℝ) ≤ t) (ht1 : t ≤ 1.305) :
    ((-0.0007494273):ℝ) ≤ ∫ v in (vBP 1.954)..(vBP 2.078), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 1.653942255) (ylo := 0.083145928205) (yhi := 0.083145928206) (j := (0:ℤ))
    (c0 := (-0.08305016)) (c1 := (-0.0830501599)) (s0 := 0.9965453682) (s1 := 0.9965453683)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.18) (t1 := 1.305) (X0 := 1.653942255) (W := 0.1766294)
    ht0 ht1 vbpP555.1 vbpP555.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1766294) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.18) (t1 := 1.305) (d := 0.06335508)
    (ulo := (-0.2581555575)) (uhi := (-0.0817580273)) (vlo := 0.9664477124) (vhi := 0.9965453683)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP551.1, vbpP555.2]) (by linarith [vbpP559.2, vbpP555.1])
    ht0 ht1 (by norm_num) blkLo10
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL5_11 {t : ℝ} (ht0 : (1.18:ℝ) ≤ t) (ht1 : t ≤ 1.305) :
    ((-0.0007944984):ℝ) ≤ ∫ v in (vBP 2.078)..(vBP 2.17945), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 1.774708172) (ylo := 0.203911845205) (yhi := 0.203911845206) (j := (0:ℤ))
    (c0 := (-0.2025016697)) (c1 := (-0.2025016696)) (s0 := 0.9792819174) (s1 := 0.9792819175)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.18) (t1 := 1.305) (X0 := 1.774708172) (W := 0.1882163)
    ht0 ht1 vbpT1.1 vbpT1.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1882163) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.18) (t1 := 1.305) (d := 0.05422059)
    (ulo := (-0.3857321661)) (uhi := (-0.198925397)) (vlo := 0.9240978698) (vhi := 0.9792819175)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP559.1, vbpT1.2]) (by linarith [vbpT3.2, vbpT1.1])
    ht0 ht1 (by norm_num) blkLo11
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL5_12 {t : ℝ} (ht0 : (1.18:ℝ) ≤ t) (ht1 : t ≤ 1.305) :
    ((-0.0003427138):ℝ) ≤ ∫ v in (vBP 2.17945)..(vBP 2.2912884), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 1.899064996) (ylo := 0.328268669205) (yhi := 0.328268669206) (j := (0:ℤ))
    (c0 := (-0.3224046314)) (c1 := (-0.3224046313)) (s0 := 0.946601951) (s1 := 0.9466019511)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.18) (t1 := 1.305) (X0 := 1.899064996) (W := 0.2013221)
    ht0 ht1 vbpT4.1 vbpT4.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.2013221) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.18) (t1 := 1.305) (d := 0.05141957)
    (ulo := (-0.5116917986)) (uhi := (-0.3158930445)) (vlo := 0.863013878) (vhi := 0.9466019511)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT3.1, vbpT4.2]) (by linarith [vbpT7.2, vbpT4.1])
    ht0 ht1 (by norm_num) blkLo12
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL5_13 {t : ℝ} (ht0 : (1.18:ℝ) ≤ t) (ht1 : t ≤ 1.305) :
    ((-0.0009602881):ℝ) ≤ ∫ v in (vBP 2.2912884)..(vBP 2.4494903), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.01151712) (ylo := 0.440720793205) (yhi := 0.440720793206) (j := (0:ℤ))
    (c0 := (-0.4265914933)) (c1 := (-0.4265914932)) (s0 := 0.9044444139) (s1 := 0.9044444141)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.18) (t1 := 1.305) (X0 := 2.01151712) (W := 0.2132665)
    ht0 ht1 vbpT9.1 vbpT9.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.2132665) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.18) (t1 := 1.305) (d := 0.08716116)
    (ulo := (-0.6180203373)) (uhi := (-0.4169269621)) (vlo := 0.7936644209) (vhi := 0.9044444141)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT7.1, vbpT9.2]) (by linarith [vbpT13.2, vbpT9.1])
    ht0 ht1 (by norm_num) blkLo13
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL5_14 {t : ℝ} (ht0 : (1.18:ℝ) ≤ t) (ht1 : t ≤ 1.305) :
    ((-0.0007841658):ℝ) ≤ ∫ v in (vBP 2.4494903)..(vBP 2.5980768), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.162365617) (ylo := 0.591569290205) (yhi := 0.591569290206) (j := (0:ℤ))
    (c0 := (-0.5576643245)) (c1 := (-0.5576643243)) (s0 := 0.8300665643) (s1 := 0.8300665659)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.18) (t1 := 1.305) (X0 := 2.162365617) (W := 0.229236)
    ht0 ht1 vbpT15.1 vbpT15.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.229236) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.18) (t1 := 1.305) (d := 0.07709944)
    (ulo := (-0.7462833186)) (uhi := (-0.5430759848)) (vlo := 0.6816322014) (vhi := 0.8300665659)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT13.1, vbpT15.2]) (by linarith [vbpT19.2, vbpT15.1])
    ht0 ht1 (by norm_num) blkLo14
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL5_15 {t : ℝ} (ht0 : (1.18:ℝ) ≤ t) (ht1 : t ≤ 1.305) :
    ((-0.0007275773):ℝ) ≤ ∫ v in (vBP 2.5980768)..(vBP 2.7838827), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.337485594) (ylo := 0.766689267205) (yhi := 0.766689267206) (j := (0:ℤ))
    (c0 := (-0.6937546188)) (c1 := (-0.6937546174)) (s0 := 0.7202114485) (s1 := 0.720211468)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.18) (t1 := 1.305) (X0 := 2.337485594) (W := 0.2478187)
    ht0 ht1 vbpT22.1 vbpT22.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.2478187) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.18) (t1 := 1.305) (d := 0.07160879)
    (ulo := (-0.8704152061)) (uhi := (-0.6725602601)) (vlo := 0.5280378394) (vhi := 0.720211468)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT19.1, vbpT22.2]) (by linarith [vbpT27.2, vbpT22.1])
    ht0 ht1 (by norm_num) blkLo15
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL5_16 {t : ℝ} (ht0 : (1.18:ℝ) ≤ t) (ht1 : t ≤ 1.305) :
    ((-0.0005504473):ℝ) ≤ ∫ v in (vBP 2.7838827)..(vBP 2.9580404), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.489947802) (ylo := 0.919151475205) (yhi := 0.919151475206) (j := (0:ℤ))
    (c0 := (-0.7950872902)) (c1 := (-0.7950872802)) (s0 := 0.6064950254) (s1 := 0.6064951441)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.18) (t1 := 1.305) (X0 := 2.489947802) (W := 0.2639863)
    ht0 ht1 vbpT30.1 vbpT30.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.2639863) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.18) (t1 := 1.305) (d := 0.06268613)
    (ulo := (-0.9533405652)) (uhi := (-0.767543471)) (vlo := 0.3780217447) (vhi := 0.6064951441)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT27.1, vbpT30.2]) (by linarith [vbpT35.2, vbpT30.1])
    ht0 ht1 (by norm_num) blkLo16
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL5_17 {t : ℝ} (ht0 : (1.18:ℝ) ≤ t) (ht1 : t ≤ 1.305) :
    ((-0.0004669388):ℝ) ≤ ∫ v in (vBP 2.9580404)..(vBP 3.1622782), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.624950964) (ylo := 1.054154637205) (yhi := 1.054154637206) (j := (0:ℤ))
    (c0 := (-0.869483005)) (c1 := (-0.8694829602)) (s0 := 0.4939629312) (s1 := 0.4939633983)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.18) (t1 := 1.305) (X0 := 2.624950964) (W := 0.2782921)
    ht0 ht1 vbpT39.1 vbpT39.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.2782921) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.18) (t1 := 1.305) (d := 0.07811905)
    (ulo := (-1.0051815968)) (uhi := (-0.8360304938)) (vlo := 0.236099181) (vhi := 0.4939633983)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT35.1, vbpT39.2]) (by linarith [vbpT45.2, vbpT39.1])
    ht0 ht1 (by norm_num) blkLo17
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL5_18 {t : ℝ} (ht0 : (1.18:ℝ) ≤ t) (ht1 : t ≤ 1.305) :
    ((-0.0003392169):ℝ) ≤ ∫ v in (vBP 3.1622782)..(vBP 3.3541025), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.774538494) (ylo := 1.203742167205) (yhi := 1.203742167206) (j := (0:ℤ))
    (c0 := (-0.933388751)) (c1 := (-0.9333885582)) (s0 := 0.3588673601) (s1 := 0.3588691204)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.18) (t1 := 1.305) (X0 := 2.774538494) (W := 0.2940949)
    ht0 ht1 vbpT49.1 vbpT49.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.2940949) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.18) (t1 := 1.305) (d := 0.06914293)
    (ulo := (-1.0374154814)) (uhi := (-0.8933134261)) (vlo := 0.0728944753) (vhi := 0.3588691204)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT45.1, vbpT49.2]) (by linarith [vbpT55.2, vbpT49.1])
    ht0 ht1 (by norm_num) blkLo18
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL5_19 {t : ℝ} (ht0 : (1.18:ℝ) ≤ t) (ht1 : t ≤ 1.305) :
    ((-0.0003737197):ℝ) ≤ ∫ v in (vBP 3.3541025)..(vBP 3.5707148), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.932079114) (ylo := 1.361282787205) (yhi := 1.361282787206) (j := (0:ℤ))
    (c0 := (-0.978132943)) (c1 := (-0.9781321977)) (s0 := 0.2079840181) (s1 := 0.20799004)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.18) (t1 := 1.305) (X0 := 2.932079114) (W := 0.3108391)
    ht0 ht1 vbpT60.1 vbpT60.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.3108391) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.18) (t1 := 1.305) (d := 0.0647093)
    (ulo := (-1.0417482842)) (uhi := (-0.9312574226)) (vlo := (-0.1011525718)) (vhi := 0.20799004)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT55.1, vbpT60.2]) (by linarith [vbpT67.2, vbpT60.1])
    ht0 ht1 (by norm_num) blkLo19
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL5_20 {t : ℝ} (ht0 : (1.18:ℝ) ≤ t) (ht1 : t ≤ 1.305) :
    ((-0.0002339962):ℝ) ≤ ∫ v in (vBP 3.5707148)..(vBP 3.8078871), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 3.071078175) (ylo := 1.500281848205) (yhi := 1.500281848206) (j := (0:ℤ))
    (c0 := (-0.9975170246)) (c1 := (-0.9975148531)) (s0 := 0.0704557885) (s1 := 0.0704717094)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.18) (t1 := 1.305) (X0 := 3.071078175) (W := 0.3255331)
    ht0 ht1 vbpT73.1 vbpT73.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.3255331) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.18) (t1 := 1.305) (d := 0.0716348)
    (ulo := (-1.0200548592)) (uhi := (-0.9451257403)) (vlo := (-0.2522643666)) (vhi := 0.0704717094)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT67.1, vbpT73.2]) (by linarith [vbpT81.2, vbpT73.1])
    ht0 ht1 (by norm_num) blkLo20
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL5_21 {t : ℝ} (ht0 : (1.18:ℝ) ≤ t) (ht1 : t ≤ 1.305) :
    ((-0.0002083821):ℝ) ≤ ∫ v in (vBP 3.8078871)..(vBP 4.0620198), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 3.234087349) (ylo := 0.09249469541) (yhi := 0.092494695411) (j := (0:ℤ))
    (c0 := (-0.9957254145)) (c1 := (-0.9957254144)) (s0 := (-0.0923628657)) (s1 := (-0.0923628656))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.18) (t1 := 1.305) (X0 := 3.234087349) (W := 0.3428177)
    ht0 ht1 vbpT88.1 vbpT88.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.3428177) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.18) (t1 := 1.305) (d := 0.06687385)
    (ulo := (-0.9957254145)) (uhi := (-0.9067383512)) (vlo := (-0.4270681619)) (vhi := (-0.0869883866))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT81.1, vbpT88.2]) (by linarith [vbpT97.2, vbpT88.1])
    ht0 ht1 (by norm_num) blkLo21
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL5_22 {t : ℝ} (ht0 : (1.18:ℝ) ≤ t) (ht1 : t ≤ 1.305) :
    ((-0.0001735031):ℝ) ≤ ∫ v in (vBP 4.0620198)..(vBP 4.3301276), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 3.377292392) (ylo := 0.23569973841) (yhi := 0.235699738411) (j := (0:ℤ))
    (c0 := (-0.9723511741)) (c1 := (-0.972351174)) (s0 := (-0.2335234341)) (s1 := (-0.233523434))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.18) (t1 := 1.305) (X0 := 3.377292392) (W := 0.3579912)
    ht0 ht1 vbpT105.1 vbpT105.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.3579912) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.18) (t1 := 1.305) (d := 0.0691632)
    (ulo := (-0.9723511741)) (uhi := (-0.8288815294)) (vlo := (-0.5742289597)) (vhi := (-0.2187186515))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT97.1, vbpT105.2]) (by linarith [vbpT115.2, vbpT105.1])
    ht0 ht1 (by norm_num) blkLo22
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL5_23 {t : ℝ} (ht0 : (1.18:ℝ) ≤ t) (ht1 : t ≤ 1.305) :
    ((-0.0001302613):ℝ) ≤ ∫ v in (vBP 4.3301276)..(vBP 4.6368098), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 3.534869762) (ylo := 0.39327710841) (yhi := 0.393277108411) (j := (0:ℤ))
    (c0 := (-0.923658177)) (c1 := (-0.9236581769)) (s0 := (-0.3832173955)) (s1 := (-0.3832173954))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.18) (t1 := 1.305) (X0 := 3.534869762) (W := 0.3746617)
    ht0 ht1 vbpT125.1 vbpT125.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.3746617) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.18) (t1 := 1.305) (d := 0.07247932)
    (ulo := (-0.923658177)) (uhi := (-0.7193440116)) (vlo := (-0.7212372337)) (vhi := (-0.3566341713))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT115.1, vbpT125.2]) (by linarith [vbpT137.2, vbpT125.1])
    ht0 ht1 (by norm_num) blkLo23
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL5_24 {t : ℝ} (ht0 : (1.18:ℝ) ≤ t) (ht1 : t ≤ 1.305) :
    ((-0.0001030712):ℝ) ≤ ∫ v in (vBP 4.6368098)..(vBP 4.949748), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 3.699786541) (ylo := 0.55819388741) (yhi := 0.558193887411) (j := (0:ℤ))
    (c0 := (-0.8482131115)) (c1 := (-0.8482131106)) (s0 := (-0.5296550943)) (s1 := (-0.5296550942))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.18) (t1 := 1.305) (X0 := 3.699786541) (W := 0.3921358)
    ht0 ht1 vbpT148.1 vbpT148.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.3921358) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.18) (t1 := 1.305) (d := 0.06760111)
    (ulo := (-0.8482131115)) (uhi := (-0.5814148849)) (vlo := (-0.8538107339)) (vhi := (-0.4894515948))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT137.1, vbpT148.2]) (by linarith [vbpT161.2, vbpT148.1])
    ht0 ht1 (by norm_num) blkLo24
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLBL5_25 {t : ℝ} (ht0 : (1.18:ℝ) ≤ t) (ht1 : t ≤ 1.305) :
    ((-0.0000138984):ℝ) ≤ ∫ v in (vBP 4.949748)..(vBP 5), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 3.786311551) (ylo := 0.64471889741) (yhi := 0.644718897411) (j := (0:ℤ))
    (c0 := (-0.7992687373)) (c1 := (-0.7992687337)) (s0 := (-0.600973786)) (s1 := (-0.6009737857))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 1.18) (t1 := 1.305) (X0 := 3.786311551) (W := 0.4013145)
    ht0 ht1 vbpT162.1 vbpT162.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.4013145) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 1.18) (t1 := 1.305) (d := 0.01033663)
    (ulo := (-0.7992687373)) (uhi := (-0.5010078475)) (vlo := (-0.913191126)) (vhi := (-0.5532254015))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpT161.1, vbpT162.2]) (by linarith [vbpT165.2, vbpT162.1])
    ht0 ht1 (by norm_num) blkLo25
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

/-- Lower bound for `∫₀^∞ err(v) cos(tv) dv` on the band `1.18 ≤ t ≤ 1.305`. -/
theorem oscLowBand5 {t : ℝ} (ht0 : (1.18:ℝ) ≤ t) (ht1 : t ≤ 1.305) :
    ((-0.0141784243):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosLBL5_0 ht0 ht1)
    (cosLBL5_1 ht0 ht1))
    (cosLBL5_2 ht0 ht1))
    (cosLBL5_3 ht0 ht1))
    (cosLBL5_4 ht0 ht1))
    (cosLBL5_5 ht0 ht1))
    (cosLBL5_6 ht0 ht1))
    (cosLBL5_7 ht0 ht1))
    (cosLBL5_8 ht0 ht1))
    (cosLBL5_9 ht0 ht1))
    (cosLBL5_10 ht0 ht1))
    (cosLBL5_11 ht0 ht1))
    (cosLBL5_12 ht0 ht1))
    (cosLBL5_13 ht0 ht1))
    (cosLBL5_14 ht0 ht1))
    (cosLBL5_15 ht0 ht1))
    (cosLBL5_16 ht0 ht1))
    (cosLBL5_17 ht0 ht1))
    (cosLBL5_18 ht0 ht1))
    (cosLBL5_19 ht0 ht1))
    (cosLBL5_20 ht0 ht1))
    (cosLBL5_21 ht0 ht1))
    (cosLBL5_22 ht0 ht1))
    (cosLBL5_23 ht0 ht1))
    (cosLBL5_24 ht0 ht1))
    (cosLBL5_25 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 5) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 5) (S := 0.0022)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_five
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
