import Split.Eq_mpr
import Split.congrArg
import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.LinearOrder_toDecidableLE
import Split.id
import Split.LE_le
import Split.if_pos
import Split.dite
import Split.min_def
import Split.LinearOrder_toMin
import Split.LinearOrder_toPartialOrder
import Split.Eq
import Split.if_neg
import Split.Not
import Split.Min_min
import Split.ite

-- le_min from environment
-- theorem le_min : forall {α : Type.{u_1}} [inst._@.Mathlib.Order.Defs.LinearOrder.2064398530._hygCtx._hyg.3 : LinearOrder.{u_1} α] {a : α} {b : α} {c : α}, (LE.le.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α (LinearOrder.toPartialOrder.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.2064398530._hygCtx._hyg.3))) c a) -> (LE.le.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α (LinearOrder.toPartialOrder.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.2064398530._hygCtx._hyg.3))) c b) -> (LE.le.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α (LinearOrder.toPartialOrder.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.2064398530._hygCtx._hyg.3))) c (Min.min.{u_1} α (LinearOrder.toMin.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.2064398530._hygCtx._hyg.3) a b))

-- Stub: this file represents the declaration `le_min`.
-- In a full split, the body would be extracted from the environment.
