import Split.Iff_mpr
import Split.AddMonoid_toAddZeroClass
import Split.PartialOrder_toPreorder
import Split.HSub_hSub
import Split.Preorder_toLE
import Split.AddZeroClass_toAddZero
import Split.PartialOrder
import Split.OrderedSub
import Split.tsub_eq_zero_iff_le
import Split.LE_le
import Split.CanonicallyOrderedAdd
import Split.AddCommMonoid
import Split.AddZero_toZero
import Split.instHSub
import Split.Zero_toOfNat0
import Split.AddCommMonoid_toAddMonoid
import Split.AddCommSemigroup_toAddCommMagma
import Split.OfNat_ofNat
import Split.AddCommMonoid_toAddCommSemigroup
import Split.Eq
import Split.AddCommMagma_toAdd
import Split.Sub

-- tsub_eq_zero_of_le from environment
-- theorem tsub_eq_zero_of_le : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.Sub.Basic.3298199274._hygCtx._hyg.3 : AddCommMonoid.{u_1} α] [inst._@.Mathlib.Algebra.Order.Sub.Basic.3298199274._hygCtx._hyg.6 : PartialOrder.{u_1} α] [inst._@.Mathlib.Algebra.Order.Sub.Basic.3298199274._hygCtx._hyg.9 : CanonicallyOrderedAdd.{u_1} α (AddCommMagma.toAdd.{u_1} α (AddCommSemigroup.toAddCommMagma.{u_1} α (AddCommMonoid.toAddCommSemigroup.{u_1} α inst._@.Mathlib.Algebra.Order.Sub.Basic.3298199274._hygCtx._hyg.3))) (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α inst._@.Mathlib.Algebra.Order.Sub.Basic.3298199274._hygCtx._hyg.6))] [inst._@.Mathlib.Algebra.Order.Sub.Basic.3298199274._hygCtx._hyg.12 : Sub.{u_1} α] [inst._@.Mathlib.Algebra.Order.Sub.Basic.3298199274._hygCtx._hyg.15 : OrderedSub.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α inst._@.Mathlib.Algebra.Order.Sub.Basic.3298199274._hygCtx._hyg.6)) (AddCommMagma.toAdd.{u_1} α (AddCommSemigroup.toAddCommMagma.{u_1} α (AddCommMonoid.toAddCommSemigroup.{u_1} α inst._@.Mathlib.Algebra.Order.Sub.Basic.3298199274._hygCtx._hyg.3))) inst._@.Mathlib.Algebra.Order.Sub.Basic.3298199274._hygCtx._hyg.12] {a : α} {b : α}, (LE.le.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α inst._@.Mathlib.Algebra.Order.Sub.Basic.3298199274._hygCtx._hyg.6)) a b) -> (Eq.{succ u_1} α (HSub.hSub.{u_1, u_1, u_1} α α α (instHSub.{u_1} α inst._@.Mathlib.Algebra.Order.Sub.Basic.3298199274._hygCtx._hyg.12) a b) (OfNat.ofNat.{u_1} α 0 (Zero.toOfNat0.{u_1} α (AddZero.toZero.{u_1} α (AddZeroClass.toAddZero.{u_1} α (AddMonoid.toAddZeroClass.{u_1} α (AddCommMonoid.toAddMonoid.{u_1} α inst._@.Mathlib.Algebra.Order.Sub.Basic.3298199274._hygCtx._hyg.3)))))))

-- Stub: this file represents the declaration `tsub_eq_zero_of_le`.
-- In a full split, the body would be extracted from the environment.
