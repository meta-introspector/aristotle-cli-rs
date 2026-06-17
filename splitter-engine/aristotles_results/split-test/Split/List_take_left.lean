import Split.List_brecOn
import Split.congrArg
import Split.List_cons
import Split.List_append
import Split.instHAppendOfAppend
import Split.List
import Split.List_below
import Split.List_instAppend
import Split.Eq
import Split.List_take
import Split.List_length
import Split.HAppend_hAppend
import Split.rfl
import Split.List_nil

-- List.take_left from environment
-- theorem List.take_left : forall {α : Type.{u_1}} {l₁ : List.{u_1} α} {l₂ : List.{u_1} α}, Eq.{succ u_1} (List.{u_1} α) (List.take.{u_1} α (List.length.{u_1} α l₁) (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} α) (List.{u_1} α) (List.{u_1} α) (instHAppendOfAppend.{u_1} (List.{u_1} α) (List.instAppend.{u_1} α)) l₁ l₂)) l₁

-- Stub: this file represents the declaration `List.take_left`.
-- In a full split, the body would be extracted from the environment.
