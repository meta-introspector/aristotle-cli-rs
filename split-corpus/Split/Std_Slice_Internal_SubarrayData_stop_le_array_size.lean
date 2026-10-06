import Mathlib

-- spec: theorem Std.Slice.Internal.SubarrayData.stop_le_array_size : forall {α : Type.{u}} (self : Std.Slice.Internal.SubarrayData.{u} α), LE.le.{0} Nat instLENat (Std.Slice.Internal.SubarrayData.stop.{u} α self) (Array.size.{u} α (Std.Slice.Internal.SubarrayData.array.{u} α self))
theorem Std.Slice.Internal.SubarrayData.stop_le_array_size : forall {α : Type.{u}} (self : Std.Slice.Internal.SubarrayData.{u} α), LE.le.{0} Nat instLENat (Std.Slice.Internal.SubarrayData.stop.{u} α self) (Array.size.{u} α (Std.Slice.Internal.SubarrayData.array.{u} α self)) :=
  fun (α : Type.{u}) (self : Std.Slice.Internal.SubarrayData.{u} α) => self.5
