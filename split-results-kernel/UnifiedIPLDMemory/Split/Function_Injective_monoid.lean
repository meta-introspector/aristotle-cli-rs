import Split.Semigroup
import Split.Monoid
import Split.MulOne_toOne
import Split.One
import Split.HMul_hMul
import Split.Monoid_toMulOneClass
import Split.Pow
import Split.MulOneClass_mul_one
import Split.MulOneClass_one_mul
import Split.Mul
import Split.MulOne_toMul
import Split.Monoid_mk
import Split.Monoid_toPow
import Split.MulOneClass_toMulOne
import Split.HPow_hPow
import Split.Function_Injective_semigroup
import Split.Nat
import Split.Monoid_toSemigroup
import Split.Function_Injective_mulOneClass
import Split.One_toOfNat1
import Split.instHPow
import Split.Function_Injective
import Split.MulOneClass
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul

-- Function.Injective.monoid from environment
-- def Function.Injective.monoid : forall {M₁ : Type.{u_1}} {M₂ : Type.{u_2}} [inst._@.Mathlib.Algebra.Group.InjSurj.1372201068._hygCtx._hyg.4 : Mul.{u_1} M₁] [inst._@.Mathlib.Algebra.Group.InjSurj.1372201068._hygCtx._hyg.7 : One.{u_1} M₁] [inst._@.Mathlib.Algebra.Group.InjSurj.1372201068._hygCtx._hyg.10 : Pow.{u_1, 0} M₁ Nat] [inst._@.Mathlib.Algebra.Group.InjSurj.1372201068._hygCtx._hyg.16 : Monoid.{u_2} M₂] (f : M₁ -> M₂), (Function.Injective.{succ u_1, succ u_2} M₁ M₂ f) -> (Eq.{succ u_2} M₂ (f (OfNat.ofNat.{u_1} M₁ 1 (One.toOfNat1.{u_1} M₁ inst._@.Mathlib.Algebra.Group.InjSurj.1372201068._hygCtx._hyg.7))) (OfNat.ofNat.{u_2} M₂ 1 (One.toOfNat1.{u_2} M₂ (MulOne.toOne.{u_2} M₂ (MulOneClass.toMulOne.{u_2} M₂ (Monoid.toMulOneClass.{u_2} M₂ inst._@.Mathlib.Algebra.Group.InjSurj.1372201068._hygCtx._hyg.16)))))) -> (forall (x : M₁) (y : M₁), Eq.{succ u_2} M₂ (f (HMul.hMul.{u_1, u_1, u_1} M₁ M₁ M₁ (instHMul.{u_1} M₁ inst._@.Mathlib.Algebra.Group.InjSurj.1372201068._hygCtx._hyg.4) x y)) (HMul.hMul.{u_2, u_2, u_2} M₂ M₂ M₂ (instHMul.{u_2} M₂ (MulOne.toMul.{u_2} M₂ (MulOneClass.toMulOne.{u_2} M₂ (Monoid.toMulOneClass.{u_2} M₂ inst._@.Mathlib.Algebra.Group.InjSurj.1372201068._hygCtx._hyg.16)))) (f x) (f y))) -> (forall (x : M₁) (n : Nat), Eq.{succ u_2} M₂ (f (HPow.hPow.{u_1, 0, u_1} M₁ Nat M₁ (instHPow.{u_1, 0} M₁ Nat inst._@.Mathlib.Algebra.Group.InjSurj.1372201068._hygCtx._hyg.10) x n)) (HPow.hPow.{u_2, 0, u_2} M₂ Nat M₂ (instHPow.{u_2, 0} M₂ Nat (Monoid.toPow.{u_2} M₂ inst._@.Mathlib.Algebra.Group.InjSurj.1372201068._hygCtx._hyg.16)) (f x) n)) -> (Monoid.{u_1} M₁)
-- (definition body omitted)

-- Stub: this file represents the declaration `Function.Injective.monoid`.
-- In a full split, the body would be extracted from the environment.
