import Split.Nat_gcd
import Split.Nat_lcm
import Split.instHDiv
import Split.HMul_hMul
import Split.HDiv_hDiv
import Split.instMulNat
import Split.Nat
import Split.Nat_instDiv
import Split.Eq
import Split.rfl
import Split.instHMul

-- Nat.lcm_eq_mul_div from environment
-- theorem Nat.lcm_eq_mul_div : forall (m : Nat) (n : Nat), Eq.{1} Nat (Nat.lcm m n) (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) m n) (Nat.gcd m n))

-- Stub: this file represents the declaration `Nat.lcm_eq_mul_div`.
-- In a full split, the body would be extracted from the environment.
