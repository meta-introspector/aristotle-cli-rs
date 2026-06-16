import Split.Preorder_toLT
import Split.Decidable_lt_or_eq_of_le'
import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.LinearOrder_toDecidableLE
import Split.LE_le
import Split.Or_symm
import Split.LT_lt
import Split.Or
import Split.lt_or_ge
import Split.LinearOrder_toPartialOrder
import Split.Eq
import Split.Or_imp_right

-- lt_trichotomy from environment
-- theorem lt_trichotomy : forall {α : Type.{u_1}} [inst._@.Mathlib.Order.Defs.LinearOrder.3077274597._hygCtx._hyg.3 : LinearOrder.{u_1} α] (a : α) (b : α), Or (LT.lt.{u_1} α (Preorder.toLT.{u_1} α (PartialOrder.toPreorder.{u_1} α (LinearOrder.toPartialOrder.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.3077274597._hygCtx._hyg.3))) a b) (Or (Eq.{succ u_1} α a b) (LT.lt.{u_1} α (Preorder.toLT.{u_1} α (PartialOrder.toPreorder.{u_1} α (LinearOrder.toPartialOrder.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.3077274597._hygCtx._hyg.3))) b a))

-- Stub: this file represents the declaration `lt_trichotomy`.
-- In a full split, the body would be extracted from the environment.
