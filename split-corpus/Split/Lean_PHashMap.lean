import Mathlib

set_option pp.all true
-- spec: Lean.PHashMap : forall (α : Type.{u}), Type.{v} -> (forall [inst._@.Lean.Data.PersistentHashMap.1997174515._hygCtx._hyg.4 : BEq.{u} α] [inst._@.Lean.Data.PersistentHashMap.1997174515._hygCtx._hyg.7 : Hashable.{succ u} α], Sort.{max (succ u) (succ v)})
def Lean.PHashMap : forall (α : Type.{u}), Type.{v} -> (forall [inst._@.Lean.Data.PersistentHashMap.1997174515._hygCtx._hyg.4 : BEq.{u} α] [inst._@.Lean.Data.PersistentHashMap.1997174515._hygCtx._hyg.7 : Hashable.{succ u} α], Sort.{max (succ u) (succ v)}) :=
  fun (α : Type.{u}) (β : Type.{v}) [inst._@.Lean.Data.PersistentHashMap.1997174515._hygCtx._hyg.4 : BEq.{u} α] [inst._@.Lean.Data.PersistentHashMap.1997174515._hygCtx._hyg.7 : Hashable.{succ u} α] => Lean.PersistentHashMap.{u, v} α β inst._@.Lean.Data.PersistentHashMap.1997174515._hygCtx._hyg.4 inst._@.Lean.Data.PersistentHashMap.1997174515._hygCtx._hyg.7
