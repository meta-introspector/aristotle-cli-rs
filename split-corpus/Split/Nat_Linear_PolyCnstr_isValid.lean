import Mathlib

set_option pp.all true
-- spec: Nat.Linear.PolyCnstr.isValid : Nat.Linear.PolyCnstr -> Bool
def Nat.Linear.PolyCnstr.isValid : Nat.Linear.PolyCnstr -> Bool :=
  fun (c : Nat.Linear.PolyCnstr) => cond.{1} Bool (Nat.Linear.PolyCnstr.eq c) (Bool.and (Nat.Linear.Poly.isZero (Nat.Linear.PolyCnstr.lhs c)) (Nat.Linear.Poly.isZero (Nat.Linear.PolyCnstr.rhs c))) (Nat.Linear.Poly.isZero (Nat.Linear.PolyCnstr.lhs c))
