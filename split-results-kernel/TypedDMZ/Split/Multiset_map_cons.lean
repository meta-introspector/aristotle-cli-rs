import Split.Multiset_map
import Split.Quot_inductionOn
import Split.Multiset
import Split.Multiset_cons
import Split.List
import Split.List_isSetoid
import Split.Eq
import Split.rfl
import Split.Setoid_r
import Split.Quot_mk

-- Multiset.map_cons from environment
-- theorem Multiset.map_cons : forall {α : Type.{u_1}} {β : Type.{v}} (f : α -> β) (a : α) (s : Multiset.{u_1} α), Eq.{succ v} (Multiset.{v} β) (Multiset.map.{v, u_1} α β f (Multiset.cons.{u_1} α a s)) (Multiset.cons.{v} β (f a) (Multiset.map.{v, u_1} α β f s))

-- Stub: this file represents the declaration `Multiset.map_cons`.
-- In a full split, the body would be extracted from the environment.
