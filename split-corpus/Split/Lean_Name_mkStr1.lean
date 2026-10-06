import Mathlib

set_option pp.all true
-- spec: Lean.Name.mkStr1 : String -> Lean.Name
def Lean.Name.mkStr1 : String -> Lean.Name :=
  fun (s₁ : String) => Lean.Name.str Lean.Name.anonymous s₁
