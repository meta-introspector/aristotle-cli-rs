import Mathlib

set_option pp.all true
-- spec: Lean.ConstantInfo.name : Lean.ConstantInfo -> Lean.Name
def Lean.ConstantInfo.name : Lean.ConstantInfo -> Lean.Name :=
  fun (d : Lean.ConstantInfo) => Lean.ConstantVal.name (Lean.ConstantInfo.toConstantVal d)
