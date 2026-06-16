import Split.Multiset_Nodup
import Split.Multiset_map
import Split.Membership_mem
import Split.Multiset
import Split.Multiset_inj_on_of_nodup_map
import Split.Multiset_instMembership
import Split.Iff
import Split.Iff_intro
import Split.Eq
import Split.Multiset_Nodup_map_on

-- Multiset.nodup_map_iff_inj_on from environment
-- theorem Multiset.nodup_map_iff_inj_on : forall {α : Type.{u_1}} {β : Type.{v}} {f : α -> β} {s : Multiset.{u_1} α}, (Multiset.Nodup.{u_1} α s) -> (Iff (Multiset.Nodup.{v} β (Multiset.map.{v, u_1} α β f s)) (forall (x : α), (Membership.mem.{u_1, u_1} α (Multiset.{u_1} α) (Multiset.instMembership.{u_1} α) s x) -> (forall (y : α), (Membership.mem.{u_1, u_1} α (Multiset.{u_1} α) (Multiset.instMembership.{u_1} α) s y) -> (Eq.{succ v} β (f x) (f y)) -> (Eq.{succ u_1} α x y))))

-- Stub: this file represents the declaration `Multiset.nodup_map_iff_inj_on`.
-- In a full split, the body would be extracted from the environment.
