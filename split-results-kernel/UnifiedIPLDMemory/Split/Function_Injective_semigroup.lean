import Split.Semigroup
import Split.Semigroup_toMul
import Split.HMul_hMul
import Split.Semigroup_mk
import Split.Mul
import Split.Function_Injective
import Split.Eq
import Split.instHMul

-- Function.Injective.semigroup from environment
-- def Function.Injective.semigroup : forall {M₁ : Type.{u_1}} {M₂ : Type.{u_2}} [inst._@.Mathlib.Algebra.Group.InjSurj.1657982427._hygCtx._hyg.4 : Mul.{u_1} M₁] [inst._@.Mathlib.Algebra.Group.InjSurj.1657982427._hygCtx._hyg.7 : Semigroup.{u_2} M₂] (f : M₁ -> M₂), (Function.Injective.{succ u_1, succ u_2} M₁ M₂ f) -> (forall (x : M₁) (y : M₁), Eq.{succ u_2} M₂ (f (HMul.hMul.{u_1, u_1, u_1} M₁ M₁ M₁ (instHMul.{u_1} M₁ inst._@.Mathlib.Algebra.Group.InjSurj.1657982427._hygCtx._hyg.4) x y)) (HMul.hMul.{u_2, u_2, u_2} M₂ M₂ M₂ (instHMul.{u_2} M₂ (Semigroup.toMul.{u_2} M₂ inst._@.Mathlib.Algebra.Group.InjSurj.1657982427._hygCtx._hyg.7)) (f x) (f y))) -> (Semigroup.{u_1} M₁)
-- (definition body omitted)

-- Stub: this file represents the declaration `Function.Injective.semigroup`.
-- In a full split, the body would be extracted from the environment.
