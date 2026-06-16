import Split.Monoid
import Split.Function_Injective_monoid
import Split.MulOne_toOne
import Split.One
import Split.HMul_hMul
import Split.MulZeroClass_toMul
import Split.Pow
import Split.MulZeroClass_zero_mul
import Split.Mul
import Split.MulZeroClass
import Split.MulZeroClass_mul_zero
import Split.MulZeroOneClass_toMulOneClass
import Split.Monoid_toPow
import Split.MulOneClass_toMulOne
import Split.MonoidWithZero
import Split.MonoidWithZero_toMulZeroOneClass
import Split.HPow_hPow
import Split.Nat
import Split.One_toOfNat1
import Split.Zero_toOfNat0
import Split.Function_Injective_mulZeroClass
import Split.instHPow
import Split.Function_Injective
import Split.MulZeroOneClass_toMulZeroClass
import Split.OfNat_ofNat
import Split.Eq
import Split.MonoidWithZero_toMonoid
import Split.MulZeroClass_toZero
import Split.instHMul
import Split.Zero
import Split.MonoidWithZero_mk

-- Function.Injective.monoidWithZero from environment
-- def Function.Injective.monoidWithZero : forall {M₀ : Type.{u_1}} {M₀' : Type.{u_3}} [inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.2772094965._hygCtx._hyg.6 : Zero.{u_3} M₀'] [inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.2772094965._hygCtx._hyg.9 : Mul.{u_3} M₀'] [inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.2772094965._hygCtx._hyg.12 : One.{u_3} M₀'] [inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.2772094965._hygCtx._hyg.15 : Pow.{u_3, 0} M₀' Nat] [inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.2772094965._hygCtx._hyg.21 : MonoidWithZero.{u_1} M₀] (f : M₀' -> M₀), (Function.Injective.{succ u_3, succ u_1} M₀' M₀ f) -> (Eq.{succ u_1} M₀ (f (OfNat.ofNat.{u_3} M₀' 0 (Zero.toOfNat0.{u_3} M₀' inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.2772094965._hygCtx._hyg.6))) (OfNat.ofNat.{u_1} M₀ 0 (Zero.toOfNat0.{u_1} M₀ (MulZeroClass.toZero.{u_1} M₀ (MulZeroOneClass.toMulZeroClass.{u_1} M₀ (MonoidWithZero.toMulZeroOneClass.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.2772094965._hygCtx._hyg.21)))))) -> (Eq.{succ u_1} M₀ (f (OfNat.ofNat.{u_3} M₀' 1 (One.toOfNat1.{u_3} M₀' inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.2772094965._hygCtx._hyg.12))) (OfNat.ofNat.{u_1} M₀ 1 (One.toOfNat1.{u_1} M₀ (MulOne.toOne.{u_1} M₀ (MulOneClass.toMulOne.{u_1} M₀ (MulZeroOneClass.toMulOneClass.{u_1} M₀ (MonoidWithZero.toMulZeroOneClass.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.2772094965._hygCtx._hyg.21))))))) -> (forall (x : M₀') (y : M₀'), Eq.{succ u_1} M₀ (f (HMul.hMul.{u_3, u_3, u_3} M₀' M₀' M₀' (instHMul.{u_3} M₀' inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.2772094965._hygCtx._hyg.9) x y)) (HMul.hMul.{u_1, u_1, u_1} M₀ M₀ M₀ (instHMul.{u_1} M₀ (MulZeroClass.toMul.{u_1} M₀ (MulZeroOneClass.toMulZeroClass.{u_1} M₀ (MonoidWithZero.toMulZeroOneClass.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.2772094965._hygCtx._hyg.21)))) (f x) (f y))) -> (forall (x : M₀') (n : Nat), Eq.{succ u_1} M₀ (f (HPow.hPow.{u_3, 0, u_3} M₀' Nat M₀' (instHPow.{u_3, 0} M₀' Nat inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.2772094965._hygCtx._hyg.15) x n)) (HPow.hPow.{u_1, 0, u_1} M₀ Nat M₀ (instHPow.{u_1, 0} M₀ Nat (Monoid.toPow.{u_1} M₀ (MonoidWithZero.toMonoid.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.2772094965._hygCtx._hyg.21))) (f x) n)) -> (MonoidWithZero.{u_3} M₀')
-- (definition body omitted)

-- Stub: this file represents the declaration `Function.Injective.monoidWithZero`.
-- In a full split, the body would be extracted from the environment.
