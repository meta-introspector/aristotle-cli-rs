import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.Eq_rec
import Split.PartialOrder
import Split.LE_le
import Split.OrderTop
import Split.OrderTop_toTop
import Split.top_unique
import Split.Top_top
import Split.Eq

-- eq_top_mono from environment
-- theorem eq_top_mono : forall {α : Type.{u}} [inst._@.Mathlib.Order.BoundedOrder.Basic.2550099732._hygCtx._hyg.4 : PartialOrder.{u} α] [inst._@.Mathlib.Order.BoundedOrder.Basic.2550099732._hygCtx._hyg.7 : OrderTop.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α inst._@.Mathlib.Order.BoundedOrder.Basic.2550099732._hygCtx._hyg.4))] {a : α} {b : α}, (LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α inst._@.Mathlib.Order.BoundedOrder.Basic.2550099732._hygCtx._hyg.4)) a b) -> (Eq.{succ u} α a (Top.top.{u} α (OrderTop.toTop.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α inst._@.Mathlib.Order.BoundedOrder.Basic.2550099732._hygCtx._hyg.4)) inst._@.Mathlib.Order.BoundedOrder.Basic.2550099732._hygCtx._hyg.7))) -> (Eq.{succ u} α b (Top.top.{u} α (OrderTop.toTop.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α inst._@.Mathlib.Order.BoundedOrder.Basic.2550099732._hygCtx._hyg.4)) inst._@.Mathlib.Order.BoundedOrder.Basic.2550099732._hygCtx._hyg.7)))

-- Stub: this file represents the declaration `eq_top_mono`.
-- In a full split, the body would be extracted from the environment.
