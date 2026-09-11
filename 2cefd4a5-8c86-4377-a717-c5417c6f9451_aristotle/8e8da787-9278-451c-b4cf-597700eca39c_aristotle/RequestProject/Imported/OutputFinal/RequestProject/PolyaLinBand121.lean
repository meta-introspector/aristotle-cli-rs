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
# Oscillatory lower bound on the band `4.659375 ≤ t ≤ 4.784375`

On each block the phase `t v` is linearised at the base point, so that the error is
quadratic in the block width; the signed contributions are then summed and the
unresolved tail beyond `q = 2.094` is estimated in absolute value.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem cosLB121_0 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    ((-0.0319327577):ℝ) ≤ ∫ v in (vBP 1)..(vBP 1.0228), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.103789851) (ylo := 0.103789851) (yhi := 0.103789851) (j := (0:ℤ))
    (c0 := 0.9946186668) (c1 := 0.9946186669) (s0 := 0.1036036081) (s1 := 0.1036036082)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 0.103789851) (W := 0.0027845)
    ht0 ht1 vbpP45.1 vbpP45.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0027845) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.02281245)
    (ulo := 0.994326327) (uhi := 0.9946186669) (vlo := 0.1036032064) (vhi := 0.1063731203)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP0.1, vbpP45.2]) (by linarith [vbpP91.2, vbpP45.1])
    ht0 ht1 (by norm_num) blkLin0
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_1 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    ((-0.0176958586):ℝ) ≤ ∫ v in (vBP 1.0228)..(vBP 1.046), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.316075393) (ylo := 0.316075393) (yhi := 0.316075393) (j := (0:ℤ))
    (c0 := 0.9504626547) (c1 := 0.9504626548) (s0 := 0.3108387716) (s1 := 0.3108387717)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 0.316075393) (W := 0.0084796)
    ht0 ht1 vbpP116.1 vbpP116.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0084796) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.02274851)
    (ulo := 0.9477927271) (uhi := 0.9504626548) (vlo := 0.3108275964) (vhi := 0.3188982183)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP91.1, vbpP116.2]) (by linarith [vbpP139.2, vbpP116.1])
    ht0 ht1 (by norm_num) blkLin1
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_2 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    ((-0.0067034509):ℝ) ≤ ∫ v in (vBP 1.046)..(vBP 1.069), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.516582171) (ylo := 0.516582171) (yhi := 0.516582171) (j := (0:ℤ))
    (c0 := 0.8695123589) (c1 := 0.8695123594) (s0 := 0.4939111838) (s1 := 0.493911184)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 0.516582171) (W := 0.0138587)
    ht0 ht1 vbpP151.1 vbpP151.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0138587) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.02257786)
    (ulo := 0.8625841115) (uhi := 0.8695123594) (vlo := 0.4938637533) (vhi := 0.5059611093)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP139.1, vbpP151.2]) (by linarith [vbpP160.2, vbpP151.1])
    ht0 ht1 (by norm_num) blkLin2
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_3 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    ((-0.0000310547):ℝ) ≤ ∫ v in (vBP 1.069)..(vBP 1.092), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.7171807) (ylo := 0.7171807) (yhi := 0.7171807) (j := (0:ℤ))
    (c0 := 0.753661742) (c1 := 0.753661752) (s0 := 0.6572624883) (s1 := 0.657262489)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 0.7171807) (W := 0.0192403)
    ht0 ht1 vbpP164.1 vbpP164.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0192403) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.02209968)
    (ulo := 0.7408771003) (uhi := 0.753661752) (vlo := 0.6571408363) (vhi := 0.6717622726)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP160.1, vbpP164.2]) (by linarith [vbpP169.2, vbpP164.1])
    ht0 ht1 (by norm_num) blkLin3
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_4 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    (0.0039634389:ℝ) ≤ ∫ v in (vBP 1.092)..(vBP 1.117), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 0.921996635) (ylo := 0.921996635) (yhi := 0.921996635) (j := (0:ℤ))
    (c0 := 0.6042304233) (c1 := 0.6042305457) (s0 := 0.796809635) (s1 := 0.7968096454)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 0.921996635) (W := 0.024735)
    ht0 ht1 vbpP180.1 vbpP180.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.024735) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.02341315)
    (ulo := 0.5843385156) (uhi := 0.6042305457) (vlo := 0.7965658953) (vhi := 0.811753764)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP169.1, vbpP180.2]) (by linarith [vbpP193.2, vbpP180.1])
    ht0 ht1 (by norm_num) blkLin4
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_5 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    (0.0043618934:ℝ) ≤ ∫ v in (vBP 1.117)..(vBP 1.1425), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.138915562) (ylo := 1.138915562) (yhi := 1.138915562) (j := (0:ℤ))
    (c0 := 0.418579605) (c1 := 0.418580617) (s0 := 0.9081801057) (s1 := 0.9081802105)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 1.138915562) (W := 0.0305545)
    ht0 ht1 vbpP206.1 vbpP206.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0305545) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.02314223)
    (ulo := 0.3906395571) (uhi := 0.418580617) (vlo := 0.9077562104) (vhi := 0.9209677421)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP193.1, vbpP206.2]) (by linarith [vbpP222.2, vbpP206.1])
    ht0 ht1 (by norm_num) blkLin5
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_6 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    (0.0024721069:ℝ) ≤ ∫ v in (vBP 1.1425)..(vBP 1.1685), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.346868296) (ylo := 1.346868296) (yhi := 1.346868296) (j := (0:ℤ))
    (c0 := 0.2220612112) (c1 := 0.2220666249) (s0 := 0.9750327024) (s1 := 0.9750333654)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 1.346868296) (W := 0.0361333)
    ht0 ht1 vbpP248.1 vbpP248.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0361333) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.02262862)
    (ulo := 0.1866927564) (uhi := 0.2220666249) (vlo := 0.9743962628) (vhi := 0.9830556195)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP222.1, vbpP248.2]) (by linarith [vbpP274.2, vbpP248.1])
    ht0 ht1 (by norm_num) blkLin6
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_7 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    ((-0.0004683376):ℝ) ≤ ∫ v in (vBP 1.1685)..(vBP 1.195), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 1.554226018) (ylo := 1.554226018) (yhi := 1.554226018) (j := (0:ℤ))
    (c0 := 0.0165691411) (c1 := 0.0165918074) (s0 := 0.9998626665) (s1 := 0.9998658692)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 1.554226018) (W := 0.0416963)
    ht0 ht1 vbpP300.1 vbpP300.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0416963) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.02272274)
    (ulo := (-0.0251238881)) (uhi := 0.0165918074) (vlo := 0.998993621) (vhi := 1.0005574858)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP274.1, vbpP300.2]) (by linarith [vbpP326.2, vbpP300.1])
    ht0 ht1 (by norm_num) blkLin7
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_8 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    ((-0.0031989319):ℝ) ≤ ∫ v in (vBP 1.195)..(vBP 1.222), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 1.760927835) (ylo := 0.190131508205) (yhi := 0.190131508206) (j := (0:ℤ))
    (c0 := (-0.188988035)) (c1 := (-0.1889880349)) (s0 := 0.9819793901) (s1 := 0.9819793902)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 1.760927835) (W := 0.0472416)
    ht0 ht1 vbpP339.1 vbpP339.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0472416) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.02304553)
    (ulo := (-0.2353610591)) (uhi := (-0.1887771853)) (vlo := 0.9719590417) (vhi := 0.9819793902)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP326.1, vbpP339.2]) (by linarith [vbpP353.2, vbpP339.1])
    ht0 ht1 (by norm_num) blkLin8
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_9 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    ((-0.004748819):ℝ) ≤ ∫ v in (vBP 1.222)..(vBP 1.25), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 1.974460086) (ylo := 0.403663759205) (yhi := 0.403663759206) (j := (0:ℤ))
    (c0 := (-0.3927902669)) (c1 := (-0.3927902668)) (s0 := 0.9196280804) (s1 := 0.9196280805)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 1.974460086) (W := 0.0529702)
    ht0 ht1 vbpP367.1 vbpP367.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0529702) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.022783)
    (ulo := (-0.4414803734)) (uhi := (-0.3922393419)) (vlo := 0.8975417658) (vhi := 0.9196280805)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP353.1, vbpP367.2]) (by linarith [vbpP381.2, vbpP367.1])
    ht0 ht1 (by norm_num) blkLin9
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_10 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    ((-0.0044916978):ℝ) ≤ ∫ v in (vBP 1.25)..(vBP 1.278), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.183208803) (ylo := 0.612412476205) (yhi := 0.612412476206) (j := (0:ℤ))
    (c0 := (-0.5748431726)) (c1 := (-0.5748431724)) (s0 := 0.8182636048) (s1 := 0.818263607)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 2.183208803) (W := 0.0585704)
    ht0 ht1 vbpP395.1 vbpP395.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0585704) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.0222755)
    (ulo := (-0.6227418025)) (uhi := (-0.5738574568)) (vlo := 0.7832109349) (vhi := 0.818263607)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP381.1, vbpP395.2]) (by linarith [vbpP403.2, vbpP395.1])
    ht0 ht1 (by norm_num) blkLin10
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_11 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    ((-0.0026954725):ℝ) ≤ ∫ v in (vBP 1.278)..(vBP 1.303), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.365720483) (ylo := 0.794924156205) (yhi := 0.794924156206) (j := (0:ℤ))
    (c0 := (-0.7138104927)) (c1 := (-0.7138104906)) (s0 := 0.700338906) (s1 := 0.7003389338)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 2.365720483) (W := 0.0634668)
    ht0 ht1 vbpP408.1 vbpP408.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0634668) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.02160518)
    (ulo := (-0.7582289299)) (uhi := (-0.7123733463)) (vlo := 0.6536560246) (vhi := 0.7003389338)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP403.1, vbpP408.2]) (by linarith [vbpP414.2, vbpP408.1])
    ht0 ht1 (by norm_num) blkLin11
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_12 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    ((-0.0011569883):ℝ) ≤ ∫ v in (vBP 1.303)..(vBP 1.331), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.565977541) (ylo := 0.995181214205) (yhi := 0.995181214206) (j := (0:ℤ))
    (c0 := (-0.8388576477)) (c1 := (-0.8388576239)) (s0 := 0.5443508835) (s1 := 0.5443511462)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 2.565977541) (W := 0.0688394)
    ht0 ht1 vbpP417.1 vbpP417.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0688394) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.02137429)
    (ulo := (-0.8763008646)) (uhi := (-0.836870793)) (vlo := 0.4853607314) (vhi := 0.5443511462)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP414.1, vbpP417.2]) (by linarith [vbpP420.2, vbpP417.1])
    ht0 ht1 (by norm_num) blkLin12
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_13 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    (0.0014998215:ℝ) ≤ ∫ v in (vBP 1.331)..(vBP 1.36), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.762021424) (ylo := 1.191225097205) (yhi := 1.191225097206) (j := (0:ℤ))
    (c0 := (-0.9288237601)) (c1 := (-0.9288235883)) (s0 := 0.3705222344) (s1 := 0.3705238201)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 2.762021424) (W := 0.0740991)
    ht0 ht1 vbpP423.1 vbpP423.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0740991) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.02218152)
    (ulo := (-0.9562541238)) (uhi := (-0.9262748198)) (vlo := 0.3007434515) (vhi := 0.3705238201)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP420.1, vbpP423.2]) (by linarith [vbpP429.2, vbpP423.1])
    ht0 ht1 (by norm_num) blkLin13
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_14 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    (0.0035604496:ℝ) ≤ ∫ v in (vBP 1.36)..(vBP 1.39), errFun v * Real.cos (t * v) := by
  have hp := trigPoint1 (X := 2.960810345) (ylo := 1.390014018205) (yhi := 1.390014018206) (j := (0:ℤ))
    (c0 := (-0.9837042616)) (c1 := (-0.9837033238)) (s0 := 0.1797990804) (s1 := 0.1798065009)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 2.960810345) (W := 0.0794328)
    ht0 ht1 vbpP435.1 vbpP435.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0794328) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.02315542)
    (ulo := (-0.9979717808)) (uhi := (-0.9806015828)) (vlo := 0.1011759113) (vhi := 0.1798065009)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP429.1, vbpP435.2]) (by linarith [vbpP442.2, vbpP435.1])
    ht0 ht1 (by norm_num) blkLin14
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_15 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    (0.0041365741:ℝ) ≤ ∫ v in (vBP 1.39)..(vBP 1.42), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 3.162086386) (ylo := 0.02049373241) (yhi := 0.020493732411) (j := (0:ℤ))
    (c0 := (-0.9997900109)) (c1 := (-0.9997900108)) (s0 := (-0.020492298)) (s1 := (-0.0204922979))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 3.162086386) (W := 0.0848338)
    ht0 ht1 vbpP448.1 vbpP448.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0848338) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.02266377)
    (ulo := (-0.9997900109)) (uhi := (-0.9944581816)) (vlo := (-0.1052065869)) (vhi := (-0.0204186028))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP442.1, vbpP448.2]) (by linarith [vbpP455.2, vbpP448.1])
    ht0 ht1 (by norm_num) blkLin15
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_16 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    (0.0035434931:ℝ) ≤ ∫ v in (vBP 1.42)..(vBP 1.45), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 3.359106203) (ylo := 0.21751354941) (yhi := 0.217513549411) (j := (0:ℤ))
    (c0 := (-0.9764370493)) (c1 := (-0.9764370492)) (s0 := (-0.2158024302)) (s1 := (-0.2158024301))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 3.359106203) (W := 0.0901218)
    ht0 ht1 vbpP461.1 vbpP461.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0901218) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.02219285)
    (ulo := (-0.9764370493)) (uhi := (-0.9530522637)) (vlo := (-0.3036816237)) (vhi := (-0.214926656))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP455.1, vbpP461.2]) (by linarith [vbpP468.2, vbpP461.1])
    ht0 ht1 (by norm_num) blkLin16
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_17 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    (0.0022527891:ℝ) ≤ ∫ v in (vBP 1.45)..(vBP 1.481), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 3.552045671) (ylo := 0.41045301741) (yhi := 0.410453017411) (j := (0:ℤ))
    (c0 := (-0.9169401518)) (c1 := (-0.9169401517)) (s0 := (-0.3990247588)) (s1 := (-0.3990247587))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 3.552045671) (W := 0.0953022)
    ht0 ht1 vbpP474.1 vbpP474.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.0953022) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.0230925)
    (ulo := (-0.9169401518)) (uhi := (-0.874808845)) (vlo := (-0.4862789513)) (vhi := (-0.3972140567))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP468.1, vbpP474.2]) (by linarith [vbpP480.2, vbpP474.1])
    ht0 ht1 (by norm_num) blkLin17
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_18 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    (0.000688788:ℝ) ≤ ∫ v in (vBP 1.481)..(vBP 1.512), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 3.747304985) (ylo := 0.60571233141) (yhi := 0.605712331411) (j := (0:ℤ))
    (c0 := (-0.8220967438)) (c1 := (-0.8220967418)) (s0 := (-0.5693478261)) (s1 := (-0.5693478259))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 3.747304985) (W := 0.1005478)
    ht0 ht1 vbpP485.1 vbpP485.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1005478) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.02261815)
    (ulo := (-0.8220967438)) (uhi := (-0.7607943393)) (vlo := (-0.6518686353)) (vhi := (-0.5664722363))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP480.1, vbpP485.2]) (by linarith [vbpP490.2, vbpP485.1])
    ht0 ht1 (by norm_num) blkLin18
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_19 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    ((-0.0002062453):ℝ) ≤ ∫ v in (vBP 1.512)..(vBP 1.546), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 3.950759045) (ylo := 0.80916639141) (yhi := 0.809166391411) (j := (0:ℤ))
    (c0 := (-0.6901019984)) (c1 := (-0.6901019651)) (s0 := (-0.7237121534)) (s1 := (-0.7237121509))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 3.950759045) (W := 0.1060189)
    ht0 ht1 vbpP494.1 vbpP494.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1060189) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.02342962)
    (ulo := (-0.6901019984)) (uhi := (-0.6096437094)) (vlo := (-0.7967390248)) (vhi := (-0.7196486942))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP490.1, vbpP494.2]) (by linarith [vbpP499.2, vbpP494.1])
    ht0 ht1 (by norm_num) blkLin19
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_20 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    ((-0.0006133332):ℝ) ≤ ∫ v in (vBP 1.546)..(vBP 1.578), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 4.155828986) (ylo := 1.01423633241) (yhi := 1.014236332411) (j := (0:ℤ))
    (c0 := (-0.5282688134)) (c1 := (-0.5282684959)) (s0 := (-0.849077407)) (s1 := (-0.8490773776))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 4.155828986) (W := 0.1115417)
    ht0 ht1 vbpP503.1 vbpP503.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1115417) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.02060152)
    (ulo := (-0.5282688134)) (uhi := (-0.4304743872)) (vlo := (-0.9078793002)) (vhi := (-0.8438009319))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP499.1, vbpP503.2]) (by linarith [vbpP507.2, vbpP503.1])
    ht0 ht1 (by norm_num) blkLin20
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_21 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    ((-0.0005458253):ℝ) ≤ ∫ v in (vBP 1.578)..(vBP 1.614), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 4.344792693) (ylo := 1.20320003941) (yhi := 1.203200039411) (j := (0:ℤ))
    (c0 := (-0.3593750758)) (c1 := (-0.3593733233)) (s0 := (-0.9331940609)) (s1 := (-0.9331938691))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 4.344792693) (W := 0.1166421)
    ht0 ht1 vbpP511.1 vbpP511.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1166421) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.02495758)
    (ulo := (-0.3593750758)) (uhi := (-0.2483283293)) (vlo := (-0.9750173368)) (vhi := (-0.9268528349))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP507.1, vbpP511.2]) (by linarith [vbpP516.2, vbpP511.1])
    ht0 ht1 (by norm_num) blkLin21
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_22 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    ((-0.0001666618):ℝ) ≤ ∫ v in (vBP 1.614)..(vBP 1.648), errFun v * Real.cos (t * v) := by
  have hp := trigPoint2 (X := 4.564310116) (ylo := 1.42271746241) (yhi := 1.422717462411) (j := (0:ℤ))
    (c0 := (-0.1475475158)) (c1 := (-0.1475381525)) (s0 := (-0.9890575395)) (s1 := (-0.9890563284))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 4.564310116) (W := 0.1225873)
    ht0 ht1 vbpP519.1 vbpP519.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1225873) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.02220681)
    (ulo := (-0.1475475158)) (uhi := (-0.0254885164)) (vlo := (-1.0070997232)) (vhi := (-0.9816340361))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP516.1, vbpP519.2]) (by linarith [vbpP521.2, vbpP519.1])
    ht0 ht1 (by norm_num) blkLin22
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_23 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    ((-0.0002470236):ℝ) ≤ ∫ v in (vBP 1.648)..(vBP 1.68), errFun v * Real.cos (t * v) := by
  have hp := trigPoint3 (X := 4.745226062) (ylo := 0.032837081615) (yhi := 0.032837081616) (j := (0:ℤ))
    (c0 := 0.0328311807) (c1 := 0.0328311808) (s0 := (-0.9994609115)) (s1 := (-0.9994609114))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 4.745226062) (W := 0.1275104)
    ht0 ht1 vbpP523.1 vbpP523.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1275104) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.01936289)
    (ulo := 0.0325646426) (uhi := 0.1599277785) (vlo := (-0.9994609115)) (vhi := (-0.9871718635))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP521.1, vbpP523.2]) (by linarith [vbpP525.2, vbpP523.1])
    ht0 ht1 (by norm_num) blkLin23
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_24 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    ((-0.0005626147):ℝ) ≤ ∫ v in (vBP 1.68)..(vBP 1.712), errFun v * Real.cos (t * v) := by
  have hp := trigPoint3 (X := 4.922680875) (ylo := 0.210291894615) (yhi := 0.210291894616) (j := (0:ℤ))
    (c0 := 0.2087453729) (c1 := 0.208745373) (s0 := (-0.9779700248)) (s1 := (-0.9779700247))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 4.922680875) (W := 0.1323678)
    ht0 ht1 vbpP527.1 vbpP527.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1323678) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.01901515)
    (ulo := 0.2069193031) (uhi := 0.337819419) (vlo := (-0.9779700248)) (vhi := (-0.9418643581))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP525.1, vbpP527.2]) (by linarith [vbpP529.2, vbpP527.1])
    ht0 ht1 (by norm_num) blkLin24
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_25 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    ((-0.0011212348):ℝ) ≤ ∫ v in (vBP 1.712)..(vBP 1.75), errFun v * Real.cos (t * v) := by
  have hp := trigPoint3 (X := 5.129084795) (ylo := 0.416695814615) (yhi := 0.416695814616) (j := (0:ℤ))
    (c0 := 0.4047412175) (c1 := 0.4047412176) (s0 := (-0.9144312697)) (s1 := (-0.9144312696))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 5.129084795) (W := 0.1380661)
    ht0 ht1 vbpP532.1 vbpP532.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1380661) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.02562316)
    (ulo := 0.4008897028) (uhi := 0.5305924512) (vlo := (-0.9144312697)) (vhi := (-0.8500258736))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP529.1, vbpP532.2]) (by linarith [vbpP534.2, vbpP532.1])
    ht0 ht1 (by norm_num) blkLin25
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_26 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    ((-0.0010453787):ℝ) ≤ ∫ v in (vBP 1.75)..(vBP 1.788), errFun v * Real.cos (t * v) := by
  have hp := trigPoint3 (X := 5.299392807) (ylo := 0.587003826615) (yhi := 0.587003826616) (j := (0:ℤ))
    (c0 := 0.553868887) (c1 := 0.5538688872) (s0 := (-0.8326039024)) (s1 := (-0.8326039009))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 5.299392807) (W := 0.1428203)
    ht0 ht1 vbpP536.1 vbpP536.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1428203) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.0249125)
    (ulo := 0.5482296737) (uhi := 0.672377782) (vlo := (-0.8326039024)) (vhi := (-0.7452916753))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP534.1, vbpP536.2]) (by linarith [vbpP539.2, vbpP536.1])
    ht0 ht1 (by norm_num) blkLin26
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_27 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    ((-0.000559464):ℝ) ≤ ∫ v in (vBP 1.788)..(vBP 1.828), errFun v * Real.cos (t * v) := by
  have hp := trigPoint3 (X := 5.497628693) (ylo := 0.785239712615) (yhi := 0.785239712616) (j := (0:ℤ))
    (c0 := 0.7069947306) (c1 := 0.7069947325) (s0 := (-0.7072188384)) (s1 := (-0.7072188138))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 5.497628693) (W := 0.1484333)
    ht0 ht1 vbpP541.1 vbpP541.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1484333) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.02665257)
    (ulo := 0.6992206088) (uhi := 0.8115845076) (vlo := (-0.7072188384)) (vhi := (-0.5948855956))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP539.1, vbpP541.2]) (by linarith [vbpP543.2, vbpP541.1])
    ht0 ht1 (by norm_num) blkLin27
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_28 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    (0.000103802:ℝ) ≤ ∫ v in (vBP 1.828)..(vBP 1.86), errFun v * Real.cos (t * v) := by
  have hp := trigPoint3 (X := 5.701775947) (ylo := 0.989386966615) (yhi := 0.989386966616) (j := (0:ℤ))
    (c0 := 0.8356894561) (c1 := 0.8356894785) (s0 := (-0.5492025152)) (s1 := (-0.5492022674))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 5.701775947) (W := 0.1543304)
    ht0 ht1 vbpP544.1 vbpP544.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1543304) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.01769411)
    (ulo := 0.8257570213) (uhi := 0.9201120611) (vlo := (-0.5492025152)) (vhi := (-0.4142138973))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP543.1, vbpP544.2]) (by linarith [vbpP545.2, vbpP544.1])
    ht0 ht1 (by norm_num) blkLin28
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_29 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    ((-0.0003271147):ℝ) ≤ ∫ v in (vBP 1.86)..(vBP 1.89), errFun v * Real.cos (t * v) := by
  have hp := trigPoint3 (X := 5.856913933) (ylo := 1.144524952615) (yhi := 1.144524952616) (j := (0:ℤ))
    (c0 := 0.9105137818) (c1 := 0.9105138925) (s0 := (-0.4134797718)) (s1 := (-0.4134787088))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 5.856913933) (W := 0.1589136)
    ht0 ht1 vbpP546.1 vbpP546.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1589136) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.01641361)
    (ulo := 0.8990411115) (uhi := 0.9759452426) (vlo := (-0.4134797718)) (vhi := (-0.2641839804))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP545.1, vbpP546.2]) (by linarith [vbpP547.2, vbpP546.1])
    ht0 ht1 (by norm_num) blkLin29
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_30 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    (0.0001150021:ℝ) ≤ ∫ v in (vBP 1.89)..(vBP 1.922), errFun v * Real.cos (t * v) := by
  have hp := trigPoint3 (X := 6.009452319) (ylo := 1.297063338615) (yhi := 1.297063338616) (j := (0:ℤ))
    (c0 := 0.9627684735) (c1 := 0.9627689115) (s0 := (-0.2703309824)) (s1 := (-0.2703272683))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 6.009452319) (W := 0.1635266)
    ht0 ht1 vbpP548.1 vbpP548.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1635266) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.01731057)
    (ulo := 0.9499244622) (uhi := 1.0067784615) (vlo := (-0.2703309824)) (vhi := (-0.1099833224))
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP547.1, vbpP548.2]) (by linarith [vbpP549.2, vbpP548.1])
    ht0 ht1 (by norm_num) blkLin30
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_31 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    ((-0.0005536826):ℝ) ≤ ∫ v in (vBP 1.922)..(vBP 1.954), errFun v * Real.cos (t * v) := by
  have hp := trigPoint3 (X := 6.164262551) (ylo := 1.451873570615) (yhi := 1.451873570616) (j := (0:ℤ))
    (c0 := 0.9929369987) (c1 := 0.9929385126) (s0 := (-0.1186539291)) (s1 := (-0.11864246))
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 6.164262551) (W := 0.1683393)
    ht0 ht1 vbpP550.1 vbpP550.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1683393) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.01716169)
    (ulo := 0.9789012075) (uhi := 1.0128184274) (vlo := (-0.1186539291)) (vhi := 0.0493968626)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP549.1, vbpP550.2]) (by linarith [vbpP551.2, vbpP550.1])
    ht0 ht1 (by norm_num) blkLin31
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_32 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    ((-0.000543223):ℝ) ≤ ∫ v in (vBP 1.954)..(vBP 1.984), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 6.311739709) (ylo := 0.02855440182) (yhi := 0.028554401821) (j := (1:ℤ))
    (c0 := 0.9995923507) (c1 := 0.9995923508) (s0 := 0.0285505216) (s1 := 0.0285505217)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 6.311739709) (W := 0.1730715)
    ht0 ht1 vbpP552.1 vbpP552.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1730715) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.01603265)
    (ulo := 0.9797422656) (uhi := 0.9995923508) (vlo := 0.0281239903) (vhi := 0.2006890909)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP551.1, vbpP552.2]) (by linarith [vbpP553.2, vbpP552.1])
    ht0 ht1 (by norm_num) blkLin32
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_33 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    ((-0.0007791882):ℝ) ≤ ∫ v in (vBP 1.984)..(vBP 2.016), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 6.456826282) (ylo := 0.17364097482) (yhi := 0.173640974821) (j := (1:ℤ))
    (c0 := 0.9849622468) (c1 := 0.9849622469) (s0 := 0.172769709) (s1 := 0.1727697091)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 6.456826282) (W := 0.1778937)
    ht0 ht1 vbpP554.1 vbpP554.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1778937) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.01698487)
    (ulo := 0.9388453701) (uhi := 0.9849622469) (vlo := 0.1700431611) (vhi := 0.3470655827)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP553.1, vbpP554.2]) (by linarith [vbpP555.2, vbpP554.1])
    ht0 ht1 (by norm_num) blkLin33
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_34 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    ((-0.0006735727):ℝ) ≤ ∫ v in (vBP 2.016)..(vBP 2.046), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 6.599582417) (ylo := 0.31639710982) (yhi := 0.316397109821) (j := (1:ℤ))
    (c0 := 0.9503626034) (c1 := 0.9503626035) (s0 := 0.3111445353) (s1 := 0.3111445354)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 6.599582417) (W := 0.1828286)
    ht0 ht1 vbpP556.1 vbpP556.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1828286) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.01598297)
    (ulo := 0.8779535131) (uhi := 0.9503626035) (vlo := 0.3059587996) (vhi := 0.4839316271)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP555.1, vbpP556.2]) (by linarith [vbpP557.2, vbpP556.1])
    ht0 ht1 (by norm_num) blkLin34
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_35 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    ((-0.0006512362):ℝ) ≤ ∫ v in (vBP 2.046)..(vBP 2.078), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 6.740064279) (ylo := 0.45687897182) (yhi := 0.456878971821) (j := (1:ℤ))
    (c0 := 0.8974337056) (c1 := 0.8974337058) (s0 := 0.4411493442) (s1 := 0.4411493443)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 6.740064279) (W := 0.1879001)
    ht0 ht1 vbpP558.1 vbpP558.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1879001) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.0170124)
    (ulo := 0.799232569) (uhi := 0.8974337058) (vlo := 0.4333845221) (vhi := 0.6087867024)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP557.1, vbpP558.2]) (by linarith [vbpP559.2, vbpP558.1])
    ht0 ht1 (by norm_num) blkLin35
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

