import Mathlib

set_option pp.all true
-- spec: Lean.kindOfErrorName : Lean.Name -> Lean.Name
def Lean.kindOfErrorName : Lean.Name -> Lean.Name :=
  fun (errorName : Lean.Name) => Lean.Name.str errorName Lean.errorNameSuffix
