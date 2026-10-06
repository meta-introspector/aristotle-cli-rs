import Mathlib

set_option pp.all true
-- spec: InductiveFunction.ctorIdx : InductiveFunction -> Nat
def InductiveFunction.ctorIdx : InductiveFunction -> Nat :=
  fun (x : InductiveFunction) => InductiveFunction.casesOn.{1} (fun (x : InductiveFunction) => Nat) x (fun (a._@._internal._hyg.0 : Expr -> InductiveFunction) => 0) (fun (a._@._internal._hyg.0 : Expr -> InductiveFunction) => 1) (fun (a._@._internal._hyg.0 : Expr -> InductiveFunction) => 2)
