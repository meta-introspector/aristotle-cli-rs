import Mathlib

-- spec: theorem Nat.min_def : forall {n : Nat} {m : Nat}, Eq.{1} Nat (Min.min.{0} Nat instMinNat n m) (ite.{1} Nat (LE.le.{0} Nat instLENat n m) (Nat.decLe n m) n m)
theorem Nat.min_def : forall {n : Nat} {m : Nat}, Eq.{1} Nat (Min.min.{0} Nat instMinNat n m) (ite.{1} Nat (LE.le.{0} Nat instLENat n m) (Nat.decLe n m) n m) :=
  fun {n : Nat} {m : Nat} => rfl.{1} Nat (Min.min.{0} Nat instMinNat n m)
