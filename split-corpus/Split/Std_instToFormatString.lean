import Mathlib

set_option pp.all true
-- spec: Std.instToFormatString : Std.ToFormat.{0} String
def Std.instToFormatString : Std.ToFormat.{0} String :=
  Std.ToFormat.mk.{0} String (fun (s : String) => Std.Format.text s)
