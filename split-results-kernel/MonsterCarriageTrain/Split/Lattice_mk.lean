import Split.Lattice
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.LE_le
import Split.SemilatticeSup_toPartialOrder
import Split.SemilatticeSup

-- Lattice.mk from environment
-- constructor Lattice.mk : forall {α : Type.{u}} [toSemilatticeSup : SemilatticeSup.{u} α] (inf : α -> α -> α), (forall (a : α) (b : α), LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeSup.toPartialOrder.{u} α toSemilatticeSup))) (inf a b) a) -> (forall (a : α) (b : α), LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeSup.toPartialOrder.{u} α toSemilatticeSup))) (inf a b) b) -> (forall (a : α) (b : α) (c : α), (LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeSup.toPartialOrder.{u} α toSemilatticeSup))) a b) -> (LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeSup.toPartialOrder.{u} α toSemilatticeSup))) a c) -> (LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeSup.toPartialOrder.{u} α toSemilatticeSup))) a (inf b c))) -> (Lattice.{u} α)

-- Stub: this file represents the declaration `Lattice.mk`.
-- In a full split, the body would be extracted from the environment.
