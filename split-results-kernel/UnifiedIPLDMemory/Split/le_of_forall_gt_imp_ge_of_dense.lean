import Split.False
import Split.Preorder_toLT
import Split.lt_irrefl
import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.Exists
import Split.le_of_not_gt
import Split.exists_between
import Split.LE_le
import Split.And
import Split.LT_lt
import Split.DenselyOrdered
import Split.LinearOrder_toPartialOrder
import Split.lt_of_lt_of_le

-- le_of_forall_gt_imp_ge_of_dense from environment
-- theorem le_of_forall_gt_imp_ge_of_dense : forall {α : Type.{u_2}} [inst._@.Mathlib.Order.Basic.2837767031._hygCtx._hyg.8 : LinearOrder.{u_2} α] [inst._@.Mathlib.Order.Basic.2837767031._hygCtx._hyg.11 : DenselyOrdered.{u_2} α (Preorder.toLT.{u_2} α (PartialOrder.toPreorder.{u_2} α (LinearOrder.toPartialOrder.{u_2} α inst._@.Mathlib.Order.Basic.2837767031._hygCtx._hyg.8)))] {a₁ : α} {a₂ : α}, (forall (a : α), (LT.lt.{u_2} α (Preorder.toLT.{u_2} α (PartialOrder.toPreorder.{u_2} α (LinearOrder.toPartialOrder.{u_2} α inst._@.Mathlib.Order.Basic.2837767031._hygCtx._hyg.8))) a₂ a) -> (LE.le.{u_2} α (Preorder.toLE.{u_2} α (PartialOrder.toPreorder.{u_2} α (LinearOrder.toPartialOrder.{u_2} α inst._@.Mathlib.Order.Basic.2837767031._hygCtx._hyg.8))) a₁ a)) -> (LE.le.{u_2} α (Preorder.toLE.{u_2} α (PartialOrder.toPreorder.{u_2} α (LinearOrder.toPartialOrder.{u_2} α inst._@.Mathlib.Order.Basic.2837767031._hygCtx._hyg.8))) a₁ a₂)

-- Stub: this file represents the declaration `le_of_forall_gt_imp_ge_of_dense`.
-- In a full split, the body would be extracted from the environment.
