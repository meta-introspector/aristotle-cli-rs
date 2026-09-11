/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The Sonin sandwich `P P̂ P` as a self-adjoint square `B* B`, and the corresponding trace
positivity, for arXiv:2006.13771 (Connes–Consani, *Weil positivity and Trace formula –
the archimedean place*).

`RequestProject/TracePositivity.lean` proves `Re Tr((T T*)(B* B)) ≥ 0` for Hilbert–Schmidt
`B`.  Here we record that the Sonin sandwich `P₁ P̂₁ P₁` of `RequestProject/SoninJoin.lean`
is precisely of the form `B* B`, with `B = P̂₁ P₁`, so that the abstract positivity applies
verbatim to the operator whose trace is the functional `L` of the paper.
-/
import RequestProject.Imported.OutputFinal.RequestProject.SoninJoin
import RequestProject.Imported.OutputFinal.RequestProject.TracePositivity

set_option maxHeartbeats 1000000

noncomputable section

open ContinuousLinearMap

namespace ConnesConsani.WeilPositivity

variable {ι : Type*}

/-- The adjoint of the cut-off projection `P̂₁` is `P̂₁`. -/
theorem adjoint_P1hat : ContinuousLinearMap.adjoint P1hat = P1hat := by
  simpa [ContinuousLinearMap.star_eq_adjoint] using P1hat_selfAdjoint

/-- **The Sonin sandwich is a self-adjoint square**: `P₁ P̂₁ P₁ = (P̂₁ P₁)* (P̂₁ P₁)`. -/
theorem P1_P1hat_P1_eq_adjoint_comp :
    P1 ∘L P1hat ∘L P1
      = ContinuousLinearMap.adjoint (P1hat ∘L P1) ∘L (P1hat ∘L P1) := by
  rw [ContinuousLinearMap.adjoint_comp, adjoint_P1, adjoint_P1hat]
  simp only [← ContinuousLinearMap.comp_assoc]
  rw [ContinuousLinearMap.comp_assoc P1 P1hat P1hat,
    show P1hat ∘L P1hat = P1hat from P1hat_idempotent]

/-- **Positivity of the trace of `(T T*) P₁ P̂₁ P₁`**: with `T = ϑ(g)` (transported to
`L²(ℝ)` by the unitary identification of the two pictures) this is the positivity of
`L(g ∗ g^♯) = Tr(ϑ(g ∗ g^♯) P P̂ P)`. -/
theorem re_traceAlong_soninSandwich_nonneg (b : HilbertBasis ι ℂ L2R) (T : L2R →L[ℂ] L2R)
    (hB : IsHilbertSchmidt b (P1hat ∘L P1)) :
    0 ≤ (traceAlong b ((T ∘L ContinuousLinearMap.adjoint T) ∘L (P1 ∘L P1hat ∘L P1))).re := by
  rw [P1_P1hat_P1_eq_adjoint_comp]
  exact re_traceAlong_selfAdjointSandwich_nonneg b T hB

end ConnesConsani.WeilPositivity
