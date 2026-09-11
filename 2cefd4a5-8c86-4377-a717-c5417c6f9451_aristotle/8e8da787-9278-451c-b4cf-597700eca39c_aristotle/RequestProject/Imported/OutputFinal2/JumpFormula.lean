/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Integration by parts against a function with a corner, and the resulting `-2‖ξ‖²`
term of the essential negativity statements of §4 and §6 of

  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771.

The trace remainder `δ` is smooth away from `ρ = 1`, continuous everywhere, and its
derivative jumps by `2` at `ρ = 1` (see `RequestProject/TraceRemainder.lean`).  Pairing
the operator `Q = -(ρ∂ρ)² + 1/4` with such a function therefore produces, besides the
smooth pairing with `Qδ`, a boundary term `-(jump) f(1)`; for `f = ξ ∗ ξ*` one has
`f(1) = ‖ξ‖²`, which is the mechanism behind the essential negativity of `D ∘ Q`.
-/
import RequestProject.Imported.OutputFinal2.Mellin

noncomputable section

open MeasureTheory Set Real Complex intervalIntegral

namespace ConnesConsani.WeilPositivity

/-- The function equal to `a` on `[0,∞)` and to `b` on `(-∞,0)`. -/
def corner (a b : ℝ → ℂ) : ℝ → ℂ := fun t => if 0 ≤ t then a t else b t

@[simp] theorem corner_of_nonneg {a b : ℝ → ℂ} {t : ℝ} (ht : 0 ≤ t) : corner a b t = a t := by
  simp [corner, ht]

@[simp] theorem corner_of_neg {a b : ℝ → ℂ} {t : ℝ} (ht : t < 0) : corner a b t = b t := by
  simp [corner, not_le.2 ht]

theorem continuous_corner {a b : ℝ → ℂ} (ha : Continuous a) (hb : Continuous b)
    (h0 : a 0 = b 0) : Continuous (corner a b) := by
  refine Continuous.if_le ha hb continuous_const continuous_id ?_
  rintro x rfl
  exact h0

/-- Almost every real number is nonzero. -/
theorem ae_ne_zero : ∀ᵐ x : ℝ, x ≠ 0 := by
  rw [MeasureTheory.ae_iff]
  simp

section

variable {f a b : ℝ → ℂ}

/-- If `f` has compact support, then `f`, `f'` and `f''` all vanish outside a large ball. -/
private theorem vanish_outside (hsupp : HasCompactSupport f) :
    ∃ R : ℝ, 0 < R ∧ ∀ x : ℝ, R < |x| →
      f x = 0 ∧ deriv f x = 0 ∧ deriv (deriv f) x = 0 := by
  obtain ⟨R, hR, hRz⟩ := hsupp.exists_pos_le_norm
  have hopen : IsOpen {y : ℝ | R < |y|} := isOpen_lt continuous_const continuous_abs
  have h1 : ∀ y : ℝ, R < |y| → f y = 0 := fun y hy => hRz y (by simpa using hy.le)
  have h2 : ∀ y : ℝ, R < |y| → deriv f y = 0 := by
    intro y hy
    have hev : f =ᶠ[nhds y] fun _ => 0 :=
      Filter.eventuallyEq_of_mem (hopen.mem_nhds hy) fun z hz => h1 z hz
    rw [hev.deriv_eq, deriv_const]
  have h3 : ∀ y : ℝ, R < |y| → deriv (deriv f) y = 0 := by
    intro y hy
    have hev : deriv f =ᶠ[nhds y] fun _ => 0 :=
      Filter.eventuallyEq_of_mem (hopen.mem_nhds hy) fun z hz => h2 z hz
    rw [hev.deriv_eq, deriv_const]
  exact ⟨R, hR, fun x hx => ⟨h1 x hx, h2 x hx, h3 x hx⟩⟩

/-- **Integration by parts against a function with a corner.**  If `f` is `C²` with
compact support and the function `g` equals the `C²` function `a` on `[0,∞)` and the
`C²` function `b` on `(-∞,0]`, then

`∫ f'' g = f(0) (a'(0) - b'(0)) + ∫ f g''`,

