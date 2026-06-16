import Split.Multiset_Nodup
import Split.Multiset_map
import Split.Membership_mem
import Split.Multiset
import Split.List_Nodup_map_on
import Split.Quot_induction_on
import Split.Multiset_instMembership
import Split.List
import Split.List_isSetoid
import Split.Eq
import Split.Setoid_r

-- Multiset.Nodup.map_on from environment
-- theorem Multiset.Nodup.map_on : forall {α : Type.{u_1}} {β : Type.{v}} {s : Multiset.{u_1} α} {f : α -> β}, (forall (x : α), (Membership.mem.{u_1, u_1} α (Multiset.{u_1} α) (Multiset.instMembership.{u_1} α) s x) -> (forall (y : α), (Membership.mem.{u_1, u_1} α (Multiset.{u_1} α) (Multiset.instMembership.{u_1} α) s y) -> (Eq.{succ v} β (f x) (f y)) -> (Eq.{succ u_1} α x y))) -> (Multiset.Nodup.{u_1} α s) -> (Multiset.Nodup.{v} β (Multiset.map.{v, u_1} α β f s))

-- Stub: this file represents the declaration `Multiset.Nodup.map_on`.
-- In a full split, the body would be extracted from the environment.
