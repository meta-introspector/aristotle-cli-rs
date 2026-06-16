import Split.Lattice
import Split.Preorder_toLT
import Split.Lattice_toSemilatticeSup
import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.Ord_mk
import Split.SemilatticeInf_toPartialOrder
import Split.SemilatticeSup_toMax
import Split.compareOfLessAndEq
import Split.SemilatticeInf_toMin
import Split.LE_le
import Split.DecidableLE
import Split.LinearOrder_mk
import Split.Std_Total
import Split.DecidableLT
import Split.Lattice_toSemilatticeInf
import Split.DecidableEq

-- Lattice.toLinearOrder from environment
-- def Lattice.toLinearOrder : forall (α : Type.{u}) [inst._@.Mathlib.Order.Lattice.1771108483._hygCtx._hyg.5 : Lattice.{u} α] [inst._@.Mathlib.Order.Lattice.1771108483._hygCtx._hyg.8 : DecidableEq.{succ u} α] [inst._@.Mathlib.Order.Lattice.1771108483._hygCtx._hyg.11 : DecidableLE.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeInf.toPartialOrder.{u} α (Lattice.toSemilatticeInf.{u} α inst._@.Mathlib.Order.Lattice.1771108483._hygCtx._hyg.5))))] [inst._@.Mathlib.Order.Lattice.1771108483._hygCtx._hyg.14 : DecidableLT.{u} α (Preorder.toLT.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeInf.toPartialOrder.{u} α (Lattice.toSemilatticeInf.{u} α inst._@.Mathlib.Order.Lattice.1771108483._hygCtx._hyg.5))))] [inst._@.Mathlib.Order.Lattice.1771108483._hygCtx._hyg.17 : Std.Total.{succ u} α (fun (x1._@.Mathlib.Order.Lattice.1771108483._hygCtx._hyg.22 : α) (x2._@.Mathlib.Order.Lattice.1771108483._hygCtx._hyg.22 : α) => LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeInf.toPartialOrder.{u} α (Lattice.toSemilatticeInf.{u} α inst._@.Mathlib.Order.Lattice.1771108483._hygCtx._hyg.5)))) x1._@.Mathlib.Order.Lattice.1771108483._hygCtx._hyg.22 x2._@.Mathlib.Order.Lattice.1771108483._hygCtx._hyg.22)], LinearOrder.{u} α
-- (definition body omitted)

-- Stub: this file represents the declaration `Lattice.toLinearOrder`.
-- In a full split, the body would be extracted from the environment.
