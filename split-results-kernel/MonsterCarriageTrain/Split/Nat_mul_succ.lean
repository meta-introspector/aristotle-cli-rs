import Split.HMul_hMul
import Split.instMulNat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.Nat_succ
import Split.Eq
import Split.rfl
import Split.instHMul

-- Nat.mul_succ from environment
-- theorem Nat.mul_succ : forall (n : Nat) (m : Nat), Eq.{1} Nat (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n (Nat.succ m)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n m) n)

-- Stub: this file represents the declaration `Nat.mul_succ`.
-- In a full split, the body would be extracted from the environment.
