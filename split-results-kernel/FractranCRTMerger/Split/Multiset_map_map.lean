import Split.Multiset_map
import Split.List_map
import Split.Function_comp
import Split.Quot_inductionOn
import Split.Multiset
import Split.List_map_map
import Split.congr_arg
import Split.List
import Split.List_isSetoid
import Split.Eq
import Split.Setoid_r
import Split.Quot_mk

-- Multiset.map_map from environment
-- theorem Multiset.map_map : forall {α : Type.{u_1}} {β : Type.{v}} {γ : Type.{u_2}} (g : β -> γ) (f : α -> β) (s : Multiset.{u_1} α), Eq.{succ u_2} (Multiset.{u_2} γ) (Multiset.map.{u_2, v} β γ g (Multiset.map.{v, u_1} α β f s)) (Multiset.map.{u_2, u_1} α γ (Function.comp.{succ u_1, succ v, succ u_2} α β γ g f) s)

-- Stub: this file represents the declaration `Multiset.map_map`.
-- In a full split, the body would be extracted from the environment.
