import Split.Nontrivial
import Split.MulOne_toOne
import Split.NeZero_one
import Split.HMul_hMul
import Split.ne_zero_of_eq_one
import Split.MulZeroClass_toMul
import Split.Ne
import Split.MulZeroOneClass
import Split.MulZeroOneClass_toMulOneClass
import Split.MulOneClass_toMulOne
import Split.left_ne_zero_of_mul
import Split.One_toOfNat1
import Split.Zero_toOfNat0
import Split.MulZeroOneClass_toMulZeroClass
import Split.OfNat_ofNat
import Split.Eq
import Split.MulZeroClass_toZero
import Split.instHMul

-- left_ne_zero_of_mul_eq_one from environment
-- theorem left_ne_zero_of_mul_eq_one : forall {M₀ : Type.{u_1}} [inst._@.Mathlib.Algebra.GroupWithZero.Basic.1481265162._hygCtx._hyg.4 : MulZeroOneClass.{u_1} M₀] [inst._@.Mathlib.Algebra.GroupWithZero.Basic.1481265162._hygCtx._hyg.7 : Nontrivial.{u_1} M₀] {a : M₀} {b : M₀}, (Eq.{succ u_1} M₀ (HMul.hMul.{u_1, u_1, u_1} M₀ M₀ M₀ (instHMul.{u_1} M₀ (MulZeroClass.toMul.{u_1} M₀ (MulZeroOneClass.toMulZeroClass.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Basic.1481265162._hygCtx._hyg.4))) a b) (OfNat.ofNat.{u_1} M₀ 1 (One.toOfNat1.{u_1} M₀ (MulOne.toOne.{u_1} M₀ (MulOneClass.toMulOne.{u_1} M₀ (MulZeroOneClass.toMulOneClass.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Basic.1481265162._hygCtx._hyg.4)))))) -> (Ne.{succ u_1} M₀ a (OfNat.ofNat.{u_1} M₀ 0 (Zero.toOfNat0.{u_1} M₀ (MulZeroClass.toZero.{u_1} M₀ (MulZeroOneClass.toMulZeroClass.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Basic.1481265162._hygCtx._hyg.4)))))

-- Stub: this file represents the declaration `left_ne_zero_of_mul_eq_one`.
-- In a full split, the body would be extracted from the environment.
