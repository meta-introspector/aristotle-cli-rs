import Mathlib

-- spec: theorem Nat.pos_of_ne_zero : forall {n : Nat}, (Ne.{1} Nat n (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) n)
theorem Nat.pos_of_ne_zero : forall {n : Nat}, (Ne.{1} Nat n (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) n) :=
  fun {n : Nat} => Or.resolve_left (Eq.{1} Nat n (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (GT.gt.{0} Nat instLTNat n (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (Nat.eq_zero_or_pos n)
