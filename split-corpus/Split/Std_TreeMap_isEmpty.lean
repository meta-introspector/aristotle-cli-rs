import Mathlib

set_option pp.all true
-- spec: Std.TreeMap.isEmpty : forall {α : Type.{u}} {β : Type.{v}} {cmp : α -> α -> Ordering}, (Std.TreeMap.{u, v} α β cmp) -> Bool
def Std.TreeMap.isEmpty : forall {α : Type.{u}} {β : Type.{v}} {cmp : α -> α -> Ordering}, (Std.TreeMap.{u, v} α β cmp) -> Bool :=
  fun {α : Type.{u}} {β : Type.{v}} {cmp : α -> α -> Ordering} (t : Std.TreeMap.{u, v} α β cmp) => Std.DTreeMap.isEmpty.{u, v} α (fun (x._@.Std.Data.TreeMap.Basic.650080009._hygCtx._hyg.33 : α) => β) cmp (Std.TreeMap.inner.{u, v} α β cmp t)
