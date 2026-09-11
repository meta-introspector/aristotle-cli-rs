/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The Fourier-side inequality of Corollary 2.3 (ii) of

  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771,

on a neighbourhood of the origin.
-/
import RequestProject.Imported.OutputFinal.RequestProject.GammaBound

noncomputable section

open MeasureTheory Set Real Filter Topology

namespace ConnesConsani.WeilPositivity

/-! ## 1. The truncated kernel of `Θ` -/

/-- The first eight terms of the kernel `k_Θ(v) = 2 e^{-v/2}/(1-e^{-2v})` of
`Θ(t) = 2θ'(t) - 2θ'(0) = ∫₀^∞ k_Θ(v)(1 - cos tv) dv`. -/
def thetaTruncKernel (v : ℝ) : ℝ :=
  ∑ n ∈ Finset.range 8, 2 * Real.exp (-((2 * (n : ℝ) + 1 / 2) * v))

/-! ## 2. The elementary Laplace transform -/

/-- An antiderivative of `v ↦ e^{-cv}(1 - cos tv)`. -/
def lapAux (c t v : ℝ) : ℝ :=
  -Real.exp (-(c * v)) / c
    + Real.exp (-(c * v)) * (c * Real.cos (t * v) - t * Real.sin (t * v)) / (c ^ 2 + t ^ 2)

theorem continuous_lapAux (c t : ℝ) : Continuous (lapAux c t) := by
  unfold lapAux; fun_prop

theorem lapAux_zero (c t : ℝ) : lapAux c t 0 = -(1 / c) + c / (c ^ 2 + t ^ 2) := by
  simp [lapAux]
  ring

theorem hasDerivAt_lapAux {c : ℝ} (hc : 0 < c) (t v : ℝ) :
    HasDerivAt (lapAux c t) (Real.exp (-(c * v)) * (1 - Real.cos (t * v))) v := by
  have hct : (0:ℝ) < c ^ 2 + t ^ 2 := by positivity
  have he : HasDerivAt (fun v : ℝ => Real.exp (-(c * v))) (-c * Real.exp (-(c * v))) v := by
    have h0 : HasDerivAt (fun v : ℝ => -(c * v)) (-c) v := by
      simpa using ((hasDerivAt_id v).const_mul c).neg
    simpa [mul_comm] using h0.exp
  have hcs : HasDerivAt (fun v : ℝ => Real.cos (t * v)) (-(t * Real.sin (t * v))) v := by
    have h0 : HasDerivAt (fun v : ℝ => t * v) t v := by simpa using (hasDerivAt_id v).const_mul t
    simpa [mul_comm] using h0.cos
  have hsn : HasDerivAt (fun v : ℝ => Real.sin (t * v)) (t * Real.cos (t * v)) v := by
    have h0 : HasDerivAt (fun v : ℝ => t * v) t v := by simpa using (hasDerivAt_id v).const_mul t
    simpa [mul_comm] using h0.sin
  have hg := he.mul ((hcs.const_mul c).sub (hsn.const_mul t))
  have hfull := ((he.neg.div_const c).add (hg.div_const (c ^ 2 + t ^ 2)))
  convert hfull using 1
  simp only [Pi.sub_apply]
  field_simp
  ring

