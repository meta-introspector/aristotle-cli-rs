/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Boundedness of the remainder in the essential negativity identity of §4 and §6 of
arXiv:2006.13771.  The identity of `RequestProject/DeltaSmooth.lean` writes
`D(Q(ξ ∗ ξ*))` as `-2‖ξ‖²` plus a pairing of `ξ ∗ ξ*` with the kernel `Qδ`, which is
smooth on each side of `ρ = 1`.  Here we show that this remainder is bounded by a
constant multiple of `‖ξ‖²`, the constant depending only on the (compact) support
allowed for `ξ`.  This is the precise sense in which `D ∘ Q` is *essentially* negative.
-/
import RequestProject.Imported.OutputFinal.RequestProject.DeltaSmooth

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

/-! ## The convolution square is bounded by the `L²` norm -/

/-- `(F ∗ F*)(t) = ∫ F(s) conj(F(s - t)) ds`. -/
theorem convLog_starLog_self_apply (F : ℝ → ℂ) (t : ℝ) :
    convLog F (starLog F) t = ∫ s : ℝ, F s * starRingEnd ℂ (F (s - t)) := by
  rw [convLog_apply]
  refine integral_congr_ae (Filter.Eventually.of_forall fun s => ?_)
  show F s * starRingEnd ℂ (F (-(t - s))) = _
  rw [show -(t - s) = s - t from by ring]

/-- The pointwise bound `‖(F ∗ F*)(t)‖ ≤ ‖F‖²₂`, a consequence of the Cauchy–Schwarz
inequality (here obtained from `ab ≤ (a² + b²)/2`). -/
theorem norm_convLog_starLog_self_le {F : ℝ → ℂ} (hF : Continuous F)
    (hsF : HasCompactSupport F) (t : ℝ) :
    ‖convLog F (starLog F) t‖ ≤ ∫ s : ℝ, ‖F s‖ ^ 2 := by
  have hsqsupp : HasCompactSupport (fun s : ℝ => ‖F s‖ ^ 2) :=
    hsF.norm.comp_left (g := fun r : ℝ => r ^ 2) (by simp)
  have hsq : Integrable (fun s : ℝ => ‖F s‖ ^ 2) :=
    ((hF.norm.pow 2).integrable_of_hasCompactSupport hsqsupp)
  have hsqt : Integrable (fun s : ℝ => ‖F (s - t)‖ ^ 2) := by
    have := hsq.comp_sub_right t
    simpa using this
  have hprod : Integrable (fun s : ℝ => ‖F s‖ * ‖F (s - t)‖) := by
    refine Continuous.integrable_of_hasCompactSupport ?_ ?_
    · exact hF.norm.mul ((hF.comp (continuous_id.sub continuous_const)).norm)
    · exact HasCompactSupport.mul_right hsF.norm
  have hmid : Integrable (fun s : ℝ => (‖F s‖ ^ 2 + ‖F (s - t)‖ ^ 2) / 2) :=
    (hsq.add hsqt).div_const 2
  calc ‖convLog F (starLog F) t‖
      = ‖∫ s : ℝ, F s * starRingEnd ℂ (F (s - t))‖ := by
        rw [convLog_starLog_self_apply]
    _ ≤ ∫ s : ℝ, ‖F s * starRingEnd ℂ (F (s - t))‖ := norm_integral_le_integral_norm _
    _ = ∫ s : ℝ, ‖F s‖ * ‖F (s - t)‖ := by
        refine integral_congr_ae (Filter.Eventually.of_forall fun s => ?_)
        simp
    _ ≤ ∫ s : ℝ, (‖F s‖ ^ 2 + ‖F (s - t)‖ ^ 2) / 2 := by
        refine integral_mono hprod hmid fun s => ?_
        nlinarith [sq_nonneg (‖F s‖ - ‖F (s - t)‖)]
    _ = ∫ s : ℝ, ‖F s‖ ^ 2 := by
        rw [integral_div, integral_add hsq hsqt]
        have : (∫ s : ℝ, ‖F (s - t)‖ ^ 2) = ∫ s : ℝ, ‖F s‖ ^ 2 :=
          integral_sub_right_eq_self (fun s : ℝ => ‖F s‖ ^ 2) t
        rw [this]
        ring

