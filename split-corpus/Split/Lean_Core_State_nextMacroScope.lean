import Mathlib

set_option pp.all true
-- spec: Lean.Core.State.nextMacroScope : Lean.Core.State -> Lean.MacroScope
def Lean.Core.State.nextMacroScope : Lean.Core.State -> Lean.MacroScope :=
  fun (self : Lean.Core.State) => self.2
