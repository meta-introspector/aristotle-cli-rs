import Split.Preorder_toLT
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.PartialOrder
import Split.LE_le
import Split.dite
import Split.DecidableLE
import Split.ge_antisymm
import Split.lt_of_le_not_ge
import Split.LT_lt
import Split.Or_inl
import Split.Or
import Split.Eq
import Split.Not
import Split.Or_inr

-- Decidable.lt_or_eq_of_le' from environment
-- theorem Decidable.lt_or_eq_of_le' : forall {α : Type.{u_1}} [inst._@.Mathlib.Order.Defs.PartialOrder.1136135823._hygCtx._hyg.3 : PartialOrder.{u_1} α] {a : α} {b : α} [inst._@.Mathlib.Order.Defs.PartialOrder.1136135823._hygCtx._hyg.8 : DecidableLE.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α inst._@.Mathlib.Order.Defs.PartialOrder.1136135823._hygCtx._hyg.3))], (LE.le.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α inst._@.Mathlib.Order.Defs.PartialOrder.1136135823._hygCtx._hyg.3)) b a) -> (Or (LT.lt.{u_1} α (Preorder.toLT.{u_1} α (PartialOrder.toPreorder.{u_1} α inst._@.Mathlib.Order.Defs.PartialOrder.1136135823._hygCtx._hyg.3)) b a) (Eq.{succ u_1} α a b))

-- Stub: this file represents the declaration `Decidable.lt_or_eq_of_le'`.
-- In a full split, the body would be extracted from the environment.
