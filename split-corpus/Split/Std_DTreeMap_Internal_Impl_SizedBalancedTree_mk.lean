import Mathlib

-- spec: constructor Std.DTreeMap.Internal.Impl.SizedBalancedTree.mk : forall {α : Type.{u}} {β : α -> Type.{v}} {lb : Nat} {ub : Nat} (impl : Std.DTreeMap.Internal.Impl.{u, v} α β), (Std.DTreeMap.Internal.Impl.Balanced.{u, v} α β impl) -> (LE.le.{0} Nat instLENat lb (Std.DTreeMap.Internal.Impl.size.{u, v} α β impl)) -> (LE.le.{0} Nat instLENat (Std.DTreeMap.Internal.Impl.size.{u, v} α β impl) ub) -> (Std.DTreeMap.Internal.Impl.SizedBalancedTree.{u, v} α β lb ub)
