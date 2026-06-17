import Split.Preorder_toLT
import Split.Lattice_toSemilatticeSup
import Split.le_sup_left
import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.SemilatticeInf_toPartialOrder
import Split.SemilatticeSup_toMax
import Split.le_sup_right
import Split.And
import Split.Iff
import Split.And_right
import Split.And_left
import Split.Max_max
import Split.And_intro
import Split.LT_lt
import Split.Iff_intro
import Split.SemilatticeSup_toPartialOrder
import Split.LinearOrder_toLattice
import Split.sup_ind
import Split.LE_le_trans_lt
import Split.Lattice_toSemilatticeInf

-- sup_lt_iff from environment
-- theorem sup_lt_iff : forall {α : Type.{u}} [inst._@.Mathlib.Order.Lattice.136821579._hygCtx._hyg.4 : LinearOrder.{u} α] {a : α} {b : α} {c : α}, Iff (LT.lt.{u} α (Preorder.toLT.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeInf.toPartialOrder.{u} α (Lattice.toSemilatticeInf.{u} α (LinearOrder.toLattice.{u} α inst._@.Mathlib.Order.Lattice.136821579._hygCtx._hyg.4))))) (Max.max.{u} α (SemilatticeSup.toMax.{u} α (Lattice.toSemilatticeSup.{u} α (LinearOrder.toLattice.{u} α inst._@.Mathlib.Order.Lattice.136821579._hygCtx._hyg.4))) b c) a) (And (LT.lt.{u} α (Preorder.toLT.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeInf.toPartialOrder.{u} α (Lattice.toSemilatticeInf.{u} α (LinearOrder.toLattice.{u} α inst._@.Mathlib.Order.Lattice.136821579._hygCtx._hyg.4))))) b a) (LT.lt.{u} α (Preorder.toLT.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeInf.toPartialOrder.{u} α (Lattice.toSemilatticeInf.{u} α (LinearOrder.toLattice.{u} α inst._@.Mathlib.Order.Lattice.136821579._hygCtx._hyg.4))))) c a))

-- Stub: this file represents the declaration `sup_lt_iff`.
-- In a full split, the body would be extracted from the environment.
