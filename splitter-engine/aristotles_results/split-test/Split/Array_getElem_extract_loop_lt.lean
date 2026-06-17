import Split.Array_instAppend
import Split.Eq_mpr
import Split.Array_size_append
import Split.GetElem
import Split.Array_getElem_append_left
import Split.congrArg
import Split.Nat_le_add_right
import Split.Eq_rec
import Split.id
import Split.List_toArray
import Split.Array
import Split.GetElem_getElem
import Split.instHAppendOfAppend
import Split.instHAdd
import Split.Array_instGetElemNatLtSize
import Split.HAdd_hAdd
import Split.Array_getElem_extract_loop_lt_aux
import Split.Nat
import Split.LT_lt
import Split.Array_extract_loop
import Split.Eq_ndrec
import Split.instAddNat
import Split.Eq_refl
import Split.instLTNat
import Split.optParam
import Split.Array_extract_loop_eq_aux
import Split.Eq
import Split.Nat_lt_of_lt_of_le
import Split.Array_size
import Split.HAppend_hAppend
import Split.Eq_trans
import Split.List_nil

-- Array.getElem_extract_loop_lt from environment
-- theorem Array.getElem_extract_loop_lt : forall {α : Type.{u_1}} {i : Nat} {xs : Array.{u_1} α} {ys : Array.{u_1} α} {size : Nat} {start : Nat} (hlt : LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α ys)) (h : optParam.{0} (LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α (Array.extract.loop.{u_1} α xs size start ys))) (Array.getElem_extract_loop_lt_aux.{u_1} α i xs ys size start hlt)), Eq.{succ u_1} α (GetElem.getElem.{u_1, 0, u_1} (Array.{u_1} α) Nat α (fun (xs : Array.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α xs)) (Array.instGetElemNatLtSize.{u_1} α) (Array.extract.loop.{u_1} α xs size start ys) i h) (GetElem.getElem.{u_1, 0, u_1} (Array.{u_1} α) Nat α (fun (xs : Array.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α xs)) (Array.instGetElemNatLtSize.{u_1} α) ys i hlt)

-- Stub: this file represents the declaration `Array.getElem_extract_loop_lt`.
-- In a full split, the body would be extracted from the environment.
