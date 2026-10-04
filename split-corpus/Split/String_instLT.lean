import Mathlib

set_option pp.all true
-- spec: String.instLT : LT.{0} String
def String.instLT : LT.{0} String :=
  LT.mk.{0} String (fun (s₁ : String) (s₂ : String) => LT.lt.{0} (List.{0} Char) (List.instLT.{0} Char Char.instLT) (String.toList s₁) (String.toList s₂))
