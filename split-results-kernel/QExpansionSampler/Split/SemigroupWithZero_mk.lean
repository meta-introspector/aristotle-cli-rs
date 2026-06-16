import Split.Semigroup
import Split.SemigroupWithZero
import Split.Semigroup_toMul
import Split.HMul_hMul
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul
import Split.Zero

-- SemigroupWithZero.mk from environment
-- constructor SemigroupWithZero.mk : forall {S₀ : Type.{u}} [toSemigroup : Semigroup.{u} S₀] [toZero : Zero.{u} S₀], (forall (a : S₀), Eq.{succ u} S₀ (HMul.hMul.{u, u, u} S₀ S₀ S₀ (instHMul.{u} S₀ (Semigroup.toMul.{u} S₀ toSemigroup)) (OfNat.ofNat.{u} S₀ 0 (Zero.toOfNat0.{u} S₀ toZero)) a) (OfNat.ofNat.{u} S₀ 0 (Zero.toOfNat0.{u} S₀ toZero))) -> (forall (a : S₀), Eq.{succ u} S₀ (HMul.hMul.{u, u, u} S₀ S₀ S₀ (instHMul.{u} S₀ (Semigroup.toMul.{u} S₀ toSemigroup)) a (OfNat.ofNat.{u} S₀ 0 (Zero.toOfNat0.{u} S₀ toZero))) (OfNat.ofNat.{u} S₀ 0 (Zero.toOfNat0.{u} S₀ toZero))) -> (SemigroupWithZero.{u} S₀)

-- Stub: this file represents the declaration `SemigroupWithZero.mk`.
-- In a full split, the body would be extracted from the environment.
