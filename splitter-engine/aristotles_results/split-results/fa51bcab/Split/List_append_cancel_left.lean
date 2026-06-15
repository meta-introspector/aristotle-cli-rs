import Split.List_rec
import Split.List_cons
import Split.List_append
import Split.instHAppendOfAppend
import Split.List
import Split.eq_of_heq
import Split.HEq
import Split.List_instAppend
import Split.Eq
import Split.List_cons_noConfusion
import Split.HAppend_hAppend
import Split.List_nil

-- List.append_cancel_left from environment
-- theorem List.append_cancel_left : forall {α : Type.{u_1}} {as : List.{u_1} α} {bs : List.{u_1} α} {cs : List.{u_1} α}, (Eq.{succ u_1} (List.{u_1} α) (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} α) (List.{u_1} α) (List.{u_1} α) (instHAppendOfAppend.{u_1} (List.{u_1} α) (List.instAppend.{u_1} α)) as bs) (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} α) (List.{u_1} α) (List.{u_1} α) (instHAppendOfAppend.{u_1} (List.{u_1} α) (List.instAppend.{u_1} α)) as cs)) -> (Eq.{succ u_1} (List.{u_1} α) bs cs)

-- Stub: this file represents the declaration `List.append_cancel_left`.
-- In a full split, the body would be extracted from the environment.
