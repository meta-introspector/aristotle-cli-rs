import Mathlib

set_option pp.all true
-- spec: Std.instToFormatFormat : Std.ToFormat.{0} Std.Format
def Std.instToFormatFormat : Std.ToFormat.{0} Std.Format :=
  Std.ToFormat.mk.{0} Std.Format (fun (f : Std.Format) => f)
