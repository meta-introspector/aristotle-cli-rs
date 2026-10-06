import Mathlib

set_option pp.all true
-- spec: Lean.ResolveName.resolveGlobalName : Lean.Environment -> Lean.Options -> Lean.Name -> (List.{0} Lean.OpenDecl) -> Lean.Name -> (List.{0} (Prod.{0, 0} Lean.Name (List.{0} String)))
def Lean.ResolveName.resolveGlobalName : Lean.Environment -> Lean.Options -> Lean.Name -> (List.{0} Lean.OpenDecl) -> Lean.Name -> (List.{0} (Prod.{0, 0} Lean.Name (List.{0} String))) :=
  fun (env : Lean.Environment) (opts : Lean.Options) (ns : Lean.Name) (openDecls : List.{0} Lean.OpenDecl) (id : Lean.Name) => have extractionResult : Lean.MacroScopesView := Lean.extractMacroScopes id; _private.Lean.ResolveName.0.Lean.ResolveName.resolveGlobalName.loop env opts ns openDecls extractionResult (Lean.MacroScopesView.name extractionResult) (List.nil.{0} String)
