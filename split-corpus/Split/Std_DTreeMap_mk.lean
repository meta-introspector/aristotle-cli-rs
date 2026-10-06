import Mathlib

-- spec: constructor Std.DTreeMap.mk : forall {α : Type.{u}} {β : α -> Type.{v}} {cmp : autoParam.{succ u} (α -> α -> Ordering) Std.DTreeMap._auto_1} (inner : Std.DTreeMap.Internal.Impl.{u, v} α β), (Std.DTreeMap.Internal.Impl.WF.{u, v} α (Ord.mk.{u} α cmp) β inner) -> (Std.DTreeMap.{u, v} α β cmp)
