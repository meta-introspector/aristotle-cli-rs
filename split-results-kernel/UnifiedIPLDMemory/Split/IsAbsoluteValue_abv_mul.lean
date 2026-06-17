import Split.HMul_hMul
import Split.PartialOrder
import Split.Distrib_toMul
import Split.NonAssocSemiring_toNonUnitalNonAssocSemiring
import Split.IsAbsoluteValue
import Split.IsAbsoluteValue_abv_mul'
import Split.Semiring
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.Semiring_toNonAssocSemiring
import Split.Eq
import Split.instHMul

-- IsAbsoluteValue.abv_mul from environment
-- theorem IsAbsoluteValue.abv_mul : forall {S : Type.{u_5}} [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2346435932._hygCtx._hyg.7 : Semiring.{u_5} S] [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2346435932._hygCtx._hyg.10 : PartialOrder.{u_5} S] {R : Type.{u_6}} [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2346435932._hygCtx._hyg.14 : Semiring.{u_6} R] (abv : R -> S) [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2346435932._hygCtx._hyg.20 : IsAbsoluteValue.{u_5, u_6} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2346435932._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2346435932._hygCtx._hyg.10 R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2346435932._hygCtx._hyg.14 abv] (x : R) (y : R), Eq.{succ u_5} S (abv (HMul.hMul.{u_6, u_6, u_6} R R R (instHMul.{u_6} R (Distrib.toMul.{u_6} R (NonUnitalNonAssocSemiring.toDistrib.{u_6} R (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_6} R (Semiring.toNonAssocSemiring.{u_6} R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2346435932._hygCtx._hyg.14))))) x y)) (HMul.hMul.{u_5, u_5, u_5} S S S (instHMul.{u_5} S (Distrib.toMul.{u_5} S (NonUnitalNonAssocSemiring.toDistrib.{u_5} S (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_5} S (Semiring.toNonAssocSemiring.{u_5} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2346435932._hygCtx._hyg.7))))) (abv x) (abv y))

-- Stub: this file represents the declaration `IsAbsoluteValue.abv_mul`.
-- In a full split, the body would be extracted from the environment.
