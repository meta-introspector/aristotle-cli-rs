import Mathlib

-- spec: theorem Nat.lt_add_one : forall (n : Nat), LT.lt.{0} Nat instLTNat n (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))
theorem Nat.lt_add_one : forall (n : Nat), LT.lt.{0} Nat instLTNat n (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) :=
  fun (n : Nat) => Nat.le_refl (Nat.succ n)
