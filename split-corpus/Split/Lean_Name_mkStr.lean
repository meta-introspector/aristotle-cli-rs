import Mathlib

set_option pp.all true
-- spec: Lean.Name.mkStr : Lean.Name -> String -> Lean.Name
def Lean.Name.mkStr : Lean.Name -> String -> Lean.Name :=
  fun (p : Lean.Name) (s : String) => Lean.Name.str p s
