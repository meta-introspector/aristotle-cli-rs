import Split.List_cons
import Split.instHAppendOfAppend
import Split.List
import Split.List_instAppend
import Split.Eq
import Split.HAppend_hAppend
import Split.rfl

-- List.cons_append from environment
-- theorem List.cons_append : forall {α : Type.{u}} {a : α} {as : List.{u} α} {bs : List.{u} α}, Eq.{succ u} (List.{u} α) (HAppend.hAppend.{u, u, u} (List.{u} α) (List.{u} α) (List.{u} α) (instHAppendOfAppend.{u} (List.{u} α) (List.instAppend.{u} α)) (List.cons.{u} α a as) bs) (List.cons.{u} α a (HAppend.hAppend.{u, u, u} (List.{u} α) (List.{u} α) (List.{u} α) (instHAppendOfAppend.{u} (List.{u} α) (List.instAppend.{u} α)) as bs))

-- Stub: this file represents the declaration `List.cons_append`.
-- In a full split, the body would be extracted from the environment.
