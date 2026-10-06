import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.Delaborator.State.holeIter : Lean.PrettyPrinter.Delaborator.State -> Lean.PrettyPrinter.Delaborator.SubExpr.HoleIterator
def Lean.PrettyPrinter.Delaborator.State.holeIter : Lean.PrettyPrinter.Delaborator.State -> Lean.PrettyPrinter.Delaborator.SubExpr.HoleIterator :=
  fun (self : Lean.PrettyPrinter.Delaborator.State) => self.3
