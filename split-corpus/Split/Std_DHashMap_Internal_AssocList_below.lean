import Mathlib

set_option pp.all true
-- spec: Std.DHashMap.Internal.AssocList.below : forall {α : Type.{u}} {β : α -> Type.{v}} {motive : (Std.DHashMap.Internal.AssocList.{v, u} α β) -> Sort.{u_1}}, (Std.DHashMap.Internal.AssocList.{v, u} α β) -> Sort.{max (max (succ u) (succ v)) u_1}
def Std.DHashMap.Internal.AssocList.below : forall {α : Type.{u}} {β : α -> Type.{v}} {motive : (Std.DHashMap.Internal.AssocList.{v, u} α β) -> Sort.{u_1}}, (Std.DHashMap.Internal.AssocList.{v, u} α β) -> Sort.{max (max (succ u) (succ v)) u_1} :=
  fun {α : Type.{u}} {β : α -> Type.{v}} {motive : (Std.DHashMap.Internal.AssocList.{v, u} α β) -> Sort.{u_1}} (t : Std.DHashMap.Internal.AssocList.{v, u} α β) => Std.DHashMap.Internal.AssocList.rec.{succ (max (max (succ u) (succ v)) u_1), v, u} α β (fun (t : Std.DHashMap.Internal.AssocList.{v, u} α β) => Sort.{max (max (succ u) (succ v)) u_1}) PUnit.{max (max (succ u) (succ v)) u_1} (fun (key : α) (value : β key) (tail : Std.DHashMap.Internal.AssocList.{v, u} α β) (tail_ih : Sort.{max (max (succ u) (succ v)) u_1}) => PProd.{u_1, max (max (succ u) (succ v)) u_1} (motive tail) tail_ih) t
