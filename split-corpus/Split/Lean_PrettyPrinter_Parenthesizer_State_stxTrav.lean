import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.Parenthesizer.State.stxTrav : Lean.PrettyPrinter.Parenthesizer.State -> Lean.Syntax.Traverser
def Lean.PrettyPrinter.Parenthesizer.State.stxTrav : Lean.PrettyPrinter.Parenthesizer.State -> Lean.Syntax.Traverser :=
  fun (self : Lean.PrettyPrinter.Parenthesizer.State) => self.1
