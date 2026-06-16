import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.PartialOrder
import Split.InfSet
import Split.IsGLB
import Split.CompleteSemilatticeInf
import Split.InfSet_sInf
import Split.Set

-- CompleteSemilatticeInf.mk from environment
-- constructor CompleteSemilatticeInf.mk : forall {α : Type.{u_8}} [toPartialOrder : PartialOrder.{u_8} α] [toInfSet : InfSet.{u_8} α], (forall (s : Set.{u_8} α), IsGLB.{u_8} α (Preorder.toLE.{u_8} α (PartialOrder.toPreorder.{u_8} α toPartialOrder)) s (InfSet.sInf.{u_8} α toInfSet s)) -> (CompleteSemilatticeInf.{u_8} α)

-- Stub: this file represents the declaration `CompleteSemilatticeInf.mk`.
-- In a full split, the body would be extracted from the environment.
