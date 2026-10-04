import Mathlib

-- spec: theorem Nat.lt_succ_self : forall (n : Nat), LT.lt.{0} Nat instLTNat n (Nat.succ n)
theorem Nat.lt_succ_self : forall (n : Nat), LT.lt.{0} Nat instLTNat n (Nat.succ n) :=
  fun (n : Nat) => Nat.lt_add_one n
