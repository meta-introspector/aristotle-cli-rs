import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.Delaborator.Context.optionsPerPos : Lean.PrettyPrinter.Delaborator.Context -> Lean.PrettyPrinter.Delaborator.OptionsPerPos
def Lean.PrettyPrinter.Delaborator.Context.optionsPerPos : Lean.PrettyPrinter.Delaborator.Context -> Lean.PrettyPrinter.Delaborator.OptionsPerPos :=
  fun (self : Lean.PrettyPrinter.Delaborator.Context) => self.1
