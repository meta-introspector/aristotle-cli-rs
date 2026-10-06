import Mathlib

-- spec: theorem Nat.sub_zero : forall (n : Nat), Eq.{1} Nat (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) n (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) n
theorem Nat.sub_zero : forall (n : Nat), Eq.{1} Nat (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) n (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) n :=
  fun (n : Nat) => rfl.{1} Nat (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) n (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))
