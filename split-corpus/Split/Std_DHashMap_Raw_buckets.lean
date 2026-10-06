import Mathlib

set_option pp.all true
-- spec: Std.DHashMap.Raw.buckets : forall {α : Type.{u}} {β : α -> Type.{v}}, (Std.DHashMap.Raw.{u, v} α β) -> (Array.{max u v} (Std.DHashMap.Internal.AssocList.{v, u} α β))
def Std.DHashMap.Raw.buckets : forall {α : Type.{u}} {β : α -> Type.{v}}, (Std.DHashMap.Raw.{u, v} α β) -> (Array.{max u v} (Std.DHashMap.Internal.AssocList.{v, u} α β)) :=
  fun (α : Type.{u}) (β : α -> Type.{v}) (self : Std.DHashMap.Raw.{u, v} α β) => self.2
