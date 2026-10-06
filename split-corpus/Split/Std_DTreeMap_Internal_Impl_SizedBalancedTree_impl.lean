import Mathlib

set_option pp.all true
-- spec: Std.DTreeMap.Internal.Impl.SizedBalancedTree.impl : forall {α : Type.{u}} {β : α -> Type.{v}} {lb : Nat} {ub : Nat}, (Std.DTreeMap.Internal.Impl.SizedBalancedTree.{u, v} α β lb ub) -> (Std.DTreeMap.Internal.Impl.{u, v} α β)
def Std.DTreeMap.Internal.Impl.SizedBalancedTree.impl : forall {α : Type.{u}} {β : α -> Type.{v}} {lb : Nat} {ub : Nat}, (Std.DTreeMap.Internal.Impl.SizedBalancedTree.{u, v} α β lb ub) -> (Std.DTreeMap.Internal.Impl.{u, v} α β) :=
  fun (α : Type.{u}) (β : α -> Type.{v}) (lb : Nat) (ub : Nat) (self : Std.DTreeMap.Internal.Impl.SizedBalancedTree.{u, v} α β lb ub) => self.1
