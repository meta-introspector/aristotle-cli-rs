import Mathlib

set_option pp.all true
-- spec: Std.DHashMap.Internal.Raw₀ : forall (α : Type.{u}), (α -> Type.{v}) -> Sort.{max 1 (succ u) (succ v)}
def Std.DHashMap.Internal.Raw₀ : forall (α : Type.{u}), (α -> Type.{v}) -> Sort.{max 1 (succ u) (succ v)} :=
  fun (α : Type.{u}) (β : α -> Type.{v}) => Subtype.{max (succ u) (succ v)} (Std.DHashMap.Raw.{u, v} α β) (fun (m : Std.DHashMap.Raw.{u, v} α β) => LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (Array.size.{max u v} (Std.DHashMap.Internal.AssocList.{v, u} α β) (Std.DHashMap.Raw.buckets.{u, v} α β m)))
