/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Minimal trace-class groundwork on a complex Hilbert space, as needed for the operator side
of arXiv:2006.13771 (Connes–Consani, *Weil positivity and Trace formula – the archimedean
place*), where the functional `L` is to be written as

  `L(f) = Tr(ϑ(f) P P̂ P)`.

Mathlib (at the version pinned by this project) has no notion of trace-class operator, so
the language is developed here from scratch, in the elementary form which suffices for the
positivity argument:

* `hsNormSq b T = ∑ᵢ ‖T bᵢ‖²`, the Hilbert–Schmidt norm squared along a Hilbert basis `b`,
  with values in `ℝ≥0∞`;
* `hsNormSq_adjoint`, `hsNormSq_basis_indep`: it is unchanged when passing to the adjoint
  and **does not depend on the chosen Hilbert basis**;
* `IsHilbertSchmidt`, `IsTraceClass`: the corresponding predicates, the latter defined (as
  usual) by factoring the operator as a product of two Hilbert–Schmidt operators;
* `traceAlong b T = ∑ᵢ ⟪bᵢ, T bᵢ⟫` and its real part `traceAlongRe`, together with
  - absolute convergence of the defining series for a trace-class operator
    (`summable_norm_inner_of_isTraceClass`),
  - the positivity `0 ≤ traceAlongRe b T` for a positive operator `T`, and its conjugated
    form `0 ≤ traceAlongRe b (B† A B)` for `A` positive, which is the mechanism behind the
    positivity of `f ↦ Tr(ϑ(f) P P̂ P)` on convolution squares `f = g ∗ g*`.

What is deliberately *not* proved here is the basis-independence of `traceAlong` itself on
trace-class operators, and the trace property `Tr(AB) = Tr(BA)`; see the status section of
`RequestProject/Skeleton.lean` for the list of remaining steps.
-/
import Mathlib

set_option maxHeartbeats 1000000

noncomputable section

open scoped ENNReal NNReal

open ContinuousLinearMap RCLike

namespace ConnesConsani.WeilPositivity

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℂ E]
variable {ι κ : Type*}

/-! ## Parseval's identity -/

/-- Parseval's identity along a Hilbert basis. -/
theorem tsum_norm_sq_inner (b : HilbertBasis ι ℂ E) (x : E) :
    ∑' i, ‖inner ℂ (b i) x‖ ^ 2 = ‖x‖ ^ 2 := by
  have h := b.repr.norm_map x
  have h2 := lp.norm_rpow_eq_tsum (p := 2) (by norm_num) (b.repr x)
  simp only [ENNReal.toReal_ofNat, b.repr_apply_apply] at h2
  rw [← h]
  exact_mod_cast h2.symm

/-- The Fourier coefficients of a vector are square summable. -/
theorem summable_norm_sq_inner (b : HilbertBasis ι ℂ E) (x : E) :
    Summable fun i => ‖inner ℂ (b i) x‖ ^ 2 := by
  have h := lp.hasSum_norm (p := 2) (E := fun _ : ι => ℂ) (by norm_num) (b.repr x)
  simp only [b.repr_apply_apply, ENNReal.toReal_ofNat] at h
  exact_mod_cast h.summable

/-- Parseval's identity, in `ℝ≥0∞` (no summability side condition). -/
theorem tsum_enorm_sq_inner (b : HilbertBasis ι ℂ E) (x : E) :
    ∑' i, ((‖inner ℂ (b i) x‖₊ : ℝ≥0∞)) ^ 2 = ((‖x‖₊ : ℝ≥0∞)) ^ 2 := by
  have hr : HasSum (fun i => ‖inner ℂ (b i) x‖ ^ 2) (‖x‖ ^ 2) := by
    rw [← tsum_norm_sq_inner b x]
    exact (summable_norm_sq_inner b x).hasSum
  have hnn : HasSum (fun i => ‖inner ℂ (b i) x‖₊ ^ 2) (‖x‖₊ ^ 2) := by
    rw [← NNReal.hasSum_coe]
    push_cast
    exact hr
  have hcoe : ∀ i : ι, ((‖inner ℂ (b i) x‖₊ : ℝ≥0∞)) ^ 2
      = ((‖inner ℂ (b i) x‖₊ ^ 2 : ℝ≥0) : ℝ≥0∞) := by
    intro i; push_cast; ring
  simp only [hcoe]
  rw [← ENNReal.coe_tsum hnn.summable, hnn.tsum_eq]
  push_cast
  ring

