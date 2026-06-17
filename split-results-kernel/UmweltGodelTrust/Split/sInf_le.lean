import Split.lowerBounds
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.Membership_mem
import Split.upperBounds
import Split.LE_le
import Split.isGLB_sInf
import Split.CompleteSemilatticeInf_toPartialOrder
import Split.And_left
import Split.CompleteSemilatticeInf
import Split.CompleteSemilatticeInf_toInfSet
import Split.Set_instMembership
import Split.InfSet_sInf
import Split.Set

-- sInf_le from environment
-- theorem sInf_le : forall {α : Type.{u_1}} [inst._@.Mathlib.Order.CompleteLattice.Defs.2274666900._hygCtx._hyg.13 : CompleteSemilatticeInf.{u_1} α] {s : Set.{u_1} α} {a : α}, (Membership.mem.{u_1, u_1} α (Set.{u_1} α) (Set.instMembership.{u_1} α) s a) -> (LE.le.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α (CompleteSemilatticeInf.toPartialOrder.{u_1} α inst._@.Mathlib.Order.CompleteLattice.Defs.2274666900._hygCtx._hyg.13))) (InfSet.sInf.{u_1} α (CompleteSemilatticeInf.toInfSet.{u_1} α inst._@.Mathlib.Order.CompleteLattice.Defs.2274666900._hygCtx._hyg.13) s) a)

-- Stub: this file represents the declaration `sInf_le`.
-- In a full split, the body would be extracted from the environment.
