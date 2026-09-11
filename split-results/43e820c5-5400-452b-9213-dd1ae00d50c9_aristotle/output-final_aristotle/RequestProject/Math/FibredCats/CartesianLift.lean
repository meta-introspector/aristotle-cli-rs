import RequestProject.Math.FibredCats.Fibration

/-!
# Cartesian lifts

In a display-map fibration over a base type `B`, a base equality `b = b'` lifts
to a **cartesian transport** of fibres `p.Fiber b ≃ p.Fiber b'`. This is the
cleavage data of the fibration realized constructively by transport along the
base path (the `J`-rule applied in the base).
-/

universe u v

namespace RequestProject.Math.FibredCats

/-- **Cartesian transport.** A base equality `h : b = b'` induces an equivalence
of fibres `p.Fiber b ≃ p.Fiber b'`. This is the (chosen) cartesian lift of the
base path. -/
def Fibration.cartesianLift {B : Type u} (p : Fibration.{u, v} B) {b b' : B}
    (h : b = b') : p.Fiber b ≃ p.Fiber b' :=
  Equiv.subtypeEquivRight (fun _ => by rw [h])

/-- The cartesian lift of the reflexivity base path is the identity: the
cleavage is normalized at `rfl`. -/
@[simp]
theorem Fibration.cartesianLift_refl {B : Type u} (p : Fibration.{u, v} B)
    (b : B) : p.cartesianLift (rfl : b = b) = Equiv.refl _ := rfl

/-- The cartesian lift preserves the underlying total point: transport along the
base only re-indexes, it does not move the point of the total space. -/
@[simp]
theorem Fibration.cartesianLift_coe {B : Type u} (p : Fibration.{u, v} B)
    {b b' : B} (h : b = b') (e : p.Fiber b) :
    (p.cartesianLift h e).1 = e.1 := rfl

/-- Cartesian lifts compose: lifting along `b = b'` then `b' = b''` agrees with
lifting along the concatenated base path. This is the functoriality of the
cleavage. -/
theorem Fibration.cartesianLift_trans {B : Type u} (p : Fibration.{u, v} B)
    {b b' b'' : B} (h : b = b') (h' : b' = b'') (e : p.Fiber b) :
    p.cartesianLift h' (p.cartesianLift h e) = p.cartesianLift (h.trans h') e := by
  apply Subtype.ext
  rfl

end RequestProject.Math.FibredCats
