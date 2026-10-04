import Mathlib

-- spec: theorem Nat.le_succ : forall (n : Nat), LE.le.{0} Nat instLENat n (Nat.succ n)
theorem Nat.le_succ : forall (n : Nat), LE.le.{0} Nat instLENat n (Nat.succ n) :=
  fun (n : Nat) => Nat.le.step n n (Nat.le.refl n)
