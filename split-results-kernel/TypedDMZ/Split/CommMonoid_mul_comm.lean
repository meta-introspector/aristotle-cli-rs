import Split.Semigroup_toMul
import Split.HMul_hMul
import Split.CommMonoid_toMonoid
import Split.Monoid_toSemigroup
import Split.Eq
import Split.CommMonoid
import Split.instHMul

-- CommMonoid.mul_comm from environment
-- theorem CommMonoid.mul_comm : forall {M : Type.{u}} [self : CommMonoid.{u} M] (a : M) (b : M), Eq.{succ u} M (HMul.hMul.{u, u, u} M M M (instHMul.{u} M (Semigroup.toMul.{u} M (Monoid.toSemigroup.{u} M (CommMonoid.toMonoid.{u} M self)))) a b) (HMul.hMul.{u, u, u} M M M (instHMul.{u} M (Semigroup.toMul.{u} M (Monoid.toSemigroup.{u} M (CommMonoid.toMonoid.{u} M self)))) b a)

-- Stub: this file represents the declaration `CommMonoid.mul_comm`.
-- In a full split, the body would be extracted from the environment.
