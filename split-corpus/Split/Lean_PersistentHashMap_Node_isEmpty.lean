import Mathlib

-- spec: opaque Lean.PersistentHashMap.Node.isEmpty : forall {α : Type.{u_1}} {β : Type.{u_2}}, (Lean.PersistentHashMap.Node.{u_1, u_2} α β) -> Bool
opaque Lean.PersistentHashMap.Node.isEmpty : forall {α : Type.{u_1}} {β : Type.{u_2}}, (Lean.PersistentHashMap.Node.{u_1, u_2} α β) -> Bool :=
  fun {α : Type.{u_1}} {β : Type.{u_2}} (a._@._internal._hyg.0 : Lean.PersistentHashMap.Node.{u_1, u_2} α β) => Inhabited.default.{1} Bool instInhabitedBool
