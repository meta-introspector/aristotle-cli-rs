import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.SemilatticeSup_toMax
import Split.LE_le
import Split.Max_max
import Split.SemilatticeSup_toPartialOrder
import Split.SemilatticeSup_le_sup_right
import Split.SemilatticeSup

-- le_sup_right from environment
-- theorem le_sup_right : forall {α : Type.{u}} [inst._@.Mathlib.Order.Lattice.659704093._hygCtx._hyg.4 : SemilatticeSup.{u} α] {a : α} {b : α}, LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeSup.toPartialOrder.{u} α inst._@.Mathlib.Order.Lattice.659704093._hygCtx._hyg.4))) b (Max.max.{u} α (SemilatticeSup.toMax.{u} α inst._@.Mathlib.Order.Lattice.659704093._hygCtx._hyg.4) a b)

-- Stub: this file represents the declaration `le_sup_right`.
-- In a full split, the body would be extracted from the environment.
