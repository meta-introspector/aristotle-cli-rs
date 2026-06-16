import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.PartialOrder
import Split.LE_le
import Split.SemilatticeSup

-- SemilatticeSup.mk from environment
-- constructor SemilatticeSup.mk : forall {α : Type.{u}} [toPartialOrder : PartialOrder.{u} α] (sup : α -> α -> α), (forall (a : α) (b : α), LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α toPartialOrder)) a (sup a b)) -> (forall (a : α) (b : α), LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α toPartialOrder)) b (sup a b)) -> (forall (a : α) (b : α) (c : α), (LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α toPartialOrder)) a c) -> (LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α toPartialOrder)) b c) -> (LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α toPartialOrder)) (sup a b) c)) -> (SemilatticeSup.{u} α)

-- Stub: this file represents the declaration `SemilatticeSup.mk`.
-- In a full split, the body would be extracted from the environment.
