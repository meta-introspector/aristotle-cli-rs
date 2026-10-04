import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.Formatter.State.stack : Lean.PrettyPrinter.Formatter.State -> (Array.{0} Std.Format)
def Lean.PrettyPrinter.Formatter.State.stack : Lean.PrettyPrinter.Formatter.State -> (Array.{0} Std.Format) :=
  fun (self : Lean.PrettyPrinter.Formatter.State) => self.6
