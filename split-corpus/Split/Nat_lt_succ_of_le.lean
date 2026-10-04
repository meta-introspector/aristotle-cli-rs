import Mathlib

-- spec: theorem Nat.lt_succ_of_le : forall {n : Nat} {m : Nat}, (LE.le.{0} Nat instLENat n m) -> (LT.lt.{0} Nat instLTNat n (Nat.succ m))
theorem Nat.lt_succ_of_le : forall {n : Nat} {m : Nat}, (LE.le.{0} Nat instLENat n m) -> (LT.lt.{0} Nat instLTNat n (Nat.succ m)) :=
  fun {n : Nat} {m : Nat} => Nat.succ_le_succ n m
