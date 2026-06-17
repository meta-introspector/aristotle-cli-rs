import Split.Semigroup_toMul
import Split.DivInvMonoid_toInv
import Split.HMul_hMul
import Split.DivisionMonoid
import Split.DivInvMonoid_toMonoid
import Split.DivisionMonoid_toDivInvMonoid
import Split.Inv_inv
import Split.Monoid_toSemigroup
import Split.One_toOfNat1
import Split.Monoid_toOne
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul

-- DivisionMonoid.inv_eq_of_mul from environment
-- theorem DivisionMonoid.inv_eq_of_mul : forall {G : Type.{u}} [self : DivisionMonoid.{u} G] (a : G) (b : G), (Eq.{succ u} G (HMul.hMul.{u, u, u} G G G (instHMul.{u} G (Semigroup.toMul.{u} G (Monoid.toSemigroup.{u} G (DivInvMonoid.toMonoid.{u} G (DivisionMonoid.toDivInvMonoid.{u} G self))))) a b) (OfNat.ofNat.{u} G 1 (One.toOfNat1.{u} G (Monoid.toOne.{u} G (DivInvMonoid.toMonoid.{u} G (DivisionMonoid.toDivInvMonoid.{u} G self)))))) -> (Eq.{succ u} G (Inv.inv.{u} G (DivInvMonoid.toInv.{u} G (DivisionMonoid.toDivInvMonoid.{u} G self)) a) b)

-- Stub: this file represents the declaration `DivisionMonoid.inv_eq_of_mul`.
-- In a full split, the body would be extracted from the environment.