theorem tendsto_lapAux {c : ℝ} (hc : 0 < c) (t : ℝ) :
    Tendsto (lapAux c t) atTop (𝓝 0) := by
  have hct : (0:ℝ) < c ^ 2 + t ^ 2 := by positivity
  have hexp : Tendsto (fun v : ℝ => Real.exp (-(c * v))) atTop (𝓝 0) :=
    Real.tendsto_exp_atBot.comp
      (Filter.tendsto_neg_atTop_atBot.comp (Filter.Tendsto.const_mul_atTop hc tendsto_id))
  have hbdd : Tendsto (fun v : ℝ =>
      Real.exp (-(c * v)) * (c * Real.cos (t * v) - t * Real.sin (t * v))) atTop (𝓝 0) := by
    refine squeeze_zero_norm (a := fun v : ℝ => Real.exp (-(c * v)) * (|c| + |t|)) ?_ ?_
    · intro v
      rw [norm_mul, Real.norm_eq_abs, Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
      have h1 : |c * Real.cos (t * v) - t * Real.sin (t * v)| ≤ |c| + |t| := by
        calc |c * Real.cos (t * v) - t * Real.sin (t * v)|
            ≤ |c * Real.cos (t * v)| + |t * Real.sin (t * v)| := abs_sub _ _
          _ ≤ |c| + |t| := by
              rw [abs_mul, abs_mul]
              nlinarith [abs_nonneg c, abs_nonneg t, Real.abs_cos_le_one (t * v),
                Real.abs_sin_le_one (t * v), abs_nonneg (Real.cos (t * v)),
                abs_nonneg (Real.sin (t * v))]
      exact mul_le_mul_of_nonneg_left h1 (Real.exp_pos _).le
    · simpa using hexp.mul_const (|c| + |t|)
  have h := ((hexp.neg.div_const c).add (hbdd.div_const (c ^ 2 + t ^ 2)))
  simp only [neg_zero, zero_div, add_zero] at h
  simpa [lapAux] using h

theorem exp_one_sub_cos_nonneg (c t : ℝ) (v : ℝ) :
    0 ≤ Real.exp (-(c * v)) * (1 - Real.cos (t * v)) := by
  have h1 := Real.cos_le_one (t * v)
  have h2 := (Real.exp_pos (-(c * v))).le
  nlinarith

theorem integrableOn_exp_one_sub_cos {c : ℝ} (hc : 0 < c) (t : ℝ) :
    IntegrableOn (fun v => Real.exp (-(c * v)) * (1 - Real.cos (t * v))) (Ioi 0) :=
  integrableOn_Ioi_deriv_of_nonneg (continuous_lapAux c t).continuousWithinAt
    (fun x _ => hasDerivAt_lapAux hc t x) (fun x _ => exp_one_sub_cos_nonneg c t x)
    (tendsto_lapAux hc t)

/-- `∫₀^∞ e^{-cv}(1 - cos tv) dv = 1/c - c/(c²+t²)`. -/
theorem integral_Ioi_exp_one_sub_cos {c : ℝ} (hc : 0 < c) (t : ℝ) :
    ∫ v in Ioi (0:ℝ), Real.exp (-(c * v)) * (1 - Real.cos (t * v))
      = 1 / c - c / (c ^ 2 + t ^ 2) := by
  have h := integral_Ioi_of_hasDerivAt_of_nonneg (a := (0:ℝ))
    (continuous_lapAux c t).continuousWithinAt
    (fun x (_ : x ∈ Ioi (0:ℝ)) => hasDerivAt_lapAux hc t x)
    (fun x (_ : x ∈ Ioi (0:ℝ)) => exp_one_sub_cos_nonneg c t x)
    (tendsto_lapAux hc t)
  rw [h, lapAux_zero]
  ring

/-- The integral of the truncated kernel against `1 - cos tv` is the corresponding partial
sum of the digamma series for `Θ`. -/
theorem integral_thetaTruncKernel (t : ℝ) :
    ∫ v in Ioi (0:ℝ), thetaTruncKernel v * (1 - Real.cos (t * v))
      = ∑ n ∈ Finset.range 8, thetaSeriesTerm t n := by
  have hexp : (fun v : ℝ => thetaTruncKernel v * (1 - Real.cos (t * v)))
      = fun v : ℝ => ∑ n ∈ Finset.range 8,
          2 * (Real.exp (-((2 * (n : ℝ) + 1 / 2) * v)) * (1 - Real.cos (t * v))) := by
    funext v
    rw [thetaTruncKernel, Finset.sum_mul]
    exact Finset.sum_congr rfl fun n _ => by ring
  rw [hexp, MeasureTheory.integral_finset_sum]
  · refine Finset.sum_congr rfl fun n _ => ?_
    have hn : (0:ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
    have hc : (0:ℝ) < 2 * (n : ℝ) + 1 / 2 := by linarith
    rw [MeasureTheory.integral_const_mul, integral_Ioi_exp_one_sub_cos hc]
    have h1 : ((n : ℝ) + 1 / 4) ≠ 0 := by positivity
    have h2 : ((n : ℝ) + 1 / 4) ^ 2 + t ^ 2 / 4 ≠ 0 := by positivity
    have h3 : (2 * (n : ℝ) + 1 / 2) ^ 2 + t ^ 2 ≠ 0 := by positivity
    have h4 : (2 * (n : ℝ) + 1 / 2) ≠ 0 := by linarith
    rw [thetaSeriesTerm, poleAbscissa]
    field_simp
    ring
  · intro n _
    have hn : (0:ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
    have hc : (0:ℝ) < 2 * (n : ℝ) + 1 / 2 := by linarith
    exact (integrableOn_exp_one_sub_cos hc t).const_mul 2

/-! ## 3. The majorant -/

/-- The elementary majorant of `v ↦ v² (2δ(e^v) - k_{Θ,8}(v))` on `[1/5,∞)`. -/
def nearMajorant (v : ℝ) : ℝ :=
  Real.exp (-(3 * v / 2)) * (2 * v ^ 2 + 2 * v + 1) / π ^ 2
    + Real.exp (-(5 * v / 2)) * (5 * v ^ 3 + 16 * v ^ 2 + 15 * v + 5) / (2 * π ^ 3)
    + Real.exp (-(33 * v / 2)) * (2 * v ^ 2 + v)

/-- The majorant, cut off below `1/5`. -/
def nearMajorantInd (v : ℝ) : ℝ := if 1 / 5 ≤ v then nearMajorant v else 0

theorem nearMajorant_nonneg {v : ℝ} (hv : 0 ≤ v) : 0 ≤ nearMajorant v := by
  have hπ := Real.pi_pos
  unfold nearMajorant
  positivity

theorem nearMajorantInd_nonneg (v : ℝ) : 0 ≤ nearMajorantInd v := by
  unfold nearMajorantInd
  split_ifs with h
  · exact nearMajorant_nonneg (by linarith)
  · exact le_refl 0

/-- An explicit antiderivative of `-nearMajorant`: for each term `e^{-av/2} p(v)` of the
majorant, `-e^{-av/2} q(v)` with `(a/2) q - q' = p` is a primitive. -/
def nearAnti (v : ℝ) : ℝ :=
  -(Real.exp (-(3 * v / 2)) * (4 / 3 * v ^ 2 + (28 / 9 * v + 74 / 27)) / π ^ 2)
    - Real.exp (-(5 * v / 2)) *
        (2 * v ^ 3 + (44 / 5 * v ^ 2 + (326 / 25 * v + 902 / 125))) / (2 * π ^ 3)
    - Real.exp (-(33 * v / 2)) *
        (4 / 33 * v ^ 2 + ((2 / 33 + 16 / 1089) * v + (4 / 1089 + 32 / 35937)))

theorem continuous_nearAnti : Continuous nearAnti := by
  unfold nearAnti; fun_prop

theorem hasDerivAt_exp_half (a v : ℝ) :
    HasDerivAt (fun v : ℝ => Real.exp (-(a * v / 2)))
      (Real.exp (-(a * v / 2)) * (-(a / 2))) v := by
  have h : HasDerivAt (fun v : ℝ => -(a * v / 2)) (-(a / 2)) v := by
    simpa using (((hasDerivAt_id v).const_mul a).div_const 2).neg
  simpa using h.exp

theorem hasDerivAt_poly2 (c2 c1 c0 v : ℝ) :
    HasDerivAt (fun v : ℝ => c2 * v ^ 2 + (c1 * v + c0)) (2 * c2 * v + c1) v := by
  have hA : HasDerivAt (fun y : ℝ => c2 * y ^ 2) (2 * c2 * v) v := by
    have h := (hasDerivAt_pow 2 v).const_mul c2
    convert h using 1
    push_cast
    ring
  have hB : HasDerivAt (fun y : ℝ => c1 * y + c0) c1 v := by
    have h := ((hasDerivAt_id v).const_mul c1).add_const c0
    simpa using h
  exact hA.add hB

theorem hasDerivAt_poly3 (c3 c2 c1 c0 v : ℝ) :
    HasDerivAt (fun v : ℝ => c3 * v ^ 3 + (c2 * v ^ 2 + (c1 * v + c0)))
      (3 * c3 * v ^ 2 + (2 * c2 * v + c1)) v := by
  have hA : HasDerivAt (fun y : ℝ => c3 * y ^ 3) (3 * c3 * v ^ 2) v := by
    have h := (hasDerivAt_pow 3 v).const_mul c3
    convert h using 1
    push_cast
    ring
  exact hA.add (hasDerivAt_poly2 c2 c1 c0 v)

theorem hasDerivAt_exp_half_quad (a c2 c1 c0 v : ℝ) :
    HasDerivAt (fun v : ℝ => Real.exp (-(a * v / 2)) * (c2 * v ^ 2 + (c1 * v + c0)))
      (Real.exp (-(a * v / 2)) *
        ((2 * c2 * v + c1) - a / 2 * (c2 * v ^ 2 + (c1 * v + c0)))) v := by
  have h := (hasDerivAt_exp_half a v).mul (hasDerivAt_poly2 c2 c1 c0 v)
  convert h using 1
  ring

theorem hasDerivAt_exp_half_cubic (a c3 c2 c1 c0 v : ℝ) :
    HasDerivAt
      (fun v : ℝ => Real.exp (-(a * v / 2)) * (c3 * v ^ 3 + (c2 * v ^ 2 + (c1 * v + c0))))
      (Real.exp (-(a * v / 2)) *
        ((3 * c3 * v ^ 2 + (2 * c2 * v + c1))
          - a / 2 * (c3 * v ^ 3 + (c2 * v ^ 2 + (c1 * v + c0))))) v := by
  have h := (hasDerivAt_exp_half a v).mul (hasDerivAt_poly3 c3 c2 c1 c0 v)
  convert h using 1
  ring

/-- `nearAnti' = nearMajorant`. -/
theorem hasDerivAt_nearAnti (v : ℝ) : HasDerivAt nearAnti (nearMajorant v) v := by
  have h1 := ((hasDerivAt_exp_half_quad 3 (4 / 3) (28 / 9) (74 / 27) v).div_const (π ^ 2)).neg
  have h2 := (hasDerivAt_exp_half_cubic 5 2 (44 / 5) (326 / 25) (902 / 125) v).div_const
    (2 * π ^ 3)
  have h3 := hasDerivAt_exp_half_quad 33 (4 / 33) (2 / 33 + 16 / 1089)
    (4 / 1089 + 32 / 35937) v
  have h := (h1.sub h2).sub h3
  have hpi : π ≠ 0 := Real.pi_ne_zero
  unfold nearAnti
  convert h using 1
  rw [nearMajorant]
  field_simp
  ring

/-- `v^k e^{-av/2} → 0`. -/
theorem tendsto_pow_mul_exp_half {a : ℝ} (ha : 0 < a) (k : ℕ) :
    Tendsto (fun v : ℝ => v ^ k * Real.exp (-(a * v / 2))) atTop (𝓝 0) := by
  have hmap : Tendsto (fun v : ℝ => a * v / 2) atTop atTop :=
    Filter.Tendsto.atTop_div_const (by norm_num)
      (Filter.Tendsto.const_mul_atTop ha tendsto_id)
  have h := (Real.tendsto_pow_mul_exp_neg_atTop_nhds_zero k).comp hmap
  have h2 := h.const_mul ((2 / a) ^ k)
  rw [mul_zero] at h2
  refine h2.congr fun v => ?_
  have h3 : (2 / a) ^ k * (a * v / 2) ^ k = v ^ k := by
    rw [← mul_pow]
    congr 1
    field_simp
  simp only [Function.comp_apply]
  rw [← mul_assoc, h3]

/-- `e^{-av/2} p(v) → 0` for a cubic `p`. -/
theorem tendsto_exp_half_cubic {a : ℝ} (ha : 0 < a) (c3 c2 c1 c0 : ℝ) :
    Tendsto (fun v : ℝ => Real.exp (-(a * v / 2)) * (c3 * v ^ 3 + c2 * v ^ 2 + c1 * v + c0))
      atTop (𝓝 0) := by
  have h3 := (tendsto_pow_mul_exp_half ha 3).const_mul c3
  have h2 := (tendsto_pow_mul_exp_half ha 2).const_mul c2
  have h1 := (tendsto_pow_mul_exp_half ha 1).const_mul c1
  have h0 := (tendsto_pow_mul_exp_half ha 0).const_mul c0
  have h := ((h3.add h2).add h1).add h0
  simp only [mul_zero, add_zero] at h
  refine h.congr fun v => ?_
  ring

theorem tendsto_nearAnti : Tendsto nearAnti atTop (𝓝 0) := by
  have h1 := ((tendsto_exp_half_cubic (a := 3) (by norm_num) 0 (4 / 3) (28 / 9)
    (74 / 27)).div_const (π ^ 2)).neg
  have h2 := (tendsto_exp_half_cubic (a := 5) (by norm_num) 2 (44 / 5) (326 / 25)
    (902 / 125)).div_const (2 * π ^ 3)
  have h3 := tendsto_exp_half_cubic (a := 33) (by norm_num) 0 (4 / 33)
    (2 / 33 + 16 / 1089) (4 / 1089 + 32 / 35937)
  have h := ((h1.sub h2).sub h3)
  simp only [neg_zero, zero_div, sub_self] at h
  refine h.congr fun v => ?_
  rw [nearAnti]
  ring

theorem integrableOn_nearMajorant_Ioi : IntegrableOn nearMajorant (Ioi (1 / 5 : ℝ)) :=
  integrableOn_Ioi_deriv_of_nonneg (a := (1 / 5 : ℝ)) continuous_nearAnti.continuousWithinAt
    (fun x (_ : x ∈ Ioi (1 / 5 : ℝ)) => hasDerivAt_nearAnti x)
    (fun x (hx : x ∈ Ioi (1 / 5 : ℝ)) => nearMajorant_nonneg (by
      have hx' : (1 / 5 : ℝ) < x := hx
      linarith)) tendsto_nearAnti

theorem integral_nearMajorant_Ioi :
    ∫ v in Ioi (1 / 5 : ℝ), nearMajorant v = 0 - nearAnti (1 / 5) :=
  integral_Ioi_of_hasDerivAt_of_nonneg (a := (1 / 5 : ℝ)) continuous_nearAnti.continuousWithinAt
    (fun x (_ : x ∈ Ioi (1 / 5 : ℝ)) => hasDerivAt_nearAnti x)
    (fun x (hx : x ∈ Ioi (1 / 5 : ℝ)) => nearMajorant_nonneg (by
      have hx' : (1 / 5 : ℝ) < x := hx
      linarith)) tendsto_nearAnti

theorem nearMajorantInd_eq : nearMajorantInd = Set.indicator (Ici (1 / 5 : ℝ)) nearMajorant := by
  funext v
  rw [nearMajorantInd, Set.indicator_apply]
  simp only [Set.mem_Ici]

theorem integrableOn_nearMajorantInd : IntegrableOn nearMajorantInd (Ioi 0) := by
  rw [nearMajorantInd_eq]
  have hsub : Ici (1 / 5 : ℝ) ∩ Ioi (0:ℝ) = Ici (1 / 5 : ℝ) := by
    ext x
    simp only [Set.mem_inter_iff, Set.mem_Ici, Set.mem_Ioi]
    exact ⟨fun h => h.1, fun h => ⟨h, by linarith⟩⟩
  have hInt : IntegrableOn nearMajorant (Ici (1 / 5 : ℝ)) :=
    integrableOn_nearMajorant_Ioi.congr_set_ae Ioi_ae_eq_Ici.symm
  rw [IntegrableOn, MeasureTheory.integrable_indicator_iff measurableSet_Ici,
    IntegrableOn, Measure.restrict_restrict measurableSet_Ici, hsub]
  exact hInt

/-- `exp (-3/10) ≤ 0.75`. -/
theorem exp_neg_three_tenths_le : Real.exp (-(3 / 10 : ℝ)) ≤ 0.75 := by
  have h := Real.sum_le_exp_of_nonneg (x := (3 / 10 : ℝ)) (by norm_num) 4
  have hs : (4 / 3 : ℝ) ≤ ∑ i ∈ Finset.range 4, (3 / 10 : ℝ) ^ i / (i.factorial : ℝ) := by
    norm_num [Finset.sum_range_succ, Nat.factorial]
  have hle : (4 / 3 : ℝ) ≤ Real.exp (3 / 10) := le_trans hs h
  have hinv := one_div_le_one_div_of_le (by norm_num : (0:ℝ) < 4 / 3) hle
  rw [Real.exp_neg, inv_eq_one_div]
  norm_num at hinv ⊢
  linarith

/-- `exp (-1/2) ≤ 0.61`. -/
theorem exp_neg_half_le : Real.exp (-(1 / 2 : ℝ)) ≤ 0.61 := by
  have h := Real.sum_le_exp_of_nonneg (x := (1 / 2 : ℝ)) (by norm_num) 5
  have hs : (1.6484 : ℝ) ≤ ∑ i ∈ Finset.range 5, (1 / 2 : ℝ) ^ i / (i.factorial : ℝ) := by
    norm_num [Finset.sum_range_succ, Nat.factorial]
  have hle : (1.6484 : ℝ) ≤ Real.exp (1 / 2) := le_trans hs h
  have hinv := one_div_le_one_div_of_le (by norm_num : (0:ℝ) < 1.6484) hle
  rw [Real.exp_neg, inv_eq_one_div]
  norm_num at hinv ⊢
  linarith

/-- `exp (-33/10) ≤ 0.04`. -/
theorem exp_neg_thirtythree_tenths_le : Real.exp (-(33 / 10 : ℝ)) ≤ 0.04 := by
  have h := Real.sum_le_exp_of_nonneg (x := (33 / 10 : ℝ)) (by norm_num) 8
  have hs : (25 : ℝ) ≤ ∑ i ∈ Finset.range 8, (33 / 10 : ℝ) ^ i / (i.factorial : ℝ) := by
    norm_num [Finset.sum_range_succ, Nat.factorial]
  have hle : (25 : ℝ) ≤ Real.exp (33 / 10) := le_trans hs h
  have hinv := one_div_le_one_div_of_le (by norm_num : (0:ℝ) < 25) hle
  rw [Real.exp_neg, inv_eq_one_div]
  norm_num at hinv ⊢
  linarith

/-- **The total mass of the majorant is at most `2/5`** (its true value is `0.3571…`). -/
theorem integral_nearMajorantInd_le : ∫ v in Ioi (0:ℝ), nearMajorantInd v ≤ 2 / 5 := by
  have hsub : Ioi (0:ℝ) ∩ Ici (1 / 5 : ℝ) = Ici (1 / 5 : ℝ) := by
    ext x
    simp only [Set.mem_inter_iff, Set.mem_Ici, Set.mem_Ioi]
    exact ⟨fun h => h.2, fun h => ⟨by linarith, h⟩⟩
  have hval : ∫ v in Ioi (0:ℝ), nearMajorantInd v = 0 - nearAnti (1 / 5) := by
    rw [nearMajorantInd_eq, MeasureTheory.setIntegral_indicator measurableSet_Ici, hsub,
      MeasureTheory.integral_Ici_eq_integral_Ioi, integral_nearMajorant_Ioi]
  rw [hval, nearAnti]
  have hpi2 : (9.8 : ℝ) ≤ π ^ 2 := by nlinarith [Real.pi_gt_d6, Real.pi_pos]
  have hpi3 : (31 : ℝ) ≤ π ^ 3 := by nlinarith [Real.pi_gt_d6, Real.pi_pos]
  have ha1 : Real.exp (-(3 * (1 / 5 : ℝ) / 2)) ≤ 0.75 := by
    have hx : (3 * (1 / 5 : ℝ) / 2) = 3 / 10 := by norm_num
    rw [hx]
    exact exp_neg_three_tenths_le
  have ha2 : Real.exp (-(5 * (1 / 5 : ℝ) / 2)) ≤ 0.61 := by
    have hx : (5 * (1 / 5 : ℝ) / 2) = 1 / 2 := by norm_num
    rw [hx]
    exact exp_neg_half_le
  have ha3 : Real.exp (-(33 * (1 / 5 : ℝ) / 2)) ≤ 0.04 := by
    have hx : (33 * (1 / 5 : ℝ) / 2) = 33 / 10 := by norm_num
    rw [hx]
    exact exp_neg_thirtythree_tenths_le
  have hb1 : Real.exp (-(3 * (1 / 5 : ℝ) / 2))
      * (4 / 3 * (1 / 5 : ℝ) ^ 2 + (28 / 9 * (1 / 5) + 74 / 27)) / π ^ 2 ≤ 0.27 := by
    have hnum : Real.exp (-(3 * (1 / 5 : ℝ) / 2))
        * (4 / 3 * (1 / 5 : ℝ) ^ 2 + (28 / 9 * (1 / 5) + 74 / 27)) ≤ 2.5623 := by
      nlinarith [Real.exp_pos (-(3 * (1 / 5 : ℝ) / 2))]
    have hpos : (0:ℝ) < π ^ 2 := by positivity
    rw [div_le_iff₀ hpos]
    nlinarith
  have hb2 : Real.exp (-(5 * (1 / 5 : ℝ) / 2))
      * (2 * (1 / 5 : ℝ) ^ 3 + (44 / 5 * (1 / 5) ^ 2 + (326 / 25 * (1 / 5) + 902 / 125)))
      / (2 * π ^ 3) ≤ 0.11 := by
    have hnum : Real.exp (-(5 * (1 / 5 : ℝ) / 2))
        * (2 * (1 / 5 : ℝ) ^ 3 + (44 / 5 * (1 / 5) ^ 2 + (326 / 25 * (1 / 5) + 902 / 125)))
        ≤ 6.22 := by
      nlinarith [Real.exp_pos (-(5 * (1 / 5 : ℝ) / 2))]
    have hpos : (0:ℝ) < 2 * π ^ 3 := by positivity
    rw [div_le_iff₀ hpos]
    nlinarith
  have hb3 : Real.exp (-(33 * (1 / 5 : ℝ) / 2))
      * (4 / 33 * (1 / 5 : ℝ) ^ 2 + ((2 / 33 + 16 / 1089) * (1 / 5)
        + (4 / 1089 + 32 / 35937))) ≤ 0.002 := by
    nlinarith [Real.exp_pos (-(33 * (1 / 5 : ℝ) / 2))]
  linarith

/-! ## 4. The pointwise comparison -/

/-- `Si x / x ≤ 0.132` for `x ≥ 4π`; the bound is attained (to three digits) at `x = 4π`. -/
theorem Si_div_le_of_four_pi_le {x : ℝ} (hx : 4 * π ≤ x) : Si x / x ≤ 0.132 := by
  have hπ : (3.14159 : ℝ) < π := by linarith [Real.pi_gt_d6]
  have hπ' : π < 3.1416 := by linarith [Real.pi_lt_d6]
  have hx0 : (12.56636 : ℝ) ≤ x := by linarith
  have hxpos : (0:ℝ) < x := by linarith
  have hSi := Si_le_of_pos hxpos
  rw [div_le_iff₀ hxpos]
  have h1 : 1 / x ≤ 1 / 12.56636 := by
    apply one_div_le_one_div_of_le (by norm_num) hx0
  have h2 : 1 / x ^ 2 ≤ 1 / 12.56636 ^ 2 := by
    apply one_div_le_one_div_of_le (by norm_num)
    nlinarith
  nlinarith [hSi, h1, h2]

/-- `exp (-(1/5)) ≥ 0.8187`. -/
theorem exp_neg_fifth_ge : (0.8187 : ℝ) ≤ Real.exp (-(1 / 5) : ℝ) := by
  have hb := Real.exp_bound (x := (-(1/5) : ℝ)) (by rw [abs_of_nonpos (by norm_num)]; norm_num)
    (n := 5) (by norm_num)
  have h := (abs_le.1 hb).1
  rw [abs_of_nonpos (by norm_num : (-(1/5):ℝ) ≤ 0)] at h
  norm_num [Finset.sum_range_succ, Nat.factorial] at h
  linarith

/-- The truncated kernel, factorized as a geometric sum. -/
theorem thetaTruncKernel_eq (v : ℝ) :
    thetaTruncKernel v
      = 2 * Real.exp (-(v / 2)) * ∑ n ∈ Finset.range 8, Real.exp (-v) ^ (2 * n) := by
  rw [thetaTruncKernel, Finset.mul_sum]
  refine Finset.sum_congr rfl fun n _ => ?_
  rw [← Real.exp_nat_mul, mul_assoc, ← Real.exp_add]
  congr 2
  push_cast
  ring

/-- The crude upper bound `2δ(e^v) ≤ 4.528 e^{v/2}` for `v ≥ 0`. -/
theorem two_delta_le_exp_half {v : ℝ} (hv : 0 ≤ v) :
    2 * delta (Rplus.expHomeo v) ≤ 4 * Real.exp (v / 2) * 1.132 := by
  have hπ : (3.14159 : ℝ) < π := by linarith [Real.pi_gt_d6]
  have hρ : (1:ℝ) ≤ Real.exp v := Real.one_le_exp hv
  have hexp : ((Rplus.expHomeo v : Rplus) : ℝ) = Real.exp v := rfl
  have hdelta := delta_explicit (ρ := Rplus.expHomeo v) (by rw [hexp]; exact hρ)
  rw [hexp] at hdelta
  set r := Real.exp v with hr
  have ha4 : 4 * π ≤ 2 * π * (1 + r) := by nlinarith [Real.pi_pos]
  have hb0 : (0:ℝ) ≤ 2 * π * (r - 1) := by nlinarith [Real.pi_pos]
  have h1 : Si (2 * π * (1 + r)) / (2 * π * (1 + r)) ≤ 0.132 := Si_div_le_of_four_pi_le ha4
  have h2 : siDiv (2 * π * (r - 1)) ≤ 1 := siDiv_le_one hb0
  have hsqrt : Real.sqrt r = Real.exp (v / 2) := by rw [hr, ← Real.exp_half]
  have hsq : (0:ℝ) < Real.exp (v / 2) := Real.exp_pos _
  rw [hdelta, hsqrt]
  nlinarith [h1, h2, hsq]

/-- Near the origin the truncated kernel already dominates `2δ(e^v)`. -/
theorem two_delta_le_thetaTruncKernel {v : ℝ} (hv0 : 0 ≤ v) (hv : v ≤ 1 / 5) :
    2 * delta (Rplus.expHomeo v) ≤ thetaTruncKernel v := by
  refine (two_delta_le_exp_half hv0).trans ?_
  rw [thetaTruncKernel_eq]
  set w := Real.exp (-v) with hw
  have hw0 : 0 < w := Real.exp_pos _
  have hwge : (0.8187 : ℝ) ≤ w := by
    rw [hw]
    exact le_trans exp_neg_fifth_ge (Real.exp_le_exp.2 (by linarith))
  have hEq : Real.exp (-(v / 2)) = Real.exp (v / 2) * w := by
    rw [hw, ← Real.exp_add]
    congr 1
    ring
  have hrw : w * ∑ n ∈ Finset.range 8, w ^ (2 * n) = ∑ n ∈ Finset.range 8, w ^ (2 * n + 1) := by
    rw [Finset.mul_sum]
    exact Finset.sum_congr rfl fun n _ => by ring
  have hmono : ∀ n ∈ Finset.range 8, (0.8187 : ℝ) ^ (2 * n + 1) ≤ w ^ (2 * n + 1) :=
    fun n _ => pow_le_pow_left₀ (by norm_num) hwge _
  have hsum := Finset.sum_le_sum hmono
  have hnum : (2.264 : ℝ) ≤ ∑ n ∈ Finset.range 8, (0.8187 : ℝ) ^ (2 * n + 1) := by
    norm_num [Finset.sum_range_succ]
  have hS : (2.264 : ℝ) ≤ w * ∑ n ∈ Finset.range 8, w ^ (2 * n) := by
    rw [hrw]; linarith
  rw [hEq]
  have hexp : (0:ℝ) < Real.exp (v / 2) := Real.exp_pos _
  nlinarith [hS, hexp]

/-! ### The smooth kernel `2u/(1-u⁴)`, `u = e^{-v/2}` -/

/-- The truncated kernel as a finite geometric sum in `u = e^{-v/2}`. -/
theorem thetaTruncKernel_eq_u {v : ℝ} (hv : 0 < v) :
    thetaTruncKernel v
      = 2 * Real.exp (-(v / 2)) * (1 - Real.exp (-(v / 2)) ^ 32)
          / (1 - Real.exp (-(v / 2)) ^ 4) := by
  set u := Real.exp (-(v / 2)) with hu
  have hu0 : (0:ℝ) < u := Real.exp_pos _
  have hu1 : u < 1 := by rw [hu]; exact Real.exp_lt_one_iff.2 (by linarith)
  have hu4lt : u ^ 4 < 1 := pow_lt_one₀ hu0.le hu1 (by norm_num)
  have hne : u ^ 4 ≠ 1 := by linarith
  have hterm : ∀ n : ℕ, 2 * Real.exp (-((2 * (n : ℝ) + 1 / 2) * v)) = 2 * u * (u ^ 4) ^ n := by
    intro n
    rw [hu, ← Real.exp_nat_mul, ← Real.exp_nat_mul, mul_assoc, ← Real.exp_add]
    congr 1
    push_cast
    ring_nf
  have hsum : thetaTruncKernel v = 2 * u * ∑ n ∈ Finset.range 8, (u ^ 4) ^ n := by
    rw [thetaTruncKernel, Finset.mul_sum]
    exact Finset.sum_congr rfl fun n _ => by rw [hterm n]
  rw [hsum, geom_sum_eq hne 8]
  have h32 : (u ^ 4) ^ 8 = u ^ 32 := by ring
  rw [h32]
  have hratio : (u ^ 32 - 1) / (u ^ 4 - 1) = (1 - u ^ 32) / (1 - u ^ 4) := by
    rw [← neg_div_neg_eq]
    congr 1 <;> ring
  rw [hratio]
  ring

/-- The excess of the smooth kernel over its truncation, weighted by `v²`. -/
theorem smooth_sub_thetaTruncKernel_le {v : ℝ} (hv : 0 < v) :
    (2 * Real.exp (-(v / 2)) / (1 - Real.exp (-(v / 2)) ^ 4) - thetaTruncKernel v) * v ^ 2
      ≤ Real.exp (-(v / 2)) ^ 33 * (2 * v ^ 2 + v) := by
  set u := Real.exp (-(v / 2)) with hu
  have hu0 : (0:ℝ) < u := Real.exp_pos _
  have hu1 : u < 1 := by rw [hu]; exact Real.exp_lt_one_iff.2 (by linarith)
  have hu4 : u ^ 4 < 1 := pow_lt_one₀ hu0.le hu1 (by norm_num)
  have hden : (0:ℝ) < 1 - u ^ 4 := by linarith
  have hu4eq : u ^ 4 = 1 / Real.exp (2 * v) := by
    rw [hu, ← Real.exp_nat_mul, one_div, ← Real.exp_neg]
    congr 1
    push_cast
    ring
  -- `1 - e^{-2v} ≥ 2v/(1+2v)`
  have hexp : 1 + 2 * v ≤ Real.exp (2 * v) := by
    have := Real.add_one_le_exp (2 * v)
    linarith
  have hlow : 2 * v / (1 + 2 * v) ≤ 1 - u ^ 4 := by
    have hinv : 1 / Real.exp (2 * v) ≤ 1 / (1 + 2 * v) :=
      one_div_le_one_div_of_le (by linarith) hexp
    have h2 : 1 - 1 / (1 + 2 * v) = 2 * v / (1 + 2 * v) := by
      field_simp
      ring
    rw [hu4eq]
    linarith
  rw [thetaTruncKernel_eq_u hv]
  have hdiff : 2 * u / (1 - u ^ 4) - 2 * u * (1 - u ^ 32) / (1 - u ^ 4)
      = 2 * u ^ 33 / (1 - u ^ 4) := by
    field_simp
    ring
  rw [hdiff]
  have hbound : 2 * v ^ 2 / (1 - u ^ 4) ≤ 2 * v ^ 2 + v := by
    rw [div_le_iff₀ hden]
    have hid : (2 * v ^ 2 + v) * (2 * v / (1 + 2 * v)) = 2 * v ^ 2 := by
      field_simp
      ring
    have hmul := mul_le_mul_of_nonneg_left hlow (by positivity : (0:ℝ) ≤ 2 * v ^ 2 + v)
    rw [hid] at hmul
    linarith
  have hupos : (0:ℝ) < u ^ 33 := by positivity
  calc 2 * u ^ 33 / (1 - u ^ 4) * v ^ 2 = u ^ 33 * (2 * v ^ 2 / (1 - u ^ 4)) := by
        field_simp
    _ ≤ u ^ 33 * (2 * v ^ 2 + v) := by
        exact mul_le_mul_of_nonneg_left hbound hupos.le

set_option maxHeartbeats 1000000 in
/-- The excess of `2δ(e^v)` over the smooth kernel, weighted by `v²`. -/
theorem two_delta_sub_smooth_le {v : ℝ} (hv : 1 / 5 ≤ v) :
    (2 * delta (Rplus.expHomeo v) - 2 * Real.exp (-(v / 2)) / (1 - Real.exp (-(v / 2)) ^ 4))
        * v ^ 2
      ≤ Real.exp (-(v / 2)) ^ 3 * (2 * v ^ 2 + 2 * v + 1) / π ^ 2
        + Real.exp (-(v / 2)) ^ 5 * (5 * v ^ 3 + 16 * v ^ 2 + 15 * v + 5) / (2 * π ^ 3) := by
  have hv0 : (0:ℝ) < v := by linarith
  have hπ0 : (0:ℝ) < π := Real.pi_pos
  set u := Real.exp (-(v / 2)) with hu
  have hu0 : (0:ℝ) < u := Real.exp_pos _
  have hu1 : u < 1 := by rw [hu]; exact Real.exp_lt_one_iff.2 (by linarith)
  have hu4 : u ^ 4 < 1 := pow_lt_one₀ hu0.le hu1 (by norm_num)
  have hden : (0:ℝ) < 1 - u ^ 4 := by linarith
  have husq : u ^ 2 = Real.exp (-v) := by
    rw [hu, ← Real.exp_nat_mul]; congr 1; push_cast; ring
  have hu2pos : (0:ℝ) < u ^ 2 := by positivity
  have hRu : Real.exp v = 1 / u ^ 2 := by
    rw [husq, Real.exp_neg]
    field_simp
  have hu2lt : u ^ 2 < 1 := pow_lt_one₀ hu0.le hu1 (by norm_num)
  have hR1 : (1:ℝ) < Real.exp v := by
    rw [hRu, lt_div_iff₀ hu2pos]
    linarith
  have hsqrtu : Real.sqrt (Real.exp v) = 1 / u := by
    have h : Real.sqrt (Real.exp v) = Real.exp (v / 2) := (Real.exp_half v).symm
    rw [h, hu, Real.exp_neg]
    field_simp
  have hbne : 2 * π * (Real.exp v - 1) ≠ 0 := by
    have : (0:ℝ) < 2 * π * (Real.exp v - 1) := by nlinarith
    linarith
  have hcoe : ((Rplus.expHomeo v : Rplus) : ℝ) = Real.exp v := rfl
  have hdelta := delta_explicit (ρ := Rplus.expHomeo v) (by rw [hcoe]; linarith)
  rw [hcoe, hsqrtu, siDiv_of_ne_zero hbne] at hdelta
  set a := 2 * π * (1 + Real.exp v) with ha
  set b := 2 * π * (Real.exp v - 1) with hb
  have hapos : (0:ℝ) < a := by rw [ha]; nlinarith
  have hbpos : (0:ℝ) < b := by rw [hb]; nlinarith
  -- the two Si-quotients
  have hSa : Si a / a ≤ π / 2 / a + 1 / a ^ 2 + 1 / a ^ 3 := by
    have h := Si_le_of_pos hapos
    rw [div_le_iff₀ hapos]
    have h2 : (π / 2 / a + 1 / a ^ 2 + 1 / a ^ 3) * a = π / 2 + 1 / a + 1 / a ^ 2 := by
      field_simp
    rw [h2]
    exact h
  have hSb : Si b / b ≤ π / 2 / b + 1 / b ^ 2 + 1 / b ^ 3 := by
    have h := Si_le_of_pos hbpos
    rw [div_le_iff₀ hbpos]
    have h2 : (π / 2 / b + 1 / b ^ 2 + 1 / b ^ 3) * b = π / 2 + 1 / b + 1 / b ^ 2 := by
      field_simp
    rw [h2]
    exact h
  -- the main-term identity
  have hmain : 2 * (1 / u) * (π / 2 / a + π / 2 / b) * 2 = 2 * u / (1 - u ^ 4) := by
    rw [ha, hb, hRu]
    have h1 : (0:ℝ) < 1 - u ^ 2 := by linarith
    have h2 : (0:ℝ) < 1 + u ^ 2 := by positivity
    field_simp
    ring
  -- lower bounds for `a` and `b`
  have ha_lb : 2 * π / u ^ 2 ≤ a := by
    rw [ha, hRu, div_le_iff₀ hu2pos]
    have : (1 + 1 / u ^ 2) * u ^ 2 = u ^ 2 + 1 := by field_simp
    nlinarith [this]
  have hb_lb : 2 * π * v / ((1 + v) * u ^ 2) ≤ b := by
    have hexp1 : 1 + v ≤ Real.exp v := by linarith [Real.add_one_le_exp v]
    have hstep : v / ((1 + v) * u ^ 2) ≤ Real.exp v - 1 := by
      rw [div_le_iff₀ (by positivity)]
      rw [hRu] at hexp1 ⊢
      have h1 : (1 + v) * u ^ 2 ≤ 1 := by
        rw [le_div_iff₀ hu2pos] at hexp1
        linarith
      have h2 : (1 / u ^ 2 - 1) * ((1 + v) * u ^ 2) = (1 + v) - (1 + v) * u ^ 2 := by
        field_simp
      rw [h2]
      linarith
    have hfac : 2 * π * v / ((1 + v) * u ^ 2) = 2 * π * (v / ((1 + v) * u ^ 2)) := by
      field_simp
    rw [hb, hfac]
    exact mul_le_mul_of_nonneg_left hstep (by linarith : (0:ℝ) ≤ 2 * π)
  -- the four error terms
  have hinv_a2 : 1 / a ^ 2 ≤ u ^ 4 / (4 * π ^ 2) := by
    have h1 : (2 * π / u ^ 2) ^ 2 ≤ a ^ 2 := pow_le_pow_left₀ (by positivity) ha_lb 2
    have h3 : 1 / a ^ 2 ≤ 1 / (2 * π / u ^ 2) ^ 2 :=
      one_div_le_one_div_of_le (by positivity) h1
    have h2 : 1 / (2 * π / u ^ 2) ^ 2 = u ^ 4 / (4 * π ^ 2) := by
      rw [div_pow]
      field_simp
      ring
    rwa [h2] at h3
  have hinv_a3 : 1 / a ^ 3 ≤ u ^ 6 / (8 * π ^ 3) := by
    have h1 : (2 * π / u ^ 2) ^ 3 ≤ a ^ 3 := pow_le_pow_left₀ (by positivity) ha_lb 3
    have h3 : 1 / a ^ 3 ≤ 1 / (2 * π / u ^ 2) ^ 3 :=
      one_div_le_one_div_of_le (by positivity) h1
    have h2 : 1 / (2 * π / u ^ 2) ^ 3 = u ^ 6 / (8 * π ^ 3) := by
      rw [div_pow]
      field_simp
      ring
    rwa [h2] at h3
  have hinv_b2 : 1 / b ^ 2 ≤ (1 + v) ^ 2 * u ^ 4 / (4 * π ^ 2 * v ^ 2) := by
    have h1 : (2 * π * v / ((1 + v) * u ^ 2)) ^ 2 ≤ b ^ 2 :=
      pow_le_pow_left₀ (by positivity) hb_lb 2
    have h3 : 1 / b ^ 2 ≤ 1 / (2 * π * v / ((1 + v) * u ^ 2)) ^ 2 :=
      one_div_le_one_div_of_le (by positivity) h1
    have h2 : 1 / (2 * π * v / ((1 + v) * u ^ 2)) ^ 2
        = (1 + v) ^ 2 * u ^ 4 / (4 * π ^ 2 * v ^ 2) := by
      rw [div_pow, mul_pow, mul_pow, mul_pow]
      field_simp
      ring
    rwa [h2] at h3
  have hinv_b3 : 1 / b ^ 3 ≤ (1 + v) ^ 3 * u ^ 6 / (8 * π ^ 3 * v ^ 3) := by
    have h1 : (2 * π * v / ((1 + v) * u ^ 2)) ^ 3 ≤ b ^ 3 :=
      pow_le_pow_left₀ (by positivity) hb_lb 3
    have h3 : 1 / b ^ 3 ≤ 1 / (2 * π * v / ((1 + v) * u ^ 2)) ^ 3 :=
      one_div_le_one_div_of_le (by positivity) h1
    have h2 : 1 / (2 * π * v / ((1 + v) * u ^ 2)) ^ 3
        = (1 + v) ^ 3 * u ^ 6 / (8 * π ^ 3 * v ^ 3) := by
      rw [div_pow, mul_pow, mul_pow, mul_pow]
      field_simp
      ring
    rwa [h2] at h3
  -- the four weighted error terms
  have hcpos : (0:ℝ) < 4 * (1 / u) * v ^ 2 := by positivity
  have t1 : 4 * (1 / u) * (1 / a ^ 2) * v ^ 2 ≤ u ^ 3 * v ^ 2 / π ^ 2 := by
    calc 4 * (1 / u) * (1 / a ^ 2) * v ^ 2 = (4 * (1 / u) * v ^ 2) * (1 / a ^ 2) := by ring
      _ ≤ (4 * (1 / u) * v ^ 2) * (u ^ 4 / (4 * π ^ 2)) :=
          mul_le_mul_of_nonneg_left hinv_a2 hcpos.le
      _ = u ^ 3 * v ^ 2 / π ^ 2 := by field_simp
  have t2 : 4 * (1 / u) * (1 / a ^ 3) * v ^ 2 ≤ u ^ 5 * v ^ 2 / (2 * π ^ 3) := by
    calc 4 * (1 / u) * (1 / a ^ 3) * v ^ 2 = (4 * (1 / u) * v ^ 2) * (1 / a ^ 3) := by ring
      _ ≤ (4 * (1 / u) * v ^ 2) * (u ^ 6 / (8 * π ^ 3)) :=
          mul_le_mul_of_nonneg_left hinv_a3 hcpos.le
      _ = u ^ 5 * v ^ 2 / (2 * π ^ 3) := by field_simp; ring
  have t3 : 4 * (1 / u) * (1 / b ^ 2) * v ^ 2 ≤ u ^ 3 * (1 + v) ^ 2 / π ^ 2 := by
    calc 4 * (1 / u) * (1 / b ^ 2) * v ^ 2 = (4 * (1 / u) * v ^ 2) * (1 / b ^ 2) := by ring
      _ ≤ (4 * (1 / u) * v ^ 2) * ((1 + v) ^ 2 * u ^ 4 / (4 * π ^ 2 * v ^ 2)) :=
          mul_le_mul_of_nonneg_left hinv_b2 hcpos.le
      _ = u ^ 3 * (1 + v) ^ 2 / π ^ 2 := by field_simp
  have t4 : 4 * (1 / u) * (1 / b ^ 3) * v ^ 2 ≤ 5 * (u ^ 5 * (1 + v) ^ 3 / (2 * π ^ 3)) := by
    have hv5 : 1 / v ≤ 5 := by
      rw [div_le_iff₀ hv0]
      linarith
    calc 4 * (1 / u) * (1 / b ^ 3) * v ^ 2 = (4 * (1 / u) * v ^ 2) * (1 / b ^ 3) := by ring
      _ ≤ (4 * (1 / u) * v ^ 2) * ((1 + v) ^ 3 * u ^ 6 / (8 * π ^ 3 * v ^ 3)) :=
          mul_le_mul_of_nonneg_left hinv_b3 hcpos.le
      _ = (1 / v) * (u ^ 5 * (1 + v) ^ 3 / (2 * π ^ 3)) := by field_simp; ring
      _ ≤ 5 * (u ^ 5 * (1 + v) ^ 3 / (2 * π ^ 3)) := by
          have hpos : (0:ℝ) ≤ u ^ 5 * (1 + v) ^ 3 / (2 * π ^ 3) := by positivity
          exact mul_le_mul_of_nonneg_right hv5 hpos
  -- put everything together
  have hexpand : 2 * delta (Rplus.expHomeo v)
      ≤ 2 * u / (1 - u ^ 4)
        + (4 * (1 / u) * (1 / a ^ 2) + 4 * (1 / u) * (1 / a ^ 3) + 4 * (1 / u) * (1 / b ^ 2)
            + 4 * (1 / u) * (1 / b ^ 3)) := by
    rw [hdelta, ← hmain]
    have hupos : (0:ℝ) < 1 / u := by positivity
    nlinarith [hSa, hSb, hupos]
  have hfinal : (2 * delta (Rplus.expHomeo v) - 2 * u / (1 - u ^ 4)) * v ^ 2
      ≤ (4 * (1 / u) * (1 / a ^ 2) + 4 * (1 / u) * (1 / a ^ 3) + 4 * (1 / u) * (1 / b ^ 2)
          + 4 * (1 / u) * (1 / b ^ 3)) * v ^ 2 := by
    have hv2 : (0:ℝ) ≤ v ^ 2 := sq_nonneg v
    nlinarith [hexpand, hv2]
  refine hfinal.trans ?_
  have hsum : (4 * (1 / u) * (1 / a ^ 2) + 4 * (1 / u) * (1 / a ^ 3) + 4 * (1 / u) * (1 / b ^ 2)
      + 4 * (1 / u) * (1 / b ^ 3)) * v ^ 2
      = 4 * (1 / u) * (1 / a ^ 2) * v ^ 2 + 4 * (1 / u) * (1 / a ^ 3) * v ^ 2
        + 4 * (1 / u) * (1 / b ^ 2) * v ^ 2 + 4 * (1 / u) * (1 / b ^ 3) * v ^ 2 := by ring
  rw [hsum]
  have hcomb : u ^ 3 * v ^ 2 / π ^ 2 + u ^ 5 * v ^ 2 / (2 * π ^ 3)
      + u ^ 3 * (1 + v) ^ 2 / π ^ 2 + 5 * (u ^ 5 * (1 + v) ^ 3 / (2 * π ^ 3))
      = u ^ 3 * (2 * v ^ 2 + 2 * v + 1) / π ^ 2
        + u ^ 5 * (5 * v ^ 3 + 16 * v ^ 2 + 15 * v + 5) / (2 * π ^ 3) := by
    field_simp
    ring
  linarith [t1, t2, t3, t4, hcomb]

/-- Away from the origin the excess of `2δ(e^v)` over the truncated kernel is controlled by
the majorant, after multiplication by `v²`. -/
theorem two_delta_sub_le_nearMajorant {v : ℝ} (hv : 1 / 5 ≤ v) :
    (2 * delta (Rplus.expHomeo v) - thetaTruncKernel v) * v ^ 2 ≤ nearMajorant v := by
  have hv0 : (0:ℝ) < v := by linarith
  have h1 := two_delta_sub_smooth_le hv
  have h2 := smooth_sub_thetaTruncKernel_le hv0
  have hpow : ∀ n : ℕ, Real.exp (-(v / 2)) ^ n = Real.exp (-((n : ℝ) * v / 2)) := by
    intro n
    rw [← Real.exp_nat_mul]
    congr 1
    ring
  have hsum : (2 * delta (Rplus.expHomeo v) - thetaTruncKernel v) * v ^ 2
      = (2 * delta (Rplus.expHomeo v)
            - 2 * Real.exp (-(v / 2)) / (1 - Real.exp (-(v / 2)) ^ 4)) * v ^ 2
        + (2 * Real.exp (-(v / 2)) / (1 - Real.exp (-(v / 2)) ^ 4)
            - thetaTruncKernel v) * v ^ 2 := by ring
  have g3 : Real.exp (-(3 * v / 2)) = Real.exp (-(v / 2)) ^ 3 := by
    rw [hpow 3]; norm_num
  have g5 : Real.exp (-(5 * v / 2)) = Real.exp (-(v / 2)) ^ 5 := by
    rw [hpow 5]; norm_num
  have g33 : Real.exp (-(33 * v / 2)) = Real.exp (-(v / 2)) ^ 33 := by
    rw [hpow 33]; norm_num
  rw [hsum, nearMajorant, g3, g5, g33]
  linarith

/-- The pointwise bound that is integrated to compare `Δ` with `Θ`. -/
theorem pointwise_delta_bound (t : ℝ) {v : ℝ} (hv : 0 < v) :
    2 * delta (Rplus.expHomeo v) * (1 - Real.cos (t * v))
      ≤ thetaTruncKernel v * (1 - Real.cos (t * v)) + t ^ 2 / 2 * nearMajorantInd v := by
  have hcos : 0 ≤ 1 - Real.cos (t * v) := by linarith [Real.cos_le_one (t * v)]
  rcases le_or_gt v (1 / 5) with hsmall | hbig
  · have hk := two_delta_le_thetaTruncKernel hv.le hsmall
    have hmaj : 0 ≤ t ^ 2 / 2 * nearMajorantInd v :=
      mul_nonneg (by positivity) (nearMajorantInd_nonneg v)
    nlinarith [mul_le_mul_of_nonneg_right hk hcos]
  · have hmaj : nearMajorantInd v = nearMajorant v := by
      rw [nearMajorantInd, if_pos hbig.le]
    -- `1 - cos(tv) ≤ t²v²/2`
    have hcos2 : 1 - Real.cos (t * v) ≤ (t * v) ^ 2 / 2 := by
      have := Real.one_sub_sq_div_two_le_cos (x := t * v)
      linarith
    rcases le_or_gt (2 * delta (Rplus.expHomeo v)) (thetaTruncKernel v) with hle | hlt
    · have hmaj0 : 0 ≤ t ^ 2 / 2 * nearMajorantInd v :=
        mul_nonneg (by positivity) (nearMajorantInd_nonneg v)
      nlinarith [mul_le_mul_of_nonneg_right hle hcos]
    · have hdiff : 0 < 2 * delta (Rplus.expHomeo v) - thetaTruncKernel v := by linarith
      have hkey := two_delta_sub_le_nearMajorant hbig.le
      have hstep : (2 * delta (Rplus.expHomeo v) - thetaTruncKernel v) *
          (1 - Real.cos (t * v))
          ≤ (2 * delta (Rplus.expHomeo v) - thetaTruncKernel v) * ((t * v) ^ 2 / 2) :=
        mul_le_mul_of_nonneg_left hcos2 hdiff.le
      have hstep2 : (2 * delta (Rplus.expHomeo v) - thetaTruncKernel v) * ((t * v) ^ 2 / 2)
          ≤ t ^ 2 / 2 * nearMajorant v := by
        have := mul_le_mul_of_nonneg_left hkey (by positivity : (0:ℝ) ≤ t ^ 2 / 2)
        nlinarith [this]
      rw [hmaj]
      nlinarith [hstep, hstep2]

/-! ## 5. The spread bound -/

/-- `Δ(t) = ∫₀^∞ 2 δ(e^v)(1 - cos tv) dv`, by the evenness of `v ↦ δ(e^v)`. -/
theorem deltaSpread_eq_two_mul_integral_Ioi (t : ℝ) :
    deltaSpread t
      = ∫ v in Ioi (0:ℝ), 2 * delta (Rplus.expHomeo v) * (1 - Real.cos (t * v)) := by
  have heven : ∀ u : ℝ, delta (Rplus.expHomeo u) * (1 - Real.cos (t * u))
      = (fun x : ℝ => delta (Rplus.expHomeo x) * (1 - Real.cos (t * x))) |u| := by
    intro u
    rcases abs_cases u with ⟨h, _⟩ | ⟨h, _⟩
    · rw [h]
    · simp only [h]
      rw [delta_expHomeo_neg, show t * -u = -(t * u) by ring, Real.cos_neg]
  have hconst : ∫ v in Ioi (0:ℝ), 2 * delta (Rplus.expHomeo v) * (1 - Real.cos (t * v))
      = 2 * ∫ v in Ioi (0:ℝ), delta (Rplus.expHomeo v) * (1 - Real.cos (t * v)) := by
    rw [← MeasureTheory.integral_const_mul]
    refine integral_congr_ae (Filter.Eventually.of_forall fun v => ?_)
    ring
  rw [deltaSpread, hconst, integral_congr_ae (Filter.Eventually.of_forall heven)]
  exact integral_comp_abs (f := fun x : ℝ => delta (Rplus.expHomeo x) * (1 - Real.cos (t * x)))

theorem integrableOn_thetaTruncKernel_mul (t : ℝ) :
    IntegrableOn (fun v => thetaTruncKernel v * (1 - Real.cos (t * v))) (Ioi 0) := by
  have hexp : (fun v : ℝ => thetaTruncKernel v * (1 - Real.cos (t * v)))
      = fun v : ℝ => ∑ n ∈ Finset.range 8,
          2 * (Real.exp (-((2 * (n : ℝ) + 1 / 2) * v)) * (1 - Real.cos (t * v))) := by
    funext v
    rw [thetaTruncKernel, Finset.sum_mul]
    exact Finset.sum_congr rfl fun n _ => by ring
  rw [IntegrableOn, hexp]
  refine MeasureTheory.integrable_finset_sum _ fun n _ => ?_
  have hn : (0:ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
  have hc : (0:ℝ) < 2 * (n : ℝ) + 1 / 2 := by linarith
  exact (integrableOn_exp_one_sub_cos hc t).const_mul 2

theorem integrableOn_two_delta_mul (t : ℝ) :
    IntegrableOn (fun v => 2 * delta (Rplus.expHomeo v) * (1 - Real.cos (t * v))) (Ioi 0) := by
  have hcos : Integrable (fun u : ℝ => delta (Rplus.expHomeo u) * Real.cos (t * u)) volume :=
    integrable_delta_log_mul (by fun_prop) fun u => Real.abs_cos_le_one _
  have h : Integrable
      (fun u : ℝ => 2 * delta (Rplus.expHomeo u) * (1 - Real.cos (t * u))) volume := by
    have hsub := (integrable_delta_log.sub hcos).const_mul 2
    refine hsub.congr (Filter.Eventually.of_forall fun u => ?_)
    simp only [Pi.sub_apply]
    ring
  exact h.integrableOn

/-- **The quantitative spread comparison**: `Δ(t) ≤ Θ(t) + t²/5`. -/
theorem deltaSpread_le_thetaSpread_add (t : ℝ) :
    deltaSpread t ≤ (2 * thetaDeriv t - 2 * thetaDeriv 0) + t ^ 2 / 5 := by
  have hIntMaj : IntegrableOn (fun v => t ^ 2 / 2 * nearMajorantInd v) (Ioi 0) :=
    integrableOn_nearMajorantInd.const_mul _
  have hIntRHS : IntegrableOn
      (fun v => thetaTruncKernel v * (1 - Real.cos (t * v)) + t ^ 2 / 2 * nearMajorantInd v)
      (Ioi 0) := (integrableOn_thetaTruncKernel_mul t).add hIntMaj
  have hmono : ∫ v in Ioi (0:ℝ), 2 * delta (Rplus.expHomeo v) * (1 - Real.cos (t * v))
      ≤ ∫ v in Ioi (0:ℝ),
          (thetaTruncKernel v * (1 - Real.cos (t * v)) + t ^ 2 / 2 * nearMajorantInd v) := by
    refine MeasureTheory.setIntegral_mono_on (integrableOn_two_delta_mul t) hIntRHS
      measurableSet_Ioi fun v hv => ?_
    exact pointwise_delta_bound t hv
  have hsplit : ∫ v in Ioi (0:ℝ),
      (thetaTruncKernel v * (1 - Real.cos (t * v)) + t ^ 2 / 2 * nearMajorantInd v)
      = (∑ n ∈ Finset.range 8, thetaSeriesTerm t n)
        + t ^ 2 / 2 * ∫ v in Ioi (0:ℝ), nearMajorantInd v := by
    rw [MeasureTheory.integral_add (integrableOn_thetaTruncKernel_mul t) hIntMaj,
      integral_thetaTruncKernel, MeasureTheory.integral_const_mul]
  have hpartial : (∑ n ∈ Finset.range 8, thetaSeriesTerm t n)
      ≤ 2 * thetaDeriv t - 2 * thetaDeriv 0 :=
    sum_le_hasSum _ (fun n _ => thetaSeriesTerm_nonneg t n) (hasSum_thetaDeriv_sub t)
  have hmass : t ^ 2 / 2 * ∫ v in Ioi (0:ℝ), nearMajorantInd v ≤ t ^ 2 / 5 := by
    have h := mul_le_mul_of_nonneg_left integral_nearMajorantInd_le
      (by positivity : (0:ℝ) ≤ t ^ 2 / 2)
    linarith
  rw [deltaSpread_eq_two_mul_integral_Ioi t]
  rw [hsplit] at hmono
  linarith

/-! ## 6. The Fourier-side inequality near the origin -/

/-- **The Fourier-side inequality near the origin**, in the form that the spread comparison
gives: `f(t) ≥ 0` as soon as `t² ≤ 5 f(0)`.  Any improvement of the lower bound for
`f(0) = δ̂(0) - (log π + γ + 3 log 2 + π/2)` widens the interval accordingly. -/
theorem fourierSide_nonneg_of_sq_le {t : ℝ} (ht : t ^ 2 ≤ 5 * fourierSide 0) :
    0 ≤ fourierSide t := by
  have hsp := deltaSpread_le_thetaSpread_add t
  rw [fourierSide_nonneg_iff]
  linarith

/-- **The Fourier-side inequality on a neighbourhood of the origin**: `f(t) ≥ 0` for
`|t| ≤ 0.18`.  (With the bound `f(0) ≥ 0.0072` of `RequestProject/GammaBound.lean`; the true
value `f(0) = 0.04907…` would give `|t| ≤ 0.49`.) -/
theorem fourierSide_nonneg_of_abs_le {t : ℝ} (ht : |t| ≤ 0.18) : 0 ≤ fourierSide t := by
  have hsq : t ^ 2 ≤ 0.0324 := by
    have h := abs_le.1 ht
    nlinarith [h.1, h.2]
  have hzero := fourierSide_zero_ge
  exact fourierSide_nonneg_of_sq_le (by linarith)

end ConnesConsani.WeilPositivity
