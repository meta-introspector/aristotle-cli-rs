import Mathlib

set_option pp.all true
-- spec: Lean.mkInstOfNatNat : Lean.Expr -> Lean.Expr
def Lean.mkInstOfNatNat : Lean.Expr -> Lean.Expr :=
  fun (n : Lean.Expr) => Lean.mkApp (Lean.mkConst (Lean.Name.mkStr1 "instOfNatNat") (List.nil.{0} Lean.Level)) n
