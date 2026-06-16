import Split.Iff_mpr
import Split.NonUnitalNonAssocSemiring_toMulZeroClass
import Split.PartialOrder
import Split.Ne
import Split.NonAssocSemiring_toNonUnitalNonAssocSemiring
import Split.AbsoluteValue_ne_zero_iff
import Split.AbsoluteValue_funLike
import Split.Semiring
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Semiring_toNonAssocSemiring
import Split.DFunLike_coe
import Split.MulZeroClass_toZero
import Split.AbsoluteValue

-- AbsoluteValue.ne_zero from environment
-- theorem AbsoluteValue.ne_zero : forall {R : Type.{u_5}} {S : Type.{u_6}} [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2874461751._hygCtx._hyg.8 : Semiring.{u_5} R] [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2874461751._hygCtx._hyg.11 : Semiring.{u_6} S] [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2874461751._hygCtx._hyg.14 : PartialOrder.{u_6} S] (abv : AbsoluteValue.{u_5, u_6} R S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2874461751._hygCtx._hyg.8 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2874461751._hygCtx._hyg.11 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2874461751._hygCtx._hyg.14) {x : R}, (Ne.{succ u_5} R x (OfNat.ofNat.{u_5} R 0 (Zero.toOfNat0.{u_5} R (MulZeroClass.toZero.{u_5} R (NonUnitalNonAssocSemiring.toMulZeroClass.{u_5} R (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_5} R (Semiring.toNonAssocSemiring.{u_5} R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2874461751._hygCtx._hyg.8))))))) -> (Ne.{succ u_6} S (DFunLike.coe.{max (succ u_5) (succ u_6), succ u_5, succ u_6} (AbsoluteValue.{u_5, u_6} R S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2874461751._hygCtx._hyg.8 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2874461751._hygCtx._hyg.11 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2874461751._hygCtx._hyg.14) R (fun (x._@.Mathlib.Data.FunLike.Basic.2582841819._hygCtx._hyg.11 : R) => S) (AbsoluteValue.funLike.{u_5, u_6} R S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2874461751._hygCtx._hyg.8 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2874461751._hygCtx._hyg.11 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2874461751._hygCtx._hyg.14) abv x) (OfNat.ofNat.{u_6} S 0 (Zero.toOfNat0.{u_6} S (MulZeroClass.toZero.{u_6} S (NonUnitalNonAssocSemiring.toMulZeroClass.{u_6} S (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_6} S (Semiring.toNonAssocSemiring.{u_6} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2874461751._hygCtx._hyg.11)))))))

-- Stub: this file represents the declaration `AbsoluteValue.ne_zero`.
-- In a full split, the body would be extracted from the environment.
