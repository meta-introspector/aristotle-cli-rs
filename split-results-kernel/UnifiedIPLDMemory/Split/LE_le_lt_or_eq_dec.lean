import Split.Preorder_toLT
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.PartialOrder
import Split.Decidable_lt_or_eq_of_le
import Split.LE_le
import Split.DecidableLE
import Split.LT_lt
import Split.Or
import Split.Eq

-- LE.le.lt_or_eq_dec from environment
-- theorem LE.le.lt_or_eq_dec : forall {α : Type.{u_1}} [inst._@.Mathlib.Order.Defs.PartialOrder.1136135823._hygCtx._hyg.3 : PartialOrder.{u_1} α] {a : α} {b : α} [inst._@.Mathlib.Order.Defs.PartialOrder.1136135823._hygCtx._hyg.8 : DecidableLE.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α inst._@.Mathlib.Order.Defs.PartialOrder.1136135823._hygCtx._hyg.3))], (LE.le.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α inst._@.Mathlib.Order.Defs.PartialOrder.1136135823._hygCtx._hyg.3)) a b) -> (Or (LT.lt.{u_1} α (Preorder.toLT.{u_1} α (PartialOrder.toPreorder.{u_1} α inst._@.Mathlib.Order.Defs.PartialOrder.1136135823._hygCtx._hyg.3)) a b) (Eq.{succ u_1} α a b))

-- Stub: this file represents the declaration `LE.le.lt_or_eq_dec`.
-- In a full split, the body would be extracted from the environment.
