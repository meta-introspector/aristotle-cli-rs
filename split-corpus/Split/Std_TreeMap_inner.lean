import Mathlib

set_option pp.all true
-- spec: Std.TreeMap.inner : forall {α : Type.{u}} {β : Type.{v}} {cmp : autoParam.{succ u} (α -> α -> Ordering) Std.TreeMap._auto_1}, (Std.TreeMap.{u, v} α β cmp) -> (Std.DTreeMap.{u, v} α (fun (x._@.Std.Data.TreeMap.Basic.650080009._hygCtx._hyg.33 : α) => β) cmp)
def Std.TreeMap.inner : forall {α : Type.{u}} {β : Type.{v}} {cmp : autoParam.{succ u} (α -> α -> Ordering) Std.TreeMap._auto_1}, (Std.TreeMap.{u, v} α β cmp) -> (Std.DTreeMap.{u, v} α (fun (x._@.Std.Data.TreeMap.Basic.650080009._hygCtx._hyg.33 : α) => β) cmp) :=
  fun (α : Type.{u}) (β : Type.{v}) (cmp : autoParam.{succ u} (α -> α -> Ordering) Std.TreeMap._auto_1) (self : Std.TreeMap.{u, v} α β cmp) => self.1
