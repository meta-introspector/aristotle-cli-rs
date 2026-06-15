import Split.Array_instAppend
import Split.Eq_mpr
import Split.congrArg
import Split.Eq_rec
import Split.Eq_mp
import Split.Fin_mk
import Split.id
import Split.Array_toList_append
import Split.Array_length_toList
import Split.Array_toList
import Split.Array
import Split.GetElem_getElem
import Split.List_getElem_append_left
import Split.instHAppendOfAppend
import Split.List
import Split.Array_instGetElemNatLtSize
import Split.List_get_of_eq
import Split.Nat
import Split.LT_lt
import Split.Eq_refl
import Split.instLTNat
import Split.List_instAppend
import Split.List_instGetElemNatLtLength
import Split.Eq_symm
import Split.Eq
import Split.List_length
import Split.Array_size
import Split.HAppend_hAppend
import Split.Eq_trans

-- Array.getElem_append_left from environment
-- theorem Array.getElem_append_left : forall {α : Type.{u_1}} {i : Nat} {xs : Array.{u_1} α} {ys : Array.{u_1} α} {h : LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α (HAppend.hAppend.{u_1, u_1, u_1} (Array.{u_1} α) (Array.{u_1} α) (Array.{u_1} α) (instHAppendOfAppend.{u_1} (Array.{u_1} α) (Array.instAppend.{u_1} α)) xs ys))} (hlt : LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α xs)), Eq.{succ u_1} α (GetElem.getElem.{u_1, 0, u_1} (Array.{u_1} α) Nat α (fun (xs : Array.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α xs)) (Array.instGetElemNatLtSize.{u_1} α) (HAppend.hAppend.{u_1, u_1, u_1} (Array.{u_1} α) (Array.{u_1} α) (Array.{u_1} α) (instHAppendOfAppend.{u_1} (Array.{u_1} α) (Array.instAppend.{u_1} α)) xs ys) i h) (GetElem.getElem.{u_1, 0, u_1} (Array.{u_1} α) Nat α (fun (xs : Array.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α xs)) (Array.instGetElemNatLtSize.{u_1} α) xs i hlt)

-- Stub: this file represents the declaration `Array.getElem_append_left`.
-- In a full split, the body would be extracted from the environment.
