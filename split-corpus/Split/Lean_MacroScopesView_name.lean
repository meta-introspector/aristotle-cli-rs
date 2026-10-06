import Mathlib

set_option pp.all true
-- spec: Lean.MacroScopesView.name : Lean.MacroScopesView -> Lean.Name
def Lean.MacroScopesView.name : Lean.MacroScopesView -> Lean.Name :=
  fun (self : Lean.MacroScopesView) => self.1
