import Mathlib

-- spec: theorem Nat.mul_one : forall (n : Nat), Eq.{1} Nat (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) n
theorem Nat.mul_one : forall (n : Nat), Eq.{1} Nat (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) n :=
  Nat.zero_add
