import Mathlib

set_option pp.all true
-- spec: Nat.hasNotBit : Nat -> Nat -> Prop
def Nat.hasNotBit : Nat -> Nat -> Prop :=
  fun (m : Nat) (n : Nat) => Ne.{1} Nat (Nat.land (OfNat.ofNat.{0} ([mdata borrowed:1 Nat]) 1 (instOfNatNat 1)) (Nat.shiftRight m n)) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))
