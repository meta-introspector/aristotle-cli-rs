import Mathlib

set_option pp.all true
-- spec: Lean.ConstantVal.name : Lean.ConstantVal -> Lean.Name
def Lean.ConstantVal.name : Lean.ConstantVal -> Lean.Name :=
  fun (self : Lean.ConstantVal) => self.1
