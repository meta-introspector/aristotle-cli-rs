import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.SemilatticeInf_toPartialOrder
import Split.SemilatticeInf_toMin
import Split.LE_le
import Split.SemilatticeInf_le_inf
import Split.SemilatticeInf
import Split.Min_min

-- le_inf from environment
-- theorem le_inf : forall {α : Type.{u}} [inst._@.Mathlib.Order.Lattice.418144958._hygCtx._hyg.4 : SemilatticeInf.{u} α] {c : α} {a : α} {b : α}, (LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeInf.toPartialOrder.{u} α inst._@.Mathlib.Order.Lattice.418144958._hygCtx._hyg.4))) c a) -> (LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeInf.toPartialOrder.{u} α inst._@.Mathlib.Order.Lattice.418144958._hygCtx._hyg.4))) c b) -> (LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeInf.toPartialOrder.{u} α inst._@.Mathlib.Order.Lattice.418144958._hygCtx._hyg.4))) c (Min.min.{u} α (SemilatticeInf.toMin.{u} α inst._@.Mathlib.Order.Lattice.418144958._hygCtx._hyg.4) a b))

-- Stub: this file represents the declaration `le_inf`.
-- In a full split, the body would be extracted from the environment.
