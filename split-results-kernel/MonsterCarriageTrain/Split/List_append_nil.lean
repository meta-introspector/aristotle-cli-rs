import Split.congrArg
import Split.id
import Split.List_rec
import Split.List_cons
import Split.List_append
import Split.instHAppendOfAppend
import Split.List
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.Eq_refl
import Split.congrFun'
import Split.List_instAppend
import Split.Eq
import Split.HAppend_hAppend
import Split.Eq_trans
import Split.List_nil

-- List.append_nil from environment
-- theorem List.append_nil : forall {α : Type.{u}} (as : List.{u} α), Eq.{succ u} (List.{u} α) (HAppend.hAppend.{u, u, u} (List.{u} α) (List.{u} α) (List.{u} α) (instHAppendOfAppend.{u} (List.{u} α) (List.instAppend.{u} α)) as (List.nil.{u} α)) as

-- Stub: this file represents the declaration `List.append_nil`.
-- In a full split, the body would be extracted from the environment.
