/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

**Effective** form of Corollary 3.8 of

  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771.

Corollary 3.8 of the paper states that `D ∘ Q ≤ 0` on `C_c^∞(I)` for `I = [u⁻¹, u]` with
`u = 1.10246`, the proof resting on the *numerical* verification of `∫₀ˢ |Qδ(exp x)| dx ≤ 1`
for `s = log u = 0.097542`.  Using the proved bound `|Qδ(exp t)| ≤ 14` for `|t| ≤ 1/15` of
`RequestProject/KernelBound.lean`, this file proves the same statement with the *explicit*
constant

  `s = 1/15`,  i.e.  `u = e^{1/15} = 1.0689…`,

with the quantitative margin `D(Q f) ≤ -(2/15) f(1)`: the elementary bounds on the moments
overestimate `|Qδ|` by about 25%, so the interval obtained here is smaller than the one the
paper obtains numerically (`1.0689` against `1.10246`), but the statement is now
unconditional and free of any existential quantifier on the length of the interval.

The file first proves the general form `DQ_nonpos_of_kernel_integral`, in which the
paper's criterion appears as an explicit hypothesis `∫_{-s}^{s}|Qδ| ≤ M` and the conclusion
is `Re D(Q f) ≤ -(2 - M) f(1)`; feeding it the paper's numerical values `u = 1.10246`
(Corollary 3.8) and `u = 1.15077` (Remark 3.9) returns the paper's statements, and feeding
it the bound proved in `RequestProject/KernelBound.lean` returns the unconditional
`u = e^{1/15}` above.
-/
import RequestProject.Imported.OutputFinal2.KernelBound
import RequestProject.Imported.OutputFinal2.Positivity

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

/-! ## The paper's criterion `∫₀ˢ |Qδ| ≤ 1`, in general effective form -/

/-- The kernel `Qδ` is measurable: it is the corner function of two continuous functions. -/
theorem measurable_Qdelta :
    Measurable (corner (Qlog deltaPieceR) (Qlog deltaPieceL)) := by
  have hR : Continuous (Qlog deltaPieceR) := (contDiff_Qlog (contDiff_deltaPieceR 4)).continuous
  have hL : Continuous (Qlog deltaPieceL) := (contDiff_Qlog (contDiff_deltaPieceL 4)).continuous
  exact Measurable.ite measurableSet_Ici hR.measurable hL.measurable

/-- The kernel `Qδ` is integrable on every bounded interval. -/
theorem integrableOn_norm_Qdelta (s : ℝ) :
    IntegrableOn (fun t => ‖corner (Qlog deltaPieceR) (Qlog deltaPieceL) t‖) (Icc (-s) s) := by
  have hR : Continuous (Qlog deltaPieceR) := (contDiff_Qlog (contDiff_deltaPieceR 4)).continuous
  have hL : Continuous (Qlog deltaPieceL) := (contDiff_Qlog (contDiff_deltaPieceL 4)).continuous
  obtain ⟨C, _, hC⟩ := exists_bound_corner_on_Icc hR hL s
  refine Measure.integrableOn_of_bounded (M := C) (by simp [Real.volume_Icc])
    measurable_Qdelta.norm.aestronglyMeasurable ?_
  filter_upwards [ae_restrict_mem measurableSet_Icc] with t ht
  rw [Real.norm_eq_abs, abs_of_nonneg (norm_nonneg _)]
  exact hC t ht

