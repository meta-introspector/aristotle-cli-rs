import Split.Membership_mem
import Split.Set_instUnion
import Split.Set_instSingletonSet
import Split.HasSubset_Subset
import Split.Bornology_mk
import Split.Set_instEmptyCollection
import Split.Union_union
import Split.EmptyCollection_emptyCollection
import Split.Singleton_singleton
import Split.Set_instMembership
import Split.Filter_comk
import Split.Bornology
import Split.Set_instHasSubset
import Split.Set

-- Bornology.ofBounded from environment
-- def Bornology.ofBounded : forall {α : Type.{u_4}} (B : Set.{u_4} (Set.{u_4} α)), (Membership.mem.{u_4, u_4} (Set.{u_4} α) (Set.{u_4} (Set.{u_4} α)) (Set.instMembership.{u_4} (Set.{u_4} α)) B (EmptyCollection.emptyCollection.{u_4} (Set.{u_4} α) (Set.instEmptyCollection.{u_4} α))) -> (forall (s₁ : Set.{u_4} α), (Membership.mem.{u_4, u_4} (Set.{u_4} α) (Set.{u_4} (Set.{u_4} α)) (Set.instMembership.{u_4} (Set.{u_4} α)) B s₁) -> (forall (s₂ : Set.{u_4} α), (HasSubset.Subset.{u_4} (Set.{u_4} α) (Set.instHasSubset.{u_4} α) s₂ s₁) -> (Membership.mem.{u_4, u_4} (Set.{u_4} α) (Set.{u_4} (Set.{u_4} α)) (Set.instMembership.{u_4} (Set.{u_4} α)) B s₂))) -> (forall (s₁ : Set.{u_4} α), (Membership.mem.{u_4, u_4} (Set.{u_4} α) (Set.{u_4} (Set.{u_4} α)) (Set.instMembership.{u_4} (Set.{u_4} α)) B s₁) -> (forall (s₂ : Set.{u_4} α), (Membership.mem.{u_4, u_4} (Set.{u_4} α) (Set.{u_4} (Set.{u_4} α)) (Set.instMembership.{u_4} (Set.{u_4} α)) B s₂) -> (Membership.mem.{u_4, u_4} (Set.{u_4} α) (Set.{u_4} (Set.{u_4} α)) (Set.instMembership.{u_4} (Set.{u_4} α)) B (Union.union.{u_4} (Set.{u_4} α) (Set.instUnion.{u_4} α) s₁ s₂)))) -> (forall (x : α), Membership.mem.{u_4, u_4} (Set.{u_4} α) (Set.{u_4} (Set.{u_4} α)) (Set.instMembership.{u_4} (Set.{u_4} α)) B (Singleton.singleton.{u_4, u_4} α (Set.{u_4} α) (Set.instSingletonSet.{u_4} α) x)) -> (Bornology.{u_4} α)
-- (definition body omitted)

-- Stub: this file represents the declaration `Bornology.ofBounded`.
-- In a full split, the body would be extracted from the environment.
