import Mathlib

set_option pp.all true
-- spec: Lean.AliasState : Type
def Lean.AliasState : Type :=
  Lean.SMap.{0, 0} Lean.Name (List.{0} Lean.Name) Lean.Name.instBEq Lean.instHashableName
