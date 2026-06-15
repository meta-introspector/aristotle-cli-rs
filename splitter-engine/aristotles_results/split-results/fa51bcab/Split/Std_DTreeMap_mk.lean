import Split.Std_DTreeMap
import Split.Ord_mk
import Split.Ordering
import Split.Std_DTreeMap_Internal_Impl_WF
import Split.autoParam
import Split.Std_DTreeMap_Internal_Impl

-- Std.DTreeMap.mk from environment
-- constructor Std.DTreeMap.mk : forall {α : Type.{u}} {β : α -> Type.{v}} {cmp : autoParam.{succ u} (α -> α -> Ordering) Std.DTreeMap._auto_1} (inner : Std.DTreeMap.Internal.Impl.{u, v} α β), (Std.DTreeMap.Internal.Impl.WF.{u, v} α (Ord.mk.{u} α cmp) β inner) -> (Std.DTreeMap.{u, v} α β cmp)

-- Stub: this file represents the declaration `Std.DTreeMap.mk`.
-- In a full split, the body would be extracted from the environment.
