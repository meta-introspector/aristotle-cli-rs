import Split.congrArg
import Split.List_map
import Split.Function_comp
import Split.List_rec
import Split.List_cons
import Split.List
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.congrFun'
import Split.Eq
import Split.Eq_trans
import Split.List_nil

-- List.map_map from environment
-- theorem List.map_map : forall {β : Type.{u_1}} {γ : Type.{u_2}} {α : Type.{u_3}} {g : β -> γ} {f : α -> β} {l : List.{u_3} α}, Eq.{succ u_2} (List.{u_2} γ) (List.map.{u_1, u_2} β γ g (List.map.{u_3, u_1} α β f l)) (List.map.{u_3, u_2} α γ (Function.comp.{succ u_3, succ u_1, succ u_2} α β γ g f) l)

-- Stub: this file represents the declaration `List.map_map`.
-- In a full split, the body would be extracted from the environment.
