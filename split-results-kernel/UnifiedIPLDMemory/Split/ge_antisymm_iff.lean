import Split.PartialOrder_toPreorder
import Split.ge_of_eq
import Split.Preorder_toLE
import Split.PartialOrder
import Split.LE_le
import Split.And
import Split.Iff
import Split.ge_antisymm
import Split.And_intro
import Split.Iff_intro
import Split.Eq_symm
import Split.Eq

-- ge_antisymm_iff from environment
-- theorem ge_antisymm_iff : forall {α : Type.{u_1}} [inst._@.Mathlib.Order.Defs.PartialOrder.3868961906._hygCtx._hyg.3 : PartialOrder.{u_1} α] {a : α} {b : α}, Iff (Eq.{succ u_1} α a b) (And (LE.le.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α inst._@.Mathlib.Order.Defs.PartialOrder.3868961906._hygCtx._hyg.3)) b a) (LE.le.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α inst._@.Mathlib.Order.Defs.PartialOrder.3868961906._hygCtx._hyg.3)) a b))

-- Stub: this file represents the declaration `ge_antisymm_iff`.
-- In a full split, the body would be extracted from the environment.
