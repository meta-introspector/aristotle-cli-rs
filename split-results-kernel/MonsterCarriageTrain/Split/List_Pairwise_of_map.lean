import Split.List_Pairwise
import Split.List_map
import Split.List_pairwise_map
import Split.List
import Split.Iff_mp
import Split.List_Pairwise_imp

-- List.Pairwise.of_map from environment
-- theorem List.Pairwise.of_map : forall {β : Type.{u_1}} {α : Type.{u_2}} {R : α -> α -> Prop} {l : List.{u_2} α} {S : β -> β -> Prop} (f : α -> β), (forall (a : α) (b : α), (S (f a) (f b)) -> (R a b)) -> (List.Pairwise.{u_1} β S (List.map.{u_2, u_1} α β f l)) -> (List.Pairwise.{u_2} α R l)

-- Stub: this file represents the declaration `List.Pairwise.of_map`.
-- In a full split, the body would be extracted from the environment.
