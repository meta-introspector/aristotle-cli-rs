import Split.and_true
import Split.instReflLe
import Split.congrArg
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.SemilatticeSup_toMax
import Split.LE_le
import Split.iff_self
import Split.And
import Split.Iff
import Split.le_antisymm_iff
import Split.Max_max
import Split.congr
import Split.True
import Split.Iff_trans
import Split.of_eq_true
import Split.congrFun'
import Split.SemilatticeSup_toPartialOrder
import Split.Eq
import Split.SemilatticeSup
import Split.Eq_trans

-- sup_eq_right from environment
-- theorem sup_eq_right : forall {α : Type.{u}} [inst._@.Mathlib.Order.Lattice.2691877019._hygCtx._hyg.4 : SemilatticeSup.{u} α] {a : α} {b : α}, Iff (Eq.{succ u} α (Max.max.{u} α (SemilatticeSup.toMax.{u} α inst._@.Mathlib.Order.Lattice.2691877019._hygCtx._hyg.4) a b) b) (LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeSup.toPartialOrder.{u} α inst._@.Mathlib.Order.Lattice.2691877019._hygCtx._hyg.4))) a b)

-- Stub: this file represents the declaration `sup_eq_right`.
-- In a full split, the body would be extracted from the environment.
