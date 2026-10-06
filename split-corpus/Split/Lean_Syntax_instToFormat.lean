import Mathlib

set_option pp.all true
-- spec: Lean.Syntax.instToFormat : Std.ToFormat.{0} Lean.Syntax
def Lean.Syntax.instToFormat : Std.ToFormat.{0} Lean.Syntax :=
  Std.ToFormat.mk.{0} Lean.Syntax (fun (stx : Lean.Syntax) => Lean.Syntax.formatStx stx (Option.none.{0} Nat) Bool.false)
