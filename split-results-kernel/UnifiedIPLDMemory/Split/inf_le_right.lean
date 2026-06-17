import Split.SemilatticeInf_inf_le_right
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.SemilatticeInf_toPartialOrder
import Split.SemilatticeInf_toMin
import Split.LE_le
import Split.SemilatticeInf
import Split.Min_min

-- inf_le_right from environment
-- theorem inf_le_right : forall {α : Type.{u}} [inst._@.Mathlib.Order.Lattice.659704093._hygCtx._hyg.4 : SemilatticeInf.{u} α] {a : α} {b : α}, LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeInf.toPartialOrder.{u} α inst._@.Mathlib.Order.Lattice.659704093._hygCtx._hyg.4))) (Min.min.{u} α (SemilatticeInf.toMin.{u} α inst._@.Mathlib.Order.Lattice.659704093._hygCtx._hyg.4) a b) b

-- Stub: this file represents the declaration `inf_le_right`.
-- In a full split, the body would be extracted from the environment.
