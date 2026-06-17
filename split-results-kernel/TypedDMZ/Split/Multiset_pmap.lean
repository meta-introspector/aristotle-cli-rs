import Split.Quot_recOn
import Split.Membership_mem
import Split.Multiset
import Split.Multiset_instMembership
import Split.List_pmap
import Split.List
import Split.Multiset_ofList
import Split.List_isSetoid
import Split.Setoid_r
import Split.Quot_mk

-- Multiset.pmap from environment
-- def Multiset.pmap : forall {α : Type.{u_1}} {β : Type.{v}} {p : α -> Prop}, (forall (a : α), (p a) -> β) -> (forall (s : Multiset.{u_1} α), (forall (a : α), (Membership.mem.{u_1, u_1} α (Multiset.{u_1} α) (Multiset.instMembership.{u_1} α) s a) -> (p a)) -> (Multiset.{v} β))
-- (definition body omitted)

-- Stub: this file represents the declaration `Multiset.pmap`.
-- In a full split, the body would be extracted from the environment.
