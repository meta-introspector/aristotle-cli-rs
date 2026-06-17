import Split.Array_push
import Split.congrArg
import Split.List_concat
import Split.Array_casesOn
import Split.Array_toList
import Split.List_concat_eq_append
import Split.List_cons
import Split.Array
import Split.instHAppendOfAppend
import Split.List
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.congrFun'
import Split.List_instAppend
import Split.Array_mk
import Split.Eq
import Split.HAppend_hAppend
import Split.Eq_trans
import Split.List_nil

-- Array.toList_push from environment
-- theorem Array.toList_push : forall {α : Type.{u_1}} {xs : Array.{u_1} α} {x : α}, Eq.{succ u_1} (List.{u_1} α) (Array.toList.{u_1} α (Array.push.{u_1} α xs x)) (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} α) (List.{u_1} α) (List.{u_1} α) (instHAppendOfAppend.{u_1} (List.{u_1} α) (List.instAppend.{u_1} α)) (Array.toList.{u_1} α xs) (List.cons.{u_1} α x (List.nil.{u_1} α)))

-- Stub: this file represents the declaration `Array.toList_push`.
-- In a full split, the body would be extracted from the environment.
