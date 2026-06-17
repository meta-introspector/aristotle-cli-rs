import Split.Array_instAppend
import Split.List_append_assoc
import Split.congrArg
import Split.Array_ext'
import Split.Array_toList_append
import Split.Array_toList
import Split.Array
import Split.instHAppendOfAppend
import Split.List
import Split.congr
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.congrFun'
import Split.List_instAppend
import Split.Eq
import Split.HAppend_hAppend
import Split.Eq_trans

-- Array.append_assoc from environment
-- theorem Array.append_assoc : forall {α : Type.{u_1}} {xs : Array.{u_1} α} {ys : Array.{u_1} α} {zs : Array.{u_1} α}, Eq.{succ u_1} (Array.{u_1} α) (HAppend.hAppend.{u_1, u_1, u_1} (Array.{u_1} α) (Array.{u_1} α) (Array.{u_1} α) (instHAppendOfAppend.{u_1} (Array.{u_1} α) (Array.instAppend.{u_1} α)) (HAppend.hAppend.{u_1, u_1, u_1} (Array.{u_1} α) (Array.{u_1} α) (Array.{u_1} α) (instHAppendOfAppend.{u_1} (Array.{u_1} α) (Array.instAppend.{u_1} α)) xs ys) zs) (HAppend.hAppend.{u_1, u_1, u_1} (Array.{u_1} α) (Array.{u_1} α) (Array.{u_1} α) (instHAppendOfAppend.{u_1} (Array.{u_1} α) (Array.instAppend.{u_1} α)) xs (HAppend.hAppend.{u_1, u_1, u_1} (Array.{u_1} α) (Array.{u_1} α) (Array.{u_1} α) (instHAppendOfAppend.{u_1} (Array.{u_1} α) (Array.instAppend.{u_1} α)) ys zs))

-- Stub: this file represents the declaration `Array.append_assoc`.
-- In a full split, the body would be extracted from the environment.
