import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Term.Context.macroStack : Lean.Elab.Term.Context -> Lean.Elab.MacroStack
def Lean.Elab.Term.Context.macroStack : Lean.Elab.Term.Context -> Lean.Elab.MacroStack :=
  fun (self : Lean.Elab.Term.Context) => self.2
