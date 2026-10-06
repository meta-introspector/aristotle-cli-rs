import Mathlib

set_option pp.all true
-- spec: Lean.Elab.MacroStackElem.after : Lean.Elab.MacroStackElem -> Lean.Syntax
def Lean.Elab.MacroStackElem.after : Lean.Elab.MacroStackElem -> Lean.Syntax :=
  fun (self : Lean.Elab.MacroStackElem) => self.2
