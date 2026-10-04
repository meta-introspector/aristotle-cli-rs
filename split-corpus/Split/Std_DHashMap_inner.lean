import Mathlib

set_option pp.all true
-- spec: Std.DHashMap.inner : forall {α : Type.{u}} {β : α -> Type.{v}} [inst._@.Std.Data.DHashMap.Basic.713811220._hygCtx._hyg.40 : BEq.{u} α] [inst._@.Std.Data.DHashMap.Basic.713811220._hygCtx._hyg.43 : Hashable.{succ u} α], (Std.DHashMap.{u, v} α β inst._@.Std.Data.DHashMap.Basic.713811220._hygCtx._hyg.40 inst._@.Std.Data.DHashMap.Basic.713811220._hygCtx._hyg.43) -> (Std.DHashMap.Raw.{u, v} α β)
def Std.DHashMap.inner : forall {α : Type.{u}} {β : α -> Type.{v}} [inst._@.Std.Data.DHashMap.Basic.713811220._hygCtx._hyg.40 : BEq.{u} α] [inst._@.Std.Data.DHashMap.Basic.713811220._hygCtx._hyg.43 : Hashable.{succ u} α], (Std.DHashMap.{u, v} α β inst._@.Std.Data.DHashMap.Basic.713811220._hygCtx._hyg.40 inst._@.Std.Data.DHashMap.Basic.713811220._hygCtx._hyg.43) -> (Std.DHashMap.Raw.{u, v} α β) :=
  fun (α : Type.{u}) (β : α -> Type.{v}) [inst._@.Std.Data.DHashMap.Basic.713811220._hygCtx._hyg.40 : BEq.{u} α] [inst._@.Std.Data.DHashMap.Basic.713811220._hygCtx._hyg.43 : Hashable.{succ u} α] (self : Std.DHashMap.{u, v} α β inst._@.Std.Data.DHashMap.Basic.713811220._hygCtx._hyg.40 inst._@.Std.Data.DHashMap.Basic.713811220._hygCtx._hyg.43) => self.1
