import Mathlib

set_option pp.all true
-- spec: Lean.Meta.mkSmartUnfoldingNameFor : Lean.Name -> Lean.Name
def Lean.Meta.mkSmartUnfoldingNameFor : Lean.Name -> Lean.Name :=
  fun (declName : Lean.Name) => Lean.Name.mkStr declName Lean.Meta.smartUnfoldingSuffix
