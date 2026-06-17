import Split.Iff_mpr
import Split.Preorder_toLT
import Split.lt_iff_le_not_ge
import Split.Preorder_toLE
import Split.LE_le
import Split.And
import Split.And_intro
import Split.LT_lt
import Split.Not
import Split.Preorder

-- lt_of_le_not_ge from environment
-- theorem lt_of_le_not_ge : forall {α : Type.{u_1}} [inst._@.Mathlib.Order.Defs.PartialOrder.2987136776._hygCtx._hyg.3 : Preorder.{u_1} α] {a : α} {b : α}, (LE.le.{u_1} α (Preorder.toLE.{u_1} α inst._@.Mathlib.Order.Defs.PartialOrder.2987136776._hygCtx._hyg.3) a b) -> (Not (LE.le.{u_1} α (Preorder.toLE.{u_1} α inst._@.Mathlib.Order.Defs.PartialOrder.2987136776._hygCtx._hyg.3) b a)) -> (LT.lt.{u_1} α (Preorder.toLT.{u_1} α inst._@.Mathlib.Order.Defs.PartialOrder.2987136776._hygCtx._hyg.3) a b)

-- Stub: this file represents the declaration `lt_of_le_not_ge`.
-- In a full split, the body would be extracted from the environment.
