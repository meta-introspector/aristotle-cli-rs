import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.SemilatticeInf_toPartialOrder
import Split.LE_le
import Split.SemilatticeInf_inf
import Split.SemilatticeInf

-- SemilatticeInf.le_inf from environment
-- theorem SemilatticeInf.le_inf : forall {α : Type.{u}} [self : SemilatticeInf.{u} α] (a : α) (b : α) (c : α), (LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeInf.toPartialOrder.{u} α self))) a b) -> (LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeInf.toPartialOrder.{u} α self))) a c) -> (LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeInf.toPartialOrder.{u} α self))) a (SemilatticeInf.inf.{u} α self b c))

-- Stub: this file represents the declaration `SemilatticeInf.le_inf`.
-- In a full split, the body would be extracted from the environment.
