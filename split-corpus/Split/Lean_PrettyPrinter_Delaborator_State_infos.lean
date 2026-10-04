import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.Delaborator.State.infos : Lean.PrettyPrinter.Delaborator.State -> (Lean.SubExpr.PosMap.{0} Lean.Elab.Info)
def Lean.PrettyPrinter.Delaborator.State.infos : Lean.PrettyPrinter.Delaborator.State -> (Lean.SubExpr.PosMap.{0} Lean.Elab.Info) :=
  fun (self : Lean.PrettyPrinter.Delaborator.State) => self.2