/-- If `F` is supported in `[-a, a]` then `F ∗ F*` is supported in `[-2a, 2a]`. -/
theorem convLog_starLog_self_eq_zero {F : ℝ → ℂ} {a t : ℝ}
    (hsupp : ∀ s, a < |s| → F s = 0) (ht : 2 * a < |t|) :
    convLog F (starLog F) t = 0 := by
  rw [convLog_starLog_self_apply]
  have : (fun s : ℝ => F s * starRingEnd ℂ (F (s - t))) = fun _ => (0 : ℂ) := by
    funext s
    rcases le_or_gt |s| a with hs | hs
    · rcases le_or_gt |s - t| a with hst | hst
      · exfalso
        have : |t| ≤ |s| + |s - t| := by
          have := abs_sub_abs_le_abs_sub s (s - t)
          have h2 : |s - (s - t)| = |t| := by rw [show s - (s - t) = t from by ring]
          calc |t| = |s - (s - t)| := h2.symm
            _ ≤ |s| + |s - t| := by
                simpa using abs_sub (s) (s - t)
        linarith
      · rw [hsupp _ hst]; simp
    · rw [hsupp _ hs]; simp
  rw [this]
  simp

/-! ## The remainder is bounded by a multiple of `‖ξ‖²` -/

/-- The pairing of `F ∗ F*` with a kernel `K` which is bounded by `C` on the interval
`[-2a, 2a]` is at most `4a·C·‖F‖²₂`. -/
theorem norm_integral_convLog_starLog_mul_le {F K : ℝ → ℂ} {a C : ℝ} (ha : 0 ≤ a)
    (hF : Continuous F) (hsupp : ∀ s, a < |s| → F s = 0)
    (hC : ∀ t ∈ Icc (-(2 * a)) (2 * a), ‖K t‖ ≤ C) :
    ‖∫ t : ℝ, convLog F (starLog F) t * K t‖
      ≤ (4 * a) * (C * ∫ s : ℝ, ‖F s‖ ^ 2) := by
  have hsF : HasCompactSupport F :=
    HasCompactSupport.intro (isCompact_Icc (a := -a) (b := a)) fun x hx =>
      hsupp x (by
        by_contra hcon
        push_neg at hcon
        exact hx (mem_Icc.2 ⟨(abs_le.1 hcon).1, (abs_le.1 hcon).2⟩))
  set N : ℝ := ∫ s : ℝ, ‖F s‖ ^ 2 with hN
  have hNnonneg : 0 ≤ N := integral_nonneg fun s => by positivity
  have hzero : ∀ t ∉ Icc (-(2 * a)) (2 * a), convLog F (starLog F) t * K t = 0 := by
    intro t ht
    have habs : 2 * a < |t| := by
      by_contra hcon
      push_neg at hcon
      exact ht (mem_Icc.2 ⟨by linarith [neg_abs_le t], le_trans (le_abs_self t) hcon⟩)
    rw [convLog_starLog_self_eq_zero hsupp habs, zero_mul]
  have hrw : (∫ t : ℝ, convLog F (starLog F) t * K t)
      = ∫ t in Icc (-(2 * a)) (2 * a), convLog F (starLog F) t * K t :=
    (setIntegral_eq_integral_of_forall_compl_eq_zero hzero).symm
  have hbound : ∀ t ∈ Icc (-(2 * a)) (2 * a),
      ‖convLog F (starLog F) t * K t‖ ≤ C * N := by
    intro t ht
    have h1 : ‖convLog F (starLog F) t‖ ≤ N := norm_convLog_starLog_self_le hF hsF t
    have h2 : ‖K t‖ ≤ C := hC t ht
    have hCnonneg : 0 ≤ C := le_trans (norm_nonneg _) h2
    rw [norm_mul]
    calc ‖convLog F (starLog F) t‖ * ‖K t‖ ≤ N * C := by
          exact mul_le_mul h1 h2 (norm_nonneg _) hNnonneg
      _ = C * N := by ring
  have hmeas : (volume (Icc (-(2 * a)) (2 * a))) < ⊤ := by
    simp [Real.volume_Icc]
  have := norm_setIntegral_le_of_norm_le_const (μ := volume)
    (s := Icc (-(2 * a)) (2 * a)) (f := fun t => convLog F (starLog F) t * K t)
    hmeas hbound
  rw [hrw]
  refine this.trans ?_
  have hvol : (volume.real (Icc (-(2 * a)) (2 * a))) = 4 * a := by
    rw [measureReal_def, Real.volume_Icc]
    rw [show (2 * a - -(2 * a)) = 4 * a from by ring]
    rw [ENNReal.toReal_ofReal (by linarith)]
  rw [hvol]
  exact le_of_eq (by ring)

