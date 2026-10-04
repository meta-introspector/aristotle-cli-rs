import Mathlib

set_option pp.all true
-- spec: Std.DTreeMap.inner : forall {α : Type.{u}} {β : α -> Type.{v}} {cmp : autoParam.{succ u} (α -> α -> Ordering) Std.DTreeMap._auto_1}, (Std.DTreeMap.{u, v} α β cmp) -> (Std.DTreeMap.Internal.Impl.{u, v} α β)
def Std.DTreeMap.inner : forall {α : Type.{u}} {β : α -> Type.{v}} {cmp : autoParam.{succ u} (α -> α -> Ordering) Std.DTreeMap._auto_1}, (Std.DTreeMap.{u, v} α β cmp) -> (Std.DTreeMap.Internal.Impl.{u, v} α β) :=
  fun (α : Type.{u}) (β : α -> Type.{v}) (cmp : autoParam.{succ u} (α -> α -> Ordering) Std.DTreeMap._auto_1) (self : Std.DTreeMap.{u, v} α β cmp) => self.1
