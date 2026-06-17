import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.SemilatticeInf_toPartialOrder
import Split.LE_le
import Split.SemilatticeInf_inf
import Split.SemilatticeInf

-- SemilatticeInf.inf_le_right from environment
-- theorem SemilatticeInf.inf_le_right : forall {α : Type.{u}} [self : SemilatticeInf.{u} α] (a : α) (b : α), LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeInf.toPartialOrder.{u} α self))) (SemilatticeInf.inf.{u} α self a b) b

-- Stub: this file represents the declaration `SemilatticeInf.inf_le_right`.
-- In a full split, the body would be extracted from the environment.
