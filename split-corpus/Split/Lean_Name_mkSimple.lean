import Mathlib

set_option pp.all true
-- spec: Lean.Name.mkSimple : String -> Lean.Name
def Lean.Name.mkSimple : String -> Lean.Name :=
  fun (s : String) => Lean.Name.str Lean.Name.anonymous s
