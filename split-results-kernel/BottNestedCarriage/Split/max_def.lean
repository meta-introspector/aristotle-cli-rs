import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.LinearOrder_toDecidableLE
import Split.LE_le
import Split.LinearOrder_toMax
import Split.LinearOrder_max_def
import Split.Max_max
import Split.LinearOrder_toPartialOrder
import Split.Eq
import Split.ite

-- max_def from environment
-- theorem max_def : forall {α : Type.{u_1}} [inst._@.Mathlib.Order.Defs.LinearOrder.1392472907._hygCtx._hyg.3 : LinearOrder.{u_1} α] (a : α) (b : α), Eq.{succ u_1} α (Max.max.{u_1} α (LinearOrder.toMax.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.1392472907._hygCtx._hyg.3) a b) (ite.{succ u_1} α (LE.le.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α (LinearOrder.toPartialOrder.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.1392472907._hygCtx._hyg.3))) a b) (LinearOrder.toDecidableLE.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.1392472907._hygCtx._hyg.3 a b) b a)

-- Stub: this file represents the declaration `max_def`.
-- In a full split, the body would be extracted from the environment.
