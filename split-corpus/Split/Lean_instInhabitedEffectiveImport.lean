import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedEffectiveImport : Inhabited.{1} Lean.EffectiveImport
def Lean.instInhabitedEffectiveImport : Inhabited.{1} Lean.EffectiveImport :=
  Inhabited.mk.{1} Lean.EffectiveImport Lean.instInhabitedEffectiveImport.default
