import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.LE_le_antisymm
import Split.PartialOrder
import Split.LE_le
import Split.OrderTop
import Split.OrderTop_toTop
import Split.le_top
import Split.Top_top
import Split.Eq

-- top_unique from environment
-- theorem top_unique : forall {α : Type.{u}} [inst._@.Mathlib.Order.BoundedOrder.Basic.1371460233._hygCtx._hyg.4 : PartialOrder.{u} α] [inst._@.Mathlib.Order.BoundedOrder.Basic.1371460233._hygCtx._hyg.7 : OrderTop.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α inst._@.Mathlib.Order.BoundedOrder.Basic.1371460233._hygCtx._hyg.4))] {a : α}, (LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α inst._@.Mathlib.Order.BoundedOrder.Basic.1371460233._hygCtx._hyg.4)) (Top.top.{u} α (OrderTop.toTop.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α inst._@.Mathlib.Order.BoundedOrder.Basic.1371460233._hygCtx._hyg.4)) inst._@.Mathlib.Order.BoundedOrder.Basic.1371460233._hygCtx._hyg.7)) a) -> (Eq.{succ u} α a (Top.top.{u} α (OrderTop.toTop.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α inst._@.Mathlib.Order.BoundedOrder.Basic.1371460233._hygCtx._hyg.4)) inst._@.Mathlib.Order.BoundedOrder.Basic.1371460233._hygCtx._hyg.7)))

-- Stub: this file represents the declaration `top_unique`.
-- In a full split, the body would be extracted from the environment.
