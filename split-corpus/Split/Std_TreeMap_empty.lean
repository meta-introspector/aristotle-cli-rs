import Mathlib

set_option pp.all true
-- spec: Std.TreeMap.empty : forall {α : Type.{u}} {β : Type.{v}} {cmp : α -> α -> Ordering}, Std.TreeMap.{u, v} α β cmp
def Std.TreeMap.empty : forall {α : Type.{u}} {β : Type.{v}} {cmp : α -> α -> Ordering}, Std.TreeMap.{u, v} α β cmp :=
  fun {α : Type.{u}} {β : Type.{v}} {cmp : α -> α -> Ordering} => Std.TreeMap.mk.{u, v} α β cmp (Std.DTreeMap.empty.{u, v} α (fun (x._@.Std.Data.TreeMap.Basic.650080009._hygCtx._hyg.33 : α) => β) cmp)
