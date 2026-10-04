import Mathlib

set_option pp.all true
-- spec: String.Slice.instToFormat : Std.ToFormat.{0} String.Slice
def String.Slice.instToFormat : Std.ToFormat.{0} String.Slice :=
  Std.ToFormat.mk.{0} String.Slice (fun (s : String.Slice) => Std.ToFormat.format.{0} String Std.instToFormatString (String.Slice.copy s))
