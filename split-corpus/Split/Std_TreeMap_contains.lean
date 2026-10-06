import Mathlib

set_option pp.all true
-- spec: Std.TreeMap.contains : forall {α : Type.{u}} {β : Type.{v}} {cmp : α -> α -> Ordering}, (Std.TreeMap.{u, v} α β cmp) -> α -> Bool
def Std.TreeMap.contains : forall {α : Type.{u}} {β : Type.{v}} {cmp : α -> α -> Ordering}, (Std.TreeMap.{u, v} α β cmp) -> α -> Bool :=
  fun {α : Type.{u}} {β : Type.{v}} {cmp : α -> α -> Ordering} (l : Std.TreeMap.{u, v} α β cmp) (a : α) => Std.DTreeMap.contains.{u, v} α (fun (x._@.Std.Data.TreeMap.Basic.650080009._hygCtx._hyg.33 : α) => β) cmp (Std.TreeMap.inner.{u, v} α β cmp l) a