/-- **The remainder bound of Corollary 3.8, in the form used by the paper.**  If the test
function `f` is supported in `|t| ≤ s` and bounded by `B`, and if the kernel satisfies the
paper's criterion `∫_{-s}^{s} |Qδ| ≤ M` (that is, `∫₀ˢ |Qδ| ≤ M/2`), then the remainder in
the jump formula is at most `B M`. -/
theorem norm_integral_mul_Qdelta_le_of_kernel_integral {f : ℝ → ℂ} {s B M : ℝ}
    (hfc : Continuous f) (hsupp : ∀ t : ℝ, s < |t| → f t = 0) (hB : ∀ t, ‖f t‖ ≤ B)
    (hM : (∫ t in Icc (-s) s, ‖corner (Qlog deltaPieceR) (Qlog deltaPieceL) t‖) ≤ M) :
    ‖∫ t : ℝ, f t * corner (Qlog deltaPieceR) (Qlog deltaPieceL) t‖ ≤ B * M := by
  have hB0 : 0 ≤ B := le_trans (norm_nonneg _) (hB 0)
  set K : ℝ → ℂ := corner (Qlog deltaPieceR) (Qlog deltaPieceL) with hK
  have hKint : IntegrableOn (fun t => ‖K t‖) (Icc (-s) s) := integrableOn_norm_Qdelta s
  have hzero : ∀ t ∉ Icc (-s) s, f t * K t = 0 := by
    intro t ht
    have habs : s < |t| := by
      by_contra hcon
      push_neg at hcon
      exact ht (mem_Icc.2 ⟨by linarith [neg_abs_le t], le_trans (le_abs_self t) hcon⟩)
    rw [hsupp t habs, zero_mul]
  have hprod : IntegrableOn (fun t => ‖f t * K t‖) (Icc (-s) s) := by
    refine Integrable.mono' (hKint.const_mul B)
      (hfc.measurable.mul measurable_Qdelta).norm.aestronglyMeasurable.restrict ?_
    filter_upwards with t
    rw [Real.norm_eq_abs, abs_of_nonneg (norm_nonneg _), norm_mul]
    exact mul_le_mul_of_nonneg_right (hB t) (norm_nonneg _)
  calc ‖∫ t : ℝ, f t * K t‖ = ‖∫ t in Icc (-s) s, f t * K t‖ := by
        rw [setIntegral_eq_integral_of_forall_compl_eq_zero hzero]
    _ ≤ ∫ t in Icc (-s) s, ‖f t * K t‖ := norm_integral_le_integral_norm _
    _ ≤ ∫ t in Icc (-s) s, B * ‖K t‖ := by
        refine setIntegral_mono_on hprod (hKint.const_mul B) measurableSet_Icc fun t _ => ?_
        rw [norm_mul]
        exact mul_le_mul_of_nonneg_right (hB t) (norm_nonneg _)
    _ = B * ∫ t in Icc (-s) s, ‖K t‖ := integral_const_mul _ _
    _ ≤ B * M := mul_le_mul_of_nonneg_left hM hB0

/-- **Corollary 3.8 of the paper, in general effective form.**  Let `f` be a `C²` test
function supported in `{ρ : |log ρ| ≤ s}` with `|f(ρ)| ≤ f(1)` (as every positive definite
function has), and suppose the kernel satisfies `∫_{-s}^{s} |Qδ| ≤ M`.  Then

  `Re D(Q f) ≤ -(2 - M) f(1)`.

