import Mathlib

-- spec: opaque Lean.PersistentArray.mkNewPath : forall {α : Type.{u}}, USize -> (Array.{u} α) -> (Lean.PersistentArrayNode.{u} α)
opaque Lean.PersistentArray.mkNewPath : forall {α : Type.{u}}, USize -> (Array.{u} α) -> (Lean.PersistentArrayNode.{u} α) :=
  fun {α : Type.{u}} (shift : USize) (a : Array.{u} α) => Inhabited.default.{succ u} (Lean.PersistentArrayNode.{u} α) (Lean.instInhabitedPersistentArrayNode.{u} α)
