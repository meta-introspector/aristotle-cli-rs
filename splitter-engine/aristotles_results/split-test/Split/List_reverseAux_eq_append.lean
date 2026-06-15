import Split.Eq_mpr
import Split.List_append_assoc
import Split.congrArg
import Split.List_reverseAux
import Split.id
import Split.List_rec
import Split.List_cons
import Split.instHAppendOfAppend
import Split.List
import Split.eq_self
import Split.of_eq_true
import Split.Eq_refl
import Split.List_instAppend
import Split.Eq
import Split.HAppend_hAppend
import Split.List_nil

-- List.reverseAux_eq_append from environment
-- theorem List.reverseAux_eq_append : forall {α : Type.{u}} {as : List.{u} α} {bs : List.{u} α}, Eq.{succ u} (List.{u} α) (List.reverseAux.{u} α as bs) (HAppend.hAppend.{u, u, u} (List.{u} α) (List.{u} α) (List.{u} α) (instHAppendOfAppend.{u} (List.{u} α) (List.instAppend.{u} α)) (List.reverseAux.{u} α as (List.nil.{u} α)) bs)

-- Stub: this file represents the declaration `List.reverseAux_eq_append`.
-- In a full split, the body would be extracted from the environment.
