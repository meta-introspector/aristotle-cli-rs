import Mathlib

set_option pp.all true
-- spec: Lean.rootNamespace : Lean.Name
def Lean.rootNamespace : Lean.Name :=
  Lean.Name.mkStr1 "_root_"
