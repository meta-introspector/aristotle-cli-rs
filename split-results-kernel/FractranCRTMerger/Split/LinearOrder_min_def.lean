import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.LinearOrder_toDecidableLE
import Split.LE_le
import Split.LinearOrder_toMin
import Split.LinearOrder_toPartialOrder
import Split.Eq
import Split.Min_min
import Split.ite

-- LinearOrder.min_def from environment
-- theorem LinearOrder.min_def : forall {α : Type.{u_2}} [self : LinearOrder.{u_2} α] (a : α) (b : α), Eq.{succ u_2} α (Min.min.{u_2} α (LinearOrder.toMin.{u_2} α self) a b) (ite.{succ u_2} α (LE.le.{u_2} α (Preorder.toLE.{u_2} α (PartialOrder.toPreorder.{u_2} α (LinearOrder.toPartialOrder.{u_2} α self))) a b) (LinearOrder.toDecidableLE.{u_2} α self a b) a b)

-- Stub: this file represents the declaration `LinearOrder.min_def`.
-- In a full split, the body would be extracted from the environment.
