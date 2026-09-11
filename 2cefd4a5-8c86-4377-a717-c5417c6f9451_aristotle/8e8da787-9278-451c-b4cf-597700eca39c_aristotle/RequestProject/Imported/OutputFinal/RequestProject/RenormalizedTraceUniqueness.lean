/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Uniqueness and asymptotics for the renormalized cut-off trace.

`RequestProject/RenormalizedTrace.lean` introduces the trace at a finite cut-off scale

  `cutTrace b U Λ f = Tr(ϑ(f) S^{(Λ)})`,   `S^{(Λ)} = P^{(Λ)} P̂^{(Λ)} P^{(Λ)}`,

the logarithmic counter-term `c(f) = 2 f(1)` and the finite part

  `HasRenormalizedTrace b U f z  ↔  Tr_Λ(ϑ(f) S^{(Λ)}) - c(f) log Λ → z`.

This file records the two structural facts that make that definition canonical.

* **The counter-term is unique.**  If the subtraction of *some* multiple `c log Λ` of the
  logarithm produces a finite limit, then both the coefficient `c` and the limit are
  determined by the family `Λ ↦ Tr_Λ(ϑ(f) S^{(Λ)})`
  (`HasRenormalizedTraceWith.coeff_unique`).  In particular no coefficient other than
  `2 f(1)` can be used once the renormalized trace is known to exist, and the finite part
  of `RenormalizedTrace.lean` is not an artefact of the chosen normalisation.

* **The divergence rate is read off from the counter-term.**  If the renormalized trace of
  `f` exists then `Tr_Λ(ϑ(f) S^{(Λ)}) / log Λ → 2 f(1)`
  (`tendsto_cutTrace_div_log`), and on a convolution square the rate is
  `2‖g‖²_{L²(ℝ⋆₊, d*λ)}` (`tendsto_cutTrace_convSquare_div_log`).  So the existence of the
  finite part is a genuinely quantitative statement about the growth of the cut-off traces,
  and it is *incompatible* with convergence of the unrenormalized traces whenever
  `f(1) ≠ 0` (`not_tendsto_cutTrace_of_apply_one_ne_zero`).

Nothing here assumes the (unproved) renormalized trace identity: these are statements about
the cut-off family itself.
-/
import RequestProject.Imported.OutputFinal.RequestProject.RenormalizedTrace

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory Filter Topology

open scoped CompactlySupported

namespace ConnesConsani.WeilPositivity

variable {ι : Type*}

/-! ## A general uniqueness lemma for logarithmic subtractions -/

