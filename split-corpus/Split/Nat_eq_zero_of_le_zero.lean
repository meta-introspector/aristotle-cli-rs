import Mathlib

-- spec: theorem Nat.eq_zero_of_le_zero : forall {n : Nat}, (LE.le.{0} Nat instLENat n (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (Eq.{1} Nat n (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))
theorem Nat.eq_zero_of_le_zero : forall {n : Nat}, (LE.le.{0} Nat instLENat n (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (Eq.{1} Nat n (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) :=
  fun {n : Nat} (h : LE.le.{0} Nat instLENat n (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) => Nat.le_antisymm n (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) h (Nat.zero_le n)
