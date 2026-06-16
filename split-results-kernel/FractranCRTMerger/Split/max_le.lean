import Split.Eq_mpr
import Split.congrArg
import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.LinearOrder_toDecidableLE
import Split.id
import Split.max_def'
import Split.LE_le
import Split.if_pos
import Split.dite
import Split.LinearOrder_toMax
import Split.Max_max
import Split.LinearOrder_toPartialOrder
import Split.Eq
import Split.if_neg
import Split.Not
import Split.ite

-- max_le from environment
-- theorem max_le : forall {α : Type.{u_1}} [inst._@.Mathlib.Order.Defs.LinearOrder.2064398530._hygCtx._hyg.3 : LinearOrder.{u_1} α] {a : α} {b : α} {c : α}, (LE.le.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α (LinearOrder.toPartialOrder.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.2064398530._hygCtx._hyg.3))) a c) -> (LE.le.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α (LinearOrder.toPartialOrder.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.2064398530._hygCtx._hyg.3))) b c) -> (LE.le.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α (LinearOrder.toPartialOrder.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.2064398530._hygCtx._hyg.3))) (Max.max.{u_1} α (LinearOrder.toMax.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.2064398530._hygCtx._hyg.3) a b) c)

-- Stub: this file represents the declaration `max_le`.
-- In a full split, the body would be extracted from the environment.
