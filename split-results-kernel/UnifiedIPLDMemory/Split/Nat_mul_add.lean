import Split.HMul_hMul
import Split.instMulNat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.Nat_left_distrib
import Split.Eq
import Split.instHMul

-- Nat.mul_add from environment
-- theorem Nat.mul_add : forall (n : Nat) (m : Nat) (k : Nat), Eq.{1} Nat (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) m k)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n m) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n k))

-- Stub: this file represents the declaration `Nat.mul_add`.
-- In a full split, the body would be extracted from the environment.
