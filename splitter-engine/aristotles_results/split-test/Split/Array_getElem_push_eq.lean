import Split.Eq_mpr
import Split.Array_push
import Split.congrArg
import Split.List_concat
import Split.Std_IsLinearPreorder_toIsPreorder
import Split.Std_instReflLeOfIsPreorder
import Split.GetElem_getElem_congr_simp
import Split.HSub_hSub
import Split.id
import Split.instSubNat
import Split.instOfNatNat
import Split.LE_le
import Split.instLENat
import Split.Array_toList
import Split.List_concat_eq_append
import Split.List_cons
import Split.Array
import Split.GetElem_getElem
import Split.Nat_sub_self
import Split.instHAppendOfAppend
import Split.List
import Split.instHSub
import Split.Array_instGetElemNatLtSize
import Split.Nat
import Split.LT_lt
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.Eq_ndrec
import Split.Eq_refl
import Split.congrFun'
import Split.instLTNat
import Split.List_instAppend
import Split.Array_mk
import Split.List_instGetElemNatLtLength
import Split.OfNat_ofNat
import Split.Eq
import Split.List_length
import Split.Array_size
import Split.HAppend_hAppend
import Split.Nat_instIsLinearOrder
import Split.Eq_trans
import Split.Std_IsLinearOrder_toIsLinearPreorder
import Split.List_getElem_append_right
import Split.List_nil

-- Array.getElem_push_eq from environment
-- theorem Array.getElem_push_eq : forall {α : Type.{u_1}} {xs : Array.{u_1} α} {x : α}, Eq.{succ u_1} α (GetElem.getElem.{u_1, 0, u_1} (Array.{u_1} α) Nat α (fun (xs : Array.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α xs)) (Array.instGetElemNatLtSize.{u_1} α) (Array.push.{u_1} α xs x) (Array.size.{u_1} α xs) (Array.getElem_push_eq._proof_1.{u_1} α xs x)) x

-- Stub: this file represents the declaration `Array.getElem_push_eq`.
-- In a full split, the body would be extracted from the environment.
