import Mathlib

set_option pp.all true
-- spec: Lean.Expr.getAppArgs : Lean.Expr -> (Array.{0} Lean.Expr)
def Lean.Expr.getAppArgs : Lean.Expr -> (Array.{0} Lean.Expr) :=
  fun (e : Lean.Expr) => have dummy : Lean.Expr := Lean.mkSort Lean.levelZero; have nargs : Nat := Lean.Expr.getAppNumArgs e; _private.Lean.Expr.0.Lean.Expr.getAppArgsAux e (Array.replicate.{0} Lean.Expr nargs dummy) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) nargs (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))
