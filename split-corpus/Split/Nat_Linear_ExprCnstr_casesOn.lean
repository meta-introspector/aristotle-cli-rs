import Mathlib

set_option pp.all true
-- spec: Nat.Linear.ExprCnstr.casesOn : forall {motive : Nat.Linear.ExprCnstr -> Sort.{u}} (t : Nat.Linear.ExprCnstr), (forall (eq : Bool) (lhs : Nat.Linear.Expr) (rhs : Nat.Linear.Expr), motive (Nat.Linear.ExprCnstr.mk eq lhs rhs)) -> (motive t)
def Nat.Linear.ExprCnstr.casesOn : forall {motive : Nat.Linear.ExprCnstr -> Sort.{u}} (t : Nat.Linear.ExprCnstr), (forall (eq : Bool) (lhs : Nat.Linear.Expr) (rhs : Nat.Linear.Expr), motive (Nat.Linear.ExprCnstr.mk eq lhs rhs)) -> (motive t) :=
  fun {motive : Nat.Linear.ExprCnstr -> Sort.{u}} (t : Nat.Linear.ExprCnstr) (mk : forall (eq : Bool) (lhs : Nat.Linear.Expr) (rhs : Nat.Linear.Expr), motive (Nat.Linear.ExprCnstr.mk eq lhs rhs)) => Nat.Linear.ExprCnstr.rec.{u} motive (fun (eq : Bool) (lhs : Nat.Linear.Expr) (rhs : Nat.Linear.Expr) => mk eq lhs rhs) t
