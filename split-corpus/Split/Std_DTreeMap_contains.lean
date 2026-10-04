import Mathlib

set_option pp.all true
-- spec: Std.DTreeMap.contains : forall {α : Type.{u}} {β : α -> Type.{v}} {cmp : α -> α -> Ordering}, (Std.DTreeMap.{u, v} α β cmp) -> α -> Bool
def Std.DTreeMap.contains : forall {α : Type.{u}} {β : α -> Type.{v}} {cmp : α -> α -> Ordering}, (Std.DTreeMap.{u, v} α β cmp) -> α -> Bool :=
  fun {α : Type.{u}} {β : α -> Type.{v}} {cmp : α -> α -> Ordering} (t : Std.DTreeMap.{u, v} α β cmp) (a : α) => Std.DTreeMap.Internal.Impl.contains.{u, v} α β (Ord.mk.{u} α cmp) a (Std.DTreeMap.inner.{u, v} α β cmp t)
