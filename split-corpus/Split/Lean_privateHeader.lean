import Mathlib

set_option pp.all true
-- spec: Lean.privateHeader : Lean.Name
def Lean.privateHeader : Lean.Name :=
  Lean.Name.mkStr1 "_private"