/-- A continuous kernel is bounded on the compact interval `[-b, b]`. -/
theorem exists_bound_corner_on_Icc {k₁ k₂ : ℝ → ℂ} (hk₁ : Continuous k₁)
    (hk₂ : Continuous k₂) (b : ℝ) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ t ∈ Icc (-b) b, ‖corner k₁ k₂ t‖ ≤ C := by
  obtain ⟨C₁, hC₁⟩ := (isCompact_Icc (a := -b) (b := b)).exists_bound_of_continuousOn
    (hk₁.norm.continuousOn)
  obtain ⟨C₂, hC₂⟩ := (isCompact_Icc (a := -b) (b := b)).exists_bound_of_continuousOn
    (hk₂.norm.continuousOn)
  refine ⟨max (max C₁ C₂) 0, le_max_right _ _, fun t ht => ?_⟩
  rcases le_or_gt 0 t with h | h
  · rw [corner_of_nonneg h]
    exact le_trans (le_trans (le_abs_self _) (hC₁ t ht)) (le_trans (le_max_left _ _)
      (le_max_left _ _))
  · rw [corner_of_neg h]
    exact le_trans (le_trans (le_abs_self _) (hC₂ t ht)) (le_trans (le_max_right _ _)
      (le_max_left _ _))

/-! ## Quantitative essential negativity -/

/-- **Essential negativity of `D ∘ Q`, quantitative form.**  For every `a > 0` there is a
constant `C` such that, for every `C²` test function `ξ` supported in the interval
`|t| ≤ a` (that is, `ρ ∈ [e^{-a}, e^{a}]`), the pairing of `Q(ξ ∗ ξ*)` with the trace
remainder `δ` differs from `-2‖ξ‖²` by at most `C‖ξ‖²`.  Thus `D ∘ Q` is negative up to
a bounded remainder, uniformly on test functions with a fixed compact support. -/
theorem essential_negativity_quantitative (a : ℝ) (ha : 0 ≤ a) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ F : ℝ → ℂ, ContDiff ℝ 2 F → (∀ s, a < |s| → F s = 0) →
      ‖(∫ t : ℝ, Qlog (convLog F (starLog F)) t * ((delta (Rplus.expHomeo t) : ℝ) : ℂ))
          + 2 * ((∫ s : ℝ, ‖F s‖ ^ 2 : ℝ) : ℂ)‖
        ≤ C * ∫ s : ℝ, ‖F s‖ ^ 2 := by
  have hR : Continuous (Qlog deltaPieceR) := (contDiff_Qlog (contDiff_deltaPieceR 4)).continuous
  have hL : Continuous (Qlog deltaPieceL) := (contDiff_Qlog (contDiff_deltaPieceL 4)).continuous
  obtain ⟨C, hC0, hC⟩ := exists_bound_corner_on_Icc hR hL (2 * a)
  refine ⟨(4 * a) * C, by positivity, fun F hF hsupp => ?_⟩
  have hsF : HasCompactSupport F :=
    HasCompactSupport.intro (isCompact_Icc (a := -a) (b := a)) fun x hx =>
      hsupp x (by
        by_contra hcon
        push_neg at hcon
        exact hx (mem_Icc.2 ⟨(abs_le.1 hcon).1, (abs_le.1 hcon).2⟩))
  have hkey := essential_negativity_delta hF hsF
  have hrw : (∫ t : ℝ, Qlog (convLog F (starLog F)) t * ((delta (Rplus.expHomeo t) : ℝ) : ℂ))
      + 2 * ((∫ s : ℝ, ‖F s‖ ^ 2 : ℝ) : ℂ)
      = ∫ t : ℝ, convLog F (starLog F) t
          * corner (Qlog deltaPieceR) (Qlog deltaPieceL) t := by
    rw [hkey]; ring
  rw [hrw]
  have := norm_integral_convLog_starLog_mul_le (K := corner (Qlog deltaPieceR) (Qlog deltaPieceL))
    ha hF.continuous hsupp hC
  calc ‖∫ t : ℝ, convLog F (starLog F) t * corner (Qlog deltaPieceR) (Qlog deltaPieceL) t‖
      ≤ (4 * a) * (C * ∫ s : ℝ, ‖F s‖ ^ 2) := this
    _ = (4 * a) * C * ∫ s : ℝ, ‖F s‖ ^ 2 := by ring

