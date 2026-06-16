import Split.Eq_mpr
import Split.HMul_hMul
import Split.congrArg
import Split.id
import Split.instMulNat
import Split.Nat_mul_comm
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.congr
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.instAddNat
import Split.congrFun'
import Split.Nat_left_distrib
import Split.Eq
import Split.Eq_trans
import Split.instHMul

-- Nat.right_distrib from environment
-- theorem Nat.right_distrib : forall (n : Nat) (m : Nat) (k : Nat), Eq.{1} Nat (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n m) k) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n k) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) m k))

-- Stub: this file represents the declaration `Nat.right_distrib`.
-- In a full split, the body would be extracted from the environment.
