import Split.HMul_hMul
import Split.MulOne_toMul
import Split.MulZeroOneClass
import Split.MulOneClass_toMulOne
import Split.Zero_toOfNat0
import Split.MulOneClass
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul
import Split.Zero

-- MulZeroOneClass.mk from environment
-- constructor MulZeroOneClass.mk : forall {M₀ : Type.{u}} [toMulOneClass : MulOneClass.{u} M₀] [toZero : Zero.{u} M₀], (forall (a : M₀), Eq.{succ u} M₀ (HMul.hMul.{u, u, u} M₀ M₀ M₀ (instHMul.{u} M₀ (MulOne.toMul.{u} M₀ (MulOneClass.toMulOne.{u} M₀ toMulOneClass))) (OfNat.ofNat.{u} M₀ 0 (Zero.toOfNat0.{u} M₀ toZero)) a) (OfNat.ofNat.{u} M₀ 0 (Zero.toOfNat0.{u} M₀ toZero))) -> (forall (a : M₀), Eq.{succ u} M₀ (HMul.hMul.{u, u, u} M₀ M₀ M₀ (instHMul.{u} M₀ (MulOne.toMul.{u} M₀ (MulOneClass.toMulOne.{u} M₀ toMulOneClass))) a (OfNat.ofNat.{u} M₀ 0 (Zero.toOfNat0.{u} M₀ toZero))) (OfNat.ofNat.{u} M₀ 0 (Zero.toOfNat0.{u} M₀ toZero))) -> (MulZeroOneClass.{u} M₀)

-- Stub: this file represents the declaration `MulZeroOneClass.mk`.
-- In a full split, the body would be extracted from the environment.
