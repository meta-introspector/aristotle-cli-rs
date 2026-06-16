import Split.Semigroup_toMul
import Split.HMul_hMul
import Split.DivisionCommMonoid
import Split.DivisionMonoid
import Split.DivInvMonoid_toMonoid
import Split.DivisionMonoid_toDivInvMonoid
import Split.Monoid_toSemigroup
import Split.Eq
import Split.instHMul

-- DivisionCommMonoid.mk from environment
-- constructor DivisionCommMonoid.mk : forall {G : Type.{u}} [toDivisionMonoid : DivisionMonoid.{u} G], (forall (a : G) (b : G), Eq.{succ u} G (HMul.hMul.{u, u, u} G G G (instHMul.{u} G (Semigroup.toMul.{u} G (Monoid.toSemigroup.{u} G (DivInvMonoid.toMonoid.{u} G (DivisionMonoid.toDivInvMonoid.{u} G toDivisionMonoid))))) a b) (HMul.hMul.{u, u, u} G G G (instHMul.{u} G (Semigroup.toMul.{u} G (Monoid.toSemigroup.{u} G (DivInvMonoid.toMonoid.{u} G (DivisionMonoid.toDivInvMonoid.{u} G toDivisionMonoid))))) b a)) -> (DivisionCommMonoid.{u} G)

-- Stub: this file represents the declaration `DivisionCommMonoid.mk`.
-- In a full split, the body would be extracted from the environment.
