import Split.Semigroup_toMul
import Split.DivInvMonoid_toInv
import Split.HMul_hMul
import Split.DivisionMonoid
import Split.DivInvMonoid_toMonoid
import Split.DivisionMonoid_toDivInvMonoid
import Split.Inv_inv
import Split.Monoid_toSemigroup
import Split.Eq
import Split.instHMul

-- DivisionMonoid.mul_inv_rev from environment
-- theorem DivisionMonoid.mul_inv_rev : forall {G : Type.{u}} [self : DivisionMonoid.{u} G] (a : G) (b : G), Eq.{succ u} G (Inv.inv.{u} G (DivInvMonoid.toInv.{u} G (DivisionMonoid.toDivInvMonoid.{u} G self)) (HMul.hMul.{u, u, u} G G G (instHMul.{u} G (Semigroup.toMul.{u} G (Monoid.toSemigroup.{u} G (DivInvMonoid.toMonoid.{u} G (DivisionMonoid.toDivInvMonoid.{u} G self))))) a b)) (HMul.hMul.{u, u, u} G G G (instHMul.{u} G (Semigroup.toMul.{u} G (Monoid.toSemigroup.{u} G (DivInvMonoid.toMonoid.{u} G (DivisionMonoid.toDivInvMonoid.{u} G self))))) (Inv.inv.{u} G (DivInvMonoid.toInv.{u} G (DivisionMonoid.toDivInvMonoid.{u} G self)) b) (Inv.inv.{u} G (DivInvMonoid.toInv.{u} G (DivisionMonoid.toDivInvMonoid.{u} G self)) a))

-- Stub: this file represents the declaration `DivisionMonoid.mul_inv_rev`.
-- In a full split, the body would be extracted from the environment.
