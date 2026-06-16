import Split.instReflLe
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.PartialOrder
import Split.LE_le
import Split.RelEmbedding_ofMapRelIff
import Split.Iff
import Split.OrderEmbedding
import Split.instAntisymmLe
import Split.Preorder

-- OrderEmbedding.ofMapLEIff from environment
-- def OrderEmbedding.ofMapLEIff : forall {α : Type.{u_6}} {β : Type.{u_7}} [inst._@.Mathlib.Order.Hom.Basic.1086438904._hygCtx._hyg.20 : PartialOrder.{u_6} α] [inst._@.Mathlib.Order.Hom.Basic.1086438904._hygCtx._hyg.23 : Preorder.{u_7} β] (f : α -> β), (forall (a : α) (b : α), Iff (LE.le.{u_7} β (Preorder.toLE.{u_7} β inst._@.Mathlib.Order.Hom.Basic.1086438904._hygCtx._hyg.23) (f a) (f b)) (LE.le.{u_6} α (Preorder.toLE.{u_6} α (PartialOrder.toPreorder.{u_6} α inst._@.Mathlib.Order.Hom.Basic.1086438904._hygCtx._hyg.20)) a b)) -> (OrderEmbedding.{u_6, u_7} α β (Preorder.toLE.{u_6} α (PartialOrder.toPreorder.{u_6} α inst._@.Mathlib.Order.Hom.Basic.1086438904._hygCtx._hyg.20)) (Preorder.toLE.{u_7} β inst._@.Mathlib.Order.Hom.Basic.1086438904._hygCtx._hyg.23))
-- (definition body omitted)

-- Stub: this file represents the declaration `OrderEmbedding.ofMapLEIff`.
-- In a full split, the body would be extracted from the environment.
