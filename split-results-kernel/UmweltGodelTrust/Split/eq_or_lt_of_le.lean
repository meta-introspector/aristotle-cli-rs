import Split.Preorder_toLT
import Split.lt_or_eq_of_le
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.PartialOrder
import Split.LE_le
import Split.Or_symm
import Split.LT_lt
import Split.Or
import Split.Eq

-- eq_or_lt_of_le from environment
-- theorem eq_or_lt_of_le : forall {α : Type.{u_2}} [inst._@.Mathlib.Order.Basic.3439784136._hygCtx._hyg.8 : PartialOrder.{u_2} α] {a : α} {b : α}, (LE.le.{u_2} α (Preorder.toLE.{u_2} α (PartialOrder.toPreorder.{u_2} α inst._@.Mathlib.Order.Basic.3439784136._hygCtx._hyg.8)) a b) -> (Or (Eq.{succ u_2} α a b) (LT.lt.{u_2} α (Preorder.toLT.{u_2} α (PartialOrder.toPreorder.{u_2} α inst._@.Mathlib.Order.Basic.3439784136._hygCtx._hyg.8)) a b))

-- Stub: this file represents the declaration `eq_or_lt_of_le`.
-- In a full split, the body would be extracted from the environment.
