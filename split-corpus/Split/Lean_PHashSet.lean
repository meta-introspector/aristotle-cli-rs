import Mathlib

set_option pp.all true
-- spec: Lean.PHashSet : forall (α : Type.{u}) [inst._@.Lean.Data.PersistentHashSet.3487345400._hygCtx._hyg.3 : BEq.{u} α] [inst._@.Lean.Data.PersistentHashSet.3487345400._hygCtx._hyg.6 : Hashable.{succ u} α], Type.{u}
def Lean.PHashSet : forall (α : Type.{u}) [inst._@.Lean.Data.PersistentHashSet.3487345400._hygCtx._hyg.3 : BEq.{u} α] [inst._@.Lean.Data.PersistentHashSet.3487345400._hygCtx._hyg.6 : Hashable.{succ u} α], Type.{u} :=
  fun (α : Type.{u}) [inst._@.Lean.Data.PersistentHashSet.3487345400._hygCtx._hyg.3 : BEq.{u} α] [inst._@.Lean.Data.PersistentHashSet.3487345400._hygCtx._hyg.6 : Hashable.{succ u} α] => Lean.PersistentHashSet.{u} α inst._@.Lean.Data.PersistentHashSet.3487345400._hygCtx._hyg.3 inst._@.Lean.Data.PersistentHashSet.3487345400._hygCtx._hyg.6
