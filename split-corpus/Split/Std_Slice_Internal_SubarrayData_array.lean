import Mathlib

set_option pp.all true
-- spec: Std.Slice.Internal.SubarrayData.array : forall {α : Type.{u}}, (Std.Slice.Internal.SubarrayData.{u} α) -> (Array.{u} α)
def Std.Slice.Internal.SubarrayData.array : forall {α : Type.{u}}, (Std.Slice.Internal.SubarrayData.{u} α) -> (Array.{u} α) :=
  fun (α : Type.{u}) (self : Std.Slice.Internal.SubarrayData.{u} α) => self.1
