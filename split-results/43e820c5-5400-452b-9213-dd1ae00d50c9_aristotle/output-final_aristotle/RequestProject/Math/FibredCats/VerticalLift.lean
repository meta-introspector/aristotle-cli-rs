import RequestProject.Math.FibredCats.CartesianLift

/-!
# Vertical morphisms

A morphism of the total space is **vertical** when it lies entirely within a
single fibre, i.e. it preserves the projection. Vertical maps are exactly the
ones lying over the identity of the base; here we record this characterization
and prove that the fibre inclusion is vertical, and that vertical maps stay
within a fibre.
-/

universe u v

namespace RequestProject.Math.FibredCats

/-- A self-map of the total space is **vertical** when it preserves the
projection — it lies over the identity of the base. -/
def Fibration.IsVertical {B : Type u} (p : Fibration.{u, v} B)
    (f : p.Total → p.Total) : Prop :=
  ∀ e, p.proj (f e) = p.proj e

/-- The identity map of the total space is vertical. -/
theorem Fibration.isVertical_id {B : Type u} (p : Fibration.{u, v} B) :
    p.IsVertical _root_.id := fun _ => rfl

/-- The composition of two vertical maps is vertical. -/
theorem Fibration.isVertical_comp {B : Type u} (p : Fibration.{u, v} B)
    {f g : p.Total → p.Total} (hf : p.IsVertical f) (hg : p.IsVertical g) :
    p.IsVertical (f ∘ g) := fun e => by
  simp only [Function.comp_apply]
  rw [hf (g e), hg e]

/-- A vertical map sends a point of the fibre over `b` to a point of the *same*
fibre: verticality is exactly fibre-preservation. -/
def Fibration.verticalToFiber {B : Type u} (p : Fibration.{u, v} B)
    {f : p.Total → p.Total} (hf : p.IsVertical f) {b : B} (e : p.Fiber b) :
    p.Fiber b := ⟨f e.1, by rw [hf e.1, e.2]⟩

end RequestProject.Math.FibredCats
