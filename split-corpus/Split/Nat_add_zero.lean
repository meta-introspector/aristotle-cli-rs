import Mathlib

-- spec: theorem Nat.add_zero : forall (n : Nat), Eq.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) n
theorem Nat.add_zero : forall (n : Nat), Eq.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) n :=
  fun (n : Nat) => rfl.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))
