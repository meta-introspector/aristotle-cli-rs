import Split.Eq_mpr
import Split.Nat_recAux
import Split.HMul_hMul
import Split.congrArg
import Split.id
import Split.instMulNat
import Split.instOfNatNat
import Split.Nat_add_left_comm
import Split.Nat_zero_mul
import Split.instHAdd
import Split.Nat_succ_mul
import Split.HAdd_hAdd
import Split.Nat
import Split.congr
import Split.Nat_add_assoc
import Split.instAddNat
import Split.Eq_refl
import Split.congrFun'
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Eq
import Split.Eq_trans
import Split.instHMul

-- Nat.left_distrib from environment
-- theorem Nat.left_distrib : forall (n : Nat) (m : Nat) (k : Nat), Eq.{1} Nat (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) m k)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n m) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n k))

-- Stub: this file represents the declaration `Nat.left_distrib`.
-- In a full split, the body would be extracted from the environment.
