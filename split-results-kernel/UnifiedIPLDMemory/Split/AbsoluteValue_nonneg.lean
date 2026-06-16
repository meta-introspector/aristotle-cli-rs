import Split.PartialOrder_toPreorder
import Split.NonUnitalNonAssocSemiring_toMulZeroClass
import Split.Preorder_toLE
import Split.PartialOrder
import Split.LE_le
import Split.AbsoluteValue_nonneg'
import Split.NonAssocSemiring_toNonUnitalNonAssocSemiring
import Split.AbsoluteValue_funLike
import Split.Semiring
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Semiring_toNonAssocSemiring
import Split.DFunLike_coe
import Split.MulZeroClass_toZero
import Split.AbsoluteValue

-- AbsoluteValue.nonneg from environment
-- theorem AbsoluteValue.nonneg : forall {R : Type.{u_5}} {S : Type.{u_6}} [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1338264996._hygCtx._hyg.8 : Semiring.{u_5} R] [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1338264996._hygCtx._hyg.11 : Semiring.{u_6} S] [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1338264996._hygCtx._hyg.14 : PartialOrder.{u_6} S] (abv : AbsoluteValue.{u_5, u_6} R S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1338264996._hygCtx._hyg.8 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1338264996._hygCtx._hyg.11 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1338264996._hygCtx._hyg.14) (x : R), LE.le.{u_6} S (Preorder.toLE.{u_6} S (PartialOrder.toPreorder.{u_6} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1338264996._hygCtx._hyg.14)) (OfNat.ofNat.{u_6} S 0 (Zero.toOfNat0.{u_6} S (MulZeroClass.toZero.{u_6} S (NonUnitalNonAssocSemiring.toMulZeroClass.{u_6} S (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_6} S (Semiring.toNonAssocSemiring.{u_6} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1338264996._hygCtx._hyg.11)))))) (DFunLike.coe.{max (succ u_5) (succ u_6), succ u_5, succ u_6} (AbsoluteValue.{u_5, u_6} R S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1338264996._hygCtx._hyg.8 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1338264996._hygCtx._hyg.11 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1338264996._hygCtx._hyg.14) R (fun (x._@.Mathlib.Data.FunLike.Basic.2582841819._hygCtx._hyg.11 : R) => S) (AbsoluteValue.funLike.{u_5, u_6} R S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1338264996._hygCtx._hyg.8 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1338264996._hygCtx._hyg.11 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1338264996._hygCtx._hyg.14) abv x)

-- Stub: this file represents the declaration `AbsoluteValue.nonneg`.
-- In a full split, the body would be extracted from the environment.
