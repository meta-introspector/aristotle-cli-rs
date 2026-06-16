import Split.Lattice
import Split.Lattice_toSemilatticeSup
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.SemilatticeSup_toMax
import Split.SemilatticeInf_toMin
import Split.LE_le
import Split.SemilatticeInf_mk
import Split.DistribLattice
import Split.Max_max
import Split.Lattice_inf_le_left
import Split.Lattice_le_inf
import Split.Lattice_inf
import Split.SemilatticeSup_toPartialOrder
import Split.Min_min
import Split.Lattice_inf_le_right

-- DistribLattice.mk from environment
-- constructor DistribLattice.mk : forall {α : Type.{u_1}} [toLattice : Lattice.{u_1} α], (forall (x : α) (y : α) (z : α), LE.le.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α (SemilatticeSup.toPartialOrder.{u_1} α (Lattice.toSemilatticeSup.{u_1} α toLattice)))) (Min.min.{u_1} α (SemilatticeInf.toMin.{u_1} α (SemilatticeInf.mk.{u_1} α (SemilatticeSup.toPartialOrder.{u_1} α (Lattice.toSemilatticeSup.{u_1} α toLattice)) (Lattice.inf.{u_1} α toLattice) (Lattice.inf_le_left.{u_1} α toLattice) (Lattice.inf_le_right.{u_1} α toLattice) (Lattice.le_inf.{u_1} α toLattice))) (Max.max.{u_1} α (SemilatticeSup.toMax.{u_1} α (Lattice.toSemilatticeSup.{u_1} α toLattice)) x y) (Max.max.{u_1} α (SemilatticeSup.toMax.{u_1} α (Lattice.toSemilatticeSup.{u_1} α toLattice)) x z)) (Max.max.{u_1} α (SemilatticeSup.toMax.{u_1} α (Lattice.toSemilatticeSup.{u_1} α toLattice)) x (Min.min.{u_1} α (SemilatticeInf.toMin.{u_1} α (SemilatticeInf.mk.{u_1} α (SemilatticeSup.toPartialOrder.{u_1} α (Lattice.toSemilatticeSup.{u_1} α toLattice)) (Lattice.inf.{u_1} α toLattice) (Lattice.inf_le_left.{u_1} α toLattice) (Lattice.inf_le_right.{u_1} α toLattice) (Lattice.le_inf.{u_1} α toLattice))) y z))) -> (DistribLattice.{u_1} α)

-- Stub: this file represents the declaration `DistribLattice.mk`.
-- In a full split, the body would be extracted from the environment.
