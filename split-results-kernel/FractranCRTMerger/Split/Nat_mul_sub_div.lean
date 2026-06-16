import Split.Nat_sub_le_sub_left
import Split.Eq_mpr
import Split.instHDiv
import Split.HMul_hMul
import Split.Nat_succ_pred_eq_of_pos
import Split.Nat_div_mul_le_self
import Split.congrArg
import Split.Nat_div_eq_of_lt_le
import Split.Nat_sub_pos_of_lt
import Split.HSub_hSub
import Split.Eq_mp
import Split.Nat_lt_succ_self
import Split.id
import Split.HDiv_hDiv
import Split.Or_resolve_left
import Split.instSubNat
import Split.instMulNat
import Split.instOfNatNat
import Split.Nat_mul_comm
import Split.LE_le
import Split.instLENat
import Split.Nat_div_lt_iff_lt_mul
import Split.Nat_mul_sub_right_distrib
import Split.Nat_zero_mul
import Split.GT_gt
import Split.instHAdd
import Split.instHSub
import Split.HAdd_hAdd
import Split.Nat_not_lt_zero
import Split.Nat
import Split.LT_lt
import Split.Nat_instDiv
import Split.propext
import Split.Iff_mp
import Split.instAddNat
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Eq
import Split.Nat_eq_zero_or_pos
import Split.Nat_pred
import Split.instHMul

-- Nat.mul_sub_div from environment
-- theorem Nat.mul_sub_div : forall (x : Nat) (n : Nat) (p : Nat), (LT.lt.{0} Nat instLTNat x (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n p)) -> (Eq.{1} Nat (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n p) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) x (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))) n) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) p (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) x n) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))))

-- Stub: this file represents the declaration `Nat.mul_sub_div`.
-- In a full split, the body would be extracted from the environment.
