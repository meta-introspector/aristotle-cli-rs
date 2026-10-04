import Mathlib

set_option pp.all true
-- spec: Lean.PersistentArray.shift : forall {α : Type.{u}}, (Lean.PersistentArray.{u} α) -> USize
def Lean.PersistentArray.shift : forall {α : Type.{u}}, (Lean.PersistentArray.{u} α) -> USize :=
  fun (α : Type.{u}) (self : Lean.PersistentArray.{u} α) => self.4
