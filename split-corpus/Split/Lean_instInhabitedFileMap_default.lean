import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedFileMap.default : Lean.FileMap
def Lean.instInhabitedFileMap.default : Lean.FileMap :=
  Lean.FileMap.mk (Inhabited.default.{1} String String.instInhabited) (Inhabited.default.{1} (Array.{0} String.Pos.Raw) (Array.instInhabited.{0} String.Pos.Raw))
