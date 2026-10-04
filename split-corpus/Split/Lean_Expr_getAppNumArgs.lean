import Mathlib

set_option pp.all true
-- spec: Lean.Expr.getAppNumArgs : Lean.Expr -> Nat
def Lean.Expr.getAppNumArgs : Lean.Expr -> Nat :=
  fun (e : Lean.Expr) => _private.Lean.Expr.0.Lean.Expr.getAppNumArgsAux e (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))
