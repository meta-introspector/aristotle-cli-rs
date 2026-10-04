import Mathlib

set_option pp.all true
-- spec: Lean.Core.Context.currMacroScope : Lean.Core.Context -> Lean.MacroScope
def Lean.Core.Context.currMacroScope : Lean.Core.Context -> Lean.MacroScope :=
  fun (self : Lean.Core.Context) => self.12
