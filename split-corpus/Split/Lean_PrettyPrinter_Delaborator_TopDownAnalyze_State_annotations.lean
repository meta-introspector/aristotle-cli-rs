import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.Delaborator.TopDownAnalyze.State.annotations : Lean.PrettyPrinter.Delaborator.TopDownAnalyze.State -> Lean.PrettyPrinter.Delaborator.OptionsPerPos
def Lean.PrettyPrinter.Delaborator.TopDownAnalyze.State.annotations : Lean.PrettyPrinter.Delaborator.TopDownAnalyze.State -> Lean.PrettyPrinter.Delaborator.OptionsPerPos :=
  fun (self : Lean.PrettyPrinter.Delaborator.TopDownAnalyze.State) => self.1
