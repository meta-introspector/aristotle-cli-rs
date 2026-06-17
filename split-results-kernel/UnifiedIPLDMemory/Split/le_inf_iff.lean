import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.inf_le_right
import Split.SemilatticeInf_toPartialOrder
import Split.ge_trans
import Split.SemilatticeInf_toMin
import Split.LE_le
import Split.le_inf
import Split.And
import Split.SemilatticeInf
import Split.Iff
import Split.And_intro
import Split.Iff_intro
import Split.inf_le_left
import Split.Min_min

-- le_inf_iff from environment
-- theorem le_inf_iff : forall {α : Type.{u}} [inst._@.Mathlib.Order.Lattice.2787056769._hygCtx._hyg.4 : SemilatticeInf.{u} α] {c : α} {a : α} {b : α}, Iff (LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeInf.toPartialOrder.{u} α inst._@.Mathlib.Order.Lattice.2787056769._hygCtx._hyg.4))) c (Min.min.{u} α (SemilatticeInf.toMin.{u} α inst._@.Mathlib.Order.Lattice.2787056769._hygCtx._hyg.4) a b)) (And (LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeInf.toPartialOrder.{u} α inst._@.Mathlib.Order.Lattice.2787056769._hygCtx._hyg.4))) c a) (LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeInf.toPartialOrder.{u} α inst._@.Mathlib.Order.Lattice.2787056769._hygCtx._hyg.4))) c b))

-- Stub: this file represents the declaration `le_inf_iff`.
-- In a full split, the body would be extracted from the environment.
