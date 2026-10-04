import Mathlib

set_option pp.all true
-- spec: Lean.PersistentArray.instAppend : forall {α : Type.{u}}, Append.{u} (Lean.PersistentArray.{u} α)
def Lean.PersistentArray.instAppend : forall {α : Type.{u}}, Append.{u} (Lean.PersistentArray.{u} α) :=
  fun {α : Type.{u}} => Append.mk.{u} (Lean.PersistentArray.{u} α) (Lean.PersistentArray.append.{u} α)
