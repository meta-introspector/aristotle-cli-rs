import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.LE_le
import Split.Or
import Split.LinearOrder_le_total
import Split.LinearOrder_toPartialOrder

-- le_total from environment
-- theorem le_total : forall {α : Type.{u_1}} [inst._@.Mathlib.Order.Defs.LinearOrder.477940745._hygCtx._hyg.3 : LinearOrder.{u_1} α] (a : α) (b : α), Or (LE.le.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α (LinearOrder.toPartialOrder.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.477940745._hygCtx._hyg.3))) a b) (LE.le.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α (LinearOrder.toPartialOrder.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.477940745._hygCtx._hyg.3))) b a)

-- Stub: this file represents the declaration `le_total`.
-- In a full split, the body would be extracted from the environment.
