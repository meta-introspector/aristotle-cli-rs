import Mathlib

-- spec: theorem Nat.mul_zero : forall (n : Nat), Eq.{1} Nat (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))
theorem Nat.mul_zero : forall (n : Nat), Eq.{1} Nat (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) :=
  fun (n : Nat) => rfl.{1} Nat (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))
