import Mathlib

set_option pp.all true
-- spec: Lean.PersistentArray.root : forall {α : Type.{u}}, (Lean.PersistentArray.{u} α) -> (Lean.PersistentArrayNode.{u} α)
def Lean.PersistentArray.root : forall {α : Type.{u}}, (Lean.PersistentArray.{u} α) -> (Lean.PersistentArrayNode.{u} α) :=
  fun (α : Type.{u}) (self : Lean.PersistentArray.{u} α) => self.1
