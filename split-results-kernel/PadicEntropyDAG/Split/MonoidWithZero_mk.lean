import Split.Monoid
import Split.Semigroup_toMul
import Split.HMul_hMul
import Split.MonoidWithZero
import Split.Monoid_toSemigroup
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul
import Split.Zero

-- MonoidWithZero.mk from environment
-- constructor MonoidWithZero.mk : forall {M₀ : Type.{u}} [toMonoid : Monoid.{u} M₀] [toZero : Zero.{u} M₀], (forall (a : M₀), Eq.{succ u} M₀ (HMul.hMul.{u, u, u} M₀ M₀ M₀ (instHMul.{u} M₀ (Semigroup.toMul.{u} M₀ (Monoid.toSemigroup.{u} M₀ toMonoid))) (OfNat.ofNat.{u} M₀ 0 (Zero.toOfNat0.{u} M₀ toZero)) a) (OfNat.ofNat.{u} M₀ 0 (Zero.toOfNat0.{u} M₀ toZero))) -> (forall (a : M₀), Eq.{succ u} M₀ (HMul.hMul.{u, u, u} M₀ M₀ M₀ (instHMul.{u} M₀ (Semigroup.toMul.{u} M₀ (Monoid.toSemigroup.{u} M₀ toMonoid))) a (OfNat.ofNat.{u} M₀ 0 (Zero.toOfNat0.{u} M₀ toZero))) (OfNat.ofNat.{u} M₀ 0 (Zero.toOfNat0.{u} M₀ toZero))) -> (MonoidWithZero.{u} M₀)

-- Stub: this file represents the declaration `MonoidWithZero.mk`.
-- In a full split, the body would be extracted from the environment.
