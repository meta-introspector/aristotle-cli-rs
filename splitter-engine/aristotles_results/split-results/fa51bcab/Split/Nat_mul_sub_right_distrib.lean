import Split.Eq_mpr
import Split.Nat_recAux
import Split.HMul_hMul
import Split.congrArg
import Split.HSub_hSub
import Split.id
import Split.Nat_sub_sub
import Split.instSubNat
import Split.instMulNat
import Split.instOfNatNat
import Split.Nat_zero_mul
import Split.instHAdd
import Split.instHSub
import Split.Nat_succ_mul
import Split.Nat_sub_succ
import Split.HAdd_hAdd
import Split.Nat
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.instAddNat
import Split.Eq_refl
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Eq
import Split.Nat_pred
import Split.Nat_pred_mul
import Split.Eq_trans
import Split.instHMul

-- Nat.mul_sub_right_distrib from environment
-- theorem Nat.mul_sub_right_distrib : forall (n : Nat) (m : Nat) (k : Nat), Eq.{1} Nat (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) n m) k) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n k) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) m k))

-- Stub: this file represents the declaration `Nat.mul_sub_right_distrib`.
-- In a full split, the body would be extracted from the environment.
