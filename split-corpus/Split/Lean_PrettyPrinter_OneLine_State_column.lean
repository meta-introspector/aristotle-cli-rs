import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.OneLine.State.column : Lean.PrettyPrinter.OneLine.State -> Nat
def Lean.PrettyPrinter.OneLine.State.column : Lean.PrettyPrinter.OneLine.State -> Nat :=
  fun (self : Lean.PrettyPrinter.OneLine.State) => self.2
