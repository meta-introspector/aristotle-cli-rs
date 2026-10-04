import Mathlib

set_option pp.all true
-- spec: Lean.MacroScopesView.ctx : Lean.MacroScopesView -> Lean.Name
def Lean.MacroScopesView.ctx : Lean.MacroScopesView -> Lean.Name :=
  fun (self : Lean.MacroScopesView) => self.3
