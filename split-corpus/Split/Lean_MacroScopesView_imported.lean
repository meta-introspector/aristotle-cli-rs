import Mathlib

set_option pp.all true
-- spec: Lean.MacroScopesView.imported : Lean.MacroScopesView -> Lean.Name
def Lean.MacroScopesView.imported : Lean.MacroScopesView -> Lean.Name :=
  fun (self : Lean.MacroScopesView) => self.2