/-- If subtracting `a log x` and subtracting `a' log x` from the same family both produce a
finite limit, then `a = a'` and the two limits agree.  (The logarithm is unbounded, so no
two distinct multiples of it differ by a convergent function.) -/
theorem coeff_and_limit_unique_of_tendsto_sub_log {F : ℝ → ℂ} {a a' z z' : ℂ}
    (h : Tendsto (fun x : ℝ => F x - a * (Real.log x : ℂ)) atTop (𝓝 z))
    (h' : Tendsto (fun x : ℝ => F x - a' * (Real.log x : ℂ)) atTop (𝓝 z')) :
    a = a' ∧ z = z' := by
  have hd : Tendsto (fun x : ℝ => (a' - a) * (Real.log x : ℂ)) atTop (𝓝 (z - z')) := by
    refine (h.sub h').congr fun x => ?_
    ring
  have ha : a = a' := by
    by_contra hne
    have hpos : 0 < ‖a' - a‖ := norm_pos_iff.mpr (sub_ne_zero.mpr (Ne.symm hne))
    have habs : Tendsto (fun x : ℝ => |Real.log x|) atTop atTop :=
      tendsto_abs_atTop_atTop.comp Real.tendsto_log_atTop
    have hbig : Tendsto (fun x : ℝ => ‖a' - a‖ * |Real.log x|) atTop atTop :=
      Filter.Tendsto.const_mul_atTop hpos habs
    have hfin : Tendsto (fun x : ℝ => ‖a' - a‖ * |Real.log x|) atTop (𝓝 ‖z - z'‖) := by
      refine hd.norm.congr fun x => ?_
      simp [Complex.norm_real, Real.norm_eq_abs]
    exact not_tendsto_nhds_of_tendsto_atTop hbig _ hfin
  subst ha
  exact ⟨rfl, tendsto_nhds_unique h h'⟩

/-! ## The renormalized trace with an arbitrary counter-term coefficient -/

/-- `HasRenormalizedTraceWith b U c g z` : subtracting the counter-term `c log Λ` from the
cut-off traces of `g` produces the finite limit `z`.  The definition of
`RenormalizedTrace.lean` is the case `c = logCounterTerm g = 2 g 1`. -/
def HasRenormalizedTraceWith (b : HilbertBasis ι ℂ L2R) (U : L2Rplus ≃ₗᵢ[ℂ] L2R) (c : ℂ)
    (g : C_c(Rplus, ℂ)) (z : ℂ) : Prop :=
  Tendsto (fun lam : ℝ => cutTrace b U lam g - c * (Real.log lam : ℂ)) atTop (𝓝 z)

theorem hasRenormalizedTrace_iff_with (b : HilbertBasis ι ℂ L2R) (U : L2Rplus ≃ₗᵢ[ℂ] L2R)
    (g : C_c(Rplus, ℂ)) (z : ℂ) :
    HasRenormalizedTrace b U g z ↔ HasRenormalizedTraceWith b U (logCounterTerm g) g z :=
  Iff.rfl

/-- **The counter-term and the finite part are unique.** -/
theorem HasRenormalizedTraceWith.coeff_unique {b : HilbertBasis ι ℂ L2R}
    {U : L2Rplus ≃ₗᵢ[ℂ] L2R} {c c' : ℂ} {g : C_c(Rplus, ℂ)} {z z' : ℂ}
    (h : HasRenormalizedTraceWith b U c g z) (h' : HasRenormalizedTraceWith b U c' g z') :
    c = c' ∧ z = z' :=
  coeff_and_limit_unique_of_tendsto_sub_log h h'

/-- **No coefficient other than `2 g 1` can renormalize the cut-off traces** once the
renormalized trace of `RenormalizedTrace.lean` is known to exist. -/
theorem HasRenormalizedTraceWith.eq_logCounterTerm {b : HilbertBasis ι ℂ L2R}
    {U : L2Rplus ≃ₗᵢ[ℂ] L2R} {c : ℂ} {g : C_c(Rplus, ℂ)} {z w : ℂ}
    (h : HasRenormalizedTraceWith b U c g z) (hstd : HasRenormalizedTrace b U g w) :
    c = logCounterTerm g ∧ z = w :=
  h.coeff_unique ((hasRenormalizedTrace_iff_with b U g w).1 hstd)

/-! ## The divergence rate of the cut-off traces -/

/-- **The cut-off traces diverge at the rate prescribed by the counter-term**:
`Tr_Λ(ϑ(f) S^{(Λ)}) / log Λ → 2 f(1)`. -/
theorem tendsto_cutTrace_div_log {b : HilbertBasis ι ℂ L2R} {U : L2Rplus ≃ₗᵢ[ℂ] L2R}
    {g : C_c(Rplus, ℂ)} {z : ℂ} (h : HasRenormalizedTrace b U g z) :
    Tendsto (fun lam : ℝ => cutTrace b U lam g / (Real.log lam : ℂ)) atTop
      (𝓝 (2 * g 1)) := by
  have hinvR : Tendsto (fun lam : ℝ => (Real.log lam)⁻¹) atTop (𝓝 (0 : ℝ)) :=
    tendsto_inv_atTop_zero.comp Real.tendsto_log_atTop
  have hinv : Tendsto (fun lam : ℝ => ((Real.log lam : ℂ))⁻¹) atTop (𝓝 0) := by
    have := (Complex.continuous_ofReal.tendsto (0 : ℝ)).comp hinvR
    simpa [Function.comp_def, Complex.ofReal_inv] using this
  have hz : Tendsto (fun lam : ℝ =>
      (cutTrace b U lam g - logCounterTerm g * (Real.log lam : ℂ))
        * ((Real.log lam : ℂ))⁻¹) atTop (𝓝 (z * 0)) := h.mul hinv
  rw [mul_zero] at hz
  have hsum := hz.add (tendsto_const_nhds (x := logCounterTerm g) (f := (atTop : Filter ℝ)))
  rw [zero_add] at hsum
  refine hsum.congr' ?_ |>.congr fun _ => rfl
  filter_upwards [eventually_gt_atTop (1 : ℝ)] with x hx
  have hlog : (Real.log x : ℂ) ≠ 0 := by
    simpa using (Real.log_pos hx).ne'
  field_simp
  ring

/-- Specialization to a convolution square: the divergence rate is
`2‖g‖²_{L²(ℝ⋆₊, d*λ)}`. -/
theorem tendsto_cutTrace_convSquare_div_log {b : HilbertBasis ι ℂ L2R}
    {U : L2Rplus ≃ₗᵢ[ℂ] L2R} {g : C_c(Rplus, ℂ)} {z : ℂ}
    (h : HasRenormalizedTrace b U (testConv g (starTest g)) z) :
    Tendsto (fun lam : ℝ => cutTrace b U lam (testConv g (starTest g)) / (Real.log lam : ℂ))
      atTop (𝓝 (2 * ((∫ t, ‖g t‖ ^ 2 ∂(Rplus.haar) : ℝ) : ℂ))) := by
  have := tendsto_cutTrace_div_log h
  rwa [show (2 : ℂ) * (testConv g (starTest g)) 1
      = 2 * ((∫ t, ‖g t‖ ^ 2 ∂(Rplus.haar) : ℝ) : ℂ) from logCounterTerm_convSquare g] at this

/-- **The unrenormalized traces cannot converge** when `f(1) ≠ 0`: the subtraction of the
logarithmic counter-term is unavoidable. -/
theorem not_tendsto_cutTrace_of_apply_one_ne_zero {b : HilbertBasis ι ℂ L2R}
    {U : L2Rplus ≃ₗᵢ[ℂ] L2R} {g : C_c(Rplus, ℂ)} {z : ℂ}
    (h : HasRenormalizedTrace b U g z) (hg : g 1 ≠ 0) (w : ℂ) :
    ¬ Tendsto (fun lam : ℝ => cutTrace b U lam g) atTop (𝓝 w) := by
  intro hw
  have hw' : HasRenormalizedTraceWith b U 0 g w := by
    refine hw.congr fun lam => ?_
    simp
  have := (hw'.eq_logCounterTerm h).1
  rw [logCounterTerm] at this
  exact hg (by simpa using this.symm)

/-- On a convolution square the unrenormalized traces converge only for the null test
function: for `g ≠ 0` in `L²(ℝ⋆₊, d*λ)` the family `Λ ↦ Tr_Λ(ϑ(g ∗ g^♯) S^{(Λ)})` has no
finite limit. -/
theorem not_tendsto_cutTrace_convSquare {b : HilbertBasis ι ℂ L2R}
    {U : L2Rplus ≃ₗᵢ[ℂ] L2R} {g : C_c(Rplus, ℂ)} {z : ℂ}
    (h : HasRenormalizedTrace b U (testConv g (starTest g)) z)
    (hg : (∫ t, ‖g t‖ ^ 2 ∂(Rplus.haar)) ≠ 0) (w : ℂ) :
    ¬ Tendsto (fun lam : ℝ => cutTrace b U lam (testConv g (starTest g))) atTop (𝓝 w) := by
  refine not_tendsto_cutTrace_of_apply_one_ne_zero h ?_ w
  intro h0
  refine hg ?_
  have := logCounterTerm_convSquare g
  rw [logCounterTerm, h0, mul_zero] at this
  exact_mod_cast (by simpa using this.symm : ((∫ t, ‖g t‖ ^ 2 ∂(Rplus.haar) : ℝ) : ℂ) = 0)

end ConnesConsani.WeilPositivity
