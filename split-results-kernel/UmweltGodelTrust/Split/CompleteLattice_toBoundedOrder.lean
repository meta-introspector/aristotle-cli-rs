import Split.Lattice_toSemilatticeSup
import Split.CompleteLattice_toLattice
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.SemilatticeSup_toPartialOrder
import Split.BoundedOrder
import Split.CompleteLattice

-- CompleteLattice.toBoundedOrder from environment
-- def CompleteLattice.toBoundedOrder : forall {α : Type.{u_8}} [self : CompleteLattice.{u_8} α], BoundedOrder.{u_8} α (Preorder.toLE.{u_8} α (PartialOrder.toPreorder.{u_8} α (SemilatticeSup.toPartialOrder.{u_8} α (Lattice.toSemilatticeSup.{u_8} α (CompleteLattice.toLattice.{u_8} α self)))))
-- (definition body omitted)

-- Stub: this file represents the declaration `CompleteLattice.toBoundedOrder`.
-- In a full split, the body would be extracted from the environment.
