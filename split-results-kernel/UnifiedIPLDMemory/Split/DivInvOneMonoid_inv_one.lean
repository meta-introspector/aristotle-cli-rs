import Split.DivInvMonoid_toInv
import Split.DivInvOneMonoid_toDivInvMonoid
import Split.DivInvOneMonoid
import Split.DivInvMonoid_toMonoid
import Split.Inv_inv
import Split.One_toOfNat1
import Split.Monoid_toOne
import Split.OfNat_ofNat
import Split.Eq

-- DivInvOneMonoid.inv_one from environment
-- theorem DivInvOneMonoid.inv_one : forall {G : Type.{u_2}} [self : DivInvOneMonoid.{u_2} G], Eq.{succ u_2} G (Inv.inv.{u_2} G (DivInvMonoid.toInv.{u_2} G (DivInvOneMonoid.toDivInvMonoid.{u_2} G self)) (OfNat.ofNat.{u_2} G 1 (One.toOfNat1.{u_2} G (Monoid.toOne.{u_2} G (DivInvMonoid.toMonoid.{u_2} G (DivInvOneMonoid.toDivInvMonoid.{u_2} G self)))))) (OfNat.ofNat.{u_2} G 1 (One.toOfNat1.{u_2} G (Monoid.toOne.{u_2} G (DivInvMonoid.toMonoid.{u_2} G (DivInvOneMonoid.toDivInvMonoid.{u_2} G self)))))

-- Stub: this file represents the declaration `DivInvOneMonoid.inv_one`.
-- In a full split, the body would be extracted from the environment.
