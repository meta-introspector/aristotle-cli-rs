import Mathlib

set_option pp.all true
-- spec: Std.instToStreamArraySubarray : forall {α : Type.{u_1}}, Std.ToStream.{u_1} (Array.{u_1} α) (Subarray.{u_1} α)
def Std.instToStreamArraySubarray : forall {α : Type.{u_1}}, Std.ToStream.{u_1} (Array.{u_1} α) (Subarray.{u_1} α) :=
  fun {α : Type.{u_1}} => Std.ToStream.mk.{u_1} (Array.{u_1} α) (Subarray.{u_1} α) (fun (a : Array.{u_1} α) => Std.Rii.Sliceable.mkSlice.{u_1, 0, u_1} (Array.{u_1} α) Nat (Subarray.{u_1} α) (instSliceableArrayNatSubarray_8.{u_1} α) a (Std.Rii.mk.{0} Nat))
