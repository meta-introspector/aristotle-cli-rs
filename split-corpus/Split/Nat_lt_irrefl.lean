import Mathlib

-- spec: theorem Nat.lt_irrefl : forall (n : Nat), Not (LT.lt.{0} Nat instLTNat n n)
theorem Nat.lt_irrefl : forall (n : Nat), Not (LT.lt.{0} Nat instLTNat n n) :=
  fun (n : Nat) => Nat.not_succ_le_self n
