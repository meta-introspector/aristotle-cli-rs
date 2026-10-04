import Mathlib

set_option pp.all true
-- spec: instSliceableArrayNatSubarray_8 : forall {α : Type.{u}}, Std.Rii.Sliceable.{u, 0, u} (Array.{u} α) Nat (Subarray.{u} α)
def instSliceableArrayNatSubarray_8 : forall {α : Type.{u}}, Std.Rii.Sliceable.{u, 0, u} (Array.{u} α) Nat (Subarray.{u} α) :=
  fun {α : Type.{u}} => Std.Rii.Sliceable.mk.{u, 0, u} (Array.{u} α) Nat (Subarray.{u} α) (fun (xs : Array.{u} α) (x._@.Init.Data.Slice.Array.Basic.3010917045._hygCtx._hyg.21 : Std.Rii.{0} Nat) => Array.toSubarray.{u} α xs (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (Array.size.{u} α xs))
