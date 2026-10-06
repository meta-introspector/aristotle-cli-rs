import Mathlib

set_option pp.all true
-- spec: Lean.PersistentArray.tailOff : forall {α : Type.{u}}, (Lean.PersistentArray.{u} α) -> Nat
def Lean.PersistentArray.tailOff : forall {α : Type.{u}}, (Lean.PersistentArray.{u} α) -> Nat :=
  fun (α : Type.{u}) (self : Lean.PersistentArray.{u} α) => self.5
