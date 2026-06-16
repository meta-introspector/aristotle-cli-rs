import Split.List_brecOn
import Split.Membership_mem
import Split.List_cons
import Split.List
import Split.List_instMembership
import Split.List_below
import Split.List_pmap_match_1
import Split.List_nil

-- List.pmap from environment
-- def List.pmap : forall {α : Type.{u_1}} {β : Type.{u_2}} {P : α -> Prop}, (forall (a : α), (P a) -> β) -> (forall (l : List.{u_1} α), (forall (a : α), (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) l a) -> (P a)) -> (List.{u_2} β))
-- (definition body omitted)

-- Stub: this file represents the declaration `List.pmap`.
-- In a full split, the body would be extracted from the environment.
