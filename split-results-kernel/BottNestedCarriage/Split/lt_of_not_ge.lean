import Split.Preorder_toLT
import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.le_of_not_ge
import Split.LE_le
import Split.lt_of_le_not_ge
import Split.LT_lt
import Split.LinearOrder_toPartialOrder
import Split.Not

-- lt_of_not_ge from environment
-- theorem lt_of_not_ge : forall {α : Type.{u_1}} [inst._@.Mathlib.Order.Defs.LinearOrder.4066266414._hygCtx._hyg.3 : LinearOrder.{u_1} α] {a : α} {b : α}, (Not (LE.le.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α (LinearOrder.toPartialOrder.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.4066266414._hygCtx._hyg.3))) b a)) -> (LT.lt.{u_1} α (Preorder.toLT.{u_1} α (PartialOrder.toPreorder.{u_1} α (LinearOrder.toPartialOrder.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.4066266414._hygCtx._hyg.3))) a b)

-- Stub: this file represents the declaration `lt_of_not_ge`.
-- In a full split, the body would be extracted from the environment.
