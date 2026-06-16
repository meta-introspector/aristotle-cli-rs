import Split.Preorder_toLT
import Split.lt_or_eq_of_le
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.PartialOrder
import Split.LE_le
import Split.LT_lt
import Split.Or
import Split.Eq

-- LE.le.lt_or_eq from environment
-- theorem LE.le.lt_or_eq : forall {α : Type.{u_1}} [inst._@.Mathlib.Order.Defs.PartialOrder.1136135824._hygCtx._hyg.3 : PartialOrder.{u_1} α] {a : α} {b : α}, (LE.le.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α inst._@.Mathlib.Order.Defs.PartialOrder.1136135824._hygCtx._hyg.3)) a b) -> (Or (LT.lt.{u_1} α (Preorder.toLT.{u_1} α (PartialOrder.toPreorder.{u_1} α inst._@.Mathlib.Order.Defs.PartialOrder.1136135824._hygCtx._hyg.3)) a b) (Eq.{succ u_1} α a b))

-- Stub: this file represents the declaration `LE.le.lt_or_eq`.
-- In a full split, the body would be extracted from the environment.