/-! ## The Hilbert–Schmidt norm along a Hilbert basis -/

/-- The square of the Hilbert–Schmidt norm of `T` computed in the Hilbert basis `b`,
`∑ᵢ ‖T bᵢ‖²`, with values in `ℝ≥0∞`. -/
def hsNormSq (b : HilbertBasis ι ℂ E) (T : E →L[ℂ] E) : ℝ≥0∞ :=
  ∑' i, ((‖T (b i)‖₊ : ℝ≥0∞)) ^ 2

section Adjoint

variable [CompleteSpace E]

/-- The Hilbert–Schmidt norm of `T` in the basis `b` equals that of `T†` in any basis `c`. -/
theorem hsNormSq_adjoint (b : HilbertBasis ι ℂ E) (c : HilbertBasis κ ℂ E) (T : E →L[ℂ] E) :
    hsNormSq b T = hsNormSq c (ContinuousLinearMap.adjoint T) := by
  have h1 : hsNormSq b T = ∑' i, ∑' j, ((‖inner ℂ (c j) (T (b i))‖₊ : ℝ≥0∞)) ^ 2 :=
    tsum_congr fun i => (tsum_enorm_sq_inner c (T (b i))).symm
  have h2 : hsNormSq c (ContinuousLinearMap.adjoint T)
      = ∑' j, ∑' i, ((‖inner ℂ (b i) (ContinuousLinearMap.adjoint T (c j))‖₊ : ℝ≥0∞)) ^ 2 :=
    tsum_congr fun j => (tsum_enorm_sq_inner b _).symm
  rw [h1, h2, ENNReal.tsum_comm]
  refine tsum_congr fun j => tsum_congr fun i => ?_
  congr 2
  rw [← ContinuousLinearMap.adjoint_inner_left]
  exact NNReal.coe_injective (by
    simpa using norm_inner_symm (𝕜 := ℂ) (ContinuousLinearMap.adjoint T (c j)) (b i))

/-- **The Hilbert–Schmidt norm does not depend on the chosen Hilbert basis.** -/
theorem hsNormSq_basis_indep (b : HilbertBasis ι ℂ E) (c : HilbertBasis κ ℂ E) (T : E →L[ℂ] E) :
    hsNormSq b T = hsNormSq c T := by
  rw [hsNormSq_adjoint b c T, hsNormSq_adjoint c c (ContinuousLinearMap.adjoint T),
    ContinuousLinearMap.adjoint_adjoint]

/-- `T` is a Hilbert–Schmidt operator (the condition is basis independent by
`hsNormSq_basis_indep`). -/
def IsHilbertSchmidt (b : HilbertBasis ι ℂ E) (T : E →L[ℂ] E) : Prop := hsNormSq b T ≠ ⊤

theorem isHilbertSchmidt_basis_indep (b : HilbertBasis ι ℂ E) (c : HilbertBasis κ ℂ E)
    (T : E →L[ℂ] E) : IsHilbertSchmidt b T ↔ IsHilbertSchmidt c T := by
  simp only [IsHilbertSchmidt, hsNormSq_basis_indep b c T]

theorem IsHilbertSchmidt.adjoint {b : HilbertBasis ι ℂ E} {T : E →L[ℂ] E}
    (hT : IsHilbertSchmidt b T) : IsHilbertSchmidt b (ContinuousLinearMap.adjoint T) := by
  rwa [IsHilbertSchmidt, ← hsNormSq_adjoint b b T]

