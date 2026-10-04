import Mathlib

-- spec: recursor Nat.Linear.ExprCnstr.rec : forall {motive : Nat.Linear.ExprCnstr -> Sort.{u}}, (forall (eq : Bool) (lhs : Nat.Linear.Expr) (rhs : Nat.Linear.Expr), motive (Nat.Linear.ExprCnstr.mk eq lhs rhs)) -> (forall (t : Nat.Linear.ExprCnstr), motive t)
