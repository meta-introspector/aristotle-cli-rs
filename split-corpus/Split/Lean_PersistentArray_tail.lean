import Mathlib

set_option pp.all true
-- spec: Lean.PersistentArray.tail : forall {α : Type.{u}}, (Lean.PersistentArray.{u} α) -> (Array.{u} α)
def Lean.PersistentArray.tail : forall {α : Type.{u}}, (Lean.PersistentArray.{u} α) -> (Array.{u} α) :=
  fun (α : Type.{u}) (self : Lean.PersistentArray.{u} α) => self.2
