import Mathlib

set_option pp.all true
-- spec: Std.DTreeMap.Internal.Impl.empty : forall {α : Type.{u}} {β : α -> Type.{v}}, Std.DTreeMap.Internal.Impl.{u, v} α β
def Std.DTreeMap.Internal.Impl.empty : forall {α : Type.{u}} {β : α -> Type.{v}}, Std.DTreeMap.Internal.Impl.{u, v} α β :=
  fun {α : Type.{u}} {β : α -> Type.{v}} => Std.DTreeMap.Internal.Impl.leaf.{u, v} α β
