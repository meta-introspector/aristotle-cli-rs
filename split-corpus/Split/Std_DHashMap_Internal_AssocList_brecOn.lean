import Mathlib

set_option pp.all true
-- spec: Std.DHashMap.Internal.AssocList.brecOn : forall {α : Type.{u}} {β : α -> Type.{v}} {motive : (Std.DHashMap.Internal.AssocList.{v, u} α β) -> Sort.{u_1}} (t : Std.DHashMap.Internal.AssocList.{v, u} α β), (forall (t : Std.DHashMap.Internal.AssocList.{v, u} α β), (Std.DHashMap.Internal.AssocList.below.{u_1, v, u} α β motive t) -> (motive t)) -> (motive t)
def Std.DHashMap.Internal.AssocList.brecOn : forall {α : Type.{u}} {β : α -> Type.{v}} {motive : (Std.DHashMap.Internal.AssocList.{v, u} α β) -> Sort.{u_1}} (t : Std.DHashMap.Internal.AssocList.{v, u} α β), (forall (t : Std.DHashMap.Internal.AssocList.{v, u} α β), (Std.DHashMap.Internal.AssocList.below.{u_1, v, u} α β motive t) -> (motive t)) -> (motive t) :=
  fun {α : Type.{u}} {β : α -> Type.{v}} {motive : (Std.DHashMap.Internal.AssocList.{v, u} α β) -> Sort.{u_1}} (t : Std.DHashMap.Internal.AssocList.{v, u} α β) (F_1 : forall (t : Std.DHashMap.Internal.AssocList.{v, u} α β), (Std.DHashMap.Internal.AssocList.below.{u_1, v, u} α β motive t) -> (motive t)) => (Std.DHashMap.Internal.AssocList.brecOn.go.{u_1, v, u} α β motive t F_1).1
