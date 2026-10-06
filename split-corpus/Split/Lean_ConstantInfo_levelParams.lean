import Mathlib

set_option pp.all true
-- spec: Lean.ConstantInfo.levelParams : Lean.ConstantInfo -> (List.{0} Lean.Name)
def Lean.ConstantInfo.levelParams : Lean.ConstantInfo -> (List.{0} Lean.Name) :=
  fun (d : Lean.ConstantInfo) => Lean.ConstantVal.levelParams (Lean.ConstantInfo.toConstantVal d)
