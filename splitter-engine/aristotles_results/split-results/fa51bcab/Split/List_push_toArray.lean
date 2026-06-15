import Split.Array_toList_push
import Split.Array_push
import Split.congrArg
import Split.Array_ext'
import Split.Array_toList
import Split.List_toArray
import Split.List_cons
import Split.Array
import Split.instHAppendOfAppend
import Split.List
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.congrFun'
import Split.List_instAppend
import Split.Eq
import Split.HAppend_hAppend
import Split.Eq_trans
import Split.List_nil

-- List.push_toArray from environment
-- theorem List.push_toArray : forall {α : Type.{u_1}} (l : List.{u_1} α) (a : α), Eq.{succ u_1} (Array.{u_1} α) (Array.push.{u_1} α (List.toArray.{u_1} α l) a) (List.toArray.{u_1} α (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} α) (List.{u_1} α) (List.{u_1} α) (instHAppendOfAppend.{u_1} (List.{u_1} α) (List.instAppend.{u_1} α)) l (List.cons.{u_1} α a (List.nil.{u_1} α))))

-- Stub: this file represents the declaration `List.push_toArray`.
-- In a full split, the body would be extracted from the environment.
