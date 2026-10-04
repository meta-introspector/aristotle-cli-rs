import Mathlib

set_option pp.all true
-- spec: Lean.reflBoolTrue : Lean.Expr
def Lean.reflBoolTrue : Lean.Expr :=
  Lean.mkApp2 (Lean.mkConst (Lean.Name.mkStr2 "Eq" "refl") (List.cons.{0} Lean.Level Lean.levelOne (List.nil.{0} Lean.Level))) (Lean.mkConst (Lean.Name.mkStr1 "Bool") (List.nil.{0} Lean.Level)) (Lean.mkConst (Lean.Name.mkStr2 "Bool" "true") (List.nil.{0} Lean.Level))
