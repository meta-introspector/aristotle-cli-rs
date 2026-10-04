import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.Delaborator.Context.currNamespace : Lean.PrettyPrinter.Delaborator.Context -> Lean.Name
def Lean.PrettyPrinter.Delaborator.Context.currNamespace : Lean.PrettyPrinter.Delaborator.Context -> Lean.Name :=
  fun (self : Lean.PrettyPrinter.Delaborator.Context) => self.2