end Adjoint

/-- A Hilbert–Schmidt operator has square summable "column norms". -/
theorem IsHilbertSchmidt.summable_norm_sq {b : HilbertBasis ι ℂ E} {T : E →L[ℂ] E}
    (hT : IsHilbertSchmidt b T) : Summable fun i => ‖T (b i)‖ ^ 2 := by
  have hcoe : ∀ i : ι, ((‖T (b i)‖₊ : ℝ≥0∞)) ^ 2 = ((‖T (b i)‖₊ ^ 2 : ℝ≥0) : ℝ≥0∞) := by
    intro i; push_cast; ring
  have h : ∑' i, ((‖T (b i)‖₊ ^ 2 : ℝ≥0) : ℝ≥0∞) ≠ ⊤ := by
    simpa only [hsNormSq, hcoe] using hT
  have hs : Summable fun i => ‖T (b i)‖₊ ^ 2 := ENNReal.tsum_coe_ne_top_iff_summable.1 h
  rw [← NNReal.summable_coe] at hs
  simpa using hs

/-! ## Trace-class operators -/

/-- `T` is trace class if it factors as a product of two Hilbert–Schmidt operators. -/
def IsTraceClass (b : HilbertBasis ι ℂ E) (T : E →L[ℂ] E) : Prop :=
  ∃ A B : E →L[ℂ] E, IsHilbertSchmidt b A ∧ IsHilbertSchmidt b B ∧ T = A ∘L B

theorem IsTraceClass.of_hilbertSchmidt_comp {b : HilbertBasis ι ℂ E} {A B : E →L[ℂ] E}
    (hA : IsHilbertSchmidt b A) (hB : IsHilbertSchmidt b B) : IsTraceClass b (A ∘L B) :=
  ⟨A, B, hA, hB, rfl⟩

/-! ## The trace along a Hilbert basis -/

/-- The trace of `T` computed in the Hilbert basis `b`, `∑ᵢ ⟪bᵢ, T bᵢ⟫`.  (The value is `0`
by convention when the series does not converge.) -/
def traceAlong (b : HilbertBasis ι ℂ E) (T : E →L[ℂ] E) : ℂ := ∑' i, inner ℂ (b i) (T (b i))

/-- The real part of the trace of `T` computed in the Hilbert basis `b`. -/
def traceAlongRe (b : HilbertBasis ι ℂ E) (T : E →L[ℂ] E) : ℝ :=
  ∑' i, re (inner ℂ (b i) (T (b i)))

@[simp] theorem traceAlong_zero (b : HilbertBasis ι ℂ E) : traceAlong b (0 : E →L[ℂ] E) = 0 := by
  simp [traceAlong]

@[simp] theorem traceAlongRe_zero (b : HilbertBasis ι ℂ E) :
    traceAlongRe b (0 : E →L[ℂ] E) = 0 := by
  simp [traceAlongRe]

/-! ## Positivity of the diagonal matrix elements -/

/-- Each diagonal matrix element of a positive operator is nonnegative. -/
theorem re_inner_nonneg_of_isPositive {T : E →L[ℂ] E} (hT : T.IsPositive) (x : E) :
    0 ≤ re (inner ℂ x (T x)) := hT.re_inner_nonneg_right x

/-- **The trace of a positive operator is nonnegative** (in any Hilbert basis, and with the
convention that a divergent series has trace `0`). -/
theorem traceAlongRe_nonneg (b : HilbertBasis ι ℂ E) {T : E →L[ℂ] E} (hT : T.IsPositive) :
    0 ≤ traceAlongRe b T :=
  tsum_nonneg fun i => re_inner_nonneg_of_isPositive hT (b i)

section CompleteTrace

variable [CompleteSpace E]

