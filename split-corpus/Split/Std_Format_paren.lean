import Mathlib

set_option pp.all true
-- spec: Std.Format.paren : Std.Format -> Std.Format
def Std.Format.paren : Std.Format -> Std.Format :=
  fun (f : Std.Format) => Std.Format.bracket "(" f ")"
