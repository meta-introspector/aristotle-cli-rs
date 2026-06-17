import Split.MulOne_toOne
import Split.One
import Split.HMul_hMul
import Split.Mul
import Split.MulOne_mk
import Split.MulOne_toMul
import Split.MulOneClass_toMulOne
import Split.MulOneClass_mk
import Split.One_toOfNat1
import Split.MulOneClass
import Split.OfNat_ofNat
import Split.Eq
import Split.Function_Surjective
import Split.instHMul

-- Function.Surjective.mulOneClass from environment
-- def Function.Surjective.mulOneClass : forall {M₁ : Type.{u_1}} {M₂ : Type.{u_2}} [inst._@.Mathlib.Algebra.Group.InjSurj.4120732672._hygCtx._hyg.4 : Mul.{u_2} M₂] [inst._@.Mathlib.Algebra.Group.InjSurj.4120732672._hygCtx._hyg.7 : One.{u_2} M₂] [inst._@.Mathlib.Algebra.Group.InjSurj.4120732672._hygCtx._hyg.10 : MulOneClass.{u_1} M₁] (f : M₁ -> M₂), (Function.Surjective.{succ u_1, succ u_2} M₁ M₂ f) -> (Eq.{succ u_2} M₂ (f (OfNat.ofNat.{u_1} M₁ 1 (One.toOfNat1.{u_1} M₁ (MulOne.toOne.{u_1} M₁ (MulOneClass.toMulOne.{u_1} M₁ inst._@.Mathlib.Algebra.Group.InjSurj.4120732672._hygCtx._hyg.10))))) (OfNat.ofNat.{u_2} M₂ 1 (One.toOfNat1.{u_2} M₂ inst._@.Mathlib.Algebra.Group.InjSurj.4120732672._hygCtx._hyg.7))) -> (forall (x : M₁) (y : M₁), Eq.{succ u_2} M₂ (f (HMul.hMul.{u_1, u_1, u_1} M₁ M₁ M₁ (instHMul.{u_1} M₁ (MulOne.toMul.{u_1} M₁ (MulOneClass.toMulOne.{u_1} M₁ inst._@.Mathlib.Algebra.Group.InjSurj.4120732672._hygCtx._hyg.10))) x y)) (HMul.hMul.{u_2, u_2, u_2} M₂ M₂ M₂ (instHMul.{u_2} M₂ inst._@.Mathlib.Algebra.Group.InjSurj.4120732672._hygCtx._hyg.4) (f x) (f y))) -> (MulOneClass.{u_2} M₂)
-- (definition body omitted)

-- Stub: this file represents the declaration `Function.Surjective.mulOneClass`.
-- In a full split, the body would be extracted from the environment.
