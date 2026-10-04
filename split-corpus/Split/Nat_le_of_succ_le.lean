import Mathlib

-- spec: theorem Nat.le_of_succ_le : forall {n : Nat} {m : Nat}, (LE.le.{0} Nat instLENat (Nat.succ n) m) -> (LE.le.{0} Nat instLENat n m)
theorem Nat.le_of_succ_le : forall {n : Nat} {m : Nat}, (LE.le.{0} Nat instLENat (Nat.succ n) m) -> (LE.le.{0} Nat instLENat n m) :=
  fun {n : Nat} {m : Nat} (h : LE.le.{0} Nat instLENat (Nat.succ n) m) => Nat.le_trans n (Nat.succ n) m (Nat.le_succ n) h
