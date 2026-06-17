import Split.Array_instAppend
import Split.congrArg
import Split.Array_ext'
import Split.Array_toList_append
import Split.List_append_nil
import Split.Array_toList
import Split.List_toArray
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

-- Array.append_empty from environment
-- theorem Array.append_empty : forall {α : Type.{u_1}} {xs : Array.{u_1} α}, Eq.{succ u_1} (Array.{u_1} α) (HAppend.hAppend.{u_1, u_1, u_1} (Array.{u_1} α) (Array.{u_1} α) (Array.{u_1} α) (instHAppendOfAppend.{u_1} (Array.{u_1} α) (Array.instAppend.{u_1} α)) xs (List.toArray.{u_1} α (List.nil.{u_1} α))) xs

-- Stub: this file represents the declaration `Array.append_empty`.
-- In a full split, the body would be extracted from the environment.
