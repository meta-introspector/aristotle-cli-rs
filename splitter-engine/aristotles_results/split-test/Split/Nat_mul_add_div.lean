import Split.Eq_mpr
import Split.Lean_RArray_leaf
import Split.Nat_mul_succ
import Split.instHDiv
import Split.HMul_hMul
import Split.Nat_div_eq
import Split.congrArg
import Split.and_self
import Split.HSub_hSub
import Split.Nat_Linear_ExprCnstr_eq_true_of_isValid
import Split.Nat_add_sub_cancel_left
import Split.Lean_RArray_branch
import Split.Nat_brecOn
import Split.id
import Split.HDiv_hDiv
import Split.instSubNat
import Split.instMulNat
import Split.instOfNatNat
import Split.LE_le
import Split.ite_cond_eq_true
import Split.instLENat
import Split.Nat_Linear_Expr_num
import Split.Nat_below
import Split.Bool_true
import Split.GT_gt
import Split.instHAdd
import Split.And
import Split.Unit
import Split.instHSub
import Split.HAdd_hAdd
import Split.Nat
import Split.congr
import Split.LT_lt
import Split.True
import Split.eq_self
import Split.Nat_instDiv
import Split.eq_true
import Split.Nat_add_assoc
import Split.Bool
import Split.of_eq_true
import Split.Nat_decLt
import Split.instAddNat
import Split.Eq_refl
import Split.congrFun'
import Split.Nat_Linear_Expr_add
import Split.instLTNat
import Split.instDecidableAnd
import Split.Nat_zero_add
import Split.OfNat_ofNat
import Split.Nat_Linear_ExprCnstr_mk
import Split.eagerReduce
import Split.Nat_succ
import Split.Eq
import Split.Nat_decLe
import Split.Eq_trans
import Split.instHMul
import Split.Nat_Linear_Expr_var
import Split.ite

-- Nat.mul_add_div from environment
-- theorem Nat.mul_add_div : forall {m : Nat}, (GT.gt.{0} Nat instLTNat m (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (forall (x : Nat) (y : Nat), Eq.{1} Nat (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) m x) y) m) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) x (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) y m)))

-- Stub: this file represents the declaration `Nat.mul_add_div`.
-- In a full split, the body would be extracted from the environment.
