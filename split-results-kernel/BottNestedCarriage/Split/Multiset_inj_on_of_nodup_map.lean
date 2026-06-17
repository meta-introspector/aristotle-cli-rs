import Split.Multiset_Nodup
import Split.Multiset_map
import Split.Membership_mem
import Split.Multiset
import Split.Quot_induction_on
import Split.Multiset_instMembership
import Split.List
import Split.List_inj_on_of_nodup_map
import Split.List_isSetoid
import Split.Eq
import Split.Setoid_r

-- Multiset.inj_on_of_nodup_map from environment
-- theorem Multiset.inj_on_of_nodup_map : forall {α : Type.{u_1}} {β : Type.{v}} {f : α -> β} {s : Multiset.{u_1} α}, (Multiset.Nodup.{v} β (Multiset.map.{v, u_1} α β f s)) -> (forall (x : α), (Membership.mem.{u_1, u_1} α (Multiset.{u_1} α) (Multiset.instMembership.{u_1} α) s x) -> (forall (y : α), (Membership.mem.{u_1, u_1} α (Multiset.{u_1} α) (Multiset.instMembership.{u_1} α) s y) -> (Eq.{succ v} β (f x) (f y)) -> (Eq.{succ u_1} α x y)))

-- Stub: this file represents the declaration `Multiset.inj_on_of_nodup_map`.
-- In a full split, the body would be extracted from the environment.