In particular `D(Q f) ≤ 0` as soon as `M ≤ 2`, i.e. as soon as the paper's numerical
criterion `∫₀ˢ |Qδ(exp x)| dx ≤ 1` holds.  No numerical input is hidden in this statement:
the criterion is a hypothesis, and it is discharged unconditionally for `s = 1/15` in
`DQ_nonpos_effective` below. -/
theorem DQ_nonpos_of_kernel_integral {f : ℝ → ℂ} {s M : ℝ}
    (hf : ContDiff ℝ 2 f) (hsupp : ∀ t : ℝ, s < |t| → f t = 0)
    (hB : ∀ t : ℝ, ‖f t‖ ≤ (f 0).re)
    (hM : (∫ t in Icc (-s) s, ‖corner (Qlog deltaPieceR) (Qlog deltaPieceL) t‖) ≤ M) :
    (∫ t : ℝ, Qlog f t * ((delta (Rplus.expHomeo t) : ℝ) : ℂ)).re ≤ -(2 - M) * (f 0).re := by
  have hB0 : 0 ≤ (f 0).re := le_trans (norm_nonneg _) (hB 0)
  have hsf : HasCompactSupport f :=
    HasCompactSupport.intro (isCompact_Icc (a := -s) (b := s)) fun x hx =>
      hsupp x (by
        by_contra hcon
        push_neg at hcon
        exact hx (mem_Icc.2 ⟨(abs_le.1 hcon).1, (abs_le.1 hcon).2⟩))
  have hkey := integral_Qlog_mul_corner hf hsf (contDiff_deltaPieceR 2) (contDiff_deltaPieceL 2)
    deltaPieceR_zero_eq
  rw [deltaPiece_jump] at hkey
  have hdelta : (∫ t : ℝ, Qlog f t * ((delta (Rplus.expHomeo t) : ℝ) : ℂ))
      = ∫ t : ℝ, Qlog f t * corner deltaPieceR deltaPieceL t :=
    integral_congr_ae (Filter.Eventually.of_forall fun t => by simp only [corner_deltaPiece])
  rw [hdelta, hkey]
  have hrem := norm_integral_mul_Qdelta_le_of_kernel_integral hf.continuous hsupp hB hM
  have hre : (-(2 * f 0) + ∫ t : ℝ, f t * corner (Qlog deltaPieceR) (Qlog deltaPieceL) t).re
      = -2 * (f 0).re
        + (∫ t : ℝ, f t * corner (Qlog deltaPieceR) (Qlog deltaPieceL) t).re := by
    simp [Complex.add_re, Complex.neg_re]
  rw [hre]
  have hle : (∫ t : ℝ, f t * corner (Qlog deltaPieceR) (Qlog deltaPieceL) t).re
      ≤ (f 0).re * M := le_trans (Complex.re_le_norm _) hrem
  nlinarith

/-- **The paper's Corollary 3.8 and Remark 3.9, in effective form.**  Assume the numerical
criterion behind Figure 8 of the paper, `∫_{-log u}^{log u} |Qδ| ≤ 2` (equivalently
`∫₀^{log u} |Qδ(exp x)| dx ≤ 1`), for a given `u ≥ 1`.  Then `D ∘ Q ≤ 0` on the test
functions supported in `[u⁻¹, u]` that are bounded by their value at `1`.

The paper verifies the criterion numerically for `u = 1.10246` (Corollary 3.8) and, using
the Boas–Kac refinement, for `u = 1.15077` (Remark 3.9); with those numerical inputs this
theorem returns exactly the paper's statements.  The criterion itself is *not* proved here
for those two values — it is proved here only for the smaller value `u = e^{1/15}`, see
`DQ_nonpos_effective`. -/
theorem DQ_nonpos_of_paper_criterion {u : ℝ} {f : ℝ → ℂ} (hf : ContDiff ℝ 2 f)
    (hsupp : ∀ t : ℝ, Real.log u < |t| → f t = 0) (hB : ∀ t : ℝ, ‖f t‖ ≤ (f 0).re)
    (hcrit : (∫ t in Icc (-Real.log u) (Real.log u),
      ‖corner (Qlog deltaPieceR) (Qlog deltaPieceL) t‖) ≤ 2) :
    (∫ t : ℝ, Qlog f t * ((delta (Rplus.expHomeo t) : ℝ) : ℂ)).re ≤ 0 := by
  have h := DQ_nonpos_of_kernel_integral hf hsupp hB hcrit
  linarith [h]

/-! ## The effective kernel-integral bound -/

/-- **The paper's criterion, proved for `s = 1/15`.**  The proved kernel bound
`|Qδ(exp t)| ≤ 14` for `|t| ≤ 1/15` gives `∫_{-1/15}^{1/15} |Qδ| ≤ 28/15 < 2`, which is the
numerical input of Corollary 3.8 with the explicit value `s = 1/15`. -/
theorem integral_norm_Qdelta_le :
    (∫ t in Icc (-(1 / 15) : ℝ) (1 / 15),
      ‖corner (Qlog deltaPieceR) (Qlog deltaPieceL) t‖) ≤ 28 / 15 := by
  have hconst : (∫ _t in Icc (-(1 / 15) : ℝ) (1 / 15), (14 : ℝ)) = 28 / 15 := by
    rw [setIntegral_const, measureReal_def, Real.volume_Icc]
    norm_num
  calc (∫ t in Icc (-(1 / 15) : ℝ) (1 / 15),
        ‖corner (Qlog deltaPieceR) (Qlog deltaPieceL) t‖)
      ≤ ∫ _t in Icc (-(1 / 15) : ℝ) (1 / 15), (14 : ℝ) := by
        refine setIntegral_mono_on (integrableOn_norm_Qdelta _)
          (integrableOn_const (C := (14 : ℝ)) (by simp [Real.volume_Icc]))
          measurableSet_Icc fun t ht => ?_
        exact norm_Qdelta_le (abs_le.2 ⟨(mem_Icc.1 ht).1, (mem_Icc.1 ht).2⟩)
    _ = 28 / 15 := hconst

