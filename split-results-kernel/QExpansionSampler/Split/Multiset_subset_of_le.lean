import Split.Multiset_instHasSubset
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.Multiset
import Split.HasSubset_Subset
import Split.LE_le
import Split.List
import Split.Quotient_inductionOn₂
import Split.List_Subperm_subset
import Split.List_isSetoid
import Split.Multiset_instPartialOrder

-- Multiset.subset_of_le from environment
-- theorem Multiset.subset_of_le : forall {α : Type.{u_1}} {s : Multiset.{u_1} α} {t : Multiset.{u_1} α}, (LE.le.{u_1} (Multiset.{u_1} α) (Preorder.toLE.{u_1} (Multiset.{u_1} α) (PartialOrder.toPreorder.{u_1} (Multiset.{u_1} α) (Multiset.instPartialOrder.{u_1} α))) s t) -> (HasSubset.Subset.{u_1} (Multiset.{u_1} α) (Multiset.instHasSubset.{u_1} α) s t)

-- Stub: this file represents the declaration `Multiset.subset_of_le`.
-- In a full split, the body would be extracted from the environment.
