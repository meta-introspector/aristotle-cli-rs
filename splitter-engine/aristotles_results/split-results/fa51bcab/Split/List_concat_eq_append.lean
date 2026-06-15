import Split.congrArg
import Split.List_concat
import Split.List_rec
import Split.List_cons
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

-- List.concat_eq_append from environment
-- theorem List.concat_eq_append : forall {α : Type.{u}} {as : List.{u} α} {a : α}, Eq.{succ u} (List.{u} α) (List.concat.{u} α as a) (HAppend.hAppend.{u, u, u} (List.{u} α) (List.{u} α) (List.{u} α) (instHAppendOfAppend.{u} (List.{u} α) (List.instAppend.{u} α)) as (List.cons.{u} α a (List.nil.{u} α)))

-- Stub: this file represents the declaration `List.concat_eq_append`.
-- In a full split, the body would be extracted from the environment.
