import Split.Semigroup
import Split.Semigroup_toMul
import Split.HMul_hMul
import Split.CommSemigroup
import Split.Eq
import Split.instHMul

-- CommSemigroup.mk from environment
-- constructor CommSemigroup.mk : forall {G : Type.{u}} [toSemigroup : Semigroup.{u} G], (forall (a : G) (b : G), Eq.{succ u} G (HMul.hMul.{u, u, u} G G G (instHMul.{u} G (Semigroup.toMul.{u} G toSemigroup)) a b) (HMul.hMul.{u, u, u} G G G (instHMul.{u} G (Semigroup.toMul.{u} G toSemigroup)) b a)) -> (CommSemigroup.{u} G)

-- Stub: this file represents the declaration `CommSemigroup.mk`.
-- In a full split, the body would be extracted from the environment.
