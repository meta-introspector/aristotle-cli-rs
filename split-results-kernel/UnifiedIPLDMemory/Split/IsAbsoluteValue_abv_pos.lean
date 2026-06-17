import Split.Preorder_toLT
import Split.PartialOrder_toPreorder
import Split.IsAbsoluteValue_toAbsoluteValue
import Split.NonUnitalNonAssocSemiring_toMulZeroClass
import Split.PartialOrder
import Split.Ne
import Split.AbsoluteValue_pos_iff
import Split.Iff
import Split.NonAssocSemiring_toNonUnitalNonAssocSemiring
import Split.LT_lt
import Split.IsAbsoluteValue
import Split.Semiring
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Semiring_toNonAssocSemiring
import Split.MulZeroClass_toZero

-- IsAbsoluteValue.abv_pos from environment
-- theorem IsAbsoluteValue.abv_pos : forall {S : Type.{u_5}} [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.3760315046._hygCtx._hyg.7 : Semiring.{u_5} S] [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.3760315046._hygCtx._hyg.10 : PartialOrder.{u_5} S] {R : Type.{u_6}} [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.3760315046._hygCtx._hyg.14 : Semiring.{u_6} R] (abv : R -> S) [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.3760315046._hygCtx._hyg.20 : IsAbsoluteValue.{u_5, u_6} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.3760315046._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.3760315046._hygCtx._hyg.10 R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.3760315046._hygCtx._hyg.14 abv] {a : R}, Iff (LT.lt.{u_5} S (Preorder.toLT.{u_5} S (PartialOrder.toPreorder.{u_5} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.3760315046._hygCtx._hyg.10)) (OfNat.ofNat.{u_5} S 0 (Zero.toOfNat0.{u_5} S (MulZeroClass.toZero.{u_5} S (NonUnitalNonAssocSemiring.toMulZeroClass.{u_5} S (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_5} S (Semiring.toNonAssocSemiring.{u_5} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.3760315046._hygCtx._hyg.7)))))) (abv a)) (Ne.{succ u_6} R a (OfNat.ofNat.{u_6} R 0 (Zero.toOfNat0.{u_6} R (MulZeroClass.toZero.{u_6} R (NonUnitalNonAssocSemiring.toMulZeroClass.{u_6} R (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_6} R (Semiring.toNonAssocSemiring.{u_6} R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.3760315046._hygCtx._hyg.14)))))))

-- Stub: this file represents the declaration `IsAbsoluteValue.abv_pos`.
-- In a full split, the body would be extracted from the environment.
