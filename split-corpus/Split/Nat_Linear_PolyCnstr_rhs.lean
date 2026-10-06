import Mathlib

set_option pp.all true
-- spec: Nat.Linear.PolyCnstr.rhs : Nat.Linear.PolyCnstr -> Nat.Linear.Poly
def Nat.Linear.PolyCnstr.rhs : Nat.Linear.PolyCnstr -> Nat.Linear.Poly :=
  fun (self : Nat.Linear.PolyCnstr) => self.3
