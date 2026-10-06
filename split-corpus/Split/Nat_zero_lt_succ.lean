import Mathlib

-- spec: theorem Nat.zero_lt_succ : forall (n : Nat), LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (Nat.succ n)
theorem Nat.zero_lt_succ : forall (n : Nat), LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (Nat.succ n) :=
  fun (n : Nat) => Nat.succ_le_succ (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) n (Nat.zero_le n)
