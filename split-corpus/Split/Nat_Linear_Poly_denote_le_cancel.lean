import Mathlib

-- spec: theorem Nat.Linear.Poly.denote_le_cancel : forall {ctx : Nat.Linear.Context} {m₁ : Nat.Linear.Poly} {m₂ : Nat.Linear.Poly}, (Nat.Linear.Poly.denote_le ctx (Prod.mk.{0, 0} Nat.Linear.Poly Nat.Linear.Poly m₁ m₂)) -> (Nat.Linear.Poly.denote_le ctx (Nat.Linear.Poly.cancel m₁ m₂))
theorem Nat.Linear.Poly.denote_le_cancel : forall {ctx : Nat.Linear.Context} {m₁ : Nat.Linear.Poly} {m₂ : Nat.Linear.Poly}, (Nat.Linear.Poly.denote_le ctx (Prod.mk.{0, 0} Nat.Linear.Poly Nat.Linear.Poly m₁ m₂)) -> (Nat.Linear.Poly.denote_le ctx (Nat.Linear.Poly.cancel m₁ m₂)) :=
  fun {ctx : Nat.Linear.Context} {m₁ : Nat.Linear.Poly} {m₂ : Nat.Linear.Poly} (h : Nat.Linear.Poly.denote_le ctx (Prod.mk.{0, 0} Nat.Linear.Poly Nat.Linear.Poly m₁ m₂)) => Nat.Linear.Poly.denote_le_cancelAux ctx Nat.Linear.hugeFuel m₁ m₂ (List.nil.{0} (Prod.{0, 0} Nat Nat.Linear.Var)) (List.nil.{0} (Prod.{0, 0} Nat Nat.Linear.Var)) h
