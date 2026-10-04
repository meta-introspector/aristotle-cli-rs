import Mathlib

-- spec: theorem Nat.not_lt_zero : forall (n : Nat), Not (LT.lt.{0} Nat instLTNat n (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))
theorem Nat.not_lt_zero : forall (n : Nat), Not (LT.lt.{0} Nat instLTNat n (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) :=
  fun (n : Nat) => Nat.not_succ_le_zero n