/-! ## Effective negativity of `D ∘ Q` (Corollary 3.8) -/

/-- **Corollary 3.8, effective form.**  Let `f` be a `C²` test function supported in
`{ρ : |log ρ| ≤ 1/15}` — that is, in `[u⁻¹, u]` with `u = e^{1/15} = 1.0689…` — and
satisfying `|f(ρ)| ≤ f(1)` (as every positive definite function does).  Then

  `Re D(Q f) ≤ -(2/15) f(1) ≤ 0`.

The hypothesis `|f| ≤ f(1)` is the only consequence of positive definiteness used in the
paper's proof of Corollary 3.8. -/
theorem DQ_nonpos_effective {f : ℝ → ℂ} (hf : ContDiff ℝ 2 f)
    (hsupp : ∀ s : ℝ, 1 / 15 < |s| → f s = 0) (hB : ∀ s : ℝ, ‖f s‖ ≤ (f 0).re) :
    (∫ t : ℝ, Qlog f t * ((delta (Rplus.expHomeo t) : ℝ) : ℂ)).re ≤ -(2 / 15) * (f 0).re := by
  have h := DQ_nonpos_of_kernel_integral hf hsupp hB integral_norm_Qdelta_le
  have hrw : -(2 - 28 / 15 : ℝ) = -(2 / 15) := by norm_num
  rwa [hrw] at h

/-- The same statement in the multiplicative language: the value of the functional `D` of
the paper at `Q f`, for a test function on `ℝ⋆₊` supported in `[u⁻¹, u]`,
`u = e^{1/15} = 1.0689…`. -/
theorem Dcomplex_Qlog_nonpos_effective {f : ℝ → ℂ} (hf : ContDiff ℝ 2 f)
    (hsupp : ∀ s : ℝ, 1 / 15 < |s| → f s = 0) (hB : ∀ s : ℝ, ‖f s‖ ≤ (f 0).re) :
    (Dcomplex (ofLog (Qlog f))).re ≤ -(2 / 15) * (f 0).re := by
  rw [Dcomplex_ofLog]
  exact DQ_nonpos_effective hf hsupp hB

/-! ## Effective negativity on convolution squares -/

/-- **Effective form of the small-support negativity for convolution squares.**  Every `C²`
test function `ξ` supported in `{ρ : |log ρ| ≤ 1/30}` satisfies
`D(Q(ξ ∗ ξ*)) ≤ -(2/15)‖ξ‖²`.  This makes `small_support_DQ_negative` effective: the
existential `∃ a > 0` is replaced by the explicit value `a = 1/30`. -/
theorem DQ_convLog_starLog_effective {F : ℝ → ℂ} (hF : ContDiff ℝ 2 F)
    (hsupp : SupportedIn (1 / 30) F) :
    D_Q_pairing F ≤ -(2 / 15) * L2sq F := by
  have hsF : HasCompactSupport F := hasCompactSupport_of_supportedIn hsupp
  set f : ℝ → ℂ := convLog F (starLog F) with hfdef
  have hf : ContDiff ℝ 2 f := contDiff_convLog_starLog_self hF hsF
  have hf0 : f 0 = ((L2sq F : ℝ) : ℂ) := by
    rw [hfdef, convLog_starLog_self_zero, L2sq]
  have hf0re : (f 0).re = L2sq F := by rw [hf0, Complex.ofReal_re]
  have hsuppf : ∀ s : ℝ, 1 / 15 < |s| → f s = 0 := by
    intro s hs
    exact convLog_starLog_self_eq_zero (a := 1 / 30) hsupp (by linarith)
  have hB : ∀ s : ℝ, ‖f s‖ ≤ (f 0).re := by
    intro s
    rw [hf0re, L2sq]
    exact norm_convLog_starLog_self_le hF.continuous hsF s
  have h := DQ_nonpos_effective hf hsuppf hB
  rw [hf0re] at h
  exact h

