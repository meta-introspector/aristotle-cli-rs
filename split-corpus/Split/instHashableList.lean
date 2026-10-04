import Mathlib

set_option pp.all true
-- spec: instHashableList : forall {α : Type.{u_1}} [inst._@.Init.Data.Hashable.353630647._hygCtx._hyg.5 : Hashable.{succ u_1} α], Hashable.{succ u_1} (List.{u_1} α)
def instHashableList : forall {α : Type.{u_1}} [inst._@.Init.Data.Hashable.353630647._hygCtx._hyg.5 : Hashable.{succ u_1} α], Hashable.{succ u_1} (List.{u_1} α) :=
  fun {α : Type.{u_1}} [inst._@.Init.Data.Hashable.353630647._hygCtx._hyg.5 : Hashable.{succ u_1} α] => Hashable.mk.{succ u_1} (List.{u_1} α) (fun (as : List.{u_1} α) => List.foldl.{0, u_1} UInt64 α (fun (r : UInt64) (a : α) => mixHash r (Hashable.hash.{succ u_1} α inst._@.Init.Data.Hashable.353630647._hygCtx._hyg.5 a)) (OfNat.ofNat.{0} UInt64 7 (UInt64.instOfNat 7)) as)
