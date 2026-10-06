import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.Formatter.State.isUngrouped : Lean.PrettyPrinter.Formatter.State -> Bool
def Lean.PrettyPrinter.Formatter.State.isUngrouped : Lean.PrettyPrinter.Formatter.State -> Bool :=
  fun (self : Lean.PrettyPrinter.Formatter.State) => self.4
