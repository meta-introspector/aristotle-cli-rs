import Split.Multiset_subset_of_le
import Split.Multiset_Nodup
import Split.Multiset_instHasSubset
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.Multiset
import Split.HasSubset_Subset
import Split.LE_le
import Split.Quotient_mk
import Split.List
import Split.Iff
import Split.Quotient_inductionOn₂
import Split.Iff_intro
import Split.List_isSetoid
import Split.List_Nodup_subperm
import Split.Multiset_instPartialOrder

-- Multiset.le_iff_subset from environment
-- theorem Multiset.le_iff_subset : forall {α : Type.{u_1}} {s : Multiset.{u_1} α} {t : Multiset.{u_1} α}, (Multiset.Nodup.{u_1} α s) -> (Iff (LE.le.{u_1} (Multiset.{u_1} α) (Preorder.toLE.{u_1} (Multiset.{u_1} α) (PartialOrder.toPreorder.{u_1} (Multiset.{u_1} α) (Multiset.instPartialOrder.{u_1} α))) s t) (HasSubset.Subset.{u_1} (Multiset.{u_1} α) (Multiset.instHasSubset.{u_1} α) s t))

-- Stub: this file represents the declaration `Multiset.le_iff_subset`.
-- In a full split, the body would be extracted from the environment.
