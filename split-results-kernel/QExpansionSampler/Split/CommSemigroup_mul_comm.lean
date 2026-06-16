import Split.Semigroup_toMul
import Split.HMul_hMul
import Split.CommSemigroup
import Split.CommSemigroup_toSemigroup
import Split.Eq
import Split.instHMul

-- CommSemigroup.mul_comm from environment
-- theorem CommSemigroup.mul_comm : forall {G : Type.{u}} [self : CommSemigroup.{u} G] (a : G) (b : G), Eq.{succ u} G (HMul.hMul.{u, u, u} G G G (instHMul.{u} G (Semigroup.toMul.{u} G (CommSemigroup.toSemigroup.{u} G self))) a b) (HMul.hMul.{u, u, u} G G G (instHMul.{u} G (Semigroup.toMul.{u} G (CommSemigroup.toSemigroup.{u} G self))) b a)

-- Stub: this file represents the declaration `CommSemigroup.mul_comm`.
-- In a full split, the body would be extracted from the environment.
