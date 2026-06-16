import Split.congrArg
import Split.List_map
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

-- List.map_append from environment
-- theorem List.map_append : forall {α : Type.{u_1}} {β : Type.{u_2}} {f : α -> β} {l₁ : List.{u_1} α} {l₂ : List.{u_1} α}, Eq.{succ u_2} (List.{u_2} β) (List.map.{u_1, u_2} α β f (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} α) (List.{u_1} α) (List.{u_1} α) (instHAppendOfAppend.{u_1} (List.{u_1} α) (List.instAppend.{u_1} α)) l₁ l₂)) (HAppend.hAppend.{u_2, u_2, u_2} (List.{u_2} β) (List.{u_2} β) (List.{u_2} β) (instHAppendOfAppend.{u_2} (List.{u_2} β) (List.instAppend.{u_2} β)) (List.map.{u_1, u_2} α β f l₁) (List.map.{u_1, u_2} α β f l₂))

-- Stub: this file represents the declaration `List.map_append`.
-- In a full split, the body would be extracted from the environment.
