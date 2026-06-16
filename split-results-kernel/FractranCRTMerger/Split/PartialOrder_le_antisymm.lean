import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.PartialOrder
import Split.LE_le
import Split.Eq

-- PartialOrder.le_antisymm from environment
-- theorem PartialOrder.le_antisymm : forall {α : Type.{u_2}} [self : PartialOrder.{u_2} α] (a : α) (b : α), (LE.le.{u_2} α (Preorder.toLE.{u_2} α (PartialOrder.toPreorder.{u_2} α self)) a b) -> (LE.le.{u_2} α (Preorder.toLE.{u_2} α (PartialOrder.toPreorder.{u_2} α self)) b a) -> (Eq.{succ u_2} α a b)

-- Stub: this file represents the declaration `PartialOrder.le_antisymm`.
-- In a full split, the body would be extracted from the environment.
