import Mathlib

set_option pp.all true
-- spec: Subarray.start : forall {α : Type.{u_1}}, (Subarray.{u_1} α) -> Nat
def Subarray.start : forall {α : Type.{u_1}}, (Subarray.{u_1} α) -> Nat :=
  fun {α : Type.{u_1}} (xs : Subarray.{u_1} α) => Std.Slice.Internal.SubarrayData.start.{u_1} α (Std.Slice.internalRepresentation.{u_1} (Std.Slice.Internal.SubarrayData.{u_1} α) xs)
