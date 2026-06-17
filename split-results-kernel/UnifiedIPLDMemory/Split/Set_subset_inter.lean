import Split.Membership_mem
import Split.HasSubset_Subset
import Split.Set_instInter
import Split.Inter_inter
import Split.And_intro
import Split.Set_instMembership
import Split.Set_instHasSubset
import Split.Set

-- Set.subset_inter from environment
-- theorem Set.subset_inter : forall {α : Type.{u}} {s : Set.{u} α} {t : Set.{u} α} {r : Set.{u} α}, (HasSubset.Subset.{u} (Set.{u} α) (Set.instHasSubset.{u} α) r s) -> (HasSubset.Subset.{u} (Set.{u} α) (Set.instHasSubset.{u} α) r t) -> (HasSubset.Subset.{u} (Set.{u} α) (Set.instHasSubset.{u} α) r (Inter.inter.{u} (Set.{u} α) (Set.instInter.{u} α) s t))

-- Stub: this file represents the declaration `Set.subset_inter`.
-- In a full split, the body would be extracted from the environment.
