import Split.Compl_compl
import Split.setOf
import Split.Membership_mem
import Split.Set_instUnion
import Split.Filter_mk
import Split.HasSubset_Subset
import Split.Set_instCompl
import Split.Set_instEmptyCollection
import Split.Union_union
import Split.EmptyCollection_emptyCollection
import Split.Set_instMembership
import Split.Filter
import Split.Set_instHasSubset
import Split.Set

-- Filter.comk from environment
-- def Filter.comk : forall {α : Type.{u_1}} (p : (Set.{u_1} α) -> Prop), (p (EmptyCollection.emptyCollection.{u_1} (Set.{u_1} α) (Set.instEmptyCollection.{u_1} α))) -> (forall (t : Set.{u_1} α), (p t) -> (forall (s : Set.{u_1} α), (HasSubset.Subset.{u_1} (Set.{u_1} α) (Set.instHasSubset.{u_1} α) s t) -> (p s))) -> (forall (s : Set.{u_1} α), (p s) -> (forall (t : Set.{u_1} α), (p t) -> (p (Union.union.{u_1} (Set.{u_1} α) (Set.instUnion.{u_1} α) s t)))) -> (Filter.{u_1} α)
-- (definition body omitted)

-- Stub: this file represents the declaration `Filter.comk`.
-- In a full split, the body would be extracted from the environment.
