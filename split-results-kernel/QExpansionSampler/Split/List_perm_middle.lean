import Split.List_brecOn
import Split.List_Perm_cons
import Split.List_Perm
import Split.List_Perm_refl
import Split.List_Perm_swap
import Split.List_Perm_trans
import Split.List_cons
import Split.instHAppendOfAppend
import Split.List
import Split.List_below
import Split.List_instAppend
import Split.HAppend_hAppend
import Split.List_nil

-- List.perm_middle from environment
-- theorem List.perm_middle : forall {α : Type.{u_1}} {a : α} {l₁ : List.{u_1} α} {l₂ : List.{u_1} α}, List.Perm.{u_1} α (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} α) (List.{u_1} α) (List.{u_1} α) (instHAppendOfAppend.{u_1} (List.{u_1} α) (List.instAppend.{u_1} α)) l₁ (List.cons.{u_1} α a l₂)) (List.cons.{u_1} α a (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} α) (List.{u_1} α) (List.{u_1} α) (instHAppendOfAppend.{u_1} (List.{u_1} α) (List.instAppend.{u_1} α)) l₁ l₂))

-- Stub: this file represents the declaration `List.perm_middle`.
-- In a full split, the body would be extracted from the environment.
