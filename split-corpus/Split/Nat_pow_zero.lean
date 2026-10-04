import Mathlib

-- spec: theorem Nat.pow_zero : forall (n : Nat), Eq.{1} Nat (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) n (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))
theorem Nat.pow_zero : forall (n : Nat), Eq.{1} Nat (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) n (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) :=
  fun (n : Nat) => rfl.{1} Nat (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) n (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))
