import Split.Eq_mpr
import Split.Nat_recAux
import Split.Nat_mul_succ
import Split.HMul_hMul
import Split.congrArg
import Split.id
import Split.instMulNat
import Split.instOfNatNat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat_add_succ
import Split.Nat
import Split.instAddNat
import Split.Eq_refl
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Eq
import Split.Nat_add_right_comm
import Split.instHMul

-- Nat.succ_mul from environment
-- theorem Nat.succ_mul : forall (n : Nat) (m : Nat), Eq.{1} Nat (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) (Nat.succ n) m) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n m) m)

-- Stub: this file represents the declaration `Nat.succ_mul`.
-- In a full split, the body would be extracted from the environment.
