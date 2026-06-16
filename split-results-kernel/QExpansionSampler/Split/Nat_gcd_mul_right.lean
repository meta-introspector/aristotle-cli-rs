import Split.Nat_gcd
import Split.Eq_mpr
import Split.HMul_hMul
import Split.congrArg
import Split.id
import Split.Nat_gcd_mul_left
import Split.instMulNat
import Split.Nat_mul_comm
import Split.Nat
import Split.Eq_refl
import Split.Eq
import Split.instHMul

-- Nat.gcd_mul_right from environment
-- theorem Nat.gcd_mul_right : forall (m : Nat) (n : Nat) (k : Nat), Eq.{1} Nat (Nat.gcd (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) m n) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) k n)) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) (Nat.gcd m k) n)

-- Stub: this file represents the declaration `Nat.gcd_mul_right`.
-- In a full split, the body would be extracted from the environment.
