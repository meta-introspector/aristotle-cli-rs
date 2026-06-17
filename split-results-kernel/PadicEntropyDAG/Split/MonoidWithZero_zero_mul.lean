import Split.Semigroup_toMul
import Split.HMul_hMul
import Split.MonoidWithZero
import Split.MonoidWithZero_toZero
import Split.Monoid_toSemigroup
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Eq
import Split.MonoidWithZero_toMonoid
import Split.instHMul

-- MonoidWithZero.zero_mul from environment
-- theorem MonoidWithZero.zero_mul : forall {M₀ : Type.{u}} [self : MonoidWithZero.{u} M₀] (a : M₀), Eq.{succ u} M₀ (HMul.hMul.{u, u, u} M₀ M₀ M₀ (instHMul.{u} M₀ (Semigroup.toMul.{u} M₀ (Monoid.toSemigroup.{u} M₀ (MonoidWithZero.toMonoid.{u} M₀ self)))) (OfNat.ofNat.{u} M₀ 0 (Zero.toOfNat0.{u} M₀ (MonoidWithZero.toZero.{u} M₀ self))) a) (OfNat.ofNat.{u} M₀ 0 (Zero.toOfNat0.{u} M₀ (MonoidWithZero.toZero.{u} M₀ self)))

-- Stub: this file represents the declaration `MonoidWithZero.zero_mul`.
-- In a full split, the body would be extracted from the environment.
