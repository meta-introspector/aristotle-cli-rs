import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.Delaborator.Context.depth : Lean.PrettyPrinter.Delaborator.Context -> Nat
def Lean.PrettyPrinter.Delaborator.Context.depth : Lean.PrettyPrinter.Delaborator.Context -> Nat :=
  fun (self : Lean.PrettyPrinter.Delaborator.Context) => self.6
