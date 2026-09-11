import RequestProject.Math.UnivalentCore

/-!
# Fibred categories: the display-map model of a fibration

This module gives a lightweight, fully verified model of a **fibration** in the
display-map (bundle) style: a fibration over a base type `B` is a *total* type
together with a projection down to `B`. The **fibre** over a base point is the
preimage of that point.

This is the genuinely formalizable kernel of the "Fibration / Cloven / Split /
Total categories" component of the unified architecture: in the set/space model
a Grothendieck fibration is precisely a display map, and its fibres are the
preimages of the projection.
-/

universe u v w

namespace RequestProject.Math.FibredCats

/-- A **fibration** (display map) over a base type `B`: a total space together
with a projection. -/
structure Fibration (B : Type u) where
  /-- The total space `E` of the fibration. -/
  Total : Type v
  /-- The projection `p : E → B`. -/
  proj : Total → B

/-- The **fibre** of a fibration over a base point `b`: the subtype of total
points projecting to `b`. -/
def Fibration.Fiber {B : Type u} (p : Fibration.{u, v} B) (b : B) : Type v :=
  { e : p.Total // p.proj e = b }

/-- The projection of any element of a fibre is the prescribed base point. -/
@[simp]
theorem Fibration.proj_fiber {B : Type u} (p : Fibration.{u, v} B) (b : B)
    (e : p.Fiber b) : p.proj e.1 = b := e.2

/-- A point of the total space lies in the fibre over its own projection. -/
def Fibration.toFiber {B : Type u} (p : Fibration.{u, v} B) (e : p.Total) :
    p.Fiber (p.proj e) := ⟨e, rfl⟩

/-- The constant projection onto a base point makes `B`-many "trivial" fibres;
this is the trivial fibration `id : B → B`. Its fibre over `b` is contractible
(a singleton). -/
def Fibration.id (B : Type u) : Fibration.{u, u} B where
  Total := B
  proj := _root_.id

@[simp]
theorem Fibration.id_proj {B : Type u} (b : B) : (Fibration.id B).proj b = b := rfl

end RequestProject.Math.FibredCats
