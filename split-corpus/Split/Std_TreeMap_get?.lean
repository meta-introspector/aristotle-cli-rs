import Mathlib

set_option pp.all true
-- spec: Std.TreeMap.get? : forall {α : Type.{u}} {β : Type.{v}} {cmp : α -> α -> Ordering}, (Std.TreeMap.{u, v} α β cmp) -> α -> (Option.{v} β)
def Std.TreeMap.get? : forall {α : Type.{u}} {β : Type.{v}} {cmp : α -> α -> Ordering}, (Std.TreeMap.{u, v} α β cmp) -> α -> (Option.{v} β) :=
  fun {α : Type.{u}} {β : Type.{v}} {cmp : α -> α -> Ordering} (t : Std.TreeMap.{u, v} α β cmp) (a : α) => Std.DTreeMap.Const.get?.{u, v} α cmp β (Std.TreeMap.inner.{u, v} α β cmp t) a
