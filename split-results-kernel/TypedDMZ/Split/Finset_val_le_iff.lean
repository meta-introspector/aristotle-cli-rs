import Split.Multiset_le_iff_subset
import Split.Finset
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.Multiset
import Split.HasSubset_Subset
import Split.Finset_nodup
import Split.LE_le
import Split.Finset_val
import Split.Iff
import Split.Finset_instHasSubset
import Split.Multiset_instPartialOrder

-- Finset.val_le_iff from environment
-- theorem Finset.val_le_iff : forall {α : Type.{u_1}} {s₁ : Finset.{u_1} α} {s₂ : Finset.{u_1} α}, Iff (LE.le.{u_1} (Multiset.{u_1} α) (Preorder.toLE.{u_1} (Multiset.{u_1} α) (PartialOrder.toPreorder.{u_1} (Multiset.{u_1} α) (Multiset.instPartialOrder.{u_1} α))) (Finset.val.{u_1} α s₁) (Finset.val.{u_1} α s₂)) (HasSubset.Subset.{u_1} (Finset.{u_1} α) (Finset.instHasSubset.{u_1} α) s₁ s₂)

-- Stub: this file represents the declaration `Finset.val_le_iff`.
-- In a full split, the body would be extracted from the environment.
