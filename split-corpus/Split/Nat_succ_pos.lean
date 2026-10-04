import Mathlib

-- spec: theorem Nat.succ_pos : forall (n : Nat), LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (Nat.succ n)
theorem Nat.succ_pos : forall (n : Nat), LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (Nat.succ n) :=
  fun (n : Nat) => Nat.zero_lt_succ n
