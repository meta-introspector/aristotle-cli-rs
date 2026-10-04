import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.OneLine.State.line : Lean.PrettyPrinter.OneLine.State -> Std.Format
def Lean.PrettyPrinter.OneLine.State.line : Lean.PrettyPrinter.OneLine.State -> Std.Format :=
  fun (self : Lean.PrettyPrinter.OneLine.State) => self.1