theorem cosLB121_36 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    ((-0.000215445):ℝ) ≤ ∫ v in (vBP 2.078)..(vBP 2.094), errFun v * Real.cos (t * v) := by
  have hp := trigPoint0 (X := 6.811698563) (ylo := 0.52851325582) (yhi := 0.528513255821) (j := (1:ℤ))
    (c0 := 0.8635577154) (c1 := 0.8635577159) (s0 := 0.5042500095) (s1 := 0.5042500096)
    (by norm_num) (by linarith [Real.pi_gt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by push_cast; linarith [Real.pi_gt_d20, Real.pi_lt_d20])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
    (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
  have hm := mul_mem_of_bracket (t0 := 4.659375) (t1 := 4.784375) (X0 := 6.811698563) (W := 0.1905794)
    ht0 ht1 vbpP559.1 vbpP559.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have hs := trig_shift_bracket (W := 0.1905794) (by norm_num) (by norm_num) hm.1 hm.2
    hp.1 hp.2.1 hp.2.2.1 hp.2.2.2
  exact errCos_block_ge_lin (t0 := 4.659375) (t1 := 4.784375) (d := 0.01705821)
    (ulo := 0.7524037084) (uhi := 0.8635577159) (vlo := 0.4951203842) (vhi := 0.6678318795)
    (vBP_mono (by norm_num) (by norm_num)) (by norm_num)
    (by linarith [vbpP559.1, vbpP559.2]) (by linarith [vbpP560.2, vbpP559.1])
    ht0 ht1 (by norm_num) blkLin36
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.1)
    (le_trans hs.2.1 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (le_trans (by norm_num [mn4, mx4, cosLoP, sinHiP]) hs.2.2.1)
    (le_trans hs.2.2.2 (by norm_num [mn4, mx4, cosLoP, sinHiP]))
    (by norm_num [mn4, mx4])

/-- Lower bound for `∫₀^∞ err(v) cos(tv) dv` on the band `4.659375 ≤ t ≤ 4.784375`. -/
theorem oscLinBand121 {t : ℝ} (ht0 : (4.659375:ℝ) ≤ t) (ht1 : t ≤ 4.784375) :
    ((-0.0689454541):ℝ) ≤ ∫ v in Ioi (0:ℝ), errFun v * Real.cos (t * v) := by
  have hsum := (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (errCos_add_ge (cosLB121_0 ht0 ht1)
    (cosLB121_1 ht0 ht1))
    (cosLB121_2 ht0 ht1))
    (cosLB121_3 ht0 ht1))
    (cosLB121_4 ht0 ht1))
    (cosLB121_5 ht0 ht1))
    (cosLB121_6 ht0 ht1))
    (cosLB121_7 ht0 ht1))
    (cosLB121_8 ht0 ht1))
    (cosLB121_9 ht0 ht1))
    (cosLB121_10 ht0 ht1))
    (cosLB121_11 ht0 ht1))
    (cosLB121_12 ht0 ht1))
    (cosLB121_13 ht0 ht1))
    (cosLB121_14 ht0 ht1))
    (cosLB121_15 ht0 ht1))
    (cosLB121_16 ht0 ht1))
    (cosLB121_17 ht0 ht1))
    (cosLB121_18 ht0 ht1))
    (cosLB121_19 ht0 ht1))
    (cosLB121_20 ht0 ht1))
    (cosLB121_21 ht0 ht1))
    (cosLB121_22 ht0 ht1))
    (cosLB121_23 ht0 ht1))
    (cosLB121_24 ht0 ht1))
    (cosLB121_25 ht0 ht1))
    (cosLB121_26 ht0 ht1))
    (cosLB121_27 ht0 ht1))
    (cosLB121_28 ht0 ht1))
    (cosLB121_29 ht0 ht1))
    (cosLB121_30 ht0 ht1))
    (cosLB121_31 ht0 ht1))
    (cosLB121_32 ht0 ht1))
    (cosLB121_33 ht0 ht1))
    (cosLB121_34 ht0 ht1))
    (cosLB121_35 ht0 ht1))
    (cosLB121_36 ht0 ht1))
  rw [vBP_one] at hsum
  have hsplit := integral_Ioi_errFun_cos_split t (c := vBP 2.094) (vBP_nonneg (by norm_num))
  have htail := abs_integral_Ioi_errFun_cos_le (t := t) (c := vBP 2.094) (S := 0.013709)
    (vBP_nonneg (by norm_num)) integral_Ioi_abs_errFun_tail_cut
  rw [abs_le] at htail
  rw [hsplit]
  linarith [hsum, htail.1]

end ConnesConsani.WeilPositivity
