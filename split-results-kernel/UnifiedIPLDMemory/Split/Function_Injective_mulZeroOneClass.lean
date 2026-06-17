import Split.MulOne_toOne
import Split.One
import Split.HMul_hMul
import Split.MulZeroClass_toMul
import Split.MulZeroClass_zero_mul
import Split.MulOneClass_mul_one
import Split.MulOneClass_one_mul
import Split.Mul
import Split.MulZeroClass
import Split.MulOne_mk
import Split.MulZeroOneClass
import Split.MulZeroClass_mul_zero
import Split.MulZeroOneClass_toMulOneClass
import Split.MulOneClass_toMulOne
import Split.MulOneClass_mk
import Split.Function_Injective_mulOneClass
import Split.One_toOfNat1
import Split.Zero_toOfNat0
import Split.Function_Injective_mulZeroClass
import Split.Function_Injective
import Split.MulZeroOneClass_toMulZeroClass
import Split.MulOneClass
import Split.OfNat_ofNat
import Split.Eq
import Split.MulZeroClass_toZero
import Split.MulZeroOneClass_mk
import Split.instHMul
import Split.Zero

-- Function.Injective.mulZeroOneClass from environment
-- def Function.Injective.mulZeroOneClass : forall {M₀ : Type.{u_1}} {M₀' : Type.{u_3}} [inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.3640769603._hygCtx._hyg.6 : MulZeroOneClass.{u_1} M₀] [inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.3640769603._hygCtx._hyg.9 : Mul.{u_3} M₀'] [inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.3640769603._hygCtx._hyg.12 : Zero.{u_3} M₀'] [inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.3640769603._hygCtx._hyg.15 : One.{u_3} M₀'] (f : M₀' -> M₀), (Function.Injective.{succ u_3, succ u_1} M₀' M₀ f) -> (Eq.{succ u_1} M₀ (f (OfNat.ofNat.{u_3} M₀' 0 (Zero.toOfNat0.{u_3} M₀' inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.3640769603._hygCtx._hyg.12))) (OfNat.ofNat.{u_1} M₀ 0 (Zero.toOfNat0.{u_1} M₀ (MulZeroClass.toZero.{u_1} M₀ (MulZeroOneClass.toMulZeroClass.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.3640769603._hygCtx._hyg.6))))) -> (Eq.{succ u_1} M₀ (f (OfNat.ofNat.{u_3} M₀' 1 (One.toOfNat1.{u_3} M₀' inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.3640769603._hygCtx._hyg.15))) (OfNat.ofNat.{u_1} M₀ 1 (One.toOfNat1.{u_1} M₀ (MulOne.toOne.{u_1} M₀ (MulOneClass.toMulOne.{u_1} M₀ (MulZeroOneClass.toMulOneClass.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.3640769603._hygCtx._hyg.6)))))) -> (forall (a : M₀') (b : M₀'), Eq.{succ u_1} M₀ (f (HMul.hMul.{u_3, u_3, u_3} M₀' M₀' M₀' (instHMul.{u_3} M₀' inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.3640769603._hygCtx._hyg.9) a b)) (HMul.hMul.{u_1, u_1, u_1} M₀ M₀ M₀ (instHMul.{u_1} M₀ (MulZeroClass.toMul.{u_1} M₀ (MulZeroOneClass.toMulZeroClass.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.InjSurj.3640769603._hygCtx._hyg.6))) (f a) (f b))) -> (MulZeroOneClass.{u_3} M₀')
-- (definition body omitted)

-- Stub: this file represents the declaration `Function.Injective.mulZeroOneClass`.
-- In a full split, the body would be extracted from the environment.