/-- For a product of two Hilbert–Schmidt operators the defining series of the trace is
**absolutely convergent** (in any Hilbert basis). -/
theorem summable_norm_inner_of_hilbertSchmidt {b : HilbertBasis ι ℂ E} {A B : E →L[ℂ] E}
    (hA : IsHilbertSchmidt b A) (hB : IsHilbertSchmidt b B) :
    Summable fun i => ‖inner ℂ (b i) ((A ∘L B) (b i))‖ := by
  have hAadj : Summable fun i => ‖(ContinuousLinearMap.adjoint A) (b i)‖ ^ 2 :=
    hA.adjoint.summable_norm_sq
  have hBs : Summable fun i => ‖B (b i)‖ ^ 2 := hB.summable_norm_sq
  have hbound : ∀ i : ι, ‖inner ℂ (b i) ((A ∘L B) (b i))‖
      ≤ (‖(ContinuousLinearMap.adjoint A) (b i)‖ ^ 2 + ‖B (b i)‖ ^ 2) / 2 := by
    intro i
    have h1 : inner ℂ (b i) ((A ∘L B) (b i))
        = inner ℂ ((ContinuousLinearMap.adjoint A) (b i)) (B (b i)) := by
      rw [ContinuousLinearMap.adjoint_inner_left]
      rfl
    rw [h1]
    refine (norm_inner_le_norm _ _).trans ?_
    nlinarith [sq_nonneg (‖(ContinuousLinearMap.adjoint A) (b i)‖ - ‖B (b i)‖),
      norm_nonneg ((ContinuousLinearMap.adjoint A) (b i)), norm_nonneg (B (b i))]
  refine Summable.of_nonneg_of_le (fun i => norm_nonneg _) hbound ?_
  exact ((hAadj.add hBs).div_const 2)

/-- Absolute convergence of the trace series of a trace-class operator. -/
theorem summable_norm_inner_of_isTraceClass {b : HilbertBasis ι ℂ E} {T : E →L[ℂ] E}
    (hT : IsTraceClass b T) : Summable fun i => ‖inner ℂ (b i) (T (b i))‖ := by
  obtain ⟨A, B, hA, hB, rfl⟩ := hT
  exact summable_norm_inner_of_hilbertSchmidt hA hB

/-! ## Positivity of the trace -/

/-- **The conjugated form of the positivity of the trace**: for `A` positive and `B`
arbitrary, `Tr(B† A B) ≥ 0`.  With `B = ϑ(g)` and `A = P P̂ P` this is the mechanism giving
the positivity of `f ↦ Tr(ϑ(f) P P̂ P)` on convolution squares `f = g ∗ g*`. -/
theorem traceAlongRe_conj_nonneg (b : HilbertBasis ι ℂ E) {A : E →L[ℂ] E} (hA : A.IsPositive)
    (B : E →L[ℂ] E) :
    0 ≤ traceAlongRe b (ContinuousLinearMap.adjoint B ∘L A ∘L B) :=
  traceAlongRe_nonneg b (hA.adjoint_conj B)

/-- The trace of a positive operator, computed along a basis, is a nonnegative real
number; in particular the complex trace `traceAlong` coincides with `traceAlongRe`. -/
theorem traceAlong_eq_traceAlongRe (b : HilbertBasis ι ℂ E) {T : E →L[ℂ] E} (hT : T.IsPositive) :
    traceAlong b T = (traceAlongRe b T : ℂ) := by
  have hreal : ∀ i : ι, inner ℂ (b i) (T (b i)) = ((re (inner ℂ (b i) (T (b i))) : ℝ) : ℂ) := by
    intro i
    have hconj : (starRingEnd ℂ) (inner ℂ (b i) (T (b i))) = inner ℂ (b i) (T (b i)) := by
      rw [inner_conj_symm]
      exact hT.isSelfAdjoint.isSymmetric (b i) (b i)
    exact (Complex.conj_eq_iff_re.1 hconj).symm
  rw [traceAlong, traceAlongRe, Complex.ofReal_tsum]
  exact tsum_congr hreal

end CompleteTrace

end ConnesConsani.WeilPositivity
