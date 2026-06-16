import Split.lt_iff_not_ge
import Split.Preorder_toLT
import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.LE_le
import Split.Iff
import Split.LT_lt
import Split.LinearOrder_toPartialOrder
import Split.Not
import Split.Iff_symm

-- not_le from environment
-- theorem not_le : forall {α : Type.{u_1}} [inst._@.Mathlib.Order.Defs.LinearOrder.3960588850._hygCtx._hyg.3 : LinearOrder.{u_1} α] {a : α} {b : α}, Iff (Not (LE.le.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α (LinearOrder.toPartialOrder.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.3960588850._hygCtx._hyg.3))) a b)) (LT.lt.{u_1} α (Preorder.toLT.{u_1} α (PartialOrder.toPreorder.{u_1} α (LinearOrder.toPartialOrder.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.3960588850._hygCtx._hyg.3))) b a)

-- Stub: this file represents the declaration `not_le`.
-- In a full split, the body would be extracted from the environment.
