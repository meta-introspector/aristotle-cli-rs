import Split.Array_instAppend
import Split.Array_push
import Split.List_toArray
import Split.List_cons
import Split.Array
import Split.instHAppendOfAppend
import Split.Eq
import Split.HAppend_hAppend
import Split.rfl
import Split.List_nil

-- Array.push_eq_append from environment
-- theorem Array.push_eq_append : forall {α : Type.{u_1}} {a : α} {as : Array.{u_1} α}, Eq.{succ u_1} (Array.{u_1} α) (Array.push.{u_1} α as a) (HAppend.hAppend.{u_1, u_1, u_1} (Array.{u_1} α) (Array.{u_1} α) (Array.{u_1} α) (instHAppendOfAppend.{u_1} (Array.{u_1} α) (Array.instAppend.{u_1} α)) as (List.toArray.{u_1} α (List.cons.{u_1} α a (List.nil.{u_1} α))))

-- Stub: this file represents the declaration `Array.push_eq_append`.
-- In a full split, the body would be extracted from the environment.
