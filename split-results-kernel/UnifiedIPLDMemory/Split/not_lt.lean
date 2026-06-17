import Split.Preorder_toLT
import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.le_of_not_gt
import Split.LE_le
import Split.Iff
import Split.LT_lt
import Split.Iff_intro
import Split.LinearOrder_toPartialOrder
import Split.Not
import Split.not_lt_of_ge

-- not_lt from environment
-- theorem not_lt : forall {α : Type.{u_1}} [inst._@.Mathlib.Order.Defs.LinearOrder.4272507027._hygCtx._hyg.3 : LinearOrder.{u_1} α] {a : α} {b : α}, Iff (Not (LT.lt.{u_1} α (Preorder.toLT.{u_1} α (PartialOrder.toPreorder.{u_1} α (LinearOrder.toPartialOrder.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.4272507027._hygCtx._hyg.3))) a b)) (LE.le.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α (LinearOrder.toPartialOrder.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.4272507027._hygCtx._hyg.3))) b a)

-- Stub: this file represents the declaration `not_lt`.
-- In a full split, the body would be extracted from the environment.
