import Mathlib

set_option pp.all true
-- spec: Std.DTreeMap.Internal.Impl.isEmpty : forall {α : Type.{u}} {β : α -> Type.{v}}, (Std.DTreeMap.Internal.Impl.{u, v} α β) -> Bool
def Std.DTreeMap.Internal.Impl.isEmpty : forall {α : Type.{u}} {β : α -> Type.{v}}, (Std.DTreeMap.Internal.Impl.{u, v} α β) -> Bool :=
  fun {α : Type.{u}} {β : α -> Type.{v}} (t : Std.DTreeMap.Internal.Impl.{u, v} α β) => Std.DTreeMap.Internal.Impl.contains.match_3.{u, v, 1} α β (fun (t._@.Std.Data.DTreeMap.Internal.Queries.2043245998._hygCtx._hyg.20 : Std.DTreeMap.Internal.Impl.{u, v} α β) => Bool) t (fun (_ : Unit) => Bool.true) (fun (size._@.Std.Data.DTreeMap.Internal.Queries.2043245998._hygCtx._hyg.41 : Nat) (k._@.Std.Data.DTreeMap.Internal.Queries.2043245998._hygCtx._hyg.42 : α) (v._@.Std.Data.DTreeMap.Internal.Queries.2043245998._hygCtx._hyg.43 : β k._@.Std.Data.DTreeMap.Internal.Queries.2043245998._hygCtx._hyg.42) (l._@.Std.Data.DTreeMap.Internal.Queries.2043245998._hygCtx._hyg.44 : Std.DTreeMap.Internal.Impl.{u, v} α β) (r._@.Std.Data.DTreeMap.Internal.Queries.2043245998._hygCtx._hyg.45 : Std.DTreeMap.Internal.Impl.{u, v} α β) => Bool.false)
