import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.LE_le
import Split.SemilatticeSup_toPartialOrder
import Split.SemilatticeSup
import Split.SemilatticeSup_sup

-- SemilatticeSup.sup_le from environment
-- theorem SemilatticeSup.sup_le : forall {α : Type.{u}} [self : SemilatticeSup.{u} α] (a : α) (b : α) (c : α), (LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeSup.toPartialOrder.{u} α self))) a c) -> (LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeSup.toPartialOrder.{u} α self))) b c) -> (LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeSup.toPartialOrder.{u} α self))) (SemilatticeSup.sup.{u} α self a b) c)

-- Stub: this file represents the declaration `SemilatticeSup.sup_le`.
-- In a full split, the body would be extracted from the environment.
