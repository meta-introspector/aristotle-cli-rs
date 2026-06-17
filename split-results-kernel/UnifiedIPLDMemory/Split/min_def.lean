import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.LinearOrder_toDecidableLE
import Split.LE_le
import Split.LinearOrder_toMin
import Split.LinearOrder_toPartialOrder
import Split.Eq
import Split.LinearOrder_min_def
import Split.Min_min
import Split.ite

-- min_def from environment
-- theorem min_def : forall {α : Type.{u_1}} [inst._@.Mathlib.Order.Defs.LinearOrder.714559417._hygCtx._hyg.3 : LinearOrder.{u_1} α] (a : α) (b : α), Eq.{succ u_1} α (Min.min.{u_1} α (LinearOrder.toMin.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.714559417._hygCtx._hyg.3) a b) (ite.{succ u_1} α (LE.le.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α (LinearOrder.toPartialOrder.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.714559417._hygCtx._hyg.3))) a b) (LinearOrder.toDecidableLE.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.714559417._hygCtx._hyg.3 a b) a b)

-- Stub: this file represents the declaration `min_def`.
-- In a full split, the body would be extracted from the environment.
