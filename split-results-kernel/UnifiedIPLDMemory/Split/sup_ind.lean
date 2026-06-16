import Split.Iff_mpr
import Split.Eq_mpr
import Split.Lattice_toSemilatticeSup
import Split.congrArg
import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.SemilatticeInf_toPartialOrder
import Split.SemilatticeSup_toMax
import Split.id
import Split.sup_eq_left
import Split.LE_le
import Split.Std_Total_total
import Split.Max_max
import Split.sup_eq_right
import Split.SemilatticeSup_toPartialOrder
import Split.LinearOrder_toLattice
import Split.Or_elim
import Split.Eq
import Split.Lattice_toSemilatticeInf
import Split.LE_total

-- sup_ind from environment
-- theorem sup_ind : forall {α : Type.{u}} [inst._@.Mathlib.Order.Lattice.695959904._hygCtx._hyg.4 : LinearOrder.{u} α] (a : α) (b : α) {p : α -> Prop}, (p a) -> (p b) -> (p (Max.max.{u} α (SemilatticeSup.toMax.{u} α (Lattice.toSemilatticeSup.{u} α (LinearOrder.toLattice.{u} α inst._@.Mathlib.Order.Lattice.695959904._hygCtx._hyg.4))) a b))

-- Stub: this file represents the declaration `sup_ind`.
-- In a full split, the body would be extracted from the environment.
