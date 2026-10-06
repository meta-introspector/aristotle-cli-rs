import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedImport.default : Lean.Import
def Lean.instInhabitedImport.default : Lean.Import :=
  Lean.Import.mk (Inhabited.default.{1} Lean.Name Lean.instInhabitedName) (Inhabited.default.{1} Bool instInhabitedBool) (Inhabited.default.{1} Bool instInhabitedBool) (Inhabited.default.{1} Bool instInhabitedBool)
