import Mathlib

set_option pp.all true
-- spec: Std.Format.fill : Std.Format -> Std.Format
def Std.Format.fill : Std.Format -> Std.Format :=
  fun (f : Std.Format) => Std.Format.group f Std.Format.FlattenBehavior.fill
