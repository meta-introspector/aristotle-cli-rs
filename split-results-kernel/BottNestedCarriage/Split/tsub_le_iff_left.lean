import Split.Eq_mpr
import Split.congrArg
import Split.Iff_rfl
import Split.HSub_hSub
import Split.Preorder_toLE
import Split.id
import Split.OrderedSub
import Split.LE_le
import Split.tsub_le_iff_right
import Split.add_comm
import Split.instHAdd
import Split.Iff
import Split.instHSub
import Split.HAdd_hAdd
import Split.propext
import Split.AddCommSemigroup_toAddCommMagma
import Split.AddCommSemigroup
import Split.Eq
import Split.Preorder
import Split.AddCommMagma_toAdd
import Split.Sub

-- tsub_le_iff_left from environment
-- theorem tsub_le_iff_left : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.Sub.Defs.2570408891._hygCtx._hyg.3 : Preorder.{u_1} α] [inst._@.Mathlib.Algebra.Order.Sub.Defs.2570408891._hygCtx._hyg.6 : AddCommSemigroup.{u_1} α] [inst._@.Mathlib.Algebra.Order.Sub.Defs.2570408891._hygCtx._hyg.9 : Sub.{u_1} α] [inst._@.Mathlib.Algebra.Order.Sub.Defs.2570408891._hygCtx._hyg.12 : OrderedSub.{u_1} α (Preorder.toLE.{u_1} α inst._@.Mathlib.Algebra.Order.Sub.Defs.2570408891._hygCtx._hyg.3) (AddCommMagma.toAdd.{u_1} α (AddCommSemigroup.toAddCommMagma.{u_1} α inst._@.Mathlib.Algebra.Order.Sub.Defs.2570408891._hygCtx._hyg.6)) inst._@.Mathlib.Algebra.Order.Sub.Defs.2570408891._hygCtx._hyg.9] {a : α} {b : α} {c : α}, Iff (LE.le.{u_1} α (Preorder.toLE.{u_1} α inst._@.Mathlib.Algebra.Order.Sub.Defs.2570408891._hygCtx._hyg.3) (HSub.hSub.{u_1, u_1, u_1} α α α (instHSub.{u_1} α inst._@.Mathlib.Algebra.Order.Sub.Defs.2570408891._hygCtx._hyg.9) a b) c) (LE.le.{u_1} α (Preorder.toLE.{u_1} α inst._@.Mathlib.Algebra.Order.Sub.Defs.2570408891._hygCtx._hyg.3) a (HAdd.hAdd.{u_1, u_1, u_1} α α α (instHAdd.{u_1} α (AddCommMagma.toAdd.{u_1} α (AddCommSemigroup.toAddCommMagma.{u_1} α inst._@.Mathlib.Algebra.Order.Sub.Defs.2570408891._hygCtx._hyg.6))) b c))

-- Stub: this file represents the declaration `tsub_le_iff_left`.
-- In a full split, the body would be extracted from the environment.
