import Mathlib

set_option pp.all true
-- spec: Std.DTreeMap.isEmpty : forall {α : Type.{u}} {β : α -> Type.{v}} {cmp : α -> α -> Ordering}, (Std.DTreeMap.{u, v} α β cmp) -> Bool
def Std.DTreeMap.isEmpty : forall {α : Type.{u}} {β : α -> Type.{v}} {cmp : α -> α -> Ordering}, (Std.DTreeMap.{u, v} α β cmp) -> Bool :=
  fun {α : Type.{u}} {β : α -> Type.{v}} {cmp : α -> α -> Ordering} (t : Std.DTreeMap.{u, v} α β cmp) => Std.DTreeMap.Internal.Impl.isEmpty.{u, v} α β (Std.DTreeMap.inner.{u, v} α β cmp t)
