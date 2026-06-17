import Split.Preorder_toLT
import Split.Lattice_toSemilatticeSup
import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.SemilatticeSup_toMax
import Split.DistribLattice_toLattice
import Split.And
import Split.Iff
import Split.Max_max
import Split.sup_lt_iff
import Split.LT_lt
import Split.SemilatticeSup_toPartialOrder
import Split.instDistribLatticeOfLinearOrder

-- max_lt_iff from environment
-- theorem max_lt_iff : forall {α : Type.{u}} [inst._@.Mathlib.Order.MinMax.585443223._hygCtx._hyg.4 : LinearOrder.{u} α] {a : α} {b : α} {c : α}, Iff (LT.lt.{u} α (Preorder.toLT.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeSup.toPartialOrder.{u} α (Lattice.toSemilatticeSup.{u} α (DistribLattice.toLattice.{u} α (instDistribLatticeOfLinearOrder.{u} α inst._@.Mathlib.Order.MinMax.585443223._hygCtx._hyg.4)))))) (Max.max.{u} α (SemilatticeSup.toMax.{u} α (Lattice.toSemilatticeSup.{u} α (DistribLattice.toLattice.{u} α (instDistribLatticeOfLinearOrder.{u} α inst._@.Mathlib.Order.MinMax.585443223._hygCtx._hyg.4)))) b c) a) (And (LT.lt.{u} α (Preorder.toLT.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeSup.toPartialOrder.{u} α (Lattice.toSemilatticeSup.{u} α (DistribLattice.toLattice.{u} α (instDistribLatticeOfLinearOrder.{u} α inst._@.Mathlib.Order.MinMax.585443223._hygCtx._hyg.4)))))) b a) (LT.lt.{u} α (Preorder.toLT.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeSup.toPartialOrder.{u} α (Lattice.toSemilatticeSup.{u} α (DistribLattice.toLattice.{u} α (instDistribLatticeOfLinearOrder.{u} α inst._@.Mathlib.Order.MinMax.585443223._hygCtx._hyg.4)))))) c a))

-- Stub: this file represents the declaration `max_lt_iff`.
-- In a full split, the body would be extracted from the environment.
