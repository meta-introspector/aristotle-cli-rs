import Mathlib

set_option pp.all true
-- spec: Lean.Expr.getArg! : forall (e : Lean.Expr), Nat -> (optParam.{1} Nat (Lean.Expr.getAppNumArgs e)) -> Lean.Expr
def Lean.Expr.getArg! : forall (e : Lean.Expr), Nat -> (optParam.{1} Nat (Lean.Expr.getAppNumArgs e)) -> Lean.Expr :=
  fun (e : Lean.Expr) (i : Nat) (n : Nat) => Lean.Expr.getRevArg! e (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) n i) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))
