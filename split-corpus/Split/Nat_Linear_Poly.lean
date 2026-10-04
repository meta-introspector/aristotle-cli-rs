import Mathlib

set_option pp.all true
-- spec: Nat.Linear.Poly : Type
def Nat.Linear.Poly : Type :=
  List.{0} (Prod.{0, 0} Nat Nat.Linear.Var)
