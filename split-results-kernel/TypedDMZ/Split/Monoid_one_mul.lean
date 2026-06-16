import Split.Monoid
import Split.Semigroup_toMul
import Split.HMul_hMul
import Split.Monoid_toSemigroup
import Split.One_toOfNat1
import Split.Monoid_toOne
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul

-- Monoid.one_mul from environment
-- theorem Monoid.one_mul : forall {M : Type.{u}} [self : Monoid.{u} M] (a : M), Eq.{succ u} M (HMul.hMul.{u, u, u} M M M (instHMul.{u} M (Semigroup.toMul.{u} M (Monoid.toSemigroup.{u} M self))) (OfNat.ofNat.{u} M 1 (One.toOfNat1.{u} M (Monoid.toOne.{u} M self))) a) a

-- Stub: this file represents the declaration `Monoid.one_mul`.
-- In a full split, the body would be extracted from the environment.
