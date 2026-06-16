import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.SemilatticeSup_toMax
import Split.LE_le
import Split.SemilatticeSup_sup_le
import Split.Max_max
import Split.SemilatticeSup_toPartialOrder
import Split.SemilatticeSup

-- sup_le from environment
-- theorem sup_le : forall {α : Type.{u}} [inst._@.Mathlib.Order.Lattice.418144958._hygCtx._hyg.4 : SemilatticeSup.{u} α] {a : α} {b : α} {c : α}, (LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeSup.toPartialOrder.{u} α inst._@.Mathlib.Order.Lattice.418144958._hygCtx._hyg.4))) a c) -> (LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeSup.toPartialOrder.{u} α inst._@.Mathlib.Order.Lattice.418144958._hygCtx._hyg.4))) b c) -> (LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeSup.toPartialOrder.{u} α inst._@.Mathlib.Order.Lattice.418144958._hygCtx._hyg.4))) (Max.max.{u} α (SemilatticeSup.toMax.{u} α inst._@.Mathlib.Order.Lattice.418144958._hygCtx._hyg.4) a b) c)

-- Stub: this file represents the declaration `sup_le`.
-- In a full split, the body would be extracted from the environment.
