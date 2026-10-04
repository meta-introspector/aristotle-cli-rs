import Mathlib

-- spec: constructor Std.Slice.Internal.SubarrayData.mk : forall {α : Type.{u}} (array : Array.{u} α) (start : Nat) (stop : Nat), (LE.le.{0} Nat instLENat start stop) -> (LE.le.{0} Nat instLENat stop (Array.size.{u} α array)) -> (Std.Slice.Internal.SubarrayData.{u} α)
