import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.Delaborator.Context.inPattern : Lean.PrettyPrinter.Delaborator.Context -> Bool
def Lean.PrettyPrinter.Delaborator.Context.inPattern : Lean.PrettyPrinter.Delaborator.Context -> Bool :=
  fun (self : Lean.PrettyPrinter.Delaborator.Context) => self.4
