import Split.Preorder_toLT
import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.LE_le
import Split.Or_symm
import Split.LT_lt
import Split.Or
import Split.lt_or_ge
import Split.LinearOrder_toPartialOrder

-- le_or_gt from environment
-- theorem le_or_gt : forall {α : Type.{u_1}} [inst._@.Mathlib.Order.Defs.LinearOrder.791140833._hygCtx._hyg.3 : LinearOrder.{u_1} α] (a : α) (b : α), Or (LE.le.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α (LinearOrder.toPartialOrder.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.791140833._hygCtx._hyg.3))) a b) (LT.lt.{u_1} α (Preorder.toLT.{u_1} α (PartialOrder.toPreorder.{u_1} α (LinearOrder.toPartialOrder.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.791140833._hygCtx._hyg.3))) b a)

-- Stub: this file represents the declaration `le_or_gt`.
-- In a full split, the body would be extracted from the environment.
