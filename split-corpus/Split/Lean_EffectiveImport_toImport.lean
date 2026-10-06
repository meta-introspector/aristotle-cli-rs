import Mathlib

set_option pp.all true
-- spec: Lean.EffectiveImport.toImport : Lean.EffectiveImport -> Lean.Import
def Lean.EffectiveImport.toImport : Lean.EffectiveImport -> Lean.Import :=
  fun (self : Lean.EffectiveImport) => self.1
