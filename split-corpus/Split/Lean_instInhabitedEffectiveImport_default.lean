import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedEffectiveImport.default : Lean.EffectiveImport
def Lean.instInhabitedEffectiveImport.default : Lean.EffectiveImport :=
  Lean.EffectiveImport.mk (Inhabited.default.{1} Lean.Import Lean.instInhabitedImport) (Inhabited.default.{1} Lean.IRPhases Lean.instInhabitedIRPhases)
