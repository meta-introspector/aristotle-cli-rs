import Split.IsAbsoluteValue_abv_nonneg'
import Split.PartialOrder_toPreorder
import Split.NonUnitalNonAssocSemiring_toMulZeroClass
import Split.Preorder_toLE
import Split.PartialOrder
import Split.LE_le
import Split.NonAssocSemiring_toNonUnitalNonAssocSemiring
import Split.IsAbsoluteValue
import Split.Semiring
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Semiring_toNonAssocSemiring
import Split.MulZeroClass_toZero

-- IsAbsoluteValue.abv_nonneg from environment
-- theorem IsAbsoluteValue.abv_nonneg : forall {S : Type.{u_5}} [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.166646465._hygCtx._hyg.7 : Semiring.{u_5} S] [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.166646465._hygCtx._hyg.10 : PartialOrder.{u_5} S] {R : Type.{u_6}} [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.166646465._hygCtx._hyg.14 : Semiring.{u_6} R] (abv : R -> S) [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.166646465._hygCtx._hyg.20 : IsAbsoluteValue.{u_5, u_6} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.166646465._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.166646465._hygCtx._hyg.10 R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.166646465._hygCtx._hyg.14 abv] (x : R), LE.le.{u_5} S (Preorder.toLE.{u_5} S (PartialOrder.toPreorder.{u_5} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.166646465._hygCtx._hyg.10)) (OfNat.ofNat.{u_5} S 0 (Zero.toOfNat0.{u_5} S (MulZeroClass.toZero.{u_5} S (NonUnitalNonAssocSemiring.toMulZeroClass.{u_5} S (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_5} S (Semiring.toNonAssocSemiring.{u_5} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.166646465._hygCtx._hyg.7)))))) (abv x)

-- Stub: this file represents the declaration `IsAbsoluteValue.abv_nonneg`.
-- In a full split, the body would be extracted from the environment.
