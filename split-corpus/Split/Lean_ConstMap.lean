import Mathlib

set_option pp.all true
-- spec: Lean.ConstMap : Type
def Lean.ConstMap : Type :=
  Lean.SMap.{0, 0} Lean.Name Lean.ConstantInfo Lean.Name.instBEq Lean.instHashableName
