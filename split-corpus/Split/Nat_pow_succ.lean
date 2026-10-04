import Mathlib

-- spec: theorem Nat.pow_succ : forall (n : Nat) (m : Nat), Eq.{1} Nat (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) n (Nat.succ m)) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) n m) n)
theorem Nat.pow_succ : forall (n : Nat) (m : Nat), Eq.{1} Nat (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) n (Nat.succ m)) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) n m) n) :=
  fun (n : Nat) (m : Nat) => rfl.{1} Nat (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) n (Nat.succ m))
