import Split.Multiset_map
import Split.List_map
import Split.Membership_mem
import Split.Quot_inductionOn
import Split.Multiset
import Split.List_map_congr_left
import Split.congr_arg
import Split.Multiset_instMembership
import Split.List
import Split.Eq_ndrec
import Split.List_isSetoid
import Split.Eq
import Split.Setoid_r
import Split.Quot_mk

-- Multiset.map_congr from environment
-- theorem Multiset.map_congr : forall {α : Type.{u_1}} {β : Type.{v}} {f : α -> β} {g : α -> β} {s : Multiset.{u_1} α} {t : Multiset.{u_1} α}, (Eq.{succ u_1} (Multiset.{u_1} α) s t) -> (forall (x : α), (Membership.mem.{u_1, u_1} α (Multiset.{u_1} α) (Multiset.instMembership.{u_1} α) t x) -> (Eq.{succ v} β (f x) (g x))) -> (Eq.{succ v} (Multiset.{v} β) (Multiset.map.{v, u_1} α β f s) (Multiset.map.{v, u_1} α β g t))

-- Stub: this file represents the declaration `Multiset.map_congr`.
-- In a full split, the body would be extracted from the environment.
