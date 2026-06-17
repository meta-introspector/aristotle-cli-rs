import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.CompleteSemilatticeInf_toPartialOrder
import Split.IsGLB
import Split.CompleteSemilatticeInf
import Split.CompleteSemilatticeInf_toInfSet
import Split.InfSet_sInf
import Split.Set

-- CompleteSemilatticeInf.isGLB_sInf from environment
-- theorem CompleteSemilatticeInf.isGLB_sInf : forall {α : Type.{u_8}} [self : CompleteSemilatticeInf.{u_8} α] (s : Set.{u_8} α), IsGLB.{u_8} α (Preorder.toLE.{u_8} α (PartialOrder.toPreorder.{u_8} α (CompleteSemilatticeInf.toPartialOrder.{u_8} α self))) s (InfSet.sInf.{u_8} α (CompleteSemilatticeInf.toInfSet.{u_8} α self) s)

-- Stub: this file represents the declaration `CompleteSemilatticeInf.isGLB_sInf`.
-- In a full split, the body would be extracted from the environment.
