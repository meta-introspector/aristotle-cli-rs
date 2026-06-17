import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.CompleteSemilatticeInf_isGLB_sInf
import Split.CompleteSemilatticeInf_toPartialOrder
import Split.IsGLB
import Split.CompleteSemilatticeInf
import Split.CompleteSemilatticeInf_toInfSet
import Split.InfSet_sInf
import Split.Set

-- isGLB_sInf from environment
-- theorem isGLB_sInf : forall {α : Type.{u_1}} [inst._@.Mathlib.Order.CompleteLattice.Defs.1592264405._hygCtx._hyg.13 : CompleteSemilatticeInf.{u_1} α] (s : Set.{u_1} α), IsGLB.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α (CompleteSemilatticeInf.toPartialOrder.{u_1} α inst._@.Mathlib.Order.CompleteLattice.Defs.1592264405._hygCtx._hyg.13))) s (InfSet.sInf.{u_1} α (CompleteSemilatticeInf.toInfSet.{u_1} α inst._@.Mathlib.Order.CompleteLattice.Defs.1592264405._hygCtx._hyg.13) s)

-- Stub: this file represents the declaration `isGLB_sInf`.
-- In a full split, the body would be extracted from the environment.
