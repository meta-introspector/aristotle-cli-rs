import Mathlib

set_option pp.all true
-- spec: Lean.Name.mkStr2 : String -> String -> Lean.Name
def Lean.Name.mkStr2 : String -> String -> Lean.Name :=
  fun (s₁ : String) (s₂ : String) => Lean.Name.str (Lean.Name.str Lean.Name.anonymous s₁) s₂
