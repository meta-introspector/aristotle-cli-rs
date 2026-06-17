import Split.Std_DTreeMap_Internal_Impl_Balanced
import Split.Std_DTreeMap_Internal_Impl_size
import Split.Std_DTreeMap_Internal_Impl_SizedBalancedTree
import Split.Std_DTreeMap_Internal_Impl_SizedBalancedTree_rec
import Split.LE_le
import Split.instLENat
import Split.Nat
import Split.Std_DTreeMap_Internal_Impl_SizedBalancedTree_mk
import Split.Std_DTreeMap_Internal_Impl

-- Std.DTreeMap.Internal.Impl.SizedBalancedTree.casesOn from environment
-- def Std.DTreeMap.Internal.Impl.SizedBalancedTree.casesOn : forall {α : Type.{u}} {β : α -> Type.{v}} {lb : Nat} {ub : Nat} {motive : (Std.DTreeMap.Internal.Impl.SizedBalancedTree.{u, v} α β lb ub) -> Sort.{u_1}} (t : Std.DTreeMap.Internal.Impl.SizedBalancedTree.{u, v} α β lb ub), (forall (impl : Std.DTreeMap.Internal.Impl.{u, v} α β) (balanced_impl : Std.DTreeMap.Internal.Impl.Balanced.{u, v} α β impl) (lb_le_size_impl : LE.le.{0} Nat instLENat lb (Std.DTreeMap.Internal.Impl.size.{u, v} α β impl)) (size_impl_le_ub : LE.le.{0} Nat instLENat (Std.DTreeMap.Internal.Impl.size.{u, v} α β impl) ub), motive (Std.DTreeMap.Internal.Impl.SizedBalancedTree.mk.{u, v} α β lb ub impl balanced_impl lb_le_size_impl size_impl_le_ub)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `Std.DTreeMap.Internal.Impl.SizedBalancedTree.casesOn`.
-- In a full split, the body would be extracted from the environment.
