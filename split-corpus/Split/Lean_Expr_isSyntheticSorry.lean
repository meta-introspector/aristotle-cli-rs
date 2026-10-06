import Mathlib

set_option pp.all true
-- spec: Lean.Expr.isSyntheticSorry : Lean.Expr -> Bool
def Lean.Expr.isSyntheticSorry : Lean.Expr -> Bool :=
  fun (e : Lean.Expr) => Bool.and (Bool.and (Lean.Expr.isAppOf e (Lean.Name.mkStr1 "sorryAx")) (Decidable.decide (GE.ge.{0} Nat instLENat (Lean.Expr.getAppNumArgs e) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2))) (Nat.decLe (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) (Lean.Expr.getAppNumArgs e)))) (Lean.Expr.isConstOf (Lean.Expr.getArg! e (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (Lean.Expr.getAppNumArgs e)) (Lean.Name.mkStr2 "Bool" "true"))
