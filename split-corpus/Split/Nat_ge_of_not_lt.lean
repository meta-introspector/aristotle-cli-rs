import Mathlib

-- spec: theorem Nat.ge_of_not_lt : forall {n : Nat} {m : Nat}, (Not (LT.lt.{0} Nat instLTNat n m)) -> (GE.ge.{0} Nat instLENat n m)
theorem Nat.ge_of_not_lt : forall {n : Nat} {m : Nat}, (Not (LT.lt.{0} Nat instLTNat n m)) -> (GE.ge.{0} Nat instLENat n m) :=
  fun {n : Nat} {m : Nat} (h : Not (LT.lt.{0} Nat instLTNat n m)) => Or.resolve_left (LT.lt.{0} Nat instLTNat n m) (GE.ge.{0} Nat instLENat n m) (Nat.lt_or_ge n m) h