/-- The same statement for the functional `D` on `ℝ⋆₊`. -/
theorem Dcomplex_Qlog_convLog_effective {F : ℝ → ℂ} (hF : ContDiff ℝ 2 F)
    (hsupp : SupportedIn (1 / 30) F) :
    (Dcomplex (ofLog (Qlog (convLog F (starLog F))))).re ≤ -(2 / 15) * L2sq F := by
  rw [← D_Q_pairing_eq]
  exact DQ_convLog_starLog_effective hF hsupp

/-- **Effective form of the lower bound for `W_∞`.**  Granting the positivity of
`L = D + W_∞`, every `C²` test function `ξ` supported in `{ρ : |log ρ| ≤ 1/30}` satisfies
`W_∞(Q(ξ ∗ ξ*)) ≥ (2/15)‖ξ‖²`.  This is `small_support_Winfty_ge` with the explicit
constant `a = 1/30`; as there, the positivity of `L` is an explicit hypothesis, not a
proved statement. -/
theorem Winfty_ge_effective (hL : LPositivity) {F : ℝ → ℂ} (hF : ContDiff ℝ 2 F)
    (hsupp : SupportedIn (1 / 30) F) :
    (2 / 15) * L2sq F ≤ (Winfty (ofLog (Qlog (convLog F (starLog F))))).re := by
  have hsF : HasCompactSupport F := hasCompactSupport_of_supportedIn hsupp
  have hconv : ContDiff ℝ 2 (convLog F (starLog F)) := contDiff_convLog_starLog_self hF hsF
  have hsconv : HasCompactSupport (convLog F (starLog F)) :=
    hasCompactSupport_convLog hsF (hasCompactSupport_starLog hsF)
  have hcont : Continuous (Qlog (convLog F (starLog F))) := continuous_Qlog hconv
  have hscomp : HasCompactSupport (Qlog (convLog F (starLog F))) := hasCompactSupport_Qlog hsconv
  have hpd : PositiveDefiniteLog (Qlog (convLog F (starLog F))) :=
    positiveDefiniteLog_Qlog hconv hsconv (positiveDefiniteLog_convLog_starLog hF.continuous hsF)
  have h2 : 0 ≤ L_real (ofLog (Qlog (convLog F (starLog F)))) := hL _ hcont hscomp hpd
  rw [L_real_eq] at h2
  have h1 := Dcomplex_Qlog_convLog_effective hF hsupp
  linarith

/-- **Corollary 3.8 in the multiplicative language, effective form.**  Every test function
`ξ` on `ℝ⋆₊` supported in `[u⁻¹, u]`, `u = e^{1/30}`, satisfies
`D(Q(ξ ∗ ξ*)) ≤ -(2/15) ‖ξ‖²`, all integrals being taken against `d*ρ`. -/
theorem DQ_effective_mul {f : Rplus → ℂ}
    (hf : ContDiff ℝ 2 (fun t => f (Rplus.expHomeo t)))
    (hsupp : ∀ ρ : Rplus, 1 / 30 < |Real.log (ρ : ℝ)| → f ρ = 0) :
    (∫ ρ : Rplus, Qlog (convLog (fun t => f (Rplus.expHomeo t))
          (starLog (fun t => f (Rplus.expHomeo t)))) (Real.log (ρ : ℝ)) * ((delta ρ : ℝ) : ℂ)
        ∂(Rplus.haar)).re
      ≤ -(2 / 15) * ∫ ρ : Rplus, ‖f ρ‖ ^ 2 ∂(Rplus.haar) := by
  have hkey := Dcomplex_Qlog_convLog_effective hf (supportedIn_comp_expHomeo hsupp)
  rwa [Dcomplex_ofLog_haar, L2sq_haar] at hkey

end ConnesConsani.WeilPositivity
