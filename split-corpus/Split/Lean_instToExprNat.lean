import Mathlib

set_option pp.all true
-- spec: Lean.instToExprNat : Lean.ToExpr.{0} Nat
def Lean.instToExprNat : Lean.ToExpr.{0} Nat :=
  Lean.ToExpr.mk.{0} Nat Lean.mkNatLit (Lean.mkConst (Lean.Name.mkStr1 "Nat") (List.nil.{0} Lean.Level))
