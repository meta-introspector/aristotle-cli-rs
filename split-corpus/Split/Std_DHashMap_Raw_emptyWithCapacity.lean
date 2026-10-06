import Mathlib

set_option pp.all true
-- spec: Std.DHashMap.Raw.emptyWithCapacity : forall {α : Type.{u}} {β : α -> Type.{v}}, (optParam.{1} Nat (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) -> (Std.DHashMap.Raw.{u, v} α β)
def Std.DHashMap.Raw.emptyWithCapacity : forall {α : Type.{u}} {β : α -> Type.{v}}, (optParam.{1} Nat (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) -> (Std.DHashMap.Raw.{u, v} α β) :=
  fun {α : Type.{u}} {β : α -> Type.{v}} (capacity : Nat) => Subtype.val.{max (succ v) (succ u)} (Std.DHashMap.Raw.{u, v} α β) (fun (m : Std.DHashMap.Raw.{u, v} α β) => LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (Array.size.{max u v} (Std.DHashMap.Internal.AssocList.{v, u} α β) (Std.DHashMap.Raw.buckets.{u, v} α β m))) (Std.DHashMap.Internal.Raw₀.emptyWithCapacity.{u, v} α β capacity)
