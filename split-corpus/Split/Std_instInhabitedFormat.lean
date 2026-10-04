import Mathlib

set_option pp.all true
-- spec: Std.instInhabitedFormat : Inhabited.{1} Std.Format
def Std.instInhabitedFormat : Inhabited.{1} Std.Format :=
  Inhabited.mk.{1} Std.Format Std.instInhabitedFormat.default
