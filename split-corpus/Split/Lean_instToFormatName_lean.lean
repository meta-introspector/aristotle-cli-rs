import Mathlib

set_option pp.all true
-- spec: Lean.instToFormatName_lean : Std.ToFormat.{0} Lean.Name
def Lean.instToFormatName_lean : Std.ToFormat.{0} Lean.Name :=
  Std.ToFormat.mk.{0} Lean.Name (fun (n : Lean.Name) => Std.Format.text (Lean.Name.toString n Bool.true))
