import Mathlib

set_option pp.all true
-- spec: Nat.Linear.ExprCnstr.rhs : Nat.Linear.ExprCnstr -> Nat.Linear.Expr
def Nat.Linear.ExprCnstr.rhs : Nat.Linear.ExprCnstr -> Nat.Linear.Expr :=
  fun (self : Nat.Linear.ExprCnstr) => self.3
