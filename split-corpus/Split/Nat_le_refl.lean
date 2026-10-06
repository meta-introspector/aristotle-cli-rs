import Mathlib

-- spec: theorem Nat.le_refl : forall (n : Nat), LE.le.{0} Nat instLENat n n
theorem Nat.le_refl : forall (n : Nat), LE.le.{0} Nat instLENat n n :=
  fun (n : Nat) => Nat.le.refl n
