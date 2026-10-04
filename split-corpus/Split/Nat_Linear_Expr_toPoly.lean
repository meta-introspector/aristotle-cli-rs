import Mathlib

set_option pp.all true
-- spec: Nat.Linear.Expr.toPoly : Nat.Linear.Expr -> Nat.Linear.Poly
def Nat.Linear.Expr.toPoly : Nat.Linear.Expr -> Nat.Linear.Poly :=
  fun (e : Nat.Linear.Expr) => Nat.Linear.Expr.toPoly.go (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) e (List.nil.{0} (Prod.{0, 0} Nat Nat.Linear.Var))
