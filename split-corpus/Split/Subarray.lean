import Mathlib

set_option pp.all true
-- spec: Subarray : Type.{u} -> Type.{u}
def Subarray : Type.{u} -> Type.{u} :=
  fun (α : Type.{u}) => Std.Slice.{u} (Std.Slice.Internal.SubarrayData.{u} α)
