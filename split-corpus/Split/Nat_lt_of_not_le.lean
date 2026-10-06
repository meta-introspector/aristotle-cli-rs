import Mathlib

-- spec: theorem Nat.lt_of_not_le : forall {a : Nat} {b : Nat}, (Not (LE.le.{0} Nat instLENat a b)) -> (LT.lt.{0} Nat instLTNat b a)
theorem Nat.lt_of_not_le : forall {a : Nat} {b : Nat}, (Not (LE.le.{0} Nat instLENat a b)) -> (LT.lt.{0} Nat instLTNat b a) :=
  fun {a : Nat} {b : Nat} (h : Not (LE.le.{0} Nat instLENat a b)) => Or.resolve_right (LT.lt.{0} Nat instLTNat b a) (GE.ge.{0} Nat instLENat b a) (Nat.lt_or_ge b a) h
