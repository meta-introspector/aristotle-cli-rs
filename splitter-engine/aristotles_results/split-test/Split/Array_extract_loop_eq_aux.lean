import Split.Array_instAppend
import Split.Eq_mpr
import Split.Array_append_assoc
import Split.Nat_recAux
import Split.Array_push
import Split.congrArg
import Split.id
import Split.instOfNatNat
import Split.Array_push_eq_append
import Split.Array_extract_loop_of_ge
import Split.Array_extract_loop_succ
import Split.dite
import Split.List_toArray
import Split.List_cons
import Split.Array
import Split.GetElem_getElem
import Split.instHAppendOfAppend
import Split.instHAdd
import Split.Array_instGetElemNatLtSize
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.Array_extract_loop
import Split.Nat_decLt
import Split.instAddNat
import Split.Eq_refl
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Eq
import Split.Array_size
import Split.Not
import Split.Array_append_empty
import Split.HAppend_hAppend
import Split.Nat_le_of_not_lt
import Split.Array_empty_append
import Split.Array_extract_loop_zero
import Split.List_nil

-- Array.extract_loop_eq_aux from environment
-- theorem Array.extract_loop_eq_aux : forall {α : Type.{u_1}} {xs : Array.{u_1} α} {ys : Array.{u_1} α} {size : Nat} {start : Nat}, Eq.{succ u_1} (Array.{u_1} α) (Array.extract.loop.{u_1} α xs size start ys) (HAppend.hAppend.{u_1, u_1, u_1} (Array.{u_1} α) (Array.{u_1} α) (Array.{u_1} α) (instHAppendOfAppend.{u_1} (Array.{u_1} α) (Array.instAppend.{u_1} α)) ys (Array.extract.loop.{u_1} α xs size start (List.toArray.{u_1} α (List.nil.{u_1} α))))

-- Stub: this file represents the declaration `Array.extract_loop_eq_aux`.
-- In a full split, the body would be extracted from the environment.
