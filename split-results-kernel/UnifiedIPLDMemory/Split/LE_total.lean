import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.le_total
import Split.LE_le
import Split.Std_Total_mk
import Split.Std_Total
import Split.LinearOrder_toPartialOrder

-- LE.total from environment
-- theorem LE.total : forall {α : Type.{u}} [inst._@.Mathlib.Order.RelClasses.427846254._hygCtx._hyg.14 : LinearOrder.{u} α], Std.Total.{succ u} α (fun (x1._@.Mathlib.Order.RelClasses.427846254._hygCtx._hyg.21 : α) (x2._@.Mathlib.Order.RelClasses.427846254._hygCtx._hyg.21 : α) => LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (LinearOrder.toPartialOrder.{u} α inst._@.Mathlib.Order.RelClasses.427846254._hygCtx._hyg.14))) x1._@.Mathlib.Order.RelClasses.427846254._hygCtx._hyg.21 x2._@.Mathlib.Order.RelClasses.427846254._hygCtx._hyg.21)

-- Stub: this file represents the declaration `LE.total`.
-- In a full split, the body would be extracted from the environment.
