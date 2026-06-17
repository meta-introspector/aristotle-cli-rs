import Split.PartialOrder_toPreorder
import Split.SemilatticeInf_inf_le_left
import Split.Preorder_toLE
import Split.SemilatticeInf_toPartialOrder
import Split.SemilatticeInf_toMin
import Split.LE_le
import Split.SemilatticeInf
import Split.Min_min

-- inf_le_left from environment
-- theorem inf_le_left : forall {α : Type.{u}} [inst._@.Mathlib.Order.Lattice.3492310680._hygCtx._hyg.4 : SemilatticeInf.{u} α] {a : α} {b : α}, LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeInf.toPartialOrder.{u} α inst._@.Mathlib.Order.Lattice.3492310680._hygCtx._hyg.4))) (Min.min.{u} α (SemilatticeInf.toMin.{u} α inst._@.Mathlib.Order.Lattice.3492310680._hygCtx._hyg.4) a b) a

-- Stub: this file represents the declaration `inf_le_left`.
-- In a full split, the body would be extracted from the environment.
