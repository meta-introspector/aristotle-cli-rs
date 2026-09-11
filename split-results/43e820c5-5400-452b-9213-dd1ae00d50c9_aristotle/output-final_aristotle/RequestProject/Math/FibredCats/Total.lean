import RequestProject.Math.FibredCats.Fibration

/-!
# The total category of a fibration

The **Grothendieck construction** reassembles a fibration from its fibres: the
total space is equivalent to the dependent sum (`Σ`) of all the fibres. This is
the precise content of the equivalence proved here, `Fibration.totalEquivSigma`,
built on Mathlib's `Equiv.sigmaFiberEquiv`.
-/

universe u v

namespace RequestProject.Math.FibredCats

/-- **Grothendieck / total-space equivalence.** The total space of a fibration
is equivalent to the dependent sum of its fibres over the base. -/
def Fibration.totalEquivSigma {B : Type u} (p : Fibration.{u, v} B) :
    (Σ b : B, p.Fiber b) ≃ p.Total :=
  Equiv.sigmaFiberEquiv p.proj

/-- The total-space equivalence sends a fibre point to the underlying total
point (forgetting the base index). -/
@[simp]
theorem Fibration.totalEquivSigma_apply {B : Type u} (p : Fibration.{u, v} B)
    (x : Σ b : B, p.Fiber b) : p.totalEquivSigma x = x.2.1 := rfl

/-- Reassembly is a bijection: the total space and the indexed sum of fibres
have the same cardinality of points, witnessed by the equivalence. -/
theorem Fibration.total_card_eq_sigma {B : Type u} (p : Fibration.{u, v} B)
    [Fintype (Σ b : B, p.Fiber b)] [Fintype p.Total] :
    Fintype.card (Σ b : B, p.Fiber b) = Fintype.card p.Total :=
  Fintype.card_congr p.totalEquivSigma

end RequestProject.Math.FibredCats
