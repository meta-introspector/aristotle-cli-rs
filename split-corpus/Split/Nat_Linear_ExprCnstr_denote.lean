import Mathlib

set_option pp.all true
-- spec: Nat.Linear.ExprCnstr.denote : Nat.Linear.Context -> Nat.Linear.ExprCnstr -> Prop
def Nat.Linear.ExprCnstr.denote : Nat.Linear.Context -> Nat.Linear.ExprCnstr -> Prop :=
  fun (ctx : Nat.Linear.Context) (c : Nat.Linear.ExprCnstr) => cond.{1} Prop (Nat.Linear.ExprCnstr.eq c) (Eq.{1} Nat (Nat.Linear.Expr.denote ctx (Nat.Linear.ExprCnstr.lhs c)) (Nat.Linear.Expr.denote ctx (Nat.Linear.ExprCnstr.rhs c))) (LE.le.{0} Nat instLENat (Nat.Linear.Expr.denote ctx (Nat.Linear.ExprCnstr.lhs c)) (Nat.Linear.Expr.denote ctx (Nat.Linear.ExprCnstr.rhs c)))
