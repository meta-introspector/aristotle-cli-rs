import Mathlib

-- spec: recursor Nat.Linear.PolyCnstr.rec : forall {motive : Nat.Linear.PolyCnstr -> Sort.{u}}, (forall (eq : Bool) (lhs : Nat.Linear.Poly) (rhs : Nat.Linear.Poly), motive (Nat.Linear.PolyCnstr.mk eq lhs rhs)) -> (forall (t : Nat.Linear.PolyCnstr), motive t)
