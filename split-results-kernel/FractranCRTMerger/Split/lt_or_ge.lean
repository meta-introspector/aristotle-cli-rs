import Split.Preorder_toLT
import Split.LinearOrder
import Split.lt_of_not_ge
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.LinearOrder_toDecidableLE
import Split.LE_le
import Split.dite
import Split.LT_lt
import Split.Or_inl
import Split.Or
import Split.LinearOrder_toPartialOrder
import Split.Not
import Split.Or_inr

-- lt_or_ge from environment
-- theorem lt_or_ge : forall {α : Type.{u_1}} [inst._@.Mathlib.Order.Defs.LinearOrder.3672051305._hygCtx._hyg.3 : LinearOrder.{u_1} α] (a : α) (b : α), Or (LT.lt.{u_1} α (Preorder.toLT.{u_1} α (PartialOrder.toPreorder.{u_1} α (LinearOrder.toPartialOrder.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.3672051305._hygCtx._hyg.3))) a b) (LE.le.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α (LinearOrder.toPartialOrder.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.3672051305._hygCtx._hyg.3))) b a)

-- Stub: this file represents the declaration `lt_or_ge`.
-- In a full split, the body would be extracted from the environment.
