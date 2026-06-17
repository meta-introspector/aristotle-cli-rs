import Split.Array_instAppend
import Split.congrArg
import Split.Array_ext'
import Split.Array_toList_append
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

-- List.append_toArray from environment
-- theorem List.append_toArray : forall {α : Type.{u_1}} (l₁ : List.{u_1} α) (l₂ : List.{u_1} α), Eq.{succ u_1} (Array.{u_1} α) (HAppend.hAppend.{u_1, u_1, u_1} (Array.{u_1} α) (Array.{u_1} α) (Array.{u_1} α) (instHAppendOfAppend.{u_1} (Array.{u_1} α) (Array.instAppend.{u_1} α)) (List.toArray.{u_1} α l₁) (List.toArray.{u_1} α l₂)) (List.toArray.{u_1} α (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} α) (List.{u_1} α) (List.{u_1} α) (instHAppendOfAppend.{u_1} (List.{u_1} α) (List.instAppend.{u_1} α)) l₁ l₂))

-- Stub: this file represents the declaration `List.append_toArray`.
-- In a full split, the body would be extracted from the environment.
