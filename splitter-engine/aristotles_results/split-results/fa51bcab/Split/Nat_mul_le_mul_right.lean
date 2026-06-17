import Split.HMul_hMul
import Split.Eq_rec
import Split.Nat_mul_le_mul_left
import Split.instMulNat
import Split.Nat_mul_comm
import Split.LE_le
import Split.instLENat
import Split.Nat
import Split.Eq
import Split.instHMul

-- Nat.mul_le_mul_right from environment
-- theorem Nat.mul_le_mul_right : forall {n : Nat} {m : Nat} (k : Nat), (LE.le.{0} Nat instLENat n m) -> (LE.le.{0} Nat instLENat (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n k) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) m k))

-- Stub: this file represents the declaration `Nat.mul_le_mul_right`.
-- In a full split, the body would be extracted from the environment.
