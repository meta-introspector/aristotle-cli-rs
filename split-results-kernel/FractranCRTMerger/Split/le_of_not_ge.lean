import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.Or_resolve_left
import Split.le_total
import Split.LE_le
import Split.LinearOrder_toPartialOrder
import Split.Not

-- le_of_not_ge from environment
-- theorem le_of_not_ge : forall {α : Type.{u_1}} [inst._@.Mathlib.Order.Defs.LinearOrder.2853965226._hygCtx._hyg.3 : LinearOrder.{u_1} α] {a : α} {b : α}, (Not (LE.le.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α (LinearOrder.toPartialOrder.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.2853965226._hygCtx._hyg.3))) a b)) -> (LE.le.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α (LinearOrder.toPartialOrder.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.2853965226._hygCtx._hyg.3))) b a)

-- Stub: this file represents the declaration `le_of_not_ge`.
-- In a full split, the body would be extracted from the environment.