/-- **Strict negativity of `D ∘ Q` on test functions with small support.**  There is an
`a > 0` such that every `C²` test function `ξ` supported in `|log ρ| ≤ a` satisfies
`Re D(Q(ξ ∗ ξ*)) ≤ -‖ξ‖²`.  This is the negativity of §4 of the paper in the regime where
the bounded remainder cannot compensate the term `-2‖ξ‖²`. -/
theorem essential_negativity_strict :
    ∃ a : ℝ, 0 < a ∧ ∀ F : ℝ → ℂ, ContDiff ℝ 2 F → (∀ s, a < |s| → F s = 0) →
      (∫ t : ℝ, Qlog (convLog F (starLog F)) t * ((delta (Rplus.expHomeo t) : ℝ) : ℂ)).re
        ≤ -(∫ s : ℝ, ‖F s‖ ^ 2) := by
  have hR : Continuous (Qlog deltaPieceR) := (contDiff_Qlog (contDiff_deltaPieceR 4)).continuous
  have hL : Continuous (Qlog deltaPieceL) := (contDiff_Qlog (contDiff_deltaPieceL 4)).continuous
  obtain ⟨M, hM0, hM⟩ := exists_bound_corner_on_Icc hR hL 2
  set a : ℝ := min 1 (1 / (4 * (M + 1))) with hadef
  have hM1 : (0 : ℝ) < 4 * (M + 1) := by linarith
  have ha : 0 < a := lt_min one_pos (by positivity)
  have ha1 : a ≤ 1 := min_le_left _ _
  have ha2 : a ≤ 1 / (4 * (M + 1)) := min_le_right _ _
  have hsmall : 4 * a * M ≤ 1 := by
    have h1 : 4 * a * M ≤ 4 * (1 / (4 * (M + 1))) * M := by
      have : 4 * a ≤ 4 * (1 / (4 * (M + 1))) := by linarith
      nlinarith
    have h2 : 4 * (1 / (4 * (M + 1))) * M = M / (M + 1) := by
      field_simp
    rw [h2] at h1
    have h3 : M / (M + 1) ≤ 1 := by
      rw [div_le_one (by linarith)]
      linarith
    linarith
  refine ⟨a, ha, fun F hF hsupp => ?_⟩
  have hN0 : (0 : ℝ) ≤ ∫ s : ℝ, ‖F s‖ ^ 2 := integral_nonneg fun s => by positivity
  have hsF : HasCompactSupport F :=
    HasCompactSupport.intro (isCompact_Icc (a := -a) (b := a)) fun x hx =>
      hsupp x (by
        by_contra hcon
        push_neg at hcon
        exact hx (mem_Icc.2 ⟨(abs_le.1 hcon).1, (abs_le.1 hcon).2⟩))
  have hMa : ∀ t ∈ Icc (-(2 * a)) (2 * a),
      ‖corner (Qlog deltaPieceR) (Qlog deltaPieceL) t‖ ≤ M := by
    intro t ht
    refine hM t (mem_Icc.2 ⟨?_, ?_⟩)
    · have := (mem_Icc.1 ht).1; linarith
    · have := (mem_Icc.1 ht).2; linarith
  have hkey := essential_negativity_delta hF hsF
  have hbound := norm_integral_convLog_starLog_mul_le
    (K := corner (Qlog deltaPieceR) (Qlog deltaPieceL)) ha.le hF.continuous hsupp hMa
  have hXeq : (∫ t : ℝ, Qlog (convLog F (starLog F)) t * ((delta (Rplus.expHomeo t) : ℝ) : ℂ))
        + 2 * ((∫ s : ℝ, ‖F s‖ ^ 2 : ℝ) : ℂ)
      = ∫ t : ℝ, convLog F (starLog F) t
          * corner (Qlog deltaPieceR) (Qlog deltaPieceL) t := by
    rw [hkey]; ring
  have hnorm : ‖(∫ t : ℝ, Qlog (convLog F (starLog F)) t * ((delta (Rplus.expHomeo t) : ℝ) : ℂ))
        + 2 * ((∫ s : ℝ, ‖F s‖ ^ 2 : ℝ) : ℂ)‖ ≤ ∫ s : ℝ, ‖F s‖ ^ 2 := by
    rw [hXeq]
    refine hbound.trans ?_
    calc (4 * a) * (M * ∫ s : ℝ, ‖F s‖ ^ 2)
        = (4 * a * M) * ∫ s : ℝ, ‖F s‖ ^ 2 := by ring
      _ ≤ 1 * ∫ s : ℝ, ‖F s‖ ^ 2 := by nlinarith
      _ = ∫ s : ℝ, ‖F s‖ ^ 2 := one_mul _
  have h1 : ((∫ t : ℝ, Qlog (convLog F (starLog F)) t * ((delta (Rplus.expHomeo t) : ℝ) : ℂ))
        + 2 * ((∫ s : ℝ, ‖F s‖ ^ 2 : ℝ) : ℂ)).re
      = (∫ t : ℝ, Qlog (convLog F (starLog F)) t * ((delta (Rplus.expHomeo t) : ℝ) : ℂ)).re
        + 2 * ∫ s : ℝ, ‖F s‖ ^ 2 := by
    simp [Complex.add_re]
  have h2 := ((∫ t : ℝ, Qlog (convLog F (starLog F)) t
      * ((delta (Rplus.expHomeo t) : ℝ) : ℂ))
      + 2 * ((∫ s : ℝ, ‖F s‖ ^ 2 : ℝ) : ℂ)).re_le_norm
  rw [h1] at h2
  linarith

end ConnesConsani.WeilPositivity
