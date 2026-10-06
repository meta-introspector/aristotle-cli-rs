import Mathlib

set_option pp.all true
-- spec: Std.DTreeMap.empty : forall {α : Type.{u}} {β : α -> Type.{v}} {cmp : α -> α -> Ordering}, Std.DTreeMap.{u, v} α β cmp
def Std.DTreeMap.empty : forall {α : Type.{u}} {β : α -> Type.{v}} {cmp : α -> α -> Ordering}, Std.DTreeMap.{u, v} α β cmp :=
  fun {α : Type.{u}} {β : α -> Type.{v}} {cmp : α -> α -> Ordering} => Std.DTreeMap.mk.{u, v} α β cmp (Std.DTreeMap.Internal.Impl.empty.{u, v} α β) (Std.DTreeMap.empty._proof_1.{u, v} α β cmp)
