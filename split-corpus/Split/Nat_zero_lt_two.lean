import Mathlib

-- spec: theorem Nat.zero_lt_two : LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2))
theorem Nat.zero_lt_two : LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) :=
  Nat.zero_lt_succ (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))
