import Mathlib

set_option pp.all true
-- spec: Expr.below : forall {motive : Expr -> Sort.{u}}, Expr -> Sort.{max 1 u}
def Expr.below : forall {motive : Expr -> Sort.{u}}, Expr -> Sort.{max 1 u} :=
  fun {motive : Expr -> Sort.{u}} (t : Expr) => Expr.rec.{succ (max 1 u)} (fun (t : Expr) => Sort.{max 1 u}) (fun (a._@._internal._hyg.0 : String) => PUnit.{max 1 u}) (fun (a._@._internal._hyg.0 : String) => PUnit.{max 1 u}) (fun (a._@._internal._hyg.0 : String) => PUnit.{max 1 u}) (fun (a._@._internal._hyg.0 : List.{0} (Prod.{0, 0} String Nat)) => PUnit.{max 1 u}) (fun (a._@._internal._hyg.0 : Expr) (a_ih._@._internal._hyg.0 : Sort.{max 1 u}) => PProd.{u, max 1 u} (motive a._@._internal._hyg.0) a_ih._@._internal._hyg.0) PUnit.{max 1 u} t
