import Split.CommMonoidWithZero_toCommMonoid
import Split.Semigroup_toMul
import Split.HMul_hMul
import Split.CommMonoid_toMonoid
import Split.CommMonoidWithZero_toZero
import Split.CommMonoidWithZero
import Split.Monoid_toSemigroup
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul

-- CommMonoidWithZero.zero_mul from environment
-- theorem CommMonoidWithZero.zero_mul : forall {M₀ : Type.{u_2}} [self : CommMonoidWithZero.{u_2} M₀] (a : M₀), Eq.{succ u_2} M₀ (HMul.hMul.{u_2, u_2, u_2} M₀ M₀ M₀ (instHMul.{u_2} M₀ (Semigroup.toMul.{u_2} M₀ (Monoid.toSemigroup.{u_2} M₀ (CommMonoid.toMonoid.{u_2} M₀ (CommMonoidWithZero.toCommMonoid.{u_2} M₀ self))))) (OfNat.ofNat.{u_2} M₀ 0 (Zero.toOfNat0.{u_2} M₀ (CommMonoidWithZero.toZero.{u_2} M₀ self))) a) (OfNat.ofNat.{u_2} M₀ 0 (Zero.toOfNat0.{u_2} M₀ (CommMonoidWithZero.toZero.{u_2} M₀ self)))

-- Stub: this file represents the declaration `CommMonoidWithZero.zero_mul`.
-- In a full split, the body would be extracted from the environment.
