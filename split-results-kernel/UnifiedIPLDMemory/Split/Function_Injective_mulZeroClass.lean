import Split.HMul_hMul
import Split.MulZeroClass_toMul
import Split.Mul
import Split.MulZeroClass
import Split.Zero_toOfNat0
import Split.MulZeroClass_mk
import Split.Function_Injective
import Split.OfNat_ofNat
import Split.Eq
import Split.MulZeroClass_toZero
import Split.instHMul
import Split.Zero

-- Function.Injective.mulZeroClass from environment
-- def Function.Injective.mulZeroClass : forall {M₀ : Type.{u_1}} {M₀' : Type.{u_3}} [inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.1411084039._hygCtx._hyg.6 : MulZeroClass.{u_1} M₀] [inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.1411084039._hygCtx._hyg.9 : Mul.{u_3} M₀'] [inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.1411084039._hygCtx._hyg.12 : Zero.{u_3} M₀'] (f : M₀' -> M₀), (Function.Injective.{succ u_3, succ u_1} M₀' M₀ f) -> (Eq.{succ u_1} M₀ (f (OfNat.ofNat.{u_3} M₀' 0 (Zero.toOfNat0.{u_3} M₀' inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.1411084039._hygCtx._hyg.12))) (OfNat.ofNat.{u_1} M₀ 0 (Zero.toOfNat0.{u_1} M₀ (MulZeroClass.toZero.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.1411084039._hygCtx._hyg.6)))) -> (forall (a : M₀') (b : M₀'), Eq.{succ u_1} M₀ (f (HMul.hMul.{u_3, u_3, u_3} M₀' M₀' M₀' (instHMul.{u_3} M₀' inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.1411084039._hygCtx._hyg.9) a b)) (HMul.hMul.{u_1, u_1, u_1} M₀ M₀ M₀ (instHMul.{u_1} M₀ (MulZeroClass.toMul.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.1411084039._hygCtx._hyg.6)) (f a) (f b))) -> (MulZeroClass.{u_3} M₀')
-- (definition body omitted)

-- Stub: this file represents the declaration `Function.Injective.mulZeroClass`.
-- In a full split, the body would be extracted from the environment.
