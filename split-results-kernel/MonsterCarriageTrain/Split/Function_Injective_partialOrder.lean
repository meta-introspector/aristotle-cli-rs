import Split.Preorder_toLT
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.PartialOrder
import Split.LE_le
import Split.LE
import Split.Iff
import Split.LT_lt
import Split.Function_Injective
import Split.Function_Injective_preorder
import Split.PartialOrder_mk
import Split.Preorder
import Split.LT

-- Function.Injective.partialOrder from environment
-- def Function.Injective.partialOrder : forall {α : Type.{u_2}} {β : Type.{u_3}} [inst._@.Mathlib.Order.Basic.222664250._hygCtx._hyg.8 : PartialOrder.{u_3} β] [inst._@.Mathlib.Order.Basic.222664250._hygCtx._hyg.11 : LE.{u_2} α] [inst._@.Mathlib.Order.Basic.222664250._hygCtx._hyg.14 : LT.{u_2} α] (f : α -> β), (Function.Injective.{succ u_2, succ u_3} α β f) -> (forall {x : α} {y : α}, Iff (LE.le.{u_3} β (Preorder.toLE.{u_3} β (PartialOrder.toPreorder.{u_3} β inst._@.Mathlib.Order.Basic.222664250._hygCtx._hyg.8)) (f x) (f y)) (LE.le.{u_2} α inst._@.Mathlib.Order.Basic.222664250._hygCtx._hyg.11 x y)) -> (forall {x : α} {y : α}, Iff (LT.lt.{u_3} β (Preorder.toLT.{u_3} β (PartialOrder.toPreorder.{u_3} β inst._@.Mathlib.Order.Basic.222664250._hygCtx._hyg.8)) (f x) (f y)) (LT.lt.{u_2} α inst._@.Mathlib.Order.Basic.222664250._hygCtx._hyg.14 x y)) -> (PartialOrder.{u_2} α)
-- (definition body omitted)

-- Stub: this file represents the declaration `Function.Injective.partialOrder`.
-- In a full split, the body would be extracted from the environment.
