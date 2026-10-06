import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedImport : Inhabited.{1} Lean.Import
def Lean.instInhabitedImport : Inhabited.{1} Lean.Import :=
  Inhabited.mk.{1} Lean.Import Lean.instInhabitedImport.default
