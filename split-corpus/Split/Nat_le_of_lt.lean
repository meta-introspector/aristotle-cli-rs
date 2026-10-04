import Mathlib

-- spec: theorem Nat.le_of_lt : forall {n : Nat} {m : Nat}, (LT.lt.{0} Nat instLTNat n m) -> (LE.le.{0} Nat instLENat n m)
theorem Nat.le_of_lt : forall {n : Nat} {m : Nat}, (LT.lt.{0} Nat instLTNat n m) -> (LE.le.{0} Nat instLENat n m) :=
  fun {n : Nat} {m : Nat} => Nat.le_of_succ_le n m
