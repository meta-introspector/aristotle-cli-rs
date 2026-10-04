import Mathlib

-- spec: theorem Nat.sub_eq_zero_iff_le : forall {n : Nat} {m : Nat}, Iff (Eq.{1} Nat (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) n m) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (LE.le.{0} Nat instLENat n m)
theorem Nat.sub_eq_zero_iff_le : forall {n : Nat} {m : Nat}, Iff (Eq.{1} Nat (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) n m) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (LE.le.{0} Nat instLENat n m) :=
  fun {n : Nat} {m : Nat} => Iff.intro (Eq.{1} Nat (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) n m) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (LE.le.{0} Nat instLENat n m) (Nat.le_of_sub_eq_zero n m) (Nat.sub_eq_zero_of_le n m)
