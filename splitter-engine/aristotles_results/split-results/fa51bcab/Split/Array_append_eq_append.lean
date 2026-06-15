import Split.Array_instAppend
import Split.Array
import Split.instHAppendOfAppend
import Split.Array_append
import Split.Eq
import Split.HAppend_hAppend
import Split.rfl

-- Array.append_eq_append from environment
-- theorem Array.append_eq_append : forall {α : Type.{u_1}} {xs : Array.{u_1} α} {ys : Array.{u_1} α}, Eq.{succ u_1} (Array.{u_1} α) (Array.append.{u_1} α xs ys) (HAppend.hAppend.{u_1, u_1, u_1} (Array.{u_1} α) (Array.{u_1} α) (Array.{u_1} α) (instHAppendOfAppend.{u_1} (Array.{u_1} α) (Array.instAppend.{u_1} α)) xs ys)

-- Stub: this file represents the declaration `Array.append_eq_append`.
-- In a full split, the body would be extracted from the environment.
