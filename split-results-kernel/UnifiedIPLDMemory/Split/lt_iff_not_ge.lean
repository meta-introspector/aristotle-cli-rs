import Split.Preorder_toLT
import Split.LinearOrder
import Split.lt_of_not_ge
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.LE_le
import Split.Iff
import Split.LT_lt
import Split.Iff_intro
import Split.not_le_of_gt
import Split.LinearOrder_toPartialOrder
import Split.Not

-- lt_iff_not_ge from environment
-- theorem lt_iff_not_ge : forall {α : Type.{u_1}} [inst._@.Mathlib.Order.Defs.LinearOrder.3120544122._hygCtx._hyg.3 : LinearOrder.{u_1} α] {a : α} {b : α}, Iff (LT.lt.{u_1} α (Preorder.toLT.{u_1} α (PartialOrder.toPreorder.{u_1} α (LinearOrder.toPartialOrder.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.3120544122._hygCtx._hyg.3))) a b) (Not (LE.le.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α (LinearOrder.toPartialOrder.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.3120544122._hygCtx._hyg.3))) b a))

-- Stub: this file represents the declaration `lt_iff_not_ge`.
-- In a full split, the body would be extracted from the environment.
