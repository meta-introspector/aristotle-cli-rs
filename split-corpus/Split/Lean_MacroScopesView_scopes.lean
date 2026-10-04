import Mathlib

set_option pp.all true
-- spec: Lean.MacroScopesView.scopes : Lean.MacroScopesView -> (List.{0} Lean.MacroScope)
def Lean.MacroScopesView.scopes : Lean.MacroScopesView -> (List.{0} Lean.MacroScope) :=
  fun (self : Lean.MacroScopesView) => self.4
