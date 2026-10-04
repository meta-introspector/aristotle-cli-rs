import Mathlib

-- spec: opaque Lean.PersistentHashMap.containsAux : forall {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Lean.Data.PersistentHashMap.4129117780._hygCtx._hyg.12 : BEq.{u_1} α], (Lean.PersistentHashMap.Node.{u_1, u_2} α β) -> USize -> α -> Bool
opaque Lean.PersistentHashMap.containsAux : forall {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Lean.Data.PersistentHashMap.4129117780._hygCtx._hyg.12 : BEq.{u_1} α], (Lean.PersistentHashMap.Node.{u_1, u_2} α β) -> USize -> α -> Bool :=
  fun {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Lean.Data.PersistentHashMap.4129117780._hygCtx._hyg.12 : BEq.{u_1} α] (a._@._internal._hyg.0 : Lean.PersistentHashMap.Node.{u_1, u_2} α β) (a._@._internal._hyg.0 : USize) (a._@._internal._hyg.0 : α) => Inhabited.default.{1} Bool instInhabitedBool
