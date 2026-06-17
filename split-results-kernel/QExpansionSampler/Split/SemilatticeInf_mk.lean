import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.PartialOrder
import Split.LE_le
import Split.SemilatticeInf

-- SemilatticeInf.mk from environment
-- constructor SemilatticeInf.mk : forall {α : Type.{u}} [toPartialOrder : PartialOrder.{u} α] (inf : α -> α -> α), (forall (a : α) (b : α), LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α toPartialOrder)) (inf a b) a) -> (forall (a : α) (b : α), LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α toPartialOrder)) (inf a b) b) -> (forall (a : α) (b : α) (c : α), (LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α toPartialOrder)) a b) -> (LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α toPartialOrder)) a c) -> (LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α toPartialOrder)) a (inf b c))) -> (SemilatticeInf.{u} α)

-- Stub: this file represents the declaration `SemilatticeInf.mk`.
-- In a full split, the body would be extracted from the environment.
