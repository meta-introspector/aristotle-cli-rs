/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The positivity mechanism behind `L(f) = Tr(ϑ(f) P P̂ P) ≥ 0` for `f = g ∗ g^♯`, following
arXiv:2006.13771 (Connes–Consani, *Weil positivity and Trace formula – the archimedean
place*).

The functional `L` of the paper is the trace of `ϑ(f) P P̂ P`.  The operator `P P̂ P` is of
the form `B* B` with `B = P̂ P`, and `ϑ(g ∗ g^♯) = ϑ(g) ϑ(g)*` by
`RequestProject/TestConvolution.lean`.  The trace property of
`RequestProject/TraceProperty.lean` then gives

  `Tr((T T*) (B* B)) = Tr((B T) (B T)*) ≥ 0`,

which is the abstract statement proved here.  Combined with the (still missing) trace
identity `L(f) = Tr(ϑ(f) P P̂ P)`, this is exactly the positivity of `L` on convolution
squares.
-/
import RequestProject.Imported.OutputFinal.RequestProject.TestConvolution
import RequestProject.Imported.OutputFinal.RequestProject.TraceProperty

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open scoped ENNReal NNReal CompactlySupported

open ContinuousLinearMap

namespace ConnesConsani.WeilPositivity

variable {ι : Type*} {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℂ E]

/-! ## The Hilbert–Schmidt operators form a two-sided ideal -/

/-- Composing on the left with a bounded operator multiplies the Hilbert–Schmidt norm by
at most the operator norm. -/
theorem hsNormSq_comp_le (b : HilbertBasis ι ℂ E) (A T : E →L[ℂ] E) :
    hsNormSq b (A ∘L T) ≤ ((‖A‖₊ : ℝ≥0∞)) ^ 2 * hsNormSq b T := by
  rw [hsNormSq, hsNormSq, ← ENNReal.tsum_mul_left]
  refine ENNReal.tsum_le_tsum fun i => ?_
  have h : ‖A (T (b i))‖₊ ≤ ‖A‖₊ * ‖T (b i)‖₊ := A.le_opNNNorm _
  calc ((‖(A ∘L T) (b i)‖₊ : ℝ≥0∞)) ^ 2
      ≤ ((‖A‖₊ * ‖T (b i)‖₊ : ℝ≥0) : ℝ≥0∞) ^ 2 := by
        gcongr
        exact_mod_cast h
    _ = ((‖A‖₊ : ℝ≥0∞)) ^ 2 * ((‖T (b i)‖₊ : ℝ≥0∞)) ^ 2 := by push_cast; ring

/-- A bounded operator composed with a Hilbert–Schmidt operator is Hilbert–Schmidt. -/
theorem IsHilbertSchmidt.comp_left {b : HilbertBasis ι ℂ E} {T : E →L[ℂ] E}
    (hT : IsHilbertSchmidt b T) (A : E →L[ℂ] E) : IsHilbertSchmidt b (A ∘L T) :=
  ne_top_of_le_ne_top
    (ENNReal.mul_ne_top (ENNReal.pow_ne_top ENNReal.coe_ne_top) hT) (hsNormSq_comp_le b A T)

variable [CompleteSpace E]

/-- A Hilbert–Schmidt operator composed with a bounded operator is Hilbert–Schmidt. -/
theorem IsHilbertSchmidt.comp_right {b : HilbertBasis ι ℂ E} {T : E →L[ℂ] E}
    (hT : IsHilbertSchmidt b T) (A : E →L[ℂ] E) : IsHilbertSchmidt b (T ∘L A) := by
  have h := (hT.adjoint.comp_left (ContinuousLinearMap.adjoint A)).adjoint
  rwa [ContinuousLinearMap.adjoint_comp, ContinuousLinearMap.adjoint_adjoint,
    ContinuousLinearMap.adjoint_adjoint] at h

