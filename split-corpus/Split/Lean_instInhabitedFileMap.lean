import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedFileMap : Inhabited.{1} Lean.FileMap
def Lean.instInhabitedFileMap : Inhabited.{1} Lean.FileMap :=
  Inhabited.mk.{1} Lean.FileMap Lean.instInhabitedFileMap.default
