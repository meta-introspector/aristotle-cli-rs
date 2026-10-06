import Mathlib

set_option pp.all true
-- spec: Lean.extractMacroScopes : Lean.Name -> Lean.MacroScopesView
def Lean.extractMacroScopes : Lean.Name -> Lean.MacroScopesView :=
  fun (n : Lean.Name) => cond.match_1.{1} (fun (x._@.Init.Prelude.3056925386._hygCtx._hyg.7 : Bool) => Lean.MacroScopesView) (Lean.Name.hasMacroScopes n) (fun (_ : Unit) => _private.Init.Prelude.0.Lean.extractMacroScopesAux n (List.nil.{0} Lean.MacroScope)) (fun (_ : Unit) => Lean.MacroScopesView.mk n Lean.Name.anonymous Lean.Name.anonymous (List.nil.{0} Lean.MacroScope))
