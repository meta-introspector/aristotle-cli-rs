import Split.Lattice
import Split.Lattice_toSemilatticeSup
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.InfSet
import Split.SupSet
import Split.IsGLB
import Split.IsLUB
import Split.SemilatticeSup_toPartialOrder
import Split.BoundedOrder
import Split.CompleteLattice
import Split.InfSet_sInf
import Split.SupSet_sSup
import Split.Set

-- CompleteLattice.mk from environment
-- constructor CompleteLattice.mk : forall {α : Type.{u_8}} [toLattice : Lattice.{u_8} α] [toSupSet : SupSet.{u_8} α], (forall (s : Set.{u_8} α), IsLUB.{u_8} α (Preorder.toLE.{u_8} α (PartialOrder.toPreorder.{u_8} α (SemilatticeSup.toPartialOrder.{u_8} α (Lattice.toSemilatticeSup.{u_8} α toLattice)))) s (SupSet.sSup.{u_8} α toSupSet s)) -> (forall [toInfSet : InfSet.{u_8} α], (forall (s : Set.{u_8} α), IsGLB.{u_8} α (Preorder.toLE.{u_8} α (PartialOrder.toPreorder.{u_8} α (SemilatticeSup.toPartialOrder.{u_8} α (Lattice.toSemilatticeSup.{u_8} α toLattice)))) s (InfSet.sInf.{u_8} α toInfSet s)) -> (forall [toBoundedOrder : BoundedOrder.{u_8} α (Preorder.toLE.{u_8} α (PartialOrder.toPreorder.{u_8} α (SemilatticeSup.toPartialOrder.{u_8} α (Lattice.toSemilatticeSup.{u_8} α toLattice))))], CompleteLattice.{u_8} α))

-- Stub: this file represents the declaration `CompleteLattice.mk`.
-- In a full split, the body would be extracted from the environment.
