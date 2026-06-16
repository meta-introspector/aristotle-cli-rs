import Split.NonUnitalNonAssocSemiring_toMulZeroClass
import Split.PartialOrder
import Split.Iff
import Split.NonAssocSemiring_toNonUnitalNonAssocSemiring
import Split.IsAbsoluteValue
import Split.Semiring
import Split.Zero_toOfNat0
import Split.IsAbsoluteValue_abv_eq_zero'
import Split.OfNat_ofNat
import Split.Semiring_toNonAssocSemiring
import Split.Eq
import Split.MulZeroClass_toZero

-- IsAbsoluteValue.abv_eq_zero from environment
-- theorem IsAbsoluteValue.abv_eq_zero : forall {S : Type.{u_5}} [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.4078508717._hygCtx._hyg.7 : Semiring.{u_5} S] [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.4078508717._hygCtx._hyg.10 : PartialOrder.{u_5} S] {R : Type.{u_6}} [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.4078508717._hygCtx._hyg.14 : Semiring.{u_6} R] (abv : R -> S) [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.4078508717._hygCtx._hyg.20 : IsAbsoluteValue.{u_5, u_6} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.4078508717._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.4078508717._hygCtx._hyg.10 R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.4078508717._hygCtx._hyg.14 abv] {x : R}, Iff (Eq.{succ u_5} S (abv x) (OfNat.ofNat.{u_5} S 0 (Zero.toOfNat0.{u_5} S (MulZeroClass.toZero.{u_5} S (NonUnitalNonAssocSemiring.toMulZeroClass.{u_5} S (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_5} S (Semiring.toNonAssocSemiring.{u_5} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.4078508717._hygCtx._hyg.7))))))) (Eq.{succ u_6} R x (OfNat.ofNat.{u_6} R 0 (Zero.toOfNat0.{u_6} R (MulZeroClass.toZero.{u_6} R (NonUnitalNonAssocSemiring.toMulZeroClass.{u_6} R (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_6} R (Semiring.toNonAssocSemiring.{u_6} R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.4078508717._hygCtx._hyg.14)))))))

-- Stub: this file represents the declaration `IsAbsoluteValue.abv_eq_zero`.
-- In a full split, the body would be extracted from the environment.
