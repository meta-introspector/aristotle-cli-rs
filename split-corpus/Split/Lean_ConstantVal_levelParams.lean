import Mathlib

set_option pp.all true
-- spec: Lean.ConstantVal.levelParams : Lean.ConstantVal -> (List.{0} Lean.Name)
def Lean.ConstantVal.levelParams : Lean.ConstantVal -> (List.{0} Lean.Name) :=
  fun (self : Lean.ConstantVal) => self.2
