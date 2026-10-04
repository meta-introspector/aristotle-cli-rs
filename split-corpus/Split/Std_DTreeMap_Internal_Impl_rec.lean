import Mathlib

-- spec: recursor Std.DTreeMap.Internal.Impl.rec : forall {α : Type.{u}} {β : α -> Type.{v}} {motive : (Std.DTreeMap.Internal.Impl.{u, v} α β) -> Sort.{u_1}}, (forall (size : Nat) (k : α) (v : β k) (l : Std.DTreeMap.Internal.Impl.{u, v} α β) (r : Std.DTreeMap.Internal.Impl.{u, v} α β), (motive l) -> (motive r) -> (motive (Std.DTreeMap.Internal.Impl.inner.{u, v} α β size k v l r))) -> (motive (Std.DTreeMap.Internal.Impl.leaf.{u, v} α β)) -> (forall (t : Std.DTreeMap.Internal.Impl.{u, v} α β), motive t)
