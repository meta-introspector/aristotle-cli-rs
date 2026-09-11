/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Basis independence of the trace on trace-class operators, completing the trace-class
groundwork of `RequestProject/TraceClass.lean` and `RequestProject/TraceProperty.lean`
needed for the operator side of arXiv:2006.13771 (Connes–Consani, *Weil positivity and
Trace formula – the archimedean place*).

The argument runs through the Hilbert–Schmidt pairing `⟪A, B⟫_HS = ∑ᵢ ⟪A bᵢ, B bᵢ⟫`: the
double-sum computation (Parseval in a second basis `c`, then Fubini, which is legitimate
because the double family is absolutely summable) gives

  `⟪A, B⟫_HS(b) = ⟪B*, A*⟫_HS(c)`,

and applying this twice shows that the pairing does not depend on the basis.  Since
`Tr(A B) = ⟪A*, B⟫_HS`, the trace of a product of two Hilbert–Schmidt operators — that is,
of a trace-class operator — is basis independent.
-/
import RequestProject.Imported.OutputFinal.RequestProject.TraceProperty

set_option maxHeartbeats 1000000

noncomputable section

open scoped ENNReal NNReal

open ContinuousLinearMap RCLike

namespace ConnesConsani.WeilPositivity

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℂ E] [CompleteSpace E]
variable {ι κ : Type*}

omit [CompleteSpace E] in
/-- Two-basis version of `summable_sq_matrix`: the matrix of `A` in the pair of bases
`(b, c)` is square summable over the pair of indices. -/
theorem summable_sq_matrix_two {b : HilbertBasis ι ℂ E} (c : HilbertBasis κ ℂ E)
    {A : E →L[ℂ] E} (hA : IsHilbertSchmidt b A) :
    Summable fun p : ι × κ => ‖inner ℂ (c p.2) (A (b p.1))‖ ^ 2 := by
  rw [summable_prod_of_nonneg (fun _ => sq_nonneg _)]
  refine ⟨fun i => summable_norm_sq_inner c (A (b i)), ?_⟩
  refine (hA.summable_norm_sq).congr fun i => ?_
  exact (tsum_norm_sq_inner c (A (b i))).symm

/-- The Hilbert–Schmidt pairing `⟪A, B⟫_HS = ∑ᵢ ⟪A bᵢ, B bᵢ⟫`, computed in the basis `b`. -/
def hsInner (b : HilbertBasis ι ℂ E) (A B : E →L[ℂ] E) : ℂ := ∑' i, inner ℂ (A (b i)) (B (b i))

omit [CompleteSpace E] in
/-- The double family occurring in the two-basis expansion of the Hilbert–Schmidt pairing
is absolutely summable. -/
theorem summable_hsInner_matrix {b : HilbertBasis ι ℂ E} (c : HilbertBasis κ ℂ E)
    {A B : E →L[ℂ] E} (hA : IsHilbertSchmidt b A) (hB : IsHilbertSchmidt b B) :
    Summable fun p : ι × κ =>
      inner ℂ (A (b p.1)) (c p.2) * inner ℂ (c p.2) (B (b p.1)) := by
  have hAsq : Summable fun p : ι × κ => ‖inner ℂ (A (b p.1)) (c p.2)‖ ^ 2 := by
    refine (summable_sq_matrix_two c hA).congr fun p => ?_
    rw [norm_inner_symm]
  have hBsq : Summable fun p : ι × κ => ‖inner ℂ (c p.2) (B (b p.1))‖ ^ 2 :=
    summable_sq_matrix_two c hB
  refine Summable.of_norm_bounded ((hAsq.add hBsq).div_const 2) fun p => ?_
  rw [norm_mul]
  nlinarith [sq_nonneg (‖inner ℂ (A (b p.1)) (c p.2)‖ - ‖inner ℂ (c p.2) (B (b p.1))‖),
    norm_nonneg (inner ℂ (A (b p.1)) (c p.2) : ℂ),
    norm_nonneg (inner ℂ (c p.2) (B (b p.1)) : ℂ)]

