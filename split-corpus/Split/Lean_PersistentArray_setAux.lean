import Mathlib

-- spec: opaque Lean.PersistentArray.setAux : forall {α : Type.{u}}, (Lean.PersistentArrayNode.{u} α) -> USize -> USize -> α -> (Lean.PersistentArrayNode.{u} α)
opaque Lean.PersistentArray.setAux : forall {α : Type.{u}}, (Lean.PersistentArrayNode.{u} α) -> USize -> USize -> α -> (Lean.PersistentArrayNode.{u} α) :=
  fun {α : Type.{u}} (a._@._internal._hyg.0 : Lean.PersistentArrayNode.{u} α) (a_1._@._internal._hyg.0 : USize) (a_1._@._internal._hyg.0 : USize) (a_1._@._internal._hyg.0 : α) => let inst : Inhabited.{succ u} (Lean.PersistentArrayNode.{u} α) := Inhabited.mk.{succ u} (Lean.PersistentArrayNode.{u} α) a._@._internal._hyg.0; Inhabited.default.{succ u} (Lean.PersistentArrayNode.{u} α) inst
