import RequestProject.Math.UnivalentCore

/-!
# Clifford morphism lift

The Clifford-algebra functor lifts isometries of quadratic spaces to algebra
homomorphisms of their Clifford algebras. This module records the functorial
core of that lift: identities go to identities (`cliffordMap_id`) and the lift
is compatible with the universal embedding `ι` (`cliffordMap_ι`). This is the
"CliffordMorphismLift" component of the geometric bridge.
-/

universe u

namespace RequestProject.Math.Bridge

open CliffordAlgebra

variable {R : Type u} [CommRing R]

/-- The Clifford functor sends the identity isometry to the identity algebra
homomorphism: functoriality at identities. -/
theorem cliffordMap_id {M : Type u} [AddCommGroup M] [Module R M]
    (Q : QuadraticForm R M) :
    CliffordAlgebra.map (QuadraticMap.Isometry.id Q) = AlgHom.id R (CliffordAlgebra Q) :=
  CliffordAlgebra.map_id Q

/-- The lift of an isometry `f` is compatible with the universal embeddings:
mapping an embedded vector through the lifted morphism equals embedding its
image. This is the naturality square of `ι` under the Clifford functor. -/
theorem cliffordMap_ι {M N : Type u} [AddCommGroup M] [Module R M]
    [AddCommGroup N] [Module R N] {Q₁ : QuadraticForm R M} {Q₂ : QuadraticForm R N}
    (f : Q₁ →qᵢ Q₂) (m : M) :
    CliffordAlgebra.map f (ι Q₁ m) = ι Q₂ (f m) :=
  CliffordAlgebra.map_apply_ι f m

end RequestProject.Math.Bridge
