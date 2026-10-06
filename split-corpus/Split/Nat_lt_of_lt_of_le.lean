import Mathlib

-- spec: theorem Nat.lt_of_lt_of_le : forall {n : Nat} {m : Nat} {k : Nat}, (LT.lt.{0} Nat instLTNat n m) -> (LE.le.{0} Nat instLENat m k) -> (LT.lt.{0} Nat instLTNat n k)
theorem Nat.lt_of_lt_of_le : forall {n : Nat} {m : Nat} {k : Nat}, (LT.lt.{0} Nat instLTNat n m) -> (LE.le.{0} Nat instLENat m k) -> (LT.lt.{0} Nat instLTNat n k) :=
  fun {n : Nat} {m : Nat} {k : Nat} => Nat.le_trans (Nat.succ n) m k
