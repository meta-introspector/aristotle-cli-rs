import Mathlib

set_option pp.all true
-- spec: Nat.Linear.ExprCnstr.eq : Nat.Linear.ExprCnstr -> Bool
def Nat.Linear.ExprCnstr.eq : Nat.Linear.ExprCnstr -> Bool :=
  fun (self : Nat.Linear.ExprCnstr) => self.1
