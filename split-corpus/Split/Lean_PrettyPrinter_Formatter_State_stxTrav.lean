import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.Formatter.State.stxTrav : Lean.PrettyPrinter.Formatter.State -> Lean.Syntax.Traverser
def Lean.PrettyPrinter.Formatter.State.stxTrav : Lean.PrettyPrinter.Formatter.State -> Lean.Syntax.Traverser :=
  fun (self : Lean.PrettyPrinter.Formatter.State) => self.1
