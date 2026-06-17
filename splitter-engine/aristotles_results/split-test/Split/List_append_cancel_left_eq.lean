import Split.congrArg
import Split.List_append_cancel_left
import Split.instHAppendOfAppend
import Split.List
import Split.True
import Split.Iff_intro
import Split.eq_self
import Split.propext
import Split.of_eq_true
import Split.congrFun'
import Split.List_instAppend
import Split.Eq
import Split.HAppend_hAppend
import Split.Eq_trans

-- List.append_cancel_left_eq from environment
-- theorem List.append_cancel_left_eq : forall {α : Type.{u_1}} (as : List.{u_1} α) (bs : List.{u_1} α) (cs : List.{u_1} α), Eq.{1} Prop (Eq.{succ u_1} (List.{u_1} α) (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} α) (List.{u_1} α) (List.{u_1} α) (instHAppendOfAppend.{u_1} (List.{u_1} α) (List.instAppend.{u_1} α)) as bs) (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} α) (List.{u_1} α) (List.{u_1} α) (instHAppendOfAppend.{u_1} (List.{u_1} α) (List.instAppend.{u_1} α)) as cs)) (Eq.{succ u_1} (List.{u_1} α) bs cs)

-- Stub: this file represents the declaration `List.append_cancel_left_eq`.
-- In a full split, the body would be extracted from the environment.
