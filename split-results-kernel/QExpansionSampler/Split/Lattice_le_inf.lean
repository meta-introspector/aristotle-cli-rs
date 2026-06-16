import Split.Lattice
import Split.Lattice_toSemilatticeSup
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.LE_le
import Split.Lattice_inf
import Split.SemilatticeSup_toPartialOrder

-- Lattice.le_inf from environment
-- theorem Lattice.le_inf : forall {α : Type.{u}} [self : Lattice.{u} α] (a : α) (b : α) (c : α), (LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeSup.toPartialOrder.{u} α (Lattice.toSemilatticeSup.{u} α self)))) a b) -> (LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeSup.toPartialOrder.{u} α (Lattice.toSemilatticeSup.{u} α self)))) a c) -> (LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeSup.toPartialOrder.{u} α (Lattice.toSemilatticeSup.{u} α self)))) a (Lattice.inf.{u} α self b c))

-- Stub: this file represents the declaration `Lattice.le_inf`.
-- In a full split, the body would be extracted from the environment.
