import Split.Std_DTreeMap_Internal_Impl_rec
import Split.Std_DTreeMap_Internal_Impl_inner
import Split.Std_DTreeMap_Internal_Impl_leaf
import Split.Nat
import Split.Std_DTreeMap_Internal_Impl

-- Std.DTreeMap.Internal.Impl.casesOn from environment
-- def Std.DTreeMap.Internal.Impl.casesOn : forall {α : Type.{u}} {β : α -> Type.{v}} {motive : (Std.DTreeMap.Internal.Impl.{u, v} α β) -> Sort.{u_1}} (t : Std.DTreeMap.Internal.Impl.{u, v} α β), (forall (size : Nat) (k : α) (v : β k) (l : Std.DTreeMap.Internal.Impl.{u, v} α β) (r : Std.DTreeMap.Internal.Impl.{u, v} α β), motive (Std.DTreeMap.Internal.Impl.inner.{u, v} α β size k v l r)) -> (motive (Std.DTreeMap.Internal.Impl.leaf.{u, v} α β)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `Std.DTreeMap.Internal.Impl.casesOn`.
-- In a full split, the body would be extracted from the environment.
