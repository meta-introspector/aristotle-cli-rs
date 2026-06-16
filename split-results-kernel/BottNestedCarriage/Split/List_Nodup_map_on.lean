import Split.False
import Split.List_Pairwise
import Split.List_Pairwise_and_mem
import Split.List_map
import Split.Membership_mem
import Split.Ne
import Split.List_Nodup
import Split.List
import Split.And
import Split.List_instMembership
import Split.List_Pairwise_map
import Split.Iff_mp
import Split.Eq

-- List.Nodup.map_on from environment
-- theorem List.Nodup.map_on : forall {α : Type.{u}} {β : Type.{v}} {l : List.{u} α} {f : α -> β}, (forall (x : α), (Membership.mem.{u, u} α (List.{u} α) (List.instMembership.{u} α) l x) -> (forall (y : α), (Membership.mem.{u, u} α (List.{u} α) (List.instMembership.{u} α) l y) -> (Eq.{succ v} β (f x) (f y)) -> (Eq.{succ u} α x y))) -> (List.Nodup.{u} α l) -> (List.Nodup.{v} β (List.map.{u, v} α β f l))

-- Stub: this file represents the declaration `List.Nodup.map_on`.
-- In a full split, the body would be extracted from the environment.
