import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.Delaborator.State.steps : Lean.PrettyPrinter.Delaborator.State -> Nat
def Lean.PrettyPrinter.Delaborator.State.steps : Lean.PrettyPrinter.Delaborator.State -> Nat :=
  fun (self : Lean.PrettyPrinter.Delaborator.State) => self.1
