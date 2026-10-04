import Mathlib

set_option pp.all true
-- spec: Lean.eagerReflBoolTrue : Lean.Expr
def Lean.eagerReflBoolTrue : Lean.Expr :=
  Lean.mkApp2 (Lean.mkConst (Lean.Name.mkStr1 "eagerReduce") (List.cons.{0} Lean.Level (OfNat.ofNat.{0} Lean.Level 0 (Lean.Level.instOfNat 0)) (List.nil.{0} Lean.Level))) (Lean.mkApp3 (Lean.mkConst (Lean.Name.mkStr1 "Eq") (List.cons.{0} Lean.Level (OfNat.ofNat.{0} Lean.Level 1 (Lean.Level.instOfNat 1)) (List.nil.{0} Lean.Level))) (Lean.mkConst (Lean.Name.mkStr1 "Bool") (List.nil.{0} Lean.Level)) (Lean.mkConst (Lean.Name.mkStr2 "Bool" "true") (List.nil.{0} Lean.Level)) (Lean.mkConst (Lean.Name.mkStr2 "Bool" "true") (List.nil.{0} Lean.Level))) Lean.reflBoolTrue
