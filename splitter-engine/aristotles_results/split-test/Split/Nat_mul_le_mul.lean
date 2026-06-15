import Split.HMul_hMul
import Split.Nat_mul_le_mul_right
import Split.Nat_mul_le_mul_left
import Split.instMulNat
import Split.LE_le
import Split.instLENat
import Split.Nat_le_trans
import Split.Nat
import Split.instHMul

-- Nat.mul_le_mul from environment
-- theorem Nat.mul_le_mul : forall {n₁ : Nat} {m₁ : Nat} {n₂ : Nat} {m₂ : Nat}, (LE.le.{0} Nat instLENat n₁ n₂) -> (LE.le.{0} Nat instLENat m₁ m₂) -> (LE.le.{0} Nat instLENat (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n₁ m₁) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n₂ m₂))

-- Stub: this file represents the declaration `Nat.mul_le_mul`.
-- In a full split, the body would be extracted from the environment.
