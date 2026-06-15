import Split.Array_instAppend
import Split.Eq_mpr
import Split.Array_toList_push
import Split.List_append_assoc
import Split.Array_push
import Split.congrArg
import Split.id
import Split.instOfNatNat
import Split.List_rec
import Split.List_foldl
import Split.List_append_nil
import Split.Array_toList
import Split.Array_foldl
import Split.List_cons
import Split.Array
import Split.instHAppendOfAppend
import Split.List
import Split.Nat
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.Array_append_eq_append
import Split.Array_append
import Split.congrFun'
import Split.List_instAppend
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Eq
import Split.Array_size
import Split.HAppend_hAppend
import Split.Eq_trans
import Split.List_nil
import Split.Array_foldl_toList

-- Array.toList_append from environment
-- theorem Array.toList_append : forall {α : Type.{u_1}} {xs : Array.{u_1} α} {ys : Array.{u_1} α}, Eq.{succ u_1} (List.{u_1} α) (Array.toList.{u_1} α (HAppend.hAppend.{u_1, u_1, u_1} (Array.{u_1} α) (Array.{u_1} α) (Array.{u_1} α) (instHAppendOfAppend.{u_1} (Array.{u_1} α) (Array.instAppend.{u_1} α)) xs ys)) (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} α) (List.{u_1} α) (List.{u_1} α) (instHAppendOfAppend.{u_1} (List.{u_1} α) (List.instAppend.{u_1} α)) (Array.toList.{u_1} α xs) (Array.toList.{u_1} α ys))

-- Stub: this file represents the declaration `Array.toList_append`.
-- In a full split, the body would be extracted from the environment.
