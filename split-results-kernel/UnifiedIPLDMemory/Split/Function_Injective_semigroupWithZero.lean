import Split.Semigroup
import Split.SemigroupWithZero
import Split.Semigroup_mul_assoc
import Split.HMul_hMul
import Split.MulZeroClass_toMul
import Split.MulZeroClass_zero_mul
import Split.SemigroupWithZero_toMulZeroClass
import Split.Semigroup_mk
import Split.Mul
import Split.MulZeroClass
import Split.SemigroupWithZero_toSemigroup
import Split.MulZeroClass_mul_zero
import Split.SemigroupWithZero_mk
import Split.Function_Injective_semigroup
import Split.Zero_toOfNat0
import Split.Function_Injective_mulZeroClass
import Split.Function_Injective
import Split.OfNat_ofNat
import Split.Eq
import Split.MulZeroClass_toZero
import Split.instHMul
import Split.Zero

-- Function.Injective.semigroupWithZero from environment
-- def Function.Injective.semigroupWithZero : forall {M₀ : Type.{u_1}} {M₀' : Type.{u_3}} [inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.2657023213._hygCtx._hyg.6 : Zero.{u_3} M₀'] [inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.2657023213._hygCtx._hyg.9 : Mul.{u_3} M₀'] [inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.2657023213._hygCtx._hyg.12 : SemigroupWithZero.{u_1} M₀] (f : M₀' -> M₀), (Function.Injective.{succ u_3, succ u_1} M₀' M₀ f) -> (Eq.{succ u_1} M₀ (f (OfNat.ofNat.{u_3} M₀' 0 (Zero.toOfNat0.{u_3} M₀' inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.2657023213._hygCtx._hyg.6))) (OfNat.ofNat.{u_1} M₀ 0 (Zero.toOfNat0.{u_1} M₀ (MulZeroClass.toZero.{u_1} M₀ (SemigroupWithZero.toMulZeroClass.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.2657023213._hygCtx._hyg.12))))) -> (forall (x : M₀') (y : M₀'), Eq.{succ u_1} M₀ (f (HMul.hMul.{u_3, u_3, u_3} M₀' M₀' M₀' (instHMul.{u_3} M₀' inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.2657023213._hygCtx._hyg.9) x y)) (HMul.hMul.{u_1, u_1, u_1} M₀ M₀ M₀ (instHMul.{u_1} M₀ (MulZeroClass.toMul.{u_1} M₀ (SemigroupWithZero.toMulZeroClass.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.2657023213._hygCtx._hyg.12))) (f x) (f y))) -> (SemigroupWithZero.{u_3} M₀')
-- (definition body omitted)

-- Stub: this file represents the declaration `Function.Injective.semigroupWithZero`.
-- In a full split, the body would be extracted from the environment.
