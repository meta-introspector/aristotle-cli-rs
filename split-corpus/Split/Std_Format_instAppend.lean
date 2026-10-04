import Mathlib

set_option pp.all true
-- spec: Std.Format.instAppend : Append.{0} Std.Format
def Std.Format.instAppend : Append.{0} Std.Format :=
  Append.mk.{0} Std.Format Std.Format.append
