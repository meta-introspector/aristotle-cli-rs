import Mathlib

set_option pp.all true
-- spec: instHashableArray : forall {α : Type.{u_1}} [inst._@.Init.Data.Hashable.4010403423._hygCtx._hyg.5 : Hashable.{succ u_1} α], Hashable.{succ u_1} (Array.{u_1} α)
def instHashableArray : forall {α : Type.{u_1}} [inst._@.Init.Data.Hashable.4010403423._hygCtx._hyg.5 : Hashable.{succ u_1} α], Hashable.{succ u_1} (Array.{u_1} α) :=
  fun {α : Type.{u_1}} [inst._@.Init.Data.Hashable.4010403423._hygCtx._hyg.5 : Hashable.{succ u_1} α] => Hashable.mk.{succ u_1} (Array.{u_1} α) (fun (as : Array.{u_1} α) => Array.foldl.{u_1, 0} α UInt64 (fun (r : UInt64) (a : α) => mixHash r (Hashable.hash.{succ u_1} α inst._@.Init.Data.Hashable.4010403423._hygCtx._hyg.5 a)) (OfNat.ofNat.{0} UInt64 7 (UInt64.instOfNat 7)) as (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (Array.size.{u_1} α as))
