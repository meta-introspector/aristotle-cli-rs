import Mathlib

-- spec: theorem Nat.le_succ_of_le : forall {n : Nat} {m : Nat}, (LE.le.{0} Nat instLENat n m) -> (LE.le.{0} Nat instLENat n (Nat.succ m))
theorem Nat.le_succ_of_le : forall {n : Nat} {m : Nat}, (LE.le.{0} Nat instLENat n m) -> (LE.le.{0} Nat instLENat n (Nat.succ m)) :=
  fun {n : Nat} {m : Nat} (h : LE.le.{0} Nat instLENat n m) => Nat.le.step n m h
