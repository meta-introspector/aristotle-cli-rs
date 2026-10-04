import Mathlib

set_option pp.all true
-- spec: Subarray.stop : forall {α : Type.{u_1}}, (Subarray.{u_1} α) -> Nat
def Subarray.stop : forall {α : Type.{u_1}}, (Subarray.{u_1} α) -> Nat :=
  fun {α : Type.{u_1}} (xs : Subarray.{u_1} α) => Std.Slice.Internal.SubarrayData.stop.{u_1} α (Std.Slice.internalRepresentation.{u_1} (Std.Slice.Internal.SubarrayData.{u_1} α) xs)
