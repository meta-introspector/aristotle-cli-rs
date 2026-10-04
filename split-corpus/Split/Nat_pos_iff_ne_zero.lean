import Mathlib

-- spec: theorem Nat.pos_iff_ne_zero : forall {n : Nat}, Iff (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) n) (Ne.{1} Nat n (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))
theorem Nat.pos_iff_ne_zero : forall {n : Nat}, Iff (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) n) (Ne.{1} Nat n (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) :=
  fun {n : Nat} => Iff.intro (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) n) (Ne.{1} Nat n (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (Nat.ne_of_gt n (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (Nat.pos_of_ne_zero n)
