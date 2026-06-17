import Split.DivInvMonoid_toMonoid
import Split.Int
import Split.DivInvMonoid_zpow
import Split.DivInvMonoid
import Split.instOfNat
import Split.One_toOfNat1
import Split.Monoid_toOne
import Split.OfNat_ofNat
import Split.Eq

-- DivInvMonoid.zpow_zero' from environment
-- theorem DivInvMonoid.zpow_zero' : forall {G : Type.{u}} [self : DivInvMonoid.{u} G] (a : G), Eq.{succ u} G (DivInvMonoid.zpow.{u} G self (OfNat.ofNat.{0} Int 0 (instOfNat 0)) a) (OfNat.ofNat.{u} G 1 (One.toOfNat1.{u} G (Monoid.toOne.{u} G (DivInvMonoid.toMonoid.{u} G self))))

-- Stub: this file represents the declaration `DivInvMonoid.zpow_zero'`.
-- In a full split, the body would be extracted from the environment.