/-- **The two-basis identity for the Hilbert–Schmidt pairing**:
`⟪A, B⟫_HS` computed in `b` equals `⟪B*, A*⟫_HS` computed in `c`. -/
theorem hsInner_eq_hsInner_adjoint (b : HilbertBasis ι ℂ E) (c : HilbertBasis κ ℂ E)
    {A B : E →L[ℂ] E} (hA : IsHilbertSchmidt b A) (hB : IsHilbertSchmidt b B) :
    hsInner b A B
      = hsInner c (ContinuousLinearMap.adjoint B) (ContinuousLinearMap.adjoint A) := by
  set g : ι × κ → ℂ :=
    fun p => inner ℂ (A (b p.1)) (c p.2) * inner ℂ (c p.2) (B (b p.1)) with hg
  have hsum : Summable g := summable_hsInner_matrix c hA hB
  have h1 : hsInner b A B = ∑' i, ∑' j, g (i, j) := by
    rw [hsInner]
    exact tsum_congr fun i => (c.tsum_inner_mul_inner (A (b i)) (B (b i))).symm
  have h2 : hsInner c (ContinuousLinearMap.adjoint B) (ContinuousLinearMap.adjoint A)
      = ∑' j, ∑' i, g (i, j) := by
    rw [hsInner]
    refine tsum_congr fun j => ?_
    rw [← b.tsum_inner_mul_inner ((ContinuousLinearMap.adjoint B) (c j))
      ((ContinuousLinearMap.adjoint A) (c j))]
    refine tsum_congr fun i => ?_
    rw [ContinuousLinearMap.adjoint_inner_left, ContinuousLinearMap.adjoint_inner_right,
      hg]
    exact mul_comm _ _
  have hswap : ∑' p : κ × ι, g p.swap = ∑' j, ∑' i, g (i, j) := (hsum.prod_symm).tsum_prod
  rw [h1, h2, ← hsum.tsum_prod, ← hswap]
  exact ((Equiv.prodComm κ ι).tsum_eq g).symm

/-- **The Hilbert–Schmidt pairing does not depend on the chosen Hilbert basis.** -/
theorem hsInner_basis_indep (b : HilbertBasis ι ℂ E) (c : HilbertBasis κ ℂ E)
    {A B : E →L[ℂ] E} (hA : IsHilbertSchmidt b A) (hB : IsHilbertSchmidt b B) :
    hsInner b A B = hsInner c A B := by
  have hA' : IsHilbertSchmidt c A := (isHilbertSchmidt_basis_indep b c A).1 hA
  have hB' : IsHilbertSchmidt c B := (isHilbertSchmidt_basis_indep b c B).1 hB
  rw [hsInner_eq_hsInner_adjoint b c hA hB,
    hsInner_eq_hsInner_adjoint c c hB'.adjoint hA'.adjoint,
    ContinuousLinearMap.adjoint_adjoint, ContinuousLinearMap.adjoint_adjoint]

/-- The trace of a product is the Hilbert–Schmidt pairing of the adjoint of the first
factor with the second. -/
theorem traceAlong_comp_eq_hsInner (b : HilbertBasis ι ℂ E) (A B : E →L[ℂ] E) :
    traceAlong b (A ∘L B) = hsInner b (ContinuousLinearMap.adjoint A) B := by
  refine tsum_congr fun i => ?_
  rw [ContinuousLinearMap.adjoint_inner_left]
  rfl

/-- **The trace of a product of two Hilbert–Schmidt operators does not depend on the
chosen Hilbert basis**; in particular the trace is well defined on trace-class
operators. -/
theorem traceAlong_comp_basis_indep (b : HilbertBasis ι ℂ E) (c : HilbertBasis κ ℂ E)
    {A B : E →L[ℂ] E} (hA : IsHilbertSchmidt b A) (hB : IsHilbertSchmidt b B) :
    traceAlong b (A ∘L B) = traceAlong c (A ∘L B) := by
  rw [traceAlong_comp_eq_hsInner, traceAlong_comp_eq_hsInner]
  exact hsInner_basis_indep b c hA.adjoint hB

/-- Being trace class does not depend on the chosen Hilbert basis. -/
theorem isTraceClass_basis_indep (b : HilbertBasis ι ℂ E) (c : HilbertBasis κ ℂ E)
    (T : E →L[ℂ] E) : IsTraceClass b T ↔ IsTraceClass c T := by
  constructor <;> rintro ⟨A, B, hA, hB, rfl⟩
  · exact ⟨A, B, (isHilbertSchmidt_basis_indep b c A).1 hA,
      (isHilbertSchmidt_basis_indep b c B).1 hB, rfl⟩
  · exact ⟨A, B, (isHilbertSchmidt_basis_indep c b A).1 hA,
      (isHilbertSchmidt_basis_indep c b B).1 hB, rfl⟩

/-- **The trace of a trace-class operator is basis independent.** -/
theorem traceAlong_basis_indep_of_isTraceClass (b : HilbertBasis ι ℂ E)
    (c : HilbertBasis κ ℂ E) {T : E →L[ℂ] E} (hT : IsTraceClass b T) :
    traceAlong b T = traceAlong c T := by
  obtain ⟨A, B, hA, hB, rfl⟩ := hT
  exact traceAlong_comp_basis_indep b c hA hB

end ConnesConsani.WeilPositivity
