import Mathlib

set_option pp.all true
-- spec: Nat.Linear.Poly.norm : Nat.Linear.Poly -> Nat.Linear.Poly
def Nat.Linear.Poly.norm : Nat.Linear.Poly -> Nat.Linear.Poly :=
  fun (p : Nat.Linear.Poly) => Nat.Linear.Poly.norm.go p (List.nil.{0} (Prod.{0, 0} Nat Nat.Linear.Var))
