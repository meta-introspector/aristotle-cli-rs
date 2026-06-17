import Split.Lattice_toSemilatticeSup
import Split.CompleteLattice_toLattice
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.CompleteLattice_toInfSet
import Split.IsGLB
import Split.SemilatticeSup_toPartialOrder
import Split.CompleteLattice
import Split.InfSet_sInf
import Split.Set

-- CompleteLattice.isGLB_sInf from environment
-- theorem CompleteLattice.isGLB_sInf : forall {α : Type.{u_8}} [self : CompleteLattice.{u_8} α] (s : Set.{u_8} α), IsGLB.{u_8} α (Preorder.toLE.{u_8} α (PartialOrder.toPreorder.{u_8} α (SemilatticeSup.toPartialOrder.{u_8} α (Lattice.toSemilatticeSup.{u_8} α (CompleteLattice.toLattice.{u_8} α self))))) s (InfSet.sInf.{u_8} α (CompleteLattice.toInfSet.{u_8} α self) s)

-- Stub: this file represents the declaration `CompleteLattice.isGLB_sInf`.
-- In a full split, the body would be extracted from the environment.
