import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.LE_le
import Split.SemilatticeSup_toPartialOrder
import Split.SemilatticeSup
import Split.SemilatticeSup_sup

-- SemilatticeSup.le_sup_right from environment
-- theorem SemilatticeSup.le_sup_right : forall {α : Type.{u}} [self : SemilatticeSup.{u} α] (a : α) (b : α), LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeSup.toPartialOrder.{u} α self))) b (SemilatticeSup.sup.{u} α self a b)

-- Stub: this file represents the declaration `SemilatticeSup.le_sup_right`.
-- In a full split, the body would be extracted from the environment.
