import Split.List_instHasSubset
import Split.Membership_mem
import Split.HasSubset_Subset
import Split.List
import Split.List_instMembership

-- List.Subset.trans from environment
-- theorem List.Subset.trans : forall {α : Type.{u_1}} {l₁ : List.{u_1} α} {l₂ : List.{u_1} α} {l₃ : List.{u_1} α}, (HasSubset.Subset.{u_1} (List.{u_1} α) (List.instHasSubset.{u_1} α) l₁ l₂) -> (HasSubset.Subset.{u_1} (List.{u_1} α) (List.instHasSubset.{u_1} α) l₂ l₃) -> (HasSubset.Subset.{u_1} (List.{u_1} α) (List.instHasSubset.{u_1} α) l₁ l₃)

-- Stub: this file represents the declaration `List.Subset.trans`.
-- In a full split, the body would be extracted from the environment.
