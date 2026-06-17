import Split.setOf
import Split.Membership_mem
import Split.HasSubset_Subset
import Split.And
import Split.Set_inter_eq_self_of_subset_right
import Split.Eq
import Split.Set_instMembership
import Split.Set_instHasSubset
import Split.Set

-- Set.sep_eq_of_subset from environment
-- theorem Set.sep_eq_of_subset : forall {α : Type.{u}} {s : Set.{u} α} {t : Set.{u} α}, (HasSubset.Subset.{u} (Set.{u} α) (Set.instHasSubset.{u} α) s t) -> (Eq.{succ u} (Set.{u} α) (setOf.{u} α (fun (x : α) => And (Membership.mem.{u, u} α (Set.{u} α) (Set.instMembership.{u} α) t x) (Membership.mem.{u, u} α (Set.{u} α) (Set.instMembership.{u} α) s x))) s)

-- Stub: this file represents the declaration `Set.sep_eq_of_subset`.
-- In a full split, the body would be extracted from the environment.
