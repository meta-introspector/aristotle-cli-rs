import Mathlib

set_option pp.all true
-- spec: Std.TreeMap.insertIfNew : forall {α : Type.{u}} {β : Type.{v}} {cmp : α -> α -> Ordering}, (Std.TreeMap.{u, v} α β cmp) -> α -> β -> (Std.TreeMap.{u, v} α β cmp)
def Std.TreeMap.insertIfNew : forall {α : Type.{u}} {β : Type.{v}} {cmp : α -> α -> Ordering}, (Std.TreeMap.{u, v} α β cmp) -> α -> β -> (Std.TreeMap.{u, v} α β cmp) :=
  fun {α : Type.{u}} {β : Type.{v}} {cmp : α -> α -> Ordering} (t : Std.TreeMap.{u, v} α β cmp) (a : α) (b : β) => Std.TreeMap.mk.{u, v} α β cmp (Std.DTreeMap.insertIfNew.{u, v} α (fun (x._@.Std.Data.TreeMap.Basic.650080009._hygCtx._hyg.33 : α) => β) cmp (Std.TreeMap.inner.{u, v} α β cmp t) a b)
