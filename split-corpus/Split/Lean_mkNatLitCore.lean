import Mathlib

set_option pp.all true
-- spec: Lean.mkNatLitCore : Lean.Expr -> Lean.Expr
def Lean.mkNatLitCore : Lean.Expr -> Lean.Expr :=
  fun (n : Lean.Expr) => Lean.mkApp3 (Lean.mkConst (Lean.Name.mkStr2 "OfNat" "ofNat") (List.cons.{0} Lean.Level Lean.levelZero (List.nil.{0} Lean.Level))) (Lean.mkConst (Lean.Name.mkStr1 "Nat") (List.nil.{0} Lean.Level)) n (Lean.mkInstOfNatNat n)
