import Mathlib

set_option pp.all true
-- spec: Nat.Linear.ExprCnstr.toNormPoly : Nat.Linear.ExprCnstr -> Nat.Linear.PolyCnstr
def Nat.Linear.ExprCnstr.toNormPoly : Nat.Linear.ExprCnstr -> Nat.Linear.PolyCnstr :=
  fun (c : Nat.Linear.ExprCnstr) => Nat.Linear.PolyCnstr.norm.match_1.{1} (fun (x._@.Init.Data.Nat.Linear.496873807._hygCtx._hyg.14 : Prod.{0, 0} Nat.Linear.Poly Nat.Linear.Poly) => Nat.Linear.PolyCnstr) (Nat.Linear.Poly.cancel (Nat.Linear.Expr.toNormPoly (Nat.Linear.ExprCnstr.lhs c)) (Nat.Linear.Expr.toNormPoly (Nat.Linear.ExprCnstr.rhs c))) (fun (lhs : Nat.Linear.Poly) (rhs : Nat.Linear.Poly) => Nat.Linear.PolyCnstr.mk (Nat.Linear.ExprCnstr.eq c) lhs rhs)
