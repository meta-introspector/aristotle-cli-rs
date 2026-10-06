import Mathlib

set_option pp.all true
-- spec: Expr.ctorIdx : Expr -> Nat
def Expr.ctorIdx : Expr -> Nat :=
  fun (x : Expr) => Expr.casesOn.{1} (fun (x : Expr) => Nat) x (fun (a._@._internal._hyg.0 : String) => 0) (fun (a._@._internal._hyg.0 : String) => 1) (fun (a._@._internal._hyg.0 : String) => 2) (fun (a._@._internal._hyg.0 : List.{0} (Prod.{0, 0} String Nat)) => 3) (fun (a._@._internal._hyg.0 : Expr) => 4) 5
