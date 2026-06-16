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

-- IsAbsoluteValue.abv_nonneg' from environment
-- theorem IsAbsoluteValue.abv_nonneg' : forall {S : Type.{u_5}} {inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2503809937._hygCtx._hyg.11 : Semiring.{u_5} S} {inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2503809937._hygCtx._hyg.14 : PartialOrder.{u_5} S} {R : Type.{u_6}} {inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2503809937._hygCtx._hyg.18 : Semiring.{u_6} R} {f : R -> S} [self : IsAbsoluteValue.{u_5, u_6} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2503809937._hygCtx._hyg.11 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2503809937._hygCtx._hyg.14 R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2503809937._hygCtx._hyg.18 f] (x : R), LE.le.{u_5} S (Preorder.toLE.{u_5} S (PartialOrder.toPreorder.{u_5} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2503809937._hygCtx._hyg.14)) (OfNat.ofNat.{u_5} S 0 (Zero.toOfNat0.{u_5} S (MulZeroClass.toZero.{u_5} S (NonUnitalNonAssocSemiring.toMulZeroClass.{u_5} S (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_5} S (Semiring.toNonAssocSemiring.{u_5} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2503809937._hygCtx._hyg.11)))))) (f x)

-- Stub: this file represents the declaration `IsAbsoluteValue.abv_nonneg'`.
-- In a full split, the body would be extracted from the environment.
