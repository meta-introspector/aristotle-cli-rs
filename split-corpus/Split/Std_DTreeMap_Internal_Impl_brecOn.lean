import Mathlib

set_option pp.all true
-- spec: Std.DTreeMap.Internal.Impl.brecOn : forall {α : Type.{u}} {β : α -> Type.{v}} {motive : (Std.DTreeMap.Internal.Impl.{u, v} α β) -> Sort.{u_1}} (t : Std.DTreeMap.Internal.Impl.{u, v} α β), (forall (t : Std.DTreeMap.Internal.Impl.{u, v} α β), (Std.DTreeMap.Internal.Impl.below.{u_1, u, v} α β motive t) -> (motive t)) -> (motive t)
def Std.DTreeMap.Internal.Impl.brecOn : forall {α : Type.{u}} {β : α -> Type.{v}} {motive : (Std.DTreeMap.Internal.Impl.{u, v} α β) -> Sort.{u_1}} (t : Std.DTreeMap.Internal.Impl.{u, v} α β), (forall (t : Std.DTreeMap.Internal.Impl.{u, v} α β), (Std.DTreeMap.Internal.Impl.below.{u_1, u, v} α β motive t) -> (motive t)) -> (motive t) :=
  fun {α : Type.{u}} {β : α -> Type.{v}} {motive : (Std.DTreeMap.Internal.Impl.{u, v} α β) -> Sort.{u_1}} (t : Std.DTreeMap.Internal.Impl.{u, v} α β) (F_1 : forall (t : Std.DTreeMap.Internal.Impl.{u, v} α β), (Std.DTreeMap.Internal.Impl.below.{u_1, u, v} α β motive t) -> (motive t)) => (Std.DTreeMap.Internal.Impl.brecOn.go.{u_1, u, v} α β motive t F_1).1
