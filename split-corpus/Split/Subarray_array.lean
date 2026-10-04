import Mathlib

set_option pp.all true
-- spec: Subarray.array : forall {α : Type.{u_1}}, (Subarray.{u_1} α) -> (Array.{u_1} α)
def Subarray.array : forall {α : Type.{u_1}}, (Subarray.{u_1} α) -> (Array.{u_1} α) :=
  fun {α : Type.{u_1}} (xs : Subarray.{u_1} α) => Std.Slice.Internal.SubarrayData.array.{u_1} α (Std.Slice.internalRepresentation.{u_1} (Std.Slice.Internal.SubarrayData.{u_1} α) xs)
