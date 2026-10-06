import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Command.Context.currMacroScope : Lean.Elab.Command.Context -> Lean.MacroScope
def Lean.Elab.Command.Context.currMacroScope : Lean.Elab.Command.Context -> Lean.MacroScope :=
  fun (self : Lean.Elab.Command.Context) => self.7
