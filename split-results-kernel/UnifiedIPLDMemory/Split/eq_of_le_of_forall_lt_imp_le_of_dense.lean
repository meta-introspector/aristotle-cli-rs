import Split.Preorder_toLT
import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.LE_le
import Split.le_antisymm
import Split.LT_lt
import Split.le_of_forall_gt_imp_ge_of_dense
import Split.DenselyOrdered
import Split.LinearOrder_toPartialOrder
import Split.Eq

-- eq_of_le_of_forall_lt_imp_le_of_dense from environment
-- theorem eq_of_le_of_forall_lt_imp_le_of_dense : forall {α : Type.{u_2}} [inst._@.Mathlib.Order.Basic.2961541860._hygCtx._hyg.8 : LinearOrder.{u_2} α] [inst._@.Mathlib.Order.Basic.2961541860._hygCtx._hyg.11 : DenselyOrdered.{u_2} α (Preorder.toLT.{u_2} α (PartialOrder.toPreorder.{u_2} α (LinearOrder.toPartialOrder.{u_2} α inst._@.Mathlib.Order.Basic.2961541860._hygCtx._hyg.8)))] {a₁ : α} {a₂ : α}, (LE.le.{u_2} α (Preorder.toLE.{u_2} α (PartialOrder.toPreorder.{u_2} α (LinearOrder.toPartialOrder.{u_2} α inst._@.Mathlib.Order.Basic.2961541860._hygCtx._hyg.8))) a₂ a₁) -> (forall (a : α), (LT.lt.{u_2} α (Preorder.toLT.{u_2} α (PartialOrder.toPreorder.{u_2} α (LinearOrder.toPartialOrder.{u_2} α inst._@.Mathlib.Order.Basic.2961541860._hygCtx._hyg.8))) a₂ a) -> (LE.le.{u_2} α (Preorder.toLE.{u_2} α (PartialOrder.toPreorder.{u_2} α (LinearOrder.toPartialOrder.{u_2} α inst._@.Mathlib.Order.Basic.2961541860._hygCtx._hyg.8))) a₁ a)) -> (Eq.{succ u_2} α a₁ a₂)

-- Stub: this file represents the declaration `eq_of_le_of_forall_lt_imp_le_of_dense`.
-- In a full split, the body would be extracted from the environment.
