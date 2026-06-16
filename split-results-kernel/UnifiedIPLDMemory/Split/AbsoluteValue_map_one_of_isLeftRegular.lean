import Split.NonAssocSemiring_toAddCommMonoidWithOne
import Split.HMul_hMul
import Split.congrArg
import Split.PartialOrder
import Split.NonAssocSemiring_toMulZeroOneClass
import Split.AddCommMonoidWithOne_toAddMonoidWithOne
import Split.MulZeroOneClass_toMulOneClass
import Split.IsLeftRegular
import Split.AddMonoidWithOne_toOne
import Split.Distrib_toMul
import Split.NonAssocSemiring_toNonUnitalNonAssocSemiring
import Split.congr
import Split.True
import Split.eq_self
import Split.AbsoluteValue_funLike
import Split.of_eq_true
import Split.Semiring
import Split.One_toOfNat1
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.mul_one
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.AbsoluteValue_map_mul
import Split.Semiring_toNonAssocSemiring
import Split.Eq
import Split.DFunLike_coe
import Split.Eq_trans
import Split.instHMul
import Split.AbsoluteValue

-- AbsoluteValue.map_one_of_isLeftRegular from environment
-- theorem AbsoluteValue.map_one_of_isLeftRegular : forall {R : Type.{u_5}} {S : Type.{u_6}} [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1223577709._hygCtx._hyg.8 : Semiring.{u_5} R] [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1223577709._hygCtx._hyg.11 : Semiring.{u_6} S] [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1223577709._hygCtx._hyg.14 : PartialOrder.{u_6} S] (abv : AbsoluteValue.{u_5, u_6} R S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1223577709._hygCtx._hyg.8 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1223577709._hygCtx._hyg.11 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1223577709._hygCtx._hyg.14), (IsLeftRegular.{u_6} S (Distrib.toMul.{u_6} S (NonUnitalNonAssocSemiring.toDistrib.{u_6} S (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_6} S (Semiring.toNonAssocSemiring.{u_6} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1223577709._hygCtx._hyg.11)))) (DFunLike.coe.{max (succ u_5) (succ u_6), succ u_5, succ u_6} (AbsoluteValue.{u_5, u_6} R S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1223577709._hygCtx._hyg.8 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1223577709._hygCtx._hyg.11 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1223577709._hygCtx._hyg.14) R (fun (x._@.Mathlib.Data.FunLike.Basic.2582841819._hygCtx._hyg.11 : R) => S) (AbsoluteValue.funLike.{u_5, u_6} R S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1223577709._hygCtx._hyg.8 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1223577709._hygCtx._hyg.11 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1223577709._hygCtx._hyg.14) abv (OfNat.ofNat.{u_5} R 1 (One.toOfNat1.{u_5} R (AddMonoidWithOne.toOne.{u_5} R (AddCommMonoidWithOne.toAddMonoidWithOne.{u_5} R (NonAssocSemiring.toAddCommMonoidWithOne.{u_5} R (Semiring.toNonAssocSemiring.{u_5} R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1223577709._hygCtx._hyg.8)))))))) -> (Eq.{succ u_6} S (DFunLike.coe.{max (succ u_5) (succ u_6), succ u_5, succ u_6} (AbsoluteValue.{u_5, u_6} R S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1223577709._hygCtx._hyg.8 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1223577709._hygCtx._hyg.11 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1223577709._hygCtx._hyg.14) R (fun (x._@.Mathlib.Data.FunLike.Basic.2582841819._hygCtx._hyg.11 : R) => S) (AbsoluteValue.funLike.{u_5, u_6} R S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1223577709._hygCtx._hyg.8 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1223577709._hygCtx._hyg.11 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1223577709._hygCtx._hyg.14) abv (OfNat.ofNat.{u_5} R 1 (One.toOfNat1.{u_5} R (AddMonoidWithOne.toOne.{u_5} R (AddCommMonoidWithOne.toAddMonoidWithOne.{u_5} R (NonAssocSemiring.toAddCommMonoidWithOne.{u_5} R (Semiring.toNonAssocSemiring.{u_5} R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1223577709._hygCtx._hyg.8))))))) (OfNat.ofNat.{u_6} S 1 (One.toOfNat1.{u_6} S (AddMonoidWithOne.toOne.{u_6} S (AddCommMonoidWithOne.toAddMonoidWithOne.{u_6} S (NonAssocSemiring.toAddCommMonoidWithOne.{u_6} S (Semiring.toNonAssocSemiring.{u_6} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.1223577709._hygCtx._hyg.11)))))))

-- Stub: this file represents the declaration `AbsoluteValue.map_one_of_isLeftRegular`.
-- In a full split, the body would be extracted from the environment.
