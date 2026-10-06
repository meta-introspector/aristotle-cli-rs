import Mathlib

set_option pp.all true
-- spec: Std.Slice.Internal.SubarrayData.stop : forall {α : Type.{u}}, (Std.Slice.Internal.SubarrayData.{u} α) -> Nat
def Std.Slice.Internal.SubarrayData.stop : forall {α : Type.{u}}, (Std.Slice.Internal.SubarrayData.{u} α) -> Nat :=
  fun (α : Type.{u}) (self : Std.Slice.Internal.SubarrayData.{u} α) => self.3
