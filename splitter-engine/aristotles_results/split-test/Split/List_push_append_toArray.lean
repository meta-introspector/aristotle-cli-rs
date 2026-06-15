import Split.Array_instAppend
import Split.List_append_assoc
import Split.Array_push
import Split.congrArg
import Split.Array_casesOn
import Split.List_append_toArray
import Split.List_toArray
import Split.List_cons
import Split.Array
import Split.instHAppendOfAppend
import Split.List
import Split.congr
import Split.True
import Split.List_push_toArray
import Split.eq_self
import Split.of_eq_true
import Split.Eq_ndrec
import Split.Eq_refl
import Split.congrFun'
import Split.List_instAppend
import Split.Array_mk
import Split.Eq_symm
import Split.Eq
import Split.HAppend_hAppend
import Split.Eq_trans
import Split.List_nil

-- List.push_append_toArray from environment
-- theorem List.push_append_toArray : forall {α : Type.{u_1}} {as : Array.{u_1} α} {a : α} {bs : List.{u_1} α}, Eq.{succ u_1} (Array.{u_1} α) (HAppend.hAppend.{u_1, u_1, u_1} (Array.{u_1} α) (Array.{u_1} α) (Array.{u_1} α) (instHAppendOfAppend.{u_1} (Array.{u_1} α) (Array.instAppend.{u_1} α)) (Array.push.{u_1} α as a) (List.toArray.{u_1} α bs)) (HAppend.hAppend.{u_1, u_1, u_1} (Array.{u_1} α) (Array.{u_1} α) (Array.{u_1} α) (instHAppendOfAppend.{u_1} (Array.{u_1} α) (Array.instAppend.{u_1} α)) as (List.toArray.{u_1} α (List.cons.{u_1} α a bs)))

-- Stub: this file represents the declaration `List.push_append_toArray`.
-- In a full split, the body would be extracted from the environment.
