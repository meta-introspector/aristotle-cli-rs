import Mathlib

set_option pp.all true
-- spec: Lean.Name.mkStr3 : String -> String -> String -> Lean.Name
def Lean.Name.mkStr3 : String -> String -> String -> Lean.Name :=
  fun (s₁ : String) (s₂ : String) (s₃ : String) => Lean.Name.str (Lean.Name.str (Lean.Name.str Lean.Name.anonymous s₁) s₂) s₃