/-! ## `Tr((T T*)(B* B)) = Tr((B T)(B T)*) ≥ 0` -/

/-- Moving `B` around the trace: the trace of `(T T*)(B* B)` is the trace of the positive
operator `(B T)(B T)*`. -/
theorem traceAlong_selfAdjointSandwich (b : HilbertBasis ι ℂ E) (T : E →L[ℂ] E)
    {B : E →L[ℂ] E} (hB : IsHilbertSchmidt b B) :
    traceAlong b ((T ∘L ContinuousLinearMap.adjoint T) ∘L
        (ContinuousLinearMap.adjoint B ∘L B))
      = traceAlong b ((B ∘L T) ∘L ContinuousLinearMap.adjoint (B ∘L T)) := by
  have hA : IsHilbertSchmidt b
      (T ∘L (ContinuousLinearMap.adjoint T ∘L ContinuousLinearMap.adjoint B)) :=
    (hB.adjoint.comp_left _).comp_left T
  have heq : (T ∘L ContinuousLinearMap.adjoint T) ∘L
        (ContinuousLinearMap.adjoint B ∘L B)
      = (T ∘L (ContinuousLinearMap.adjoint T ∘L ContinuousLinearMap.adjoint B)) ∘L B := by
    simp only [ContinuousLinearMap.comp_assoc]
  have heq2 : B ∘L (T ∘L (ContinuousLinearMap.adjoint T ∘L ContinuousLinearMap.adjoint B))
      = (B ∘L T) ∘L ContinuousLinearMap.adjoint (B ∘L T) := by
    rw [ContinuousLinearMap.adjoint_comp]
    simp only [ContinuousLinearMap.comp_assoc]
  rw [heq, traceAlong_comm hA hB, heq2]

/-- **Positivity of the trace of `(T T*)(B* B)`** for `B` Hilbert–Schmidt.  This is the
abstract form of the positivity of `L` on convolution squares: `T = ϑ(g)` gives
`ϑ(g ∗ g^♯) = T T*`, and the Sonin sandwich `P P̂ P` is `B* B` with `B = P̂ P`. -/
theorem re_traceAlong_selfAdjointSandwich_nonneg (b : HilbertBasis ι ℂ E) (T : E →L[ℂ] E)
    {B : E →L[ℂ] E} (hB : IsHilbertSchmidt b B) :
    0 ≤ (traceAlong b ((T ∘L ContinuousLinearMap.adjoint T) ∘L
      (ContinuousLinearMap.adjoint B ∘L B))).re := by
  rw [traceAlong_selfAdjointSandwich b T hB,
    traceAlong_eq_traceAlongRe b (ContinuousLinearMap.isPositive_self_comp_adjoint (B ∘L T))]
  simpa using traceAlongRe_nonneg b (ContinuousLinearMap.isPositive_self_comp_adjoint (B ∘L T))

/-! ## The special case of the integrated scaling representation -/

/-- **The positivity of `f ↦ Tr(ϑ(f) B* B)` on convolution squares `f = g ∗ g^♯`**, for any
Hilbert–Schmidt `B`.  With `B = P̂ P` the operator `B* B` is the Sonin sandwich `P P̂ P`, so
this is the operator-theoretic content of the positivity of the functional `L`, waiting
only for the identification of `L(f)` with the trace. -/
theorem re_traceAlong_scalingOp_testConv_starTest_nonneg
    (b : HilbertBasis ι ℂ L2Rplus) (g : C_c(Rplus, ℂ)) {B : L2Rplus →L[ℂ] L2Rplus}
    (hB : IsHilbertSchmidt b B) :
    0 ≤ (traceAlong b (scalingOp (testConv g (starTest g)) ∘L
      (ContinuousLinearMap.adjoint B ∘L B))).re := by
  rw [scalingOp_testConv_starTest]
  exact re_traceAlong_selfAdjointSandwich_nonneg b (scalingOp g) hB

end ConnesConsani.WeilPositivity
