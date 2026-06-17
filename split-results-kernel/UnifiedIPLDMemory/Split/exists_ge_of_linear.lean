import Split.le_rfl
import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.Exists
import Split.le_total
import Split.LE_le
import Split.And
import Split.And_intro
import Split.Exists_intro
import Split.Or
import Split.LinearOrder_toPartialOrder

-- exists_ge_of_linear from environment
-- theorem exists_ge_of_linear : forall {α : Type.{u_2}} [inst._@.Mathlib.Order.Basic.66579818._hygCtx._hyg.8 : LinearOrder.{u_2} α] (a : α) (b : α), Exists.{succ u_2} α (fun (c : α) => And (LE.le.{u_2} α (Preorder.toLE.{u_2} α (PartialOrder.toPreorder.{u_2} α (LinearOrder.toPartialOrder.{u_2} α inst._@.Mathlib.Order.Basic.66579818._hygCtx._hyg.8))) a c) (LE.le.{u_2} α (Preorder.toLE.{u_2} α (PartialOrder.toPreorder.{u_2} α (LinearOrder.toPartialOrder.{u_2} α inst._@.Mathlib.Order.Basic.66579818._hygCtx._hyg.8))) b c))

-- Stub: this file represents the declaration `exists_ge_of_linear`.
-- In a full split, the body would be extracted from the environment.
