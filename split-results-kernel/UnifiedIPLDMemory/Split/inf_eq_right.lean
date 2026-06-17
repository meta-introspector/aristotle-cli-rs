import Split.instReflGe
import Split.and_true
import Split.congrArg
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.Std_ge_refl
import Split.inf_le_right
import Split.SemilatticeInf_toPartialOrder
import Split.SemilatticeInf_toMin
import Split.LE_le
import Split.le_inf_iff
import Split.iff_self
import Split.And
import Split.SemilatticeInf
import Split.Iff
import Split.congr
import Split.True
import Split.propext
import Split.eq_true
import Split.Iff_trans
import Split.of_eq_true
import Split.congrFun'
import Split.ge_antisymm_iff
import Split.Eq
import Split.Min_min
import Split.Eq_trans

-- inf_eq_right from environment
-- theorem inf_eq_right : forall {α : Type.{u}} [inst._@.Mathlib.Order.Lattice.2691877019._hygCtx._hyg.4 : SemilatticeInf.{u} α] {a : α} {b : α}, Iff (Eq.{succ u} α (Min.min.{u} α (SemilatticeInf.toMin.{u} α inst._@.Mathlib.Order.Lattice.2691877019._hygCtx._hyg.4) a b) b) (LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (SemilatticeInf.toPartialOrder.{u} α inst._@.Mathlib.Order.Lattice.2691877019._hygCtx._hyg.4))) b a)

-- Stub: this file represents the declaration `inf_eq_right`.
-- In a full split, the body would be extracted from the environment.
