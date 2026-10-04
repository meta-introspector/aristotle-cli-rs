import Mathlib

-- spec: theorem Nat.mul_succ : forall (n : Nat) (m : Nat), Eq.{1} Nat (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n (Nat.succ m)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n m) n)
theorem Nat.mul_succ : forall (n : Nat) (m : Nat), Eq.{1} Nat (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n (Nat.succ m)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n m) n) :=
  fun (n : Nat) (m : Nat) => rfl.{1} Nat (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n (Nat.succ m))
