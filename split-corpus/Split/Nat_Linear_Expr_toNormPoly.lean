import Mathlib

set_option pp.all true
-- spec: Nat.Linear.Expr.toNormPoly : Nat.Linear.Expr -> Nat.Linear.Poly
def Nat.Linear.Expr.toNormPoly : Nat.Linear.Expr -> Nat.Linear.Poly :=
  fun (e : Nat.Linear.Expr) => Nat.Linear.Poly.norm (Nat.Linear.Expr.toPoly e)
