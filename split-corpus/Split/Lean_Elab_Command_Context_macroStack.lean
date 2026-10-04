import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Command.Context.macroStack : Lean.Elab.Command.Context -> Lean.Elab.MacroStack
def Lean.Elab.Command.Context.macroStack : Lean.Elab.Command.Context -> Lean.Elab.MacroStack :=
  fun (self : Lean.Elab.Command.Context) => self.5
