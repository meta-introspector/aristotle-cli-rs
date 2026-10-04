import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.Formatter.Context.options : Lean.PrettyPrinter.Formatter.Context -> Lean.Options
def Lean.PrettyPrinter.Formatter.Context.options : Lean.PrettyPrinter.Formatter.Context -> Lean.Options :=
  fun (self : Lean.PrettyPrinter.Formatter.Context) => self.1
