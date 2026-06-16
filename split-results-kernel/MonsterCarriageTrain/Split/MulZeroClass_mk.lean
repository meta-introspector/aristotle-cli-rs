import Split.HMul_hMul
import Split.Mul
import Split.MulZeroClass
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul
import Split.Zero

-- MulZeroClass.mk from environment
-- constructor MulZeroClass.mk : forall {M₀ : Type.{u}} [toMul : Mul.{u} M₀] [toZero : Zero.{u} M₀], (forall (a : M₀), Eq.{succ u} M₀ (HMul.hMul.{u, u, u} M₀ M₀ M₀ (instHMul.{u} M₀ toMul) (OfNat.ofNat.{u} M₀ 0 (Zero.toOfNat0.{u} M₀ toZero)) a) (OfNat.ofNat.{u} M₀ 0 (Zero.toOfNat0.{u} M₀ toZero))) -> (forall (a : M₀), Eq.{succ u} M₀ (HMul.hMul.{u, u, u} M₀ M₀ M₀ (instHMul.{u} M₀ toMul) a (OfNat.ofNat.{u} M₀ 0 (Zero.toOfNat0.{u} M₀ toZero))) (OfNat.ofNat.{u} M₀ 0 (Zero.toOfNat0.{u} M₀ toZero))) -> (MulZeroClass.{u} M₀)

-- Stub: this file represents the declaration `MulZeroClass.mk`.
-- In a full split, the body would be extracted from the environment.
