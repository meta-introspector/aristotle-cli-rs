import Split.Eq_mpr
import Split.Nat_recAux
import Split.Nat_succ_pred_eq_of_pos
import Split.Array_push
import Split.congrArg
import Split.Nat_sub_pos_of_lt
import Split.HSub_hSub
import Split.id
import Split.instSubNat
import Split.instOfNatNat
import Split.LE_le
import Split.instLENat
import Split.Array_extract_loop_of_ge
import Split.Array_extract_loop_succ
import Split.dite
import Split.Array
import Split.GetElem_getElem
import Split.instHAdd
import Split.instHSub
import Split.Nat_sub_succ
import Split.Array_instGetElemNatLtSize
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.Array_extract_loop
import Split.Nat_add_assoc
import Split.Nat_decLt
import Split.instAddNat
import Split.Eq_refl
import Split.Array_size_push
import Split.Nat_add_zero
import Split.Nat_min_zero
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Nat_add_min_add_left
import Split.Nat_le_of_not_gt
import Split.Nat_one_add
import Split.Nat_succ
import Split.Eq
import Split.Nat_pred
import Split.Array_size
import Split.Not
import Split.Nat_sub_eq_zero_of_le
import Split.Min_min
import Split.instMinNat
import Split.Array_extract_loop_zero
import Split.Nat_zero_min

-- Array.size_extract_loop from environment
-- theorem Array.size_extract_loop : forall {α : Type.{u_1}} {xs : Array.{u_1} α} {ys : Array.{u_1} α} {size : Nat} {start : Nat}, Eq.{1} Nat (Array.size.{u_1} α (Array.extract.loop.{u_1} α xs size start ys)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (Array.size.{u_1} α ys) (Min.min.{0} Nat instMinNat size (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (Array.size.{u_1} α xs) start)))

-- Stub: this file represents the declaration `Array.size_extract_loop`.
-- In a full split, the body would be extracted from the environment.
