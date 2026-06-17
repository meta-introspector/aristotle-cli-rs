import Split.Eq_mpr
import Split.HMul_hMul
import Split.congrArg
import Split.id
import Split.instMulNat
import Split.Nat_mul_comm
import Split.Nat_mul_assoc
import Split.Nat
import Split.Eq_refl
import Split.Eq_symm
import Split.Eq
import Split.instHMul

-- Nat.mul_left_comm from environment
-- theorem Nat.mul_left_comm : forall (n : Nat) (m : Nat) (k : Nat), Eq.{1} Nat (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) m k)) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) m (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n k))

-- Stub: this file represents the declaration `Nat.mul_left_comm`.
-- In a full split, the body would be extracted from the environment.
