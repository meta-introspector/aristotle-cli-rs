import Split.Monoid
import Split.Semigroup_toMul
import Split.HMul_hMul
import Split.Monoid_toSemigroup
import Split.Eq
import Split.CommMonoid
import Split.instHMul

-- CommMonoid.mk from environment
-- constructor CommMonoid.mk : forall {M : Type.{u}} [toMonoid : Monoid.{u} M], (forall (a : M) (b : M), Eq.{succ u} M (HMul.hMul.{u, u, u} M M M (instHMul.{u} M (Semigroup.toMul.{u} M (Monoid.toSemigroup.{u} M toMonoid))) a b) (HMul.hMul.{u, u, u} M M M (instHMul.{u} M (Semigroup.toMul.{u} M (Monoid.toSemigroup.{u} M toMonoid))) b a)) -> (CommMonoid.{u} M)

-- Stub: this file represents the declaration `CommMonoid.mk`.
-- In a full split, the body would be extracted from the environment.
