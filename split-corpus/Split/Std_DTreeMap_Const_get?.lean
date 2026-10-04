import Mathlib

set_option pp.all true
-- spec: Std.DTreeMap.Const.get? : forall {α : Type.{u}} {cmp : α -> α -> Ordering} {β : Type.{v}}, (Std.DTreeMap.{u, v} α (fun (x._@.Std.Data.DTreeMap.Basic.561689103._hygCtx._hyg.30 : α) => β) cmp) -> α -> (Option.{v} β)
def Std.DTreeMap.Const.get? : forall {α : Type.{u}} {cmp : α -> α -> Ordering} {β : Type.{v}}, (Std.DTreeMap.{u, v} α (fun (x._@.Std.Data.DTreeMap.Basic.561689103._hygCtx._hyg.30 : α) => β) cmp) -> α -> (Option.{v} β) :=
  fun {α : Type.{u}} {cmp : α -> α -> Ordering} {β : Type.{v}} (t : Std.DTreeMap.{u, v} α (fun (x._@.Std.Data.DTreeMap.Basic.561689103._hygCtx._hyg.30 : α) => β) cmp) (a : α) => Std.DTreeMap.Internal.Impl.Const.get?.{u, v} α β (Ord.mk.{u} α cmp) (Std.DTreeMap.inner.{u, v} α (fun (x._@.Std.Data.DTreeMap.Basic.561689103._hygCtx._hyg.30 : α) => β) cmp t) a
