import Split.Lattice
import Split.Lattice_toSemilatticeSup
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.LE_le
import Split.Lattice_inf
import Split.SemilatticeSup_toPartialOrder

-- Lattice.inf_le_left from environment
-- theorem Lattice.inf_le_left : forall {α : Type.{u}} [self : Lattice.{u} α] (a : α) (b : α), LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeSup.toPartialOrder.{u} α (Lattice.toSemilatticeSup.{u} α self)))) (Lattice.inf.{u} α self a b) a

-- Stub: this file represents the declaration `Lattice.inf_le_left`.
-- In a full split, the body would be extracted from the environment.
