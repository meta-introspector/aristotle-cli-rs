import Mathlib

set_option pp.all true
-- spec: Nat.Linear.Poly.cancel : Nat.Linear.Poly -> Nat.Linear.Poly -> (Prod.{0, 0} Nat.Linear.Poly Nat.Linear.Poly)
def Nat.Linear.Poly.cancel : Nat.Linear.Poly -> Nat.Linear.Poly -> (Prod.{0, 0} Nat.Linear.Poly Nat.Linear.Poly) :=
  fun (p₁ : Nat.Linear.Poly) (p₂ : Nat.Linear.Poly) => Nat.Linear.Poly.cancelAux Nat.Linear.hugeFuel p₁ p₂ (List.nil.{0} (Prod.{0, 0} Nat Nat.Linear.Var)) (List.nil.{0} (Prod.{0, 0} Nat Nat.Linear.Var))
