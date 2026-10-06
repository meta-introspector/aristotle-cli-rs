import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.Delaborator.Context.subExpr : Lean.PrettyPrinter.Delaborator.Context -> Lean.SubExpr
def Lean.PrettyPrinter.Delaborator.Context.subExpr : Lean.PrettyPrinter.Delaborator.Context -> Lean.SubExpr :=
  fun (self : Lean.PrettyPrinter.Delaborator.Context) => self.5
