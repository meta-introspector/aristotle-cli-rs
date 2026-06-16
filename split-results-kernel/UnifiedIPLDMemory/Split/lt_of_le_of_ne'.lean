import Split.Preorder_toLT
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.mt
import Split.PartialOrder
import Split.Ne
import Split.LE_le
import Split.ge_antisymm
import Split.lt_of_le_not_ge
import Split.LT_lt
import Split.Eq

-- lt_of_le_of_ne' from environment
-- theorem lt_of_le_of_ne' : forall {α : Type.{u_1}} [inst._@.Mathlib.Order.Defs.PartialOrder.2732534281._hygCtx._hyg.3 : PartialOrder.{u_1} α] {a : α} {b : α}, (LE.le.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α inst._@.Mathlib.Order.Defs.PartialOrder.2732534281._hygCtx._hyg.3)) b a) -> (Ne.{succ u_1} α a b) -> (LT.lt.{u_1} α (Preorder.toLT.{u_1} α (PartialOrder.toPreorder.{u_1} α inst._@.Mathlib.Order.Defs.PartialOrder.2732534281._hygCtx._hyg.3)) b a)

-- Stub: this file represents the declaration `lt_of_le_of_ne'`.
-- In a full split, the body would be extracted from the environment.
