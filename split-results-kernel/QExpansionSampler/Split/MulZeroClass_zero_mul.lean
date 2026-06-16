import Split.HMul_hMul
import Split.MulZeroClass_toMul
import Split.MulZeroClass
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Eq
import Split.MulZeroClass_toZero
import Split.instHMul

-- MulZeroClass.zero_mul from environment
-- theorem MulZeroClass.zero_mul : forall {M₀ : Type.{u}} [self : MulZeroClass.{u} M₀] (a : M₀), Eq.{succ u} M₀ (HMul.hMul.{u, u, u} M₀ M₀ M₀ (instHMul.{u} M₀ (MulZeroClass.toMul.{u} M₀ self)) (OfNat.ofNat.{u} M₀ 0 (Zero.toOfNat0.{u} M₀ (MulZeroClass.toZero.{u} M₀ self))) a) (OfNat.ofNat.{u} M₀ 0 (Zero.toOfNat0.{u} M₀ (MulZeroClass.toZero.{u} M₀ self)))

-- Stub: this file represents the declaration `MulZeroClass.zero_mul`.
-- In a full split, the body would be extracted from the environment.
