import Mathlib

-- spec: opaque Lean.PersistentHashMap.findAux : forall {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Lean.Data.PersistentHashMap.3870088558._hygCtx._hyg.12 : BEq.{u_1} α], (Lean.PersistentHashMap.Node.{u_1, u_2} α β) -> USize -> α -> (Option.{u_2} β)
opaque Lean.PersistentHashMap.findAux : forall {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Lean.Data.PersistentHashMap.3870088558._hygCtx._hyg.12 : BEq.{u_1} α], (Lean.PersistentHashMap.Node.{u_1, u_2} α β) -> USize -> α -> (Option.{u_2} β) :=
  fun {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Lean.Data.PersistentHashMap.3870088558._hygCtx._hyg.12 : BEq.{u_1} α] (a._@._internal._hyg.0 : Lean.PersistentHashMap.Node.{u_1, u_2} α β) (a._@._internal._hyg.0 : USize) (a._@._internal._hyg.0 : α) => Inhabited.default.{succ u_2} (Option.{u_2} β) (instInhabitedOption.{u_2} β)
