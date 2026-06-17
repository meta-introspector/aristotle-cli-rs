import Split.Iff_mpr
import Split.List_Pairwise
import Split.List_map
import Split.List_pairwise_map
import Split.List
import Split.List_Pairwise_imp

-- List.Pairwise.map from environment
-- theorem List.Pairwise.map : forall {β : Type.{u_1}} {α : Type.{u_2}} {R : α -> α -> Prop} {l : List.{u_2} α} {S : β -> β -> Prop} (f : α -> β), (forall (a : α) (b : α), (R a b) -> (S (f a) (f b))) -> (List.Pairwise.{u_2} α R l) -> (List.Pairwise.{u_1} β S (List.map.{u_2, u_1} α β f l))

-- Stub: this file represents the declaration `List.Pairwise.map`.
-- In a full split, the body would be extracted from the environment.
