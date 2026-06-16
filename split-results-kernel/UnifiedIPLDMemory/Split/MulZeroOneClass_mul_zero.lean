import Split.HMul_hMul
import Split.MulOne_toMul
import Split.MulZeroOneClass
import Split.MulZeroOneClass_toMulOneClass
import Split.MulOneClass_toMulOne
import Split.MulZeroOneClass_toZero
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul

-- MulZeroOneClass.mul_zero from environment
-- theorem MulZeroOneClass.mul_zero : forall {M₀ : Type.{u}} [self : MulZeroOneClass.{u} M₀] (a : M₀), Eq.{succ u} M₀ (HMul.hMul.{u, u, u} M₀ M₀ M₀ (instHMul.{u} M₀ (MulOne.toMul.{u} M₀ (MulOneClass.toMulOne.{u} M₀ (MulZeroOneClass.toMulOneClass.{u} M₀ self)))) a (OfNat.ofNat.{u} M₀ 0 (Zero.toOfNat0.{u} M₀ (MulZeroOneClass.toZero.{u} M₀ self)))) (OfNat.ofNat.{u} M₀ 0 (Zero.toOfNat0.{u} M₀ (MulZeroOneClass.toZero.{u} M₀ self)))

-- Stub: this file represents the declaration `MulZeroOneClass.mul_zero`.
-- In a full split, the body would be extracted from the environment.