the extra term being produced by the jump `a'(0) - b'(0)` of the derivative of `g`. -/
theorem integral_deriv2_mul_corner
    (hf : ContDiff ℝ 2 f) (hsupp : HasCompactSupport f)
    (ha : ContDiff ℝ 2 a) (hb : ContDiff ℝ 2 b) (h0 : a 0 = b 0) :
    ∫ t : ℝ, deriv (deriv f) t * corner a b t
      = f 0 * (deriv a 0 - deriv b 0)
        + ∫ t : ℝ, f t * corner (deriv (deriv a)) (deriv (deriv b)) t := by
  obtain ⟨R, hR, hz⟩ := vanish_outside hsupp
  set S : ℝ := R + 1 with hSdef
  have hS : 0 < S := by positivity
  have hSR : R < |S| := by rw [abs_of_pos hS]; linarith
  have hSR' : R < |(-S)| := by rw [abs_neg, abs_of_pos hS]; linarith
  obtain ⟨hfS, hf'S, -⟩ := hz S hSR
  obtain ⟨hfS', hf'S', -⟩ := hz (-S) hSR'
  -- regularity of `f`, `a`, `b`
  have hfd : ∀ x : ℝ, HasDerivAt f (deriv f x) x := fun x =>
    (hf.differentiable (by norm_num) x).hasDerivAt
  have hf1 : ContDiff ℝ 1 (deriv f) := hf.deriv'
  have hfdd : ∀ x : ℝ, HasDerivAt (deriv f) (deriv (deriv f) x) x := fun x =>
    (hf1.differentiable (by norm_num) x).hasDerivAt
  have had : ∀ x : ℝ, HasDerivAt a (deriv a x) x := fun x =>
    (ha.differentiable (by norm_num) x).hasDerivAt
  have ha1 : ContDiff ℝ 1 (deriv a) := ha.deriv'
  have hadd : ∀ x : ℝ, HasDerivAt (deriv a) (deriv (deriv a) x) x := fun x =>
    (ha1.differentiable (by norm_num) x).hasDerivAt
  have hbd : ∀ x : ℝ, HasDerivAt b (deriv b x) x := fun x =>
    (hb.differentiable (by norm_num) x).hasDerivAt
  have hb1 : ContDiff ℝ 1 (deriv b) := hb.deriv'
  have hbdd : ∀ x : ℝ, HasDerivAt (deriv b) (deriv (deriv b) x) x := fun x =>
    (hb1.differentiable (by norm_num) x).hasDerivAt
  have hfc : Continuous f := hf.continuous
  have hfc' : Continuous (deriv f) := hf1.continuous
  have hfc'' : Continuous (deriv (deriv f)) := hf1.continuous_deriv le_rfl
  have hac : Continuous a := ha.continuous
  have hac' : Continuous (deriv a) := ha1.continuous
  have hac'' : Continuous (deriv (deriv a)) := ha1.continuous_deriv le_rfl
  have hbc : Continuous b := hb.continuous
  have hbc' : Continuous (deriv b) := hb1.continuous
  have hbc'' : Continuous (deriv (deriv b)) := hb1.continuous_deriv le_rfl
  -- the two integration-by-parts identities on `[0,S]`
  have IA : (∫ x in (0:ℝ)..S, (deriv (deriv f) x * a x - f x * deriv (deriv a) x))
      = f 0 * deriv a 0 - deriv f 0 * a 0 := by
    have hE1 := intervalIntegral.integral_deriv_mul_eq_sub (a := (0:ℝ)) (b := S)
      (u := deriv f) (u' := deriv (deriv f)) (v := a) (v' := deriv a)
      (fun x _ => hfdd x) (fun x _ => had x)
      (hfc''.intervalIntegrable _ _) (hac'.intervalIntegrable _ _)
    have hE2 := intervalIntegral.integral_deriv_mul_eq_sub (a := (0:ℝ)) (b := S)
      (u := f) (u' := deriv f) (v := deriv a) (v' := deriv (deriv a))
      (fun x _ => hfd x) (fun x _ => hadd x)
      (hfc'.intervalIntegrable _ _) (hac''.intervalIntegrable _ _)
    have hsub : (∫ x in (0:ℝ)..S, (deriv (deriv f) x * a x + deriv f x * deriv a x))
        - (∫ x in (0:ℝ)..S, (deriv f x * deriv a x + f x * deriv (deriv a) x))
        = ∫ x in (0:ℝ)..S, (deriv (deriv f) x * a x - f x * deriv (deriv a) x) := by
      have ii1 : IntervalIntegrable
          (fun x => deriv (deriv f) x * a x + deriv f x * deriv a x) volume 0 S :=
        ((hfc''.mul hac).add (hfc'.mul hac')).intervalIntegrable _ _
      have ii2 : IntervalIntegrable
          (fun x => deriv f x * deriv a x + f x * deriv (deriv a) x) volume 0 S :=
        ((hfc'.mul hac').add (hfc.mul hac'')).intervalIntegrable _ _
      rw [← intervalIntegral.integral_sub ii1 ii2]
      exact intervalIntegral.integral_congr fun x _ => by ring
    rw [← hsub, hE1, hE2, hfS, hf'S]
    ring
  have IB : (∫ x in (-S)..(0:ℝ), (deriv (deriv f) x * b x - f x * deriv (deriv b) x))
      = deriv f 0 * b 0 - f 0 * deriv b 0 := by
    have hE1 := intervalIntegral.integral_deriv_mul_eq_sub (a := -S) (b := (0:ℝ))
      (u := deriv f) (u' := deriv (deriv f)) (v := b) (v' := deriv b)
      (fun x _ => hfdd x) (fun x _ => hbd x)
      (hfc''.intervalIntegrable _ _) (hbc'.intervalIntegrable _ _)
    have hE2 := intervalIntegral.integral_deriv_mul_eq_sub (a := -S) (b := (0:ℝ))
      (u := f) (u' := deriv f) (v := deriv b) (v' := deriv (deriv b))
      (fun x _ => hfd x) (fun x _ => hbdd x)
      (hfc'.intervalIntegrable _ _) (hbc''.intervalIntegrable _ _)
    have hsub : (∫ x in (-S)..(0:ℝ), (deriv (deriv f) x * b x + deriv f x * deriv b x))
        - (∫ x in (-S)..(0:ℝ), (deriv f x * deriv b x + f x * deriv (deriv b) x))
        = ∫ x in (-S)..(0:ℝ), (deriv (deriv f) x * b x - f x * deriv (deriv b) x) := by
      have ii1 : IntervalIntegrable
          (fun x => deriv (deriv f) x * b x + deriv f x * deriv b x) volume (-S) 0 :=
        ((hfc''.mul hbc).add (hfc'.mul hbc')).intervalIntegrable _ _
      have ii2 : IntervalIntegrable
          (fun x => deriv f x * deriv b x + f x * deriv (deriv b) x) volume (-S) 0 :=
        ((hfc'.mul hbc').add (hfc.mul hbc'')).intervalIntegrable _ _
      rw [← intervalIntegral.integral_sub ii1 ii2]
      exact intervalIntegral.integral_congr fun x _ => by ring
    rw [← hsub, hE1, hE2, hfS', hf'S']
    ring
  -- pass from the whole line to the interval `[-S,S]`
  have hcorner : Continuous (corner a b) := continuous_corner hac hbc h0
  have hL : ∫ t : ℝ, deriv (deriv f) t * corner a b t
      = ∫ t in (-S)..S, deriv (deriv f) t * corner a b t := by
    rw [intervalIntegral.integral_of_le (by linarith)]
    rw [MeasureTheory.setIntegral_eq_integral_of_forall_compl_eq_zero]
    intro x hx
    have : R < |x| := by
      rcases not_and_or.1 (fun h => hx ⟨h.1, h.2⟩) with h | h
      · have : x ≤ -S := le_of_not_gt h
        rw [abs_of_nonpos (by linarith)]; linarith
      · have : S < x := lt_of_not_ge h
        rw [abs_of_pos (by linarith)]; linarith
    rw [(hz x this).2.2, zero_mul]
  have hR2 : ∫ t : ℝ, f t * corner (deriv (deriv a)) (deriv (deriv b)) t
      = ∫ t in (-S)..S, f t * corner (deriv (deriv a)) (deriv (deriv b)) t := by
    rw [intervalIntegral.integral_of_le (by linarith)]
    rw [MeasureTheory.setIntegral_eq_integral_of_forall_compl_eq_zero]
    intro x hx
    have : R < |x| := by
      rcases not_and_or.1 (fun h => hx ⟨h.1, h.2⟩) with h | h
      · have : x ≤ -S := le_of_not_gt h
        rw [abs_of_nonpos (by linarith)]; linarith
      · have : S < x := lt_of_not_ge h
        rw [abs_of_pos (by linarith)]; linarith
    rw [(hz x this).1, zero_mul]
  -- split at `0` and identify the two halves
  have hmeas1 : IntervalIntegrable (fun t => deriv (deriv f) t * corner a b t) volume (-S) 0 :=
    (hfc''.mul hcorner).intervalIntegrable _ _
  have hmeas2 : IntervalIntegrable (fun t => deriv (deriv f) t * corner a b t) volume 0 S :=
    (hfc''.mul hcorner).intervalIntegrable _ _
  have hmeas3 : IntervalIntegrable
      (fun t => f t * corner (deriv (deriv a)) (deriv (deriv b)) t) volume (-S) 0 := by
    have hbase : IntervalIntegrable (fun t => f t * deriv (deriv b) t) volume (-S) 0 :=
      (hfc.mul hbc'').intervalIntegrable _ _
    refine ⟨hbase.1.congr ?_, ?_⟩
    · filter_upwards [MeasureTheory.ae_restrict_of_ae ae_ne_zero,
        MeasureTheory.ae_restrict_mem measurableSet_Ioc] with x hx hmem
      rw [corner_of_neg (lt_of_le_of_ne hmem.2 hx)]
    · rw [Set.Ioc_eq_empty (by linarith)]
      exact MeasureTheory.integrableOn_empty
  have hmeas4 : IntervalIntegrable
      (fun t => f t * corner (deriv (deriv a)) (deriv (deriv b)) t) volume 0 S := by
    refine IntervalIntegrable.congr ?_ ((hfc.mul hac'').intervalIntegrable 0 S)
    intro x hx
    rw [Set.uIoc_of_le hS.le] at hx
    show f x * deriv (deriv a) x = f x * corner (deriv (deriv a)) (deriv (deriv b)) x
    rw [corner_of_nonneg hx.1.le]
  have hnonneg : ∀ x ∈ Set.uIcc (0:ℝ) S, (0:ℝ) ≤ x := by
    intro x hx
    rw [Set.uIcc_of_le hS.le] at hx
    exact hx.1
  have hsplitL : ∫ t in (-S)..S, deriv (deriv f) t * corner a b t
      = (∫ t in (-S)..(0:ℝ), deriv (deriv f) t * b t)
        + ∫ t in (0:ℝ)..S, deriv (deriv f) t * a t := by
    rw [← intervalIntegral.integral_add_adjacent_intervals hmeas1 hmeas2]
    congr 1
    · refine intervalIntegral.integral_congr_ae ?_
      filter_upwards [ae_ne_zero] with x hx hmem
      rw [Set.uIoc_of_le (by linarith : (-S : ℝ) ≤ 0)] at hmem
      show deriv (deriv f) x * corner a b x = deriv (deriv f) x * b x
      rw [corner_of_neg (lt_of_le_of_ne hmem.2 hx)]
    · refine intervalIntegral.integral_congr fun x hx => ?_
      show deriv (deriv f) x * corner a b x = deriv (deriv f) x * a x
      rw [corner_of_nonneg (hnonneg x hx)]
  have hsplitR : ∫ t in (-S)..S, f t * corner (deriv (deriv a)) (deriv (deriv b)) t
      = (∫ t in (-S)..(0:ℝ), f t * deriv (deriv b) t)
        + ∫ t in (0:ℝ)..S, f t * deriv (deriv a) t := by
    rw [← intervalIntegral.integral_add_adjacent_intervals hmeas3 hmeas4]
    congr 1
    · refine intervalIntegral.integral_congr_ae ?_
      filter_upwards [ae_ne_zero] with x hx hmem
      rw [Set.uIoc_of_le (by linarith : (-S : ℝ) ≤ 0)] at hmem
      show f x * corner (deriv (deriv a)) (deriv (deriv b)) x = f x * deriv (deriv b) x
      rw [corner_of_neg (lt_of_le_of_ne hmem.2 hx)]
    · refine intervalIntegral.integral_congr fun x hx => ?_
      show f x * corner (deriv (deriv a)) (deriv (deriv b)) x = f x * deriv (deriv a) x
      rw [corner_of_nonneg (hnonneg x hx)]
  have e1 : (∫ t in (-S)..(0:ℝ), deriv (deriv f) t * b t)
      - (∫ t in (-S)..(0:ℝ), f t * deriv (deriv b) t)
      = deriv f 0 * b 0 - f 0 * deriv b 0 := by
    have ii1 : IntervalIntegrable (fun t => deriv (deriv f) t * b t) volume (-S) 0 :=
      (hfc''.mul hbc).intervalIntegrable _ _
    have ii2 : IntervalIntegrable (fun t => f t * deriv (deriv b) t) volume (-S) 0 :=
      (hfc.mul hbc'').intervalIntegrable _ _
    rw [← intervalIntegral.integral_sub ii1 ii2]
    exact IB
  have e2 : (∫ t in (0:ℝ)..S, deriv (deriv f) t * a t)
      - (∫ t in (0:ℝ)..S, f t * deriv (deriv a) t)
      = f 0 * deriv a 0 - deriv f 0 * a 0 := by
    have ii1 : IntervalIntegrable (fun t => deriv (deriv f) t * a t) volume 0 S :=
      (hfc''.mul hac).intervalIntegrable _ _
    have ii2 : IntervalIntegrable (fun t => f t * deriv (deriv a) t) volume 0 S :=
      (hfc.mul hac'').intervalIntegrable _ _
    rw [← intervalIntegral.integral_sub ii1 ii2]
    exact IA
  rw [hL, hR2, hsplitL, hsplitR]
  linear_combination e1 + e2 - deriv f 0 * h0

/-- A compactly supported continuous function times a `corner` function is integrable. -/
theorem integrable_mul_corner (hf : Continuous f) (hsupp : HasCompactSupport f)
    (ha : Continuous a) (hb : Continuous b) :
    Integrable (fun t => f t * corner a b t) := by
  have h1 : Integrable ((Set.Ici (0:ℝ)).indicator (fun t => f t * a t)) :=
    ((hf.mul ha).integrable_of_hasCompactSupport hsupp.mul_right).indicator measurableSet_Ici
  have h2 : Integrable ((Set.Iio (0:ℝ)).indicator (fun t => f t * b t)) :=
    ((hf.mul hb).integrable_of_hasCompactSupport hsupp.mul_right).indicator measurableSet_Iio
  refine (h1.add h2).congr (Filter.Eventually.of_forall fun t => ?_)
  show ((Set.Ici (0:ℝ)).indicator (fun t => f t * a t)) t
      + ((Set.Iio (0:ℝ)).indicator (fun t => f t * b t)) t = f t * corner a b t
  rcases le_or_gt 0 t with ht | ht
  · rw [Set.indicator_of_mem (Set.mem_Ici.2 ht), Set.indicator_of_notMem (by simpa using ht),
      corner_of_nonneg ht, add_zero]
  · rw [Set.indicator_of_notMem (by simpa using ht), Set.indicator_of_mem (Set.mem_Iio.2 ht),
      corner_of_neg ht, zero_add]

/-- The `Q`-form of the corner integration by parts formula: pairing `Q f` with a function
with a corner produces the boundary term `-(jump) f(0)`. -/
theorem integral_Qlog_mul_corner
    (hf : ContDiff ℝ 2 f) (hsupp : HasCompactSupport f)
    (ha : ContDiff ℝ 2 a) (hb : ContDiff ℝ 2 b) (h0 : a 0 = b 0) :
    ∫ t : ℝ, Qlog f t * corner a b t
      = -((deriv a 0 - deriv b 0) * f 0)
        + ∫ t : ℝ, f t * corner (Qlog a) (Qlog b) t := by
  have hfc : Continuous f := hf.continuous
  have hfc'' : Continuous (deriv (deriv f)) := (hf.deriv' : ContDiff ℝ 1 (deriv f)).continuous_deriv
    le_rfl
  have hac : Continuous a := ha.continuous
  have hbc : Continuous b := hb.continuous
  have hac'' : Continuous (deriv (deriv a)) := (ha.deriv' : ContDiff ℝ 1 (deriv a)).continuous_deriv
    le_rfl
  have hbc'' : Continuous (deriv (deriv b)) := (hb.deriv' : ContDiff ℝ 1 (deriv b)).continuous_deriv
    le_rfl
  have hcorner : Continuous (corner a b) := continuous_corner hac hbc h0
  -- split the left-hand side
  have hi1 : Integrable (fun t => deriv (deriv f) t * corner a b t) :=
    integrable_mul_corner hfc'' hsupp.deriv.deriv hac hbc
  have hi2 : Integrable (fun t => f t * corner a b t) :=
    integrable_mul_corner hfc hsupp hac hbc
  have hsplit : ∫ t : ℝ, Qlog f t * corner a b t
      = -(∫ t : ℝ, deriv (deriv f) t * corner a b t)
        + (∫ t : ℝ, f t * corner a b t) / 4 := by
    have hn1 : Integrable (fun t : ℝ => -(deriv (deriv f) t * corner a b t)) := hi1.neg
    have hd2 : Integrable (fun t : ℝ => f t * corner a b t / 4) := hi2.div_const 4
    rw [← MeasureTheory.integral_neg, ← MeasureTheory.integral_div,
      ← MeasureTheory.integral_add hn1 hd2]
    refine integral_congr_ae (Filter.Eventually.of_forall fun t => ?_)
    simp only [Qlog]
    ring
  -- split the right-hand side
  have hi3 : Integrable (fun t => f t * corner (deriv (deriv a)) (deriv (deriv b)) t) :=
    integrable_mul_corner hfc hsupp hac'' hbc''
  have hsplit' : ∫ t : ℝ, f t * corner (Qlog a) (Qlog b) t
      = -(∫ t : ℝ, f t * corner (deriv (deriv a)) (deriv (deriv b)) t)
        + (∫ t : ℝ, f t * corner a b t) / 4 := by
    have hn3 : Integrable
        (fun t : ℝ => -(f t * corner (deriv (deriv a)) (deriv (deriv b)) t)) := hi3.neg
    have hd2 : Integrable (fun t : ℝ => f t * corner a b t / 4) := hi2.div_const 4
    rw [← MeasureTheory.integral_neg, ← MeasureTheory.integral_div,
      ← MeasureTheory.integral_add hn3 hd2]
    refine integral_congr_ae (Filter.Eventually.of_forall fun t => ?_)
    rcases le_or_gt 0 t with ht | ht
    · simp only [corner_of_nonneg ht, Qlog]
      ring
    · simp only [corner_of_neg ht, Qlog]
      ring
  rw [hsplit, hsplit', integral_deriv2_mul_corner hf hsupp ha hb h0]
  ring

end

/-! ## The `-2‖ξ‖²` term -/

/-- The value at `ρ = 1` of `ξ ∗ ξ*` is `‖ξ‖²`. -/
theorem convLog_starLog_self_zero {F : ℝ → ℂ} :
    convLog F (starLog F) 0 = ((∫ s : ℝ, ‖F s‖ ^ 2 : ℝ) : ℂ) := by
  rw [convLog_apply, ← integral_complex_ofReal]
  refine integral_congr_ae (Filter.Eventually.of_forall fun s => ?_)
  show F s * starLog F (0 - s) = ((‖F s‖ ^ 2 : ℝ) : ℂ)
  rw [show (0:ℝ) - s = -s from by ring]
  simp only [starLog, neg_neg]
  rw [Complex.mul_conj']
  push_cast
  ring

/-- **Essential negativity of `D ∘ Q`, elementary form.**  If `g` is a function with a
corner at `ρ = 1` whose derivative jumps by `2` there — as the trace remainder `δ` does —
then pairing it with `Q(ξ ∗ ξ*)` produces the term `-2‖ξ‖²` plus the pairing of `ξ ∗ ξ*`
with the (smooth on each side) function `Qg`. -/
theorem integral_Qlog_convLog_starLog_mul_corner {F a b : ℝ → ℂ}
    (hF : ContDiff ℝ 2 F) (hsF : HasCompactSupport F)
    (ha : ContDiff ℝ 2 a) (hb : ContDiff ℝ 2 b) (h0 : a 0 = b 0)
    (hjump : deriv a 0 - deriv b 0 = 2) :
    ∫ t : ℝ, Qlog (convLog F (starLog F)) t * corner a b t
      = -2 * ((∫ s : ℝ, ‖F s‖ ^ 2 : ℝ) : ℂ)
        + ∫ t : ℝ, convLog F (starLog F) t * corner (Qlog a) (Qlog b) t := by
  have hstar : ContDiff ℝ 2 (starLog F) := by
    have : starLog F = (fun z => starRingEnd ℂ z) ∘ (F ∘ fun t : ℝ => -t) := rfl
    rw [this]
    exact (Complex.conjLIE.toLinearIsometry.toContinuousLinearMap.contDiff).comp
      (hF.comp (contDiff_neg))
  have hsstar : HasCompactSupport (starLog F) := hasCompactSupport_starLog hsF
  have hconv : ContDiff ℝ 2 (convLog F (starLog F)) :=
    HasCompactSupport.contDiff_convolution_left (n := 2) _ hsF hF
      hstar.continuous.locallyIntegrable
  have hsconv : HasCompactSupport (convLog F (starLog F)) :=
    hasCompactSupport_convLog hsF hsstar
  rw [integral_Qlog_mul_corner hconv hsconv ha hb h0, hjump, convLog_starLog_self_zero]
  ring

end ConnesConsani.WeilPositivity
