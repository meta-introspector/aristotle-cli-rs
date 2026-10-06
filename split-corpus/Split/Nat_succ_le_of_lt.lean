import Mathlib

-- spec: theorem Nat.succ_le_of_lt : forall {n : Nat} {m : Nat}, (LT.lt.{0} Nat instLTNat n m) -> (LE.le.{0} Nat instLENat (Nat.succ n) m)
theorem Nat.succ_le_of_lt : forall {n : Nat} {m : Nat}, (LT.lt.{0} Nat instLTNat n m) -> (LE.le.{0} Nat instLENat (Nat.succ n) m) :=
  fun {n : Nat} {m : Nat} (h : LT.lt.{0} Nat instLTNat n m) => h
