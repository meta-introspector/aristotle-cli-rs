import Mathlib

set_option pp.all true
-- spec: Lean.Name.eraseMacroScopes : Lean.Name -> Lean.Name
def Lean.Name.eraseMacroScopes : Lean.Name -> Lean.Name :=
  fun (n : Lean.Name) => cond.match_1.{1} (fun (x._@.Init.Prelude.2631962155._hygCtx._hyg.7 : Bool) => Lean.Name) (Lean.Name.hasMacroScopes n) (fun (_ : Unit) => _private.Init.Prelude.0.Lean.eraseMacroScopesAux n) (fun (_ : Unit) => n)
