import Split.Semigroup_toMul
import Split.HMul_hMul
import Split.CommMonoid_toMonoid
import Split.CommMonoidWithZero
import Split.Monoid_toSemigroup
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Eq
import Split.CommMonoid
import Split.instHMul
import Split.Zero

-- CommMonoidWithZero.mk from environment
-- constructor CommMonoidWithZero.mk : forall {M₀ : Type.{u_2}} [toCommMonoid : CommMonoid.{u_2} M₀] [toZero : Zero.{u_2} M₀], (forall (a : M₀), Eq.{succ u_2} M₀ (HMul.hMul.{u_2, u_2, u_2} M₀ M₀ M₀ (instHMul.{u_2} M₀ (Semigroup.toMul.{u_2} M₀ (Monoid.toSemigroup.{u_2} M₀ (CommMonoid.toMonoid.{u_2} M₀ toCommMonoid)))) (OfNat.ofNat.{u_2} M₀ 0 (Zero.toOfNat0.{u_2} M₀ toZero)) a) (OfNat.ofNat.{u_2} M₀ 0 (Zero.toOfNat0.{u_2} M₀ toZero))) -> (forall (a : M₀), Eq.{succ u_2} M₀ (HMul.hMul.{u_2, u_2, u_2} M₀ M₀ M₀ (instHMul.{u_2} M₀ (Semigroup.toMul.{u_2} M₀ (Monoid.toSemigroup.{u_2} M₀ (CommMonoid.toMonoid.{u_2} M₀ toCommMonoid)))) a (OfNat.ofNat.{u_2} M₀ 0 (Zero.toOfNat0.{u_2} M₀ toZero))) (OfNat.ofNat.{u_2} M₀ 0 (Zero.toOfNat0.{u_2} M₀ toZero))) -> (CommMonoidWithZero.{u_2} M₀)

-- Stub: this file represents the declaration `CommMonoidWithZero.mk`.
-- In a full split, the body would be extracted from the environment.
