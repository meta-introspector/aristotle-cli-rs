/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

STATUS: this module is **not on any live proof path**.  The positivity mechanism it records
is proved again, in the picture that the live results actually use, in
`RequestProject/TracePositivity.lean`; no other module refers to the three theorems below.
It is kept (and imported by `RequestProject/Main.lean`, so it is elaborated on every build)
because it is `sorry`-free, self-contained and cheap; see the "Clean-up of the repository"
section of `RequestProject/Skeleton.lean`.

The trace of the operators built from the integrated scaling representation, following the
shape of the identity

  `L(f) = Tr(ϑ(f) P P̂ P)`

of arXiv:2006.13771 (Connes–Consani, *Weil positivity and Trace formula – the archimedean
place*).

This module puts together `RequestProject/ScalingIntegrated.lean` (the operators `ϑ(f)`)
and `RequestProject/TraceClass.lean` (Hilbert–Schmidt and trace-class language), and
records the positivity mechanism in the form in which it will be used:

  `Tr(ϑ(f)^♯ A ϑ(f)) ≥ 0`  for every positive `A`,

i.e. the trace of the conjugate of a positive operator by an integrated operator is
nonnegative.  Since `ϑ(f^♯) = ϑ(f)*`, this is exactly the positivity of
`f ↦ Tr(ϑ(f ∗ f^♯) A)` once the two remaining analytic ingredients are available: the
multiplicativity `ϑ(f ∗ g) = ϑ(f) ϑ(g)` of the integrated representation and the trace
property `Tr(AB) = Tr(BA)` on trace-class operators.
-/
import RequestProject.Imported.OutputFinal.RequestProject.ScalingIntegrated
import RequestProject.Imported.OutputFinal.RequestProject.TraceClass

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory ContinuousLinearMap

open scoped CompactlySupported

namespace ConnesConsani.WeilPositivity

variable {ι : Type*}

/-- **The positivity mechanism of the trace formula.**  For every positive operator `A` on
`L²(ℝ⋆₊)` and every test function `f`, the trace of `ϑ(f)* A ϑ(f)` (computed along any
Hilbert basis) is nonnegative. -/
theorem traceAlongRe_scalingOp_conj_nonneg (b : HilbertBasis ι ℂ L2Rplus)
    {A : L2Rplus →L[ℂ] L2Rplus} (hA : A.IsPositive) (g : C_c(Rplus, ℂ)) :
    0 ≤ traceAlongRe b (ContinuousLinearMap.adjoint (scalingOp g) ∘L A ∘L scalingOp g) :=
  traceAlongRe_conj_nonneg b hA (scalingOp g)

/-- The same statement written with the involution of the convolution algebra:
`Tr(ϑ(f^♯) A ϑ(f)) ≥ 0` for every positive `A`. -/
theorem traceAlongRe_scalingOp_starTest_nonneg (b : HilbertBasis ι ℂ L2Rplus)
    {A : L2Rplus →L[ℂ] L2Rplus} (hA : A.IsPositive) (g : C_c(Rplus, ℂ)) :
    0 ≤ traceAlongRe b (scalingOp (starTest g) ∘L A ∘L scalingOp g) := by
  rw [← adjoint_scalingOp g]
  exact traceAlongRe_scalingOp_conj_nonneg b hA g

/-- If moreover the conjugated operator is trace class, its trace series converges
absolutely, so the value `traceAlongRe` above is a genuine (absolutely convergent) sum. -/
theorem summable_norm_inner_scalingOp_conj (b : HilbertBasis ι ℂ L2Rplus)
    {A : L2Rplus →L[ℂ] L2Rplus} (g : C_c(Rplus, ℂ))
    (hTC : IsTraceClass b (ContinuousLinearMap.adjoint (scalingOp g) ∘L A ∘L scalingOp g)) :
    Summable fun i =>
      ‖inner ℂ (b i)
        ((ContinuousLinearMap.adjoint (scalingOp g) ∘L A ∘L scalingOp g) (b i))‖ :=
  summable_norm_inner_of_isTraceClass hTC

end ConnesConsani.WeilPositivity
