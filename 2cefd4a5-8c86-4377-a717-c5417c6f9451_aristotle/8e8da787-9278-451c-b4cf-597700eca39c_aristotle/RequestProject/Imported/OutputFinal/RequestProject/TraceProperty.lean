/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The trace property `Tr(AB) = Tr(BA)` for Hilbert–Schmidt operators, continuing the
trace-class groundwork of `RequestProject/TraceClass.lean` needed for the operator side of
arXiv:2006.13771 (Connes–Consani, *Weil positivity and Trace formula – the archimedean
place*).

The proof is the classical double-sum computation: with `f(i,j) = ⟪bᵢ, A bⱼ⟫ ⟪bⱼ, B bᵢ⟫`
one has `Tr(AB) = ∑ᵢ ∑ⱼ f(i,j)` and `Tr(BA) = ∑ⱼ ∑ᵢ f(i,j)`, and the double family is
absolutely summable because `A` and `B` are Hilbert–Schmidt.
-/
import RequestProject.Imported.OutputFinal.RequestProject.TraceClass

set_option maxHeartbeats 1000000

noncomputable section

open scoped ENNReal NNReal

open ContinuousLinearMap RCLike

namespace ConnesConsani.WeilPositivity

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℂ E] [CompleteSpace E]
variable {ι : Type*}

omit [CompleteSpace E] in
/-- For a Hilbert–Schmidt operator the matrix coefficients `⟪bᵢ, A bⱼ⟫` are square summable
over the *pair* of indices. -/
theorem summable_sq_matrix {b : HilbertBasis ι ℂ E} {A : E →L[ℂ] E} (hA : IsHilbertSchmidt b A) :
    Summable fun p : ι × ι => ‖inner ℂ (b p.2) (A (b p.1))‖ ^ 2 := by
  rw [summable_prod_of_nonneg (fun _ => sq_nonneg _)]
  refine ⟨fun j => summable_norm_sq_inner b (A (b j)), ?_⟩
  refine (hA.summable_norm_sq).congr fun j => ?_
  exact (tsum_norm_sq_inner b (A (b j))).symm

omit [CompleteSpace E] in
/-- The double family defining the trace of a product of two Hilbert–Schmidt operators is
absolutely summable. -/
theorem summable_matrix_prod {b : HilbertBasis ι ℂ E} {A B : E →L[ℂ] E}
    (hA : IsHilbertSchmidt b A) (hB : IsHilbertSchmidt b B) :
    Summable fun p : ι × ι => inner ℂ (b p.1) (A (b p.2)) * inner ℂ (b p.2) (B (b p.1)) := by
  have hAsq : Summable fun p : ι × ι => ‖inner ℂ (b p.1) (A (b p.2))‖ ^ 2 :=
    (summable_sq_matrix hA).prod_symm
  have hBsq : Summable fun p : ι × ι => ‖inner ℂ (b p.2) (B (b p.1))‖ ^ 2 :=
    summable_sq_matrix hB
  refine Summable.of_norm_bounded ((hAsq.add hBsq).div_const 2) fun p => ?_
  rw [norm_mul]
  nlinarith [sq_nonneg (‖inner ℂ (b p.1) (A (b p.2))‖ - ‖inner ℂ (b p.2) (B (b p.1))‖),
    norm_nonneg (inner ℂ (b p.1) (A (b p.2)) : ℂ), norm_nonneg (inner ℂ (b p.2) (B (b p.1)) : ℂ)]

/-- The diagonal matrix elements of a product, expanded in the basis. -/
theorem inner_comp_eq_tsum (b : HilbertBasis ι ℂ E) (A B : E →L[ℂ] E) (i : ι) :
    inner ℂ (b i) ((A ∘L B) (b i))
      = ∑' j, inner ℂ (b i) (A (b j)) * inner ℂ (b j) (B (b i)) := by
  have h : inner ℂ (b i) ((A ∘L B) (b i))
      = inner ℂ ((ContinuousLinearMap.adjoint A) (b i)) (B (b i)) := by
    rw [ContinuousLinearMap.adjoint_inner_left]
    rfl
  rw [h, ← b.tsum_inner_mul_inner ((ContinuousLinearMap.adjoint A) (b i)) (B (b i))]
  exact tsum_congr fun j => by rw [ContinuousLinearMap.adjoint_inner_left]

/-- **The trace property** `Tr(AB) = Tr(BA)` for Hilbert–Schmidt operators, along any
Hilbert basis. -/
theorem traceAlong_comm {b : HilbertBasis ι ℂ E} {A B : E →L[ℂ] E}
    (hA : IsHilbertSchmidt b A) (hB : IsHilbertSchmidt b B) :
    traceAlong b (A ∘L B) = traceAlong b (B ∘L A) := by
  set f : ι × ι → ℂ :=
    fun p => inner ℂ (b p.1) (A (b p.2)) * inner ℂ (b p.2) (B (b p.1)) with hf
  have hsum : Summable f := summable_matrix_prod hA hB
  have h1 : traceAlong b (A ∘L B) = ∑' i, ∑' j, f (i, j) := by
    rw [traceAlong]
    exact tsum_congr fun i => inner_comp_eq_tsum b A B i
  have h2 : traceAlong b (B ∘L A) = ∑' j, ∑' i, f (i, j) := by
    rw [traceAlong]
    refine tsum_congr fun j => ?_
    rw [inner_comp_eq_tsum b B A j]
    exact tsum_congr fun i => mul_comm _ _
  have hswap : ∑' p : ι × ι, f p.swap = ∑' j, ∑' i, f (i, j) := (hsum.prod_symm).tsum_prod
  rw [h1, h2, ← hsum.tsum_prod, ← hswap]
  exact ((Equiv.prodComm ι ι).tsum_eq f).symm

end ConnesConsani.WeilPositivity
