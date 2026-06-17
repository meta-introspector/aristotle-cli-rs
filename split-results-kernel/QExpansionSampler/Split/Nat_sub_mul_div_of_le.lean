import Split.Eq_mpr
import Split.Nat_recAux
import Split.Nat_mul_succ
import Split.instHDiv
import Split.HMul_hMul
import Split.Nat_zero_sub
import Split.congrArg
import Split.HSub_hSub
import Split.GE_ge
import Split.Eq_mp
import Split.id
import Split.HDiv_hDiv
import Split.Nat_le_of_add_le_add_right
import Split.Nat_sub_sub
import Split.Nat_mul_le_mul_left
import Split.instSubNat
import Split.Nat_le_succ
import Split.instMulNat
import Split.instOfNatNat
import Split.LE_le
import Split.instLENat
import Split.Nat_div_eq_sub_div
import Split.Nat_div_zero
import Split.GT_gt
import Split.instHAdd
import Split.instHSub
import Split.Nat_sub_add_cancel
import Split.Nat_sub_succ
import Split.HAdd_hAdd
import Split.Nat_le_trans
import Split.Nat
import Split.True
import Split.Nat_mul_zero
import Split.eq_self
import Split.Nat_instDiv
import Split.of_eq_true
import Split.instAddNat
import Split.Eq_refl
import Split.Nat_sub_zero
import Split.congrFun'
import Split.Or
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Nat_succ
import Split.Eq
import Split.Nat_eq_zero_or_pos
import Split.Nat_pred
import Split.Eq_trans
import Split.instHMul
import Split.Nat_add_comm

-- Nat.sub_mul_div_of_le from environment
-- theorem Nat.sub_mul_div_of_le : forall (x : Nat) (n : Nat) (p : Nat), (LE.le.{0} Nat instLENat (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n p) x) -> (Eq.{1} Nat (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) x (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n p)) n) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) x n) p))

-- Stub: this file represents the declaration `Nat.sub_mul_div_of_le`.
-- In a full split, the body would be extracted from the environment.
