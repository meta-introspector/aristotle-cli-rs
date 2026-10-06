import Mathlib

set_option pp.all true
-- spec: Lean.PersistentArray.mkEmptyArray : forall {α : Type.{u}}, Array.{u} α
def Lean.PersistentArray.mkEmptyArray : forall {α : Type.{u}}, Array.{u} α :=
  fun {α : Type.{u}} => Array.mkEmpty.{u} α (USize.toNat Lean.PersistentArray.branching)
