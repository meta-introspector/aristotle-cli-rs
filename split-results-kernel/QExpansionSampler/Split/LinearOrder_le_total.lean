import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.LE_le
import Split.Or
import Split.LinearOrder_toPartialOrder

-- LinearOrder.le_total from environment
-- theorem LinearOrder.le_total : forall {α : Type.{u_2}} [self : LinearOrder.{u_2} α] (a : α) (b : α), Or (LE.le.{u_2} α (Preorder.toLE.{u_2} α (PartialOrder.toPreorder.{u_2} α (LinearOrder.toPartialOrder.{u_2} α self))) a b) (LE.le.{u_2} α (Preorder.toLE.{u_2} α (PartialOrder.toPreorder.{u_2} α (LinearOrder.toPartialOrder.{u_2} α self))) b a)

-- Stub: this file represents the declaration `LinearOrder.le_total`.
-- In a full split, the body would be extracted from the environment.
