import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.Delaborator.Context.openDecls : Lean.PrettyPrinter.Delaborator.Context -> (List.{0} Lean.OpenDecl)
def Lean.PrettyPrinter.Delaborator.Context.openDecls : Lean.PrettyPrinter.Delaborator.Context -> (List.{0} Lean.OpenDecl) :=
  fun (self : Lean.PrettyPrinter.Delaborator.Context) => self.3
