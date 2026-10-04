import Mathlib

set_option pp.all true
-- spec: Lean.FileMap.positions : Lean.FileMap -> (Array.{0} String.Pos.Raw)
def Lean.FileMap.positions : Lean.FileMap -> (Array.{0} String.Pos.Raw) :=
  fun (self : Lean.FileMap) => self.2
