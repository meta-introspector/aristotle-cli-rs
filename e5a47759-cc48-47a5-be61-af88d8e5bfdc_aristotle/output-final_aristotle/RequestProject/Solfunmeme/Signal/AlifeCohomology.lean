/-
  AlifeCohomology.lean — the self-hosted life is cohomologically trivial.

  `AlifeLattice.lean` showed that the mature colony — the equilibrium the web's
  own artificial life settles into — is a conformal embedding of the web in the
  field its own growth defines (`mature_isEmbedding`).  `Cohomology.lean` showed
  that solvability of a field is the vanishing of a cohomology class.  Putting
  the two together: the life's own field carries the zero class, for every
  prime, and in particular its 2-adic exponents satisfy the six chord equations
  of the recorded web.

  The contrast is the point.  A weighting of the attachments chosen by hand — the
  constant one, say, or the perturbed conformal field — generally has a nonzero
  class and then no colony can realise it.  The one the life generates for itself
  cannot fail to be trivial, because the life is its solution.
-/
import RequestProject.Solfunmeme.Signal.Cohomology
import RequestProject.Solfunmeme.Signal.AlifeLattice

namespace Mycelium

namespace Alife

/-- The field the mature colony generates is nowhere zero. -/
theorem matureRatio_ne_zero (h : Hypha Strand) : matureRatio h ≠ 0 := by
  rw [matureRatio, div_ne_zero_iff]
  exact ⟨Nat.cast_ne_zero.mpr (mature_ne_zero h.target),
    Nat.cast_ne_zero.mpr (mature_ne_zero h.source)⟩

/-- **The life's field is a coboundary.**  For every prime, the valuation of the
    field the mature colony generates is the difference of the valuations of the
    colony's own sizes. -/
theorem mature_padic_coboundary (p : ℕ) [Fact p.Prime] :
    IsCoboundary continuum (fun h => padicValRat p (matureRatio h)) :=
  padic_coboundary_of_embedding matureRatio_ne_zero
    (fun x => Nat.cast_ne_zero.mpr (mature_ne_zero x)) mature_isEmbedding

/-- **…so its class vanishes.**  The self-hosted life sits in the zero class of
    `H¹(continuum; ℤ)`: nothing obstructs it, because it is its own solution. -/
theorem mature_class_eq_zero (p : ℕ) [Fact p.Prime] :
    cls continuum (fun h => padicValRat p (matureRatio h)) = 0 :=
  (cls_eq_zero_iff _).mpr (mature_padic_coboundary p)

/-- Concretely, the 2-adic exponents of the life's field satisfy the six chord
    equations of the recorded web. -/
theorem mature_chordEquations :
    ChordEquations (fun h => padicValRat 2 (matureRatio h)) :=
  (continuum_coboundary_iff _).mp (mature_padic_coboundary 2)

/-- The life's field is *not* the constant field: growth along the web is not
    uniform, and indeed no uniform growth is possible. -/
theorem mature_class_ne_unit_class :
    cls continuum (fun h => padicValRat 2 (matureRatio h)) ≠
      cls continuum (fun _ => (1 : ℤ)) := by
  intro h
  refine continuum_unit_class_ne_zero ?_
  rw [← h]
  exact mature_class_eq_zero 2

/-! ## Axiom audit -/

#print axioms mature_padic_coboundary
#print axioms mature_class_eq_zero
#print axioms mature_chordEquations
#print axioms mature_class_ne_unit_class

end Alife

end Mycelium
