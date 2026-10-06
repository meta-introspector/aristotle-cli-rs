import Mathlib

set_option pp.all true
-- spec: Nat.Linear.PolyCnstr.eq : Nat.Linear.PolyCnstr -> Bool
def Nat.Linear.PolyCnstr.eq : Nat.Linear.PolyCnstr -> Bool :=
  fun (self : Nat.Linear.PolyCnstr) => self.1
