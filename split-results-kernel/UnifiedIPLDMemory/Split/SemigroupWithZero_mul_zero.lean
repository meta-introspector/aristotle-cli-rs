import Split.SemigroupWithZero
import Split.Semigroup_toMul
import Split.HMul_hMul
import Split.SemigroupWithZero_toSemigroup
import Split.SemigroupWithZero_toZero
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul

-- SemigroupWithZero.mul_zero from environment
-- theorem SemigroupWithZero.mul_zero : forall {S₀ : Type.{u}} [self : SemigroupWithZero.{u} S₀] (a : S₀), Eq.{succ u} S₀ (HMul.hMul.{u, u, u} S₀ S₀ S₀ (instHMul.{u} S₀ (Semigroup.toMul.{u} S₀ (SemigroupWithZero.toSemigroup.{u} S₀ self))) a (OfNat.ofNat.{u} S₀ 0 (Zero.toOfNat0.{u} S₀ (SemigroupWithZero.toZero.{u} S₀ self)))) (OfNat.ofNat.{u} S₀ 0 (Zero.toOfNat0.{u} S₀ (SemigroupWithZero.toZero.{u} S₀ self)))

-- Stub: this file represents the declaration `SemigroupWithZero.mul_zero`.
-- In a full split, the body would be extracted from the environment.
