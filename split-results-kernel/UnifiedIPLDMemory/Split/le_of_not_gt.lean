import Split.Preorder_toLT
import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.LE_le
import Split.le_or_gt
import Split.LT_lt
import Split.Or_resolve_right
import Split.LinearOrder_toPartialOrder
import Split.Not

-- le_of_not_gt from environment
-- theorem le_of_not_gt : forall {α : Type.{u_1}} [inst._@.Mathlib.Order.Defs.LinearOrder.2977137._hygCtx._hyg.3 : LinearOrder.{u_1} α] {a : α} {b : α}, (Not (LT.lt.{u_1} α (Preorder.toLT.{u_1} α (PartialOrder.toPreorder.{u_1} α (LinearOrder.toPartialOrder.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.2977137._hygCtx._hyg.3))) b a)) -> (LE.le.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α (LinearOrder.toPartialOrder.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.2977137._hygCtx._hyg.3))) a b)

-- Stub: this file represents the declaration `le_of_not_gt`.
-- In a full split, the body would be extracted from the environment.
