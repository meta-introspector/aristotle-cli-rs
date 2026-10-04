import Mathlib

set_option pp.all true
-- spec: Lean.Elab.MacroStack : Type
def Lean.Elab.MacroStack : Type :=
  List.{0} Lean.Elab.MacroStackElem
