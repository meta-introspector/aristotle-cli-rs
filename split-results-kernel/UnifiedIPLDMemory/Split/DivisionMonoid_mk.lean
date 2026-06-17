import Split.Semigroup_toMul
import Split.DivInvMonoid_toInv
import Split.HMul_hMul
import Split.DivisionMonoid
import Split.DivInvMonoid_toMonoid
import Split.DivInvMonoid
import Split.Inv_inv
import Split.Monoid_toSemigroup
import Split.One_toOfNat1
import Split.Monoid_toOne
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul

-- DivisionMonoid.mk from environment
-- constructor DivisionMonoid.mk : forall {G : Type.{u}} [toDivInvMonoid : DivInvMonoid.{u} G], (forall (x : G), Eq.{succ u} G (Inv.inv.{u} G (DivInvMonoid.toInv.{u} G toDivInvMonoid) (Inv.inv.{u} G (DivInvMonoid.toInv.{u} G toDivInvMonoid) x)) x) -> (forall (a : G) (b : G), Eq.{succ u} G (Inv.inv.{u} G (DivInvMonoid.toInv.{u} G toDivInvMonoid) (HMul.hMul.{u, u, u} G G G (instHMul.{u} G (Semigroup.toMul.{u} G (Monoid.toSemigroup.{u} G (DivInvMonoid.toMonoid.{u} G toDivInvMonoid)))) a b)) (HMul.hMul.{u, u, u} G G G (instHMul.{u} G (Semigroup.toMul.{u} G (Monoid.toSemigroup.{u} G (DivInvMonoid.toMonoid.{u} G toDivInvMonoid)))) (Inv.inv.{u} G (DivInvMonoid.toInv.{u} G toDivInvMonoid) b) (Inv.inv.{u} G (DivInvMonoid.toInv.{u} G toDivInvMonoid) a))) -> (forall (a : G) (b : G), (Eq.{succ u} G (HMul.hMul.{u, u, u} G G G (instHMul.{u} G (Semigroup.toMul.{u} G (Monoid.toSemigroup.{u} G (DivInvMonoid.toMonoid.{u} G toDivInvMonoid)))) a b) (OfNat.ofNat.{u} G 1 (One.toOfNat1.{u} G (Monoid.toOne.{u} G (DivInvMonoid.toMonoid.{u} G toDivInvMonoid))))) -> (Eq.{succ u} G (Inv.inv.{u} G (DivInvMonoid.toInv.{u} G toDivInvMonoid) a) b)) -> (DivisionMonoid.{u} G)

-- Stub: this file represents the declaration `DivisionMonoid.mk`.
-- In a full split, the body would be extracted from the environment.
