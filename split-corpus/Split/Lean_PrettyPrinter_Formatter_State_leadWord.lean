import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.Formatter.State.leadWord : Lean.PrettyPrinter.Formatter.State -> String
def Lean.PrettyPrinter.Formatter.State.leadWord : Lean.PrettyPrinter.Formatter.State -> String :=
  fun (self : Lean.PrettyPrinter.Formatter.State) => self.2
