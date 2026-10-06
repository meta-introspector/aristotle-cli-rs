import Mathlib

set_option pp.all true
-- spec: Lean.EnvironmentHeader.moduleNames : Lean.EnvironmentHeader -> (Array.{0} Lean.Name)
def Lean.EnvironmentHeader.moduleNames : Lean.EnvironmentHeader -> (Array.{0} Lean.Name) :=
  fun (header : Lean.EnvironmentHeader) => Array.map.{0, 0} Lean.EffectiveImport Lean.Name (fun (x._@.Lean.Environment.3430995603._hygCtx._hyg.8 : Lean.EffectiveImport) => Lean.Import.module (Lean.EffectiveImport.toImport x._@.Lean.Environment.3430995603._hygCtx._hyg.8)) (Lean.EnvironmentHeader.modules header)
